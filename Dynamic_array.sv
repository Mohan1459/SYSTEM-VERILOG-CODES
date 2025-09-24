module dynamic_array;
  int dyn_arr[];
  initial begin
    dyn_arr=new[5];
    dyn_arr[0]=2;
    dyn_arr[1]=3;
    dyn_arr[2]=1;
    dyn_arr[3]=5;
    dyn_arr[4]=4;
    foreach(dyn_arr[i])begin
      $display("dynamic_array[%0d]=%0d",i,dyn_arr[i]);
    end
    $display("SIZE OF THE ARRAY=%0d",dyn_arr.size());
    dyn_arr=new[10];
    foreach(dyn_arr[i])begin
      $display("dynamic_array_after[%0d]=%0d",i,dyn_arr[i]);
    end
    $display("size of the array=%0d",dyn_arr.size());
  end
endmodule
