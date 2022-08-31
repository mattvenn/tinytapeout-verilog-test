`default_nettype none

//  Top level io for this module should stay the same to fit into the scan_wrapper.
//  The pin connections within the user_module are up to you,
//  although (if one is present) it is recommended to place a clock on io_in[0].
//  This allows use of the internal clock divider if you wish.
module user_module_341431502448362067(
    input [7:0] io_in,
    output [7:0] io_out
);

sreg_341431502448362067 #(.MSB(8)) sreg(
    .d(io_in[3]),
    .en(io_in[2]),
    .rstn(io_in[1]),
    .clk(io_in[0]),
    .out(io_out[7:0])
);

endmodule

module sreg_341431502448362067 #(parameter MSB = 8) (
    input d,
    input clk,
    input en,
    input rstn,
    output reg [MSB-1:0] out
);

always @ (posedge clk) begin
    if (!rstn)
        out <= 0;
    else begin
        if (en)
            out <= {d, out[MSB-1:1]};
        else
            out <= out;
    end
end

endmodule
