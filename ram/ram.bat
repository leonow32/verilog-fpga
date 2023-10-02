@echo off
iverilog -o ram.o ram.v ram_tb.v
vvp ram.o
del ram.o
