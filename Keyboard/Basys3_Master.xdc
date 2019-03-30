## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 
# LEDs
set_property PACKAGE_PIN U16 [get_ports {strobe}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {strobe}]
set_property PACKAGE_PIN E19 [get_ports {lightCheck}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lightCheck}]
	
##7 segment display
set_property PACKAGE_PIN W7 [get_ports {sseg[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[6]}]
set_property PACKAGE_PIN W6 [get_ports {sseg[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[5]}]
set_property PACKAGE_PIN U8 [get_ports {sseg[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[4]}]
set_property PACKAGE_PIN V8 [get_ports {sseg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[3]}]
set_property PACKAGE_PIN U5 [get_ports {sseg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[2]}]
set_property PACKAGE_PIN V5 [get_ports {sseg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[1]}]
set_property PACKAGE_PIN U7 [get_ports {sseg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sseg[0]}]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


##USB HID (PS/2)
set_property PACKAGE_PIN C17 [get_ports PS2CLK]						
	set_property IOSTANDARD LVCMOS33 [get_ports PS2CLK]
	set_property PULLUP true [get_ports PS2CLK]
set_property PACKAGE_PIN B17 [get_ports PS2Data]					
	set_property IOSTANDARD LVCMOS33 [get_ports PS2Data]	
	set_property PULLUP true [get_ports PS2Data]

