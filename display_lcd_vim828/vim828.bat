@echo off
iverilog -o vim828.o vim828.v vim828_defines.vh vim828_tb.v vim828_pwm.v ../strobe_generator/strobe_generator.v
vvp vim828.o
del vim828.o
