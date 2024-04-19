@echo off
iverilog -o top.o                                       ^
	top.v                                               ^
	top_tb.v                                            ^
	slave_spi.v                                         ^
	../decoder_7seg/decoder_7seg.v                      ^
	../display_multiplexed_variable/display_multiplex.v ^
	../edge_detector/edge_detector.v                    ^
	../strobe_generator/strobe_generator.v              ^
	../synchronizer/synchronizer.v                      
vvp top.o
del top.o
