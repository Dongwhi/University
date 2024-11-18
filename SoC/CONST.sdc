###################################################################
# CLOCK
###################################################################

#RESET
set_ideal_network [get_port RSTN]

###################################################################
# INPUT
###################################################################
set_input_delay 0.1 -clock [get_clock CLOCK] [remove_from_collection [all_inputs] [get_port {CLK RSTN}]]


###################################################################
# OUTPUT
###################################################################
set_output_delay 0.1 -clock [get_clock CLOCK] [all_outputs]

# set_load 0.3 [get_ports CLK]
# set_load 1.5 [get_ports all_inputs]
# set_load 1.5 [get_ports all_outputs]

set_load 0.001 [get_ports CLK]
set_load 0.003 [get_ports RSTN]

set_load 0.005 [remove_from_collection [all_inputs] [get_port {CLK RSTN}]]
set_load 0.005 [all_outputs]


###################################################################
# user-defined path group
###################################################################
# group_path -name INPUTS -from [all_inputs]
# group_path -name OUTPUTS -to [all_outputs]
# group_path -name COMBO -from [all_inputs] -to [all_outputs]

# group_path -name CLOCK -weight 5 -critical 0.5
# group_path -name INPUTS -weight 1 -critical 0.5
# group_path -name OUTPUTS -weight 1 -critical 0.5
# group_path -name COMBO -weight 1 -critical 1.0
