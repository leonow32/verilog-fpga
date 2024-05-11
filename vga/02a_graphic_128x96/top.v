// 230428

`default_nettype none
module top(
	input wire Clock,		// Pin 20, must be 25 MHz or 25.175 MHz
	input wire Reset,		// Pin 17
	
	input wire CS_i,		// Pin 27
	input wire SCK_i,		// Pin 31
	input wire MOSI_i,		// Pin 49
	input wire DC_i,		// Pin 48
	
	output wire Red_o,		// Pin 78
	output wire Green_o,	// Pin 10
	output wire Blue_o,		// Pin 9
	output wire HSync_o,	// Pin 1
	output wire VSync_o		// Pin 8
);
	
	// SPI data receiver
	wire TransmissionStart;
	wire TransactionDone;
	wire [7:0] DataFromSPI;
	wire [7:0] DataFromRAM;
	
	SlaveSPI SlaveSPI_inst(
		.Clock(Clock),
		.Reset(Reset),
		.CS_i(CS_i),
		.SCK_i(SCK_i),
		.MOSI_i(MOSI_i),
		.MISO_o(),
		.DataToSend_i(8'd0),
		.DataReceived_o(DataFromSPI),
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
	reg  [10:0] WriteAddress;
	wire [10:0] ReadAddress;
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(11),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1536)
	) BitmapRAM(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(1'b1),
		.WriteEnable_i(TransactionDone),
		.ReadAddress_i(ReadAddress),
		.WriteAddress_i(WriteAddress),
		.Data_i(DataFromSPI),
		.Data_o(DataFromRAM)
	);
	
	// State machine to copy bitmap data
	// from SPI interface to Dual Port RAM
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			WriteAddress <= 0;
		else if(TransmissionStart)
			WriteAddress <= 0;
		else if(TransactionDone && DC)
			WriteAddress <= WriteAddress + 1'b1;
	end
	
	VGA VGA_inst(
		.Clock(Clock),
		.Reset(Reset),
		.RequestedAddress_o(ReadAddress),
		.DataFromRAM_i(DataFromRAM),
		.Red_o(Red_o),
		.Green_o(Green_o),
		.Blue_o(Blue_o),
		.HSync_o(HSync_o),
		.VSync_o(VSync_o)
	);
	
endmodule
