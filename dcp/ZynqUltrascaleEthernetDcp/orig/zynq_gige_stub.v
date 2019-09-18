// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Thu Jun 14 15:31:34 2018
// Host        : rdsrv222 running 64-bit Red Hat Enterprise Linux Server release 6.9 (Santiago)
// Command     : write_verilog -force -mode synth_stub
//               /u1/ruckman/build/ZynqUltrascaleEthernetDcp/ZynqUltrascaleEthernetDcp_project.srcs/sources_1/ip/zynq_gige/zynq_gige_stub.v
// Design      : zynq_gige
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu15eg-ffvb1156-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "gig_ethernet_pcs_pma_v16_1_3,Vivado 2018.1" *)
module zynq_gige(gtrefclk, txp, txn, rxp, rxn, resetdone, cplllock, 
  mmcm_reset, txoutclk, rxoutclk, userclk, userclk2, rxuserclk, rxuserclk2, pma_reset, mmcm_locked, 
  independent_clock_bufg, gmii_txclk, gmii_rxclk, gmii_txd, gmii_tx_en, gmii_tx_er, gmii_rxd, 
  gmii_rx_dv, gmii_rx_er, gmii_isolate, mdc, mdio_i, mdio_o, mdio_t, phyaddr, configuration_vector, 
  configuration_valid, status_vector, reset, gtpowergood, signal_detect)
/* synthesis syn_black_box black_box_pad_pin="gtrefclk,txp,txn,rxp,rxn,resetdone,cplllock,mmcm_reset,txoutclk,rxoutclk,userclk,userclk2,rxuserclk,rxuserclk2,pma_reset,mmcm_locked,independent_clock_bufg,gmii_txclk,gmii_rxclk,gmii_txd[7:0],gmii_tx_en,gmii_tx_er,gmii_rxd[7:0],gmii_rx_dv,gmii_rx_er,gmii_isolate,mdc,mdio_i,mdio_o,mdio_t,phyaddr[4:0],configuration_vector[4:0],configuration_valid,status_vector[15:0],reset,gtpowergood,signal_detect" */;
  input gtrefclk;
  output txp;
  output txn;
  input rxp;
  input rxn;
  output resetdone;
  output cplllock;
  output mmcm_reset;
  output txoutclk;
  output rxoutclk;
  input userclk;
  input userclk2;
  input rxuserclk;
  input rxuserclk2;
  input pma_reset;
  input mmcm_locked;
  input independent_clock_bufg;
  output gmii_txclk;
  output gmii_rxclk;
  input [7:0]gmii_txd;
  input gmii_tx_en;
  input gmii_tx_er;
  output [7:0]gmii_rxd;
  output gmii_rx_dv;
  output gmii_rx_er;
  output gmii_isolate;
  input mdc;
  input mdio_i;
  output mdio_o;
  output mdio_t;
  input [4:0]phyaddr;
  input [4:0]configuration_vector;
  input configuration_valid;
  output [15:0]status_vector;
  input reset;
  output gtpowergood;
  input signal_detect;
endmodule
