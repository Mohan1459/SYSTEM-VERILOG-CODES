
class packet;
  rand int a[];

  constraint c1 {
    a.size() == 10;
  }

  
  constraint c2{
    foreach (a[i]) {
    a[i] inside{[1:100]};
      if (i % 2 == 0)
        a[i] % 2 == 1;   
      else
        a[i] % 2 == 0;   
    }
  };

  function void display();
    foreach (a[i])
      $display("index=%0d  value=%0d", i, a[i]);
  endfunction
endclass


module tb;
  packet pkt;

  initial begin
    pkt = new();
    if (pkt.randomize())
      pkt.display();
    else
      $display("Randomization failed");
  end
endmodule
