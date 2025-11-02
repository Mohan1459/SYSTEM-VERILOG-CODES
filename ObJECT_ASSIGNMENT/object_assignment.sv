class header;
 int id;
 function new(int id);
 this.id=id;
 endfunction
 
 function display();
 $display("id=%d", id);
 endfunction 
 endclass
 
 class packet;
 int addr;
 int data;
 header h1;
 
 function new(int addr, int data,int id);
 this.addr=addr;
 this.data=data;
 endfunction
 
 function display(string name);
 $display("[%s]  address=%d,data=%d",name,addr,data);
 endfunction
  
 endclass
 
 module shallow_copy;
 packet p1,p2;
 
 initial begin
 p1= new(2,3,1);
 p1.display("p1");
 //p2= new(1,3,2);
 p2=p1;
 p2.addr=20;
 p2.data=30;
 p2.display("p2");
 p1.display("p1");
 end
 endmodule
