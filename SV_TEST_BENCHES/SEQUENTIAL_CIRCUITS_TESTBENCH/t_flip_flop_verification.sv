module tff(
  input clk,
  input rst,
  input t,
  output reg  q
);
  always@(posedge clk)begin
    if(rst)begin
      q<=1'b0;
    end
    else if(t)begin
      q<=~q;
    end
    else begin
      q<=1'b0;
    end
  end
endmodule

class transaction;
  rand bit t;
       bit q;
  
  function void display(string name);
    $display("--------------------------------------------------");
    $display("------------------------%s------------------------",name);
    $display("input=%0b,output=%0b",t,q);
    $display("--------------------------------------------------");
  endfunction
endclass

class generator;
  mailbox m1;
  transaction tr;
  
  function new(mailbox m1);
    this.m1=m1;
  endfunction
  
  task main();
    repeat(2)begin
      tr=new();
      m1.put(tr);
      tr.randomize();
      tr.display("GENERATOR_SIGNALS");
    end
  endtask
endclass

interface intf(input bit clk);
logic rst;
logic t;
logic q;

clocking drv_cb @(posedge clk);
  default input #1step output #0;
  output t;
endclocking

clocking mon_cb @(posedge clk);
  default input #1step;
  input rst,t,q;
endclocking

modport DRIVER(clocking drv_cb,output rst);
  modport MONITOR (clocking mon_cb);
    modport DUT(input clk,rst,t,output q);
endinterface
    
class driver;
  virtual intf.DRIVER vif;
  mailbox m1;
  transaction tr;
  function new(virtual intf.DRIVER vif,mailbox m1);
    this.vif=vif;
    this.m1=m1;
  endfunction
  
  task main();
    vif.rst=1'b1;
    @(vif.drv_cb);
    vif.rst=1'b0;
    @(vif.drv_cb);
    
    repeat(2)begin
      m1.get(tr);
      vif.drv_cb.t<=tr.t;
      tr.display("DRIVER_SIGNALS");
      @(vif.drv_cb);
    end
  endtask
endclass
    
    class monitor;
      mailbox m2;
      virtual intf.MONITOR vif;
      transaction tr;
      
      function new(virtual intf.MONITOR vif,mailbox m2);
        this.vif=vif;
        this.m2=m2;
      endfunction
      
      task main();
        repeat(2)begin
          @(vif.mon_cb);
          tr=new();
          m2.put(tr);
          tr.t=vif.mon_cb.t;
          tr.q=vif.mon_cb.q;
          tr.display("MONITOR_SIGNALS");
        end
      endtask
    endclass
    
class scoreboard;
  mailbox m2;
  transaction tr;
  function new(mailbox m2);
    this.m2=m2;
  endfunction
  
  task main();
    bit exp_v;
    bit prev_q=1'b0;
    repeat(2)begin
      tr=new();
      m2.get(tr);
      tr.display("SCOREBOARD_SIGNALS");
      case(tr.t)
        0:begin
          exp_v=prev_q;
        end
        1:begin
          exp_v=~prev_q;
        end
      endcase
        if(exp_v==tr.q)begin
          $display("TEST_PASSED");
          $display("EXPECTED_VALUE=%0b,ACTUAL_VALUE=%0b",exp_v,tr.t);
        end
        else begin
          $display("TEST_FAILED");
        $display("EXPECTED_VALUE=%0b,ACTUAL_VALUE=%0b",exp_v,tr.t);
        end
      exp_v=prev_q;
    end
  endtask
endclass
    
    class environment;
      generator gen;
      driver drv;
      monitor mon;
      scoreboard scb;
      mailbox m1;
      mailbox m2;
      
      virtual intf vif;
      
      function new(virtual intf vif);
        this.vif=vif;
        m1=new();
        m2=new();
        gen=new(m1);
        drv=new(vif,m1);
        mon=new(vif,m2);
        scb=new(m2);
      endfunction
      
      task run();
        fork 
          gen.main();
          drv.main();
          mon.main();
          scb.main();
        join
        #50;
        $finish;
      endtask
    endclass
    
    program test(intf intff);
      environment env;
      initial begin
        env=new(intff);
        env.run();
      end
    endprogram
    
    module tb;
      bit clk;
      initial clk=0;
      always #5clk=~clk;
      intf intff(clk);
      test tst(intff);
      
      tff g1(.clk(intff.clk),
             .rst(intff.rst),
             .t(intff.t),
             .q(intff.q)
            );
      initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,tb);
      end
    endmodule 

