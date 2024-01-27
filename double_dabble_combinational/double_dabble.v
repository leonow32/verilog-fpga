// 231124

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
	integer bit;
	integer digit;
	
	// Combinational logic
	always @(*) begin
		BCD_o = 0;
		
		// For each bit in the input
		for(bit=0; bit<INPUT_BITS; bit=bit+1) begin
			
			// For each digit in the output
			for(digit=0; digit<OUTPUT_BITS; digit=digit+4) begin
				
				// If a digit is >= 5
				if(BCD_o[digit+:4] >= 4'd5) begin
					
					// Then add 3 to this digit
					BCD_o[digit+:4] = BCD_o[digit+:4] + 4'd3;
				end
			end
			
			// Shift output register
			// and append another bit from the binary input
			BCD_o = {BCD_o[OUTPUT_BITS-2:0], Binary_i[(INPUT_BITS-1)-bit]};
		end
	end

endmodule

`default_nettype wire
