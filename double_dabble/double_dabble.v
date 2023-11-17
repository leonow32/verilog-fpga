// 231117

// Max 255 - 3 cyfry
`default_nettype none
module DoubleDabble(
	input wire [15:0] Binary_i,	// Max 65535
	output reg [19:0] BCD_o
);
	
	integer i;   
     
	always @(*) begin
		BCD_o = 0;
		
		for (i=0; i<=15; i=i+1) begin // For each bit of input
		
			BCD_o = {BCD_o[18:0], Binary_i[15-i]};
				
			//if a hex digit of 'BCD_o' is more than 4, add 3 to it. 
			if(i != 15) begin
				if(BCD_o[3:0] > 4'd4) 
					BCD_o[3:0] = BCD_o[3:0] + 4'd3;
				
				if(BCD_o[7:4] > 4'd4)
					BCD_o[7:4] = BCD_o[7:4] + 4'd3;
				
				if(BCD_o[11:8] > 4'd4)
					BCD_o[11:8] = BCD_o[11:8] + 4'd3;
					
				if(BCD_o[15:12] > 4'd4)
					BCD_o[15:12] = BCD_o[15:12] + 4'd3; 
					
				if(BCD_o[19:16] > 4'd4)
					BCD_o[19:12] = BCD_o[19:12] + 4'd3; 
			end

			
			// if(i < 15 && BCD_o[3:0] > 4) 
				// BCD_o[3:0] = BCD_o[3:0] + 4'd3;
			
			// if(i < 15 && BCD_o[7:4] > 4)
				// BCD_o[7:4] = BCD_o[7:4] + 4'd3;
			
			// if(i < 15 && BCD_o[11:8] > 4)
				// BCD_o[11:8] = BCD_o[11:8] + 4'd3;
				
			// if(i < 15 && BCD_o[15:12] > 4)
				// BCD_o[15:12] = BCD_o[15:12] + 4'd3; 
				
			// if(i < 15 && BCD_o[19:16] > 4)
				// BCD_o[19:12] = BCD_o[19:12] + 4'd3; 
		end
	end

endmodule


// Max 255 - 3 cyfry
/*
module DoubleDabble(
	input wire [ 7:0] Binary_i,
	output reg [11:0] BCD_o
);
	
	integer i;   
     
	always @(*) begin
		BCD_o = 0; //initialize BCD_o to zero.
		for (i = 0; i <= 7; i = i+1) begin //run for 8 iterations
		
			BCD_o = {BCD_o[10:0], Binary_i[7-i]}; //concatenation
				
			//if a hex digit of 'BCD_o' is more than 4, add 3 to it.  
			if(i < 7 && BCD_o[3:0] > 4) 
				BCD_o[3:0] = BCD_o[3:0] + 4'd3;
			
			if(i < 7 && BCD_o[7:4] > 4)
				BCD_o[7:4] = BCD_o[7:4] + 4'd3;
			
			if(i < 7 && BCD_o[11:8] > 4)
				BCD_o[11:8] = BCD_o[11:8] + 4'd3;  
		end
	end

endmodule
*/

`default_nettype wire
