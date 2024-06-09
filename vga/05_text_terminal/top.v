// 230428

`default_nettype none
module top #(
	parameter CLOCK_HZ = 25000000,
	parameter BAUD     = 115200
)(
	input wire Clock,		// Pin 20, must be 25 MHz or 25.175 MHz
	input wire Reset,		// Pin 17
	
	input wire UartRx_i,	// Pin 75
	
	output wire [7:0] Cathodes_o,
	output wire [7:0] Segments_o,
	
	output wire Red_o,		// Pin 78
	output wire Green_o,	// Pin 10
	output wire Blue_o,		// Pin 9
	output wire HSync_o,	// Pin 1
	output wire VSync_o		// Pin 8
);
	
	// Currently displayed Character
	wire [6:0] Column;			// Range 0..79
	wire [4:0] Row;				// Range 0..29
	wire [3:0] Line;			// Range 0..15
	
	// Signals between memory and VGA modules
	wire GetImageRequest;
	wire [7:0] Pixels;
	wire [2:0] ColorForeground;
	wire [2:0] ColorBackground;
	
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
		
		.GetImageRequest_i(GetImageRequest),
		.Column_i(Column),
		.Row_i(Row),
		.Line_i(Line),
		
		.Pixels_o(Pixels),
		.ColorForeground_o(ColorForeground),
		.ColorBackground_o(ColorBackground)
	);
	
	// VGA instance
	VGA VGA_inst(
		.Clock(Clock),
		.Reset(Reset),
		
		.GetImageRequest_o(GetImageRequest),
		.Column_o(Column),
		.Row_o(Row),
		.Line_o(Line),
		
		// .PixelsToDisplay_i(DataFromUART),
		.PixelsToDisplay_i(Pixels),
		.ColorForeground_i(ColorForeground),
		.ColorBackground_i(ColorBackground),
		// .PixelsToDisplay_i(8'b11111100),
		// .ColorForeground_i(3'b110),
		// .ColorBackground_i(3'b001),
		
		.Red_o(Red_o),
		.Green_o(Green_o),
		.Blue_o(Blue_o),
		.HSync_o(HSync_o),
		.VSync_o(VSync_o)
	);
	
	// DisplayMultiplex #(
		// .CLOCK_HZ(CLOCK_HZ),
		// .SWITCH_PERIOD_US(1000),
		// .DIGITS(8)
	// ) DisplayMultiplex_inst(
		// .Clock(Clock),
		// .Reset(Reset),
		
// /*		.Data_i({
			// DataFromUART,
			// 12'd0,
			// DebugTextWriteAddress
		// }),*/
		
// /*		.Data_i({
			// 8'd0,
			// 3'd0, Row[4:0],
			// 1'd0, Column[6:0],
			// 4'd0, Line[3:0]
		// }),*/
		
// /*		.Data_i({
			// DebugTextDataToWrite,
			// DebugDataFromImageRAM
		// }),*/
		
		// .Data_i({
			// 20'd0,
			// DebugTextReadAddress
		// }),
		
		// .DecimalPoints_i(8'd0),
		// .Cathodes_o(Cathodes_o),
		// .Segments_o(Segments_o),
		// .SwitchCathode_o()
	// );
	
endmodule

`default_nettype wire
