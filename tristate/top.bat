@echo off
iverilog -o top.o                                       ^
	top.v                                               ^
	top_tb.v                                            ^
	tristate.v
vvp top.o
del top.o
