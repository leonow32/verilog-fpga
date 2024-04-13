// 240411

`default_nettype none

module top #(
	parameter CLOCK_HZ = 25_000_000
)(
	input wire Clock,				// Pin 20
	input wire Reset,				// Pin 17
	input wire CS,					// Pin 5
	input wire SCK,					// Pin 18
	input wire MOSI,				// Pin 23
	output reg MISO,				// Pin 19
	output wire [7:0] Cathodes_o,	// Pin 40 41 42 43 45 47 51 25
	output wire [7:0] Segments_o	// Pin 39 38 37 36 35 34 30 29
);
	
	// Four last received bytes
	reg [7:0] Byte0;
	reg [7:0] Byte1;
	reg [7:0] Byte2;
	reg [7:0] Byte3;
	
	wire [7:0] DataReceived;
	wire ReceivedEvent;
	wire MISO_Data;
	wire MISO_Enable;
	
	SlaveSPI SlaveSPI_inst(
		.Clock(Clock),
		.Reset(Reset),
		.CS_i(CS),
		.SCK_i(SCK),
		.MOSI_i(MOSI),
		.MISO_o(MISO_Data),
		.MISO_Enable_o(MISO_Enable),
		.DataToSend_i(Byte0),
		.DataReceived_o(DataReceived),
		.Done_o(ReceivedEvent)
	);
	
	//assign MISO = MISO_Enable ? MISO_Data : 1'bZ;
	
	always @(*) begin
		if(!MISO_Enable)
			MISO = MISO_Data;
		else
			MISO = 1'bZ;
	end
	
	// Shift all received bytes when new byte is received
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Byte0 <= 0;
			Byte1 <= 0;
			Byte2 <= 0;
			Byte3 <= 0;
		end 
		
		else if(ReceivedEvent) begin
			Byte3 <= Byte2;
			Byte2 <= Byte1;
			Byte1 <= Byte0;
			Byte0 <= DataReceived;
		end
	end
	
	// Display instance
	DisplayMultiplex #(
		.CLOCK_HZ(CLOCK_HZ),
		.SWITCH_PERIOD_US(1000),
		.DIGITS(8)
	) DisplayMultiplex_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Data_i({Byte3, Byte2, Byte1, Byte0}),
		.DecimalPoints_i(8'b01010101),
		.Cathodes_o(Cathodes_o),
		.Segments_o(Segments_o),
		.SwitchCathode_o()
	);	
	
endmodule

`default_nettype wire
