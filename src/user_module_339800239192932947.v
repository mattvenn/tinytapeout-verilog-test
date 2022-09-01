`default_nettype none


module user_module_339800239192932947 (
  input [7:0] io_in,
  output [7:0] io_out
);

  mulinv mod1(.clock(1'b0), .reset(1'b0), .io_in(io_in), .io_out(io_out));

endmodule
