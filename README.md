# RV32IM Pipelined CPU — FPGA Implementation

A fully functional 5-stage pipelined RISC-V 32-bit processor implementing the RV32IM instruction set, in SystemVerilog, deployed on a Digilent Basys 3 FPGA (Xilinx Artix-7).

## Overview

This project implements the RV32I base integer instruction set plus the M (multiply/divide) extension in a classic 5-stage pipeline (IF, ID, EX, MEM, WB). The design targets synthesis and hardware correctness, with verified execution on real FPGA hardware at 50MHz.

## Architecture

- **Pipeline:** 5-stage (Instruction Fetch, Instruction Decode, Execute, Memory Access, Write Back)
- **Memory:** Harvard architecture with separate instruction and data memories, both implemented as synchronous BRAM-inferred memories
- **Multiply Unit:** Combinational, DSP-inferred 32×32 multiplier supporting MUL/MULH/MULHU/MULHSU
- **Divide Unit:** 32-cycle iterative restoring-division FSM supporting DIV/DIVU/REM/REMU, with sign correction for signed division
- **Cycle Counter:** Memory-mapped 32-bit free-running counter at `0x80001004`, for benchmarking (e.g. CoreMark)
- **Hazard Handling:**
  - Data forwarding (EX-EX and MEM-EX)
  - Load-use stall detection
  - BRAM read latency stall
  - Multi-cycle divide stall (pipeline freeze for IFID/IDEX/EXMEM during 32-cycle division)
  - Branch/jump flush logic
- **Target Device:** Digilent Basys 3 (Xilinx Artix-7 xc7a35t)
- **Clock Frequency:** 50MHz (timing closure verified in Vivado, WNS +1.947ns with full RV32IM)

## Instruction Set Coverage

All RV32I base integer instructions plus the M extension are implemented and hardware-verified:

| Category | Instructions |
|---|---|
| Arithmetic | ADD, ADDI, SUB, LUI, AUIPC |
| Logical | AND, OR, XOR, ANDI, ORI, XORI |
| Shifts | SLL, SRL, SRA, SLLI, SRLI, SRAI |
| Comparisons | SLT, SLTU, SLTI, SLTIU |
| Branches | BEQ, BNE, BLT, BGE, BLTU, BGEU |
| Jumps | JAL, JALR |
| Loads | LW, LH, LHU, LB, LBU |
| Stores | SW, SH, SB |
| Multiply | MUL, MULH, MULHU, MULHSU |
| Divide/Remainder | DIV, DIVU, REM, REMU |

## Repository Structure
/src/          SystemVerilog source files

/tests/        RISC-V assembly test programs (.S) and hex files (.hex)

/constraints/  Vivado XDC constraints file

## Hardware Verification

Each instruction category was verified on hardware using custom RISC-V assembly test programs. Tests signal pass/fail by writing to a memory-mapped `tohost` register at `0x80001000`, which drives the onboard LEDs:
- **LED[0] lit** — test passed
- **LED[1] lit** — test failed

## Design Notes: Multiply/Divide Implementation

- Multiply is implemented as a separate combinational unit running in parallel with the ALU; a mux in EX selects between ALU and multiply results based on decoded `funct7`/`funct3`. This keeps the ALU's timing-critical path untouched.
- An initial fully-combinational divider caused a worst-case path of 340 logic levels and ~103ns delay (WNS -82.8ns at 50MHz). Replacing it with a 32-cycle iterative restoring-division FSM restored timing to WNS +2.266ns.
- The divide stall required holding IFID, IDEX, and EXMEM (not MEMWB) for the duration of the division, plus careful edge-detection on the divide "start" signal to avoid re-triggering the divider after completion.

## Tools Used

- **HDL:** SystemVerilog
- **Synthesis & Implementation:** Vivado 2023.1
- **Simulation:** Vivado Behavioral Simulation, Icarus Verilog, GTKWave
- **Assembler:** riscv32-unknown-elf-gcc (`-march=rv32im -mabi=ilp32`)
- **Board:** Digilent Basys 3

## Programming the Board

1. Open Vivado and create a new project with the source files from `/src/`
2. Add the constraints file from `/constraints/`
3. Copy the desired hex file from `/tests/` to your Vivado project directory
4. Update the `$readmemh` path in `imem.sv` to point to your hex file
5. Run synthesis, implementation, and generate bitstream
6. Program the Basys 3 via Vivado Hardware Manager
7. Press the center button (reset) and observe the LEDs

## Current Issues

1. **Back-to-back loads to the same address can read stale data.** Two consecutive `lw` instructions create two adjacent one-cycle BRAM stalls with an un-stalled cycle in between. If an earlier instruction's result (needed as an address operand by the second load) is still in the forwarding window, it can fall out of that window during the gap cycle before the delayed load consumes it, causing the load to use a stale forwarded value rather than the corrected one. This does not occur in normally-scheduled code (including compiler-generated code, which naturally separates dependent loads) and was only discovered via a deliberately back-to-back test case for the cycle counter. Documented for future hazard-unit refinement.

## Roadmap

- [X] CoreMark benchmark port (bare-metal, using the memory-mapped cycle counter)
- [X] Fix back-to-back load forwarding hazard
- [ ] RTL-to-GDS-II flow (OpenLane + Sky130 PDK) for physical design portfolio artifacts****
