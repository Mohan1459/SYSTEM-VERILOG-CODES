
//design 

module mux(
  input [7:0]i,
  input [2:0]s,
  output y);
  assign y = s[2] ?
              ( s[1] ?
                    ( s[0] ? i[7] : i[6] ) :
                    ( s[0] ? i[5] : i[4] )
              ) :
              ( s[1] ?
                    ( s[0] ? i[3] : i[2] ) :
                    ( s[0] ? i[1] : i[0] )
              );

  endmodule


//testbench

class transaction;
  rand bit [7:0]i;
  rand bit [2:0]s;
  bit y;
  function void display(string name);
    $display("--------------------------------------");
    $display("input=%0b,selection_line=%3b,output=%b",i,s,y);
    $display("----------------%s---------------------",name);
    $display("---------------------------------------");
  endfunction
endclass

class generator;
  mailbox m1;
  transaction trans;
  
  function new(mailbox m1);
    this.m1=m1;
  endfunction 
  
  task main();
    repeat(2)begin
      trans=new();
      trans.randomize();
      m1.put(trans);
      trans.display("GENERATOR_SIGNALS");  
    end
  endtask
endclass

interface intf();
  logic [7:0]i;
  logic [2:0]s;
  logic y;
endinterface 

class driver;
  virtual intf vif;
  mailbox m1;
  transaction trans;
  
  function new(virtual intf vif, mailbox m1);
    this.vif=vif;
    this.m1=m1;
  endfunction
  
  task main();
    repeat(2)begin
      #1;
    m1.get(trans);
    vif.i<=trans.i;
    vif.s<=trans.s;
    trans.display("DRIVER_SIGNALS");
    end
  endtask
endclass

class monitor;
  mailbox m2;
  virtual intf vif;
  transaction trans;
  
  function new(virtual intf vif,mailbox m2);
    this.vif=vif;
    this.m2=m2;
  endfunction
  
  task main();
    repeat(2)begin
      #1;
    trans=new();
    m2.put(trans);
    trans.i=vif.i;
    trans.s=vif.s;
    trans.y=vif.y;
    trans.display("MONITOR_SIGNALS");
    end
  endtask 
endclass

class scoreboard;
  mailbox m2;
  transaction trans;
  function new(mailbox m2);
    this.m2=m2;
  endfunction
  task main();
    repeat(2)begin
      #1;
      trans=new();
      m2.get(trans);
      trans.display("SCOREBOARD SIGNALS");
      if(trans.y==(
        ((~trans.s[0])&(~trans.s[1]) & (~trans.s[2]) & trans.i[0])|
        ((~trans.s[0])&(~trans.s[1]) & (trans.s[2]) & trans.i[1])|
        ((~trans.s[0])&(trans.s[1]) & (~trans.s[2]) & trans.i[2])|
        ((~trans.s[0])&(trans.s[1]) & (trans.s[2]) & trans.i[3])|
        ((trans.s[0])&(~trans.s[1]) & (~trans.s[2]) & trans.i[4])|
        ((trans.s[0])&(~trans.s[1]) & (trans.s[2]) & trans.i[5])|
        ((trans.s[0])&(trans.s[1]) & (~trans.s[2])& trans.i[6])|
        ((trans.s[0])&(trans.s[1]) & (trans.s[2]) & trans.i[7])
      ))begin
         $display("TEST_PASSED");
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
  virtual intf vif;
  mailbox m1;
  mailbox m2;
 
  
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
  mux g1(.i(intff.i),
         .s(intff.s),
         .y(intff.y)
        );
  initial begin
    $dumpfile("waves.vcd");
    $dumpvars;
  end
endmodule 
