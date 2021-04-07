`timescale 1ns / 1ps

module test_1(

    );
    reg clk_0;
    design_1_wrapper top(clk_0);
    
    initial begin
        clk_0 = 0;
    end
    always
        #50 clk_0 = ~clk_0;
    
endmodule
