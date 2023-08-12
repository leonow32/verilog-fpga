@echo off
iverilog -o stream_tx.o stream_tx_tb.v stream_tx.v uart_tx.v ../edge_detector/edge_detector.v ../strobe_generator_ticks/strobe_generator_ticks.v
vvp stream_tx.o
del stream_tx.o
