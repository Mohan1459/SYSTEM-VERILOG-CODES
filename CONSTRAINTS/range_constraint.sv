class range;
rand bit [3:0]addr;
constraint c1{addr<=100;addr>10; addr!=12;}
function void display();
$display("Value of the address=%0d",addr);
endfunction
endclass

module test;
range r;
initial begin
r=new();
repeat(100)begin
r.randomize();
r.display();
end
end
endmodule
