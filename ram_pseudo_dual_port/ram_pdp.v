// 230907

`default_nettype none
module PseudoDualPortRAM #(
	parameter ADDRESS_WIDTH = 16,
	parameter DATA_WIDTH    = 8
)(
	input wire ClockRead,
	input wire ClockWrite,
	input wire Reset,
	input wire ReadEnable_i,
	input wire WriteEnable_i,
	input wire [ADDRESS_WIDTH-1:0] AddressRead_i,
	input wire [ADDRESS_WIDTH-1:0] AddressWrite_i,
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
	
	always @(posedge ClockRead, negedge Reset) begin
		if(!Reset)
			Data_o <= 0;
		else if(ReadEnable_i)
			Data_o <= Memory[AddressRead_i];
	end
	
	always @(posedge ClockWrite, negedge Reset) begin
		if(!Reset)
			Data_o <= 0;
		else if(WriteEnable_i)
			Memory[AddressWrite_i] <= Data_i;
	end

endmodule
`default_nettype wire