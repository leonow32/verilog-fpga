@echo off
iverilog -o slave_spi.o ^
	slave_spi.v         ^
	slave_spi_tb.v      ^
	../edge_detector/edge_detector.v ^
	../synchronizer/synchronizer.v
vvp slave_spi.o
del slave_spi.o
