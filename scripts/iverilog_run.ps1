$ErrorActionPreference = "Stop"

$rtl = @(
    "../rtl/program_counter.v",
    "../rtl/instruction_memory.v",
    "../rtl/if_id_register.v",
    "../rtl/id_ex_register.v",
    "../rtl/data_memory.v",
    "../rtl/register_file.v",
    "../rtl/alu.v",
    "../rtl/alu_decoder.v",
    "../rtl/main_decoder.v",
    "../rtl/control_unit.v",
    "../rtl/immediate_generator.v",
    "../rtl/branch_unit.v",
    "../rtl/adder.v",
    "../rtl/mux2.v",
    "../rtl/mux4.v",
    "../rtl/cpu_top.v"
)

$tests = @(
    "tb_alu",
    "tb_register_file",
    "tb_memory",
    "tb_cpu_top"
)

New-Item -ItemType Directory -Force ../sim | Out-Null

foreach ($test in $tests) {
    iverilog -g2001 -o "../sim/$test.vvp" $rtl "../tb/$test.v"
    vvp "../sim/$test.vvp"
}
