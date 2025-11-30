//DESIGN 
module decoder(
  input [2:0]i,
  output reg [7:0]y
);
  always@(*)begin
    case(i)
      3'b000:begin
        y=8'b00000001;
      end
      3'b001:begin
        y=8'b00000010;
      end
      3'b010:begin
        y=8'b00000100;
      end
      3'b011:begin
       y=8'b00001000;
      end
      3'b100:begin
         y=8'b00010000;
      end
      3'b101:begin
        y=8'b00100000;
      end
      3'b110:begin
        y=8'b01000000;
      end
      3'b111:begin
       y=8'b10000000;
      end
      default:begin
        y=8'b00000000;
      end
    endcase
  end
endmodule

//TEST BENCH 
class transaction;
  rand bit[2:0]i;
  bit [7:0]y;
  
  function void display(string name);
    $display("-------------------------------------");
    $display("------------------%s--------------------",name);
    $display("input=%3b,output=%7b",i,y);
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
      tr.display("GENERATOR_SIGNALS");
    end
  endtask
  
endclass

interface intf();
  logic [2:0]i;
  logic [7:0]y;
endinterface

class driver;
  virtual intf vif;
  mailbox m1;
  transaction tr;
  function new(virtual intf vif,mailbox m1);
    this.vif=vif;
    this.m1=m1;
  endfunction
  
  task main();
    repeat(2)begin
      m1.get(tr);
      vif.i<=tr.i;
      #2;
      tr.display("DRIVER_SIGNALS");
    end
  endtask
  
endclass

class monitor;
  virtual intf vif;
  mailbox m2;
  transaction tr;
  
  function new(virtual intf vif, mailbox m2);
  this.vif=vif;
  this.m2=m2;
  endfunction
  
  task main();
    repeat(2)begin
      #2;
      tr=new();
      m2.put(tr);
      tr.i=vif.i;
      tr.y=vif.y;
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
    logic [7:0]expected_v;
    repeat(2)begin
      m2.get(tr);
      tr.display("SCOREBOARD_SIGNALS");
      case(tr.i)
        3'b000:begin
          expected_v=8'b00000001;
        end
         3'b001:begin
           expected_v=8'b00000010;
         end 
        3'b010:begin
          expected_v=8'b00000100;
        end
         3'b011:begin
           expected_v=8'b00001000;
        end
         3'b100:begin
           expected_v=8'b00010000;
        end
         3'b101:begin
           expected_v=8'b00100000;
        end
         3'b110:begin
           expected_v=8'b01000000;
        end
         3'b111:begin
           expected_v=8'b10000000;
        end
        default:begin
          expected_v=8'b0000000;
        end
      endcase
      if(expected_v==tr.y)begin
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

module test_top;
  intf intff();
  test tst(intff);
  decoder g1(.i(intff.i),.y(intff.y));
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
    
    
