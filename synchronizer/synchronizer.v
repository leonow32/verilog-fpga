// 230425

`default_nettype none
module Synchronizer(
	input Clock,
	input Reset,
	input Async_i,
	output Sync_o
);

	reg [1:0] Buffer;

	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			Buffer <= 0;
		else
			Buffer[1:0] <= {Buffer[0], Async_i};
	end

	assign Sync_o = Buffer[1];

endmodule
`default_nettype wire
