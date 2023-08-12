`default_nettype none
module UART_TX #(
	parameter CLOCK_HZ = 10_000_000,
	parameter BAUD     = 115200
)(
	input wire Clock,
	input wire Reset,
	input wire Start_i,
	input wire [7:0] Data_i,
	output wire Busy_o,
	output wire Done_o,
	output wire Tx_o
);
	
	// Timing
	wire NextBit;
	
	StrobeGeneratorTicks #(
		.TICKS(CLOCK_HZ / BAUD)
	) StrobeGeneratorTicks_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Enable_i(Busy),
		.Strobe_o(NextBit)
	);

	// Shift register
	reg Busy;
	reg [3:0] Pointer;
	reg [7:0] ByteCopy;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			ByteCopy <= 0;
			Busy     <= 0;
			Pointer  <= 0;
		end else if(Start_i && !Busy) begin
			ByteCopy <= Data_i;
			Busy     <= 1'b1;
			Pointer  <= 0;
		end else if(NextBit) begin
			Pointer <= Pointer + 1'b1;
			if(Pointer == 4'd9) begin
				Busy <= 1'b0;
			end 
		end
	end
	
	// Edge detector of Busy signal
	EdgeDetector EdgeDetector_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Signal_i(Busy),
		.RisingEdge_o(),
		.FallingEdge_o(Done_o)
	);
	
	wire [9:0] DataToSend;
	assign DataToSend = {1'b1, ByteCopy, 1'b0};
	assign Tx_o = Busy ? DataToSend[Pointer] : 1'b1;
	assign Busy_o = Busy;
	
endmodule
`default_nettype wire