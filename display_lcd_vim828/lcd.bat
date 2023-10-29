@echo off
iverilog -o lcd.o lcd.v vim828_defines.vh lcd_tb.v lcd_pwm.v ../strobe_generator/strobe_generator.v
vvp lcd.o
del lcd.o
