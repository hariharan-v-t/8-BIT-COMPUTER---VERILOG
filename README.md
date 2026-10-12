
<div align="center">

# ⚡ AXION-8
### A Custom 8-Bit Computer Built with Verilog HDL

**FROM LOGIC GATES TO A WORKING PROCESSOR**

A modular 8-bit CPU designed to explore processor architecture, digital logic, instruction execution, password authentication, and FPGA implementation.

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue?style=for-the-badge)
![FPGA](https://img.shields.io/badge/Platform-Spartan--7-green?style=for-the-badge)
![Vivado](https://img.shields.io/badge/Tool-AMD%20Vivado-orange?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-8--Bit-purple?style=for-the-badge)

**8-BIT DATA PATH • CUSTOM ISA • FPGA DESIGN**

[Architecture](#-architecture) •
[Instruction Set](#-instruction-set-architecture) •
[Simulation](#-simulation-and-verification) •
[Hardware](#-fpga-hardware-implementation) •
[Innovation](#-innovation-roadmap)

</div>

---

## ◈ Project Overview

**AXION-8** is a custom 8-bit computer architecture implemented using Verilog HDL and AMD Xilinx Vivado.

The project brings together fundamental computer components, including the Program Counter, RAM, Instruction Register, Control Unit, registers, Arithmetic Logic Unit (ALU), status flags, and output interface.

The processor follows a control-driven instruction execution cycle to fetch, decode, and execute instructions. It supports arithmetic operations, logical operations, memory access, conditional branching, program control, and external input/output.

The design targets the **Real Digital Boolean Board with a Spartan-7 FPGA** for hardware demonstration.

### ✨ Key Features

- 🧠 **Custom 8-bit CPU:** Modular processor architecture.
- ➕ **Arithmetic operations:** Addition and subtraction.
- 🔢 **Logical operations:** AND, XOR, comparison, and bit shifting.
- 💾 **16 × 8-bit RAM:** Stores instructions and data.
- 🎮 **Custom instruction set:** Sixteen possible 4-bit opcodes.
- 🔐 **Password authentication:** Access control for CPU execution, where integrated and verified.
- 🚩 **Status flags:** Carry and Zero flags for conditional execution.
- 📥 **External input:** Accepts input through the input interface.
- 📺 **Output interface:** Connects processor results to display logic.
- ⚡ **FPGA implementation:** Designed using Vivado for simulation and board testing.

> **Project goal:** Understand how a computer works by designing and integrating its fundamental hardware blocks from the ground up.

**Project status:** Work in progress. Features should be marked as verified only after successful simulation or hardware testing.

---

## ◈ Architecture

### 🏗️ CPU Datapath

The processor uses an internal 8-bit data bus to transfer information between registers, memory, and functional units. The Control Unit coordinates the transfers through control signals and sequential timing states.

```text
             ┌──────────────────┐
             │ Program Counter  │
             │       PC         │
             └────────┬─────────┘
                      │
                      ▼
             ┌──────────────────┐
             │       MAR        │
             │ Memory Address   │
             └────────┬─────────┘
                      │
                      ▼
             ┌──────────────────┐
             │    RAM 16 × 8    │
             │ Instructions/Data│
             └────────┬─────────┘
                      │
                      ▼
             ┌──────────────────┐
             │ Instruction Reg. │
             │       IR         │
             └────────┬─────────┘
                      │
                      ▼
             ┌──────────────────┐
             │   Control Unit   │
             │ Decode & Timing  │
             └────────┬─────────┘
                      │
          Control Signals / Data Bus
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
      ┌────────┐  ┌────────┐  ┌────────┐
      │ A Reg  │  │ B Reg  │  │ Input  │
      └────┬───┘  └────┬───┘  └────┬───┘
           └───────────┼────────────┘
                       ▼
                ┌────────────┐
                │  8-bit ALU │
                └─────┬──────┘
                      │
               ┌──────▼──────┐
               │ Flag Register│
               │ Carry / Zero │
               └─────────────┘

                CPU Output Path
                      │
                      ▼
               ┌─────────────┐
               │Output Register│
               └──────┬──────┘
                      ▼
               ┌─────────────┐
               │ Seven-Segment│
               │ Display Logic│
               └─────────────┘
```

*Conceptual architecture. The final diagram should match the actual RTL connections.*

### 🔩 Core Modules

| Module | Responsibility |
|---|---|
| `Top_Module` | Integrates the CPU and external interfaces |
| `program_counter` | Tracks the next instruction address |
| `MAR` | Holds the memory address |
| `RAM` | Stores program instructions and data |
| `IR` | Holds the current instruction |
| `A_Register` | Stores the accumulator and intermediate results |
| `B_Register` | Holds the second operand |
| `ALU` | Performs arithmetic and logical operations |
| `Flag_Register` | Stores status flags |
| `Control_Unit` | Decodes instructions and generates control signals |
| `Input_Register` | Handles external input |
| `OR` | Output Register, if named this way in the RTL |
| `DC` | Display conversion logic, if used in the RTL |
| `Pass` | Password authentication, if included in the final integration |
| `Clk_Div` | Generates a slower clock, if used |
| Seven-segment logic | Converts output values into display signals |

*Module names must match the actual source files in the repository.*

### 💾 Memory Organization

| Property | Specification |
|---|---|
| Data width | 8 bits |
| Address width | 4 bits |
| Capacity | 16 × 8 bits |
| Total storage | 128 bits |
| Address range | `0x0`–`0xF` |
| Initialization | `hram.mem` using `$readmemb` |

The RAM supports instruction storage and data access. Program initialization and manual memory loading should be tested according to the final RAM implementation.

---

## ◈ Instruction Set Architecture

AXION-8 uses a custom 4-bit opcode space with sixteen possible instruction types.

### Instruction Format

```text
┌────────────────┬────────────────┐
│  Opcode: 4 bits│ Operand: 4 bits│
└────────────────┴────────────────┘

          Total: 8 bits
```

The opcode selects the operation, while the lower four bits can specify an address, target, or other operand depending on the instruction.

### 📘 Supported Instruction Set

| Opcode | Mnemonic | Description |
|:---:|---|---|
| `0000` | NOP | No operation |
| `0001` | INP | Read external input |
| `0010` | LDA | Load data from RAM into A |
| `0011` | STA | Store A into RAM |
| `0100` | ADD | Perform addition |
| `0101` | SUB | Perform subtraction |
| `0110` | AND | Perform bitwise AND |
| `0111` | CMP | Compare operands |
| `1000` | XOR | Perform bitwise XOR |
| `1001` | JC | Jump if Carry is set |
| `1010` | SHL | Shift left |
| `1011` | SHR | Shift right |
| `1100` | OUT | Send data to output |
| `1101` | JMP | Unconditional jump |
| `1110` | JZ | Jump if Zero is set |
| `1111` | HLT | Halt execution |

*Confirm operand handling, flag updates, and instruction-specific timing against the final Control Unit and ALU RTL.*

---

## ◈ How the Computer Works

### 01 — Authentication 🔐

If password authentication is integrated, the user must pass the authentication check before normal CPU execution is enabled.

### 02 — Fetch 📥

The Program Counter identifies the instruction address. The instruction is fetched from RAM.

### 03 — Decode 🧩

The Instruction Register holds the fetched instruction. The Control Unit decodes the opcode and generates the required control signals.

### 04 — Execute ⚡

The registers, ALU, and RAM work together to perform the selected operation.

### 05 — Update and Display 📺

The result is stored in the appropriate register, and relevant status flags are updated. An `OUT` instruction transfers the result to the output interface.

The Control Unit sequences these actions through timing states, such as T0 to T5, according to the implemented instruction cycle.

---

## ◈ Program Memory

The `hram.mem` file contains binary instructions and data for the 16 × 8-bit RAM.

### Example Program

```text
00101000
01001001
01011010
11000000
11110000
```

| Binary | Instruction | Meaning |
|---|---|---|
| `00101000` | LDA 8 | Load data from address 8 |
| `01001001` | ADD 9 | Add data from address 9 |
| `01011010` | SUB 10 | Subtract data from address 10 |
| `11000000` | OUT | Send the result to output |
| `11110000` | HLT | Halt the processor |

Addresses 8, 9, and 10 must contain the intended operand values. The exact result depends on the data stored in RAM and the implemented instruction semantics.

Keep the program and its data within the available 16 memory locations.

---

## ◈ Simulation and Verification

**Development environment:** AMD Xilinx Vivado

Simulation is used to verify instruction execution, memory operations, ALU behavior, control signals, flags, and output values before hardware testing.

### 🧪 Verification Checklist

| Test | Purpose | Status |
|---|---|---|
| Reset | Verify initial CPU state | To be confirmed |
| Instruction fetch | Verify PC and IR | To be confirmed |
| RAM read/write | Verify memory access | To be confirmed |
| ADD and SUB | Verify arithmetic results | To be confirmed |
| AND and XOR | Verify logical operations | To be confirmed |
| CMP | Verify comparison behavior | To be confirmed |
| JC and JZ | Verify conditional branching | To be confirmed |
| INP and OUT | Verify input/output | To be confirmed |
| HLT | Verify halt behavior | To be confirmed |
| Full program | Verify instruction sequence | To be confirmed |

### Suggested Simulation Evidence

Save genuine Vivado screenshots in the repository:

```text
docs/
└── images/
    ├── cpu-architecture.png
    ├── simulation-waveform.png
    ├── arithmetic-test.png
    └── program-output.png
```

Once a screenshot exists, embed it in this README:

```markdown
![AXION-8 Simulation](docs/images/simulation-waveform.png)
```

Mark tests as passed only after checking the simulation results.

---

## ◈ FPGA Hardware Implementation

### Target Platform

**Real Digital Boolean Board — Spartan-7 FPGA**

The hardware demonstration aims to execute the CPU on the FPGA and present processor results through the board's seven-segment display.

### Planned Demonstration

- Load a program into RAM.
- Apply reset and enable CPU execution.
- Execute an arithmetic or logical program.
- Observe Carry and Zero status signals.
- Display the processor's output as a decimal value.
- Demonstrate execution using the FPGA clock.

### Decimal Seven-Segment Display

The intended decimal display path is:

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
FPGA Display
```

The conversion logic, digit multiplexing, segment polarity, and pin constraints must match the actual implementation.

### Hardware Evidence

After successful board testing, add real photographs or screenshots:

```text
docs/
└── images/
    ├── boolean-board-setup.jpg
    ├── fpga-programmed.jpg
    └── decimal-output.jpg
```

*Do not claim successful FPGA operation or decimal display functionality until verified on the board.*

---

## ◈ Innovation Roadmap

The following ideas are proposed enhancements, not claims of completed features.

### 01 — CPU Execution Visualizer

Expose selected internal signals, such as the Program Counter, Instruction Register, accumulator, ALU result, and flags, for easier debugging and demonstrations.

### 02 — Interactive Program Loader

Improve program loading so different instruction sequences can be tested without repeatedly editing the memory initialization file.

### 03 — Instruction-Level Debugging

Provide accessible debugging signals to observe instruction execution and identify incorrect control states.

### 04 — Verified Program Library

Build a collection of tested programs covering arithmetic, logic, loops, branches, and input/output.

### 05 — Improved Decimal Display

Refine the binary-to-decimal conversion and display multiplexing for a clear hardware demonstration.

### 06 — FPGA Resource and Timing Analysis

Use Vivado implementation reports to study resource utilization and timing performance.

---

## ◈ Repository Structure

The following is a suggested organization. The actual repository may use a different structure.

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

Keep the folder names and filenames synchronized with the actual project files.

---

## ◈ Getting Started

### Requirements

- Git
- AMD Xilinx Vivado
- Verilog HDL simulation support
- Real Digital Boolean Board for hardware testing

### Clone the Repository

```bash
git clone https://github.com/hariharan-v-t/8-BIT-COMPUTER---VERILOG.git
cd 8-BIT-COMPUTER---VERILOG
```

### Run in Vivado

1. Open Vivado and create or open the project.
2. Add the required Verilog source files.
3. Add the RAM initialization file `hram.mem`.
4. Add the testbench as a simulation source.
5. Run behavioral simulation.
6. Inspect waveforms and verify the expected results.
7. For hardware testing, add the correct XDC constraints and program the FPGA.

The memory initialization file must be available at the path expected by `$readmemb`.

---

## ◈ Development Status

| Area | Status |
|---|---|
| Custom ISA | Defined |
| Modular CPU architecture | Under development |
| Control Unit integration | Verify against final RTL |
| Simulation test suite | Evidence to be added |
| FPGA implementation | Requires final confirmation |
| Decimal display | Hardware verification required |
| Innovation features | Proposed roadmap |

Update this table as milestones are completed.

---

## ◈ What We Learned

- Modular digital system design using Verilog HDL.
- Processor architecture and instruction execution.
- Register transfers, RAM access, and ALU operations.
- Control signals, clocking, reset, and sequential logic.
- Testbench development and waveform analysis.
- FPGA implementation using Vivado.
- Hardware interfacing and seven-segment display logic.

---

## ◈ Team

**Team Name: Gryffindor**

Developed as an educational hardware-design and hackathon project focused on digital systems, computer architecture, Verilog HDL, and FPGA implementation.

**Author:** Hariharan V T

**Repository:** [AXION-8 — 8-BIT-COMPUTER---VERILOG](https://github.com/hariharan-v-t/8-BIT-COMPUTER---VERILOG)

---

<div align="center">

### ⚡ AXION-8

**8 Bits. One Bus. A World of Logic.**

*Every instruction tells a story. Every clock cycle makes it happen.*

**BUILD • SIMULATE • DEBUG • INNOVATE**

</div>
