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
SetDebugCoreClk ${ilaName} {U_DtmCore/U_PcieRoot/sysClk200}

## Set the Probes
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[araddr][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[arburst][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[arcache][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[arid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[arlen][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[arlock][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[arprot][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[arsize][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[arvalid]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadMaster[rready]}

ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadSlave[arready]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadSlave[rdata][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadSlave[rid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadSlave[rlast]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadSlave[rresp][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userReadSlave[rvalid]}

ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[awaddr][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[awburst][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[awcache][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[awid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[awlen][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[awlock][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[awprot][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[awsize][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[awvalid]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[bready]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[wdata][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[wid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[wlast]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[wstrb][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteMaster[wvalid]}

ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteSlave[awready]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteSlave[bid][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteSlave[bresp][*]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteSlave[bvalid]}
ConfigProbe ${ilaName} {U_DtmCore/U_PcieRoot/userWriteSlave[wready]}

## Delete the last unused port
delete_debug_port [get_debug_ports [GetCurrentProbe ${ilaName}]]

## Write the port map file
#write_debug_probes -force ${PROJ_DIR}/images/debug_probes_${IMAGENAME}.ltx

