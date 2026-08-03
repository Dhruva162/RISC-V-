read_verilog ../rtl/program_counter.v
read_verilog ../rtl/instruction_memory.v
read_verilog ../rtl/if_id_register.v
read_verilog ../rtl/id_ex_register.v
read_verilog ../rtl/data_memory.v
read_verilog ../rtl/register_file.v
read_verilog ../rtl/alu.v
read_verilog ../rtl/alu_decoder.v
read_verilog ../rtl/main_decoder.v
read_verilog ../rtl/control_unit.v
read_verilog ../rtl/immediate_generator.v
read_verilog ../rtl/branch_unit.v
read_verilog ../rtl/adder.v
read_verilog ../rtl/mux2.v
read_verilog ../rtl/mux4.v
read_verilog ../rtl/cpu_top.v
synth_design -top cpu_top -part xc7a35tcpg236-1
report_utilization -file ../sim/utilization.rpt
report_timing_summary -file ../sim/timing_summary.rpt
write_checkpoint -force ../sim/cpu_top_synth.dcp
