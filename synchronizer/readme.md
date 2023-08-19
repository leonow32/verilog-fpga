# Synchronizer

![Status](https://img.shields.io/badge/STATUS-READY-green.svg)

A module for synchronizing asynchronous inputs with the clock domain of an FPGA. The implementation of this module at the GPIO input pins solves the problem of metastability. Changes in the state of the asynchronous input are visible on the synchronous output, but are delayed by a maximum of 2 clock cycles.

## Instantiation

```verilog
	Synchronizer DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Async_i(),
		.Sync_o()
	);
```

## Port description

+ **Clock** - Clock signal, active rising edge.
+ **Reset** - Asynchronous reset, active low.
+ **Async_i** - Asynchronous input.
+ **Sync_o** - Syncronous output.

## Simulation

![Simulation](simulation.png "Simulation")

## Console output

    VCD info: dumpfile synchronizer.vcd opened for output.
    ===== START =====
          Time Reset AsynchInput SyncOutput
       0.000us     x           0          x
       0.005us     0           0          0
       0.010us     1           0          0
       0.175us     1           1          0
       0.300us     1           1          1
       0.528us     1           0          1
       0.700us     1           0          0
       1.210us     1           1          0
       1.400us     1           1          1
       1.666us     1           0          1
       1.800us     1           0          0
    ====== END ======
    synchronizer_tb.v:48: $finish called at 2166 (1ns)
