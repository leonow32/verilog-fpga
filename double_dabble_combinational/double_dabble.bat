@echo off
iverilog -o double_dabble.o ^
	double_dabble.v ^
	double_dabble_tb.v
vvp double_dabble.o
del double_dabble.o
