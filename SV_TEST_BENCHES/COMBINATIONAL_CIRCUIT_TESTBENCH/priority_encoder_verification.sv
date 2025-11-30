//DESIGN 
module priority_encoder(
  input [3:0]i,
  output reg [1:0]y,
  output reg  valid
);
  always@(*)begin
    casez(i)
      4'b1???:begin
        y=2'b11;
        valid=1'b1;
      end
      4'b01??:begin
        y=2'b10;
       valid=1'b1;
      end
      4'b001?:begin
        y=2'b01;
        valid=1'b1;
      end
      4'b0001:begin
        y=2'b00;
        valid=1'b1;
      end
      default:begin
        y=2'b00;
        valid=0;
      end
    endcase
  end
endmodule

//TESTBENCH 
class transaction;
  rand bit [3:0]i;
  bit [1:0]y;
  bit valid;
  
  function void display(string name);
    $display("----------------------------------------------");
    $display("-------------------%s-------------------------",name);
    $display("input=%4b,output=%2b,valid=%b",i,y,valid);
    $display("-----------------------------------------------");
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
        m1.put(tr);
        tr.display("Generator_signals");
        tr.randomize();
      end
    endtask
    
  endclass
  
  interface intf();
    logic [3:0]i;
    logic [1:0]y;
    logic valid;
  endinterface
  
  class driver;
    virtual intf vif;
    mailbox m1;
    
    function new(virtual intf vif,mailbox m1);
      this.vif=vif;
      this.m1=m1;
    endfunction
    
    task main();
      repeat(2)begin
      transaction tr;
      m1.get(tr);
        tr.display("Driver_signals");
        vif.i<=tr.i;
        #2;
      end
    endtask
    
  endclass
  
  class monitor;
    transaction tr;
    mailbox m2;
    virtual intf vif;
    
    function new(virtual intf vif,mailbox m2);
      this.vif=vif;
      this.m2=m2;
    endfunction
    
    task main();
      repeat(2)begin
        #2;
        tr=new();
        m2.put(tr);
        tr.display("Monitor_signals");
        tr.i=vif.i;
        tr.y=vif.y;
        tr.valid=vif.valid;
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
       logic [1:0]expected_v;
        logic expected_valid;
      repeat(2)begin
       #2;
        m2.get(tr);
        tr.display("Scoreboard_signals");
        
        casez(tr.i)
          4'b1???:begin
            expected_v=2'b11;
            expected_valid=1'b1;
          end
          4'b01??:begin
            expected_v=2'b10;
            expected_valid=1'b1;
          end
          4'b001?:begin
            expected_v=2'b01;
            expected_valid=1'b1;
          end
          4'b0001:begin
            expected_v=2'b00;
            expected_valid=1'b1;
          end
          default:begin
            expected_v=2'b00;
            expected_valid=1'b0;
          end
        endcase
        
        if(expected_v==tr.y && expected_valid==tr.valid)begin
          $display("TEST_PASSED");
          $display("EXPECTED_VALUE=%2b,ACTUAL_VALUE=%2b,EXPECTED_VALID=%b,ACTUAL_VALID=%b",expected_v,tr.y,expected_valid,tr.valid);
        end
        else begin
          $display("TEST_FAILED");
        $display("EXPECTED_VALUE=%2b,ACTUAL_VALUE=%2b,EXPECTED_VALID=%b,ACTUAL_VALID=%b",expected_v,tr.y,expected_valid,tr.valid);
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
    priority_encoder g1(.i(intff.i),.y(intff.y),.valid(intff.valid));
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  endmodule 
          
        
        
      
        


    
    
    
  
