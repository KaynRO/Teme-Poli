`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2020 20:40:51
// Design Name: 
// Module Name: impartitor_d
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


module impartitor_d(
    d, d1, d2
    );
    input [15:0]d;
    output [7:0]d1;
    output [7:0]d2;
    assign d1 = d[15:8];
    assign d2 = d[7:0];
endmodule
