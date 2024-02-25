// 240218

`timescale 1ns/1ps

`default_nettype none
module DDS_tb();
	
	// Configuration
	parameter CLOCK_HZ   = 25_000_000;
	reg [7:0] TuningWord = 1000;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	
	// Variable dump
	initial begin
		$dumpfile("dds.vcd");
		$dumpvars(0, DDS_tb);
	end
	
	// Instantiate device under test
	DDS DUT(
		.Clock(Clock),
		.Reset(Reset),
		.TuningWord_i(TuningWord),
		.Result_o(),
		.Overflow_o()
	);
	
	// Wire to catch the beginig of new cycle
	// TODO - this is not accurate. Cycles may be omitted at high frequencies
	//wire PeriodStart = (DUT.ROM_inst.Address_i == 10'd1);
	
	//ire Past = $past(TimePrevious, 1);
	
	// Measure signal frequency
	always @(posedge DUT.Overflow_o) begin: MeasureFreq
		real TimePrevious;
		real Freq;
		
		if(TimePrevious == 0) begin
			TimePrevious = $realtime;
		end else begin
			Freq = 1_000_000_000.0 / ($realtime - TimePrevious);
			$display("%t %10.3f Hz", $realtime, Freq);
			//$display("%d", $past(TuningWord));
			TimePrevious = $realtime;
		end
	end
	
	// Test sequence
	initial begin
		$timeformat(-3, 3, "ms", 10);
		$display("===== START =====");
		
		@(posedge Clock);
		Reset <= 1'b1;
		
		repeat(10) @(posedge DUT.Overflow_o);
		
		$display("====== END ======");
		$finish;
	end

endmodule
