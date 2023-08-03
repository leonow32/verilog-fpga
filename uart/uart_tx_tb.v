`timescale 1ns/1ns  // time-unit, precision

`default_nettype none
module UART_TX_tb();

	parameter CLOCK_HZ	     = 10_000_000;
	parameter HALF_PERIOD_NS = 1_000_000_000 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS Clock = !Clock;
	end
	
	// Variables
	wire Busy;
	wire Done;
	reg Reset = 1'b0;
	reg Start = 1'b0;
	reg [7:0] DataToSend;
	
	// Instantiate device under test
	UART_TX #(
		.CLOCK_HZ(CLOCK_HZ),
		.BAUD(115200)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Start_i(Start),
		.Data_i(DataToSend),
		.Busy_o(),
		.Done_o(Done),
		.Tx_o()
	);
	
	// Variable dump
	initial begin
		$dumpfile("uart_tx.vcd");
		$dumpvars(0, UART_TX_tb);
	end

	// Test sequence
	integer i;
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");
		
		@(posedge Clock);
		Reset <= 1'b1;
		
		repeat(10) @(posedge Clock);
		Start      <= 1'b1;
//		DataToSend <= 8'b10101010;
//		DataToSend <= 8'b01010101;
		DataToSend <= 8'b11110000;
		@(posedge Clock);
		Start      <= 1'b0;
		DataToSend <= 8'bX;
		
		
		// Pause
		@(posedge DUT.Done_o);
		Start      <= 1'b1;
//		DataToSend <= 8'b10101010;
//		DataToSend <= 8'b01010101;
//		DataToSend <= 8'b11110000;
		DataToSend <= 8'b00001111;
		@(posedge Clock);
		Start      <= 1'b0;
		DataToSend <= 8'bX;
		
		@(posedge DUT.Done_o);
		repeat(100) @(posedge Clock);
		
		#1 $display("====== END ======");
		#1 $finish;
	end

endmodule
`default_nettype wire