//DESIGN
module demux(
  input i,
  input [2:0]s,
  output reg [7:0]y
);
  always@(*)begin
    y=8'b00000000;
  case(s)
      3'b000:begin
        y[0]=i;
      end
      3'b001:begin
        y[1]=i;
      end
      3'b010:begin
        y[2]=i;
      end
      3'b011:begin
        y[3]=i;
      end
      3'b100:begin
        y[4]=i;
      end
      3'b101:begin
        y[5]=i;
      end
      3'b110:begin
        y[6]=i;
      end
      3'b111:begin
        y[7]=i;
      end
    endcase
  end
endmodule 


//SV_TESTBENCH 

class transaction;
  rand bit i;
  rand bit [2:0]s;
  bit [7:0]y;
 
  function void display(string name);
    $display("---------------------------------------------");
    $display("input=%0b,selection_line=%3b,output=%8b",i,s,y);
    $display("---------------------%s----------------------",name);
    $display("---------------------------------------------");
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
      tr.randomize();
      m1.put(tr);
      tr.display("Generator signals");
    end
  endtask
endclass

interface intf();
  logic i;
  logic [2:0]s;
  logic [7:0]y;
endinterface

class driver;
  mailbox m1;
  virtual intf vif;
  
  function new(virtual intf vif, mailbox m1);
    this.vif=vif;
    this.m1=m1;
  endfunction
  
  task main();
    repeat(2)begin
    transaction tr;
    m1.get(tr);
    tr.display("DRIVER_SIGNALS");
    vif.i=tr.i;
    vif.s=tr.s;
      #1;
    end
  endtask
endclass

class monitor;
  virtual intf vif;
  mailbox m2;
  transaction tr;
  
  function new(virtual intf vif,mailbox m2);
    this.vif=vif;
    this.m2=m2;
  endfunction
  
  task main();
    repeat(2)begin
      #2;
    tr=new();
    m2.put(tr);
    tr.i=vif.i;
    tr.s=vif.s;
    tr.y=vif.y;
    tr.display("MOnitor_signals");
      #2;
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
    logic [7:0]expected_v=8'b00000000;
    repeat(2)begin
      #1;
      m2.get(tr);
      tr.display("SCOREBOARD_SIGNALS");
      case(tr.s)
        3'b000:begin
          expected_v[0]=tr.i;
        end
        3'b001:begin
          expected_v[1]=tr.i;
        end
         3'b010:begin
           expected_v[2]=tr.i;
        end
         3'b011:begin
           expected_v[3]=tr.i;
        end
         3'b100:begin
           expected_v[4]=tr.i;
        end
         3'b101:begin
           expected_v[5]=tr.i;
        end
         3'b110:begin
           expected_v[6]=tr.i;
        end
         3'b111:begin
           expected_v[7]=tr.i;
        end
      endcase
      if(tr.y==expected_v)begin
        $display("TEST_PASSED");
        $display("EXPECTED_VALUE=%8b,ACTUAL_VALUE=%8b",expected_v,tr.y);
      end
      else begin
        $display("TEST_FAILED");
        $display("EXPECTED_VALUE=%8b,ACTUAL_VALUE=%8b",expected_v,tr.y);
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
  demux g1(.i(intff.i),.s(intff.s),.y(intff.y));
  initial begin
    $dumpfile("waves.vcd");
    $dumpvars;
  end
endmodule 

        

