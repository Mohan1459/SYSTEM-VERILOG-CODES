class packet;
  rand bit [2:0]arr[];
  
  constraint c1{arr.size()==10;}
  
  
  constraint c2{foreach(arr[i])
    arr[i] inside{[0:10]};}
  
  constraint c3{foreach(arr[i])
    arr[i]==(i+2)/2;
            }
  function void display();
    foreach(arr[i])
      $display("elements=%0d",arr[i]);
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
