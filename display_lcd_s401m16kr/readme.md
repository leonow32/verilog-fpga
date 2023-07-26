# LCD Multiplexed display - driver for S401M16KR display

>**Status**: ready


![Pinout](pinout.png "Pinout")

The display should be connected to the FPGA this way. There are RC filters for each pin of the display to filter out the noise coming from PWM. RC filters should be placed as close to FPGA as possible.

![Schematic](schematic.png "Schematic")



## Instantiation

    LCD #(
		.CLOCK_HZ(CLOCK_HZ),
		.CHANGE_COM_US(50)
	) LCD_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Digit3_i(),
		.Digit2_i(),
		.Digit1_i(),
		.Digit0_i(),
		.ComPWM_o(),
		.SegPWM_o()
	);
    
## Port description

+ **CLOCK_HZ** - Clock signal frequency [Hz].
+ **CHANGE_COM_US** - The time how long each COM is active in [us].
+ **DIGITS** - The number of digits in the display.
+ **Clock** - Clock signal, active rising edge.
+ **Reset** - Asynchronous reset, active low.
+ **Digit3_i[7:0]** - 
+ **Digit2_i[7:0]** - 
+ **Digit1_i[7:0]** - 
+ **ComPWM_o[3:0]** - 
+ **SegPWM_o[3:0]** - 

## Simulation

Example of displaying .................

![Simulation](simulation.png "Simulation")

## Console output

	VCD info: dumpfile lcd.vcd opened for output.
	VCD warning: array word LCD_tb.DUT.ComAnalog[0] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.ComAnalog[1] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.ComAnalog[2] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.ComAnalog[3] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.SegAnalog[0] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.SegAnalog[1] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.SegAnalog[2] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.SegAnalog[3] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.SegAnalog[4] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.SegAnalog[5] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.SegAnalog[6] will conflict with an escaped identifier.
	VCD warning: array word LCD_tb.DUT.SegAnalog[7] will conflict with an escaped identifier.
	===== START =====
	CLOCK_HZ =   1000000
		  time C0 C1 C2 C3 S0 S1 S2 S3 S4 S5 S6 S7
	   0.001us  3  1  1  1  2  2  2  2  2  2  2  2 
	  51.000us  1  3  1  1  2  2  2  0  2  2  2  2 
	 101.000us  1  1  3  1  2  2  2  2  2  2  2  2 
	 151.000us  1  1  1  3  2  2  2  2  2  2  2  2 
	 201.000us  0  2  2  2  1  1  1  1  1  1  1  1 
	 251.000us  2  0  2  2  1  1  1  3  1  1  1  1 
	 301.000us  2  2  0  2  1  1  1  1  1  1  1  1 
	 351.000us  2  2  2  0  1  1  1  1  1  1  1  1 
	===== END =====
	lcd_tb.v:91: $finish called at 400002 (1ns)

