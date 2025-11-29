
//Design 


module encoder(
  input [3:0]i,
  output reg [1:0]y
);
  always@(*)begin
    y<=2'b00;
    case(i)
      4'b0001:begin
        y[0]=1'b0;
        y[1]=1'b0;
      end
      4'b0010:begin
        y[0]=1'b1;
        y[1]=1'b0;
      end
      4'b0100:begin
        y[0]=1'b0;
        y[1]=1'b1;
      end
      4'b1000:begin
        y[0]=1'b1;
        y[1]=1'b1;
      end
      default:begin
        y=2'b00;
      end
    endcase
  end
endmodule

//Testbench 
class transaction;
  rand bit[3:0] i;
  bit [1:0] y;
  
  function void display(string name);
    $display("--------------------------------------");
    $display("-------------------%s-------------------", name);
    $display("input=%4b, output=%2b", i, y);
    $display("--------------------------------------");
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

interface intf();
  logic [3:0] i;
  logic [1:0] y;
endinterface 

class driver;
  virtual intf vif;
  mailbox m1;
  transaction tr;
  
  function new(virtual intf vif, mailbox m1);
    this.vif = vif;
    this.m1 = m1;
  endfunction
  
  task main();
    repeat(2) begin
      m1.get(tr);
      tr.display("DRIVER_SIGNALS");
      vif.i = tr.i;
      #1; 
    end
  endtask
endclass

class monitor;
  mailbox m2;
  virtual intf vif;
  transaction tr;
  
  function new(virtual intf vif, mailbox m2);
    this.m2 = m2;
    this.vif = vif;
  endfunction
  
  task main();
    repeat(2) begin
      #1;
      tr = new();
      tr.i = vif.i;
      tr.y = vif.y; 
      m2.put(tr);
      tr.display("MONITOR_SIGNALS");
    end
  endtask
endclass

class scoreboard;
  mailbox m2;
  transaction tr;
  
  function new(mailbox m2);
    this.m2 = m2;
  endfunction
  
  task main();
    logic [1:0] expected_y;
    repeat(2) begin
      m2.get(tr);
      tr.display("SCOREBOARD_SIGNALS");
      
      
      case(tr.i)
        4'b0001:begin 
          expected_y = 2'b00; 
        end
        4'b0010:begin
          expected_y = 2'b01; 
        end
        4'b0100:begin 
          expected_y = 2'b10; 
        end
        
        4'b1000:begin
          expected_y = 2'b11;  
        end
        default:begin
          expected_y = 2'b00;
        end
      endcase
      
      if(expected_y == tr.y) begin
        $display("TEST_PASSED");
        $display("Input %4b correctly encoded to %2b", tr.i, tr.y);
      end else begin
        $display("TEST_FAILED: Expected = %2b, Got = %2b", expected_y, tr.y);
        $display("For input = %4b", tr.i);
      end
      $display("======================================");
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
    #10;
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
  intf intff();
  test tst(intff);
  encoder g1(.i(intff.i), .y(intff.y));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
