@echo off
iverilog -o top.o ^
	top.v ^
	vga.v ^
	top_tb.v ^
	../../edge_detector/edge_detector.v ^
	../../ram_pseudo_dual_port/ram_pdp.v ^
	../../slave_spi/slave_spi.v ^
	../../synchronizer/synchronizer.v 
	
vvp top.o
del top.o
