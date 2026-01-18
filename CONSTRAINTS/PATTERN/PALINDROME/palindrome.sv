class packet;
  rand int a[];
  
  constraint c1{a.size()==30;}
  constraint c2{foreach(a[i])
  {
    if(i>(a.size())/2)
      a[i]==a[a.size()-1-i];
  }
               }
    constraint c3{foreach(a[i])
      a[i]inside{[1:100]};
                 }
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
                
                
