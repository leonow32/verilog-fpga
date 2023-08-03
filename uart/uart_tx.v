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
	
	wire ChangeBit;
	StrobeGenerator #(
		.CLOCK_HZ(CLOCK_HZ),
		.PERIOD_US(9)
	) StrobeGeneratorMilli(
		.Clock(Clock),
		.Reset(Reset),
		//.Enable_i(Busy_o || Start_i),
		.Enable_i(Busy),
		.Strobe_o(ChangeBit)
	);
	
	reg Busy;
	reg [3:0] Pointer;
	reg [7:0] ByteCopy;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Busy     <= 0;
			Pointer  <= 0;
			ByteCopy <= 0;
		end else if(Start_i) begin
			Busy     <= 1'b1;
			Pointer  <= 0;
			ByteCopy <= Data_i;
		end else if(Busy && ChangeBit) begin
			if(Pointer == 4'd9) begin
				Busy <= 1'b0;
			end else begin
				Pointer <= Pointer + 1'b1;
			end
		end
	end
	
	reg BusyPrevious;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			BusyPrevious <= 1'b0;
		end else begin
			BusyPrevious <= Busy;
		end
	end
	
	wire [9:0] DataToSend;
	assign DataToSend = {1'b1, ByteCopy, 1'b0};
	assign Tx_o = Busy ? DataToSend[Pointer] : 1'b1;
	assign Busy_o = Busy;
	assign Done_o = BusyPrevious && !Busy;
	
endmodule
`default_nettype wire