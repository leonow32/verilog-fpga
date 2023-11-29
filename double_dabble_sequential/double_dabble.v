// 231128

`default_nettype none

module DoubleDabble #(
	parameter INPUT_BITS    = 16,
	parameter OUTPUT_DIGITS = 5,
	parameter OUTPUT_BITS   = OUTPUT_DIGITS * 4
)(
	input wire Clock,
	input wire Reset,
	input wire Start_i,
	output reg Busy_o,
	output reg Done_o,
	input wire [ INPUT_BITS-1:0] Binary_i,
	output reg [OUTPUT_BITS-1:0] BCD_o
);
	
	// Variables
	integer i;
	reg [ INPUT_BITS-1:0] Binary;
	reg [OUTPUT_BITS-1:0] BCD;
	
	wire [3:0] DEC = BCD[ 3:0];
	wire [3:0] TEN = BCD[ 7:4];
	wire [3:0] HUN = BCD[11:8];
	
	// State machine
	// 0 - Double
	// 1 - Dabble
	reg State;
	localparam DOUBLE = 1'b0;
	localparam DABBLE = 1'b1;
	
	localparam WIDTH = $clog2(INPUT_BITS - 1);
	reg [WIDTH-1:0] Counter;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Counter <= 0;
			Busy_o <= 0;
			Done_o <= 0;
			Binary <= 0;
			BCD <= 0;
			State   <= DOUBLE;
		end 
		
		else if(Start_i) begin
			Busy_o  <= 1'b1;
			Done_o  <= 1'b0;
			Binary  <= Binary_i;
			Counter <= INPUT_BITS - 1'b1;
			State   <= DOUBLE;
		end 
		
		else if(Busy_o) begin
			
			// Double
			if(State == DOUBLE) begin
				BCD <= {BCD[OUTPUT_BITS-2:0], Binary[INPUT_BITS-1]};
				Binary <= {Binary[INPUT_BITS-2:0], 1'bX};
				State <= DABBLE;
			end 
			
			// Dabble
			else begin
				
				// Check each digit
				// If the digit is >= 5 then add 3
				for(i=3; i<OUTPUT_BITS; i=i+4) begin
					if(BCD[i-:4] >= 4'd5)
						BCD[i-:4] <= BCD[i-:4] + 4'd3;
				end
				
				/*
				if(BCD[3:0] >= 4'd5)
					BCD[3:0] <= BCD[3:0] + 4'd3;
				
				if(BCD[7:4] >= 4'd5)
					BCD[7:4] <= BCD[7:4] + 4'd3;
				
				if(BCD[11:8] >= 4'd5)
					BCD[11:8] <= BCD[11:8] + 4'd3;
				*/
				
				State <= DOUBLE;
				
				if(Counter) begin
					Counter <= Counter - 1'b1;
				end
				
				else begin
					Busy_o <= 0;
					Done_o <= 1'b1;
					BCD_o <= BCD;
				end
			end
		end
		
		if(Done_o) begin
			Done_o <= 1'b0;
		end
	end
	

endmodule

`default_nettype wire
