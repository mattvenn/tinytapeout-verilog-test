// See README.md for license details.

package wrapper

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec
import chiseltest._
import org.scalatest._
import org.scalatest.flatspec.AnyFlatSpec

class ChiselWrapperTester extends AnyFlatSpec with ChiselScalatestTester {

  def testGCDandDisplay(dut:ChiselWrapperAux, data1:Int, data2:Int, expected:Int) = {
    dut.io.data1.poke(data1)
      dut.io.data2.poke(data2)
      dut.io.sw.poke(1)
      dut.clock.step()
      dut.io.sw.poke(0)
      dut.clock.step(10)
      
      println(dut.io.out.peek())
      dut.io.out.expect(expected)
  }
  behavior of "ChiselWrapper"

  it should "The module should add the tow operands at io.in[4:2] and io.in[7:5]" in {
    test(new ChiselWrapperAux()) { dut =>
      testGCDandDisplay(dut, 0x0, 0x7, 134)
      testGCDandDisplay(dut, 0x1, 0x1, 134)
      testGCDandDisplay(dut, 0x1, 0x6, 207)
      testGCDandDisplay(dut, 0x0, 0x4, 238)
      
    // while(dut.io.out.peek()(7) == 0){

    // }

    }
  }
}
