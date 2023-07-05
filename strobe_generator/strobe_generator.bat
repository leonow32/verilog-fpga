@echo off
iverilog -o strobe_generator.o strobe_generator.v strobe_generator_tb.v
vvp strobe_generator.o
del strobe_generator.o
