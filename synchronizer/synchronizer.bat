@echo off
iverilog -o synchronizer.o synchronizer.v synchronizer_tb.v
vvp synchronizer.o
del synchronizer.o
