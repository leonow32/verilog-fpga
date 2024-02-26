@echo off
iverilog -o top.o                                       ^
	top.v                                               ^
	top_tb.v                                            ^
	dds.v                                               ^
	../decoder_7seg/decoder_7seg.v                      ^
	../display_multiplexed_variable/display_multiplex.v ^
	../double_dabble_sequential/double_dabble.v         ^
	../edge_detector/edge_detector.v                    ^
	../frequency_meter/frequency_meter.v                ^
	../rom/rom.v                                        ^
	../rotary_encoder/encoder.v                         ^
	../strobe_generator/strobe_generator.v              ^
	../synchronizer/synchronizer.v
vvp top.o
del top.o
