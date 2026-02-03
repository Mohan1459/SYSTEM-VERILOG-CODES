class packet;
  rand int a[];
  rand int b[];
  
  constraint c1{a.size()==10;}
  constraint c2{b.size()==10;}
  constraint c3{foreach(a[i])
    a[i]inside{[1:50]};
               }
  constraint c4{foreach(b[i])
    b[i]inside{[1:50]};
               }
  constraint c5{foreach(a[i])
    if(i<0)
      a[i]>a[i-1];
               }
  constraint c6{foreach(b[i])
    if(i<0)
      b[i]<b[i-1];
               }
  function void display1();
    foreach(a[i])
      $display("ELEMENTS ASCENDING ORDER=%0d",a[i]);
  endfunction
  
  function void display2();
    foreach(b[i])
      $display("ELEMENTS DESCENDING ORDER=%0d",b[i]);
   endfunction
endclass
               
   module tb;
     packet pkt;
     initial begin
       pkt=new();
       pkt.randomize();
       pkt.display1();
       pkt.display2();
     end
   endmodule
       
