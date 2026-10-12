
# ⚡ 8-BIT COMPUTER — Verilog HDL

<p align="center">
  <img src="https://img.shields.io/badge/Verilog-HDL-blue?style=for-the-badge&logo=dependabot" alt="Verilog HDL"/>
  <img src="https://img.shields.io/badge/FPGA-Spartan--7-green?style=for-the-badge" alt="FPGA"/>
  <img src="https://img.shields.io/badge/Tool-Xilinx%20Vivado-orange?style=for-the-badge" alt="Vivado"/>
  <img src="https://img.shields.io/badge/Architecture-8--Bit-purple?style=for-the-badge" alt="8-bit architecture"/>
</p>

<p align="center">
  <b>From Logic Gates to a Working Computer.</b><br>
  A custom 8-bit processor designed in Verilog HDL, combining digital logic, memory, instruction execution, password authentication, and hardware output.
</p>

---

## 🚀 Project Overview

What happens when registers, memory, an ALU, and a control unit come together?

They form a computer!

This project implements a **custom 8-bit computer architecture** using Verilog HDL and Xilinx Vivado, designed for simulation and FPGA-based demonstration on the Real Digital Boolean Board.

The processor follows a structured instruction cycle to fetch, decode, and execute instructions. It supports arithmetic and logical operations, memory access, program control, and output display. Password authentication adds an additional layer of access control before CPU execution.

> 💡 **Our goal:** Understand how a computer works by building its fundamental hardware from the ground up.

## ✨ Key Features

- 🧠 **8-bit CPU architecture** — A custom processor with dedicated registers and a control unit.
- ➕ **Arithmetic and logic operations** — Addition, subtraction, AND, XOR, comparison, and bit shifting.
- 💾 **16 × 8-bit RAM** — Stores program instructions and data.
- 🎮 **Custom instruction set** — A compact 8-bit instruction format with opcode and operand fields.
- 🔐 **Password authentication** — CPU execution is enabled only after successful authentication.
- 🖥️ **Output display** — Displays processor results through a seven-segment display interface.
- 🚩 **Status flags** — Carry and Zero flags support arithmetic status and conditional execution.
- ⚙️ **FPGA implementation** — Designed for simulation and hardware demonstration.

## 🏗️ System Architecture

The computer is built using interconnected Verilog modules:

```text
                 ┌──────────────────┐
                 │ Password Module  │
                 └────────┬─────────┘
                          │ Authentication
                          ▼
┌──────────────┐   ┌────────────────────┐
│ Clock / Reset│──▶│    Control Unit    │
└──────────────┘   └─────────┬──────────┘
                             │ Control Signals
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
    ┌──────────┐       ┌──────────┐       ┌──────────┐
    │Registers │◀─────▶│   ALU    │◀─────▶│   RAM    │
    │ A, B, IR │       │  8-bit   │       │ 16 × 8   │
    └──────────┘       └────┬─────┘       └──────────┘
                             │
                             ▼
                      ┌────────────┐
                      │ Output Reg │
                      └─────┬──────┘
                            ▼
                      ┌────────────┐
                      │ 7-Segment  │
                      │  Display   │
                      └────────────┘
```

### 🔩 Core Modules

| Module | Responsibility |
|---|---|
| `program_counter` | Tracks the address of the next instruction |
| `MAR` | Holds the memory address |
| `RAM` | Stores program instructions and data |
| `IR` | Holds the current instruction |
| `A_Register` | Stores the accumulator and ALU result |
| `B_Register` | Stores the second ALU operand |
| `ALU` | Performs arithmetic and logical operations |
| `Flag_Register` | Stores status flags |
| `Control_Unit` | Generates signals to coordinate execution |
| `Input_Register` | Handles external input data |
| `OR` | Holds the processor's output |
| `DC` | Converts output data for the seven-segment display |
| `Pass` | Handles password authentication |
| `Clk_Div` | Generates a slower clock for hardware operation |
| `Top_Module` | Integrates the complete computer |

*Module names and functions should match the final source files in the repository.*

## 📘 Instruction Set Architecture

Each instruction is **8 bits wide**:

```text
┌───────────────┬────────────────┐
│ Opcode: 4 bits│ Operand: 4 bits│
└───────────────┴────────────────┘
```

