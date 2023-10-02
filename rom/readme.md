# ROM Memory

![Status](https://img.shields.io/badge/STATUS-READY-green.svg)

Read only memory. This module can be used to store permanent information, such as the code of a program executed by the processor, for example.

## Instantiation

```verilog
	ROM #(
		.ADDRESS_WIDTH(),
		.DATA_WIDTH(),
		.MEMORY_DEPTH(),
		.MEMORY_FILE("data.mem")
	) ROM_inst(
		.Clock(Clock),
		.Reset(Reset),
		.ReadEnable_i(),
		.Address_i(),
		.Data_o()
	);
```

## Port description

+ **ADDRESS_WIDTH** - Number of address bus bits. Determines the size of the memory. The memory size is equal to 2^ADDRESS_WIDTH.
+ **DATA_WIDTH** - Number of data bus bits. Most common values are 8, 16 and 32. 
+ **MEMORY_DEPTH** - Number of words in the memory array.
+ **MEMORY_FILE** - A file with the contents of the memory to be loaded as soon as the device starts up.
+ **Clock** - Clock signal, active rising edge.
+ **Reset** - Asynchronous reset, active low.
+ **ReadEnable_i** - If 1 then on the next clock edge the requested data is ready.
+ **Address_i[ADDRESS_WIDTH-1:0]** - Address of the byte requested to be read on the next clock edge.
+ **Data_o[DATA_WIDTH-1:0]** - Value of the requested byte.
    
## Simulation

![Simulation](simulation.png "Simulation")

## Console output

	VCD info: dumpfile rom.vcd opened for output.
	===== START =====
	MEMORY_DEPTH: 16
	Memory[          0] = 0f
	Memory[          1] = 1e
	Memory[          2] = 2d
	Memory[          3] = 3c
	Memory[          4] = 4b
	Memory[          5] = 5a
	Memory[          6] = 69
	Memory[          7] = 78
	Memory[          8] = 87
	Memory[          9] = 96
	Memory[         10] = a5
	Memory[         11] = b4
	Memory[         12] = c3
	Memory[         13] = d2
	Memory[         14] = e1
	Memory[         15] = f0
	===== END =====
	rom_tb.v:70: $finish called at 400 (1ns)
