@echo off
iverilog -o decoder_7seg.o decoder_7seg.v decoder_7seg_tb.v
vvp decoder_7seg.o
del decoder_7seg.o
