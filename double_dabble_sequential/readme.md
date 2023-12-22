# Binary to BCD converter - Double Dabble algorithm (sequential)

![Status](https://img.shields.io/badge/STATUS-READY-green.svg)

Converter of binary values to BCD code, which is often used by display controllers. It uses the Double Dabble algorithm in a sequential implementation.

Testbench tries to convert all possible values from zero to maximum and from maximum to zero. After the test, it shows how many attempts were successful and failed.

## Instantiation

```verilog
	DoubleDabble #(
		.INPUT_BITS(),
		.OUTPUT_DIGITS()
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Start_i(),
		.Busy_o(),
		.Done_o(),
		.Binary_i(),
		.BCD_o()
	);
```

## Port description

+ **INPUT_BITS** - The number of bits of the input value.
+ **OUTPUT_DIGITS** - How many digits are to be included in the result. 
+ **OUTPUT_BITS** - Optional parameter. Defaults to `OUTPUT_DIGITS` * 4, since there are 4 bits for each digit in the BCD code. However, if the most significant digit can change in an incomplete range (e.g. from 0 to 3) then there is no need for 4 bits, but 2.
+ **Clock** - Clock signal, active rising edge.
+ **Reset** - Asynchronous reset, active low.
+ **Start_i** - High strobe initiates the process.
+ **Busy_o** - High as long as the process is in ongoing.
+ **Done_o** - A single high pulse signals the end of the operation and the result is available at the output.
+ **Binary_i** - Input binary value.
+ **BCD_o** - Output in BCD code.

## Simulation

![Simulation](simulation.png "Simulation")

## Console output

	VCD info: dumpfile double_dabble.vcd opened for output.
	===== START =====
	INPUT_BITS:            8
	OUTPUT_BITS:          12
	OUTPUT_DIGITS:         3
	MaxInput:            255
	Pass:         512
	Fail:           0
	====== END ======
	double_dabble_tb.v:130: $finish called at 9218000 (1ns)
