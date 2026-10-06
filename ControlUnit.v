`timescale 1ns / 1ps

module ControlUnit (
    input  [2:0] Opcode,
    output       Alu_Src,
    output       Branch,
    output       Mem_Write,
    output       Reg_Write,
    output       Jump,
    output       Mem_To_Reg,
    output       Reg_Dst
);

// Temp bit order: {Reg_Dst, Mem_To_Reg, Jump, Reg_Write,
//                  Mem_Write, Branch, Alu_Src}
reg [6:0] Temp;

assign Alu_Src   = Temp[0];
assign Branch    = Temp[1];
assign Mem_Write = Temp[2];
assign Reg_Write = Temp[3];
assign Jump      = Temp[4];
assign Mem_To_Reg = Temp[5];
assign Reg_Dst   = Temp[6];

always @(*) begin
    // Safe defaults also define behavior for unknown or unsupported opcodes.
    Temp = 7'b0000000;

    case (Opcode)
        3'b000: Temp = 7'b1001000; // ADD: register operands, rd destination
        3'b001: Temp = 7'b0001001; // ADDI: immediate operand, rt destination
        3'b010: Temp = 7'b1001000; // Shift: register operands, rd destination
        3'b011: Temp = 7'b1001000; // Rotate: register operands, rd destination
        3'b100: Temp = 7'b0000010; // BEQ: compare rs and rt, branch on zero
        3'b101: Temp = 7'b0000101; // SW: base plus immediate, write memory
        3'b110: Temp = 7'b0101001; // LW: base plus immediate, write rt from memory
        3'b111: Temp = 7'b0010000; // J
        default: Temp = 7'b0000000;
    endcase
end

endmodule
