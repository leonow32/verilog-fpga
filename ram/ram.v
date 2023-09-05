`default_nettype none
module RAM #(
	parameter ADDRESS_WIDTH = 16,
	parameter DATA_WIDTH    = 8//,
	//parameter MEMORY_FILE   = "data.mem"
)(
	input wire Clock,
	input wire Reset,
	input wire ReadEnable_i,
	input wire WriteEnable_i,
	input wire [ADDRESS_WIDTH-1:0] Address_i,
	input wire [   DATA_WIDTH-1:0] Data_i,
	output reg [   DATA_WIDTH-1:0] Data_o
);
	
	reg [DATA_WIDTH-1:0] Memory [0:2**ADDRESS_WIDTH-1];
	
	integer i;
	initial begin
		//$readmemh(MEMORY_FILE, Memory);
		for(i = 0; i < 2**ADDRESS_WIDTH; i = i+1) begin
			Memory[i] = 8'hFF;
		end
	end
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			Data_o <= 0;
		else begin
			if(ReadEnable_i)
				Data_o <= Memory[Address_i];
			if(WriteEnable_i)
				Memory[Address_i] <= Data_i;
		end
	end

endmodule
`default_nettype wire