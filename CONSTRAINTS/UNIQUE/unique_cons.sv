class packet;
  rand bit [4:0]da[];
  constraint c1 {da.size==10;}
  constraint c2 {unique{da};}
  function void display();
    $display("array=%p",da);
  endfunction
endclass
module test;
  packet pkt;
  initial begin
    pkt=new();
    pkt.randomize();
    pkt.display();
  end 
endmodule
  
