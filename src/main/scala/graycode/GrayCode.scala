package graycode

import chisel3._
import chisel3.util._
import chisel3.stage.ChiselStage

class GrayCode extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(8.W))
    val out = Output(UInt(8.W))

  })

  io.out := BinaryToGray(io.in)
}

object Main extends App {
  (new ChiselStage).emitVerilog(new GrayCode())
}
