# Verification

## Running the Suite

From the project root, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\iverilog_run.ps1
```

The script builds each testbench with Icarus Verilog and terminates on the first compilation or simulation failure.

## Testbench Coverage

| Testbench | Coverage |
| --- | --- |
| `tb_alu.v` | Arithmetic, logical, shift, signed comparison, unsigned comparison, and zero detection behavior. |
| `tb_register_file.v` | Synchronous writeback, asynchronous reads, reset behavior, and the permanent-zero behavior of `x0`. |
| `tb_memory.v` | Byte, halfword, and word stores; signed and unsigned byte/halfword loads; and word loads. |
| `tb_cpu_top.v` | End-to-end `ADDI`, dependent `ADD`, `SW`, `LW`, load-use interlocking, `BEQ` redirection, `LUI`, `JAL`, link-address writeback, and control-path flushing. |

## Build Artifacts

The simulation script writes compiled test executables to `sim/`. The Vivado batch script writes utilization and timing reports, plus a synthesis checkpoint, to the same directory.
