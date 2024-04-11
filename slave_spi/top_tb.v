// 240411

`timescale 1ns/1ns

`default_nettype none
module top_tb();
	
	// Configuration
	parameter CLOCK_HZ = 25_000_000;
	parameter DELAY    = 7894;			// Delay between edges of SCK
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	reg CS    = 1;
	reg SCK   = 0;
	reg MOSI  = 0;
	wire MISO = 0;
	
	// Variable dump
	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, top_tb);
	end
	
	// Instantiate device under test	
	top DUT(
		.Clock(Clock),
		.Reset(Reset),
		.CS(CS),
		.SCK(SCK),
		.MOSI(MOSI),
		.MISO(MISO),
		.Cathodes_o(),
		.Segments_o()
	);
	
	task TransmitSPI(input [7:0] Data);
		begin
			#DELAY;		CS = 0; 	SCK = 0; 	MOSI = Data[7];
			#DELAY;					SCK = 1;
			#DELAY;					SCK = 0;	MOSI = Data[6];
			#DELAY;					SCK = 1;
			#DELAY;					SCK = 0;	MOSI = Data[5];
			#DELAY;					SCK = 1;
			#DELAY;					SCK = 0;	MOSI = Data[4];
			#DELAY;					SCK = 1;
			#DELAY;					SCK = 0;	MOSI = Data[3];
			#DELAY;					SCK = 1;
			#DELAY;					SCK = 0;	MOSI = Data[2];
			#DELAY;					SCK = 1;
			#DELAY;					SCK = 0;	MOSI = Data[1];
			#DELAY;					SCK = 1;
			#DELAY;					SCK = 0;	MOSI = Data[0];
			#DELAY;					SCK = 1;
			#DELAY; 	CS = 1;
		end
	endtask
	
	// Test sequence
	initial begin
		$timeformat(-9, 3, "ns", 10);
		$display("===== START =====");
		
		@(posedge Clock);
		Reset = 1'b1;
		
		@(posedge Clock);
		TransmitSPI(8'b01010101);
		TransmitSPI(8'b00110011);
		TransmitSPI(8'b00001111);
		TransmitSPI(8'b00000000);
		
		repeat(1000) @(posedge Clock);
		
		$display("====== END ======");
		$finish;
	end
	
endmodule
