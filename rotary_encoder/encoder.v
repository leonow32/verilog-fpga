// 230616

`default_nettype none
module Encoder #(
	parameter	CLOCK_HZ	= 10_000_000
)(
	input  wire Clock,
	input  wire Reset,
	input  wire AsyncA_i,
	input  wire AsyncB_i,
	output reg  Increment_o,
	output reg  Decrement_o
);
	
	// Synchronizer
	reg [1:0] SyncA;
	reg [1:0] SyncB;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			SyncA <= 0;
			SyncB <= 0;
		end else begin
			SyncA <= {SyncA[0], AsyncA_i};
			SyncB <= {SyncB[0], AsyncB_i};
		end
	end
	
	// Synchronized input signals
	wire A = SyncA[1];
	wire B = SyncB[1];
	
	// State machine defines
	localparam IDLE           = 0;
	localparam WAIT_FOR_LOW_A = 1;
	localparam WAIT_FOR_LOW_B = 2;
	localparam WAIT_FOR_IDLE  = 3;
	reg [1:0] State;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Increment_o <= 0;
			Decrement_o <= 0;
			State <= IDLE;
		end else begin
			case(State)
				
				IDLE: begin
					if(A & !B) begin
						State <= WAIT_FOR_LOW_A;
					end else if(!A & B) begin
						State <= WAIT_FOR_LOW_B;
					end else if(!A & !B) begin
						State <= WAIT_FOR_IDLE;
					end
				end
				
				WAIT_FOR_LOW_A: begin
					if(!A & !B) begin
						Decrement_o <= 1'b1;
						State <= WAIT_FOR_IDLE;
					end else if(A & B) begin
						State <= IDLE;
					end
				end
				
				WAIT_FOR_LOW_B: begin
					if(!A & !B) begin
						Increment_o <= 1'b1;
						State <= WAIT_FOR_IDLE;
					end else if(A & B) begin
						State <= IDLE;
					end
				end
				
				WAIT_FOR_IDLE: begin
					Increment_o <= 1'b0;
					Decrement_o <= 1'b0;
					if(A & B) begin
						State <= IDLE;
					end
				end
				
			endcase
		end
	end
	
endmodule
`default_nettype wire
