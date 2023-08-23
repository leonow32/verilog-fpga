// 230425

`default_nettype none
module Synchronizer #(
	parameter WIDTH = 1
)(
	input  wire Clock,
	input  wire Reset,
	input  wire [WIDTH-1:0] Async_i,
	output wire [WIDTH-1:0] Sync_o
);

	reg [WIDTH-1:0] R1;
	reg [WIDTH-1:0] R2;
	//reg [1:0] Buffer;

	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			// Buffer <= 0;
			R1 <= 0;
			R2 <= 0;
		end else begin
			// Buffer[1:0] <= {Buffer[0], Async_i};
			R1 <= Async_i;
			R2 <= R1;
		end
	end

	//assign Sync_o = Buffer[1];
	assign Sync_o = R2;

endmodule
`default_nettype wire
