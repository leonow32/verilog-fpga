`default_nettype none
module ROM(
	input wire Clock,
	input wire Reset,
	input wire ReadEnable_i,
	input wire [7:0] Address_i,
	output reg [7:0] Data_o
);

	always @(posedge Clock) begin
		if(!Reset)
			Data_o <= 0;
		else if(ReadEnable_i) begin
			case(Address_i)

				// 5ms, 5kHz
				8'h00:		Data_o <= 8'h00;
				8'h01:		Data_o <= 8'h05;
				8'h02:		Data_o <= 8'h00;
				8'h03:		Data_o <= 8'h64;

				default:	Data_o <= 8'h00;
			endcase
		end
	end

endmodule
`default_nettype wire

