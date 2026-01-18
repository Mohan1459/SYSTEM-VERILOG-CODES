class pattern10;
  rand bit matrix[8][8];   

  function void post_randomize();
    int top = 0, bottom = 7;
    int left = 0, right = 7;
    bit val = 0;     

    while (top <= bottom && left <= right) begin
      for (int j = left; j <= right; j++) begin
        matrix[top][j] = val;
        val = ~val;
      end
      top++;
      for (int i = top; i <= bottom; i++) begin
        matrix[i][right] = val;
        val = ~val;
      end
      right--;
      for (int j = right; j >= left; j--) begin
        matrix[bottom][j] = val;
        val = ~val;
      end
      bottom--;
      for (int i = bottom; i >= top; i--) begin
        matrix[i][left] = val;
        val = ~val;
      end
      left++;

    end
  endfunction

  function void display();
    for (int i = 0; i < 8; i++) begin
      for (int j = 0; j < 8; j++) begin
        $write("%2d", matrix[i][j]);
      end
      $write("\n");
    end
  endfunction
endclass


module tb;
  pattern10 pkt;

  initial begin
    pkt = new();
    pkt.randomize();
    pkt.display();
    #10 $finish;
  end
endmodule
