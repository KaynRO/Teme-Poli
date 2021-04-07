//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Wed Nov  4 00:04:57 2020
//Host        : DESKTOP-U90RVUD running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (clk_0,
    reset_n_0);
  input clk_0;
  input reset_n_0;

  wire clk_0;
  wire reset_n_0;

  design_1 design_1_i
       (.clk_0(clk_0),
        .reset_n_0(reset_n_0));
endmodule
