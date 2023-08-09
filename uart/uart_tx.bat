@echo off
iverilog -o uart_tx.o uart_tx.v uart_tx_tb.v ../edge_detector/edge_detector.v ../strobe_generator_ticks/strobe_generator_ticks.v
vvp uart_tx.o
del uart_tx.o
