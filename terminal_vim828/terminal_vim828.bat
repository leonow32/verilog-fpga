@echo off
iverilog -o terminal_vim828.o ^
	terminal_vim828.v ^
	terminal_vim828_tb.v ^
	../decoder_14seg/decoder_14seg.v ^
	../display_lcd_vim828/vim828_defines.v ^
	../display_lcd_vim828/vim828.v ^
	../display_lcd_vim828/vim828_pwm.v ^
	../edge_detector/edge_detector.v ^
	../strobe_generator/strobe_generator.v ^
	../strobe_generator_ticks/strobe_generator_ticks.v ^
	../synchronizer/synchronizer.v ^
	../uart_rx/uart_rx.v ^
	../uart_tx/uart_tx.v
vvp terminal_vim828.o
del terminal_vim828.o
