
# Verilog FPGA
This is my repo with various peripherals coded in Verilog that I use in my FPGA projects. I use this as a code base and a library of many useful things that I can just copy-paste into something more advanced. 

I decided to publish these peripherals because I think they may be useful for other Verilog coders. Feel free to download all of them and use them without any limits. It would be nice if you mention me (Dominik Bieczyński) in your project description.

## Modules

**Timing:**

+ [Strobe Generator](/strobe_generator) - This is a very simple yet very useful module. I use it almost in every project. The strobe signal is set to high state for one clock cycle and then it is set low. This kind of signal is very common to drice `ClockEnale` inputs. This module generates periodic page signals. The period of the strobes is defined by the `PERIOD_US` parameter. Based on the `CLOCK_HZ` parameter, the module itself calculates how many clock cycles to wait between strobe signals to occur at the desired intervals. The module also calculates by itself the number of bits of the Counter register, used to count clock ticks, in such a way that FPGA resources are not wasted on unnecessary register bits.

**Memories:**

+ [Rom - Case implementation](/rom_case) - This is very a simple implementation of ROM memory using `case` instruction. It has no practical sense - but can be used for educational purposes.

**Just for fun:**

+ [Sound Generator](/sound_generator) - generates sound of the desired frequency and duration.
+ [Melody Player](/melody_player) - This module is superior to the `SoundGenerator` module, which can only play a single sound at the desired frequency for the desired duration. The `MelodyPlayer` module is equipped with a ROM that contains music notes and their length of time. After starting the module with the `Play` signal, the module reads consecutive sounds from the memory and pushes them to the SoundGenerator. This way, a melody player with capabilities similar to the ringtone composer from the Nokia 3310 can be realized.




