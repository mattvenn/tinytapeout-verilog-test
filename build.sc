// import Mill dependency
import mill._
import mill.define.Sources
import mill.modules.Util
import mill.scalalib.TestModule.ScalaTest
import scalalib._
// support BSP
import mill.bsp._
import coursier.maven.MavenRepository

object GrayCode extends SbtModule { m =>
  def repositoriesTask = T.task {
    super.repositoriesTask() ++ Seq(
      MavenRepository("https://oss.sonatype.org/content/repositories/releases"),
      MavenRepository("https://oss.sonatype.org/content/repositories/snapshots")
    )
  }
  override def scalaVersion = "2.13.8"

  val chiselVersion = "3.6-SNAPSHOT"

  override def millSourcePath = os.pwd

  override def scalacOptions = Seq(
    "-language:reflectiveCalls",
    "-deprecation",
    "-feature",
    "-Xcheckinit",
  )
  override def ivyDeps = Agg(
    ivy"edu.berkeley.cs::chisel3:${chiselVersion}"
  )
  override def scalacPluginIvyDeps = Agg(
    ivy"edu.berkeley.cs:::chisel3-plugin:${chiselVersion}"
  )
  object test extends Tests with ScalaTest {
    override def ivyDeps = m.ivyDeps() ++ Agg(
      // ivy"org.scalactic::scalactic:3.1.1",
      // ivy"org.scalatest::scalatest:3.1.1",
      ivy"edu.berkeley.cs::chiseltest:${chiselVersion.replaceFirst("3", "0")}"
    )
    def testFrameworks = Seq("org.scalatest.tools.Framework")
  }

}
