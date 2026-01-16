class packet;
  rand int a[];
  
  constraint c1 { a.size() == 10; }

  constraint c_simple {
    foreach (a[i]) {
      a[i] inside {[0:100]};
    }
  }
  function void post_randomize();
    foreach (a[i]) begin
      if (i % 2 == 0) begin
        if (a[i] % 2 == 0)
         a[i] = a[i] + 1;
      end else begin
        if (a[i] % 2 == 1) a[i] = a[i] + 1;
      end
    end
  endfunction
  function void display();
    $display("Post-randomize method results:");
    foreach (a[i]) $display("  a[%0d] = %0d", i, a[i]);
  endfunction
endclass

module tb;
  packet pkt = new();
  
  initial begin
    pkt.a = new[10];
    if(pkt.randomize()) begin
      $display("Randomization SUCCESSFUL");
      pkt.display();
    end else begin
      $display("Randomization FAILED");
      $fatal("Randomization failed - stopping simulation");
    end
    end
endmodule
