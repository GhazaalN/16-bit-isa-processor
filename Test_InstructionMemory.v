`timescale 1ns / 1ps

module Test_InstructionMemory;

reg [15:0] Address;
wire [15:0] Instruction;

InstructionMemory uut (
    .Address(Address),
    .Instruction(Instruction)
);

initial begin
    Address = 16'd0;
    #1;
    if (Instruction !== 16'b001_0000_0000_1111_0)
        $fatal(1, "Instruction memory did not retain instruction 0.");

    Address = 16'd18;
    #1;
    if (Instruction !== 16'b101_0011_1111_00000)
        $fatal(1, "Instruction memory did not retain instruction 18.");

    Address = 16'd512;
    #1;
    if (Instruction !== 16'b0)
        $fatal(1, "Out-of-range instruction reads should return a no-op.");

    $display("Instruction-memory tests passed.");
    $finish;
end

endmodule
