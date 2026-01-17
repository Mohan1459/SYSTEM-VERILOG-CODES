class packet;
  rand int a[$];
  
  constraint c1{a.size()==100;}
  constraint c2{foreach(a[i])
  {
    if(i>1  && !((i%2==0 && i!=2) || (i%3==0 && i!=3) || (i%5==0 && i!=5) || (i%7==0 && i!=7)))
      a[i]==i;
    else
      a[i]==2;
  }
               }
    function void post_randomize();
    a=a.unique();
    endfunction
    function void display();
      foreach(a[i])
     $display("elements_in_array=%0p,index=%0d",a[i],i);
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
