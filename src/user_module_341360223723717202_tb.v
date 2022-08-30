`timescale 1ns / 1ps
//`include "user_module_341360223723717202.v"

module user_module_341360223723717202_tb;

reg [7:0] io_in;
wire [7:0] io_out;

user_module_341360223723717202 m (.io_in(io_in), .io_out(io_out));

initial begin
  $dumpfile("user_module_341360223723717202_tb.vcd");
  $dumpvars(0, user_module_341360223723717202_tb);
end

initial begin
   #8000;
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
  // reset
  #20
  $display("RESET");
  io_in[1] = 1;
  #(CLK_HALF_PERIOD);
  io_in[1] = 0;
end

always begin
  // external memory
  //case(io_out[3:0])
  case(io_out[5:0])
    0: io_in[7:2] <= 1; // a = a + b
    1: io_in[7:2] <= 2; // swap a,b
    2: io_in[7:2] <= 4; // jmp if a == 0
    3: io_in[7:2] <= 0; // ... to address
    4: io_in[7:2] <= 5; // read immediate into a
    5: io_in[7:2] <= 63;// ...
    6: io_in[7:2] <= 3; // jmp
    7: io_in[7:2] <= 6; // ... to address
    default: io_in[7:4] <= 15;
  endcase
  #1;
end

initial begin
  $monitor(
    "a",m.reg_a,"  ",
    "b",m.reg_b,"  ",
    "pc",m.pc,"  ",
    "micro",m.micro_pc,"  ",
    "instr",m.instr,"  ",
    ""
  );
end

endmodule
