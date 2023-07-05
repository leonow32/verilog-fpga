
# Verilog FPGA
This is my repo for various peripherals coded in Verilog that I use in my FPGA projects. I use this as a code base and a library of many useful things that I can just copy-paste into something more advanced. 

I decided to publish these peripherals because I think they mat be useful for other Verilog coders. Feel free to download all ot them and use without any limits. It would be nice it you mention me (Dominik Bieczyński) in your project decription.

# Description

## ROM - case implementation

>**Status**: ready

This is very simple implementation of ROM memory using `case` instruction. It has no practical sense - can be used only for educational purposes.

### Instantiation:

	ROM ROM_inst(
		.Clock(Clock),
		.ReadEnable_i(),
		.Address_i(),
		.Data_o()
	);
	
### Port description

* **Clock** - clock signal, active high.
* **ReadEnable_i** - if 1 then on the next clock edge the requested data is ready.
* **Address_i** - address of the byte requested to be read on the next clock edge.
* **Data_o** - value of the requested byte.
	
### Simulation:

![Simulation](rom_case/simulation.png "Simulation")

## Sound Generator

>**Status**: during development

The `SoundGenerator` module generates sound of the desired frequency and duration. Together with the `Player` module, you can easily build a simple melody player with capabilities similar to Nokia 3310.

Example:

	SoundGenerator #(
		.CLOCK_HZ(CLOCK_HZ)
	) SoundGenerator_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Request_i(),
		.Duration_ms_i(),
		.HalfPeriod_us_i(),
		.SoundWave_o(),
		.Busy_o(),
		.Done_o()
	);

## Strobe Generator

>**Status**: code ready, documentaion to be updated

This is the most useful code in Verilog I've ever made. I use it almost in every project.
