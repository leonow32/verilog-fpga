@echo off
iverilog -o melody_player.o melody_player.v melody_player_tb.v rom.v ../sound_generator/sound_generator.v ../strobe_generator/strobe_generator.v
vvp melody_player.o
del melody_player.o
