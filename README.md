# 7 Segment Looping Figure Eight for TinyTapeout

![Animated Figure 8](fig8.gif)

A small looping figure 8/snake with fading tail for [TinyTapeout](http://tinytapeout.com/). Speed, direction, fade and common anode/cathode are configurable using the input pins.



                 +-----------+
                 |           |
                 | in    out |     led segment
    x           -|  0     0  |-      a
    reset       -|  1     1  |-      b
    speed lsb   -|  2     2  |-      c
    speed       -|  3     3  |-      d
    speed msb   -|  4     4  |-      e
    tail        -|  5     5  |-      f
    direction   -|  6     6  |-      g
    led invert  -|  7     7  |-      x
                 |           |
                 +-----------+

Hardware used for testing this demo project is the [iceFUN](https://www.robot-electronics.co.uk/icefun.html) FPGA board. I have been using `apio` to generate bitstream to load on hardware.

---

(Original readme from `omerk`'s repository [here](https://github.com/omerk/tinytapeout-verilog-test/blob/main/README.md))
