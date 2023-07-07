// 230703

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
				
				// HalfPeriod = 10^6 / 2*Freq
				
				// 5ms, 5kHz
				8'h00:		Data_o <= 8'h00;
				8'h01:		Data_o <= 8'h05;
				8'h02:		Data_o <= 8'h00;
				8'h03:		Data_o <= 8'h64;
				
				// 2ms, silence
				8'h04:		Data_o <= 8'h00;
				8'h05:		Data_o <= 8'h02;
				8'h06:		Data_o <= 8'h00;
				8'h07:		Data_o <= 8'h00;
				
				// 8ms, 1kHz
				8'h08:		Data_o <= 8'h00;
				8'h09:		Data_o <= 8'h08;
				8'h0A:		Data_o <= 8'h01;
				8'h0B:		Data_o <= 8'hF4;
				
				// 5ms, 10kHz
				8'h0C:		Data_o <= 8'h00;
				8'h0D:		Data_o <= 8'h05;
				8'h0E:		Data_o <= 8'h00;
				8'h0F:		Data_o <= 8'h32;
				
				default:	Data_o <= 8'h00;
			endcase
		end
	end
	
endmodule
`default_nettype wire
