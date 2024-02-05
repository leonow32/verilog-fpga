// 231124

`timescale 1ns/1ns

`default_nettype none
module FrequencyMeter_tb();
	
	// Configuration
	parameter CLOCK_HZ       = 1_000_000;
	parameter TEST_SIGNAL_HZ = 300_000;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Test signal generator
	reg TestSignal = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * TEST_SIGNAL_HZ));
		TestSignal = !TestSignal;
	end
	
	// Variable dump
	initial begin
		$dumpfile("frequency_meter.vcd");
		$dumpvars(0, FrequencyMeter_tb);
	end
	
	// Instantiate device under test
	FrequencyMeter #(
		.CLOCK_HZ(CLOCK_HZ)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.SignalAsync_i(TestSignal),
		.Cathodes_o(),
		.Segments_o()
	);
	
	reg Reset = 0;
	
	// Test sequence
	initial begin
		$timeformat(-9, 3, "ns", 10);
		$display("===== START =====");
		// $display("INPUT_BITS:    %9d", INPUT_BITS);
		// $display("OUTPUT_BITS:   %9d", DUT.OUTPUT_BITS);
		// $display("OUTPUT_DIGITS: %9d", OUTPUT_DIGITS);
		// $display("MaxInput:      %9d", MaxInput);
		// $display("Counter WIDTH: %9d", DUT.WIDTH);
		
		@(posedge Clock);
		Reset = 1'b1;
		
		//@(posedge DUT.DoubleDabble_inst.Done_o)
		
		
		repeat(10000)
			@(posedge Clock);
		
		$display("====== END ======");
		$finish;
	end

endmodule
