`timescale 1ns / 1ps

module Pc(
    input  Clk,
    input  [15:0] PcInput,
    output [15:0] PcOutput
);

reg [15:0] Counter;

initial begin
    Counter = 16'b0;
end

assign PcOutput = Counter;

always @(posedge Clk) begin
    Counter <= PcInput;
end

endmodule
