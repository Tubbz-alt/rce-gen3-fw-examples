##############################################################################
## This file is part of 'DUNE Development Firmware'.
## It is subject to the license terms in the LICENSE.txt file found in the 
## top-level directory of this distribution and at: 
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
## No part of 'DUNE Development Firmware', including this file, 
## may be copied, modified, propagated, or distributed except according to 
## the terms contained in the LICENSE.txt file.
##############################################################################

##############################
# Get variables and procedures
##############################
source -quiet $::env(RUCKUS_DIR)/vivado_env_var.tcl
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Bypass the debug chipscope generation
return

############################
## Open the synthesis design
############################
open_run synth_1

###############################
## Set the name of the ILA core
###############################
set ilaName u_ila_0

##################
## Create the core
##################
CreateDebugCore ${ilaName}

#######################
## Set the record depth
#######################
set_property C_DATA_DEPTH 1024 [get_debug_cores ${ilaName}]

#################################
## Set the clock for the ILA core
#################################
SetDebugCoreClk ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/ethClk}

#######################
## Set the debug Probes
#######################

ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/csumMaster[tLast]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/csumMaster[tValid]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/csumMaster[tUser][0]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/csumMaster[tUser][1]}

ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/macIbMaster[tLast]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/macIbMaster[tValid]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/macIbMaster[tUser][0]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/macIbMaster[tUser][1]}

ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/mPrimMaster[tLast]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/mPrimMaster[tValid]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/mPrimMaster[tUser][0]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/mPrimMaster[tUser][1]}

ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/pauseMaster[tLast]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/pauseMaster[tValid]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/pauseMaster[tUser][0]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/pauseMaster[tUser][1]}

ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/sPrimMaster[tLast]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/sPrimMaster[tValid]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/sPrimMaster[tUser][0]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/sPrimMaster[tUser][1]}

ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/mPrimMaster[tLast]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/mPrimMaster[tValid]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/mPrimMaster[tUser][0]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/mPrimMaster[tUser][1]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/mPrimSlave[tReady]}

ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/rxFifoDrop}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/primDrop}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/sPrimCtrl[overflow]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_RxFifo/sPrimCtrl[pause]}

##########################
## Write the port map file
##########################
WriteDebugProbes ${ilaName} 
