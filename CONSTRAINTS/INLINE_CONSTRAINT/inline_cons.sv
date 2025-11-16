class packet;
rand bit [3:0]v_1;
rand bit [7:0]v_2;

constraint c1{v_1>10; v_2<100;}
endclass

module test;
packet pkt;
initial begin
pkt=new();
repeat(5)begin
pkt.randomize()with{v_1>4;v_2>30;};
$display("value_1=%0d,value_2=%0d",pkt.v_1,pkt.v_2);
end
end
endmodule
