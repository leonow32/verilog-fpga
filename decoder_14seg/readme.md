# 14 Segment Display Decoder

![Status](https://img.shields.io/badge/STATUS-DEVELOPMENT-yellow.svg)

Simple module to convert 8-bit ASCII data into 14-segment code that can drive a 14-segment display. Supports displaying digits from 0 to 9, letters from A to Z and some other characters. Designed to be used with `display_lcd_vim828`.

## Instantiation

```verilog
	Decoder14seg Decoder14seg_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Enable_i(),
		.Data_i(),
		.Segments_o()
	);
```

## Port description

+ **Clock** - Clock signal, active rising edge.
+ **Reset** - Asynchronous reset, active low.
+ **Enable_i** - If 1 then display is enabled, if 0 then all segments are disabled.
+ **Data_i[7:0]** - ASCII code to be displayed.
+ **Segments_o[13:0]** - Driver output.
    
## Simulation

![Simulation](simulation.png "Simulation")

## Console output

	VCD info: dumpfile decoder_14seg.vcd opened for output.
	===== START =====
	====== END ======
	decoder_14seg_tb.v:48: $finish called at 99000 (1ns)
