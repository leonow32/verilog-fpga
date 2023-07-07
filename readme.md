
# Verilog FPGA
This is my repo with various peripherals coded in Verilog that I use in my FPGA projects. I use this as a code base and a library of many useful things that I can just copy-paste into something more advanced. 

I decided to publish these peripherals because I think they may be useful for other Verilog coders. Feel free to download all of them and use them without any limits. It would be nice if you mention me (Dominik Bieczyński) in your project description.

# Modules

Described in the alphabetical order.

## Melody Player

>**Status**: during development

This module is superior to the `SoundGenerator` module, which can only play a single sound at the desired frequency for the desired duration. The `MelodyPlayer` module is equipped with a ROM that contains music notes and their length of time. After starting the module with the `Play` signal, the module reads consecutive sounds from the memory and pushes them to the SoundGenerator. This way, a melody player with capabilities similar to the ringtone composer from the Nokia 3310 can be realized.

**Instantiation**

    MelodyPlayer #(
        .CLOCK_HZ(CLOCK_HZ)
    ) DUT(
        .Clock(Clock),
        .Reset(Reset),
        .Play_i(),
        .Stop_i(),
        .SoundWave_o()
    );

**Port description**

+ **CLOCK_HZ** - clock signal frequency [Hz]
+ **Clock** - clock signal, active rising edge.
+ **Reset** - asynchronous reset, active low.
+ **Play_i** - a high pulse triggers the start of melody playback.
+ **Stop_i** - a high pulse stops the operation.
+ **SoundWave_o** - connect to the speaker.

**Simulation**

![Simulation](melody_player/simulation1.png "Simulation")
![Simulation](melody_player/simulation2.png "Simulation")

**Console output**

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

## ROM - case implementation

>**Status**: ready

This is very a simple implementation of ROM memory using `case` instruction. It has no practical sense - but can be used for educational purposes.

**Instantiation**

    ROM ROM_inst(
        .Clock(Clock),
        .ReadEnable_i(),
        .Address_i(),
        .Data_o()
    );

**Port description**

* **Clock** - clock signal, active rising edge.
* **ReadEnable_i** - if 1 then on the next clock edge the requested data is ready.
* **Address_i** - address of the byte requested to be read on the next clock edge.
* **Data_o** - value of the requested byte.
    
**Simulation**

![Simulation](rom_case/simulation.png "Simulation")

## Sound Generator

>**Status**: during development

The `SoundGenerator` module generates sound of the desired frequency and duration. Together with the `Player` module, you can easily build a simple melody player with capabilities similar to Nokia 3310.

**Instantiation**

    SoundGenerator #(
        .CLOCK_HZ(CLOCK_HZ)
    ) SoundGenerator_inst(
        .Clock(Clock),
        .Reset(Reset),
        .Start_i(),
        .Finish_i(),
        .Duration_ms_i(),
        .HalfPeriod_us_i(),
        .SoundWave_o(),
        .Busy_o(),
        .Done_o()
    );

**Instantiation**

TODO

**Port description**

TODO

**Simulation**

TODO

## Strobe Generator

>**Status**: code ready, documentation to be updated

This is the most useful code in Verilog I've ever made. I use it almost in every project.

**Instantiation**

TODO

**Port description**

TODO

**Simulation**

TODO