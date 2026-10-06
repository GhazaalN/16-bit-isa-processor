`timescale 1ns / 1ps

module Test_SignExtend;

reg [4:0] Immediate;
wire [15:0] Extended;

SignExtend uut (
    .Immediate(Immediate),
    .Extended(Extended)
);

initial begin
    Immediate = 5'b10010; // -14
    #1;
    if (Extended !== 16'hfff2)
        $fatal(1, "Sign extension failed for a negative immediate.");

    Immediate = 5'b00010; // 2
    #1;
    if (Extended !== 16'h0002)
        $fatal(1, "Sign extension failed for a positive immediate.");

    $display("Sign-extension tests passed.");
    $finish;
end

endmodule
