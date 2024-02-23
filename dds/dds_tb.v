// 240218

`timescale 1ns/1ns

`default_nettype none
module DDS_tb();
	
	// Configuration
	parameter CLOCK_HZ            = 10_000_000;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	wire Changed;
	reg [7:0] TuningWord = 10;
	
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
		.Changed_o(Changed)
	);
	
	real TimePrevious;
	real TimeNow;
	real Freq;
	
/*	
	always @(posedge Changed) begin: FreqMeasure
		TimePrevious	= TimeNow;
		TimeNow			= $realtime;
		FreqPrevious	= FreqNow;
		FreqNow 		= (TimeNow - TimePrevious);
		
		// $display("%t", TimePrevious);
		
		//if(FreqPrevious != FreqNow) begin
			$display("%t Frequency: %d", 
				$realtime,
				FreqNow
			);
		//end
	end*/


	always @(posedge DUT.ROM_inst.Address_i == 10'd1) begin
		TimePrevious	= TimeNow;
		TimeNow			= $realtime;
		Freq			= 1_000_000_000.0 / (TimeNow - TimePrevious);
		
		$display("%t %t %t %f", 
			TimeNow, 
			TimePrevious, 
			TimeNow - TimePrevious, 
			Freq
		);
	end
	
	wire Zego = (DUT.ROM_inst.Address_i == 10'd1);
	
	// Test sequence
	initial begin
		$timeformat(-6, 6, "us", 10);
		$display("===== START =====");
		
		@(posedge Clock);
		Reset = 1'b1;
		
		
		repeat(100000) @(posedge Clock);
		
		$display("====== END ======");
		$finish;
	end

endmodule
