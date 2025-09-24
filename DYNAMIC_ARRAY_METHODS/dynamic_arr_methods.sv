module dynamic_array;
  int dyn_arr[];
  initial begin
    dyn_arr=new[10];
    dyn_arr[0]=2;
    dyn_arr[1]=3;
    dyn_arr[2]=1;
    dyn_arr[3]=5;
    dyn_arr[4]=4;
    dyn_arr[5]=7;
    dyn_arr[6]=8;
    dyn_arr[7]=8;
    dyn_arr[8]=6;
    dyn_arr[9]=9;
    foreach(dyn_arr[i])begin
      $display("dynamic_array_after[%0d]=%0d",i,dyn_arr[i]);
    end
    $display("size of the array=%0d",dyn_arr.size());
    $display("-------------REVERSE METHOD--------------");
    dyn_arr.reverse();
    $display("dynamic array sorting elements in reversing order=%p",dyn_arr);
    $display("-------------SORTING METHOD--------------");
    dyn_arr.sort();
    $display("dynamic array sorting elements ascending order=%p",dyn_arr);
    dyn_arr.rsort();
    $display("dynamic array reversesorting elements descending order=%p",dyn_arr);
    $display("-------------SHUFFLE METHOD--------------");
    dyn_arr.shuffle();
    $display("dynamic array sorting elements shuffling order=%p",dyn_arr);
    $display("-------------MAXIMUM METHOD--------------");
    $display("dynamic array maximum element=%p",dyn_arr.max());
    $display("-------------MINIIMUM METHOD--------------");
    $display("dynamic array maximum element=%p",dyn_arr.min());
  end
endmodule
