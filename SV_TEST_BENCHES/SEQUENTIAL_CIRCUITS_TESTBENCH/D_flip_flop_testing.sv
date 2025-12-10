
//DESIGN 
module d_ff(
  input clk,
  input rst,
  input din,
  output reg q
);
  always@(posedge clk)begin
    if(rst)begin
      q<=1'b0;
    end
    else begin
      q<=din;
    end
  end
endmodule 

//TESTBENCH 
class transaction;
  rand bit din;
       bit q;
  
  function void display(string name);
    $display("------------------------------------------------");
    $display("------------------%s--------------------",name);
    $display("input_data=%b,output_data=%b",din,q);
    $display("------------------------------------------------");
  endfunction
endclass

class generator;
  transaction tr;
  mailbox m1;
  
  function new(mailbox m1);
    this.m1=m1;
  endfunction
  
  task main();
    repeat(2)begin
    tr=new();
      tr.randomize();
    m1.put(tr);
    tr.display("GENERATOR SIGNALS");
    end
  endtask
endclass

interface intf(input bit clk);
  logic rst;
  logic din;
  logic q;
  
  clocking drv_cb @(posedge clk);
    default input  #1step;
    output din;
  endclocking 
  
  clocking mon_cb @(posedge clk);
    default input #1step;
    input din,q;
  endclocking 
  modport DRIVER(clocking drv_cb,output rst);
  modport MONITOR(clocking mon_cb);
  modport DUT(input din,rst,clk,output q);    
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
      tr.display("DRIVER_SIGNALS");
      vif.drv_cb.din<=tr.din;
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
    tr.display("MONITOR_SIGNALS");
    tr.din=vif.mon_cb.din;
    tr.q= vif.mon_cb.q;
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
        repeat(2)begin
          m2.get(tr);
          tr.display("SCOREBOARD_SIGNALS");
          if(tr.din)begin
            exp_v=tr.din;
          end
            else begin
              exp_v=1'b0;
            end
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
     m1=new();
     m2=new();
     gen=new(m1);
     drv=new(vif,m1);
     mon=new(vif,m2);
     scb=new(m2);
     this.vif=vif;
  endfunction
 
   task run();
     fork
       gen.main();
       drv.main();
       mon.main();
       scb.main();
       #5;
     join
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
  always #5 clk=~clk;
  intf intff(clk);
  test tst(intff);
  
  d_ff g1(.clk(intff.clk),.rst(intff.rst),.din(intff.din),.q(intff.q));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule 
    
/* class transaction;
  rand bit din;
       bit q;
  
  function void display(string name);
    $display("------------------------------------------------");
    $display("------------------%s--------------------", name);
    $display("input_data=%b, output_data=%b", din, q);
    $display("------------------------------------------------");
  endfunction
endclass

class generator;
  transaction tr;
  mailbox m1;
  
  function new(mailbox m1);
    this.m1 = m1;
  endfunction
  
  task main();
    repeat(2) begin
      tr = new();
      tr.randomize();
      m1.put(tr);
      tr.display("GENERATOR SIGNALS");
    end
  endtask
endclass

interface intf(input bit clk);
  logic rst;
  logic din;
  logic q;
  
  clocking drv_cb @(posedge clk);
    default input #1step output #0;  // ✅ Fixed timing
    output din;
    input q;
  endclocking 
  
  clocking mon_cb @(posedge clk);
    default input #1step;
    input din, q;
  endclocking 
  
  modport DRIVER(clocking drv_cb, output rst);
  modport MONITOR(clocking mon_cb);
  modport DUT(input din, rst, clk, output q);    
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
      tr.display("DRIVER_SIGNALS");
      vif.drv_cb.din <= tr.din;
      @(vif.drv_cb);
    end
  endtask
endclass
    
class monitor;
  mailbox m2;
  virtual intf.MONITOR vif;
  transaction tr;
  
  function new(virtual intf.MONITOR vif, mailbox m2);
    this.vif = vif;
    this.m2 = m2;
  endfunction
  
  task main();
    repeat(2) begin
      @(vif.mon_cb);
      tr = new();
      tr.din = vif.mon_cb.din;  // Assign values
      tr.q = vif.mon_cb.q;
      m2.put(tr);               // ✅ CORRECT: Put transaction, not mailbox!
      tr.display("MONITOR SIGNALS");
    end
  endtask
endclass
    
class scoreboard;
  mailbox m2;
  transaction tr;
  bit prev_din = 1'b0;  // Store previous input
  
  function new(mailbox m2);
    this.m2 = m2;
  endfunction
  
  task main();
    bit exp_v;
    
    repeat(2) begin
      m2.get(tr);
      tr.display("SCOREBOARD_SIGNALS");
      
      // D-FF: q = previous cycle's din
      exp_v = prev_din;
      
      if(exp_v == tr.q) begin
        $display("TEST_PASSED");
        $display("EXPECTED_VALUE=%0b, ACTUAL_VALUE=%0b", exp_v, tr.q);
      end
      else begin
        $display("TEST_FAILED");
        $display("EXPECTED_VALUE=%0b, ACTUAL_VALUE=%0b", exp_v, tr.q);
      end
      
      prev_din = tr.din;  // Update for next cycle
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
  always #5 clk = ~clk;
  
  intf intff(clk);
  test tst(intff);
  
  // D-flipflop module
  d_ff g1(
    .clk(intff.clk),
    .rst(intff.rst),
    .din(intff.din),
    .q(intff.q)
  );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end
endmodule*/
