`timescale 1ns / 1ps

module InstructionMemory(
    input  [15:0] Address,
    output [15:0] Instruction
);

reg [15:0] Memory [0:511];
integer i;

initial begin
    // Initialize unused instruction locations to ADD $0,$0,$0 (a no-op
    // because register zero is hard-wired to zero).
    for (i = 0; i < 512; i = i + 1)
        Memory[i] = 16'b0;

    // Example program: calculate the dot product of [3,4] and [1,2].
    // The program uses repeated addition for multiplication.
    Memory[0]  = 16'b001_0000_0000_1111_0;  // addi $15,$0,0: accumulator
    Memory[1]  = 16'b001_0000_0001_00010;   // addi $1,$0,2: vector length
    Memory[2]  = 16'b000_0000_0000_0010_0;  // add  $2,$0,$0: first vector pointer
    Memory[3]  = 16'b000_0000_0001_0011_0;  // add  $3,$0,$1: second vector pointer
    Memory[4]  = 16'b100_0001_0010_01101;   // beq  $1,$2,13: branch to instruction 18
    Memory[5]  = 16'b110_0010_0100_00000;  // lw   $4,0($2)
    Memory[6]  = 16'b110_0011_0101_00000;  // lw   $5,0($3)
    Memory[7]  = 16'b000_0000_0000_0110_0;  // add  $6,$0,$0: multiplication counter
    Memory[8]  = 16'b000_0000_0000_0111_0;  // add  $7,$0,$0: product
    Memory[9]  = 16'b100_0110_0100_00011;   // beq  $6,$4,3: end repeated addition
    Memory[10] = 16'b000_0101_0111_0111_0;  // add  $7,$5,$7
    Memory[11] = 16'b001_0110_0110_00001;   // addi $6,$6,1
    Memory[12] = 16'b111_0000_0000_01001;   // j    9
    Memory[13] = 16'b001_0011_0011_00001;   // addi $3,$3,1
    Memory[14] = 16'b001_0010_0010_00001;   // addi $2,$2,1
    Memory[15] = 16'b000_0111_1111_1111_0;  // add  $15,$7,$15: accumulate product
    Memory[16] = 16'b101_1010_1111_10000;   // sw   $15,16($10)
    Memory[17] = 16'b111_0000_0000_00100;   // j    4
    Memory[18] = 16'b101_0011_1111_00000;   // sw   $15,0($3): save final result
end

// Return a no-op for addresses outside the 512-word instruction memory.
assign Instruction = (Address < 16'd512) ? Memory[Address[8:0]] : 16'b0;

endmodule
