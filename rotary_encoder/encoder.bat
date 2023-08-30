@echo off
iverilog -o encoder.o encoder.v encoder_tb.v ../synchronizer/synchronizer.v
vvp encoder.o
del encoder.o
