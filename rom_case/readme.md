# ROM Memory - case implementation

>**Status**: ready

This is very a simple implementation of ROM memory using `case` instruction. It has no practical sense - but can be used for educational purposes.

## Instantiation

    ROM ROM_inst(
        .Clock(Clock),
        .ReadEnable_i(),
        .Address_i(),
        .Data_o()
    );

## Port description

+ **Clock** - Clock signal, active rising edge.
+ **ReadEnable_i** - If 1 then on the next clock edge the requested data is ready.
+ **Address_i** - Address of the byte requested to be read on the next clock edge.
+ **Data_o** - Value of the requested byte.
    
## Simulation

![Simulation](simulation.png "Simulation")

## Console output

    VCD info: dumpfile rom.vcd opened for output.
    ===== START =====
            Time Ad Data
         0.400us 0: 00
         0.700us 1: 10
         1.000us 2: 02
         1.300us 3: 30
         1.600us 4: 04
         1.900us 5: 55
         2.200us 6: 60
         2.500us 7: 07
         2.800us 8: 88
         3.100us 9: 90
         3.400us a: 0a
         3.700us b: b0
         4.000us c: cc
         4.300us d: 0d
         4.600us e: e0
         4.900us f: ff
    ===== END =====
    rom_tb.v:69: $finish called at 7502 (1ns)