// 231117


`default_nettype none

module DoubleDabble #(
	parameter INPUT_BITS    = 16,
	parameter OUTPUT_DIGITS = 5,
	parameter OUTPUT_BITS   = OUTPUT_DIGITS * 4
)(
	input wire [ INPUT_BITS-1:0] Binary_i,
	output reg [OUTPUT_BITS-1:0] BCD_o
);
	
	// For loop iterators
	integer i;
	integer j;
	
	// Combinational logic
	always @(*) begin
		BCD_o = 0;
		
		// For each bit in the input
		for(i=0; i<INPUT_BITS; i=i+1) begin
			
			// For each digit in the output
			for(j=3; j<OUTPUT_BITS; j=j+4) begin
				
				// If a digit is >= 5
				if(BCD_o[j-:4] >= 4'd5) begin
					
					// Then add 3 to this digit
					BCD_o[j-:4] = BCD_o[j-:4] + 4'd3;
				end
			end
			
			// Shift output register
			// and append another bit from the binary input
			BCD_o = {BCD_o[OUTPUT_BITS-2:0], Binary_i[(INPUT_BITS-1)-i]};
		end
	end

endmodule

// Max 65535 - 5 cyfr
//	36	108	215	25
//	36	94	187	28
/*
module DoubleDabble(
	input wire [15:0] Binary_i,	// Max 65535
	output reg [19:0] BCD_o
);
	
	integer i;
	
	always @(*) begin
		BCD_o = 0;
		
		// For each bit of input
		for(i=0; i<=15; i=i+1) begin
			
			//if a hex digit of 'BCD_o' is more than 4, add 3 to it. 
			if(BCD_o[3:0] >= 4'd5) 
				BCD_o[3:0] = BCD_o[3:0] + 4'd3;
			
			if(BCD_o[7:4] >= 4'd5)
				BCD_o[7:4] = BCD_o[7:4] + 4'd3;
			
			if(BCD_o[11:8] >= 4'd5)
				BCD_o[11:8] = BCD_o[11:8] + 4'd3;
				
			if(BCD_o[15:12] >= 4'd5)
				BCD_o[15:12] = BCD_o[15:12] + 4'd3; 
				
			if(BCD_o[19:16] >= 4'd5)
				BCD_o[19:12] = BCD_o[19:12] + 4'd3; 
			
			BCD_o = {BCD_o[18:0], Binary_i[15-i]};
		end
	end

endmodule
*/

// Max 255 - 3 cyfry
//	18	13	26	141
/*
module DoubleDabble(
	input wire [ 7:0] Binary_i,
	output reg [11:0] BCD_o
);
	
	integer i;
	
	always @(*) begin
		BCD_o = 0;
		
		// For each bit of input
		for(i=0; i<=7; i=i+1) begin
		
			BCD_o = {BCD_o[10:0], Binary_i[7-i]};
				
			if(i != 7) begin
				if(BCD_o[3:0] > 4'd4) 
					BCD_o[3:0] = BCD_o[3:0] + 4'd3;
				
				if(BCD_o[7:4] > 4'd4)
					BCD_o[7:4] = BCD_o[7:4] + 4'd3;
				
				if(BCD_o[11:8] > 4'd4)
					BCD_o[11:8] = BCD_o[11:8] + 4'd3;
			end
		end
	end

endmodule
*/

// Max 99 - 2 cyfry
//	16	19	37	80
/*
module DoubleDabble(
	input wire [7:0] Binary_i,
	output reg [7:0] BCD_o
);
	
	integer i;
	
	always @(*) begin
		BCD_o = 0;
		
		// For each bit of input
		for(i=0; i<=7; i=i+1) begin
		
			BCD_o = {BCD_o[6:0], Binary_i[7-i]};
				
			if(i != 7) begin
				if(BCD_o[3:0] >= 4'd5) 
					BCD_o[3:0] = BCD_o[3:0] + 4'd3;
				
				if(BCD_o[7:4] >= 4'd5)
					BCD_o[7:4] = BCD_o[7:4] + 4'd3;
			end
		end
	end

endmodule
*/

// Max 99 - 2 cyfry
//	16	16	32	99
/*
module DoubleDabble(
	input wire [7:0] Binary_i,
	output reg [7:0] BCD_o
);
	
	integer i;
	
	always @(*) begin
		BCD_o = 0;
		
		// For each bit of input
		for(i=0; i<=7; i=i+1) begin

			if(BCD_o[3:0] >= 4'd5) 
				BCD_o[3:0] = BCD_o[3:0] + 4'd3;
			
			if(BCD_o[7:4] >= 4'd5)
				BCD_o[7:4] = BCD_o[7:4] + 4'd3;
			
			BCD_o = {BCD_o[6:0], Binary_i[7-i]};
		end
	end

endmodule
*/


// Max 255 - 3 cyfry bez pętli
/*
module DoubleDabble(
	input wire [ 7:0] Binary_i,
	output reg [11:0] BCD_o
);
	
	integer i;
	
	always @(*) begin
		BCD_o = 0;
		
		// i = 0
		
		BCD_o = {BCD_o[10:0], Binary_i[7]};
				
		if(BCD_o[3:0] > 4'd3) 
			BCD_o[3:0] = BCD_o[3:0] + 4'd3;
		
		if(BCD_o[7:4] > 4'd3)
			BCD_o[7:4] = BCD_o[7:4] + 4'd3;
		
		if(BCD_o[11:8] > 4'd3)
			BCD_o[11:8] = BCD_o[11:8] + 4'd3;
			
		// i = 1
		
		BCD_o = {BCD_o[10:0], Binary_i[6]};
				
		if(BCD_o[3:0] > 4'd3) 
			BCD_o[3:0] = BCD_o[3:0] + 4'd3;
		
		if(BCD_o[7:4] > 4'd3)
			BCD_o[7:4] = BCD_o[7:4] + 4'd3;
		
		if(BCD_o[11:8] > 4'd3)
			BCD_o[11:8] = BCD_o[11:8] + 4'd3;
		
		// i = 2
		
		BCD_o = {BCD_o[10:0], Binary_i[5]};
				
		if(BCD_o[3:0] > 4'd3) 
			BCD_o[3:0] = BCD_o[3:0] + 4'd3;
		
		if(BCD_o[7:4] > 4'd3)
			BCD_o[7:4] = BCD_o[7:4] + 4'd3;
		
		if(BCD_o[11:8] > 4'd3)
			BCD_o[11:8] = BCD_o[11:8] + 4'd3;
		
		// i = 3
		
		BCD_o = {BCD_o[10:0], Binary_i[4]};
				
		if(BCD_o[3:0] > 4'd3) 
			BCD_o[3:0] = BCD_o[3:0] + 4'd3;
		
		if(BCD_o[7:4] > 4'd3)
			BCD_o[7:4] = BCD_o[7:4] + 4'd3;
		
		if(BCD_o[11:8] > 4'd3)
			BCD_o[11:8] = BCD_o[11:8] + 4'd3;
		
		// i = 4
		
		BCD_o = {BCD_o[10:0], Binary_i[3]};
				
		if(BCD_o[3:0] > 4'd3) 
			BCD_o[3:0] = BCD_o[3:0] + 4'd3;
		
		if(BCD_o[7:4] > 4'd3)
			BCD_o[7:4] = BCD_o[7:4] + 4'd3;
		
		if(BCD_o[11:8] > 4'd3)
			BCD_o[11:8] = BCD_o[11:8] + 4'd3;
		
		// i = 5
		
		BCD_o = {BCD_o[10:0], Binary_i[2]};
				
		if(BCD_o[3:0] > 4'd3) 
			BCD_o[3:0] = BCD_o[3:0] + 4'd3;
		
		if(BCD_o[7:4] > 4'd3)
			BCD_o[7:4] = BCD_o[7:4] + 4'd3;
		
		if(BCD_o[11:8] > 4'd3)
			BCD_o[11:8] = BCD_o[11:8] + 4'd3;
		
		// i = 6
		
		BCD_o = {BCD_o[10:0], Binary_i[1]};
				
		if(BCD_o[3:0] > 4'd3) 
			BCD_o[3:0] = BCD_o[3:0] + 4'd3;
		
		if(BCD_o[7:4] > 4'd3)
			BCD_o[7:4] = BCD_o[7:4] + 4'd3;
		
		if(BCD_o[11:8] > 4'd3)
			BCD_o[11:8] = BCD_o[11:8] + 4'd3;
		
		// i = 7
		
		BCD_o = {BCD_o[10:0], Binary_i[0]};

	end

endmodule
*/



`default_nettype wire
