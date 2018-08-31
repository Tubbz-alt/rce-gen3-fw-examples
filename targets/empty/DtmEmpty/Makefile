# Parallel processes for synthesizing the PCIe block diagram
export PARALLEL_SYNTH = 8

# Define Firmware Version Number
export PRJ_VERSION = 0xDC000304

# Define target output
target: bit

# Define target part
export PRJ_PART = XC7Z030FBG484-2

# Using a non-standard target directory structure, 
# which requires me to define the TOP_DIR path
export TOP_DIR = $(abspath $(PWD)/../../..)

# Use top level makefile
include $(TOP_DIR)/submodules/ruckus/system_vivado.mk
