module sr_ff(
  input s,
  input r,
  input clk,
  input rst,
  output reg q
);
  always@(posedge clk)begin
    if(rst)begin
      q<=1'b0;
    end
    else begin
      case({s,r})
        2'b00:begin
          q<=q;
        end
        2'b01:begin
          q<=0;
        end
        2'b10:begin
          q<=1;
        end
        2'b11:begin
          q<=1'b0;
        end
      endcase
    end
  end
endmodule


class transaction;
      rand bit s;
  rand bit r;
       bit q;
  function void display(string name);
    $display("--------------------------------");
    $display("-------------%s---------------", name);
    $display("s=%0b, r=%0b, q=%0b", s, r, q);
    $display("---------------------------------");
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
      tr.display("GENERATOR SIGNALS");
      m1.put(tr);
    end
  endtask
endclass

interface intf(input bit clk);
  logic rst;
  logic s;
  logic r;
  logic q;
  clocking drv_cb @(posedge clk);
    default input #1step;
    output s, r;
    input q, rst;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1step;
    input s, r, q, rst;
  endclocking
  
  modport DRIVER (clocking drv_cb, output rst);
  modport MONITOR (clocking mon_cb);
  modport DUT (input clk, rst, s, r, output q);
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
      vif.drv_cb.s <= tr.s;
      vif.drv_cb.r <= tr.r;
      @(vif.drv_cb);
    end
  endtask
endclass

class monitor;
  virtual intf.MONITOR vif;
  mailbox m2;
  transaction tr;
  
  function new(virtual intf.MONITOR vif, mailbox m2);
    this.m2 = m2;
    this.vif = vif;
  endfunction
  
  task main();
    repeat(2) begin
      @(vif.mon_cb); 
      tr = new();
      tr.s = vif.mon_cb.s;  
      tr.r = vif.mon_cb.r;
      tr.q = vif.mon_cb.q;
      m2.put(tr);
      tr.display("MONITOR SIGNALS");
    end
  endtask
endclass

class scoreboard;
  mailbox m2;
  bit prev_q = 1'b0;
  
  function new(mailbox m2);
    this.m2 = m2;
  endfunction
  
  task main();
    transaction tr;
    bit expected_q;
    
    repeat(2) begin
      m2.get(tr);
      tr.display("SCOREBOARD_SIGNALS");
      
      case({tr.s, tr.r})
        2'b00: expected_q = prev_q; 
        2'b01: expected_q = 1'b0;    
        2'b10: expected_q = 1'b1;    
        2'b11: expected_q = 1'b0;    
      endcase
      
      if (expected_q == tr.q) begin
        $display("TEST_PASSED");
      end else begin
        $display("TEST_FAILED: Expected q=%b, Got q=%b", expected_q, tr.q);
      end
      
      prev_q = tr.q;  
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
    drv = new(vif, m1);      // vif.DRIVER
    mon = new(vif, m2);      // vif.MONITOR
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


module testbench;
  bit clk;
  always #5 clk = ~clk;
  intf intff(clk);
  test tst(intff);
  
  sr_ff g1(
    .clk(intff.clk),
    .rst(intff.rst),
    .s(intff.s),
    .r(intff.r),
    .q(intff.q)
  );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
  end
endmodule    
