# Define Firmware Version Number
export PRJ_VERSION = 0xDB000113

# Define target output
target: bit

# Define target part
export PRJ_PART = XC7Z045FFG900-2

# Using a non-standard target directory structure, 
# which requires me to define the TOP_DIR path
export TOP_DIR = $(abspath $(PWD)/../../..)

# Use top level makefile
include $(TOP_DIR)/submodules/ruckus/system_vivado.mk
