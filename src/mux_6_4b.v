`default_nettype none

module mux_6_4b (
    input i_clk,
    input i_rst,
    input [3:0] i_in0,
    input [3:0] i_in1,
    input [3:0] i_in2,
    input [3:0] i_in3,
    input [3:0] i_in4,
    input [3:0] i_in5,
    input [2:0] i_sel,
    output [3:0] o_out,
    input i_latch
);

    reg [3:0] o_out;
    reg [3:0] in0_r;
    reg [3:0] in1_r;
    reg [3:0] in2_r;
    reg [3:0] in3_r;
    reg [3:0] in4_r;
    reg [3:0] in5_r;
    
    always @(posedge i_clk) begin
        if(i_latch)begin 
            in0_r <= i_in0;
            in1_r <= i_in1;
            in2_r <= i_in2;
            in3_r <= i_in3;
            in4_r <= i_in4;
            in5_r <= i_in5; 
        end

        if(i_rst)begin
            in0_r <= 4'd10;
            in1_r <= 4'd10;
            in2_r <= 4'd10;
            in3_r <= 4'd10;
            in4_r <= 4'd10;
            in5_r <= 4'd10; 
        end
    end

    always @(*) begin
        case (i_sel)
            3'd0: o_out <= in0_r;
            3'd1: o_out <= in1_r;
            3'd2: o_out <= in2_r;
            3'd3: o_out <= in3_r;
            3'd4: o_out <= in4_r;
            3'd5: o_out <= in5_r; 
            default: o_out <= 4'b1111;
        endcase
    end
endmodule
