// Auto-generated test bench created by VeriLogger Pro at Thu Apr 04 05:01:29 2002

// Timing model is min/max timing.

`timescale 1ns / 1ps

module syncad_top;

parameter tb_stop_time = 1000.000000;


real CLK0_JFall;
real CLK0_JRise;
real CLK0_MaxHL;
real CLK0_MaxLH;
real CLK0_MinHL;
real CLK0_MinLH;
real CLK0_Duty;
real CLK0_Period;
real CLK0_Offset;

task AssignExpressions;
  begin
  CLK0_JFall = 0.0;
  CLK0_JRise = 0.0;
  CLK0_MaxHL = 0.0;
  CLK0_MaxLH = 0.0;
  CLK0_MinHL = 0.0;
  CLK0_MinLH = 0.0;
  CLK0_Duty = 50.0;
  CLK0_Period = 20.0;
  CLK0_Offset = 0.0;
  end
endtask  // AssignExpressions

wire [1:0] tb_status;
reg [1:0] tb_status_driver;
assign tb_status = tb_status_driver;
wire CLK0;

initial
  begin
  AssignExpressions;
  tb_status_driver <= 1'b1;
  #(tb_stop_time)
  $finish;
  end
tb_clock_minmax #(1) tb_CLK0(tb_status[1:0],
                              CLK0,
                              $realtobits(CLK0_Offset),
                              $realtobits(CLK0_Period),
                              $realtobits(CLK0_Duty),
                              $realtobits(CLK0_MinLH),
                              $realtobits(CLK0_MaxLH),
                              $realtobits(CLK0_MinHL),
                              $realtobits(CLK0_MaxHL),
                              $realtobits(CLK0_JRise),
                              $realtobits(CLK0_JFall));

sim sim();
  initial
    begin
    end
endmodule

