![](../../workflows/wokwi/badge.svg)

(Original readme for the template repository [here](https://github.com/mattvenn/wokwi-verilog-gds-test/blob/main/README.md))
Adapted from H-S-S-11's tinytapeout-verilog-test.

# TinyIO

Itty bitty digital IO expander for Tiny Tapeout. TinyIO has seven outputs and three inputs accessible via a SPI interface.

## Pinout

| Pin         | Name    | Function               |
|-------------|---------|------------------------|
| `io_in[0]`  | `clk`   | Logic clock            |
| `io_in[1]`  | `reset` | Logic reset (positive) |
| `io_in[2]`  | `sclk`  | SPI clock (negative)   |
| `io_in[3]`  | `ce`    | SPI chip enable (neg.) |
| `io_in[4]`  | `sin`   | SPI in (-->chip)       |
| `io_in[5]`  | `in0`   | Digital input          |
| `io_in[6]`  | `in1`   | Digital input          |
| `io_in[7]`  | `in2`   | Digital input          |
| `io_out[0]` | `out0`  | Digital output         |
| `io_out[1]` | `out1`  | Digital output         |
| `io_out[2]` | `out2`  | Digital output         |
| `io_out[3]` | `out3`  | Digital output         |
| `io_out[4]` | `out4`  | Digital output         |
| `io_out[5]` | `out5`  | Digital output         |
| `io_out[6]` | `out6`  | Digital output         |
| `io_out[7]` | `sout`  | SPI out (<--chip)      |

## Interface

Outputs are shifted in MSB first. `sin` is sampled on the falling edge of `sclk`. `sout` is set on the rising edge of `sckl`.
Inputs are latched on the falling edge of `ce`. Outputs are latched on the rising edge of `ce`.

![Alt](https://svg.wavedrom.com/github/AidanMedcalf/tinytapeout-tinyio/main/diagram/tinyio-spi.json5)

Notes:
* Wait one `clk` cycle after deasserting `ce` before asserting `sclk`.
* `sclk` should not be higher frequency than `clk`.
