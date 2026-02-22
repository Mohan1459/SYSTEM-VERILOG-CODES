module tb;
  reg a,b,cin;
  wire brr;
  wire diff;
  
  fs g1(a,b,cin,brr,diff);
  initial begin
    repeat(8)begin
      {a,b,cin}=$urandom%8;
    #5;
      assert(diff==a^b^cin)
        $display("DIFFERENCE TEST PASSED");
    else
      $display("DIFFERENCE TEST FAILED");
    #5;
      assert(brr==(((~a)&b)|(b&cin)|(cin&(~a))))
        $display("BORROW TEST PASSED");
    else
      $display("BORROW TEST FAILED");
    end
    #10; $finish;
      
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule

    
    
