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
	reg  [11:0] WriteAddress;
	wire [11:0] ReadAddress;
	
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
	
	// Multiplexer for memory outputs
	wire [7:0] DataFromRAM_0;
	wire [7:0] DataFromRAM_1;
	wire [7:0] DataFromRAM_2;
	wire [7:0] DataFromRAM = (ReadAddress[11:10] == 2'd0) ? DataFromRAM_0 :
	                         (ReadAddress[11:10] == 2'd1) ? DataFromRAM_1 :
							 (ReadAddress[11:10] == 2'd2) ? DataFromRAM_2 :
							 8'd0;
	
	// Memory blocks
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) BitmapRAM_0(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadAddress[11:10] == 2'b00),
		.WriteEnable_i(TransactionDone && (WriteAddress[11:10] == 2'b00)),
		.ReadAddress_i(ReadAddress[9:0]),
		.WriteAddress_i(WriteAddress[9:0]),
		.Data_i(DataFromSPI),
		.Data_o(DataFromRAM_0)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) BitmapRAM_1(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadAddress[11:10] == 2'b01),
		.WriteEnable_i(TransactionDone && (WriteAddress[11:10] == 2'b01)),
		.ReadAddress_i(ReadAddress[9:0]),
		.WriteAddress_i(WriteAddress[9:0]),
		.Data_i(DataFromSPI),
		.Data_o(DataFromRAM_1)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(352)
	) BitmapRAM_2(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadAddress[11:10] == 2'b10),
		.WriteEnable_i(TransactionDone && (WriteAddress[11:10] == 2'b10)),
		.ReadAddress_i(ReadAddress[9:0]),
		.WriteAddress_i(WriteAddress[9:0]),
		.Data_i(DataFromSPI),
		.Data_o(DataFromRAM_2)
	);
	
	// VGA instance
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
