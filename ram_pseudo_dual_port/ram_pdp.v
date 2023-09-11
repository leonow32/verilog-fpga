// 230907

`default_nettype none
module PseudoDualPortRAM #(
	parameter ADDRESS_WIDTH = 16,
	parameter DATA_WIDTH    = 8
)(
	input wire ReadClock,
	input wire WriteClock,
	input wire Reset,
	input wire ReadEnable_i,
	input wire WriteEnable_i,
	input wire [ADDRESS_WIDTH-1:0] ReadAddress_i,
	input wire [ADDRESS_WIDTH-1:0] WriteAddress_i,
	input wire [   DATA_WIDTH-1:0] Data_i,
	output reg [   DATA_WIDTH-1:0] Data_o
);
	
	reg [DATA_WIDTH-1:0] Memory [0:2**ADDRESS_WIDTH-1];
	
	integer i;
	initial begin
		for(i=0; i<2**ADDRESS_WIDTH; i=i+1) begin
			Memory[i] = 0;
		end
	end
	
	always @(posedge ReadClock, negedge Reset) begin
		if(!Reset)
			Data_o <= 0;
		else if(ReadEnable_i)
			Data_o <= Memory[ReadAddress_i];
	end
	
	always @(posedge WriteClock, negedge Reset) begin
		if(!Reset)
			Data_o <= 0;
		else if(WriteEnable_i)
			Memory[WriteAddress_i] <= Data_i;
	end

endmodule
`default_nettype wire