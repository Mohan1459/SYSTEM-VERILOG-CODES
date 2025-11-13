class addr_range;
rand bit [3:0]addr;
rand bit [3:0]initial_addr;
rand bit [3:0]final_addr;
constraint c1{!(addr inside {[initial_addr:final_addr]});}
function void display();
$display("INITIAL ADDRESS=%0d | FINAL ADDRESS=%0d | ACTUAL ADDRESS=%0d",initial_addr,final_addr,addr);
endfunction
endclass

module test;
addr_range r;
initial begin
r=new();
repeat(100)begin
r.randomize();
r.display();
end
end
endmodule
