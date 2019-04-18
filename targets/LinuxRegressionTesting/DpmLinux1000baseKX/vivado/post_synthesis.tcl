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

# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[byteCnt][*]}

ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[eofeDet][*]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[fragDet][*]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[ipv4Det][*]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[state][*]}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[tcpDet][*]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[udpDet][*]}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[valid][*]}

# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/ipCsumEn}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[tcpFlag]}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/tcpCsumEn}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/udpCsumEn}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/sAxisMaster[tValid]}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/sAxisMaster[tLast]}

# for {set i 0} {$i < 20} {incr i} {
for {set i 5} {$i < 8} {incr i} {
   ConfigProbe ${ilaName} "U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r\[ipv4Hdr\]\[$i\]\[*\]"
}

ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[mAxisMasters][*][tLast]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[mAxisMasters][*][tValid]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[mAxisMasters][*][tUser][0]}
ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[mAxisMasters][*][tUser][1]}

# for {set i 0} {$i < 128} {incr i 8 } {
   # ConfigProbe ${ilaName} "U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r\[mAxisMaster\]\[tUser\]\[*\]"
# }

# for {set i 1} {$i < 128} {incr i 8 } {
   # ConfigProbe ${ilaName} "U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r\[mAxisMaster\]\[tUser\]\[*\]"
# }

# for {set i 2} {$i < 128} {incr i 8 } {
   # ConfigProbe ${ilaName} "U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r\[mAxisMaster\]\[tUser\]\[*\]"
# }

# for {set i 3} {$i < 128} {incr i 8 } {
   # ConfigProbe ${ilaName} "U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r\[mAxisMaster\]\[tUser\]\[*\]"
# }

# for {set i 0} {$i < 16} {incr i} {
   # ConfigProbe ${ilaName} "U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r\[mAxisMaster\]\[tKeep\]\[$i\]"
# }
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[mAxisMaster][tLast]}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/r[mAxisMaster][tValid]}

# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/mAxisMaster[tLast]}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/mAxisMaster[tValid]}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/mAxisMaster[tUser][0]}
# ConfigProbe ${ilaName} {U_DpmCore/U_Eth10gGen.U_RceEthernet/U_RceMac/U_EthMacTop/U_Rx/U_Csum/mAxisMaster[tUser][1]}

##########################
## Write the port map file
##########################
WriteDebugProbes ${ilaName} 
