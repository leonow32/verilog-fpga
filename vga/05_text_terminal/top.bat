@echo off
iverilog -o top.o 											^
	top.v 													^
	top_tb.v 												^
	memory.v												^
	vga.v													^
	../../edge_detector/edge_detector.v						^
	../../ram_pseudo_dual_port/ram_pdp.v					^
	../../rom/rom.v											^
	../../strobe_generator_ticks/strobe_generator_ticks.v	^
	../../synchronizer/synchronizer.v						^
	../../uart_rx/uart_rx.v 								^
	../../uart_tx/uart_tx.v 								^
	
vvp top.o
del top.o
