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
	localparam TICKS_PER_HALF_BIT = CLOCK_HZ / (BAUD * 2);
	
	StrobeGeneratorTicks #(
		.TICKS(TICKS_PER_HALF_BIT)
	) StrobeGeneratorTicks_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Enable_i(State == RECEIVING || !Rx_i),	//
		.Strobe_o(Strobe)
	);

	// Start of frame detection (start bit is always 0)
	wire RxFallingEdge;
	EdgeDetector EdgeDetector_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Signal_i(Rx_i),
		.RisingEdge_o(),
		.FallingEdge_o(RxFallingEdge)
	);
	
	// State machine
	reg [1:0] State;
	parameter IDLE = 0;
	parameter RECEIVING = 1;
	parameter RETURN = 2;
	
	reg [8:0] ReceivedData;
	reg [4:0] Counter;
	wire SampleEnable = Strobe && !Counter[0];
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			State <= IDLE;
			Counter <= 5'd0;
			Data_o <= 0;
			Done_o <= 0;
			ReceivedData <= 0;
		end else begin
			case(State)
				IDLE: begin
					if(RxFallingEdge) begin
						Counter <= 5'd0;
						State <= RECEIVING;
					end else begin
						Done_o <= 1'b0;
					end
				end
				
				RECEIVING: begin
					if(Strobe) begin
						Counter <= Counter + 1'b1;
					end
					
					if(SampleEnable) begin
						ReceivedData <= {ReceivedData[7:0], Rx_i};
						ReceivedData <= {Rx_i, ReceivedData[8:1]};
					end
					
					if(Counter == 5'd17) begin
						Data_o <= ReceivedData[8:1];
						Done_o <= 1'b1;
						State <= IDLE;
					end
				end
				
				/*RETURN: begin
					Done_o <= 1'b0;
					State <= IDLE;
				end*/
			endcase
		end
	end
	
endmodule
`default_nettype wire