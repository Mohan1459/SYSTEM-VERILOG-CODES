//design 
module demux
  (
    input i,
    input [2:0]s,
    output reg [7:0]y
  );
  always_comb begin
    case(s)
      3'b000:begin
        y[0]=1'b1;
      end
      3'b001:begin
        y[1]=1'b1;
      end
      3'b010:begin
        y[2]=1'b1;
      end
      3'b011:begin
        y[3]=1'b1;
      end
      3'b100:begin
        y[4]=1'b1;
      end
      3'b101:begin
        y[5]=1'b1;
      end
      3'b110:begin
        y[6]=1'b1;
      end
      3'b111:begin
        y[7]=1'b1;
      end
    endcase
  end
endmodule
//Verification testbench code
module tb;
  reg i;
  reg [2:0]s;
  wire [7:0]y;
  
  demux g1(i,s,y);
  initial begin
    assert(y==i<<s)
      $display("assertion passed");
    else
      $display("assertion passed");
  end
endmodule
