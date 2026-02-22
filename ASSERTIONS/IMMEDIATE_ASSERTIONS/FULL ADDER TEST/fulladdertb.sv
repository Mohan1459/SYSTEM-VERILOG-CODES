module tb;
  reg a,b,cin;
  wire cout;
  wire sum;
  
  fa g1(a,b,cin,cout,sum);
  initial begin
    repeat(8)begin
      {a,b,cin}=$urandom%8;
    #5;
    assert(sum==a^b^cin)
      $display("SUM TEST PASSED");
    else
      $display("SUM TEST FAILED");
    #5;
      assert(cout==(( a&b|b&cin|cin&a)))
      $display("CARRY TEST PASSED");
    else
      $display("CARRY TEST FAILED");
    end
    #10; $finish;
      
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule

    
    
module tb;
  reg a,b,cin;
  wire cout;
  wire sum;
  
  fa g1(a,b,cin,cout,sum);

  initial begin
    repeat(8) begin
      {a,b,cin} = $random % 8;
      #1;

      // Assertion for SUM
      assert (sum == (a ^ b ^ cin))
        else $error("SUM MISMATCH: a=%0b b=%0b cin=%0b sum=%0b",
                     a,b,cin,sum);

      // Assertion for CARRY
      assert (cout == ((a & b) | (b & cin) | (a & cin)))
        else $error("CARRY MISMATCH: a=%0b b=%0b cin=%0b cout=%0b",
                     a,b,cin,cout);

      #4;
    end

    #10;
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
