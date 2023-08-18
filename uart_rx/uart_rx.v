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
	wire Strobe;
	localparam TICKS_PER_BIT = CLOCK_HZ / (BAUD * 2);
	
	StrobeGeneratorTicks #(
		.TICKS(TICKS_PER_BIT)
	) StrobeGeneratorTicks_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Enable_i(State == RECEIVING || !Rx_i),	//
		.Strobe_o(Strobe)
	);

	// Start of frame detection (start bit is always 0)
	wire RxRisingEdge;
	wire RxFallingEdge;
	EdgeDetector DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Signal_i(Rx_i),
		.RisingEdge_o(RxRisingEdge),
		.FallingEdge_o(RxFallingEdge)
	);
	
	// State machine
	reg [1:0] State;
	parameter IDLE = 0;
	parameter RECEIVING = 1;
	parameter RETURN = 2;
	
	reg [3:0] Counter;
	wire [2:0] BitNumber = Counter[3:1];
	wire Flag = Counter[0];
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			State <= IDLE;
		end else begin
			case(State)
				IDLE: begin
					if(RxFallingEdge) begin
						State <= RECEIVING;
						Counter <= 4'd0;
					end
				end
				
				RECEIVING: begin
					if(Strobe) begin
						Counter <= Counter + 1'b1;
					end
				end
				
				RETURN: begin
				
				end
			endcase
		end
	end
	
endmodule
`default_nettype wire