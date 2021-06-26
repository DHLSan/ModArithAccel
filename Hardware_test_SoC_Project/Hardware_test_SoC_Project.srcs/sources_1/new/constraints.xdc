# Clock
set_property PACKAGE_PIN Y9 [get_ports {clk}];  # "GCLK"
create_clock -period 100.000 -name CLK -waveform {0.000 50.000} [get_ports clk]

# OLED display
set_property PACKAGE_PIN U10  [get_ports {oled_dc}];  # "OLED-DC"
set_property PACKAGE_PIN U9   [get_ports {oled_res}];  # "OLED-RES"
set_property PACKAGE_PIN AB12 [get_ports {oled_sclk}];  # "OLED-SCLK"
set_property PACKAGE_PIN AA12 [get_ports {oled_sdin}];  # "OLED-SDIN"
set_property PACKAGE_PIN U11  [get_ports {oled_vbat}];  # "OLED-VBAT"
set_property PACKAGE_PIN U12  [get_ports {oled_vdd}];  # "OLED-VDD"

# Reset
set_property PACKAGE_PIN P16 [get_ports {rst}];  # "BTNC"
set_property PACKAGE_PIN R16 [get_ports {en}];   # "BTND"

# Switches
set_property PACKAGE_PIN M15 [get_ports {sw_in[7]}];  # "SW7"
set_property PACKAGE_PIN H17 [get_ports {sw_in[6]}];  # "SW6"
set_property PACKAGE_PIN H18 [get_ports {sw_in[5]}];  # "SW5"
set_property PACKAGE_PIN H19 [get_ports {sw_in[4]}];  # "SW4"
set_property PACKAGE_PIN F21 [get_ports {sw_in[3]}];  # "SW3"
set_property PACKAGE_PIN H22 [get_ports {sw_in[2]}];  # "SW2"
set_property PACKAGE_PIN G22 [get_ports {sw_in[1]}];  # "SW1"
set_property PACKAGE_PIN F22 [get_ports {sw_in[0]}];  # "SW0"

# Voltage settings
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];