@echo off
iverilog -o uart_tx.o uart_tx.v uart_tx_tb.v
vvp uart_tx.o
del uart_tx.o
