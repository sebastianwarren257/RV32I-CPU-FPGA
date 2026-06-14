# RV32I Pipelined CPU — FPGA Implementation

A fully functional 5-stage pipelined RISC-V 32-bit (RV32I) processor implemented in SystemVerilog and deployed on a Digilent Basys 3 FPGA (Xilinx Artix-7).

## Overview

This project implements the complete RV32I base integer instruction set in a classic 5-stage pipeline (IF, ID, EX, MEM, WB). The design targets synthesis and hardware correctness, with verified execution on real FPGA hardware at 50MHz.

## Architecture

- **Pipeline:** 5-stage (Instruction Fetch, Instruction Decode, Execute, Memory Access, Write Back)
- **Memory:** Harvard architecture with separate instruction and data memories, both implemented as synchronous BRAM-inferred memories
- **Hazard Handling:**
  - Data forwarding (EX-EX and MEM-EX)
  - Load-use stall detection
  - BRAM read latency stall
  - Branch/jump flush logic
- **Target Device:** Digilent Basys 3 (Xilinx Artix-7 xc7a35t)
- **Clock Frequency:** 50MHz (timing closure verified in Vivado)

## Instruction Set Coverage

All RV32I base integer instructions are implemented and hardware-verified:

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

## Repository Structure
/src/          SystemVerilog source files

/tests/        RISC-V assembly test programs (.S) and hex files (.hex)

/constraints/  Vivado XDC constraints file

## Hardware Verification

Each instruction category was verified on hardware using custom RISC-V assembly test programs. Tests signal pass/fail by writing to a memory-mapped `tohost` register at `0x80001000`, which drives the onboard LEDs:
- **LED[0] lit** — test passed
- **LED[1] lit** — test failed

## Tools Used

- **HDL:** SystemVerilog
- **Synthesis & Implementation:** Vivado 2023.1
- **Simulation:** Vivado Behavioral Simulation, Icarus Verilog, GTKWave
- **Assembler:** riscv32-unknown-elf-gcc (`-march=rv32i -mabi=ilp32`)
- **Board:** Digilent Basys 3

## Programming the Board

1. Open Vivado and create a new project with the source files from `/src/`
2. Add the constraints file from `/constraints/`
3. Copy the desired hex file from `/tests/` to your Vivado project directory
4. Update the `$readmemh` path in `imem.sv` to point to your hex file
5. Run synthesis, implementation, and generate bitstream
6. Program the Basys 3 via Vivado Hardware Manager
7. Press the center button (reset) and observe the LEDs
