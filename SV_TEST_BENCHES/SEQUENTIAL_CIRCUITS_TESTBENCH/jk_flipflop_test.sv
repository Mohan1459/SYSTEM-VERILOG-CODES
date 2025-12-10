module jk_ff(
  input clk,
  input rst,
  input j,
  input k,
  output reg q
);
  always@(posedge clk)begin
    if(rst)begin
      q<=1'b0;
    end
    else begin
      case({j,k})
        2'b00:begin
          q<=q;
        end
        2'b01:begin
          q<=1'b0;
        end
        2'b10:begin
          q<=1'b1;
        end
        2'b11:begin
          q<=~q;
        end
        default:begin
          q<=1'b0;
        end
      endcase
    end
  end
endmodule
class transaction;
  randc bit j;
  randc bit k;
       bit q;
  
  function void display(string name);
    $display("-----------------------------------------------------");
    $display("-------------------------%s--------------------------",name);
    $display("j=%0b,k=%0b,q=%0b",j,k,q);
    $display("-----------------------------------------------------");
  endfunction
endclass

class generator;
  mailbox m1;
  transaction tr;
  
  function new(mailbox m1);
    this.m1=m1;
  endfunction
  
  task main();
    repeat(4)begin
    tr=new();
    tr.randomize();
    m1.put(tr);
    tr.display("GENERATOR_SIGNALS");
    end
  endtask
endclass

interface intf(input bit clk);
  logic rst;
  logic j;
  logic k;
  logic q;
  
  clocking drv_cb @(posedge clk);
    default input #1step;
    output j,k;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1step;
    input j,k,q;
  endclocking
  
  modport DRIVER(clocking drv_cb,output rst);
    modport MONITOR(clocking mon_cb);
      modport DUT(input clk,rst,j,k, output q);
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
    
    repeat(4)begin
      m1.get(tr);
      vif.drv_cb.j<=tr.j;
      vif.drv_cb.k<=tr.k;
      @(vif.drv_cb);
      tr.display("DRIVER_SIGNALS");
    end
  endtask
endclass
      
class monitor;
  virtual intf.MONITOR vif;
  mailbox m2;
  transaction tr;
  
  function new(virtual intf.MONITOR vif,mailbox m2);
    this.vif=vif;
    this.m2=m2;
  endfunction
  
  task main();
    repeat(4)begin
      @(vif.mon_cb);
      tr=new();
      m2.put(tr);
      tr.j=vif.mon_cb.j;
      tr.k=vif.mon_cb.k;
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
    bit prev=1'b0;
    bit exp_v;
    
    repeat(4)begin
      m2.get(tr);
      tr.display("SCOREBOARD_SIGNALS");
      case({tr.j,tr.k})
        2'b00:exp_v=prev;
        2'b01:exp_v=1'b0;
        2'b10:exp_v=1'b1;
        2'b11:exp_v=~prev;
      endcase
      if(exp_v==tr.q)begin
        $display("TEST_PASSED");
        $display("EXPECTED_VALUE=%0b,ACTUAL_VALUE=%0b",exp_v,tr.q);
      end
      else begin
        $display("TEST_FAILED");
      end
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
    
    jk_ff g1(.clk(intff.clk),
          .rst(intff.rst),
          .j(intff.j),
          .k(intff.k),
          .q(intff.q)
         );
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  endmodule 

