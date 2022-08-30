`timescale 1ns / 1ps
//`include "user_module_341457971277988435.v"

module user_module_341457971277988435_tb;

wire [7:0] io_in;
wire [7:0] io_out;

reg clk, reset;

assign io_in = {reset, clk};

user_module_341457971277988435 UUT (.io_in(io_in), .io_out(io_out));

initial begin
  $dumpfile("user_module_341457971277988435_tb.vcd");
  $dumpvars(0, user_module_341457971277988435_tb);
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
    #20
    reset = 1;
    #(TCLK);
    reset = 0;
end

initial begin
    #(200*TCLK);
    $finish;
end

endmodule
