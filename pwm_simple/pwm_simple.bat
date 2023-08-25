@echo off
iverilog -o pwm_simple.o pwm_simple.v pwm_simple_tb.v
vvp pwm_simple.o
del pwm_simple.o
