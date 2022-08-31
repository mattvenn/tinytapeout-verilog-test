`timescale 1ns / 1ps
// `include "user_module_341464767397888596.v"

module user_module_341464767397888596_tb;

wire [7:0] io_in;
wire [7:0] io_out;

user_module_341464767397888596 UUT (.io_in(io_in), .io_out(io_out));

initial begin
  $dumpfile("user_module_341464767397888596_tb.vcd");
  $dumpvars(0, user_module_341464767397888596_tb);
end

initial begin
   #100_000_000; // Wait a long time in simulation units (adjust as needed).
   $display("Caught by trap");
   $finish;
 end

  reg [2:0] A;
  reg [2:0] B;
  assign io_in[3:1] = A;
  assign io_in[6:4] = B;

initial begin
  A = 0;B = 0; #(5);
  A = 1;B = 0; #(5);
  A = 2;B = 0; #(5);
  A = 3;B = 0; #(5);
  A = 4;B = 0; #(5);
  A = 5;B = 0; #(5);
  A = 6;B = 0; #(5);
  A = 7;B = 0; #(5);

  A = 0;B = 0; #(5);
  A = 0;B = 1; #(5);
  A = 0;B = 2; #(5);
  A = 0;B = 3; #(5);
  A = 0;B = 4; #(5);
  A = 0;B = 5; #(5);
  A = 0;B = 6; #(5);
  A = 0;B = 7; #(5);
end


endmodule
