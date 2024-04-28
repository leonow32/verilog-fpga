// 230428

`default_nettype none
module top(
	input wire Clock,		// Must be 25 MHz or 25.175 MHz
	input wire Reset,
	
	input wire CS_i,
	input wire SCK_i,
	input wire MOSI_i,
	input wire DC_i,
	
	output wire Red_o,
	output wire Green_o,
	output wire Blue_o,
	output wire HSync_o,
	output wire VSync_o
);
	
	// SPI data receiver
	wire TransmissionStart;
	wire TransactionDone;
	wire [7:0] DataReceived;
	
	SlaveSPI SlaveSPI_inst(
		.Clock(Clock),
		.Reset(Reset),
		.CS_i(CS_i),
		.SCK_i(SCK_i),
		.MOSI_i(MOSI_i),
		.MISO_o(),
		.DataToSend_i(8'd0),
		.DataReceived_o(DataReceived),
		.TransactionDone_o(TransactionDone),
		.TransmissionStart_o(TransmissionStart),
		.TransmissionEnd_o()
	);
	
	// Data/Command input synchronizer
	wire DC;
	
	Synchronizer SynchronizerDC(
		.Clock(Clock),
		.Reset(Reset),
		.Async_i(DC_i),
		.Sync_o(DC)
	);
	
	
	

endmodule
