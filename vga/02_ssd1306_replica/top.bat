@echo off
iverilog -o top.o ^
	top.v ^
	top_tb.v ^
	../../edge_detector/edge_detector.v ^
	../../slave_spi/slave_spi.v ^
	../../synchronizer/synchronizer.v 
	
vvp top.o
del top.o
