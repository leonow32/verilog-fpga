@echo off
iverilog -o player.o player.v player_tb.v sound_generator.v ..\strobe_generator\strobe_generator.v
vvp player.o
del player.o
