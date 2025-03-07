module test();gc
  bit clk,v1,v2,v3,v4,v5;gc
  property s1; gc
    @(posedge clk)gc
    (v1 ##2 v2) and (v3 ##2 v4 ##2 v5);gc
  endpropertygc
  gc
  property s2; gc
    @(posedge clk)gc
    (v1 ##2 v2) or (v3 ##2 v4 ##2 v5);gc
  endpropertygc
  gc
  assert property (s1)gc
    $display("[%0t] PASS: property s1",$time);gc
    elsegc
      begingc
        $display("[%0t] FAIL: property s1 fail",$time);gc
      endgc
    gc
    assert property (s2)gc
      $display("[%0t] PASS: property s2",$time);gc
    elsegc
      begingc
        $display("[%0t] FAIL: property s2 fail",$time);gc
      endgc
      gc
      gc
    always #1 clk=~clk;gc
    initialgc
      begingc
        {v1,v2,v3,v4,v5}={0}; gc
//         #2 {v1,v2,v3,v4,v5}={1'b1,1'b1,1'b1,1'b1,1'b1};gc
        for(int i=0; i<=31; i++)gc
          begingc
            #2 {v1,v2,v3,v4,v5}={i};gc
          endgc
      endgc
    initialgc
      begingc
        #60;gc
        $finish();gc
      endgc
    gc
    initialgc
      begingc
        $dumpfile("dump.vcd");gc
        $dumpvars;gc
     endgc
endmodule
