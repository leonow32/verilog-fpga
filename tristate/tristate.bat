@echo off
iverilog -o tristate.o ^
	tristate.v         ^
	tristate_tb.v      
vvp tristate.o
del tristate.o
