package displaydriver

import chisel3._
import chisel3.util._

class DisplayDriver extends RawModule {
  val io = IO(new Bundle {
    val in = Input(UInt(4.W))
    val dot = Input(Bool())
    val out = Output(UInt(8.W))
  })
  val display = Wire(UInt(7.W))

  io.out := Cat(io.dot, display)
  
  display := MuxLookup(io.in, 0.U(7.W), Seq(
               // 6543210
    0.U(4.W) -> "b0111111".U(7.W),
               // 6543210
    1.U(4.W) -> "b0000110".U(7.W),
               // 6543210
    2.U(4.W) -> "b1011011".U(7.W),
               // 6543210
    3.U(4.W) -> "b1001111".U(7.W),
               // 6543210
    4.U(4.W) -> "b1101110".U(7.W),
               // 6543210
    5.U(4.W) -> "b1101101".U(7.W),
               // 6543210
    6.U(4.W) -> "b1111101".U(7.W),
               // 6543210
    7.U(4.W) -> "b0000111".U(7.W),
               // 6543210
    8.U(4.W) -> "b1111111".U(7.W),
               // 6543210
    9.U(4.W) -> "b1101111".U(7.W),
  ))
}

object DisplayDriver extends App {
  println("Generating the DisplayDriver module Verilog")
  (new chisel3.stage.ChiselStage).emitVerilog(
    new DisplayDriver,
    Array(
      "--target-dir",
      "generated"
    )
  )
}
