@echo off
iverilog -o decoder_14seg.o decoder_14seg.v decoder_14seg_tb.v
vvp decoder_14seg.o
del decoder_14seg.o
