//Design
module fa(
  input a,
  input b,
  input c,
  output sum,
  output carry
);
  assign sum = a^b^c;
  assign carry= a&b|b&c|c&a;
endmodule


//Test bench 
class transaction;
  rand bit a;
  rand bit b;
  rand bit c;
  bit sum;
  bit carry;

  function void display(string name);
    $display("---------------------%s--------------------------", name);
    $display("a=%0b, b=%0b, c=%0b, sum=%0b, carry=%0b", a, b, c, sum, carry);
    $display("------------------------------------------------");
  endfunction
endclass

class generator;
  transaction trans;
  mailbox gen2drv;
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task main();
    repeat (2) begin
      trans = new();
      trans.randomize();       
      trans.display("generator signals");
      gen2drv.put(trans);        
    end
  endtask
endclass

interface intf();
  logic a;
  logic b;
  logic c;
  logic sum;
  logic carry;
endinterface

class driver;
  virtual intf vif;
  mailbox gen2drv;

  function new(virtual intf vif, mailbox gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task main();
    repeat (2) begin
      transaction trans; 
      gen2drv.get(trans);     
      vif.a = trans.a;
      vif.b = trans.b;
      vif.c = trans.c;
      #1;               
      trans.display("DRIVER SIGNALS");
    end
  endtask
endclass

class monitor;
  virtual intf vif;
  mailbox mon2scb;
  transaction trans;

  function new(virtual intf vif , mailbox mon2scb);
    this.mon2scb = mon2scb;
    this.vif = vif;
  endfunction

  task main();
    repeat (2) begin
      #1;
      trans=new();

      trans.a     = vif.a;
      trans.b     = vif.b;
      trans.c     = vif.c;
      trans.sum   = vif.sum;
      trans.carry = vif.carry;

      trans.display("Monitor signals");

      mon2scb.put(trans);
    end
  endtask
endclass


class scoreboard;
  mailbox mon2scb;
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  task main();
    repeat (2) begin
      transaction trans;
      trans=new();
      mon2scb.get(trans);
      trans.display("SCOREBOARD SIGNALS");
      if(((trans.a^trans.b^trans.c)==trans.sum)&&((trans.a & trans.b)|(trans.b & trans.c) | (trans.a & trans.c==trans.carry)))
        $display("---TEST PASSED----");
      else
        $display("----TEST FAILED----");
      end
  endtask
endclass

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  mailbox mon2scb;
  mailbox gen2drv;
  virtual intf vif;

  function new(virtual intf vif);
    this.vif = vif;
    gen2drv = new();
    mon2scb = new();
    gen = new(gen2drv);
    drv = new(vif, gen2drv);
    mon = new(vif, mon2scb);
    scb = new(mon2scb);
  endfunction

  task run();
    fork
      gen.main();
      drv.main();
      mon.main();
      scb.main();
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
  

module testbench;
  intf intff();
  test tst(intff);
  fa g1(.a(intff.a),
        .b(intff.b),
        .c(intff.c),
        .sum(intff.sum),
        .carry(intff.carry));
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
