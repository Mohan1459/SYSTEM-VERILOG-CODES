 virtual class parent;
 pure virtual function void display();

endclass
class A extends parent;
function void display();
$display("CLASS A");
endfunction 
endclass

class B extends parent;
function void display();
$display("CLASS B");
endfunction
endclass

class C extends parent;
function void display();
$display("CLASS C");
endfunction
endclass

module test;
parent p;
A a;
B b;
C c;
initial begin
a=new();
b=new();
c=new();
p=a;
p.display();
p=b;
p.display();
p=c;
p.display();
end
endmodule
