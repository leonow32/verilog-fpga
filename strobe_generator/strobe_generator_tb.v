// 230804

`timescale 1ns/1ps	// time-unit, precision

module StrobeGenerator_tb();
	
	parameter STROBE_PERIOD_NS = 1000;
	
	parameter real CLOCK_HZ	= 11_000_000;
	parameter real HALF_PERIOD_NS = 1_000_000_000 / (2 * CLOCK_HZ);
	
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
		.PERIOD_NS(STROBE_PERIOD_NS)
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
	
	// Timing calculations
	//real CLOCK_PERIOD_NS;
	

	// Test sequence
	initial begin
		//CLOCK_PERIOD_NS = 1_000_000_000.0 / CLOCK_HZ;
		//TICKS_INT = (CLOCK_HZ * STROBE_PERIOD_NS);
		//STROBE_PERIOD_REAL = CLOCK_PERIOD_NS * DUT.TICKS;
		$timeformat(-6, 3, "us", 10);
		$display("===== START =====");
		$display("CLOCK_HZ   = %9d", DUT.CLOCK_HZ);
		//$display("CLOCK_PERIOD_NS = %f",CLOCK_PERIOD_NS);
		$display("HALF_PERIOD_NS = %f",HALF_PERIOD_NS);
		
		$display("PERIOD_NS  = %9d", DUT.PERIOD_NS);
		$display("TICKS      = %9d", DUT.TICKS);
		//$display("TICKS_REAL = %f",  TICKS_REAL);
		$display("WIDTH      = %9d", DUT.WIDTH);
		
		@(posedge Clock)
		Reset <= 1'b1;
		@(posedge Clock)
		Enable <= 1'b1;
		
		repeat(4) begin
			@(posedge Strobe);
			$display("Strobe detected at %t", $realtime);
		end
	

		$display("===== END =====");
		$finish;
	end

endmodule
