`timescale 1ns / 1ps

module user_module_user_module_341449297858921043_tb;

wire [7:0] io_in;
wire [7:0] io_out;

reg clk;
reg [6:0] query;

assign io_in = {query, clk};

user_module_341449297858921043 UUT (.io_in(io_in), .io_out(io_out));

initial begin
  $dumpfile("user_module_341449297858921043_tb.vcd");
  $dumpvars(0);
end

initial begin
   #1000_000_000; // Wait a long time in simulation units (adjust as needed).
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

integer q;

initial begin

    for (q=0; q<128; q++) begin
      query = q;
      #(CLK_HALF_PERIOD);
      #(64*TCLK);
    end
    $finish;
end

endmodule
