class packet;
  rand int a[];
  
  constraint c1{a.size()==10;}
  constraint c4{foreach(a[i])
  {
  if(i==0)
   a[i]==1;
   else if(i==1)
   a[i]==1;
   else
   a[i]==a[i-1]+a[i-2];
   }
   }
  
  constraint c3{foreach(a[i])
    a[i]inside{[1:100]};}
    function void display();
      foreach(a[i])
        $display("elements_in_array=%0d,index=%0d",a[i],i);
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
