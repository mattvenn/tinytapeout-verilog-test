package aes

import chisel3._
import chisel3.util._

//  calculate multiplicative inverse over composite field GF(2^8) = GF(2)[x]/(x^8 + x^4 + x^3 + x + 1)
class MulInv8 extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(8.W))
    val out = Output(UInt(8.W))
  })

  def dissect(u: UInt) = {
    val w = u.getWidth
    val h = w / 2
    (u.head(w - h), u.tail(h))
  }

  // Isomorphism matrix to transform from GF(2^8) to GF(2^2^2) (λ = "b1100", φ = "b10")
  def isoMat(x: UInt) = Cat(
    x(7) ^ x(5),
    x(7) ^ x(6) ^ x(4) ^ x(3) ^ x(2) ^ x(1),
    x(7) ^ x(5) ^ x(3) ^ x(2),
    x(7) ^ x(5) ^ x(3) ^ x(2) ^ x(1),
    x(7) ^ x(6) ^ x(2) ^ x(1),
    x(7) ^ x(4) ^ x(3) ^ x(2) ^ x(1),
    x(6) ^ x(4) ^ x(1),
    x(6) ^ x(1) ^ x(0)
  )

  // Inverse isomorphism matrix
  def isoMatInv(x: UInt) = Cat(
    x(7) ^ x(6) ^ x(5) ^ x(1),
    x(6) ^ x(2),
    x(6) ^ x(5) ^ x(1),
    x(6) ^ x(5) ^ x(4) ^ x(2) ^ x(1),
    x(5) ^ x(4) ^ x(3) ^ x(2) ^ x(1),
    x(7) ^ x(4) ^ x(3) ^ x(2) ^ x(1),
    x(5) ^ x(4),
    x(6) ^ x(5) ^ x(4) ^ x(2) ^ x(0)
  )

  def square4(x: UInt) = Cat(
    x(3),
    x(3) ^ x(2),
    x(2) ^ x(1),
    x(3) ^ x(1) ^ x(0)
  )

  def multiply4(x: UInt, y: UInt) =
    Cat(
      (x(3) & y(3)) ^ (x(3) & y(1)) ^ (x(1) & y(3)) ^
        (x(2) & y(3)) ^ (x(2) & y(1)) ^ (x(0) & y(3)) ^
        (x(3) & y(2)) ^ (x(3) & y(0)) ^ (x(1) & y(2)),
      (x(3) & y(3)) ^ (x(3) & y(1)) ^ (x(1) & y(3)) ^
        (x(2) & y(2)) ^ (x(2) & y(0)) ^ (x(0) & y(2)),
      (x(2) & y(3)) ^ (x(3) & y(2)) ^ (x(2) & y(2)) ^
        (x(1) & y(1)) ^ (x(0) & y(1)) ^ (x(1) & y(0)),
      (x(3) & y(3)) ^ (x(2) & y(3)) ^ (x(3) & y(2)) ^
        (x(1) & y(1)) ^ (x(0) & y(0))
    )

  // multiply by λ = "b1100"
  def mul4Lambda(x: UInt) =
    Cat(x(2) ^ x(0), x(3) ^ x(2) ^ x(1) ^ x(0), x(3), x(2))

  def square2(x: UInt) = Cat(x(1), x(1) ^ x(0))

  def multiply2(x: UInt, y: UInt) = Cat(
    (x(1) & y(1)) ^ (x(0) & y(1)) ^ (x(1) & y(0)),
    (x(1) & y(1)) ^ (x(0) & y(0))
  )

  // multiply by φ = "b10"
  def multiplyPhi2(x: UInt) = Cat(x(1) ^ x(0), x(1))

  def inverse2(x: UInt) = Cat(x(1), x(1) ^ x(0))

  // Inverse in GF(2^2)
  def inverse4(x4: UInt) = {
    val (hi, lo) = dissect(x4)
    val hiPlusLo = hi ^ lo

    val p2 = multiplyPhi2(square2(hi)) ^ multiply2(hiPlusLo, lo)
    val p2Inv = inverse2(p2)
    multiply2(hi, p2Inv) ## multiply2(hiPlusLo, p2Inv)
  }

  // Transform from GF(2^8) to GF(2^2^2)
  val (hi, lo) = dissect(isoMat(io.in))
  val hiPlusLo = hi ^ lo

  // Multiplicative inverse in GF(2^2^2) and then transform back to GF(2^8)
  val p4 = mul4Lambda(square4(hi)) ^ multiply4(hiPlusLo, lo)
  val p4Inv = inverse4(p4)
  io.out := isoMatInv(multiply4(hi, p4Inv) ## multiply4(hiPlusLo, p4Inv))
}

object Main extends App {
  val systemVerilog = false

  def gen = new MulInv8()

  def name = "mulinv"

  val verilog =
    if (systemVerilog)
      circt.stage.ChiselStage.emitSystemVerilog(gen)
    else
      stage.ChiselStage.emitVerilog(gen)

  val ext = if (systemVerilog) "sv" else "v"

  os.write.over(os.pwd / "src" / s"$name.$ext", verilog)
}
