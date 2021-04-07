//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Wed Nov  4 00:04:57 2020
//Host        : DESKTOP-U90RVUD running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=11,numReposBlks=11,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=11,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (clk_0,
    reset_n_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN design_1_clk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_N_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_N_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input reset_n_0;

  wire clk_0_1;
  wire decoder_0_o;
  wire gateand_0_c;
  wire gateand_1_c;
  wire gateand_2_c;
  wire gatenegare_0_b;
  wire gateor_0_c;
  wire [9:0]impartitor_a_0_a1;
  wire [12:0]impartitor_a_0_a2;
  wire [7:0]impartitor_d_0_d1;
  wire [7:0]impartitor_d_0_d2;
  wire [23:0]mc68000_0_a;
  wire mc68000_0_as_n;
  wire [15:0]mc68000_0_d;
  wire mc68000_0_lds_n;
  wire mc68000_0_rw_n;
  wire mc68000_0_uds_n;
  wire reset_n_0_1;

  assign clk_0_1 = clk_0;
  assign reset_n_0_1 = reset_n_0;
  design_1_decoder_0_0 decoder_0
       (.address(impartitor_a_0_a1),
        .o(decoder_0_o));
  design_1_gateand_0_0 gateand_0
       (.a(mc68000_0_as_n),
        .b(mc68000_0_rw_n),
        .c(gateand_0_c));
  design_1_gateand_0_1 gateand_1
       (.a(mc68000_0_lds_n),
        .b(decoder_0_o),
        .c(gateand_1_c));
  design_1_gateand_0_2 gateand_2
       (.a(mc68000_0_uds_n),
        .b(decoder_0_o),
        .c(gateand_2_c));
  design_1_gatenegare_0_0 gatenegare_0
       (.a(mc68000_0_rw_n),
        .b(gatenegare_0_b));
  design_1_gateor_0_0 gateor_0
       (.a(gateand_1_c),
        .b(gateand_2_c),
        .c(gateor_0_c));
  design_1_impartitor_a_0_0 impartitor_a_0
       (.a(mc68000_0_a),
        .a1(impartitor_a_0_a1),
        .a2(impartitor_a_0_a2));
  design_1_impartitor_d_0_0 impartitor_d_0
       (.d(mc68000_0_d),
        .d1(impartitor_d_0_d1),
        .d2(impartitor_d_0_d2));
  design_1_mc68000_0_0 mc68000_0
       (.a(mc68000_0_a),
        .as_n(mc68000_0_as_n),
        .berr_n(1'b0),
        .bgack_n(1'b0),
        .br_n(1'b0),
        .clk(clk_0_1),
        .d(mc68000_0_d),
        .dtack_n(gateor_0_c),
        .ip_n({1'b0,1'b0,1'b0}),
        .lds_n(mc68000_0_lds_n),
        .reset_n(reset_n_0_1),
        .rw_n(mc68000_0_rw_n),
        .uds_n(mc68000_0_uds_n),
        .vpa_n(1'b0));
  design_1_ram8kx8_0_0 ram8kx8_0
       (.a(impartitor_a_0_a2),
        .cs_n(gateand_1_c),
        .d(impartitor_d_0_d1),
        .oe_n(gatenegare_0_b),
        .rw_n(gateand_0_c));
  design_1_ram8kx8_1_0 ram8kx8_1
       (.a(impartitor_a_0_a2),
        .cs_n(gateand_2_c),
        .d(impartitor_d_0_d2),
        .oe_n(gatenegare_0_b),
        .rw_n(gateand_0_c));
endmodule
