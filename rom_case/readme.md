# ROM - case implementation

>**Status**: ready

This is very simple implementation of ROM memory using `case` instruction. It has no practical sense - can be used only for educational purposes.

## Instantiation:

	ROM ROM_inst(
		.Clock(Clock),
		.ReadEnable_i(),
		.Address_i(),
		.Data_o()
	);
	
## Port description

* **Clock** - clock signal, active high.
* **ReadEnable_i** - if 1 then on the next clock edge the requested data is ready.
* **Address_i** - address of the byte requested to be read on the next clock edge.
* **Data_o** - value of the requested byte.
	
## Simulation:

![Simulation](simulation.png "Simulation")