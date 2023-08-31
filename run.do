vlog traffic_light_controller.v  traffic_light_controller_tb.v timer.v
vsim  traffic_light_controller_tb
add wave *;

add wave -position insertpoint  \
sim:/traffic_light_controller_tb/UUT/state_next \
sim:/traffic_light_controller_tb/UUT/state_reg


run -all  