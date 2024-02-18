@echo off
iverilog -o dds.o ^
	dds.v ^
	dds_tb.v
vvp dds.o
del dds.o
