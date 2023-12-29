@echo off
iverilog -o top.o ^
	top.v ^
	top_tb.v ^
	double_dabble.v ^
	../rotary_encoder/encoder.v ^
	../synchronizer/synchronizer.v ^
	../edge_detector/edge_detector.v ^
	../display_multiplexed_variable/display_multiplex.v ^
	../decoder_7seg/decoder_7seg.v ^
	../strobe_generator/strobe_generator.v
vvp top.o
del top.o
