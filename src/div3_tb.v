module tb;

reg clk,rst;
wire out;

initial begin
  clk = 1 ; #5 clk = 0 ;
  forever #5 clk = ~clk ;
end

div3_340067262721426004 div3(.rst(rst),.in(clk),.out(out));

integer i,clk_count,out_count,fail;

always @(posedge clk)
   clk_count <= rst ? 0 : clk_count + 1;

always @(posedge out)
   out_count <= rst ? 0 : out_count + 1;

initial begin
   //$dumpfile("tb.vcd");
   //$dumpvars(0);
   //$monitor("%-04d %b %b %b",$time,div3.s0,div3.s1,div3.s2);

   rst = 1;
   @(posedge clk);
   @(posedge clk);
   rst = 0;

   $display("\n%-04d: Release reset\n",$time);
   $display("%-04d:\tI | O",$time);
   $display("----:---------");

   for( i=0; i<9; i=i+1) begin 
     @(posedge clk);
     $display("%-04d:\t%b | %b",$time,clk,out);
     @(negedge clk);
     $display("%-04d:\t%b | %b",$time,clk,out);
   end

   fail = 0;

   if( clk_count/out_count != 3 ) begin
	   $display("FAIL %d / %d is not 3",clk_count,out_count);
           fail = fail | 1;
   end

   if( clk_count%out_count != 0 ) begin
	   $display("FAIL %d % %d has a remainder",clk_count,out_count);
           fail = fail | 1;
   end

   if( fail ) begin
	    $display("TEST FAIL");
   end	else begin
	    $display("TEST PASS");
   end
   $finish;

end

endmodule
