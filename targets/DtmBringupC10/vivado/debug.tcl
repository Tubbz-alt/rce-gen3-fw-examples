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
append nl [get_nets {U_PcieRoot/*}]

regsub -all -line { } $nl "\n" nl
puts $fd $nl
close $fd

## Setup configurations
set ilaName u_ila_0

## Create the core
CreateDebugCore ${ilaName}

## Set the record depth
set_property C_DATA_DEPTH 8192 [get_debug_cores ${ilaName}]

## Set the clock for the Core
SetDebugCoreClk ${ilaName} {U_DtmCore/U_PcieRoot/axiClk}

## Set the Probes
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][araddr][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][arburst][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][arcache][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][arid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][arlen][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][arlock][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][arprot][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][arsize][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][arvalid]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadMaster[1][rready]}

ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadSlave[1][arready]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadSlave[1][rdata][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadSlave[1][rid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadSlave[1][rlast]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadSlave[1][rresp][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieReadSlave[1][rvalid]}

ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][awaddr][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][awburst][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][awcache][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][awid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][awlen][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][awlock][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][awprot][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][awsize][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][awvalid]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][bready]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][wdata][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][wid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][wlast]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][wstrb][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteMaster[1][wvalid]}

ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteSlave[1][awready]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteSlave[1][bid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteSlave[1][bresp][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteSlave[1][bvalid]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/pcieWriteSlave[1][wready]}

## Delete the last unused port
delete_debug_port [get_debug_ports [GetCurrentProbe ${ilaName}]]

## Write the port map file
#write_debug_probes -force ${PROJ_DIR}/images/debug_probes_${IMAGENAME}.ltx

