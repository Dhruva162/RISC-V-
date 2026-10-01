# RV32I Five-Stage Pipelined CPU

A synthesizable 32-bit RISC-V RV32I processor written in Verilog-2001. The design uses separate instruction and data memories, a classic IF/ID/EX/MEM/WB pipeline, data forwarding, load-use interlocks, and EX-stage control-transfer recovery.

## Highlights

- Implements the RV32I arithmetic, logical, load/store, branch, upper-immediate, and jump instruction groups.
- Uses explicit IF/ID, ID/EX, EX/MEM, and MEM/WB pipeline registers.
- Resolves read-after-write dependencies through EX/MEM and MEM/WB forwarding paths.
- Detects load-use dependencies, stalls fetch/decode, and injects an EX bubble.
- Resolves branches, `JAL`, and `JALR` in EX and flushes younger instructions after a redirected PC.
- Provides byte-addressable data memory with correctly extended byte and halfword loads.
- Keeps `x0` hardwired to zero with two asynchronous read ports and a synchronous write port.
- Includes self-checking unit and integration testbenches plus Icarus Verilog and Vivado build scripts.

## Architecture

| Stage | Responsibility |
| --- | --- |
| IF | Instruction fetch and sequential PC generation. |
| ID | Instruction decode, register read, and immediate generation. |
| EX | ALU execution, address generation, forwarding, branch comparison, and jump target generation. |
| MEM | Byte-addressable load/store access. |
| WB | ALU, load, link-address, or upper-immediate writeback selection. |

Detailed pipeline state and hazard behavior are documented in [docs/pipeline_architecture.md](docs/pipeline_architecture.md).

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
    verification.md
  scripts/
    iverilog_run.ps1
    vivado_synth.tcl
  sim/
  examples/
    program.hex
```

## Simulation

Run all self-checking testbenches from the project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\iverilog_run.ps1
```

The script compiles and runs `tb_alu`, `tb_register_file`, `tb_memory`, and `tb_cpu_top` using Icarus Verilog. Current test coverage is recorded in [docs/verification.md](docs/verification.md).

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

## Supported ISA

The supported RV32I instructions are listed in [docs/isa_subset.md](docs/isa_subset.md).

## Design Scope

This is an in-order, single-issue educational processor core focused on the RV32I base integer ISA. It does not include caches, interrupts, exceptions, CSRs, compressed instructions, multiplication/division extensions, or an external bus interface.
