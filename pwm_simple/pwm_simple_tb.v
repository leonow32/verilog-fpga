// 230819

`timescale 1ns/1ns  // time-unit, precision

`default_nettype none
module SimplePWM_tb();

	parameter CLOCK_HZ	          = 1_000_000;
	parameter real HALF_PERIOD_NS = 1_000_000_000.0 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	// Variables
	reg  Reset = 1'b0;
	reg [3:0] CompareValue = 4'd5;
	wire OutputSignalA;
	
	// UART Transmitter
	SimplePWM #(
		.WIDTH(4)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Compare_i(CompareValue),
		.SignalA_o(OutputSignalA)
	);
	
	// Variable dump
	initial begin
		$dumpfile("pwm_simple.vcd");
		$dumpvars(0, SimplePWM_tb);
	end

	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");
		
		@(posedge Clock);
		Reset     <= 1'b1;
		
		
		repeat(50) @(posedge Clock);
		
		
		$display("====== END ======");
		$finish;
	end
	
endmodule
`default_nettype wire
