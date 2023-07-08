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

				// 4g2
				8'h00:		Data_o <= 8'h01;
				8'h01:		Data_o <= 8'hF4;
				8'h02:		Data_o <= 8'h02;
				8'h03:		Data_o <= 8'h7D;

				// 8.#a2
				8'h04:		Data_o <= 8'h01;
				8'h05:		Data_o <= 8'h77;
				8'h06:		Data_o <= 8'h02;
				8'h07:		Data_o <= 8'h18;

				// 16g2
				8'h08:		Data_o <= 8'h00;
				8'h09:		Data_o <= 8'h7D;
				8'h0A:		Data_o <= 8'h02;
				8'h0B:		Data_o <= 8'h7D;

				// 16-
				8'h0C:		Data_o <= 8'h00;
				8'h0D:		Data_o <= 8'h7D;
				8'h0E:		Data_o <= 8'h00;
				8'h0F:		Data_o <= 8'h00;

				// 16g2
				8'h10:		Data_o <= 8'h00;
				8'h11:		Data_o <= 8'h7D;
				8'h12:		Data_o <= 8'h02;
				8'h13:		Data_o <= 8'h7D;

				// 8c3
				8'h14:		Data_o <= 8'h00;
				8'h15:		Data_o <= 8'hFA;
				8'h16:		Data_o <= 8'h01;
				8'h17:		Data_o <= 8'hDD;

				// 8g2
				8'h18:		Data_o <= 8'h00;
				8'h19:		Data_o <= 8'hFA;
				8'h1A:		Data_o <= 8'h02;
				8'h1B:		Data_o <= 8'h7D;

				// 8f2
				8'h1C:		Data_o <= 8'h00;
				8'h1D:		Data_o <= 8'hFA;
				8'h1E:		Data_o <= 8'h02;
				8'h1F:		Data_o <= 8'hCB;

				// 4g2
				8'h20:		Data_o <= 8'h01;
				8'h21:		Data_o <= 8'hF4;
				8'h22:		Data_o <= 8'h02;
				8'h23:		Data_o <= 8'h7D;

				// 8.d3
				8'h24:		Data_o <= 8'h01;
				8'h25:		Data_o <= 8'h77;
				8'h26:		Data_o <= 8'h01;
				8'h27:		Data_o <= 8'hA9;

				// 16g2
				8'h28:		Data_o <= 8'h00;
				8'h29:		Data_o <= 8'h7D;
				8'h2A:		Data_o <= 8'h02;
				8'h2B:		Data_o <= 8'h7D;

				// 16-
				8'h2C:		Data_o <= 8'h00;
				8'h2D:		Data_o <= 8'h7D;
				8'h2E:		Data_o <= 8'h00;
				8'h2F:		Data_o <= 8'h00;

				// 16g2
				8'h30:		Data_o <= 8'h00;
				8'h31:		Data_o <= 8'h7D;
				8'h32:		Data_o <= 8'h02;
				8'h33:		Data_o <= 8'h7D;

				// 8#d3
				8'h34:		Data_o <= 8'h00;
				8'h35:		Data_o <= 8'hFA;
				8'h36:		Data_o <= 8'h01;
				8'h37:		Data_o <= 8'h91;

				// 8d3
				8'h38:		Data_o <= 8'h00;
				8'h39:		Data_o <= 8'hFA;
				8'h3A:		Data_o <= 8'h01;
				8'h3B:		Data_o <= 8'hA9;

				// 8#a2
				8'h3C:		Data_o <= 8'h00;
				8'h3D:		Data_o <= 8'hFA;
				8'h3E:		Data_o <= 8'h02;
				8'h3F:		Data_o <= 8'h18;

				// 8g2
				8'h40:		Data_o <= 8'h00;
				8'h41:		Data_o <= 8'hFA;
				8'h42:		Data_o <= 8'h02;
				8'h43:		Data_o <= 8'h7D;

				// 8d3
				8'h44:		Data_o <= 8'h00;
				8'h45:		Data_o <= 8'hFA;
				8'h46:		Data_o <= 8'h01;
				8'h47:		Data_o <= 8'hA9;

				// 8g3
				8'h48:		Data_o <= 8'h00;
				8'h49:		Data_o <= 8'hFA;
				8'h4A:		Data_o <= 8'h01;
				8'h4B:		Data_o <= 8'h3E;

				// 16g2
				8'h4C:		Data_o <= 8'h00;
				8'h4D:		Data_o <= 8'h7D;
				8'h4E:		Data_o <= 8'h02;
				8'h4F:		Data_o <= 8'h7D;

				// 16f2
				8'h50:		Data_o <= 8'h00;
				8'h51:		Data_o <= 8'h7D;
				8'h52:		Data_o <= 8'h02;
				8'h53:		Data_o <= 8'hCB;

				// 16-
				8'h54:		Data_o <= 8'h00;
				8'h55:		Data_o <= 8'h7D;
				8'h56:		Data_o <= 8'h00;
				8'h57:		Data_o <= 8'h00;

				// 16f2
				8'h58:		Data_o <= 8'h00;
				8'h59:		Data_o <= 8'h7D;
				8'h5A:		Data_o <= 8'h02;
				8'h5B:		Data_o <= 8'hCB;

				// 8d2
				8'h5C:		Data_o <= 8'h00;
				8'h5D:		Data_o <= 8'hFA;
				8'h5E:		Data_o <= 8'h03;
				8'h5F:		Data_o <= 8'h53;

				// 8a2
				8'h60:		Data_o <= 8'h00;
				8'h61:		Data_o <= 8'hFA;
				8'h62:		Data_o <= 8'h02;
				8'h63:		Data_o <= 8'h38;

				// 2g2
				8'h64:		Data_o <= 8'h03;
				8'h65:		Data_o <= 8'hE8;
				8'h66:		Data_o <= 8'h02;
				8'h67:		Data_o <= 8'h7D;

				default:	Data_o <= 8'h00;
			endcase
		end
	end

endmodule
`default_nettype wire

