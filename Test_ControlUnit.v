`timescale 1ns / 1ps

module Test_ControlUnit;

reg [2:0] Opcode;
wire Alu_Src;
wire Branch;
wire Mem_Write;
wire Reg_Write;
wire Jump;
wire Mem_To_Reg;
wire Reg_Dst;
integer failures;

ControlUnit uut (
    .Opcode(Opcode),
    .Alu_Src(Alu_Src),
    .Branch(Branch),
    .Mem_Write(Mem_Write),
    .Reg_Write(Reg_Write),
    .Jump(Jump),
    .Mem_To_Reg(Mem_To_Reg),
    .Reg_Dst(Reg_Dst)
);

task check_controls;
    input [2:0] opcode;
    input [6:0] expected;
    begin
        Opcode = opcode;
        #1;
        if ({Reg_Dst, Mem_To_Reg, Jump, Reg_Write,
             Mem_Write, Branch, Alu_Src} !== expected) begin
            $display("FAIL opcode=%b controls=%b expected=%b",
                     opcode,
                     {Reg_Dst, Mem_To_Reg, Jump, Reg_Write,
                      Mem_Write, Branch, Alu_Src},
                     expected);
            failures = failures + 1;
        end
    end
endtask

initial begin
    failures = 0;
    check_controls(3'b000, 7'b1001000);
    check_controls(3'b001, 7'b0001001);
    check_controls(3'b010, 7'b1001000);
    check_controls(3'b011, 7'b1001000);
    check_controls(3'b100, 7'b0000010);
    check_controls(3'b101, 7'b0000101);
    check_controls(3'b110, 7'b0101001);
    check_controls(3'b111, 7'b0010000);

    if (failures != 0)
        $fatal(1, "Control-unit test failed: %0d failure(s)", failures);

    $display("Control-unit tests passed.");
    $finish;
end

endmodule
