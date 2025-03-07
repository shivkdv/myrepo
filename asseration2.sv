class base;
  bit rst;
  rand reg rqt,grt;
  
//   constraint c1 {dist}
  
endclass

module test();
  bit clk=0;
  always #1 clk=~clk;
  bit rst;
  bit rqt,grt;
  base b;
  property p1; @(posedge clk)
    disable iff (rst) (rqt |-> grt [*2:5]); 
  endproperty
  
  assert property (p1)
    $display("PASS : the value of data should not change when enable is high [%0t]",$time);
    else
      begin
        $display("FAIL: the value of data will change when enable is high [%0t]",$time);
      end
  
  initial
    begin
      b=new();
      repeat(20)
        begin
          #2;
          b.randomize();
          rqt=b.rqt;
          grt=b.grt;
        end

    end
    initial
      begin
        #50;
        $finish();
      end
    
    initial
      begin
        $monitor("[%0t] rst : %0d grt : %0d",$time,rst,grt);
        $dumpfile("dump.vcd");
        $dumpvars;
     end
  
endmodule

