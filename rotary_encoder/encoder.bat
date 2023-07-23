@echo off
iverilog -o encoder.o encoder.v encoder_tb.v
vvp encoder.o
del encoder.o
