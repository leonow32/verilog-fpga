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

				// 4a1
				8'h00:		Data_o <= 8'h01;
				8'h01:		Data_o <= 8'hF4;
				8'h02:		Data_o <= 8'h04;
				8'h03:		Data_o <= 8'h70;

				// 4a1
				8'h04:		Data_o <= 8'h01;
				8'h05:		Data_o <= 8'hF4;
				8'h06:		Data_o <= 8'h04;
				8'h07:		Data_o <= 8'h70;

				// 4a1
				8'h08:		Data_o <= 8'h01;
				8'h09:		Data_o <= 8'hF4;
				8'h0A:		Data_o <= 8'h04;
				8'h0B:		Data_o <= 8'h70;

				// 4f1
				8'h0C:		Data_o <= 8'h01;
				8'h0D:		Data_o <= 8'hF4;
				8'h0E:		Data_o <= 8'h05;
				8'h0F:		Data_o <= 8'h97;

				// 16c2
				8'h10:		Data_o <= 8'h00;
				8'h11:		Data_o <= 8'h7D;
				8'h12:		Data_o <= 8'h03;
				8'h13:		Data_o <= 8'hBB;

				// 4a1
				8'h14:		Data_o <= 8'h01;
				8'h15:		Data_o <= 8'hF4;
				8'h16:		Data_o <= 8'h04;
				8'h17:		Data_o <= 8'h70;

				// 4f1
				8'h18:		Data_o <= 8'h01;
				8'h19:		Data_o <= 8'hF4;
				8'h1A:		Data_o <= 8'h05;
				8'h1B:		Data_o <= 8'h97;

				// 16c2
				8'h1C:		Data_o <= 8'h00;
				8'h1D:		Data_o <= 8'h7D;
				8'h1E:		Data_o <= 8'h03;
				8'h1F:		Data_o <= 8'hBB;

				// 2a1
				8'h20:		Data_o <= 8'h03;
				8'h21:		Data_o <= 8'hE8;
				8'h22:		Data_o <= 8'h04;
				8'h23:		Data_o <= 8'h70;

				// 4e2
				8'h24:		Data_o <= 8'h01;
				8'h25:		Data_o <= 8'hF4;
				8'h26:		Data_o <= 8'h02;
				8'h27:		Data_o <= 8'hF6;

				// 4e2
				8'h28:		Data_o <= 8'h01;
				8'h29:		Data_o <= 8'hF4;
				8'h2A:		Data_o <= 8'h02;
				8'h2B:		Data_o <= 8'hF6;

				// 4e2
				8'h2C:		Data_o <= 8'h01;
				8'h2D:		Data_o <= 8'hF4;
				8'h2E:		Data_o <= 8'h02;
				8'h2F:		Data_o <= 8'hF6;

				// 4f2
				8'h30:		Data_o <= 8'h01;
				8'h31:		Data_o <= 8'hF4;
				8'h32:		Data_o <= 8'h02;
				8'h33:		Data_o <= 8'hCB;

				// 16c2
				8'h34:		Data_o <= 8'h00;
				8'h35:		Data_o <= 8'h7D;
				8'h36:		Data_o <= 8'h03;
				8'h37:		Data_o <= 8'hBB;

				// 4#g1
				8'h38:		Data_o <= 8'h01;
				8'h39:		Data_o <= 8'hF4;
				8'h3A:		Data_o <= 8'h04;
				8'h3B:		Data_o <= 8'hB3;

				// 4f1
				8'h3C:		Data_o <= 8'h01;
				8'h3D:		Data_o <= 8'hF4;
				8'h3E:		Data_o <= 8'h05;
				8'h3F:		Data_o <= 8'h97;

				// 16c2
				8'h40:		Data_o <= 8'h00;
				8'h41:		Data_o <= 8'h7D;
				8'h42:		Data_o <= 8'h03;
				8'h43:		Data_o <= 8'hBB;

				// 2a1
				8'h44:		Data_o <= 8'h03;
				8'h45:		Data_o <= 8'hE8;
				8'h46:		Data_o <= 8'h04;
				8'h47:		Data_o <= 8'h70;

				// 4a2
				8'h48:		Data_o <= 8'h01;
				8'h49:		Data_o <= 8'hF4;
				8'h4A:		Data_o <= 8'h02;
				8'h4B:		Data_o <= 8'h38;

				// 4a1
				8'h4C:		Data_o <= 8'h01;
				8'h4D:		Data_o <= 8'hF4;
				8'h4E:		Data_o <= 8'h04;
				8'h4F:		Data_o <= 8'h70;

				// 16a1
				8'h50:		Data_o <= 8'h00;
				8'h51:		Data_o <= 8'h7D;
				8'h52:		Data_o <= 8'h04;
				8'h53:		Data_o <= 8'h70;

				// 4a2
				8'h54:		Data_o <= 8'h01;
				8'h55:		Data_o <= 8'hF4;
				8'h56:		Data_o <= 8'h02;
				8'h57:		Data_o <= 8'h38;

				// 4#g2
				8'h58:		Data_o <= 8'h01;
				8'h59:		Data_o <= 8'hF4;
				8'h5A:		Data_o <= 8'h02;
				8'h5B:		Data_o <= 8'h59;

				// 16g2
				8'h5C:		Data_o <= 8'h00;
				8'h5D:		Data_o <= 8'h7D;
				8'h5E:		Data_o <= 8'h02;
				8'h5F:		Data_o <= 8'h7D;

				// 16#f2
				8'h60:		Data_o <= 8'h00;
				8'h61:		Data_o <= 8'h7D;
				8'h62:		Data_o <= 8'h02;
				8'h63:		Data_o <= 8'hA3;

				// 16f2
				8'h64:		Data_o <= 8'h00;
				8'h65:		Data_o <= 8'h7D;
				8'h66:		Data_o <= 8'h02;
				8'h67:		Data_o <= 8'hCB;

				// 4#f2
				8'h68:		Data_o <= 8'h01;
				8'h69:		Data_o <= 8'hF4;
				8'h6A:		Data_o <= 8'h02;
				8'h6B:		Data_o <= 8'hA3;

				// 8#a1
				8'h6C:		Data_o <= 8'h00;
				8'h6D:		Data_o <= 8'hFA;
				8'h6E:		Data_o <= 8'h04;
				8'h6F:		Data_o <= 8'h30;

				// 4#d2
				8'h70:		Data_o <= 8'h01;
				8'h71:		Data_o <= 8'hF4;
				8'h72:		Data_o <= 8'h03;
				8'h73:		Data_o <= 8'h23;

				// 4d2
				8'h74:		Data_o <= 8'h01;
				8'h75:		Data_o <= 8'hF4;
				8'h76:		Data_o <= 8'h03;
				8'h77:		Data_o <= 8'h53;

				// 16#c2
				8'h78:		Data_o <= 8'h00;
				8'h79:		Data_o <= 8'h7D;
				8'h7A:		Data_o <= 8'h03;
				8'h7B:		Data_o <= 8'h85;

				// 16c2
				8'h7C:		Data_o <= 8'h00;
				8'h7D:		Data_o <= 8'h7D;
				8'h7E:		Data_o <= 8'h03;
				8'h7F:		Data_o <= 8'hBB;

				// 16b1
				8'h80:		Data_o <= 8'h00;
				8'h81:		Data_o <= 8'h7D;
				8'h82:		Data_o <= 8'h03;
				8'h83:		Data_o <= 8'hF4;

				// 4c2
				8'h84:		Data_o <= 8'h01;
				8'h85:		Data_o <= 8'hF4;
				8'h86:		Data_o <= 8'h03;
				8'h87:		Data_o <= 8'hBB;

				// 8f1
				8'h88:		Data_o <= 8'h00;
				8'h89:		Data_o <= 8'hFA;
				8'h8A:		Data_o <= 8'h05;
				8'h8B:		Data_o <= 8'h97;

				// 4#g1
				8'h8C:		Data_o <= 8'h01;
				8'h8D:		Data_o <= 8'hF4;
				8'h8E:		Data_o <= 8'h04;
				8'h8F:		Data_o <= 8'hB3;

				// 4f1
				8'h90:		Data_o <= 8'h01;
				8'h91:		Data_o <= 8'hF4;
				8'h92:		Data_o <= 8'h05;
				8'h93:		Data_o <= 8'h97;

				// 16#g1
				8'h94:		Data_o <= 8'h00;
				8'h95:		Data_o <= 8'h7D;
				8'h96:		Data_o <= 8'h04;
				8'h97:		Data_o <= 8'hB3;

				// 4c2
				8'h98:		Data_o <= 8'h01;
				8'h99:		Data_o <= 8'hF4;
				8'h9A:		Data_o <= 8'h03;
				8'h9B:		Data_o <= 8'hBB;

				// 4a1
				8'h9C:		Data_o <= 8'h01;
				8'h9D:		Data_o <= 8'hF4;
				8'h9E:		Data_o <= 8'h04;
				8'h9F:		Data_o <= 8'h70;

				// 16c2
				8'hA0:		Data_o <= 8'h00;
				8'hA1:		Data_o <= 8'h7D;
				8'hA2:		Data_o <= 8'h03;
				8'hA3:		Data_o <= 8'hBB;

				// 2e2
				8'hA4:		Data_o <= 8'h03;
				8'hA5:		Data_o <= 8'hE8;
				8'hA6:		Data_o <= 8'h02;
				8'hA7:		Data_o <= 8'hF6;

				// 4a2
				8'hA8:		Data_o <= 8'h01;
				8'hA9:		Data_o <= 8'hF4;
				8'hAA:		Data_o <= 8'h02;
				8'hAB:		Data_o <= 8'h38;

				// 4a1
				8'hAC:		Data_o <= 8'h01;
				8'hAD:		Data_o <= 8'hF4;
				8'hAE:		Data_o <= 8'h04;
				8'hAF:		Data_o <= 8'h70;

				// 16a1
				8'hB0:		Data_o <= 8'h00;
				8'hB1:		Data_o <= 8'h7D;
				8'hB2:		Data_o <= 8'h04;
				8'hB3:		Data_o <= 8'h70;

				// 4a2
				8'hB4:		Data_o <= 8'h01;
				8'hB5:		Data_o <= 8'hF4;
				8'hB6:		Data_o <= 8'h02;
				8'hB7:		Data_o <= 8'h38;

				// 4#g2
				8'hB8:		Data_o <= 8'h01;
				8'hB9:		Data_o <= 8'hF4;
				8'hBA:		Data_o <= 8'h02;
				8'hBB:		Data_o <= 8'h59;

				// 16g2
				8'hBC:		Data_o <= 8'h00;
				8'hBD:		Data_o <= 8'h7D;
				8'hBE:		Data_o <= 8'h02;
				8'hBF:		Data_o <= 8'h7D;

				// 16#f2
				8'hC0:		Data_o <= 8'h00;
				8'hC1:		Data_o <= 8'h7D;
				8'hC2:		Data_o <= 8'h02;
				8'hC3:		Data_o <= 8'hA3;

				// 16f2
				8'hC4:		Data_o <= 8'h00;
				8'hC5:		Data_o <= 8'h7D;
				8'hC6:		Data_o <= 8'h02;
				8'hC7:		Data_o <= 8'hCB;

				default:	Data_o <= 8'h00;
			endcase
		end
	end

endmodule
`default_nettype wire

