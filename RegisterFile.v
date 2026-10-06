`timescale 1ns / 1ps

module RegisterFile(
    input  [3:0]  Read_Register1,
    input  [3:0]  Read_Register2,
    input  [3:0]  Write_Reg,
    input  [15:0] Write_Data,
    input         Clk,
    input         RegWrite,
    output reg [15:0] Read_Data1,
    output reg [15:0] Read_Data2
);

reg [15:0] Registers [0:15];
integer i;

initial begin
    for (i = 0; i < 16; i = i + 1)
        Registers[i] = 16'b0;

    // Preserve the original example initialization; the program overwrites
    // register 1 before using it.
    Registers[1] = 16'h1000;
end

// Combinational reads and rising-edge writes make register operands,
 // instruction decode, and write-back line up in the single-cycle CPU.
always @(*) begin
    Read_Data1 = (Read_Register1 == 4'd0) ? 16'b0 : Registers[Read_Register1];
    Read_Data2 = (Read_Register2 == 4'd0) ? 16'b0 : Registers[Read_Register2];
end

always @(posedge Clk) begin
    if (RegWrite && (Write_Reg != 4'd0))
        Registers[Write_Reg] <= Write_Data;
end

endmodule
