`timescale 1ns / 1ps
//`include "user_module_341431502448362067.v"

module user_module_341431502448362067_tb;

wire [7:0] io_in;
wire [7:0] io_out;

reg [4:0] op;
reg clk, rstn, en;

assign io_in = {op, a, b, rstn, clk};

user_module_341431502448362067 UUT (.io_in(io_in), .io_out(io_out));

initial begin
  $dumpfile("user_module_341431502448362067_tb.vcd");
  $dumpvars(0, user_module_341431502448362067_tb);
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
    #(TCLK);
    rstn <= 0;
    #(TCLK);
    rstn <= 1;
end

initial begin
    reg [8:0] ap;
    reg [8:0] bp;
    reg [8:0] op;
    ap = $random;
    bp = $random;
    en = 1;
    op = add;
    for (int i = 0; i < 8; i = i + 1) begin
        #(TCLK)
        a[i] = ap[i];
        b[i] = bp[i];
        op[i] = io_out[i];
    end

    #(TCLK)
    rstn = 1;
    en = 0;
    $finish;
end

endmodule
