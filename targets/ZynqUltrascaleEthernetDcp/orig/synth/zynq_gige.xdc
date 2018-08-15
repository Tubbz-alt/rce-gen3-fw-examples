






# false path constraints to async inputs coming directly to synchronizer
set_false_path -to [get_pins -hier -filter {name =~ *SYNC_*/data_sync*/D }]
set_false_path -to [get_pins -hier -filter {name =~ */sync_block_reset_done/data_sync_reg1/D }]
set_false_path -to [get_pins -hier -filter {name =~ *reset_sync*/PRE }]

## timing for MDIO interface
set_max_delay 10.000 -datapath_only -from [get_pins -hier -filter { name =~ */*MDIO_INTERFACE_*/MDIO_OUT_reg/C } ]
set_max_delay 10.000 -datapath_only -from [get_pins -hier -filter { name =~ */*MDIO_INTERFACE_*/MDIO_TRI_reg/C } ]




