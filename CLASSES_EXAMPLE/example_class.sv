class transaction;
bit [7:0]data;
integer id;

function new(int data, integer id);
this.data=data;
this.id=id;
endfunction
function void display();
$display("Data=%0d,id=%0d",data,id);
endfunction
endclass

module tb;
transaction tr;
initial begin
tr=new(5,4);
tr.display();
end
endmodule 
