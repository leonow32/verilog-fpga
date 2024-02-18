// 240218

`default_nettype none

module DDS (
	input wire Clock,
	input wire Reset,
	input wire [7:0] TuningWord_i,
	output wire [7:0] Result_o,
	output wire Changed_o
);
	
	// Phase accumulator
	reg [15:0] Accumulator;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Accumulator <= 0;
		end else begin
			Accumulator <= Accumulator + TuningWord_i;
		end
	end
	
	assign Result_o = Accumulator[15:8];
	
	// Change detection
	reg [7:0] Previous;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Previous <= 0;
		end else begin
			Previous <= Result_o;
		end
	end
	
	assign Changed_o = (Result_o != Previous);
	

endmodule

`default_nettype wire
