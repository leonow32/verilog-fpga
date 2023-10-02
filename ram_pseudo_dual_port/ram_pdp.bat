@echo off
iverilog -o ram_pdp.o ram_pdp.v ram_pdp_tb.v
vvp ram_pdp.o
del ram_pdp.o
