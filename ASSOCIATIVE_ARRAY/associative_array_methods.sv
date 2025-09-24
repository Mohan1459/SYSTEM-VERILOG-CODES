
module associative_array;
  int ass_arr[int];
  int key;
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
    $display("---------------EXIST_METHOD-----------------");
    if(ass_arr.exists(1))begin;
      $display("the given index is present");
    end
    else begin
      $display("the given index is not present");
    end
    $display("---------------FIRST_KEY_METHOD-----------------");
    ass_arr.first(key);
    $display("the first key is=%0d",key);
    $display("---------------LAST_KEY_METHOD-----------------");
    ass_arr.last(key);
    $display("the last key is=%0d",key);
    $display("---------------NEXT_KEY_METHOD-----------------");
    key=4;
    ass_arr.next(key);
    $display("the next key is=%0d",key);
    $display("---------------PREVIOUS_KEY_METHOD-----------------");
    key=6;
    ass_arr.prev(key);
    $display("the previous key is=%0d",key);
    end
endmodule

