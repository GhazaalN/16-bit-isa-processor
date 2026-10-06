`timescale 1ns / 1ps

module Test_DataMemoryUnit;

reg [15:0] Address;
reg [15:0] Write_Data;
reg Clk;
reg MemWrite;
wire [15:0] Read_Data;

DataMemoryUnit uut (
    .Address(Address),
    .Write_Data(Write_Data),
    .Clk(Clk),
    .MemWrite(MemWrite),
    .Read_Data(Read_Data)
);

initial begin
    Clk = 1'b0;
    MemWrite = 1'b0;
    Address = 16'd0;
    Write_Data = 16'd0;
    #1;
    if (Read_Data !== 16'd3)
        $fatal(1, "Memory[0] should initially contain 3.");

    Address = 16'd2;
    #1;
    if (Read_Data !== 16'd1)
        $fatal(1, "Memory[2] should initially contain 1.");

    Address = 16'd5;
    Write_Data = 16'h1234;
    MemWrite = 1'b1;
    #1;
    Clk = 1'b1;
    #1;
    Clk = 1'b0;
    MemWrite = 1'b0;
    #1;
    if (Read_Data !== 16'h1234)
        $fatal(1, "Data-memory write/read check failed.");

    Address = 16'd201;
    #1;
    if (Read_Data !== 16'b0)
        $fatal(1, "Out-of-range reads should return zero.");

    MemWrite = 1'b1;
    Write_Data = 16'hffff;
    Clk = 1'b1;
    #1;
    Clk = 1'b0;
    MemWrite = 1'b0;
    Address = 16'd200;
    #1;
    if (Read_Data !== 16'b0)
        $fatal(1, "Out-of-range writes must be ignored.");

    $display("Data-memory tests passed.");
    $finish;
end

endmodule
