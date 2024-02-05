@echo off
iverilog -o frequency_meter.o                           ^
	frequency_meter.v                                   ^
	frequency_meter_tb.v                                ^
	../edge_detector/edge_detector.v                    ^
	../double_dabble_sequential/double_dabble.v         ^
	../synchronizer/synchronizer.v                      ^
	../display_multiplexed_variable/display_multiplex.v ^
	../decoder_7seg/decoder_7seg.v                      ^
	../strobe_generator/strobe_generator.v
vvp frequency_meter.o
del frequency_meter.o
