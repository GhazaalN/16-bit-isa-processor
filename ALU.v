`timescale 1ns / 1ps

module ALU(
    input  [15:0] Operand1,
    input  [15:0] Operand2,
    input  [2:0]  Alu_Opcode,
    input         Shift,
    output [15:0] Result,
    output        Zero_Out
);

reg [15:0] Temp;
reg IsZero;
reg [3:0] ShiftAmount;

assign Result = Temp;
assign Zero_Out = IsZero;

always @(*) begin
    Temp = 16'b0;
    ShiftAmount = Operand2[3:0];

    case (Alu_Opcode)
        3'b000, 3'b001: begin
            // ADD and ADDI
            Temp = Operand1 + Operand2;
        end

        3'b010: begin
            // Shift by a 4-bit amount (0 to 15); Shift=1 means right.
            if (Shift)
                Temp = Operand1 >> ShiftAmount;
            else
                Temp = Operand1 << ShiftAmount;
        end

        3'b011: begin
            // Rotate by a 4-bit amount; a zero shift leaves the value unchanged.
            if (ShiftAmount == 4'b0000)
                Temp = Operand1;
            else if (Shift)
                Temp = (Operand1 >> ShiftAmount) |
                       (Operand1 << (16 - ShiftAmount));
            else
                Temp = (Operand1 << ShiftAmount) |
                       (Operand1 >> (16 - ShiftAmount));
        end

        3'b100: begin
            // BEQ compares the two register operands.
            Temp = Operand1 - Operand2;
        end

        3'b101, 3'b110: begin
            // SW and LW calculate the effective address: base + offset.
            Temp = Operand1 + Operand2;
        end

        default: begin
            // Includes the unused ALU result for J.
            Temp = 16'b0;
        end
    endcase

    IsZero = (Temp == 16'b0);
end

endmodule
