`default_nettype none

// Keep I/O fixed for TinyTapeout
module user_module_341063825089364563(
  input [7:0] io_in,
  output [7:0] io_out
);
  parameter COUNTER_WIDTH = 24;

  // using io_in[0] as clk, io_in[1] as reset
  wire clk;
  assign clk = io_in[0];
  wire reset;
  assign reset = io_in[1];

  reg [COUNTER_WIDTH:0] counter = 0; // XXX: What is the clk freq for TT?
  reg [COUNTER_WIDTH:0] counter_speed = {COUNTER_WIDTH-3{1'b1}};
  reg [2:0] state = 3'b000;
  reg [7:0] led_out = 0;
  reg direction = 0;
  reg [3:0] segments [6:0];

  always @(posedge clk) begin
    counter_speed[COUNTER_WIDTH:COUNTER_WIDTH-3] <= io_in[4:2] ^ 4'b111;
    direction <= io_in[7];
  end

  always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        counter_speed[COUNTER_WIDTH-4:0] <= {COUNTER_WIDTH-3{1'b1}};
        state <= 0;
        led_out <= 8'b00000000;
        segments[0] = 4'b0000;
        segments[1] = 4'b0000;
        segments[2] = 4'b0000;
        segments[3] = 4'b0000;
        segments[4] = 4'b0000;
        segments[5] = 4'b0000;
        segments[6] = 4'b0000;
        segments[7] = 4'b0000;
    end else begin
      if (counter >= counter_speed) begin
        counter <= 0;
        if(direction) 
          state <= state + 3'b001;
        else
          if(state == 3'b000)
            state = 3'b111;
          else
            state <= state - 3'b001;
      end
      else
        counter <= counter + 1;
    end

    if(segments[0]) begin
      led_out[0] <= 1'b1;
      segments[0] <= 4'b0000;
    end else
      led_out[0] <= 1'b0;
    if(segments[1]) begin
      led_out[1] <= 1'b1;
      segments[1] <= 4'b0000;
    end else
      led_out[1] <= 1'b0;
    if(segments[2]) begin
      led_out[2] <= 1'b1;
      segments[2] <= 4'b0000;
    end else
      led_out[2] <= 1'b0;
    if(segments[3]) begin
      led_out[3] <= 1'b1;
      segments[3] <= 4'b0000;
    end else
      led_out[3] <= 1'b0;
    if(segments[4]) begin
      led_out[4] <= 1'b1;
      segments[4] <= 4'b0000;
    end else
      led_out[4] <= 1'b0;
    if(segments[5]) begin
      led_out[5] <= 1'b1;
      segments[5] <= 4'b0000;
    end else
      led_out[5] <= 1'b0;
    if(segments[6]) begin
      led_out[6] <= 1'b1;
      segments[6] <= 4'b0000;
    end else
      led_out[6] <= 1'b0;
    if(segments[7]) begin
      led_out[7] <= 1'b1;
      segments[7] <= 4'b0000;
    end else
      led_out[7] <= 1'b0;

    case(state)
      3'b000 : segments[0] <= 4'b1111;
      3'b001 : segments[1] <= 4'b1111;
      3'b010 : segments[6] <= 4'b1111;
      3'b011 : segments[4] <= 4'b1111;
      3'b100 : segments[3] <= 4'b1111;
      3'b101 : segments[2] <= 4'b1111;
      3'b110 : segments[6] <= 4'b1111;
      3'b111 : segments[5] <= 4'b1111;
    endcase
  end

  assign io_out = led_out ^ 8'b11111111;
endmodule
