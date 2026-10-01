# Pipeline Architecture

## Stages

| Stage | Responsibility |
| --- | --- |
| IF | Fetches the instruction and computes `PC + 4`. |
| ID | Decodes the instruction, reads the register file, and generates the immediate. |
| EX | Executes ALU operations, generates memory addresses, resolves branches and jumps, and computes branch targets. |
| MEM | Performs byte-addressable data memory loads and stores. |
| WB | Selects and writes the result to the register file. |

## Pipeline Registers

| Register | State Carried Forward |
| --- | --- |
| IF/ID | Instruction, PC, and `PC + 4`. |
| ID/EX | Decoded control signals, operands, immediate, register indexes, PC state, and instruction fields needed by EX. |
| EX/MEM | Memory/writeback control, ALU result, store data, immediate, `PC + 4`, destination register, and load/store function. |
| MEM/WB | Writeback control, ALU result, load data, immediate, `PC + 4`, and destination register. |

## Data Hazards

`forwarding_unit` forwards the newest eligible result from EX/MEM or MEM/WB to either EX operand. EX/MEM forwarding has priority over MEM/WB forwarding.

`hazard_unit` detects a load-use dependency between the instruction in ID/EX and the instruction in IF/ID. It holds the PC and IF/ID register for one cycle and injects a bubble into ID/EX.

## Control Hazards

Branches, `JAL`, and `JALR` resolve in EX. A taken branch or jump redirects the program counter and flushes the younger instructions in IF/ID and ID/EX.

## Memory and Register File

Instruction memory is read-only and word-addressed. Data memory is byte-addressable and supports byte, halfword, and word loads/stores with RV32I sign and zero extension rules. The register file has two asynchronous read ports, one synchronous write port, and permanently holds `x0` at zero.
