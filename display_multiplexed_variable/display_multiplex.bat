@echo off
iverilog -o display_multiplex.o display_multiplex.v display_multiplex_tb.v ../decoder_7seg/decoder_7seg.v ../strobe_generator/strobe_generator.v
vvp display_multiplex.o
del display_multiplex.o
