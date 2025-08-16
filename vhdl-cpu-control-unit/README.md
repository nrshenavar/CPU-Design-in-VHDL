# VHDL CPU Control Unit Project

## Overview
This project implements a CPU control unit in VHDL, which includes various components such as registers, an ALU, a memory module, and control logic. The design is modular, allowing for easy testing and integration of each component.

## Project Structure
The project is organized into the following directories and files:

- **src/**: Contains the VHDL source files for the CPU components.
  - **control_unit.vhd**: Implements the control unit that generates control signals based on the instruction opcode.
  - **alu.vhd**: Defines the arithmetic logic unit (ALU) for performing operations.
  - **register_file.vhd**: Implements the register file for reading and writing registers.
  - **immediate_gen.vhd**: Generates immediate values for instructions like `lw` and `sw`.
  - **memory.vhd**: Implements the memory module for data and instruction storage.
  - **mux.vhd**: Defines multiplexers for selecting data sources.
  - **registers/**: Contains individual register implementations.
    - **reg_a.vhd**: Register A for ALU operations.
    - **reg_b.vhd**: Register B for ALU operations.
    - **reg_pc.vhd**: Program counter (PC) for instruction tracking.
    - **reg_ir.vhd**: Instruction register (IR) for holding the current instruction.
    - **reg_aluout.vhd**: ALU output register for storing results.
    - **reg_mdr.vhd**: Memory data register (MDR) for data transfer.
  - **types/**: Contains type definitions and constants.
    - **index.vhd**: Defines instruction formats and control signals.

- **asm/**: Contains assembly instructions and binary encoding.
  - **instructions.asm**: Assembly code for loading values, performing operations, and saving results.
  - **mem_input.txt**: Binary encoding of assembly instructions formatted into 32 bits.

- **sim/**: Contains simulation files.
  - **cpu_tb.vhd**: Testbench for simulating the CPU and capturing output.
  - **mem_output.txt**: Output of the simulation showing results of executed instructions.

## Setup Instructions
1. Ensure you have a VHDL simulator installed.
2. Clone the repository or download the project files.
3. Navigate to the `src` directory and compile the VHDL files.
4. Load the testbench from the `sim` directory and run the simulation.
5. Check the `mem_output.txt` file for the results of the executed instructions.

## Usage
- Modify the `instructions.asm` file to change the assembly instructions.
- Re-generate the `mem_input.txt` file to reflect any changes in the assembly code.
- Run the simulation to see how the CPU executes the instructions and captures the output.

## Conclusion
This project serves as a foundational design for a CPU control unit in VHDL, demonstrating the integration of various components and their interactions. It can be extended or modified for further experimentation and learning in digital design and computer architecture.