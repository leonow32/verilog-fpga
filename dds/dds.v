// 240218

`default_nettype none

module DDS (
	input wire Clock,
	input wire Reset,
	input wire [7:0] TuningWord_i,
	output wire [7:0] Result_o
);
	
	// Phase accumulator
	reg [15:0] Accumulator;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			Accumulator <= 0;
		else
			Accumulator <= Accumulator + TuningWord_i;
	end
	
	// ROM with sine wave
	ROM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024),
		.MEMORY_FILE("sin.mem")
	) ROM_inst(
		.Clock(Clock),
		.Reset(Reset),
		.ReadEnable_i(1'b1),
		.Address_i(Accumulator[15:6]),
		.Data_o(Result_o)
	);

endmodule

`default_nettype wire
