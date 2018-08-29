# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Check for Vivado version
if { [VersionCheck 2018.1 "mustBeExact"] < 0 } {
   exit -1
}

# Load target's source code and constraints
loadSource      -dir  "$::DIR_PATH/hdl"
loadSource      -dir  "$::DIR_PATH/hdl/transceiver"

# loadIpCore -path "$::DIR_PATH/ip/zynq_gige.xci"