`default_nettype none
module Stream(
	input wire Clock,
	input wire Reset,
	input wire Button_i,
	output wire Tx_o
);
	
	reg [7:0] Memory [0:7];
	
	initial begin
		Memory[0] = 8'b00000000;
		Memory[1] = 8'b00000001;
		Memory[2] = 8'b00000011;
		Memory[3] = 8'b00001111;
		Memory[4] = 8'b11111111;
		Memory[5] = 8'b11110000;
		Memory[6] = 8'b11000000;
		Memory[7] = 8'b10000000;
	end
	
	wire Done;
	wire Busy;
	reg State;
	reg [2:0] Pointer;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			State <= 0;
			Pointer <= 0;
		end else if(Button_i && !Busy) begin
			State <= 1'b1;
		end
	end
	
	UART_TX #(
		.CLOCK_HZ(CLOCK_HZ),
		.BAUD(115200)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Start_i(Start),
		.Data_i(),
		.Busy_o(),
		.Done_o(Done),
		.Tx_o(Tx_o)
	);
	
endmodule
`default_nettype wire