//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Wed Dec  2 13:49:28 2020
//Host        : DESKTOP-SG0G1D1 running 64-bit major release  (build 9200)
//Command     : generate_target powerPCItoSDRAM.bd
//Design      : powerPCItoSDRAM
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "powerPCItoSDRAM,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=powerPCItoSDRAM,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=5,numReposBlks=5,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=5,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "powerPCItoSDRAM.hwdef" *) 
module powerPCItoSDRAM
   (CLK_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN powerPCItoSDRAM_CLK_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input CLK_0;

  wire CLK_0_1;
  wire chip_select_splitter_0_b;
  wire [0:7]data_splitter_0_d_out;
  wire mpc106fsm_0_AACK;
  wire mpc106fsm_0_ARTRY;
  wire mpc106fsm_0_BG0;
  wire [0:7]mpc106fsm_0_CS;
  wire mpc106fsm_0_DBG0;
  wire mpc106fsm_0_SDCAS;
  wire [0:11]mpc106fsm_0_SDMA;
  wire mpc106fsm_0_SDRAS;
  wire mpc106fsm_0_TA;
  wire mpc106fsm_0_WE;
  wire [0:31]powerpcfsm_0_A;
  wire powerpcfsm_0_BR;
  wire [0:31]powerpcfsm_0_DH;
  wire [0:31]powerpcfsm_0_DL;
  wire powerpcfsm_0_TBST;
  wire powerpcfsm_0_TS;
  wire [0:2]powerpcfsm_0_TSIZ;
  wire powerpcfsm_0_WT;

  assign CLK_0_1 = CLK_0;
  powerPCItoSDRAM_chip_select_splitter_0_0 chip_select_splitter_0
       (.a(mpc106fsm_0_CS),
        .b(chip_select_splitter_0_b));
  powerPCItoSDRAM_data_splitter_0_0 data_splitter_0
       (.d_in(powerpcfsm_0_DH),
        .d_out(data_splitter_0_d_out));
  powerPCItoSDRAM_mpc106fsm_0_0 mpc106fsm_0
       (.A(powerpcfsm_0_A),
        .AACK(mpc106fsm_0_AACK),
        .ARTRY(mpc106fsm_0_ARTRY),
        .BG0(mpc106fsm_0_BG0),
        .BR0(powerpcfsm_0_BR),
        .CLK(CLK_0_1),
        .CS(mpc106fsm_0_CS),
        .DBG0(mpc106fsm_0_DBG0),
        .DH(powerpcfsm_0_DH),
        .DL(powerpcfsm_0_DL),
        .SDCAS(mpc106fsm_0_SDCAS),
        .SDMA(mpc106fsm_0_SDMA),
        .SDRAS(mpc106fsm_0_SDRAS),
        .TA(mpc106fsm_0_TA),
        .TBST(powerpcfsm_0_TBST),
        .TS(powerpcfsm_0_TS),
        .TSIZ(powerpcfsm_0_TSIZ),
        .WE(mpc106fsm_0_WE),
        .WT(powerpcfsm_0_WT));
  powerPCItoSDRAM_mx9_sdramfsm_0_0 mx9_sdramfsm_0
       (.A(mpc106fsm_0_SDMA),
        .CAS(mpc106fsm_0_SDCAS),
        .CLK(CLK_0_1),
        .CS(chip_select_splitter_0_b),
        .DQ(data_splitter_0_d_out),
        .RAS(mpc106fsm_0_SDRAS),
        .WE(mpc106fsm_0_WE));
  powerPCItoSDRAM_powerpcfsm_0_0 powerpcfsm_0
       (.A(powerpcfsm_0_A),
        .AACK(mpc106fsm_0_AACK),
        .ARTRY(mpc106fsm_0_ARTRY),
        .BG(mpc106fsm_0_BG0),
        .BR(powerpcfsm_0_BR),
        .CLK(CLK_0_1),
        .DBG(mpc106fsm_0_DBG0),
        .DH(powerpcfsm_0_DH),
        .DL(powerpcfsm_0_DL),
        .TA(mpc106fsm_0_TA),
        .TBST(powerpcfsm_0_TBST),
        .TS(powerpcfsm_0_TS),
        .TSIZ(powerpcfsm_0_TSIZ),
        .WT(powerpcfsm_0_WT));
endmodule
