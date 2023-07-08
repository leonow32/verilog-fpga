// 230703

`default_nettype none
module ROM(
	input wire Clock,
	input wire Reset,
	input wire ReadEnable_i,
	input wire [11:0] Address_i,
	output reg [ 7:0] Data_o
);
	
	always @(posedge Clock) begin
		if(!Reset)
			Data_o <= 0;
		else if(ReadEnable_i) begin
			case(Address_i)
				
				// HalfPeriod = 10^6 / 2*Freq
				
				// 5ms, 5kHz
				12'h000:	Data_o <= 8'h00;
				12'h001:	Data_o <= 8'h05;
				12'h002:	Data_o <= 8'h00;
				12'h003:	Data_o <= 8'h64;
				
				// 2ms, silence
				12'h004:	Data_o <= 8'h00;
				12'h005:	Data_o <= 8'h02;
				12'h006:	Data_o <= 8'h00;
				12'h007:	Data_o <= 8'h00;
				
				// 8ms, 1kHz
				12'h008:	Data_o <= 8'h00;
				12'h009:	Data_o <= 8'h08;
				12'h00A:	Data_o <= 8'h01;
				12'h00B:	Data_o <= 8'hF4;
				
				// 5ms, 10kHz
				12'h00C:	Data_o <= 8'h00;
				12'h00D:	Data_o <= 8'h05;
				12'h00E:	Data_o <= 8'h00;
				12'h00F:	Data_o <= 8'h32;
				
				default:	Data_o <= 8'h00;
			endcase
		end
	end
	
endmodule
`default_nettype wire
