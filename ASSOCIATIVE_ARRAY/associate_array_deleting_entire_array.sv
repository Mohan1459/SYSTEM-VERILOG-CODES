module associative_array;
  int ass_arr[int];
  initial begin
    ass_arr[0]=2;
    ass_arr[1]=3;
    ass_arr[2]=1;
    ass_arr[3]=5;
    ass_arr[4]=4;
    ass_arr[5]=7;
    ass_arr[6]=8;
    ass_arr[7]=8;
    ass_arr[8]=6;
    ass_arr[9]=9;
    foreach(ass_arr[i])begin
      $display("associative_array[%0d]=%0d",i,ass_arr[i]);
    end
    $display("number of elements=%0d",ass_arr.num());
    $display("---------------DETLETE_METHOD-----------------");
    ass_arr.delete();
    foreach(ass_arr[i])begin
      $display("associative_array_after_delete_method[%0d]=%0d",i,ass_arr[i]);
    end
  end
endmodule
