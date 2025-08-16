// This file contains assembly instructions for the CPU, including loading values into registers, performing operations, and saving results in memory.

// Load immediate values into registers
LOAD A, 5      // Load the value 5 into register A
LOAD B, 10     // Load the value 10 into register B

// Perform arithmetic operations
ADD A, B       // Add the values in registers A and B, result in A
SUB A, B       // Subtract the value in register B from A, result in A
AND A, B       // Perform bitwise AND on A and B, result in A
OR A, B        // Perform bitwise OR on A and B, result in A

// Load word from memory
LW A, 0x00    // Load word from memory address 0x00 into register A
SW A, 0x04    // Store the value in register A into memory address 0x04

// Branch if equal
BEQ A, B, 0x08 // If A equals B, branch to address 0x08

// End of instructions
HALT            // Stop execution