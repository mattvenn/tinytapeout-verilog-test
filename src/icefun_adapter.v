// Seven segment to matrix mapping
//       0 1 2 3 col
//  led
//   0   x a a x
//   1   f x x b
//   2   f x x b
//   3   x g g x
//   4   e x x c
//   5   e x x c
//   6   x d d x
//   7   x x x x

module sevenseg_to_matrix (
    input clk,
    input [7:0] sevenseg_in,
    output [7:0] io_out,
    output [3:0] io_col);

    wire [7:0] mapping [7:0] [3:0];
    wire [3:0] strobe_out;
    wire [1:0] strobe_idx;
    wire [7:0] sevenseg_in_inv;
    wire [7:0] matrix_out [7:0];

    initial $readmemb("sevenseg_to_matrix.txt", mapping);

    assign io_col = strobe_out ^ 4'b1111;

    // 0 0 0 1  ->  0 0
    // 0 0 1 0  ->  0 1
    // 0 1 0 0  ->  1 0
    // 1 0 0 0  ->  1 1
    // [0] = ~3 ~2 1 ~0 + 3 ~2 ~1 ~0
    assign strobe_idx[0] = (~strobe_out[3] & ~strobe_out[2] & strobe_out[1] & ~strobe_out[0])
                           | (strobe_out[3] & ~strobe_out[2] & ~strobe_out[1] & ~strobe_out[0]); 
    // [0] = ~3 2 ~1 ~0 + 3 ~2 ~1 ~0
    assign strobe_idx[1] = (~strobe_out[3] & strobe_out[2] & ~strobe_out[1] & ~strobe_out[0])
                           | (strobe_out[3] & ~strobe_out[2] & ~strobe_out[1] & ~strobe_out[0]); 

    assign sevenseg_in_inv = ~sevenseg_in;
  
	generate
        genvar i;
		for (i = 0; i < 8; i = i + 1) begin
          assign io_out[i] = (matrix_out[0][i] | matrix_out[1][i] | matrix_out[2][i] | matrix_out[3][i] 
                              | matrix_out[4][i] | matrix_out[5][i] | matrix_out[6][i] | matrix_out[7][i]) ^ 1'b1;
		end
	endgenerate
    
    strobe strobe_1 (.clk(clk), .strobe_out(strobe_out));

    function [7:0] segment;
        input [3:0] idx;
        input [7:0] segments;
        begin
            if(segments[idx])
                segment = mapping[idx][strobe_idx];
            else
                segment = 8'b00000000;
        end
    endfunction

    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin
            assign matrix_out[i] = segment(i, sevenseg_in_inv);
        end
    endgenerate

endmodule

module strobe (
    input clk, 
    output [3:0] strobe_out);

    reg [12:0] counter = 0;
    reg [3:0] strobe_out = 4'b0001;

    always @ (posedge clk)
        begin
            counter <= counter + 1;
            if(counter == 0)
                if(strobe_out == 4'b1000)
                    strobe_out <= 4'b0001;
                else
                    strobe_out <= strobe_out << 1;
        end
endmodule
