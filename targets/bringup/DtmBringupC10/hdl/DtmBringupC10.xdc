##############################################################################
## This file is part of 'RCE Development Firmware'.
## It is subject to the license terms in the LICENSE.txt file found in the 
## top-level directory of this distribution and at: 
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
## No part of 'RCE Development Firmware', including this file, 
## may be copied, modified, propagated, or distributed except according to 
## the terms contained in the LICENSE.txt file.
##############################################################################

# IO Types
#set_property IOSTANDARD LVDS_25  [get_ports dtmToRtmLsP]
#set_property IOSTANDARD LVDS_25  [get_ports dtmToRtmLsM]
#set_property IOSTANDARD LVCMOS25 [get_ports plSpareP]
#set_property IOSTANDARD LVCMOS25 [get_ports plSpareM]

set_false_path -from [get_clocks sysClk125] -to [get_clocks -of_objects [get_pins U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/pcie_top_with_gt_top.gt_ges.gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/mmcm_i/CLKOUT0]]

set_false_path -from [get_clocks -of_objects [get_pins U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/pcie_top_with_gt_top.gt_ges.gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/mmcm_i/CLKOUT0]] -to [get_clocks -of_objects [get_pins U_DtmCore/U_RceG3Top/U_RceG3AxiCntl/U_ICEN.U_RceG3PcieRoot/U_PcieRoot/axi_pcie_0/inst/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/pcie_top_with_gt_top.gt_ges.gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/mmcm_i/CLKOUT2]]
