class header;
 int id;
 function new(int id);
 this.id=id;
 endfunction
 
 function void display();
 $display("id=%d", id);
 endfunction 
 endclass
 
 class packet;
 int addr;
 int data;
 header h1;
 
 function new(int addr, int data,int id);
 h1=new(id);
 this.addr=addr;
 this.data=data;
 endfunction
 
 function void display(string name);
 $display("[%s] address=%0d,data=%0d,id=%0d",name,addr,data,h1.id);
 endfunction
  
 endclass
 
 module shallow_copy;
 packet p1,p2;
 
 initial begin
 p1= new(2,3,1);
 p1.display("p1");
 p2= new(1,3,2);
 p2.addr=20;
 p2.data=30;
 p2.h1.id=50;
 p1.display("p1");
 p2.display("p2");
 end
 endmodule
 
