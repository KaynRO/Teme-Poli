`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2020 20:46:11
// Design Name: 
// Module Name: impartitor_a
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


module impartitor_a(
    a, a1, a2
    );
    input [23:0]a;
    output [9:0]a1;
    output [12:0]a2;
    assign a1 = a[23:11];
    assign a2 = a[10:1];
endmodule
