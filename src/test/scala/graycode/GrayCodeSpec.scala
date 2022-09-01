package graycode

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec
import chisel3.experimental.BundleLiterals._

class GrayCodeSpec extends AnyFreeSpec with ChiselScalatestTester {

  "convert binary to gray-code" in {
    test(new GrayCode()) { dut =>
      val inputs = (0 to 255).toSeq
      fork {
        for (i <- inputs) {
          timescope {

            dut.io.in.poke(i.U)
            dut.clock.step(1)
          }
        }
      }.fork {
        for (i <- inputs) {
          fork
            .withRegion(Monitor) {
              val out = dut.io.out.peekInt()
              println(f"${out.toString(2)}%8s")
            }
            .joinAndStep(dut.clock)
        }
      }.join()

      DecoupledDriver

    }
  }
}
