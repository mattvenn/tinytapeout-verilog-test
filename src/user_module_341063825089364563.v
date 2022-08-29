`default_nettype none

// Keep I/O fixed for TinyTapeout
module user_module_341063825089364563(
  input [7:0] io_in,
  output [7:0] io_out
);
  parameter COUNTER_WIDTH = 24;
  parameter FADE_COUNTER_WIDTH = 21;
  parameter PWM_COUNTER_WIDTH = 11;
  parameter COMMON_ANODE = 1;

  // using io_in[0] as clk, io_in[1] as reset
  wire clk;
  assign clk = io_in[0];
  wire reset;
  assign reset = io_in[1];

  reg [COUNTER_WIDTH-1:0] counter = 0; // XXX: What is the clk freq for TT?
  reg [COUNTER_WIDTH-1:0] counter_speed = {COUNTER_WIDTH-3{1'b1}};
  reg [2:0] state = 3'b000;
  reg [7:0] led_out = 0;
  reg direction = 0;
  reg [4:0] segments [6:0];
  reg [1:0] fade_speed = 2'b11;
  reg [6:0] segments_processed;
  reg [FADE_COUNTER_WIDTH-1:0] fade_counter = 0;
  reg [PWM_COUNTER_WIDTH-1:0] pwm_counter = 0;

  wire [3:0] segments_0;
  assign segments_0 = segments[0];
  wire [3:0] segments_1;
  assign segments_1 = segments[1];


  always @(posedge clk) begin
    counter_speed[COUNTER_WIDTH-1:COUNTER_WIDTH-3] <= io_in[4:2] ^ 4'b111;
    direction <= io_in[7];
  end

  always @(posedge clk) begin
    if(reset) begin
        counter <= 0;
        counter_speed[COUNTER_WIDTH-1-3:0] <= {COUNTER_WIDTH-3{1'b1}};
        state <= 0;
        led_out <= 8'b00000000;
        segments[0] <= 5'b00000;
        segments[1] <= 5'b00000;
        segments[2] <= 5'b00000;
        segments[3] <= 5'b00000;
        segments[4] <= 5'b00000;
        segments[5] <= 5'b00000;
        segments[6] <= 5'b00000;
        fade_counter = 0;
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
      fade_counter <= fade_counter + 1;
    end

    if(segments[0] && segments[0] >= pwm_counter[PWM_COUNTER_WIDTH-4:PWM_COUNTER_WIDTH-4-5]) begin
      led_out[0] <= 1'b1;
    end else
      led_out[0] <= 1'b0;
    if(segments[0] && fade_counter == 0)
      segments[0] <= segments[0] >> 1;

   if(segments[1] && segments[1] >= pwm_counter[PWM_COUNTER_WIDTH-4:PWM_COUNTER_WIDTH-4-5]) begin
      led_out[1] <= 1'b1;
    end else
      led_out[1] <= 1'b0;
    if(segments[1] && fade_counter == 0)
      segments[1] <= segments[1] >> 1;

   if(segments[2] && segments[2] >= pwm_counter[PWM_COUNTER_WIDTH-4:PWM_COUNTER_WIDTH-4-5]) begin
      led_out[2] <= 1'b1;
    end else
      led_out[2] <= 1'b0;
    if(segments[2] && fade_counter == 0)
      segments[2] <= segments[2] >> 1;

   if(segments[3] && segments[3] >= pwm_counter[PWM_COUNTER_WIDTH-4:PWM_COUNTER_WIDTH-4-5]) begin
      led_out[3] <= 1'b1;
    end else
      led_out[3] <= 1'b0;
    if(segments[3] && fade_counter == 0)
      segments[3] <= segments[3] >> 1;

   if(segments[4] && segments[4] >= pwm_counter[PWM_COUNTER_WIDTH-4:PWM_COUNTER_WIDTH-4-5]) begin
      led_out[4] <= 1'b1;
    end else
      led_out[4] <= 1'b0;
    if(segments[4] && fade_counter == 0)
      segments[4] <= segments[4] >> 1;

   if(segments[5] && segments[5] >= pwm_counter[PWM_COUNTER_WIDTH-4:PWM_COUNTER_WIDTH-4-5]) begin
      led_out[5] <= 1'b1;
    end else
      led_out[5] <= 1'b0;
    if(segments[5] && fade_counter == 0)
      segments[5] <= segments[5] >> 1;

   if(segments[6] && segments[6] >= pwm_counter[PWM_COUNTER_WIDTH-4:PWM_COUNTER_WIDTH-4-5]) begin
      led_out[6] <= 1'b1;
    end else
      led_out[6] <= 1'b0;
    if(segments[6] && fade_counter == 0)
      segments[6] <= segments[6] >> 1;

    if(segments[7] && segments[7] >= pwm_counter[PWM_COUNTER_WIDTH-4:PWM_COUNTER_WIDTH-4-5]) begin
      led_out[7] <= 1'b1;
    end else
      led_out[7] <= 1'b0;
    if(segments[7] && fade_counter == 0)
      segments[7] <= segments[7] >> 1;

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
