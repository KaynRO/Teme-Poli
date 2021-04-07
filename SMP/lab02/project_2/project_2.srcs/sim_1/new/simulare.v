`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2020 23:58:36
// Design Name: 
// Module Name: simulare
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module simulare();
        reg clk;
        reg reset;
        design_1_wrapper lab2(clk, reset);
        
        initial begin
            clk = 0;
            reset = 1;
            #100 reset = 0;
            #100 reset = 1;
        end
        always
            #50 clk = ~clk;
endmodule
