# Verilog FPGA
This is my repo with various peripherals coded in Verilog that I use in my FPGA projects. I use this as a code base and a library of many useful things that I can just copy-paste into something more advanced. 

I decided to publish these peripherals because I think they may be useful for other Verilog coders. Feel free to download all of them and use them without any limits. It would be nice if you mention me (Dominik Bieczyński) in your project description.

## Modules

**Displays**

+ [Decoder 7seg](/decoder_7seg) - Simple module to convert 4-bit binary data into 7-segment code that can drive a 7-segment display. Supports displaying digits from 0 to 9 and hexadecimal values from A to F. Made as a fully combinational logic without any clock and reset signals. Can be used with common cathode and common anode displays.
+ [Decoder 14seg](/decoder_14seg) - Simple module to convert 8-bit ASCII data into 14-segment code that can drive a 14-segment display. Supports displaying digits from 0 to 9, letters from A to Z and some other characters. Designed to be used with `display_lcd_vim828`.
+ [LED Display Multiplexed Const](/display_multiplexed_const) - Module that controls an 8-digit LED display with a common cathode. Supports blanking out unnecessary zeros and adjustable multiplexing period.
+ [LED Display Multiplexed Variable](/display_multiplexed_variable) - Module that controls an n-digit LED display with a common cathode. The number of digits in the display is controlled with a parameter. Supports blanking out unnecessary zeros and adjustable multiplexing period.
+ [LCD Display S401M16KR](/display_lcd_s401m16kr) - Multiplexing an LCD display is much more difficult than for an LED display. This controller works with the S401M16KR display from Lumex. This display works with 1/4 duty, that is, it has four electrodes in common COM and 1/3 bias, that is, the control voltage of the electrodes can have 4 different values.
+ [LCD Display VIM828](/display_lcd_vim828) - A 14-segment display that supports 8 alphanumeric characters.
+ [VGA](/vga) - During development. VGA driver that will display some text on a monitor.

**Timing:**

+ [Strobe Generator](/strobe_generator) - This is a very simple yet very useful module. I use it almost in every project. The strobe signal is set to high state for one clock cycle and then it is set low. This kind of signal is very common to drice `ClockEnale` inputs. This module generates periodic page signals. The period of the strobes is defined by the `PERIOD_US` parameter. Based on the `CLOCK_HZ` parameter, the module itself calculates how many clock cycles to wait between strobe signals to occur at the desired intervals. The module also calculates by itself the number of bits of the Counter register, used to count clock ticks, in such a way that FPGA resources are not wasted on unnecessary register bits.

**Input/Ouptut:**

+ [Synchronizer](/synchronizer) - A module for synchronizing asynchronous inputs with the clock domain of an FPGA. The implementation of this module at the GPIO input pins solves the problem of metastability. Changes in the state of the asynchronous input are visible on the synchronous output, but are delayed by a maximum of 2 clock cycles.
+ [Edge Detector](/edge_detector) - A simple module that is used to detect the rising and falling edge of any signal. If a change in the signal is detected, a pulse of one clock cycle length will be generated on the `RisingEdge_o` and `FallingEdge_o` outputs. Important - the signal under test must be synchronized with the clock.
+ [Debouncer](/debouncer) - A module used to filter the vibration of mechanical button contacts. After changing the state of the input `NoisySignal_i`, the module waits the time specified by the parameter . If the input state is stable during this time, then the output state `FilteredSignal_o` changes.
+ [Rotary Encoder](/rotary_encoder) - Module supporting a rotary encoder. Allows recognition of increment and decrement signals of ecoders, which have four pulses per click.

**Memories:**

+ [ROM](/rom) - Read only memory. This module can be used to store permanent information, such as the code of a program executed by the processor, for example.
+ [ROM - Case implementation](/rom_case) - This is very a simple implementation of ROM memory using `case` instruction. It has no practical sense - but can be used for educational purposes.
+ [RAM](/ram) - Single port RAM.
+ [Pseudo Dual Port RAM](/ram_pseudo_dual_port) - RAM memory with a separate address port for reading data and a separate one for writing. Moreover, the write and read ports can be connected to completely different clock signals.

**Computing**

+ [Binary to BCD converter - combinational Double Dabble](/double_dabble_combinational) - Converter of binary values to BCD code. It uses the Double Dabble algorithm in a combinational implementation.
+ [Binary to BCD converter - sequential Double Dabble](/double_dabble_sequential) - Converter of binary values to BCD code. It uses the Double Dabble algorithm in a sequential implementation.

**Communication**

+ [UART Transmitter](/uart_tx)
+ [UART Receiver](/uart_rx)
+ [SPI Slave](/slave_spi)

**Just for fun:**

+ [Sound Generator](/sound_generator) - generates sound of the desired frequency and duration.
+ [Melody Player](/melody_player) - This module is superior to the `SoundGenerator` module, which can only play a single sound at the desired frequency for the desired duration. The `MelodyPlayer` module is equipped with a ROM that contains music notes and their length of time. After starting the module with the `Play` signal, the module reads consecutive sounds from the memory and pushes them to the SoundGenerator. This way, a melody player with capabilities similar to the ringtone composer from the Nokia 3310 can be realized.
+ [Terminal VIM828](/terminal_vim828) - A module that combines the functionality of a UART receiver, a 14-segment decoder and a VIM828 display controller. When a character is received by the UART, it is converted into a 14-segment code and shown on the display. The display shows the eight most recently received characters.
+ [Frequency Meter](/frequency_meter) - Simple module to measure frequency of a signal and display the result on 7-segment display.
+ [Direct Digital Synthesis](/dds) - Sine wave generator with adjustable frequency and amplitude.





