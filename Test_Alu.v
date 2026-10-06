`timescale 1ns / 1ps

module Test_Alu;

reg [15:0] Operand1;
reg [15:0] Operand2;
reg [2:0] Alu_Opcode;
reg Shift;
wire [15:0] Result;
wire Zero_Out;
integer failures;

ALU uut (
    .Operand1(Operand1),
    .Operand2(Operand2),
    .Alu_Opcode(Alu_Opcode),
    .Shift(Shift),
    .Result(Result),
    .Zero_Out(Zero_Out)
);

task check_result;
    input [2:0] opcode;
    input [15:0] operand1;
    input [15:0] operand2;
    input shift_direction;
    input [15:0] expected;
    begin
        Alu_Opcode = opcode;
        Operand1 = operand1;
        Operand2 = operand2;
        Shift = shift_direction;
        #1;
        if (Result !== expected) begin
            $display("FAIL opcode=%b result=%h expected=%h",
                     opcode, Result, expected);
            failures = failures + 1;
        end
        if (Zero_Out !== (expected == 16'b0)) begin
            $display("FAIL opcode=%b zero flag=%b result=%h",
                     opcode, Zero_Out, expected);
            failures = failures + 1;
        end
    end
endtask

initial begin
    failures = 0;
    check_result(3'b000, 16'hffff, 16'h0001, 1'b0, 16'h0000);
    check_result(3'b001, 16'h0004, 16'h0003, 1'b0, 16'h0007);
    check_result(3'b010, 16'h0003, 16'h0002, 1'b0, 16'h000c);
    check_result(3'b010, 16'h8000, 16'h0001, 1'b1, 16'h4000);
    check_result(3'b011, 16'h8001, 16'h0001, 1'b0, 16'h0003);
    check_result(3'b011, 16'h8001, 16'h0001, 1'b1, 16'hc000);
    check_result(3'b011, 16'h1234, 16'h0000, 1'b0, 16'h1234);
    check_result(3'b100, 16'h002a, 16'h002a, 1'b0, 16'h0000);
    check_result(3'b100, 16'h0005, 16'h0003, 1'b0, 16'h0002);
    check_result(3'b101, 16'h0100, 16'h0005, 1'b0, 16'h0105);
    check_result(3'b110, 16'h0100, 16'h0005, 1'b0, 16'h0105);
    check_result(3'b111, 16'h1234, 16'h5678, 1'b0, 16'h0000);

    if (failures != 0)
        $fatal(1, "ALU test failed: %0d failure(s)", failures);

    $display("ALU tests passed.");
    $finish;
end

endmodule
