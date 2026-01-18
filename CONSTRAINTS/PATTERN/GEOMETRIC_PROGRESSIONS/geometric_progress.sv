class packet;
  rand int a[];
  rand int r;

  constraint c1 { a.size() == 20; }
  constraint c4 { r inside{[2:3]};}
  constraint c2 {
    foreach (a[i]) {
      if (i == 0)
        a[i] == 1;
      else
        a[i] == a[i-1] *r;
    }
  }

  constraint c3 {
    foreach (a[i])
      a[i] inside {[1:1000000]};
  }

  function void display();
    foreach (a[i])
      $display("a[%0d] = %0d", i, a[i]);
  endfunction
endclass
 module tb;
   packet pkt; 
   initial begin 
     pkt=new();
     pkt.randomize();
     pkt.display();
   end
 endmodule
    

    
    
                
