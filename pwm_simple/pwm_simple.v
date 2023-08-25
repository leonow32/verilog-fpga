// 230819

`default_nettype none
module SimplePWM #(
	parameter WIDTH = 8
)(
	input wire Clock,
	input wire Reset,
	input wire [WIDTH-1:0] Compare_i,
	output wire Signal_o
);
	
	reg [WIDTH-1:0] Counter;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Counter <= 0;
		end else begin
			Counter <= Counter + 1'b1;
		end
	end
	
	assign Signal_o = Counter > Compare_i;
	
endmodule
`default_nettype wire