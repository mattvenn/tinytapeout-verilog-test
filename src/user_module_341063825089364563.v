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
  wire [3:0] speed;
  assign speed = io_in[4:2];

  reg [COUNTER_WIDTH:0] counter = 0; // XXX: What is the clk freq for TT?
  reg [COUNTER_WIDTH:0] counter_speed = {COUNTER_WIDTH-3{1'b1}};
  reg [2:0] state = 3'b000;
  reg [7:0] led_out = 0;

  always @(posedge clk) begin
    counter_speed[COUNTER_WIDTH:COUNTER_WIDTH-3] <= speed ^ 4'b111;
  end

  always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        counter_speed[COUNTER_WIDTH-4:0] <= {COUNTER_WIDTH-3{1'b1}};
        state <= 0;
        led_out <= 8'b00000000;
    end else begin
      if (counter >= counter_speed) begin
        counter <= 0;
        state <= state + 3'b001;
      end
      else
        counter <= counter + 1;
    end

    case(state)
      3'b000 : led_out <= 8'b00000001;
      3'b001 : led_out <= 8'b00000010;
      3'b010 : led_out <= 8'b01000000;
      3'b011 : led_out <= 8'b00010000;
      3'b100 : led_out <= 8'b00001000;
      3'b101 : led_out <= 8'b00000100;
      3'b110 : led_out <= 8'b01000000;
      3'b111 : led_out <= 8'b00100000;
      default : led_out <= 8'b00000000;
    endcase
  end

  assign io_out = led_out ^ 8'b11111111;
endmodule
