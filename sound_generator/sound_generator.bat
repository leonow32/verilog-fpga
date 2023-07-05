@echo off
iverilog -o sound_generator.o sound_generator.v sound_generator_tb.v ..\strobe_generator\strobe_generator.v
vvp sound_generator.o
del sound_generator.o
