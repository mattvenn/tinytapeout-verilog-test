`default_nettype none

module ctrl (
    input i_clk,
    input i_rst,
    input i_freq,
    output [2:0] o_muxsel,
    input i_srbusy,
    output o_srload,
    output o_latch,
    output o_cnt_en
);
    reg [2:0] state;
    reg [2:0] counter;
    reg [9:0] scaler;

    reg o_srload;
    assign o_cnt_en = scaler == 0;
    assign o_latch = (state == 4'd4);
    assign o_muxsel = counter;
        
    always @(posedge i_clk) begin
        scaler <= scaler + 10'd1;
        if(i_freq) begin
            if(scaler >= (256-1))
                scaler <= 9'd0;
        end else begin
            if(scaler >= (128-1))
                scaler <= 9'd0;
        end

        case (state)
            3'd0: begin
                if(!i_srbusy) begin
                    o_srload <= 1'b1;
                    state <= 4'd1;
                    counter <= counter + 3'd1;
                end
            end 
            3'd1: begin
                o_srload <= 1'b0;
                state <= 4'd0;
                if(counter == 5) begin
                    state <= 4'd2;
                end
            end 
            3'd2: begin
                if(!i_srbusy) begin
                    state <= 4'd3;
                end
            end 
            3'd3: begin
                state <= 4'd4;
            end 
            3'd4: begin
                counter <= 3'd0;
                if(o_cnt_en) begin
                    o_srload <= 1'b1;
                    state <= 4'd1;
                end
            end 

            default: state <= 3'd3;
        endcase

        if(i_rst) begin
            state <= 3'd4;
            counter <= 3'd0;
            scaler <= 9'd0;
            o_srload <= 1'b0;
        end
    end
    

endmodule

