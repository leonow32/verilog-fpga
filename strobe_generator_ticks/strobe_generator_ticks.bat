@echo off
iverilog -o strobe_generator_ticks.o strobe_generator_ticks.v strobe_generator_ticks_tb.v
vvp strobe_generator_ticks.o
del strobe_generator_ticks.o