The opcode selects the operation. The remaining four bits specify an address or operand, depending on the instruction.

| Opcode | Instruction | Description |
|:---:|---|---|
| `0000` | NOP | No operation |
| `0001` | INP | Read external input |
| `0010` | LDA | Load data into accumulator |
| `0011` | STA | Store accumulator in RAM |
| `0100` | ADD | Add an operand |
| `0101` | SUB | Subtract an operand |
| `0110` | AND | Bitwise AND |
| `0111` | CMP | Compare values |
| `1000` | XOR | Bitwise XOR |
| `1001` | JC | Jump if Carry is set |
| `1010` | SHL | Shift left |
| `1011` | SHR | Shift right |
| `1100` | OUT | Send accumulator value to output |
| `1101` | JMP | Unconditional jump |
| `1110` | JZ | Jump if Zero is set |
| `1111` | HLT | Halt execution |

## 🔄 How the Computer Works

**01 — Authenticate 🔐**  
The user enters the password through switches. The CPU remains disabled until authentication succeeds.

**02 — Fetch 📥**  
The Program Counter identifies the instruction address, and the instruction is fetched from RAM.

**03 — Decode 🧩**  
The Instruction Register holds the instruction while the Control Unit identifies the opcode and generates control signals.

**04 — Execute ⚡**  
The required registers, RAM, and ALU work together to perform the selected operation.

**05 — Update and Display 📺**  
The result and applicable status flags are updated. An `OUT` instruction sends the accumulator value to the output interface.

The Control Unit coordinates these actions through sequential timing states, from T0 to T5, according to the instruction being executed.

## 💾 Program Memory

The `hram.mem` file contains the binary instructions and data loaded into the 16 × 8-bit RAM.

Example instruction sequence:

```text
00101000   // LDA 8
01001001   // ADD 9
01011010   // SUB 10
11000000   // OUT
11110000   // HLT
```

For this example, RAM addresses 8, 9, and 10 should contain the intended operand values. Keep the program and data within the available 16 memory locations.

This sequence loads a value, performs arithmetic, displays the result, and halts. The exact output depends on the values stored in RAM.

## 🧪 Simulation and Testing

The project can be tested in Xilinx Vivado using a Verilog testbench.

1. Add all required Verilog source files to the project.
2. Add `Top_Module_tb.v` as the simulation testbench.
3. Ensure `hram.mem` is available at the path used by `$readmemb`.
4. Run behavioral simulation.
5. Inspect the clock, reset, instruction sequence, accumulator, flags, authentication status, and output signals.
6. Test each supported instruction and verify the expected result.

For hardware testing, program the FPGA with the correct constraints file and verify the switches, reset, clock, and seven-segment display connections.

## 🛠️ Tools and Technologies

- **Hardware Description Language:** Verilog HDL
- **Design and Simulation:** Xilinx Vivado
- **Target FPGA Board:** Real Digital Boolean Board
- **Architecture:** Custom 8-bit CPU
- **Memory Initialization:** `$readmemb` with `hram.mem`
- **Verification:** Verilog testbench and waveform analysis

## 🎯 What We Learned

- Designing and integrating modular digital systems.
- Understanding CPU architecture and instruction execution.
- Implementing registers, RAM, ALU operations, and control signals.
- Managing clocking, reset, and sequential logic.
- Testing RTL designs through simulation and waveforms.
- Connecting a processor design to FPGA hardware.
- Exploring password-based control and display interfacing.

## 🔮 Future Improvements

- Add a more advanced instruction set and addressing modes.
- Improve input/output interaction.
- Add debugging indicators for the Program Counter and instruction register.
- Support more informative display modes.
- Expand memory and processor capabilities.
- Explore interrupts or a simple pipelined architecture.

## 👥 Team

**Team:** Gryffindor

Developed as an educational hardware-design and hackathon project focused on learning computer architecture, Verilog HDL, and FPGA implementation.

## 🏁 Final Note

> **Every instruction tells a story. Every clock cycle makes it happen.**

This 8-bit computer is more than a collection of Verilog modules — it is a hands-on journey into the architecture behind real processors.

**Build. Simulate. Debug. Innovate.** ⚡

---

<p align="center">
  <b>Designed with Verilog HDL | Simulated with Vivado | Built to Learn</b>
</p>
