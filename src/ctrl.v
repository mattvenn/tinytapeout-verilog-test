`default_nettype none

module ctrl (
    input i_clk,
    input i_rst,
    output [2:0] o_muxsel,
    input i_srbusy,
    output o_srload,
    output o_latch,
    output o_cnt_en,
    input i_set
);
    reg [3:0] state;
    reg [2:0] counter;
    reg [8:0] scaler;

    reg o_srload;
    assign o_cnt_en = (scaler == 0);
    assign o_latch = (state == 4'd4);
    
    always @(*) begin
        o_muxsel <= counter;
        if(set_toggle)begin
            if((set_target == 2'd1) && (counter[2:1] == 2'b00))begin
                o_muxsel <= 3'd6;
            end
            if((set_target == 2'd2) && (counter[2:1] == 2'b?1))begin
                o_muxsel <= 3'd6;
            end
            if((set_target == 2'd3) && (counter[2:1] == 2'b1?))begin
                o_muxsel <= 3'd6;
            end
        end


        
    end

    always @(posedge i_clk) begin
        scaler <= scaler + 8'd1;

        case (state)
            4'd0: begin
                if(!i_srbusy) begin
                    o_srload <= 1'b1;
                    state <= 4'd1;
                    counter <= counter + 3'd1;
                end
            end 
            4'd1: begin
                o_srload <= 1'b0;
                state <= 4'd0;
                if(counter == 5) begin
                    state <= 4'd2;
                end
            end 
            4'd2: begin
                if(!i_srbusy) begin
                    state <= 4'd3;
                end
            end 
            4'd3: begin
                state <= 4'd4;
            end 
            4'd4: begin
                counter <= 3'd0;
                o_srload <= 1'b1;
                state <= 4'd1;
            end 

            default: state <= 4'd3;
        endcase

        if(i_rst) begin
            state <= 4'd4;
            counter <= 4'd0;
            scaler <= 8'd0;
            o_srload <= 1'b0;
        end
    end


    reg [3:0] set_state;
    reg [9:0] set_counter;
    reg [1:0] set_target;
    reg set_toggle;
    reg i_set_r;
    
    always @(posedge i_clk) begin
        if(o_latch) begin
            set_toggle <= ~set_toggle;
        end
        
        if(i_set) begin
            set_counter <= set_counter + 8'd1;
            if(set_counter[9])begin
                set_counter <= 8'd0;
                set_target <= set_target + 2'd1;
                end
        end else begin 
            set_counter <= 8'd0;
        end
            
        if(i_rst) begin
            set_counter <= 4'd0;
            set_toggle <= 1'b0;
            set_target <= 2'd0;
        end
    end

    

endmodule

