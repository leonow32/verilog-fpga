// 230804

`timescale 1ns/1ps	// time-unit, precision

module StrobeGenerator_tb();
	
	parameter CLOCK_HZ	= 1_000_000;
	parameter HALF_PERIOD_NS = 1_000_000_000 / (2 * CLOCK_HZ);
	
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
		.PERIOD_NS(2_900)
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
		$timeformat(-6, 3, "us", 10);
		$display("===== START =====");
		$display("CLOCK_HZ  = %9d", DUT.CLOCK_HZ);
		$display("PERIOD_NS = %9d", DUT.PERIOD_NS);
		$display("DELAY_REAL = %f ticks", DUT.DELAY_REAL);
		$display("DELAY     = %9d", DUT.DELAY);
		$display("WIDTH     = %9d", DUT.WIDTH);
		
		@(posedge Clock)
		Reset <= 1'b1;
		@(posedge Clock)
		Enable <= 1'b1;
		
		repeat(4) begin
			@(posedge Strobe);
			$display("Strobe detected at %t", $realtime);
		end
	

		$display("===== END =====");
		#1 $finish;
	end

endmodule
