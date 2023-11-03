// 230711

`default_nettype none
module Decoder14seg(
	input wire Clock,
	input wire Reset,
	input wire Enable_i,
	input wire	[7:0]  Data_i,
	output reg	[13:0] Segments_o
);
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Segments_o <= 14'b00000000000000;
		end else if(Enable_i) begin
			case(Data_i)
				8'd0:  Segments_o <= 14'b00000000000000;
				8'd1:  Segments_o <= 14'b01010101010101;
				8'd2:  Segments_o <= 14'b00000000000001;
				8'd3:  Segments_o <= 14'b00000000000010;
				8'd4:  Segments_o <= 14'b00000000000100;
				8'd5:  Segments_o <= 14'b00000000001000;
				8'd6:  Segments_o <= 14'b00000000010000;
				8'd7:  Segments_o <= 14'b00000000100000;
				8'd8:  Segments_o <= 14'b00000001000000;
				8'd9:  Segments_o <= 14'b00000010000000;
				8'd10:  Segments_o <= 14'b00000100000000;
				8'd11:  Segments_o <= 14'b00001000000000;
				8'd12:  Segments_o <= 14'b00010000000000;
				8'd13:  Segments_o <= 14'b00100000000000;
				8'd14:  Segments_o <= 14'b01000000000000;
				8'd15:  Segments_o <= 14'b10000000000000;
				8'd16:  Segments_o <= 14'b00000000000001;
				8'd17:  Segments_o <= 14'b00000000000010;
				8'd18:  Segments_o <= 14'b00000000000100;
				8'd19:  Segments_o <= 14'b00000000001000;
				8'd20:  Segments_o <= 14'b00000000010000;
				8'd21:  Segments_o <= 14'b00000000100000;
				8'd22:  Segments_o <= 14'b00000001000000;
				8'd23:  Segments_o <= 14'b00000010000000;
				8'd24:  Segments_o <= 14'b00000100000000;
				8'd25:  Segments_o <= 14'b00001000000000;
				8'd26:  Segments_o <= 14'b00010000000000;
				8'd27:  Segments_o <= 14'b00100000000000;
				8'd28:  Segments_o <= 14'b01000000000000;
				8'd29:  Segments_o <= 14'b10000000000000;
				8'd30:  Segments_o <= 14'b00000000000001;
				8'd31:  Segments_o <= 14'b00000000000010;
				8'd32:  Segments_o <= 14'b00000000000100;
				8'd33:  Segments_o <= 14'b01000100001000;
				8'd34:  Segments_o <= 14'b00000000100010;
				8'd35:  Segments_o <= 14'b11111111111111;
				8'd36:  Segments_o <= 14'b01010101101101;
				8'd37:  Segments_o <= 14'b00101000100100;
				8'd38:  Segments_o <= 14'b11111111111111;
				8'd39:  Segments_o <= 14'b00000100000000;
				8'd40:  Segments_o <= 14'b10001000000000;
				8'd41:  Segments_o <= 14'b00100010000000;
				8'd42:  Segments_o <= 14'b11111111000000;
				8'd43:  Segments_o <= 14'b01010101000000;
				8'd44:  Segments_o <= 14'b00100000000000;
				8'd45:  Segments_o <= 14'b00010001000000;
				8'd46:  Segments_o <= 14'b01000000000000;
				8'd47:  Segments_o <= 14'b00101000000000;
				8'd48:  Segments_o <= 14'b00000000111111;
				8'd49:  Segments_o <= 14'b00001000000110;
				8'd50:  Segments_o <= 14'b00101000101001;
				8'd51:  Segments_o <= 14'b00010000001111;
				8'd52:  Segments_o <= 14'b00010001100110;
				8'd53:  Segments_o <= 14'b00010001101101;
				8'd54:  Segments_o <= 14'b00010001111101;
				8'd55:  Segments_o <= 14'b01001000000001;
				8'd56:  Segments_o <= 14'b00010001111111;
				8'd57:  Segments_o <= 14'b00010001101111;
				8'd58:  Segments_o <= 14'b11111111111111;
				8'd59:  Segments_o <= 14'b11111111111111;
				8'd60:  Segments_o <= 14'b10001000000000;
				8'd61:  Segments_o <= 14'b00010001001000;
				8'd62:  Segments_o <= 14'b00100010000000;
				8'd63:  Segments_o <= 14'b01010000100011;
				8'd64:  Segments_o <= 14'b00010000111011;
				8'd65:  Segments_o <= 14'b00010001110111;
				8'd66:  Segments_o <= 14'b01010100001111;
				8'd67:  Segments_o <= 14'b00000000111001;
				8'd68:  Segments_o <= 14'b01000100001111;
				8'd69:  Segments_o <= 14'b00000001111001;
				8'd70:  Segments_o <= 14'b00000001110001;
				8'd71:  Segments_o <= 14'b00010000111101;
				8'd72:  Segments_o <= 14'b00010001110110;
				8'd73:  Segments_o <= 14'b01000100001001;
				8'd74:  Segments_o <= 14'b00000000011110;
				8'd75:  Segments_o <= 14'b10001001110000;
				8'd76:  Segments_o <= 14'b00000000111000;
				8'd77:  Segments_o <= 14'b00001010110110;
				8'd78:  Segments_o <= 14'b10000010110110;
				8'd79:  Segments_o <= 14'b00000000111111;
				8'd80:  Segments_o <= 14'b00010001110011;
				8'd81:  Segments_o <= 14'b10000000111111;
				8'd82:  Segments_o <= 14'b10010001110011;
				8'd83:  Segments_o <= 14'b00010001101101;
				8'd84:  Segments_o <= 14'b01000100000001;
				8'd85:  Segments_o <= 14'b00000000111110;
				8'd86:  Segments_o <= 14'b00101000110000;
				8'd87:  Segments_o <= 14'b10100000110110;
				8'd88:  Segments_o <= 14'b10101010000000;
				8'd89:  Segments_o <= 14'b01001010000000;
				8'd90:  Segments_o <= 14'b00101000001001;
				8'd91:  Segments_o <= 14'b00000000000001;
				8'd92:  Segments_o <= 14'b00000000000010;
				8'd93:  Segments_o <= 14'b00000000000100;
				8'd94:  Segments_o <= 14'b00000000001000;
				8'd95:  Segments_o <= 14'b00000000010000;
				8'd96:  Segments_o <= 14'b00000000100000;
				8'd97:  Segments_o <= 14'b00000001000000;
				8'd98:  Segments_o <= 14'b00000010000000;
				8'd99:  Segments_o <= 14'b00000100000000;
				8'd100:  Segments_o <= 14'b00001000000000;
				8'd101:  Segments_o <= 14'b00010000000000;
				8'd102:  Segments_o <= 14'b00100000000000;
				8'd103:  Segments_o <= 14'b01000000000000;
				8'd104:  Segments_o <= 14'b10000000000000;
				8'd105:  Segments_o <= 14'b00000000000001;
				8'd106:  Segments_o <= 14'b00000000000010;
				8'd107:  Segments_o <= 14'b00000000000100;
				8'd108:  Segments_o <= 14'b00000000001000;
				8'd109:  Segments_o <= 14'b00000000010000;
				8'd110:  Segments_o <= 14'b00000000100000;
				8'd111:  Segments_o <= 14'b00000001000000;
				8'd112:  Segments_o <= 14'b00000010000000;
				8'd113:  Segments_o <= 14'b00000100000000;
				8'd114:  Segments_o <= 14'b00001000000000;
				8'd115:  Segments_o <= 14'b00010000000000;
				8'd116:  Segments_o <= 14'b00100000000000;
				8'd117:  Segments_o <= 14'b01000000000000;
				8'd118:  Segments_o <= 14'b10000000000000;
				8'd119:  Segments_o <= 14'b00000000000001;
				8'd120:  Segments_o <= 14'b00000000000010;
				8'd121:  Segments_o <= 14'b00000000000100;
				8'd122:  Segments_o <= 14'b00000000001000;
				8'd123:  Segments_o <= 14'b00000000010000;
				8'd124:  Segments_o <= 14'b00000000100000;
				8'd125:  Segments_o <= 14'b00000001000000;
				8'd126:  Segments_o <= 14'b00000010000000;
				8'd127:  Segments_o <= 14'b00000100000000;
				8'd128:  Segments_o <= 14'b00001000000000;
				8'd129:  Segments_o <= 14'b00010000000000;
				8'd130:  Segments_o <= 14'b00100000000000;
				8'd131:  Segments_o <= 14'b01000000000000;
				8'd132:  Segments_o <= 14'b10000000000000;
				8'd133:  Segments_o <= 14'b00000000000001;
				8'd134:  Segments_o <= 14'b00000000000010;
				8'd135:  Segments_o <= 14'b00000000000100;
				8'd136:  Segments_o <= 14'b00000000001000;
				8'd137:  Segments_o <= 14'b00000000010000;
				8'd138:  Segments_o <= 14'b00000000100000;
				8'd139:  Segments_o <= 14'b00000001000000;
				8'd140:  Segments_o <= 14'b00000010000000;
				8'd141:  Segments_o <= 14'b00000100000000;
				8'd142:  Segments_o <= 14'b00001000000000;
				8'd143:  Segments_o <= 14'b00010000000000;
				8'd144:  Segments_o <= 14'b00100000000000;
				8'd145:  Segments_o <= 14'b01000000000000;
				8'd146:  Segments_o <= 14'b10000000000000;
				8'd147:  Segments_o <= 14'b00000000000001;
				8'd148:  Segments_o <= 14'b00000000000010;
				8'd149:  Segments_o <= 14'b00000000000100;
				8'd150:  Segments_o <= 14'b00000000001000;
				8'd151:  Segments_o <= 14'b00000000010000;
				8'd152:  Segments_o <= 14'b00000000100000;
				8'd153:  Segments_o <= 14'b00000001000000;
				8'd154:  Segments_o <= 14'b00000010000000;
				8'd155:  Segments_o <= 14'b00000100000000;
				8'd156:  Segments_o <= 14'b00001000000000;
				8'd157:  Segments_o <= 14'b00010000000000;
				8'd158:  Segments_o <= 14'b00100000000000;
				8'd159:  Segments_o <= 14'b01000000000000;
				8'd160:  Segments_o <= 14'b10000000000000;
				8'd161:  Segments_o <= 14'b00000000000001;
				8'd162:  Segments_o <= 14'b00000000000010;
				8'd163:  Segments_o <= 14'b00000000000100;
				8'd164:  Segments_o <= 14'b00000000001000;
				8'd165:  Segments_o <= 14'b00000000010000;
				8'd166:  Segments_o <= 14'b00000000100000;
				8'd167:  Segments_o <= 14'b00000001000000;
				8'd168:  Segments_o <= 14'b00000010000000;
				8'd169:  Segments_o <= 14'b00000100000000;
				8'd170:  Segments_o <= 14'b00001000000000;
				8'd171:  Segments_o <= 14'b00010000000000;
				8'd172:  Segments_o <= 14'b00100000000000;
				8'd173:  Segments_o <= 14'b01000000000000;
				8'd174:  Segments_o <= 14'b10000000000000;
				8'd175:  Segments_o <= 14'b00000000000001;
				8'd176:  Segments_o <= 14'b00000000000010;
				8'd177:  Segments_o <= 14'b00000000000100;
				8'd178:  Segments_o <= 14'b00000000001000;
				8'd179:  Segments_o <= 14'b00000000010000;
				8'd180:  Segments_o <= 14'b00000000100000;
				8'd181:  Segments_o <= 14'b00000001000000;
				8'd182:  Segments_o <= 14'b00000010000000;
				8'd183:  Segments_o <= 14'b00000100000000;
				8'd184:  Segments_o <= 14'b00001000000000;
				8'd185:  Segments_o <= 14'b00010000000000;
				8'd186:  Segments_o <= 14'b00100000000000;
				8'd187:  Segments_o <= 14'b01000000000000;
				8'd188:  Segments_o <= 14'b10000000000000;
				8'd189:  Segments_o <= 14'b00000000000001;
				8'd190:  Segments_o <= 14'b00000000000010;
				8'd191:  Segments_o <= 14'b00000000000100;
				8'd192:  Segments_o <= 14'b00000000001000;
				8'd193:  Segments_o <= 14'b00000000010000;
				8'd194:  Segments_o <= 14'b00000000100000;
				8'd195:  Segments_o <= 14'b00000001000000;
				8'd196:  Segments_o <= 14'b00000010000000;
				8'd197:  Segments_o <= 14'b00000100000000;
				8'd198:  Segments_o <= 14'b00001000000000;
				8'd199:  Segments_o <= 14'b00010000000000;
				8'd200:  Segments_o <= 14'b00100000000000;
				8'd201:  Segments_o <= 14'b01000000000000;
				8'd202:  Segments_o <= 14'b10000000000000;
				8'd203:  Segments_o <= 14'b00000000000001;
				8'd204:  Segments_o <= 14'b00000000000010;
				8'd205:  Segments_o <= 14'b00000000000100;
				8'd206:  Segments_o <= 14'b00000000001000;
				8'd207:  Segments_o <= 14'b00000000010000;
				8'd208:  Segments_o <= 14'b00000000100000;
				8'd209:  Segments_o <= 14'b00000001000000;
				8'd210:  Segments_o <= 14'b00000010000000;
				8'd211:  Segments_o <= 14'b00000100000000;
				8'd212:  Segments_o <= 14'b00001000000000;
				8'd213:  Segments_o <= 14'b00010000000000;
				8'd214:  Segments_o <= 14'b00100000000000;
				8'd215:  Segments_o <= 14'b01000000000000;
				8'd216:  Segments_o <= 14'b10000000000000;
				8'd217:  Segments_o <= 14'b00000000000001;
				8'd218:  Segments_o <= 14'b00000000000010;
				8'd219:  Segments_o <= 14'b00000000000100;
				8'd220:  Segments_o <= 14'b00000000001000;
				8'd221:  Segments_o <= 14'b00000000010000;
				8'd222:  Segments_o <= 14'b00000000100000;
				8'd223:  Segments_o <= 14'b00000001000000;
				8'd224:  Segments_o <= 14'b00000010000000;
				8'd225:  Segments_o <= 14'b00000100000000;
				8'd226:  Segments_o <= 14'b00001000000000;
				8'd227:  Segments_o <= 14'b00010000000000;
				8'd228:  Segments_o <= 14'b00100000000000;
				8'd229:  Segments_o <= 14'b01000000000000;
				8'd230:  Segments_o <= 14'b10000000000000;
				8'd231:  Segments_o <= 14'b00000000000001;
				8'd232:  Segments_o <= 14'b00000000000010;
				8'd233:  Segments_o <= 14'b00000000000100;
				8'd234:  Segments_o <= 14'b00000000001000;
				8'd235:  Segments_o <= 14'b00000000010000;
				8'd236:  Segments_o <= 14'b00000000100000;
				8'd237:  Segments_o <= 14'b00000001000000;
				8'd238:  Segments_o <= 14'b00000010000000;
				8'd239:  Segments_o <= 14'b00000100000000;
				8'd240:  Segments_o <= 14'b00001000000000;
				8'd241:  Segments_o <= 14'b00010000000000;
				8'd242:  Segments_o <= 14'b00100000000000;
				8'd243:  Segments_o <= 14'b01000000000000;
				8'd244:  Segments_o <= 14'b10000000000000;
				8'd245:  Segments_o <= 14'b00000000000001;
				8'd246:  Segments_o <= 14'b00000000000010;
				8'd247:  Segments_o <= 14'b00000000000100;
				8'd248:  Segments_o <= 14'b00000000001000;
				8'd249:  Segments_o <= 14'b00000000010000;
				8'd250:  Segments_o <= 14'b00000000100000;
				8'd251:  Segments_o <= 14'b00000001000000;
				8'd252:  Segments_o <= 14'b00000010000000;
				8'd253:  Segments_o <= 14'b00000100000000;
				8'd254:  Segments_o <= 14'b00001000000000;
				8'd255:  Segments_o <= 14'b00010000000000;
			endcase
		end
	end
	
endmodule
`default_nettype wire
