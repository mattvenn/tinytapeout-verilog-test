`default_nettype none

// Keep I/O fixed for TinyTapeout
module user_module_341457494561784402(
    input  wire [7:0] io_in,
    output wire [7:0] io_out
);
    ChiselWrapper chiselwrapper(
        .io_in(io_in),
        .io_out(io_out),
    );

endmodule


