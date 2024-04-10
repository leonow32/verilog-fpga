// 240405

`timescale 1ns/1ns

`default_nettype none
module SlaveSPI_tb();
	
	// Configuration
	parameter CLOCK_HZ     = 1_000_000;
	parameter DELAY        = 7894;			// Delay between edges of SCK
	
	reg [7:0] BytesMOSI[0:3];				// Data from Master to Slave
	reg [7:0] BytesMISO[0:3];				// Data from Slave to Master

	initial begin
		
		// Data from Master to Slave
		BytesMOSI[0] = 8'b10101010;
		BytesMOSI[1] = 8'b11111111;
		BytesMOSI[2] = 8'b01010101;
		BytesMOSI[3] = 8'b00000000;
		
		// Data from Slave to Master
		BytesMISO[0] = 8'b10100101;
		BytesMISO[1] = 8'b00110011;
		BytesMISO[2] = 8'b01010101;
		BytesMISO[3] = 8'b11110000;
	end
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset	= 0;
	reg CS		= 1;
	reg SCK		= 0;
	reg MOSI	= 0;
	reg [7:0] ResponseData;
	
	// Variable dump
	initial begin
		$dumpfile("slave_spi.vcd");
		$dumpvars(0, SlaveSPI_tb);
	end
	
	// Instantiate device under test
	SlaveSPI DUT(
		.Clock(Clock),
		.Reset(Reset),
		.CS_i(CS),						// Chip select, active low
		.SCK_i(SCK),					// Serial clock
		.MOSI_i(MOSI),					// Master Out, Slave In
		.MISO_o(),						// Master In, Slave Out
		
		.DataToSend_i(ResponseData),	// Byte to be sent via MISO
		.DataReceived_o(),				// Byte received from MOSI
		.Done_o()	
	);
	
	always @(posedge DUT.Done_o) begin
		$display("%t Received: %H %b", $realtime, DUT.DataReceived_o, DUT.DataReceived_o);
	end
	
	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 10);
		$display("===== START =====");
		$display("SCK freq is %f Hz", 1_000_000_000.0 / (2 * DELAY));
		
		@(posedge Clock);
		Reset <= 1'b1;
		
		// Transmit one byte to the slave
		ResponseData = BytesMISO[0];
		#DELAY;		CS = 0; 	SCK = 0; 	MOSI = BytesMOSI[0][7];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[0][6];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[0][5];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[0][4];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[0][3];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[0][2];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[0][1];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[0][0];
		#DELAY;					SCK = 1;
		#DELAY; 	CS = 1;//		SCK = 0; 	MOSI = 1;					// Czy trzeba ustawiać SCK i MOSI?
		//#DELAY;
		
		// Transmit one byto to another slave
		ResponseData = BytesMISO[1];
		#DELAY;					SCK = 0; 	MOSI = BytesMOSI[1][7];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[1][6];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[1][5];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[1][4];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[1][3];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[1][2];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[1][1];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[1][0];
		#DELAY;					SCK = 1;
		#DELAY; 			//	SCK = 0; 	MOSI = 1;					// Czy trzeba ustawiać SCK i MOSI?
		//#DELAY;
		
		// Transmit one byte to the slave - but transmission broken
		ResponseData = BytesMISO[2];
		#DELAY;		CS = 0; 	SCK = 0; 	MOSI = BytesMOSI[2][7];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[2][6];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[2][5];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[2][4];
		#DELAY;					SCK = 1;
		#DELAY; 	CS = 1;//		SCK = 0; 	MOSI = 1;					// Czy trzeba ustawiać SCK i MOSI?
		//#DELAY;
		
		// Transmit one byte to the slave - recover after broken transmission
		ResponseData = BytesMISO[3];
		#DELAY;		CS = 0; 	SCK = 0; 	MOSI = BytesMOSI[3][7];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[3][6];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[3][5];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[3][4];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[3][3];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[3][2];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[3][1];
		#DELAY;					SCK = 1;
		#DELAY;					SCK = 0;	MOSI = BytesMOSI[3][0];
		#DELAY;					SCK = 1;
		#DELAY; 	CS = 1;//		SCK = 0; 	MOSI = 1;					// Czy trzeba ustawiać SCK i MOSI?
		//#DELAY;
		
		$display("====== END ======");
		$finish;
	end

endmodule
