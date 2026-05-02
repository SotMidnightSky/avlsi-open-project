link
uniquify
# specify clk
create_clock clk -period 42 -waveform {0 20}
set_clock_latency 0.3 clk
set_input_delay 2.0 -clock clk [all_inputs]
set_output_delay 1.65 -clock clk [all_outputs]
# specify clk_serial
create_clock clk_serial -period 14 -waveform {0 7}
set_clock_latency 0.3 clk_serial
set_input_delay 2.0 -clock clk_serial [all_inputs]
set_output_delay 1.65 -clock clk_serial [all_outputs]
# specify loads
set_load 0.1 [all_outputs]
set_max_fanout 1 [all_inputs]
set_fanout_load 8 [all_outputs]
report_port