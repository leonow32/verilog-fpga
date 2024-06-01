// 230428

`default_nettype none
module top #(
	parameter CLOCK_HZ = 10000000,
	parameter BAUD     = 115200
)(
	input wire Clock,		// Pin 20, must be 25 MHz or 25.175 MHz
	input wire Reset,		// Pin 17
	
	input wire UartRx_i,	// Pin XX
	
	output wire Red_o,		// Pin 78
	output wire Green_o,	// Pin 10
	output wire Blue_o,		// Pin 9
	output wire HSync_o,	// Pin 1
	output wire VSync_o		// Pin 8
);
	
	// Currently displayed Character
	input [6:0] Column;			// Range 0..79
	input [4:0] Row;			// Range 0..29
	input [3:0] Line;			// Range 0..15
	
	wire MemoryReadRequest;
	
	// UART data receiver
	wire DataReceivedEvent;
	wire [7:0] DataFromUART;
	
	UartRx #(
		.CLOCK_HZ(CLOCK_HZ),
		.BAUD(BAUD)
	) UartRx_Inst(
		.Clock(Clock),
		.Reset(Reset),
		.Rx_i(UartRx_i),
		.Done_o(DataReceivedEvent),
		.Data_o(DataFromUART)
	);
	
	// Memory controller
	Memory Memory_inst(
		.Clock(Clock),
		.Reset(Reset),
		.AnalyzeRequest_i(DataReceivedEvent),
		.DataFromUART_i(DataFromUART),
		.ReadRequest_i(MemoryReadRequest),
		.Column_i(Column),
		.Row_i(Row),
		.Line_i(Line),
		.DataReady_o(),
		.Pixels_o(),
		.ColorForeground_o(),
		.ColorBackground_o()
	);
	
	// Character memory
	/*
	wire [11:0] CharWriteAddress = CursorY * 80 + CursorX;		// Range 0..2399
	wire [11:0] CharReadAddress;
	
	// Multiplexer for memory outputs
	wire [7:0] CharDataFromRAM_0;
	wire [7:0] CharDataFromRAM_1;
	wire [7:0] CharDataFromRAM_2;
	wire [7:0] CharDataFromRAM = (CharReadAddress[11:10] == 2'd0) ? CharDataFromRAM_0 :
								 (CharReadAddress[11:10] == 2'd1) ? CharDataFromRAM_1 :
								 (CharReadAddress[11:10] == 2'd2) ? CharDataFromRAM_2 :
								 8'd0;
	
	// Memory blocks
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) CharRAM_0(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(CharReadAddress[11:10] == 2'd0),							// Czy to potrzebne
		.WriteEnable_i(CharWriteRequest && (CharWriteAddress[11:10] == 2'd0)),
		.ReadAddress_i(CharReadAddress[9:0]),
		.WriteAddress_i(CharWriteAddress[9:0]),
		.Data_i(DataFromUART),
		.Data_o(CharDataFromRAM_0)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) CharRAM_1(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(CharReadAddress[11:10] == 2'd1),							// Czy to potrzebne
		.WriteEnable_i(CharWriteRequest && (CharWriteAddress[11:10] == 2'd1)),
		.ReadAddress_i(CharReadAddress[9:0]),
		.WriteAddress_i(CharWriteAddress[9:0]),
		.Data_i(DataFromUART),
		.Data_o(CharDataFromRAM_1)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(352)
	) CharRAM_2(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(CharReadAddress[11:10] == 2'd2),							// Czy to potrzebne
		.WriteEnable_i(CharWriteRequest && (CharWriteAddress[11:10] == 2'd2)),
		.ReadAddress_i(CharReadAddress[9:0]),
		.WriteAddress_i(CharWriteAddress[9:0]),
		.Data_i(DataFromUART),
		.Data_o(CharDataFromRAM_2)
	);
	*/
	
	// Font Memory
	/*
	wire [10:0] FontAddress;
	
	wire [7:0] FontDataFromROM_0;
	wire [7:0] FontDataFromROM_1;
	wire [7:0] FontDataFromROM = (FontAddress[10] == 1'd0) ? FontDataFromROM_0 : FontDataFromROM_1;
	
	// Characters 32...95
	ROM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024),
		.MEMORY_FILE("font_32_95.mem")
	) FontROM_0(
		.Clock(Clock),
		.Reset(Reset),
		.ReadEnable_i(1'b1),
		.Address_i(FontAddress[9:0]),
		.Data_o(FontDataFromROM_0)
	);
	
	*/
	
	// VGA instance
	VGA VGA_inst(
		.Clock(Clock),
		.Reset(Reset),
		.MemoryReadRequest_o(MemoryReadRequest),
		.Column_o(Column),
		.Row_o(Row),
		.Line_o(Line),
		.PixelsToDisplay_i(8'd0),
		.ColorForeground_i(3'b111),
		.ColorBackground_i(3'b000),
		.Red_o(Red_o),
		.Green_o(Green_o),
		.Blue_o(Blue_o),
		.HSync_o(HSync_o),
		.VSync_o(VSync_o)
	);
	
endmodule
