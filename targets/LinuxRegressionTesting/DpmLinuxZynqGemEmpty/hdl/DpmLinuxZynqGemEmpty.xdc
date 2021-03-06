##############################################################################
## This file is part of 'RCE Development Firmware'.
## It is subject to the license terms in the LICENSE.txt file found in the 
## top-level directory of this distribution and at: 
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
## No part of 'RCE Development Firmware', including this file, 
## may be copied, modified, propagated, or distributed except according to 
## the terms contained in the LICENSE.txt file.
##############################################################################

# create_clock -name locRefClk -period 4.0 [get_ports locRefClkP]
# create_generated_clock -name pgpClk [get_pins {ClockManager7_1/MmcmGen.U_Mmcm/CLKOUT0}]
# set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {locRefClk}] -group [get_clocks -include_generated_clocks {ethRefClkP}] 
# set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {locRefClk}] -group [get_clocks -include_generated_clocks {fclk0}] 
