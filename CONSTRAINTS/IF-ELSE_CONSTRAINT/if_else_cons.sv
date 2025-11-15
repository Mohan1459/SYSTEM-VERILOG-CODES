class packet;
rand bit [6:0]addr;
rand bit [2:0]mode;
constraint c1{if(mode==1)
                {addr inside{[10:15]}};
                else if(mode==2)
                {addr inside{[16:31]}};
                else
                {addr inside{[32:49]}};
                }
endclass

module test;
packet pkt;
initial begin 
pkt=new();
repeat(10)begin
pkt.randomize();
$display("mode of operation=%0d,address_value=%0d",pkt.mode,pkt.addr);
$display("--------------------------------------------");
pkt.randomize();
$display("mode of operation=%0d,address_value=%0d",pkt.mode,pkt.addr);
end
end
endmodule               
