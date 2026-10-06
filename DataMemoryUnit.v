`timescale 1ns / 1ps

module DataMemoryUnit(
    input  [15:0] Address,
    input  [15:0] Write_Data,
    input         Clk,
    input         MemWrite,
    output [15:0] Read_Data
);

reg [15:0] Memory [0:200];
integer i;

initial begin
    for (i = 0; i <= 200; i = i + 1)
        Memory[i] = 16'b0;

    // Example input vectors for the dot-product program.
    Memory[0] = 16'd3;
    Memory[1] = 16'd4;
    Memory[2] = 16'd1;
    Memory[3] = 16'd2;
end

// Invalid addresses read as zero; a write outside the memory is ignored.
assign Read_Data = (MemWrite || (Address >= 16'd201))
                 ? 16'b0
                 : Memory[Address[7:0]];

always @(posedge Clk) begin
    if (MemWrite && (Address < 16'd201))
        Memory[Address[7:0]] <= Write_Data;
end

endmodule
