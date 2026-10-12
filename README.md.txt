
<div align="center">

# ⚡ AXION-8
### A Custom 8-Bit Computer Built with Verilog HDL

**FROM LOGIC GATES TO A WORKING PROCESSOR**

A modular 8-bit CPU designed to explore processor architecture, digital logic, instruction execution, and FPGA implementation.

<br/>

![Verilog](https://img.shields.io/badge/HDL-Verilog-00D9FF?style=for-the-badge&logo=verilog&logoColor=white)
![FPGA](https://img.shields.io/badge/Platform-Spartan--7-00D9FF?style=for-the-badge)
![Vivado](https://img.shields.io/badge/Tool-AMD%20Vivado-00D9FF?style=for-the-badge)
![Project](https://img.shields.io/badge/Project-Computer%20Architecture-111827?style=for-the-badge)

<br/>

**8-BIT DATA PATH &nbsp; • &nbsp; CUSTOM ISA &nbsp; • &nbsp; FPGA DESIGN**

[Architecture](#-architecture) •
[Instruction Set](#-instruction-set-architecture-isa) •
[Simulation](#-simulation-and-verification) •
[Hardware](#-fpga-hardware-implementation) •
[Innovations](#-innovation-roadmap)

</div>

---

## ◈ Project Overview

**AXION-8** is an educational 8-bit computer architecture implemented using Verilog HDL. The project focuses on understanding how a processor fetches instructions, decodes operations, processes data, accesses memory, and produces output.

Instead of treating the CPU as a single block, AXION-8 is organized into individual RTL modules that work together through a shared internal data bus and control signals.

The design is being developed and tested using **AMD Xilinx Vivado**, with a target hardware demonstration on the **Real Digital Boolean Board**.

### Design Goals

- Build a modular 8-bit CPU from fundamental digital design blocks.
- Implement a custom instruction set architecture.
- Execute arithmetic, logical, memory, and program-control instructions.
- Understand instruction execution through clock cycles and control signals.
- Verify functionality through simulation and testbenches.
- Demonstrate processor output using FPGA hardware and a decimal seven-segment display.

> **Project status:** Work in progress. Refer to the verification and hardware sections for the features that have been tested and those that still require confirmation.

---

## ◈ Architecture

### CPU Datapath

The processor is organized around a shared 8-bit data bus. Registers and functional units exchange information through this bus under the control of the control unit.

```text
                    ┌─────────────────────┐
                    │   Program Counter   │
                    │         PC          │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   Memory Address    │
                    │    Register (MAR)   │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │      RAM 16 × 8     │
                    │ Instructions / Data │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │ Instruction Register│
                    │         IR          │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    Control Unit     │
                    │ Decode & Sequencing │
                    └──────────┬──────────┘
                               │
             Control Signals   │
          ┌────────────────────┼───────────────────┐
          ▼                    ▼                   ▼
     ┌─────────┐         ┌───────────┐        ┌───────────┐
     │ A Reg   │         │  B Reg    │        │ Input Reg │
     └────┬────┘         └─────┬─────┘        └─────┬─────┘
          └────────────────────┼────────────────────┘
                               ▼
                    ┌─────────────────────┐
                    │         ALU         │
                    │ Arithmetic / Logic  │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   Flag Register     │
                    │   Carry / Zero      │
                    └─────────────────────┘

           Shared 8-bit internal bus and control logic

                    ┌─────────────────────┐
                    │    Output Register  │
                    └──────────┬──────────┘
                               ▼
                    ┌─────────────────────┐
                    │ Decimal 7-Segment   │
                    │   Display Logic     │
                    └─────────────────────┘
```

*Conceptual architecture illustration. Update it if the final RTL connections differ from this diagram.*

### Main Modules

| Module | Responsibility |
|---|---|
| `Top_Module` | Integrates the CPU modules and external interfaces |
| `program_counter` | Tracks the address of the next instruction |
| `A_Register` | Holds an operand and/or intermediate result |
| `B_Register` | Holds a second operand |
| `MAR` | Holds the memory address |
| `IR` | Holds the current instruction |
| `RAM` | Stores instructions and data |
| `ALU` | Performs arithmetic and logical operations |
| `Control_Unit` | Decodes instructions and generates control signals |
| `Flag_Register` | Stores status flags used by conditional instructions |
| `Input_Register` | Captures external input data |
| `Output_Register` | Holds data intended for external display |
| Seven-segment logic | Converts the output value into display signals |

*Module names and responsibilities should be aligned with the final source files.*

### Memory Organization

| Property | Design |
|---|---|
| Data width | 8 bits |
| Address width | 4 bits |
| Memory capacity | 16 × 8 bits |
| Total storage | 128 bits |
| Address range | `0x0`–`0xF` |

The memory is intended to support instruction storage and data access. Program initialization and manual memory loading are implemented through the RTL design; their final hardware behavior should be verified on the target board.

---

## ◈ Instruction Set Architecture (ISA)

AXION-8 uses a custom 4-bit opcode space with up to 16 instruction types.

| Opcode | Mnemonic | Operation |
|:---:|:---:|---|
| `0000` | `NOP` | No operation |
| `0001` | `INP` | Read external input |
| `0010` | `LDA` | Load data from memory into A |
| `0011` | `STA` | Store A into memory |
| `0100` | `ADD` | Add operands |
| `0101` | `SUB` | Subtract operands |
| `0110` | `AND` | Bitwise AND |
| `0111` | `CMP` | Compare operands |
| `1000` | `XOR` | Bitwise XOR |
| `1001` | `JC` | Conditional jump if carry |
| `1010` | `SHL` | Shift left |
| `1011` | `SHR` | Shift right |
| `1100` | `OUT` | Send data to output |
| `1101` | `JMP` | Unconditional jump |
| `1110` | `JZ` | Conditional jump if zero |
| `1111` | `HLT` | Halt execution |

**Important:** This table describes the intended instruction meanings. Confirm the exact operand format, instruction length, flag behavior, and control-unit implementation against the final RTL.

### Instruction Execution

The processor follows a control-driven execution sequence. Depending on the instruction, the control unit coordinates actions such as:

1. Fetch an instruction from memory.
2. Load and decode the instruction.
3. Fetch any required operand.
4. Execute the operation or perform memory access.
5. Update the destination register and relevant flags.
6. Continue to the next instruction or change the program counter for a branch.

The precise T-state sequence is defined by the control-unit implementation.

---

## ◈ Simulation and Verification

**Development environment:** AMD Xilinx Vivado

Simulation is used to inspect instruction execution, internal registers, control signals, memory behavior, and output values before relying on the FPGA implementation.

### Verification Plan

| Test | Purpose | Status |
|---|---|---|
| Reset behavior | Check initial CPU state | Pending final evidence |
| Instruction fetch | Check PC and IR operation | Pending final evidence |
| Memory read/write | Verify RAM access | Pending final evidence |
| Arithmetic | Check ADD and SUB results | Pending final evidence |
| Logical operations | Check AND and XOR | Pending final evidence |
| Conditional branches | Verify JC and JZ | Pending final evidence |
| Input/output | Check INP and OUT | Pending final evidence |
| Halt | Verify HLT behavior | Pending final evidence |
| Full-program execution | Execute a sequence of instructions | Pending final evidence |

### Simulation Evidence

Add your own Vivado screenshots to the repository as you complete the tests.

Suggested layout:

```text
docs/
└── images/
    ├── cpu-architecture.png
    ├── simulation-waveform.png
    ├── arithmetic-test.png
    └── program-output.png
```

Once these images exist, embed them here:

```markdown
![AXION-8 simulation waveform](docs/images/simulation-waveform.png)
```

Do not mark a test as passed until the corresponding result has been checked.

---

## ◈ FPGA Hardware Implementation

### Target Platform

**Real Digital Boolean Board — Spartan-7 FPGA platform**

The hardware goal is to demonstrate the CPU operating on the FPGA board, with visible output through the onboard seven-segment display.

### Planned Hardware Demonstration

- Program loading through the available memory-loading interface.
- Controlled CPU reset and execution.
- Execution of a small arithmetic or logical program.
- Observation of carry and zero status outputs.
- Display of the processor's output as a decimal number.
- Demonstration of instruction execution using a real FPGA clock.

### Decimal Seven-Segment Output

The display subsystem is intended to show output values in decimal rather than hexadecimal.

The conversion path is conceptually:

```text
8-bit CPU Output
       │
       ▼
Binary-to-Decimal Conversion
       │
       ▼
Digit Selection / Multiplexing
       │
       ▼
Seven-Segment Decoder
       │
       ▼
FPGA Seven-Segment Display
```

The final conversion, digit multiplexing, active-low/active-high pin configuration, and timing must match the implemented display logic and board constraints.

### Hardware Evidence

Add actual photos or screenshots after successful testing.

```text
docs/
└── images/
    ├── boolean-board-setup.jpg
    ├── fpga-programmed.jpg
    └── decimal-output.jpg
```

*Hardware operation and decimal display behavior are not claimed as verified until evidence is added.*

---

## ◈ Innovation Roadmap

The following enhancements are proposed directions for future development, not claims of completed features.

### 01 — CPU Execution Visualizer

Create a visual representation of the PC, IR, registers, ALU result, flags, and current instruction during simulation.

**Goal:** Make instruction execution easier to debug and explain during demonstrations.

### 02 — Interactive Program Loader

Develop a convenient method to load custom programs into RAM and execute them without repeatedly editing the memory initialization file.

**Goal:** Demonstrate different programs with less setup effort.

### 03 — Instruction-Level Debugging

Expose selected internal state and control signals to help track instruction execution and identify incorrect state transitions.

**Goal:** Improve observability and debugging.

### 04 — Expanded Program Library

Build a collection of verified programs covering arithmetic, logical operations, branches, loops, and input/output.

**Goal:** Demonstrate the instruction set with repeatable test cases.

### 05 — Improved Display Interface

Refine the decimal output path and display multiplexing for a clear, stable hardware demonstration.

**Goal:** Make CPU results easier to read during live testing.

### 06 — Resource and Timing Analysis

Use Vivado reports to document FPGA resource utilization and timing results after implementation.

**Goal:** Understand how the processor maps into FPGA logic.

---

## ◈ Repository Structure

The repository is expected to evolve toward the following organization as files are added.

```text
8-BIT-COMPUTER---VERILOG/
│
├── README.md
├── rtl/
│   ├── Top_Module.v
│   ├── ALU.v
│   ├── Control_Unit.v
│   ├── RAM.v
│   └── ...
│
├── sim/
│   ├── testbench.v
│   └── programs/
│       └── hram.mem
│
├── constraints/
│   └── BooleanBoard.xdc
│
└── docs/
    └── images/
```

*This is a proposed organization. Keep the actual filenames and directory structure synchronized with the repository.*

---

## ◈ Getting Started

### Requirements

- Windows or another supported development environment
- Git
- AMD Xilinx Vivado
- Verilog HDL simulation support
- Real Digital Boolean Board for the intended hardware demonstration

### Clone the Repository

```bash
git clone https://github.com/hariharan-v-t/8-BIT-COMPUTER---VERILOG.git
cd 8-BIT-COMPUTER---VERILOG
```

### Run the Project

1. Add or obtain the current RTL source files.
2. Open Vivado and create or open the relevant project.
3. Add the Verilog modules and any required memory initialization files.
4. Add the testbench as a simulation source.
5. Run behavioral simulation.
6. Inspect waveforms and compare the results with expected values.
7. For hardware testing, add the appropriate board constraints and program the FPGA.

*Exact setup steps may change with the final project files and Vivado project configuration.*

---

## ◈ Development Status

| Area | Status |
|---|---|
| Custom ISA definition | Defined |
| Modular RTL architecture | Under development |
| Control-unit integration | Verify against final RTL |
| Simulation test suite | Evidence to be added |
| FPGA implementation | Pending confirmation |
| Decimal seven-segment output | Hardware verification pending |
| Innovation features | Proposed roadmap |

This status table should be updated as each milestone is completed.

---

## ◈ Design Philosophy

> **Understand every bit. Control every cycle. Build every block with purpose.**

AXION-8 is an exploration of how a collection of digital logic blocks can work together as a programmable computer. The goal is not only to make a processor execute instructions, but also to understand the architecture, verify the implementation, and explain the design clearly.

---

## ◈ Acknowledgements

Developed as an educational digital design and computer architecture project using Verilog HDL and AMD Xilinx Vivado.

**Author:** Hariharan V T  
**Repository:** [AXION-8 — 8-BIT-COMPUTER---VERILOG](https://github.com/hariharan-v-t/8-BIT-COMPUTER---VERILOG)

---

<div align="center">

### AXION-8

**8 Bits. One Bus. A World of Logic.**

*Built block by block.*

</div>
