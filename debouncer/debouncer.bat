@echo off
iverilog -o debouncer.o debouncer.v debouncer_tb.v
vvp debouncer.o
del debouncer.o