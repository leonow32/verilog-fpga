// 230419

`timescale 1ns/1ns	// time-unit, precision
`default_nettype none
`include "vim828_defines.vh"

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
		             //PNMLK_JIHGF_EDCBA
		.Bitmap7_i(15'b00000_10000_00000),
		.Bitmap6_i(15'b00000_00000_00000),
		.Bitmap5_i(15'b00000_00000_00000),
		.Bitmap4_i(15'b00000_00000_00000),
		.Bitmap3_i(15'b00000_00000_00000),
		.Bitmap2_i(15'b00000_00000_00000),
		.Bitmap1_i(15'b00000_00000_00000),
		.Bitmap0_i(15'b00000_00000_00000),
		.Pin_o()
	);
	
	// Variable dump
	initial begin
		$dumpfile("vim828.vcd");
		$dumpvars(0, VIM828_tb);
		/*
		$dumpvars(2, DUT.ComAnalog[0]);
		$dumpvars(2, DUT.ComAnalog[1]);
		$dumpvars(2, DUT.ComAnalog[2]);
		$dumpvars(2, DUT.ComAnalog[3]);
		$dumpvars(2, DUT.SegAnalog[0]);
		$dumpvars(2, DUT.SegAnalog[1]);
		$dumpvars(2, DUT.SegAnalog[2]);
		$dumpvars(2, DUT.SegAnalog[3]);
		$dumpvars(2, DUT.SegAnalog[4]);
		$dumpvars(2, DUT.SegAnalog[5]);
		$dumpvars(2, DUT.SegAnalog[6]);
		$dumpvars(2, DUT.SegAnalog[7]);
		*/
	end

	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 10);
		$display("===== START =====");
		$display("CLOCK_HZ = %9d", CLOCK_HZ);

		#1 Reset = 1'b1;
		
		$display("      time C0 C1 C2 C3");	
		$monitor("%t  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d", 
				$realtime, 
				DUT.ComAnalog[0],
				DUT.ComAnalog[1],
				DUT.ComAnalog[2],
				DUT.ComAnalog[3],
				DUT.SegAnalog[0],
				DUT.SegAnalog[1],
				DUT.SegAnalog[2],
				DUT.SegAnalog[3],
				DUT.SegAnalog[4],
				DUT.SegAnalog[5],
				DUT.SegAnalog[6],
				DUT.SegAnalog[7],
			);
			*/

		// Wait through all eight states
		repeat(8) begin
			@(posedge DUT.ChangeState);
		end
		
		#1 $display("===== END =====");
		#1 $finish;
	end

endmodule
`default_nettype wire
