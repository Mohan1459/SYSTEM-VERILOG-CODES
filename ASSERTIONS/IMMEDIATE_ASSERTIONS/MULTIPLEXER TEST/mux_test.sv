module mux
  (
    input [7:0]i,
    input [2:0]s,
    output y
  );
  assign y=s[2]?
    ( s[1]?
             (s[0]?i[7]:i[6])
            : (s[0]?i[5]:i[4])
    )
    :( s[1]?
              (s[0]?i[3]:i[2])
            : (s[0]?i[1]:i[0])
    );
endmodule
module tb;
  reg [7:0]i;
  reg [2:0]s;
  wire y;
  
  mux g1(i,s,y);
  initial begin
    assert(y==i[s])
      $display("assertion passed");
    else
      $display("assertion passed");
  end
endmodule

