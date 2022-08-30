`default_nettype none

// Keep I/O fixed for TinyTapeout
module user_module_341063825089364563(
  input [7:0] io_in,
  output [7:0] io_out
);
  parameter COUNTER_WIDTH = 22;
  parameter FADE_COUNTER_WIDTH = 20;
  parameter PWM_COUNTER_WIDTH = 11;
  parameter COMMON_ANODE = 1;

  // using io_in[0] as clk, io_in[1] as reset
  wire clk;
  assign clk = io_in[0];
  wire reset;
  assign reset = io_in[1];

  reg [COUNTER_WIDTH-1:0] counter = 0; // XXX: What is the clk freq for TT?
  reg [2:0] counter_speed_prefix;
  reg [2:0] state = 3'b000;
  reg [7:0] led_out;
  reg direction;
  reg [4:0] segments [6:0];
  reg [1:0] fade_speed = 2'b11;
  reg [PWM_COUNTER_WIDTH-1:0] pwm_counter = 0;
  wire [FADE_COUNTER_WIDTH-1:0] fade_counter;
  wire [4:0] pwm_counter_slice;
  wire [COUNTER_WIDTH-1:0] counter_speed;

  assign pwm_counter_slice = pwm_counter[PWM_COUNTER_WIDTH-4:PWM_COUNTER_WIDTH-4-5];
  assign counter_speed = {counter_speed_prefix, {COUNTER_WIDTH-1-3{1'b1}}};
  assign fade_counter = counter[FADE_COUNTER_WIDTH-1:0];


  always @(posedge clk) begin
    counter_speed_prefix <= io_in[4:2] ^ 4'b111;
    direction <= io_in[7];
  end

  always @(posedge clk) begin
    if(reset) begin
        counter <= 0;
        state <= 0;
        led_out <= 8'b00000000;
        segments[0] <= 5'b00000;
        segments[1] <= 5'b00000;
        segments[2] <= 5'b00000;
        segments[3] <= 5'b00000;
        segments[4] <= 5'b00000;
        segments[5] <= 5'b00000;
        segments[6] <= 5'b00000;
        pwm_counter = 0;
    end else begin
      if(counter >= counter_speed) begin
        counter <= 0;
        if(direction)
          state <= state + 3'b001;
        else
          if(state == 3'b000)
            state = 3'b111;
          else
            state <= state - 3'b001;
      end else begin
        counter <= counter + 1;
      end
      pwm_counter <= pwm_counter + 1;
    end

    led_out[0] <= segments[0] > pwm_counter_slice;
    led_out[1] <= segments[1] > pwm_counter_slice;
    led_out[2] <= segments[2] > pwm_counter_slice;
    led_out[3] <= segments[3] > pwm_counter_slice;
    led_out[4] <= segments[4] > pwm_counter_slice;
    led_out[5] <= segments[5] > pwm_counter_slice;
    led_out[6] <= segments[6] > pwm_counter_slice;
    led_out[7] <= segments[7] > pwm_counter_slice;

    if(fade_counter == 0)
    begin
      segments[0] <= segments[0] >> 1;
      segments[1] <= segments[1] >> 1;
      segments[2] <= segments[2] >> 1;
      segments[3] <= segments[3] >> 1;
      segments[4] <= segments[4] >> 1;
      segments[5] <= segments[5] >> 1;
      segments[6] <= segments[6] >> 1;
      segments[7] <= segments[7] >> 1;
    end

    case(state)
      3'b000 : segments[0] <= 5'b11111;
      3'b001 : segments[1] <= 5'b11111;
      3'b010 : segments[6] <= 5'b11111;
      3'b011 : segments[4] <= 5'b11111;
      3'b100 : segments[3] <= 5'b11111;
      3'b101 : segments[2] <= 5'b11111;
      3'b110 : segments[6] <= 5'b11111;
      3'b111 : segments[5] <= 5'b11111;
    endcase
  end

  generate
    if(COMMON_ANODE)
      assign io_out = led_out ^ 8'b11111111;
    else
      assign io_out = led_out;
  endgenerate
endmodule
