## Clock
set_property PACKAGE_PIN W5 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Clk]
create_clock -period 10.000 [get_ports Clk]

## Reset (Center Button)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## LEDs (tohost[15:0])
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
set_property PACKAGE_PIN W18 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED[7]}]
set_property PACKAGE_PIN V13 [get_ports {LED[8]}]
set_property PACKAGE_PIN V3 [get_ports {LED[9]}]
set_property PACKAGE_PIN W3 [get_ports {LED[10]}]
set_property PACKAGE_PIN U3 [get_ports {LED[11]}]
set_property PACKAGE_PIN P3 [get_ports {LED[12]}]
set_property PACKAGE_PIN N3 [get_ports {LED[13]}]
set_property PACKAGE_PIN P1 [get_ports {LED[14]}]
set_property PACKAGE_PIN L1 [get_ports {LED[15]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LED[*]}]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clkgen/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {coremark_crc[0]} {coremark_crc[1]} {coremark_crc[2]} {coremark_crc[3]} {coremark_crc[4]} {coremark_crc[5]} {coremark_crc[6]} {coremark_crc[7]} {coremark_crc[8]} {coremark_crc[9]} {coremark_crc[10]} {coremark_crc[11]} {coremark_crc[12]} {coremark_crc[13]} {coremark_crc[14]} {coremark_crc[15]} {coremark_crc[16]} {coremark_crc[17]} {coremark_crc[18]} {coremark_crc[19]} {coremark_crc[20]} {coremark_crc[21]} {coremark_crc[22]} {coremark_crc[23]} {coremark_crc[24]} {coremark_crc[25]} {coremark_crc[26]} {coremark_crc[27]} {coremark_crc[28]} {coremark_crc[29]} {coremark_crc[30]} {coremark_crc[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {coremark_elapsed[0]} {coremark_elapsed[1]} {coremark_elapsed[2]} {coremark_elapsed[3]} {coremark_elapsed[4]} {coremark_elapsed[5]} {coremark_elapsed[6]} {coremark_elapsed[7]} {coremark_elapsed[8]} {coremark_elapsed[9]} {coremark_elapsed[10]} {coremark_elapsed[11]} {coremark_elapsed[12]} {coremark_elapsed[13]} {coremark_elapsed[14]} {coremark_elapsed[15]} {coremark_elapsed[16]} {coremark_elapsed[17]} {coremark_elapsed[18]} {coremark_elapsed[19]} {coremark_elapsed[20]} {coremark_elapsed[21]} {coremark_elapsed[22]} {coremark_elapsed[23]} {coremark_elapsed[24]} {coremark_elapsed[25]} {coremark_elapsed[26]} {coremark_elapsed[27]} {coremark_elapsed[28]} {coremark_elapsed[29]} {coremark_elapsed[30]} {coremark_elapsed[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list coremark_done]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets cpu_clk]
