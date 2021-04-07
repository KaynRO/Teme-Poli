//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Wed Jan 13 14:50:03 2021
//Host        : DESKTOP-SG0G1D1 running 64-bit major release  (build 9200)
//Command     : generate_target PICtoSRAM.bd
//Design      : PICtoSRAM
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "PICtoSRAM,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=PICtoSRAM,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=9,numReposBlks=9,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=9,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "PICtoSRAM.hwdef" *) 
module PICtoSRAM
   (oe_0);
  input oe_0;

  wire [5:0]PIC16F873_0_porta;
  wire [7:0]PIC16F873_0_portb;
  wire [7:0]PIC16F873_0_portc;
  wire T74LS04_0_outt;
  wire [7:0]T74LS373_0_outh;
  wire [7:0]m62256_0_dat;
  wire [7:0]m62256_1_dat;
  wire oe_0_1;
  wire [7:0]select_0_d_out;
  wire splitter1_0_d_out;
  wire [14:0]splitter1_0_d_out2;
  wire splitter2_0_d_out;
  wire splitter3_0_d_out;

  assign oe_0_1 = oe_0;
  PICtoSRAM_PIC16F873_0_0 PIC16F873_0
       (.porta(PIC16F873_0_porta),
        .portb(PIC16F873_0_portb),
        .portbw(select_0_d_out),
        .portc(PIC16F873_0_portc));
  PICtoSRAM_T74LS04_0_0 T74LS04_0
       (.inn(splitter1_0_d_out),
        .outt(T74LS04_0_outt));
  PICtoSRAM_T74LS373_0_0 T74LS373_0
       (.dat(PIC16F873_0_portb),
        .le(splitter2_0_d_out),
        .oe(oe_0_1),
        .outh(T74LS373_0_outh));
  PICtoSRAM_m62256_0_0 m62256_0
       (.adr(splitter1_0_d_out2),
        .ce(T74LS04_0_outt),
        .dat(m62256_0_dat),
        .datw(PIC16F873_0_portb),
        .oe(T74LS04_0_outt),
        .we(splitter3_0_d_out));
  PICtoSRAM_m62256_1_0 m62256_1
       (.adr(splitter1_0_d_out2),
        .ce(splitter1_0_d_out),
        .dat(m62256_1_dat),
        .datw(PIC16F873_0_portb),
        .oe(splitter1_0_d_out),
        .we(splitter3_0_d_out));
  PICtoSRAM_select_0_0 select_0
       (.d_in1(m62256_0_dat),
        .d_in2(m62256_1_dat),
        .d_out(select_0_d_out),
        .not_in(splitter1_0_d_out),
        .oe(splitter3_0_d_out));
  PICtoSRAM_splitter1_0_0 splitter1_0
       (.d_in(PIC16F873_0_portc),
        .d_out(splitter1_0_d_out),
        .d_out2(splitter1_0_d_out2),
        .out_in(T74LS373_0_outh));
  PICtoSRAM_splitter2_0_0 splitter2_0
       (.d_in(PIC16F873_0_porta),
        .d_out(splitter2_0_d_out));
  PICtoSRAM_splitter3_0_0 splitter3_0
       (.d_in(PIC16F873_0_porta),
        .d_out(splitter3_0_d_out));
endmodule
