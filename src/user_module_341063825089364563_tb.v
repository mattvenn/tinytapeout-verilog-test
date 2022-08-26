`timescale 1ns / 1ps
//`include "user_module_341063825089364563.v"

module user_module_341063825089364563_tb;

reg [7:0] io_in;
wire [7:0] io_out;
wire [2:0] fn;
`define speed io_in[4:2]
`define direction io_in[7]

user_module_341063825089364563 UUT (.io_in(io_in), .io_out(io_out));

initial begin
  $dumpfile("user_module_341063825089364563_tb.vcd");
  $dumpvars(0, user_module_341063825089364563_tb);
end

initial begin
   #100_000; // Wait a long time in simulation units (adjust as needed).
   $display("Caught by trap");
   $finish;
 end

parameter CLK_HALF_PERIOD = 5;
always begin
  io_in[0] = 1'b1;
  #(CLK_HALF_PERIOD);
  io_in[0] = 1'b0;
  #(CLK_HALF_PERIOD);
end

initial
begin
  #20
  `speed = 4'b0000;
  `direction = 1'b0;
	io_in[1] = 1;
	#(CLK_HALF_PERIOD);
	io_in[1] = 0;
  #100
  `speed = 4'b1111;
  #100
  `speed = 4'b0011;
  #100
  `direction = 1'b1;
end

endmodule
