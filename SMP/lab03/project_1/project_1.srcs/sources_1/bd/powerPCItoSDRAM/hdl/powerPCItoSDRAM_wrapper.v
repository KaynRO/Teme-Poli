//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Wed Dec  2 13:53:11 2020
//Host        : DESKTOP-SG0G1D1 running 64-bit major release  (build 9200)
//Command     : generate_target powerPCItoSDRAM_wrapper.bd
//Design      : powerPCItoSDRAM_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module powerPCItoSDRAM_wrapper
   (CLK_0);
  input CLK_0;

  wire CLK_0;

  powerPCItoSDRAM powerPCItoSDRAM_i
       (.CLK_0(CLK_0));
endmodule
