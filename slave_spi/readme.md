# Slave SPI interface

![Status](https://img.shields.io/badge/STATUS-READY-green.svg)



![](photo.jpg)

## Instantiation

```verilog
	DDS DDS_inst(
		.Clock(Clock),
		.Reset(Reset),
		.TuningWord_i(),
		.Amplitude_i(),
		.Signal_o(),
		.Overflow_o()
	);
```

## Port description

+ **Clock** - Clock signal, active rising edge.
+ **Reset** - Asynchronous reset, active low.

## Simulation

![](simulation.png)

## Console output

	VCD info: dumpfile dds.vcd opened for output.
