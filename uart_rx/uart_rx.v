// 230814

`default_nettype none
module UART_RX #(
	parameter CLOCK_HZ = 10_000_000,
	parameter BAUD     = 115200
)(
	input wire Clock,
	input wire Reset,
	input wire Rx_i,
	output reg Done_o,
	output reg [7:0] Data_o
);
	
	// Timing
	wire Next;
	localparam TICKS_PER_BIT = CLOCK_HZ / (BAUD * 2);
	
	StrobeGeneratorTicks #(
		.TICKS(TICKS_PER_BIT)
	) StrobeGeneratorTicks_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Enable_i(),	//
		.Strobe_o(Next)
	);

	// Start of frame detection (start bit is always 0)
	wire StartBitDetected;
	EdgeDetector DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Signal_i(Rx_i),
		.RisingEdge_o(),
		.FallingEdge_o(StartBitDetected)
	);
	
	// State machine
	
	parameter IDLE = 0;
	parameter WORK = 1;
	parameter RETURN = 2;
	
endmodule
`default_nettype wire