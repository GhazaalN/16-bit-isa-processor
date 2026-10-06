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

The instruction word is 16 bits. The opcode is `[15:13]`; the register fields are `[12:9]` and `[8:5]`; the low five bits are used as an immediate for immediate, load/store, branch, and jump instructions. For register-format instructions, `[4:1]` selects the destination and bit `[0]` selects shift direction.

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

The sample program and initial data memory are embedded in the HDL source. The sample computes `3×1 + 4×2 = 11`, stores the running result at data-memory address 16, and writes the final result at address 4.

## Simulate

The self-checking testbenches are named `Test_*.v`. With Icarus Verilog installed, compile a unit test by listing its design files and testbench, then run it with `vvp`. For example:

```sh
iverilog -g2012 -s Test_Alu -o test_alu ALU.v Test_Alu.v
vvp test_alu

iverilog -g2012 -s Test_CPU -o test_cpu   CPU.v Pc.v InstructionMemory.v ControlUnit.v RegisterFile.v   Mux2_1_16bit.v Mux_4bit.v SignExtend.v ALU.v   Adder_16bit.v DataMemoryUnit.v Test_CPU.v
vvp test_cpu
```

The repository also contains historical Xilinx ISE reports and waveform files from the original project. They are not required for the Icarus simulation examples above.

## Limitations

This is a small teaching design, not a production CPU. It has no reset input, uses initialized memories, and its data memory is limited to 201 words. The HDL has been updated for deterministic simulation and the testbenches document the intended behavior; FPGA synthesis and timing have not been validated here.

## License

No license is currently specified. Ask the repository owner before reusing or redistributing the code.
