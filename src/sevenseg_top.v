`default_nettype none
//`include "user_module_341063825089364563.v"

/*
import math
def fn():
    source = 12_000_000
    target = float(input('Target frequency: '))
    divider = math.floor(source / target)
    width =  math.ceil(math.log2(divider))
    print(f'// Source clock: {source}')
    print(f'// Target clock: {target}')
    print(f'`define CLOCK_DIVIDER {divider}')
    print(f'`define CLOCK_DIVIDER_WIDTH {width}')


fn()
*/

// Source clock: 12000000
// Target clock: 2500.0
`define CLOCK_DIVIDER 4800
`define CLOCK_DIVIDER_WIDTH 13

module sevenseg_top (
  input TINY_CLK,
  input [7:0] io_in, //using io_in[0] as clk, io_in[1] as reset
  output [7:0] io_out
);

// XXX: All I really want is this: assign io_in[0] = TINY_CLK;
// But yosys errors out:
//   Net 'TINY_CLK' is multiply driven by cell port TINY_CLK.O and top level input 'io_in[0]'.
// hence the extra wire and explicit assignments. There must be a better way?
wire [7:0] io_in_x;
`ifndef CLOCK_DIVIDER
assign io_in_x[0] = TINY_CLK;
`else
reg slow_clk = 0;
reg [`CLOCK_DIVIDER_WIDTH:0] clock_divider = 0;
assign io_in_x[0] = slow_clk;
`endif
assign io_in_x[1] = io_in[1];
assign io_in_x[2] = io_in[2];
assign io_in_x[3] = io_in[3];
assign io_in_x[4] = io_in[4];
assign io_in_x[5] = io_in[5];
assign io_in_x[6] = io_in[6];
assign io_in_x[7] = io_in[7];

`ifdef CLOCK_DIVIDER
always @  (posedge TINY_CLK) begin
  if(clock_divider >= `CLOCK_DIVIDER) begin
    slow_clk <= ~slow_clk;
    clock_divider <= 0;
  end else
    clock_divider <= clock_divider + 1;
end

`endif

user_module_341063825089364563 mod1(.io_in(io_in_x), .io_out(io_out));

endmodule
