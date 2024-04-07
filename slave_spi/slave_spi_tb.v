// 240405

`timescale 1ns/1ns

`default_nettype none
module SlaveSPI_tb();
	
	// Configuration
	parameter CLOCK_HZ     = 1_000_000;
	parameter DELAY        = 7894;			// Delay between edges of SCK
	parameter MOSI_TO_SEND = 8'b01010101;	// Data from master to slave
	parameter MISO_TO_SEND = 8'b11111111;	// Data from slave to master
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset	= 0;
	reg CS		= 1;
	reg SCK		= 0;		// Clock is 0 when idle
	reg MOSI	= 1;		// MOSI is 1 when idle
	
	// Variable dump
	initial begin
		$dumpfile("slave_spi.vcd");
		$dumpvars(0, SlaveSPI_tb);
	end
	
	// Instantiate device under test
	SlaveSPI DUT(
		.Clock(Clock),
		.Reset(Reset),
		.CS_i(CS),					// Chip select, active low
		.SCK_i(SCK),				// Serial clock
		.MOSI_i(MOSI),				// Master Out, Slave In
		.MISO_o(),					// Master In, Slave Out
		
		.DataToSend_i(MISO_TO_SEND),	// Byte to be sent via MISO
		.DataReceived_o(),			// Byte received from MOSI
		.Done_o()	
	);
	
	// Test sequence
	initial begin
		$timeformat(-9, 3, "ns", 10);
		$display("===== START =====");
		$display("SCK freq is %f Hz", 1_000_000_000.0 / (2 * DELAY));
		
		@(posedge Clock);
		Reset <= 1'b1;
		
		#DELAY;		CS = 0; 	SCK = 0; 	MOSI = MOSI_TO_SEND[7];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = MOSI_TO_SEND[6];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = MOSI_TO_SEND[5];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = MOSI_TO_SEND[4];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = MOSI_TO_SEND[3];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = MOSI_TO_SEND[2];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = MOSI_TO_SEND[1];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = MOSI_TO_SEND[0];
		#DELAY;					SCK = 1;
		#DELAY; 	CS = 1;		SCK = 0; 	MOSI = 1;					// Czy trzeba ustawiać SCK i MOSI?
		#DELAY;
		
		$display("====== END ======");
		$finish;
	end

endmodule
