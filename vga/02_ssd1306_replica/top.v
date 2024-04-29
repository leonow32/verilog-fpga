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
	
	// Bitmap memory
	reg [10:0] WriteAddress;
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(),
		.DATA_WIDTH(8)
	) BitmapRAM(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(1'b1),
		.WriteEnable_i(TransactionDone),
		.ReadAddress_i(),
		.WriteAddress_i(WriteAddress),
		.Data_i(DataReceived),
		.Data_o()
	);
	
	// State machine to copy bitmap data
	// from SPI interface to Dual Port RAM
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			WriteAddress <= 0;
		else if(TransmissionStart)
			WriteAddress <= 0;
		else if(TransactionDone)
			WriteAddress <= WriteAddress + 1'b1;
	end
	
	
	
	

endmodule
