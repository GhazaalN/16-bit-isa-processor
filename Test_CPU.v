`timescale 1ns / 1ps

module Test_CPU;

reg Clk;
wire [15:0] Temp;
wire [15:0] ReadData1;
wire [15:0] ReadData2;
wire [15:0] Finalextend;
wire Zero;
integer cycle;

CPU uut (
    .Clk(Clk),
    .Temp(Temp),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .Finalextend(Finalextend),
    .Zero(Zero)
);

initial begin
    Clk = 1'b0;
    forever #5 Clk = ~Clk;
end

initial begin
    // Allow the sample program to complete and reach its no-op region.
    for (cycle = 0; cycle < 200; cycle = cycle + 1)
        @(posedge Clk);
    #1;

    if (uut.RegFile1.Registers[15] !== 16'd11)
        $fatal(1, "Expected dot product 11 in register 15; got %0d.",
               uut.RegFile1.Registers[15]);

    if (uut.dataMemory.Memory[16] !== 16'd11)
        $fatal(1, "Expected intermediate result 11 at data-memory address 16.");

    if (uut.dataMemory.Memory[4] !== 16'd11)
        $fatal(1, "Expected final result 11 at data-memory address 4.");

    $display("CPU integration test passed: 3*1 + 4*2 = 11.");
    $finish;
end

endmodule
