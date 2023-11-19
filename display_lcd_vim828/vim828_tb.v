// 231109

`timescale 1ns/1ns
`default_nettype none

module VIM828_tb();
	
	parameter CLOCK_HZ	     = 1_000_000;
	parameter HALF_PERIOD_NS = 1_000_000_000 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	// Variables
	reg Reset  = 1'b0;
	
	// Instantiate device under test
	VIM828 #(
		.CLOCK_HZ(CLOCK_HZ),
		.CHANGE_COM_US(50)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		               //NMLK_JIHGF_EDCBA
		.Segments7_i(14'b0000_00000_00000), // Segment J visible
		.Segments6_i(14'b0010_00000_00000),
		.Segments5_i(14'b0000_00000_00000),
		.Segments4_i(14'b0000_00000_00000),
		.Segments3_i(14'b0000_00000_00000),
		.Segments2_i(14'b0000_00000_00000),
		.Segments1_i(14'b0000_00000_00000),
		.Segments0_i(14'b0000_00000_00000),
		.DecimalPoints_i(8'b00000000),
		.Pin_o()
	);
	
	// Variable dump
	initial begin
		$dumpfile("vim828.vcd");
		$dumpvars(0, VIM828_tb);
	end

	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 10);
		$display("===== START =====");
		$display("CLOCK_HZ = %9d", CLOCK_HZ);

		@(posedge Clock);
		Reset = 1'b1;
		
		$display("      time C0 C1 C2 C3");	
		$monitor("%t  %d  %d  %d  %d", 
			$realtime, 
			DUT.PinVoltage[`COM0],
			DUT.PinVoltage[`COM1],
			DUT.PinVoltage[`COM2],
			DUT.PinVoltage[`COM3]
		);

		// Wait through all eight states
		repeat(8) begin
			@(posedge DUT.ChangeState);
		end
		
		$display("====== END ======");
		$finish;
	end

endmodule
`default_nettype wire
