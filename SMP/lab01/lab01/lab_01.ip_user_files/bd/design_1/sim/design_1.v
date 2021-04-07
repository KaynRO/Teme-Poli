//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Tue Oct 20 13:03:20 2020
//Host        : DESKTOP-U90RVUD running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (clk_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN design_1_clk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_0;

  wire clk_0_1;
  wire core_logic_0_gnt;
  wire [2:0]core_logic_0_st;
  wire graphic_controller_0_inta;
  wire graphic_controller_0_intb;
  wire graphic_controller_0_pipe;
  wire graphic_controller_0_rbf;
  wire graphic_controller_0_req;
  wire graphic_controller_0_sb_stb;
  wire [7:0]graphic_controller_0_sba;
  wire graphic_controller_0_serr;

  assign clk_0_1 = clk_0;
  design_1_core_logic_0_0 core_logic_0
       (.clk(clk_0_1),
        .gnt(core_logic_0_gnt),
        .inta(graphic_controller_0_inta),
        .intb(graphic_controller_0_intb),
        .pipe(graphic_controller_0_pipe),
        .rbf(graphic_controller_0_rbf),
        .req(graphic_controller_0_req),
        .sb_stb(graphic_controller_0_sb_stb),
        .sba(graphic_controller_0_sba),
        .serr(graphic_controller_0_serr),
        .st(core_logic_0_st));
  design_1_graphic_controller_0_0 graphic_controller_0
       (.clk(clk_0_1),
        .gnt(core_logic_0_gnt),
        .inta(graphic_controller_0_inta),
        .intb(graphic_controller_0_intb),
        .pipe(graphic_controller_0_pipe),
        .rbf(graphic_controller_0_rbf),
        .req(graphic_controller_0_req),
        .sb_stb(graphic_controller_0_sb_stb),
        .sba(graphic_controller_0_sba),
        .serr(graphic_controller_0_serr),
        .st(core_logic_0_st));
endmodule
