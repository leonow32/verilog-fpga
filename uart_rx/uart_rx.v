// 230819

`default_nettype none
module UartRx #(
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
		.Enable_i(Busy || !Rx_i),
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
	reg Busy;
	reg [8:0] RxBuffer;
	reg [4:0] Counter;
	wire SampleEnable = Strobe && !Counter[0];
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Busy     <= 0;
			Counter  <= 0;
			Data_o   <= 0;
			Done_o   <= 0;
			RxBuffer <= 0;
		end else begin
			
			// Idle state
			if(!Busy) begin
				if(RxFallingEdge) begin
					Counter <= 5'd0;
					Busy    <= 1'b1;
				end else begin
					Done_o  <= 1'b0;
				end
			end
			
			// Transmission in progress
			else begin
				if(Strobe) begin
					Counter <= Counter + 1'b1;
				end
				
				if(SampleEnable) begin
					RxBuffer <= {Rx_i, RxBuffer[8:1]};
				end
				
				if(Counter == 5'd17) begin
					Data_o <= RxBuffer[8:1];
					Done_o <= 1'b1;
					Busy   <= 1'b0;
				end
			end
		end
	end
	
endmodule
`default_nettype wire