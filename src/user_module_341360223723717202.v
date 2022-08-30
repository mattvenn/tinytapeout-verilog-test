`default_nettype none

// Keep I/O fixed for TinyTapeout
module user_module_341360223723717202(
  input wire[7:0] io_in, 
  output wire[7:0] io_out
);
  // using io_in[0] as clk, io_in[1] as reset
  wire clk;
  assign clk = io_in[0];
  wire reset;
  assign reset = io_in[1];
  wire[3:0] mem_in;
  assign mem_in = io_in[7:4];

  reg[3:0] reg_a;
  reg[3:0] reg_b;
  reg[3:0] pc;
  reg[1:0] micro_pc;
  reg[3:0] instr;
  reg[3:0] mem_request;

  assign io_out = { reg_a, mem_request };

  always @(posedge clk) begin
    if (reset) begin
      reg_a <= 1;
      reg_b <= 1;
      pc <= 0;
      micro_pc <= 0;
      instr <= 0;
      mem_request <= 0;
    end else begin
      micro_pc <= micro_pc + 1;
      if (micro_pc == 0) begin
        mem_request <= pc;
        pc <= pc + 1;
      end else if (micro_pc == 1) begin
        instr <= mem_in;
      end else if (micro_pc == 2) begin
        if (instr == 1) reg_a <= reg_a + reg_b;
        else if (instr == 2) begin reg_a <= reg_b; reg_b <= reg_a; end
        else if (instr == 3 || instr == 4) begin mem_request <= pc; end
      end else if (micro_pc == 3) begin
        if (instr == 3) begin pc <= mem_in; end
        else if (instr == 4 && reg_a != 0) begin pc <= mem_in; end
      end
    end
  end

endmodule
