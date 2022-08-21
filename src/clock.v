`default_nettype none

module clock (
    input i_clk,
    input i_rst,
    input i_set_h,
    input i_set_m,
    output o_clk,
    output o_latch,
    output o_bit
);
    wire seconds_carry;
    wire minutes_carry;

    wire [7:0] seconds;
    wire [7:0] minutes;
    wire [7:0] hours;

    wire [2:0] mux_sel;
    wire [3:0] mux_out;

    wire [7:0] dec_out;

    wire sr_load;
    wire sr_busy;
    wire cnt_en;


    bcd_counter_8b bcd_seconds(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(cnt_en),
        .o_bcd(seconds),
        .i_max(8'h59),
        .o_carry(seconds_carry)
    );    
    bcd_counter_8b bcd_minutes(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(seconds_carry | (cnt_en & i_set_m)),
        .o_bcd(minutes),
        .i_max(8'h59),
        .o_carry(minutes_carry)
    );    
    bcd_counter_8b bcd_hours(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(minutes_carry | (cnt_en & i_set_h)),
        .o_bcd(hours),
        .i_max(8'h23),
        .o_carry()
    );

    mux_6_4b mux(
        .i_in0(seconds[3:0]),
        .i_in1(seconds[7:4]),
        .i_in2(minutes[3:0]),
        .i_in3(minutes[7:4]),
        .i_in4(hours[3:0]),
        .i_in5(hours[7:4]),
        .i_sel(mux_sel),
        .o_out(mux_out)
    );

    bcd_decoder dec(
        .i_in(mux_out),
        .o_out(dec_out)
    );

    output_sr sr(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_load(sr_load),
        .i_data(dec_out),
        .o_busy(sr_busy),
        .o_bit(o_bit),
        .o_clk(o_clk)
    );

    ctrl ctrl(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_muxsel(mux_sel),
        .o_srload(sr_load),
        .i_srbusy(sr_busy),
        .o_latch(o_latch),
        .o_cnt_en(cnt_en)
    );


endmodule

