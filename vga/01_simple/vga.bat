@echo off
iverilog -o vga.o ^
	vga.v ^
	vga_tb.v
vvp vga.o
del vga.o
