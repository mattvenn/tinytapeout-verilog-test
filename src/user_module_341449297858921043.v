`default_nettype none

//  Top level io for this module should stay the same to fit into the scan_wrapper.
//  The pin connections within the user_module are up to you,
//  although (if one is present) it is recommended to place a clock on io_in[0].
//  This allows use of the internal clock divider if you wish.
module user_module_341449297858921043(
  input [7:0] io_in, 
  output [7:0] io_out
);

  wire pdm_out;

  assign io_out[0] = pdm_out;
  assign io_out[1] = ~pdm_out;

  anfsqrt_sqrt_341449297858921043 sqrt_core(
    .clk(io_in[0]),
    .query(io_in[7:1]),
    .result(io_out[6:0])
  );

endmodule

//  Any submodules should be included in this file,
//  so they are copied into the main TinyTapeout repo.
//  Appending your ID to any submodules you create 
//  ensures there are no clashes in full-chip simulation.


// SQRT Iteration Unit
// Copyright (C) 2022 Davit Margarian

module anfsqrt_sqrtiu_341449297858921043 (
    input [6:0] prev_att,
    input [6:0] prev_eps,
    input [6:0] prev_res,

    output [6:0] this_att,
    output [6:0] this_eps,
    output [6:0] this_res
);

    assign this_att = {1'b0, prev_att[6:1]};

	wire [6:0] this_delta_term1_half;
	wire [6:0] this_delta;
	reg [2:0] this_att_msb;
	wire [3:0] this_att_sq_exp;
	wire [6:0] this_att_sq;

    assign this_att_sq_exp = {this_att_msb, 1'b0};
    assign this_att_sq = 7'b1 << this_att_sq_exp;

	assign this_delta_term1_half = prev_res << this_att_msb;
	assign this_delta = {this_delta_term1_half[5:0], 1'b0} + this_att_sq;

	wire cond_met;
	assign cond_met = this_delta <= prev_eps;
	assign this_eps = cond_met ? prev_eps - this_delta : prev_eps; 
	assign this_res = cond_met ? prev_res | this_att : prev_res; 

    integer msb_idx;
    always @* begin
        this_att_msb = 0;

        for (msb_idx=0; msb_idx < 8; msb_idx++) begin
			if(this_att == (1 << msb_idx))
                this_att_msb = msb_idx[2:0];
        end

    end

endmodule

// SQRT Control Logic
// Copyright (C) 2022 Davit Margarian

module anfsqrt_sqrt_341449297858921043(
	input clk,
	input [6:0] query,
	output reg [6:0] result
);

	reg [6:0] att;
	reg [6:0] eps;
	reg [6:0] res;

	wire [6:0] att_next;
	wire [6:0] res_next;
	wire [6:0] eps_next;

	anfsqrt_sqrtiu iterator(.prev_att(att),
						.prev_eps(eps), 
						.prev_res(res),
						.this_att(att_next),
						.this_eps(eps_next),
						.this_res(res_next)
						);

	reg [2:0] iteration;
	
	always @(posedge clk) begin
		if (iteration != 7) begin
				att <= att_next;
				eps <= eps_next;
				res <= res_next;
				iteration <= iteration + 1;
			end else begin
				result <= res;
				eps <= query;
				att <= 1 << 4;
				res <= 0;
				iteration <= 0;
			end
	end

endmodule