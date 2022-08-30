`timescale 1ns / 1ps
//`include "user_module_341432284947153491.v"

module user_module_341432284947153491_tb;

wire [7:0] io_in;
wire [7:0] io_out;

reg clk, reset, sclk, ce, sin, in0, in1, in2;
assign io_in = {in2, in1, in0, sin, ce, sclk, reset, clk};

wire sout;
wire [6:0] out;
assign { sout, out } = io_out;

user_module_341432284947153491 UUT (.io_in(io_in), .io_out(io_out));

initial begin
  $dumpfile("user_module_341432284947153491_tb.vcd");
  $dumpvars(0, user_module_341432284947153491_tb);
end

initial begin
   #100_000_000; // Wait a long time in simulation units (adjust as needed).
   $display("Caught by trap");
   $finish;
 end

parameter CLK_HALF_PERIOD = 5;
parameter TCLK = 2*CLK_HALF_PERIOD;
always begin
    clk = 1'b1;
    #(CLK_HALF_PERIOD);
    clk = 1'b0;
    #(CLK_HALF_PERIOD);
end

initial 
begin
    #30
    reset = 1;
    #(3*TCLK);
    reset = 0;
end

parameter SCLK_HALF_PERIOD = 10;
parameter STCLK = 2*CLK_HALF_PERIOD;

initial begin
	ce = 1;
	sclk = 1;
	in0 = 1;
	in1 = 0;
	in2 = 1;
	sin = 0;
	#60
	ce = 0;

	// 0
	sclk = 0;
	sin = 1;
	#(SCLK_HALF_PERIOD);
	sclk = 1;
	// sout should be 1
	#(SCLK_HALF_PERIOD);

	// 1
	sin = 0;
	sclk = 0;
	#(SCLK_HALF_PERIOD);
	sclk = 1;
	// sout should be 0
	#(SCLK_HALF_PERIOD);

	// 2
	sin = 0;
	sclk = 0;
	#(SCLK_HALF_PERIOD);
	sclk = 1;
	// sout should be 0
	#(SCLK_HALF_PERIOD);

	// 3
	sin = 1;
	sclk = 0;
	#(SCLK_HALF_PERIOD);
	sclk = 1;
	// sout should be 0
	#(SCLK_HALF_PERIOD);

	// 4
	sin = 0;
	sclk = 0;
	#(SCLK_HALF_PERIOD);
	sclk = 1;
	// sout should be 0
	#(SCLK_HALF_PERIOD);

	// 5
	sin = 1;
	sclk = 0;
	#(SCLK_HALF_PERIOD);
	sclk = 1;
	// sout should be 0
	#(SCLK_HALF_PERIOD);

	// 6
	sin = 1;
	sclk = 0;
	#(SCLK_HALF_PERIOD);
	sclk = 1;
	// sout should be 0
	#(SCLK_HALF_PERIOD);

	// 7
	sin = 0;
	sclk = 0;
	#(SCLK_HALF_PERIOD);
	sclk = 1;
	// sout should be 0
	#(SCLK_HALF_PERIOD);

	#(2*STCLK);
	ce = 1;
	#(2*STCLK);

	$finish;
end

endmodule
