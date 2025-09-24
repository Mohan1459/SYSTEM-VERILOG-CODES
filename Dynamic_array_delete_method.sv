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
    dyn_arr[0]=2;
    dyn_arr[1]=3;
    dyn_arr[2]=1;
    dyn_arr[3]=5;
    dyn_arr[4]=4;
    dyn_arr[5]=7;
    dyn_arr[6]=8;
    dyn_arr[7]=11;
    dyn_arr[8]=6;
    dyn_arr[9]=9;
    foreach(dyn_arr[i])begin
      $display("dynamic_array_after[%0d]=%0d",i,dyn_arr[i]);
    end
    $display("size of the array=%0d",dyn_arr.size());
    $display("-------------DELETE_METHOD--------------");
    dyn_arr.delete();
    $display("size of the array_after_deleting the array=%0d",dyn_arr.size());
  end
endmodule
