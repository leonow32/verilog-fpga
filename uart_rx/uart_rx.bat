@echo off
iverilog -o uart_rx.o uart_rx.v uart_rx_tb.v ../strobe_generator_ticks/strobe_generator_ticks.v
vvp uart_rx.o
del uart_rx.o
