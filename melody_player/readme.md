# Melody Player

![Status](https://img.shields.io/badge/STATUS-READY-green.svg)

This module is superior to the `SoundGenerator` module, which can only play a single sound at the desired frequency for the desired duration. The `MelodyPlayer` module is equipped with a ROM that contains music notes and their length of time. After starting the module with the `Play` signal, the module reads consecutive sounds from the memory and pushes them to the SoundGenerator. This way, a melody player with capabilities similar to the ringtone composer from the Nokia 3310 can be realized.

## Instantiation

```verilog
	MelodyPlayer #(
		.CLOCK_HZ(CLOCK_HZ)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Play_i(),
		.Stop_i(),
		.SoundWave_o()
	);
```

## Port description

+ **CLOCK_HZ** - Clock signal frequency [Hz].
+ **Clock** - Clock signal, active rising edge.
+ **Reset** - Asynchronous reset, active low.
+ **Play_i** - A high pulse triggers the start of melody playback.
+ **Stop_i** - A high pulse stops the operation.
+ **SoundWave_o** - Connect to the speaker.

## Simulation

![Simulation](simulation1.png "Simulation")
![Simulation](simulation2.png "Simulation")

## Console output

    VCD info: dumpfile melody_player.vcd opened for output.
    ===== START =====
            Time Durat HaPer        Freq
         1.700us     5   100        5000
      5002.300us     2     0           x
      7002.900us     8   500        1000
     15003.500us     5    50       10000
     20004.100us     0     0           x
    ====== END ======
    melody_player_tb.v:60: $finish called at 20005102 (1ns)