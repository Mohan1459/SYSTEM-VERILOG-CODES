class packet;
  rand int a[];
  constraint c1 { a.size() == 10; }
    constraint c_simple {
    foreach (a[i]) {
      a[i]==i*2;
    }
  };
  function void display();
    foreach (a[i]) 
    $display("  a[%0d] = %0d", i, a[i]);
  endfunction
endclass

module tb;
  packet pkt = new();
  
  initial begin
    pkt.a=new[10];
    if( pkt.randomize())
    $display("Randomization passed");
    else
    $display("failed");
    pkt.display();
    
    #10 $finish;
  end
endmodule
