// 231128

`default_nettype none

module DoubleDabble #(
	parameter INPUT_BITS    = 16,
	parameter OUTPUT_DIGITS = 5,
	parameter OUTPUT_BITS   = OUTPUT_DIGITS * 4
)(
	input wire Start_i,
	output wire Busy_o,
	output wire Done_o,
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

`default_nettype wire
