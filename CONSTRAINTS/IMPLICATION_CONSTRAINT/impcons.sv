class packet;
rand bit [3:0]addr;
string range;

constraint c1{(range=="small")->(addr<8);}
endclass
module test;
packet pkt;
initial begin
pkt=new();
pkt.range="small";
repeat(5)begin
pkt.randomize();
$display("address_range=%0s,address=%0d",pkt.range,pkt.addr);
end
end
endmodule
