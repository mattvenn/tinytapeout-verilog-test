`default_nettype none

module clock (
    input i_clk,
    input i_rst,
    input i_set,
    input i_up,
    input i_down,
    output [7:0] o_seg0,
    output [7:0] o_seg1,
    output [7:0] o_seg2,
    output [7:0] o_seg3,
    output [7:0] o_seg4,
    output [7:0] o_seg5,
);
    wire seconds_carry;
    wire minutes_carry;

    wire [7:0] seconds;
    wire [7:0] minutes;
    wire [7:0] hours;

    bcd_counter_8b bcd_seconds(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(1'b1),
        .o_bcd(seconds),
        .i_max(8'h59),
        .o_carry(seconds_carry)
    );    
    bcd_counter_8b bcd_minutes(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(seconds_carry),
        .o_bcd(minutes),
        .i_max(8'h59),
        .o_carry(minutes_carry)
    );    
    bcd_counter_8b bcd_hours(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_en(minutes_carry),
        .o_bcd(hours),
        .i_max(8'h23),
        .o_carry()
    );

    bcd_decoder dec0(
        .i_in(seconds[3:0]),
        .o_out(o_seg0)
    );
    bcd_decoder dec1(
        .i_in(seconds[7:4]),
        .o_out(o_seg1)
    );
    bcd_decoder dec2(
        .i_in(minutes[3:0]),
        .o_out(o_seg2)
    );
    bcd_decoder dec3(
        .i_in(minutes[7:4]),
        .o_out(o_seg3)
    );
    bcd_decoder dec4(
        .i_in(hours[3:0]),
        .o_out(o_seg4)
    );
    bcd_decoder dec5(
        .i_in(hours[7:4]),
        .o_out(o_seg5)
    );



endmodule

