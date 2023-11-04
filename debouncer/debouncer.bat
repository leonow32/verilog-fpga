@echo off
iverilog -o debouncer.o debouncer.v debouncer_tb.v ../edge_detector/edge_detector.v
vvp debouncer.o
del debouncer.o