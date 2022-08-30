`default_nettype none

//  Top level io for this module should stay the same to fit into the scan_wrapper.
//  The pin connections within the user_module are up to you,
//  although (if one is present) it is recommended to place a clock on io_in[0].
//  This allows use of the internal clock divider if you wish.
module user_module_341446083683025490(
  input  wire [7:0] io_in, 
  output wire [7:0] io_out
);




endmodule

//  Any submodules should be included in this file,
//  so they are copied into the main TinyTapeout repo.
//  Appending your ID to any submodules you create 
//  ensures there are no clashes in full-chip simulation.

module top_341446083683025490
    (
    input  wire       i_clk,
    input  wire       i_rst,
      
    input  wire       i_roll,
       
    input  wire       i_load,
    input  wire [2:0] i_seed,

    output wire [7:0] o_led
    );

    reg lfsr_en;

    lfsr_341446083683025490 lfsr_i (
        .i_clk  (i_clk),
        .i_rst  (i_rst),
        .i_en   (lfsr_en),
        //
        .i_load (i_load),
        .i_seed (i_seed),
        //
        .o_lfsr ()
    );

endmodule

module lfsr_341446083683025490
    (
    input  wire       i_clk,
    input  wire       i_rst,
    input  wire       i_en,

    input  wire       i_load,
    input  wire [2:0] i_seed,
    
    output reg  [2:0] o_lfsr
    );

    always@(posedge i_clk) begin 
        if(i_rst) begin 
            o_lfsr <= 0;
        end 
        else if(i_en) begin 
            if(i_load) begin 
                o_lfsr <= i_seed;
            end 
            else begin 
                o_lfsr[0] <= o_lfsr[1] ^ o_lfsr[2];
                o_lfsr[1] <= o_lfsr[0];
                o_lfsr[2] <= o_lfsr[1];
            end 
        end 
    end 

endmodule