/*class transaction;
  rand bit j;
  rand bit k;
       bit q;
  
  function void display(string name);
    $display("-----------------------------------------------------");
    $display("-------------------------%s--------------------------", name);
    $display("j=%0b, k=%0b, q=%0b", j, k, q);
    $display("-----------------------------------------------------");
  endfunction
endclass

class generator;
  mailbox m1;
  transaction tr;
  
  function new(mailbox m1);
    this.m1 = m1;
  endfunction
  
  task main();
    repeat(2) begin
      tr = new();
      tr.randomize();
      m1.put(tr);
      tr.display("GENERATOR_SIGNALS");
    end
  endtask
endclass

interface intf(input bit clk);
  logic rst;
  logic j;
  logic k;
  logic q;
  
  clocking drv_cb @(posedge clk);
    default input #1step output #0;  // ✅ Fixed
    output j, k;
    input q;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1step;
    input j, k, q;
  endclocking
  
  modport DRIVER(clocking drv_cb, output rst);
  modport MONITOR(clocking mon_cb);
  modport DUT(input clk, rst, j, k, output q);
endinterface
      
class driver;
  virtual intf.DRIVER vif;
  mailbox m1;
  transaction tr;
  
  function new(virtual intf.DRIVER vif, mailbox m1);
    this.vif = vif;
    this.m1 = m1;
  endfunction
  
  task main();
    vif.rst = 1'b1;
    @(vif.drv_cb);
    vif.rst = 1'b0;
    @(vif.drv_cb);
    
    repeat(2) begin
      m1.get(tr);
      vif.drv_cb.j <= tr.j;
      vif.drv_cb.k <= tr.k;
      @(vif.drv_cb);
      tr.display("DRIVER_SIGNALS");
    end
  endtask
endclass
      
class monitor;
  virtual intf.MONITOR vif;
  mailbox m2;
  transaction tr;
  
  function new(virtual intf.MONITOR vif, mailbox m2);
    this.vif = vif;
    this.m2 = m2;
  endfunction
  
  task main();
    repeat(2) begin
      @(vif.mon_cb);
      tr = new();
      tr.j = vif.mon_cb.j;  // Assign BEFORE display
      tr.k = vif.mon_cb.k;
      tr.q = vif.mon_cb.q;
      m2.put(tr);
      tr.display("MONITOR_SIGNALS");
    end
  endtask
endclass
      
class scoreboard;
  mailbox m2;
  transaction tr;
  bit prev_q = 1'b0;  // Store previous q (not prev)
  
  function new(mailbox m2);
    this.m2 = m2;
  endfunction
  
  task main();
    bit exp_v;
    
    repeat(2) begin
      m2.get(tr);
      tr.display("SCOREBOARD_SIGNALS");
      
      // JK flip-flop truth table
      case({tr.j, tr.k})
        2'b00: exp_v = prev_q;      // Hold
        2'b01: exp_v = 1'b0;        // Reset
        2'b10: exp_v = 1'b1;        // Set
        2'b11: exp_v = ~prev_q;     // Toggle
      endcase
      
      if(exp_v == tr.q) begin
        $display("TEST_PASSED");
        $display("EXPECTED_VALUE=%0b, ACTUAL_VALUE=%0b", exp_v, tr.q);
      end
      else begin
        $display("TEST_FAILED");
        $display("Expected: %0b, Got: %0b", exp_v, tr.q);
      end
      
      prev_q = tr.q;  // ✅ Update for next cycle
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
    this.vif = vif;
    m1 = new();
    m2 = new();
    gen = new(m1);
    drv = new(vif, m1);
    mon = new(vif, m2);
    scb = new(m2);
  endfunction
  
  task run();
    fork
      gen.main();
      drv.main();
      mon.main();
      scb.main();
    join
    #50;
    $display("\n[%0t] Simulation complete", $time);
    $finish;
  endtask
endclass
      
program test(intf intff);
  environment env;
  initial begin
    env = new(intff);
    env.run();
  end
endprogram 
      
module tb;
  bit clk;
  
  // Generate clock
  initial clk = 0;
  always #5 clk = ~clk;
  
  // Instantiate interface
  intf intff(clk);
  
  // Instantiate test
  test tst(intff);
  
  // Instantiate JK flip-flop DUT
  jk_ff g1(
    .clk(intff.clk),
    .rst(intff.rst),
    .j(intff.j),
    .k(intff.k),
    .q(intff.q)
  );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end
endmodule*/

