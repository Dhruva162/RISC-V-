# RV32I Single-Cycle CPU

## Project Overview

Synthesizable Verilog-2001 implementation of a 32-bit single-cycle RV32I processor using a Harvard architecture.

## Folder Structure

```text
rv32i_cpu/
  rtl/
  tb/
  sim/
  docs/
  scripts/
  examples/
```

## Compilation Instructions

```powershell
cd rv32i_cpu/scripts
./iverilog_run.ps1
```

## Simulation Instructions

Each testbench is self-checking and prints PASS or FAIL:

```powershell
iverilog -g2001 -o ../sim/tb_cpu_top.vvp ../rtl/*.v ../tb/tb_cpu_top.v
vvp ../sim/tb_cpu_top.vvp
```

## Vivado Synthesis Instructions

```tcl
cd rv32i_cpu/scripts
vivado -mode batch -source vivado_synth.tcl
```

## Top-Level Module

`cpu_top` exposes `clk`, `rst`, `pc`, `instruction`, and `alu_result`.

## Instruction Memory Initialization

Set `IMEM_INIT_FILE` on `cpu_top` or `instruction_memory` to load a hex program with `$readmemh`.
