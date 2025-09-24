// Code your testbench here
// or browse Examples
module queue_array;
  int queue_arr[$];
  int key[$];
  int new_queue[$];
  initial begin
    queue_arr='{2,3,7,9,4,3,1,8,9};
    $display("------------ORIGINAL_QUEUE-------------");
    $display("size of the queue=%0d",queue_arr.size());
    foreach(queue_arr[i])begin
      $display("queue[%0d]=%0d",i,queue_arr[i]);
    end
    $display("------------PUSH_BACK_METHOD-------------");
    queue_arr.push_back(12);
    foreach(queue_arr[i])begin
      $display("queue_after_push_method[%0d]=%0d",i,queue_arr[i]);
    end
    $display("------------PUSH_FRONT_METHOD-------------");
    queue_arr.push_front(0);
    foreach(queue_arr[i])begin
      $display("queue_after_push_method[%0d]=%0d",i,queue_arr[i]);
    end
    $display("------------POP_FRONT_METHOD-------------");
    queue_arr.pop_front();
    foreach(queue_arr[i])begin
      $display("queue_after_pop_method[%0d]=%0d",i,queue_arr[i]);
    end
    $display("------------POP_BACK_METHOD-------------");
    queue_arr.pop_back();
    foreach(queue_arr[i])begin
      $display("queue_after_pop_method[%0d]=%0d",i,queue_arr[i]);
    end
    $display("------------INSERT_METHOD-------------");
    queue_arr.insert(4,12);
    foreach(queue_arr[i])begin
      $display("queue_after_insert_method[%0d]=%0d",i,queue_arr[i]);
    end
    $display("------------DELETE_METHOD-------------");
    queue_arr.delete(9);
    foreach(queue_arr[i])begin
      $display("queue_after_delete_method[%0d]=%0d",i,queue_arr[i]);
    end
    $display("------------SORTING_METHOD-------------");
    queue_arr.sort();
    foreach(queue_arr[i])begin
      $display("queue_after_sorting_method[%0d]=%0d",i,queue_arr[i]);
    end
    $display("------------UNIQUE_METHOD-------------");
    new_queue='{3,5,6,7,9,7,8};
    new_queue.sort();
    new_queue.unique();
    foreach(new_queue[i])begin
      $display("queue_after_unique_method[%0d]=%0d",i,new_queue[i]);
    end
    $display("------------REVERSE_SORTING_METHOD-------------");
    queue_arr.rsort();
    foreach(queue_arr[i])begin
      $display("queue_after_reverse_sorting_method[%0d]=%0d",i,queue_arr[i]);
    end
   $display("------------MAXIMUM_METHOD-------------");
    if (queue_arr.size() > 0) begin
      $display("queue_maximum element = %0d", queue_arr.max());
      $display("After rsort(), max should be first element: queue[0] = %0d", queue_arr[0]);
    end
     $display("------------REVERSE_METHOD-------------");
    queue_arr.reverse();
    foreach(queue_arr[i])begin
      $display("queue_after_reverse_method[%0d]=%0d",i,queue_arr[i]);
    end
    $display("------------SHUFFLE_METHOD-------------");
    queue_arr.shuffle();
    foreach(queue_arr[i])begin
      $display("queue_after_shuffle_method[%0d]=%0d",i,queue_arr[i]);
    end
    key=queue_arr.find with(item % 2==1);
    $display("queue=%p",key);
    $display("queue_sum=%0d",queue_arr.sum());
  end
endmodule

