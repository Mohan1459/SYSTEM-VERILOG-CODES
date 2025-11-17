
class packet;
  rand bit [3:0]da[];
  rand bit [3:0] a[];
  
  constraint c1{da.size==10;}
  
  constraint c2{foreach(da[i])         // 0102030405
    if(i%2==0)
      da[i]==0;
     else
       da[i]==(i/2)+1;}
  
  constraint c3{ 
    a.size == 10;
    
    foreach(a[i])                 // even num in odd location and odd num in even location 
      
    if(i%2==0)
      a[i]%2 == 1;
    else if(i%2 == 1)
      a[i]%2 == 0; }
                
  function void display();
    $display("da = %p", da);
    $display("a  = %p", a);
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
