`timescale 1ns / 1ps

module Test_Pc;

reg Clk;
reg [15:0] PcInput;
wire [15:0] PcOutput;

Pc uut (
    .Clk(Clk),
    .PcInput(PcInput),
    .PcOutput(PcOutput)
);

initial begin
    Clk = 1'b0;
    PcInput = 16'd0;
    #1;
    if (PcOutput !== 16'd0)
        $fatal(1, "Program counter should initialize to zero.");

    PcInput = 16'd7;
    #1;
    Clk = 1'b1;
    #1;
    if (PcOutput !== 16'd7)
        $fatal(1, "Program counter did not capture its input.");

    Clk = 1'b0;
    PcInput = 16'd18;
    #1;
    Clk = 1'b1;
    #1;
    if (PcOutput !== 16'd18)
        $fatal(1, "Program counter did not update on the next rising edge.");

    $display("Program-counter tests passed.");
    $finish;
end

endmodule
