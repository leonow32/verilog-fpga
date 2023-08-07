// 230428

`timescale 1ns/1ps	// time-unit, precision

module StrobeGenerator_tb();
	
	parameter CLOCK_HZ	= 10_000_000;
	parameter real HALF_PERIOD_NS = 1_000_000_000.0 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	reg	Reset = 1'b0;
	reg Enable = 1'b0;
	wire Strobe;
	
	// Instantiate device under test
	StrobeGenerator #(
		.CLOCK_HZ(CLOCK_HZ),
		.PERIOD_NS(1000)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Enable_i(Enable),
		.Strobe_o(Strobe)
	);
	
	// Variable dump
	initial begin
		$dumpfile("strobe_generator.vcd");
		$dumpvars(0, StrobeGenerator_tb);
	end

	// Test sequence
	initial begin
		
		
		
		$timeformat(-9, 3, "ns", 10);
		$display("===== START =====");
		$display("Clock");
		$display(" - Frequency:          %f MHz", DUT.CLOCK_HZ / 1_000_000.0);
		$display(" - Period:             %f ns", DUT.CLOCK_PERIOD_NS);
		$display("Strobe");
		$display(" - Period requested: %d ns", DUT.PERIOD_NS);
		$display(" - Period achieved:   %f ns", DUT.REAL_PERIOD_NS);
		$display(" - Clock ticks:               %d", DUT.TICKS);
		$display(" - Counter width:    %d", DUT.WIDTH);
		
		
		
		
		@(posedge Clock)
		Reset <= 1'b1;
		
		@(posedge Clock)
		Enable <= 1'b1;
		
		repeat(4) begin
			@(posedge Strobe);
			$display("Strobe detected at %t", $realtime);
		end
		
		
		//@(negedge Strobe);
		/*#1000;
		
		EnableAsync = 1'b0;
		#1000;
		EnableAsync = 1'b1;
		
		repeat(2) begin
			@(posedge Strobe);
			$display("Strobe detected at %t", $realtime);
		end
		
		#512;
		EnableAsync = 1'b0;
		#525;
		EnableAsync = 1'b1;
		
		repeat(2) begin
			@(posedge Strobe);
			$display("Strobe detected at %t", $realtime);
		end
		*/
		$display("===== END =====");
		$finish;
	end

endmodule