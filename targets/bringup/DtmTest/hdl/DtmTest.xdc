##############################################################################
## This file is part of 'RCE Development Firmware'.
## It is subject to the license terms in the LICENSE.txt file found in the 
## top-level directory of this distribution and at: 
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
## No part of 'RCE Development Firmware', including this file, 
## may be copied, modified, propagated, or distributed except according to 
## the terms contained in the LICENSE.txt file.
##############################################################################

# PGP Clocks
create_clock -name locRefClk -period 4.0 [get_ports locRefClkP]

create_generated_clock -name pgpClk250 -source [get_ports locRefClkP] \
    -multiply_by 1 [get_pins U_PgpArray/U_PgpClkGen/CLKOUT0]

set_clock_groups -asynchronous \
      -group [get_clocks -include_generated_clocks fclk0] \
      -group [get_clocks -include_generated_clocks locRefClk]

set_clock_groups -asynchronous \
   -group [get_clocks clk125] \
   -group [get_clocks clk200] \
   -group [get_clocks ipgpClk] \
   -group [get_clocks pcieUserClk2]
      
# IO Types
set_property IOSTANDARD LVDS_25  [get_ports dtmToRtmLsP]
set_property IOSTANDARD LVDS_25  [get_ports dtmToRtmLsM]

