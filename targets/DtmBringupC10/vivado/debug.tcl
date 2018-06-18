##############################################################################
## This file is part of 'RCE Development Firmware'.
## It is subject to the license terms in the LICENSE.txt file found in the 
## top-level directory of this distribution and at: 
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
## No part of 'RCE Development Firmware', including this file, 
## may be copied, modified, propagated, or distributed except according to 
## the terms contained in the LICENSE.txt file.
##############################################################################
set RUCKUS_DIR $::env(RUCKUS_DIR)
set IMAGENAME  $::env(IMAGENAME)
source -quiet ${RUCKUS_DIR}/vivado_env_var.tcl
source -quiet ${RUCKUS_DIR}/vivado_proc.tcl

## Open the run
open_run synth_1

# Get a list of nets
set netFile ${PROJ_DIR}/net_log.txt
set fd [open ${netFile} "w"]
set nl ""

append nl [get_nets {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/*}]

regsub -all -line { } $nl "}\nConfigProbe \${ilaName} {" nl
puts $fd $nl
close $fd

## Setup configurations
set ilaName u_ila_0

## Create the core
CreateDebugCore ${ilaName}

## Set the record depth
set_property C_DATA_DEPTH 1024 [get_debug_cores ${ilaName}]
#set_property C_EN_STRG_QUAL true [get_debug_cores ${ilaName}]
#set_property C_INPUT_PIPE_STAGES 3 [get_debug_cores ${ilaName}]
#set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores ${ilaName}]

SetDebugCoreClk ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/aclk}

ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/C[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/L[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/R[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/addrstreampipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/badreadreq}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/blk_bus_number[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/blk_dcontrol[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/cplcounter[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/cpldsplitcounttemp[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/cpldsplitsm[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/cplndstatuscode[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/cplndtargetpipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/cplpendcpl[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/cpltargetpipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/ctargetpipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/ctlpbytecounttemp[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/data4[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/dis_rden}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/dout[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/empty}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/m_axis_cc_tdata[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/m_axis_cc_tdata_h[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/m_axis_cc_tlast}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/m_axis_cc_tready}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/m_axis_cc_tvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/m_axis_cc_tvalid_d}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/m_axis_cc_tvalid_nd}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/master_wr_idle}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/orrdreqpipeline[0]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/orrdreqpipeline[1]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/orrdreqpipeline[2]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/p_1_out[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/p_3_out0_in[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/p_3_out[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/p_6_in[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/rd_en}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/rdreq}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/requesteridsig[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/reset}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/rrespdelayed}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/rth_debug_mv[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/rth_debug_sel}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/s_axis_cr_tvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/slv_write_idle}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/tlpbytecount[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/tlplengthsig[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/tlpndbytecount3_out[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/tlpndtc}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/tlprequesterid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/tlptcsig[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/totallength[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/wrreqpend[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_s_masterbridge_rd/data_phase}

ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/AddrVar[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/aclk}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/addrmmpipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/addrspipeline1}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/addrspipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/almost_full}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/barhit[0][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/barhit[1][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/barhit[2][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/barhit[3][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/compready[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/databeat1}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/dataen}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/datammpipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/datatxpertlp[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/din[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/firstdwen}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_araddr1[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_araddr2[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_araddr3[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_araddr4[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_araddr[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arburst[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arcache[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arlen1[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arlen2[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arlen3[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arlen4[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arlen[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arlock}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arsize0[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_arvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_rdata[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_rdatatemp128[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_rdatatemp64[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_rlast}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_rready}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_rresp[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/m_axi_rvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/master_int[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/master_wr_idle}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rdaddrsmsig}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rdaddrsmsig0}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rdaddrsmsig1}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rddatasmsig}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rdreq}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rdtargetpipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/reset}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rresp[0][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rresp[1][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rresp[3][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/rrespsig[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/s_axi_awvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/single_beat}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/slwrreqpend[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/slwrreqpending[0][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/slwrreqpending[1][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/slwrreqpending[2][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/slwrreqpending[3][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/splitcnt[0]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/tlpaddrl[0][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/tlpaddrl[1][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/tlpaddrl[2][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/tlpaddrl[3][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/tlplength[0][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/tlplength[1][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/tlplength[2][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/comp_axi_mm_masterbridge_rd/tlplength[3][*]}

ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/almost_fullsig}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/axi_aresetn}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/compready[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/cplpendcpl[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/dataensig}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/dinsig[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/doutsig[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/emptysig}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_araddr[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_arburst[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_arcache[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_arlen[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_arlock}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_arprot[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_arready}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_arsize[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_arvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_rdata[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_rlast}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_rready}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_rresp[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axi_rvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axis_cc_tdata[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axis_cc_tlast}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axis_cc_tready}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axis_cc_tstrb[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axis_cc_tuser[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axis_cc_tvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axis_cr_tdata[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axis_cr_tstrb[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/m_axis_cr_tuser[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/orcplpipeline_reg[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/orrdreqpipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/rdreq}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/rdtargetpipeline_out[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/rrespsig[0]_8[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/rrespsig[1]_7[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/rrespsig[2]_6[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/rrespsig[3]_5[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/s_axi_awvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/s_axis_cr_tready}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/s_axis_cr_tvalid}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/s_axis_tx_tdata_d_reg[55][9]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/sig_addrstreampipeline[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/slv_write_idle}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/slwrreqcompsig[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/tlpaddrlsig[0]_24[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/tlpaddrlsig[1]_23[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/tlpaddrlsig[2]_22[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/tlpaddrlsig[3]_21[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/tlplengthsig[0]_20[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/tlplengthsig[1]_19[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/tlplengthsig[2]_18[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/tlplengthsig[3]_17[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/wrpending[0]_16[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/wrpending[1]_15[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/wrpending[2]_14[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/wrpending[3]_13[*]}
ConfigProbe ${ilaName} {U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_pcie_mm_s/comp_AXI_MM_S_MasterBridge/comp_axi_mm_s_masterbridge_rd/wrreqcomp[*]}

## Delete the last unused port}
delete_debug_port [get_debug_ports [GetCurrentProbe ${ilaName}]]

## Write the port map file
#write_debug_probes -force ${PROJ_DIR}/images/debug_probes_${IMAGENAME}.ltx

