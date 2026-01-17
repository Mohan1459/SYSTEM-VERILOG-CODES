class packet;
  rand int a[];
  
  constraint c1{a.size()==10;}
  constraint c2{foreach(a[i])
  {
    if(i==0)
      a[i]==1;
    else if(i<1)
    a[i]==1;
    else if(i<3)
      a[i]==2;
    else if(i<6)
      a[i]==3;
    else 
      a[i]==4;
  }
               }
  function void display();
    foreach(a[i])begin
    $display("pyramidvalues=%0p,position=%0d",a[i],i);
    end
  endfunction
endclass
                
  module tb;
    packet pkt;
    
    initial begin
      pkt=new();
      pkt.a=new[10];
      pkt.randomize();
      pkt.display();
    end
  endmodule 
      
