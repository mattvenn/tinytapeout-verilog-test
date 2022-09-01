`default_nettype none

// Keep I/O fixed for TinyTapeout
module user_module_341457494561784402(
    input  wire [7:0] io_in,
    output wire [7:0] io_out
);
/*
 * Local signals
 */
    // Used as a clock.
    wire clk;

    // Used as a synchronous reset.
    wire rst;

    wire [15:0] io_value1;
    wire [15:0] io_value2;
    wire io_loadingValues;
    wire io_outputValid;
    wire [15:0] io_outputGCD;


    
/*
 * Logic
 */
    // Using io_in[0] as clk.
    assign clk = io_in[0];

    // Using io_in[1] as rst.
    assign rst = io_in[1];

    assign io_loadingValues = io_in[2];
    assign io_value1 = {13'b0,io_in[4:3]};
    assign io_value2 = {13'b0,io_in[6:5]};

    assign io_out = {io_outputValid, io_outputGCD[6:0]} ;

    gcd GCD(
        .clock(clk),
        .reset(rst),
        .io_value1(io_value1),
        .io_value2(io_value2),
        .io_loadingValues(io_loadingValues),
        .io_outputGCD(io_outputGCD),
        .io_outputValid(io_outputValid)
    );

endmodule


