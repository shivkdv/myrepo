module test;
  reg enable,data,rst;
  reg clk=0;
  always #1 clk=~clk;
  
  function void disp(string str);
    $display("\n################################### PASS ######################################################\n");
    $display("\t [%0t] %0s",$time,str);
    $display("\n#################################### PASSED #####################################################\n");
  endfunction
  
  function void fail(string str);
    $display("\n################################### FAIL ######################################################\n");
    $display("\t [%0t] %0s",$time,str);
    $display("\n#################################### FAILED #####################################################\n");
  endfunction
  
  property p1; @(posedge clk)
    disable iff(rst) enable |-> $stable(data);
  endproperty
  
 assert property (p1)
    disp("PASS: Property P1 ");
  else
    begin
      fail("FAILED: Property P1:");
    end
  
  initial
    begin
      rst=0;
      {data,enable}=0;
      #2 rst=1;
      #2 rst=0;
      repeat(10)
        begin
          #2 {data,enable}={$urandom};
        end
    end

    initial
      begin
       #20;  
       $finish;
     end
    
    initial
      begin
        $monitor("[%0t] rst : %0d enable : %0d data : %0d",$time,rst,enable,data);
        $dumpfile("dump.vcd");
        $dumpvars;
     end
    endmodule
