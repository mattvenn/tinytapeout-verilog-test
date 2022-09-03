![](../../workflows/wokwi/badge.svg)

Repeatedly transmits "Hello World!\n" with a byte length idle gap between repetitions using UART.
One start bit, two stop bits, no parity bit. One bit per clock cycle.

![Alt](https://github.com/ElectricPotato/tinytapeout-hello-world-uart/blob/main/wavedrom.svg?raw=true)

## Pin list
| Pin  | Function |
|------|------|
| in0  | CLK  |
| in1  | Synchronous reset  |
| out0 | UART TX |

(This repo is using the Tiny Tapeout [verilog template](https://github.com/H-S-S-11/tinytapeout-verilog-test))