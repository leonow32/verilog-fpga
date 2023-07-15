@echo off
iverilog -o edge_detector.o edge_detector.v edge_detector_tb.v
vvp edge_detector.o
del edge_detector.o
