class pattern10;
  rand int matrix[4][4];
  function void post_randomize();
    int val = 1;
    int top = 0, bottom = 3;
    int left = 0, right = 3;

    while (top <= bottom && left <= right) begin
      for (int j = left; j <= right; j++) begin
        matrix[top][j] = val++;
      end
      top++;
      for (int i = top; i <= bottom; i++) begin
        matrix[i][right] = val++;
      end
      right--;
      for (int j = right; j >= left; j--) begin
        matrix[bottom][j] = val++;
      end
      bottom--;
      for (int i = bottom; i >= top; i--) begin
        matrix[i][left] = val++;
      end
      left++;

    end
  endfunction

  function void display();
    for (int i = 0; i < 4; i++) begin
      for (int j = 0; j < 4; j++) begin
        $write("%4d", matrix[i][j]);
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
