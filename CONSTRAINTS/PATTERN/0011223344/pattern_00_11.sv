class packet;
  rand int arr[];

  constraint c1 { arr.size() == 10; }

  constraint c2 {
    foreach (arr[i]) 
      arr[i]==i/2;      
  }
  
  function void display();
    foreach (arr[i])
      $display("arr[%0d] = %0d", i, arr[i]);
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
