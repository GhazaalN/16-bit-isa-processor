`timescale 1ns / 1ps

module Test_Mux21;

reg [15:0] Operand1;
reg [15:0] Operand2;
reg SelectorInput;
wire [15:0] Result;

Mux2_1_16bit uut (
    .Operand1(Operand1),
    .Operand2(Operand2),
    .SelectorInput(SelectorInput),
    .Result(Result)
);

initial begin
    Operand1 = 16'h1234;
    Operand2 = 16'habcd;
    SelectorInput = 1'b0;
    #1;
    if (Result !== Operand1)
        $fatal(1, "Mux should select Operand1 when selector is zero.");

    SelectorInput = 1'b1;
    #1;
    if (Result !== Operand2)
        $fatal(1, "Mux should select Operand2 when selector is one.");

    $display("16-bit multiplexer tests passed.");
    $finish;
end

endmodule
