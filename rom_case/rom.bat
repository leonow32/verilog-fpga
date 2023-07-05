@echo off
iverilog -o rom.o rom.v rom_tb.v
vvp rom.o
del rom.o
