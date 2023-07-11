`default_nettype none
module ROM(
//	input wire Clock,
//	input wire Reset,
	input wire [11:0] Address_i,
	output reg [ 7:0] Data_o
);

	always @(*) begin
		// if(!Reset)
			// Data_o = 0;
		// else begin
			case(Address_i)

				// 0 64c1
				12'h000:	Data_o = 8'h00;
				12'h001:	Data_o = 8'h20;
				12'h002:	Data_o = 8'h07;
				12'h003:	Data_o = 8'h77;

				// 1 64-
				12'h004:	Data_o = 8'h00;
				12'h005:	Data_o = 8'h20;
				12'h006:	Data_o = 8'h00;
				12'h007:	Data_o = 8'h00;

				// 2 64c2
				12'h008:	Data_o = 8'h00;
				12'h009:	Data_o = 8'h20;
				12'h00A:	Data_o = 8'h03;
				12'h00B:	Data_o = 8'hBB;

				// 3 64-
				12'h00C:	Data_o = 8'h00;
				12'h00D:	Data_o = 8'h20;
				12'h00E:	Data_o = 8'h00;
				12'h00F:	Data_o = 8'h00;

				// 4 32c3
				12'h010:	Data_o = 8'h00;
				12'h011:	Data_o = 8'h40;
				12'h012:	Data_o = 8'h01;
				12'h013:	Data_o = 8'hDD;

				default:	Data_o = 8'h00;
			endcase
		//end
	end

endmodule
`default_nettype wire

