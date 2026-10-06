# 16-Bit ISA Processor

An educational 16-bit processor written in Verilog. The design includes a custom instruction set, a register file, an ALU, instruction and data memories, and a sample program that computes the dot product of two two-element vectors using repeated addition.

## Architecture

The top-level module is `CPU`. Its main components are:

- `Pc.v`: 16-bit program counter
- `InstructionMemory.v`: 512-word instruction memory and sample program
- `ControlUnit.v`: opcode decoding and control signals
- `RegisterFile.v`: sixteen 16-bit registers; register 0 always reads as zero
- `ALU.v`: arithmetic, shifts, rotates, branch comparison, and effective-address calculation
- `DataMemoryUnit.v`: 201-word data memory
- `Adder_16bit.v`, `Mux2_1_16bit.v`, `Mux_4bit.v`, `SignExtend.v`: datapath helpers

## Instruction formats

Each instruction is 16 bits, with the opcode in `[15:13]`.

- **Register format:** `[12:9]` and `[8:5]` are source registers; `[4:1]` is the destination; `[0]` selects shift or rotate direction.
- **Immediate format:** `[12:9]` is the base/source register, `[8:5]` is the destination or second source, and `[4:0]` is a signed immediate.
- **Jump format:** `[12:0]` is the target instruction address.

## Opcode map

| Opcode | Instruction | Behavior |
| --- | --- | --- |
| `000` | ADD | Add two register operands |
| `001` | ADDI | Add a sign-extended 5-bit immediate |
| `010` | SHIFT | Shift left or right by the low 4 bits of the second operand |
| `011` | ROTATE | Rotate left or right by the low 4 bits of the second operand |
| `100` | BEQ | Branch when the two register operands are equal |
| `101` | SW | Store a register at base plus signed offset |
| `110` | LW | Load from base plus signed offset |
| `111` | J | Jump to the encoded instruction address |

The sample program and initial data memory are embedded in the HDL source. It calculates `3×1 + 4×2 = 11`, stores an intermediate result at data-memory address 16, and writes the final result at address 4.

## Simulate

Self-checking benches cover the ALU, control unit, data memory, instruction memory, program counter, register file, sign extension, and CPU integration. With Icarus Verilog installed, run a unit test by compiling the design file(s) and its testbench, then launching the output with `vvp`. For example:

```sh
iverilog -g2012 -s Test_Alu -o test_alu ALU.v Test_Alu.v
vvp test_alu

iverilog -g2012 -s Test_CPU -o test_cpu CPU.v Pc.v InstructionMemory.v ControlUnit.v RegisterFile.v Mux2_1_16bit.v Mux_4bit.v SignExtend.v ALU.v Adder_16bit.v DataMemoryUnit.v Test_CPU.v
vvp test_cpu
```

The repository also contains historical Xilinx ISE reports and waveform files from the original project. They are not required for the Icarus simulation examples above.

## Limitations

This is a small teaching design, not a production CPU. It has no reset input, uses initialized memories, and its data memory is limited to 201 words. FPGA synthesis and timing have not been validated here.

## License

No license is currently specified. Ask the repository owner before reusing or redistributing the code.
