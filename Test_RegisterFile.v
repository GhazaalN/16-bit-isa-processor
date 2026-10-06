`timescale 1ns / 1ps

module Test_RegisterFile;

reg [3:0] Read_Register1;
reg [3:0] Read_Register2;
reg [3:0] Write_Reg;
reg [15:0] Write_Data;
reg Clk;
reg RegWrite;
wire [15:0] Read_Data1;
wire [15:0] Read_Data2;

RegisterFile uut (
    .Read_Register1(Read_Register1),
    .Read_Register2(Read_Register2),
    .Write_Reg(Write_Reg),
    .Write_Data(Write_Data),
    .Clk(Clk),
    .RegWrite(RegWrite),
    .Read_Data1(Read_Data1),
    .Read_Data2(Read_Data2)
);

initial begin
    Clk = 1'b0;
    RegWrite = 1'b0;
    Read_Register1 = 4'd0;
    Read_Register2 = 4'd1;
    Write_Reg = 4'd0;
    Write_Data = 16'hdead;
    #1;
    if (Read_Data1 !== 16'b0 || Read_Data2 !== 16'h1000)
        $fatal(1, "Register initialization/read check failed.");

    // Register zero must ignore writes.
    RegWrite = 1'b1;
    #1;
    Clk = 1'b1;
    #1;
    Clk = 1'b0;
    Read_Register1 = 4'd0;
    #1;
    if (Read_Data1 !== 16'b0)
        $fatal(1, "Register zero changed after a write.");

    // Normal registers accept writes on the rising clock edge.
    Write_Reg = 4'd3;
    Write_Data = 16'h0020;
    Read_Register1 = 4'd3;
    #1;
    Clk = 1'b1;
    #1;
    if (Read_Data1 !== 16'h0020)
        $fatal(1, "Register write/read check failed.");

    $display("Register-file tests passed.");
    $finish;
end

endmodule
