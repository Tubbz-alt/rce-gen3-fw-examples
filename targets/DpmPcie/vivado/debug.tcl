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
SetDebugCoreClk ${ilaName} {U_PcieRoot/intAxiClk}
#SetDebugCoreClk ${ilaName} {U_PcieRoot/axiClk}

## Set the Probes
#ConfigProbe ${ilaName} {U_PcieRoot/pcieReadMaster[0][arvalid]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieReadMaster[0][araddr][*]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieReadMaster[0][rready]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieReadSlave[0][arready]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieReadSlave[0][rresp][*]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieReadSlave[0][rvalid]}

#ConfigProbe ${ilaName} {U_PcieRoot/pcieWriteMaster[0][awvalid]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieWriteMaster[0][awaddr][*]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieWriteMaster[0][bready]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieWriteMaster[0][wvalid]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieWriteSlave[0][awready]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieWriteSlave[0][bresp][*]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieWriteSlave[0][bvalid]}
#ConfigProbe ${ilaName} {U_PcieRoot/pcieWriteSlave[0][wready]}

ConfigProbe ${ilaName} {U_PcieRoot/intReadMaster[0][arvalid]}
ConfigProbe ${ilaName} {U_PcieRoot/intReadMaster[0][araddr][*]}
ConfigProbe ${ilaName} {U_PcieRoot/intReadMaster[0][rready]}
ConfigProbe ${ilaName} {U_PcieRoot/intReadSlave[0][arready]}
ConfigProbe ${ilaName} {U_PcieRoot/intReadSlave[0][rresp][*]}
ConfigProbe ${ilaName} {U_PcieRoot/intReadSlave[0][rvalid]}

ConfigProbe ${ilaName} {U_PcieRoot/intWriteMaster[0][awvalid]}
ConfigProbe ${ilaName} {U_PcieRoot/intWriteMaster[0][awaddr][*]}
ConfigProbe ${ilaName} {U_PcieRoot/intWriteMaster[0][bready]}
ConfigProbe ${ilaName} {U_PcieRoot/intWriteMaster[0][wvalid]}
ConfigProbe ${ilaName} {U_PcieRoot/intWriteSlave[0][awready]}
ConfigProbe ${ilaName} {U_PcieRoot/intWriteSlave[0][bresp][*]}
ConfigProbe ${ilaName} {U_PcieRoot/intWriteSlave[0][bvalid]}
ConfigProbe ${ilaName} {U_PcieRoot/intWriteSlave[0][wready]}

## Delete the last unused port
delete_debug_port [get_debug_ports [GetCurrentProbe ${ilaName}]]

## Write


## Delete the last unused port
delete_debug_port [get_debug_ports [GetCurrentProbe ${ilaName}]]

## Write the port map file
#write_debug_probes -force ${PROJ_DIR}/images/debug_probes_${IMAGENAME}.ltx

