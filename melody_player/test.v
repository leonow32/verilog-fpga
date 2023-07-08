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

				// 0 4a1
				12'h000:	Data_o <= 8'h01;
				12'h001:	Data_o <= 8'hF4;
				12'h002:	Data_o <= 8'h04;
				12'h003:	Data_o <= 8'h70;

				// 1 4a1
				12'h004:	Data_o <= 8'h01;
				12'h005:	Data_o <= 8'hF4;
				12'h006:	Data_o <= 8'h04;
				12'h007:	Data_o <= 8'h70;

				// 2 4a1
				12'h008:	Data_o <= 8'h01;
				12'h009:	Data_o <= 8'hF4;
				12'h00A:	Data_o <= 8'h04;
				12'h00B:	Data_o <= 8'h70;

				// 3 4f1
				12'h00C:	Data_o <= 8'h01;
				12'h00D:	Data_o <= 8'hF4;
				12'h00E:	Data_o <= 8'h05;
				12'h00F:	Data_o <= 8'h97;

				// 4 16c2
				12'h010:	Data_o <= 8'h00;
				12'h011:	Data_o <= 8'h7D;
				12'h012:	Data_o <= 8'h03;
				12'h013:	Data_o <= 8'hBB;

				// 5 4a1
				12'h014:	Data_o <= 8'h01;
				12'h015:	Data_o <= 8'hF4;
				12'h016:	Data_o <= 8'h04;
				12'h017:	Data_o <= 8'h70;

				// 6 4f1
				12'h018:	Data_o <= 8'h01;
				12'h019:	Data_o <= 8'hF4;
				12'h01A:	Data_o <= 8'h05;
				12'h01B:	Data_o <= 8'h97;

				// 7 16c2
				12'h01C:	Data_o <= 8'h00;
				12'h01D:	Data_o <= 8'h7D;
				12'h01E:	Data_o <= 8'h03;
				12'h01F:	Data_o <= 8'hBB;

				// 8 2a1
				12'h020:	Data_o <= 8'h03;
				12'h021:	Data_o <= 8'hE8;
				12'h022:	Data_o <= 8'h04;
				12'h023:	Data_o <= 8'h70;

				// 9 4e2
				12'h024:	Data_o <= 8'h01;
				12'h025:	Data_o <= 8'hF4;
				12'h026:	Data_o <= 8'h02;
				12'h027:	Data_o <= 8'hF6;

				// 10 4e2
				12'h028:	Data_o <= 8'h01;
				12'h029:	Data_o <= 8'hF4;
				12'h02A:	Data_o <= 8'h02;
				12'h02B:	Data_o <= 8'hF6;

				// 11 4e2
				12'h02C:	Data_o <= 8'h01;
				12'h02D:	Data_o <= 8'hF4;
				12'h02E:	Data_o <= 8'h02;
				12'h02F:	Data_o <= 8'hF6;

				// 12 4f2
				12'h030:	Data_o <= 8'h01;
				12'h031:	Data_o <= 8'hF4;
				12'h032:	Data_o <= 8'h02;
				12'h033:	Data_o <= 8'hCB;

				// 13 16c2
				12'h034:	Data_o <= 8'h00;
				12'h035:	Data_o <= 8'h7D;
				12'h036:	Data_o <= 8'h03;
				12'h037:	Data_o <= 8'hBB;

				// 14 4#g1
				12'h038:	Data_o <= 8'h01;
				12'h039:	Data_o <= 8'hF4;
				12'h03A:	Data_o <= 8'h04;
				12'h03B:	Data_o <= 8'hB3;

				// 15 4f1
				12'h03C:	Data_o <= 8'h01;
				12'h03D:	Data_o <= 8'hF4;
				12'h03E:	Data_o <= 8'h05;
				12'h03F:	Data_o <= 8'h97;

				// 16 16c2
				12'h040:	Data_o <= 8'h00;
				12'h041:	Data_o <= 8'h7D;
				12'h042:	Data_o <= 8'h03;
				12'h043:	Data_o <= 8'hBB;

				// 17 2a1
				12'h044:	Data_o <= 8'h03;
				12'h045:	Data_o <= 8'hE8;
				12'h046:	Data_o <= 8'h04;
				12'h047:	Data_o <= 8'h70;

				// 18 4a2
				12'h048:	Data_o <= 8'h01;
				12'h049:	Data_o <= 8'hF4;
				12'h04A:	Data_o <= 8'h02;
				12'h04B:	Data_o <= 8'h38;

				// 19 4a1
				12'h04C:	Data_o <= 8'h01;
				12'h04D:	Data_o <= 8'hF4;
				12'h04E:	Data_o <= 8'h04;
				12'h04F:	Data_o <= 8'h70;

				// 20 16a1
				12'h050:	Data_o <= 8'h00;
				12'h051:	Data_o <= 8'h7D;
				12'h052:	Data_o <= 8'h04;
				12'h053:	Data_o <= 8'h70;

				// 21 4a2
				12'h054:	Data_o <= 8'h01;
				12'h055:	Data_o <= 8'hF4;
				12'h056:	Data_o <= 8'h02;
				12'h057:	Data_o <= 8'h38;

				// 22 4#g2
				12'h058:	Data_o <= 8'h01;
				12'h059:	Data_o <= 8'hF4;
				12'h05A:	Data_o <= 8'h02;
				12'h05B:	Data_o <= 8'h59;

				// 23 16g2
				12'h05C:	Data_o <= 8'h00;
				12'h05D:	Data_o <= 8'h7D;
				12'h05E:	Data_o <= 8'h02;
				12'h05F:	Data_o <= 8'h7D;

				// 24 16#f2
				12'h060:	Data_o <= 8'h00;
				12'h061:	Data_o <= 8'h7D;
				12'h062:	Data_o <= 8'h02;
				12'h063:	Data_o <= 8'hA3;

				// 25 16f2
				12'h064:	Data_o <= 8'h00;
				12'h065:	Data_o <= 8'h7D;
				12'h066:	Data_o <= 8'h02;
				12'h067:	Data_o <= 8'hCB;

				// 26 4#f2
				12'h068:	Data_o <= 8'h01;
				12'h069:	Data_o <= 8'hF4;
				12'h06A:	Data_o <= 8'h02;
				12'h06B:	Data_o <= 8'hA3;

				// 27 8#a1
				12'h06C:	Data_o <= 8'h00;
				12'h06D:	Data_o <= 8'hFA;
				12'h06E:	Data_o <= 8'h04;
				12'h06F:	Data_o <= 8'h30;

				// 28 4#d2
				12'h070:	Data_o <= 8'h01;
				12'h071:	Data_o <= 8'hF4;
				12'h072:	Data_o <= 8'h03;
				12'h073:	Data_o <= 8'h23;

				// 29 4d2
				12'h074:	Data_o <= 8'h01;
				12'h075:	Data_o <= 8'hF4;
				12'h076:	Data_o <= 8'h03;
				12'h077:	Data_o <= 8'h53;

				// 30 16#c2
				12'h078:	Data_o <= 8'h00;
				12'h079:	Data_o <= 8'h7D;
				12'h07A:	Data_o <= 8'h03;
				12'h07B:	Data_o <= 8'h85;

				// 31 16c2
				12'h07C:	Data_o <= 8'h00;
				12'h07D:	Data_o <= 8'h7D;
				12'h07E:	Data_o <= 8'h03;
				12'h07F:	Data_o <= 8'hBB;

				// 32 16b1
				12'h080:	Data_o <= 8'h00;
				12'h081:	Data_o <= 8'h7D;
				12'h082:	Data_o <= 8'h03;
				12'h083:	Data_o <= 8'hF4;

				// 33 4c2
				12'h084:	Data_o <= 8'h01;
				12'h085:	Data_o <= 8'hF4;
				12'h086:	Data_o <= 8'h03;
				12'h087:	Data_o <= 8'hBB;

				// 34 8f1
				12'h088:	Data_o <= 8'h00;
				12'h089:	Data_o <= 8'hFA;
				12'h08A:	Data_o <= 8'h05;
				12'h08B:	Data_o <= 8'h97;

				// 35 4#g1
				12'h08C:	Data_o <= 8'h01;
				12'h08D:	Data_o <= 8'hF4;
				12'h08E:	Data_o <= 8'h04;
				12'h08F:	Data_o <= 8'hB3;

				// 36 4f1
				12'h090:	Data_o <= 8'h01;
				12'h091:	Data_o <= 8'hF4;
				12'h092:	Data_o <= 8'h05;
				12'h093:	Data_o <= 8'h97;

				// 37 16#g1
				12'h094:	Data_o <= 8'h00;
				12'h095:	Data_o <= 8'h7D;
				12'h096:	Data_o <= 8'h04;
				12'h097:	Data_o <= 8'hB3;

				// 38 4c2
				12'h098:	Data_o <= 8'h01;
				12'h099:	Data_o <= 8'hF4;
				12'h09A:	Data_o <= 8'h03;
				12'h09B:	Data_o <= 8'hBB;

				// 39 4a1
				12'h09C:	Data_o <= 8'h01;
				12'h09D:	Data_o <= 8'hF4;
				12'h09E:	Data_o <= 8'h04;
				12'h09F:	Data_o <= 8'h70;

				// 40 16c2
				12'h0A0:	Data_o <= 8'h00;
				12'h0A1:	Data_o <= 8'h7D;
				12'h0A2:	Data_o <= 8'h03;
				12'h0A3:	Data_o <= 8'hBB;

				// 41 2e2
				12'h0A4:	Data_o <= 8'h03;
				12'h0A5:	Data_o <= 8'hE8;
				12'h0A6:	Data_o <= 8'h02;
				12'h0A7:	Data_o <= 8'hF6;

				// 42 4a2
				12'h0A8:	Data_o <= 8'h01;
				12'h0A9:	Data_o <= 8'hF4;
				12'h0AA:	Data_o <= 8'h02;
				12'h0AB:	Data_o <= 8'h38;

				// 43 4a1
				12'h0AC:	Data_o <= 8'h01;
				12'h0AD:	Data_o <= 8'hF4;
				12'h0AE:	Data_o <= 8'h04;
				12'h0AF:	Data_o <= 8'h70;

				// 44 16a1
				12'h0B0:	Data_o <= 8'h00;
				12'h0B1:	Data_o <= 8'h7D;
				12'h0B2:	Data_o <= 8'h04;
				12'h0B3:	Data_o <= 8'h70;

				// 45 4a2
				12'h0B4:	Data_o <= 8'h01;
				12'h0B5:	Data_o <= 8'hF4;
				12'h0B6:	Data_o <= 8'h02;
				12'h0B7:	Data_o <= 8'h38;

				// 46 4#g2
				12'h0B8:	Data_o <= 8'h01;
				12'h0B9:	Data_o <= 8'hF4;
				12'h0BA:	Data_o <= 8'h02;
				12'h0BB:	Data_o <= 8'h59;

				// 47 16g2
				12'h0BC:	Data_o <= 8'h00;
				12'h0BD:	Data_o <= 8'h7D;
				12'h0BE:	Data_o <= 8'h02;
				12'h0BF:	Data_o <= 8'h7D;

				// 48 16#f2
				12'h0C0:	Data_o <= 8'h00;
				12'h0C1:	Data_o <= 8'h7D;
				12'h0C2:	Data_o <= 8'h02;
				12'h0C3:	Data_o <= 8'hA3;

				// 49 16f2
				12'h0C4:	Data_o <= 8'h00;
				12'h0C5:	Data_o <= 8'h7D;
				12'h0C6:	Data_o <= 8'h02;
				12'h0C7:	Data_o <= 8'hCB;

				default:	Data_o <= 8'h00;
			endcase
		end
	end

endmodule
`default_nettype wire

