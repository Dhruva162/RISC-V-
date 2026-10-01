# RV32I Five-Stage Pipelined CPU

## Project Overview

Synthesizable Verilog-2001 implementation of a 32-bit RV32I processor with a Harvard memory architecture and a classic five-stage pipeline:

- IF: instruction fetch
- ID: instruction decode and register read
- EX: execute, address generation, branch resolution, and jump resolution
- MEM: data memory access
- WB: register writeback

The processor includes IF/ID, ID/EX, EX/MEM, and MEM/WB pipeline registers, EX-stage forwarding, load-use hazard stalls, and branch/jump pipeline flushes.

## Folder Structure

```text
rv32i_cpu/
  rtl/
    cpu_top.v
    program_counter.v
    instruction_memory.v
    data_memory.v
    register_file.v
    if_id_register.v
    id_ex_register.v
    ex_mem_register.v
    mem_wb_register.v
    forwarding_unit.v
    hazard_unit.v
    alu.v
    alu_decoder.v
    main_decoder.v
    control_unit.v
    immediate_generator.v
    branch_unit.v
    adder.v
    mux2.v
    mux4.v
  tb/
    tb_alu.v
    tb_register_file.v
    tb_memory.v
    tb_cpu_top.v
  docs/
    isa_subset.md
    pipeline_architecture.md
  scripts/
    iverilog_run.ps1
    vivado_synth.tcl
  sim/
  examples/
    program.hex
```

## Pipeline Control

Data forwarding, load-use stalls, and control-transfer flushing are implemented in `forwarding_unit`, `hazard_unit`, and `cpu_top`. See [docs/pipeline_architecture.md](docs/pipeline_architecture.md) for pipeline behavior.

## Simulation

Run all self-checking testbenches from the project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\iverilog_run.ps1
```

The script compiles and runs `tb_alu`, `tb_register_file`, `tb_memory`, and `tb_cpu_top` using Icarus Verilog.

## Vivado Synthesis

Run the included batch synthesis script from the project root:

```powershell
vivado -mode batch -source .\scripts\vivado_synth.tcl
```

The script targets `xc7a35tcpg236-1` and writes utilization, timing, and checkpoint outputs to `sim/`.

## Top-Level Module

`cpu_top` exposes `clk`, `rst`, `pc`, `instruction`, and `alu_result`.

## Instruction Memory Initialization

Set `IMEM_INIT_FILE` on `cpu_top` or `instruction_memory` to load a word-addressed hexadecimal program with `$readmemh`.

## ISA Coverage

The supported RV32I instructions are listed in [docs/isa_subset.md](docs/isa_subset.md).
