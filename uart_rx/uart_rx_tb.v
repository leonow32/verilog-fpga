// 230814

`timescale 1ns/1ns  // time-unit, precision

`default_nettype none
module UART_RX_tb();

	parameter CLOCK_HZ	          = 1_000_000;
	parameter real HALF_PERIOD_NS = 1_000_000_000.0 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	// Variables
	reg  Reset         = 1'b0;
	
	reg  [7:0] TxData;
	wire       TxBusy;
	wire       TxDone;
	reg        TxRequest = 1'b0;
	
	wire [7:0] RxData;
	wire       RxDone;
	
	wire       TxRxCommon;
	
	// UART Transmitter
	UART_TX #(
		.CLOCK_HZ(CLOCK_HZ),
		.BAUD(100_000)
	) UartTx_Inst(
		.Clock(Clock),
		.Reset(Reset),
		.Start_i(TxRequest),
		.Data_i(TxData),
		.Busy_o(),
		.Done_o(TxDone),
		.Tx_o(TxRxCommon)
	);
	
	// UART Receiver
	UART_RX #(
		.CLOCK_HZ(CLOCK_HZ),
		.BAUD(100_000)
	) UartRx_Inst(
		.Clock(Clock),
		.Reset(Reset),
		.Rx_i(TxRxCommon),
		.Done_o(RxDone),
		.Data_o(RxData)
	);
	
	// Variable dump
	initial begin
		$dumpfile("uart_rx.vcd");
		$dumpvars(0, UART_RX_tb);
	end

	// Test sequence
	integer i;
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");
		//$display("Ticks per bit = %9d", DUT.StrobeGeneratorTicks_inst.TICKS);
		
		@(posedge Clock);
		Reset <= 1'b1;
		
		// Sending 1st byte
		repeat(99) @(posedge Clock);
		TxData <= 8'b01010101;
		TxRequest <= 1'b1;
		@(posedge Clock);
		TxData <= 8'bxxxxxxxx;
		TxRequest <= 1'b0;
		
		// Sending 2nd byte
		@(posedge TxDone);
		TxData <= 8'b10101010;
		TxRequest <= 1'b1;
		@(posedge Clock);
		TxData <= 8'bxxxxxxxx;
		TxRequest <= 1'b0;
		
		@(posedge TxDone);
		repeat(100) @(posedge Clock);
		
		$display("====== END ======");
		$finish;
	end
	
	// Display trasmitted bytes
	always begin
		@(posedge TxRequest)
		$display("%t Transmitting byte: %s", $realtime, UartTx_Inst.Data_i);
	end

endmodule
`default_nettype wire