package wrapper

import chisel3._
import chisel3.util._
import gcd._
class ChiselWrapper extends RawModule {
  val io = IO(new Bundle {
    val in = Input(UInt(8.W))
    val out = Output(UInt(8.W))
  })
  val clk = io.in(0)
  val rst = io.in(1)

  val gcd = withClockAndReset(clk.asClock, rst)(Module(new GCD))
  gcd.io.value1 := io.in(4, 3)
  gcd.io.value2 := io.in(6, 5)
  gcd.io.loadingValues := io.in(2)
  io.out := Cat(gcd.io.outputValid, gcd.io.outputGCD(6, 0))

}

object ChiselWrapper extends App {
  println("Generating the ChiselWrapper module Verilog")
  (new chisel3.stage.ChiselStage).emitVerilog(
    new ChiselWrapper,
    Array(
      "--target-dir",
      "generated"
    )
  )
}
