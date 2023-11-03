// 230711

`default_nettype none
module Decoder14seg #(
	parameter COMMON_CATHODE = 1	// 1 - common cathode, 0 - common anode
)(
	input wire		   Enable_i,
	input wire	[7:0]  Data_i,
	output wire	[13:0] Segments_o
);
	
	reg		[13:0] Temp;
	
	always @(*) begin
		if(Enable_i)
			case(Data_i)
    8'd0:  Temp = 14'b00000000000000;
    8'd1:  Temp = 14'b01010101010101;
    8'd2:  Temp = 14'b00000000000001;
    8'd3:  Temp = 14'b00000000000010;
    8'd4:  Temp = 14'b00000000000100;
    8'd5:  Temp = 14'b00000000001000;
    8'd6:  Temp = 14'b00000000010000;
    8'd7:  Temp = 14'b00000000100000;
    8'd8:  Temp = 14'b00000001000000;
    8'd9:  Temp = 14'b00000010000000;
    8'd10:  Temp = 14'b00000100000000;
    8'd11:  Temp = 14'b00001000000000;
    8'd12:  Temp = 14'b00010000000000;
    8'd13:  Temp = 14'b00100000000000;
    8'd14:  Temp = 14'b01000000000000;
    8'd15:  Temp = 14'b10000000000000;
    8'd16:  Temp = 14'b00000000000001;
    8'd17:  Temp = 14'b00000000000010;
    8'd18:  Temp = 14'b00000000000100;
    8'd19:  Temp = 14'b00000000001000;
    8'd20:  Temp = 14'b00000000010000;
    8'd21:  Temp = 14'b00000000100000;
    8'd22:  Temp = 14'b00000001000000;
    8'd23:  Temp = 14'b00000010000000;
    8'd24:  Temp = 14'b00000100000000;
    8'd25:  Temp = 14'b00001000000000;
    8'd26:  Temp = 14'b00010000000000;
    8'd27:  Temp = 14'b00100000000000;
    8'd28:  Temp = 14'b01000000000000;
    8'd29:  Temp = 14'b10000000000000;
    8'd30:  Temp = 14'b00000000000001;
    8'd31:  Temp = 14'b00000000000010;
    8'd32:  Temp = 14'b00000000000100;
    8'd33:  Temp = 14'b01000100001000;
    8'd34:  Temp = 14'b00000000100010;
    8'd35:  Temp = 14'b11111111111111;
    8'd36:  Temp = 14'b01010101101101;
    8'd37:  Temp = 14'b00101000100100;
    8'd38:  Temp = 14'b11111111111111;
    8'd39:  Temp = 14'b00000100000000;
    8'd40:  Temp = 14'b10001000000000;
    8'd41:  Temp = 14'b00100010000000;
    8'd42:  Temp = 14'b11111111000000;
    8'd43:  Temp = 14'b01010101000000;
    8'd44:  Temp = 14'b00100000000000;
    8'd45:  Temp = 14'b00010001000000;
    8'd46:  Temp = 14'b01000000000000;
    8'd47:  Temp = 14'b00101000000000;
    8'd48:  Temp = 14'b00000000111111;
    8'd49:  Temp = 14'b00001000000110;
    8'd50:  Temp = 14'b00101000101001;
    8'd51:  Temp = 14'b00010000001111;
    8'd52:  Temp = 14'b00010001100110;
    8'd53:  Temp = 14'b00010001101101;
    8'd54:  Temp = 14'b00010001111101;
    8'd55:  Temp = 14'b01001000000001;
    8'd56:  Temp = 14'b00010001111111;
    8'd57:  Temp = 14'b00010001101111;
    8'd58:  Temp = 14'b11111111111111;
    8'd59:  Temp = 14'b11111111111111;
    8'd60:  Temp = 14'b10001000000000;
    8'd61:  Temp = 14'b00010001001000;
    8'd62:  Temp = 14'b00100010000000;
    8'd63:  Temp = 14'b01010000100011;
    8'd64:  Temp = 14'b00010000111011;
    8'd65:  Temp = 14'b00010001110111;
    8'd66:  Temp = 14'b01010100001111;
    8'd67:  Temp = 14'b00000000111001;
    8'd68:  Temp = 14'b01000100001111;
    8'd69:  Temp = 14'b00000001111001;
    8'd70:  Temp = 14'b00000001110001;
    8'd71:  Temp = 14'b00010000111101;
    8'd72:  Temp = 14'b00010001110110;
    8'd73:  Temp = 14'b01000100001001;
    8'd74:  Temp = 14'b00000000011110;
    8'd75:  Temp = 14'b10001001110000;
    8'd76:  Temp = 14'b00000000111000;
    8'd77:  Temp = 14'b00001010110110;
    8'd78:  Temp = 14'b10000010110110;
    8'd79:  Temp = 14'b00000000111111;
    8'd80:  Temp = 14'b00010001110011;
    8'd81:  Temp = 14'b10000000111111;
    8'd82:  Temp = 14'b10010001110011;
    8'd83:  Temp = 14'b00010001101101;
    8'd84:  Temp = 14'b01000100000001;
    8'd85:  Temp = 14'b00000000111110;
    8'd86:  Temp = 14'b00101000110000;
    8'd87:  Temp = 14'b10100000110110;
    8'd88:  Temp = 14'b10101010000000;
    8'd89:  Temp = 14'b01001010000000;
    8'd90:  Temp = 14'b00101000001001;
    8'd91:  Temp = 14'b00000000000001;
    8'd92:  Temp = 14'b00000000000010;
    8'd93:  Temp = 14'b00000000000100;
    8'd94:  Temp = 14'b00000000001000;
    8'd95:  Temp = 14'b00000000010000;
    8'd96:  Temp = 14'b00000000100000;
    8'd97:  Temp = 14'b00000001000000;
    8'd98:  Temp = 14'b00000010000000;
    8'd99:  Temp = 14'b00000100000000;
    8'd100:  Temp = 14'b00001000000000;
    8'd101:  Temp = 14'b00010000000000;
    8'd102:  Temp = 14'b00100000000000;
    8'd103:  Temp = 14'b01000000000000;
    8'd104:  Temp = 14'b10000000000000;
    8'd105:  Temp = 14'b00000000000001;
    8'd106:  Temp = 14'b00000000000010;
    8'd107:  Temp = 14'b00000000000100;
    8'd108:  Temp = 14'b00000000001000;
    8'd109:  Temp = 14'b00000000010000;
    8'd110:  Temp = 14'b00000000100000;
    8'd111:  Temp = 14'b00000001000000;
    8'd112:  Temp = 14'b00000010000000;
    8'd113:  Temp = 14'b00000100000000;
    8'd114:  Temp = 14'b00001000000000;
    8'd115:  Temp = 14'b00010000000000;
    8'd116:  Temp = 14'b00100000000000;
    8'd117:  Temp = 14'b01000000000000;
    8'd118:  Temp = 14'b10000000000000;
    8'd119:  Temp = 14'b00000000000001;
    8'd120:  Temp = 14'b00000000000010;
    8'd121:  Temp = 14'b00000000000100;
    8'd122:  Temp = 14'b00000000001000;
    8'd123:  Temp = 14'b00000000010000;
    8'd124:  Temp = 14'b00000000100000;
    8'd125:  Temp = 14'b00000001000000;
    8'd126:  Temp = 14'b00000010000000;
    8'd127:  Temp = 14'b00000100000000;
    8'd128:  Temp = 14'b00001000000000;
    8'd129:  Temp = 14'b00010000000000;
    8'd130:  Temp = 14'b00100000000000;
    8'd131:  Temp = 14'b01000000000000;
    8'd132:  Temp = 14'b10000000000000;
    8'd133:  Temp = 14'b00000000000001;
    8'd134:  Temp = 14'b00000000000010;
    8'd135:  Temp = 14'b00000000000100;
    8'd136:  Temp = 14'b00000000001000;
    8'd137:  Temp = 14'b00000000010000;
    8'd138:  Temp = 14'b00000000100000;
    8'd139:  Temp = 14'b00000001000000;
    8'd140:  Temp = 14'b00000010000000;
    8'd141:  Temp = 14'b00000100000000;
    8'd142:  Temp = 14'b00001000000000;
    8'd143:  Temp = 14'b00010000000000;
    8'd144:  Temp = 14'b00100000000000;
    8'd145:  Temp = 14'b01000000000000;
    8'd146:  Temp = 14'b10000000000000;
    8'd147:  Temp = 14'b00000000000001;
    8'd148:  Temp = 14'b00000000000010;
    8'd149:  Temp = 14'b00000000000100;
    8'd150:  Temp = 14'b00000000001000;
    8'd151:  Temp = 14'b00000000010000;
    8'd152:  Temp = 14'b00000000100000;
    8'd153:  Temp = 14'b00000001000000;
    8'd154:  Temp = 14'b00000010000000;
    8'd155:  Temp = 14'b00000100000000;
    8'd156:  Temp = 14'b00001000000000;
    8'd157:  Temp = 14'b00010000000000;
    8'd158:  Temp = 14'b00100000000000;
    8'd159:  Temp = 14'b01000000000000;
    8'd160:  Temp = 14'b10000000000000;
    8'd161:  Temp = 14'b00000000000001;
    8'd162:  Temp = 14'b00000000000010;
    8'd163:  Temp = 14'b00000000000100;
    8'd164:  Temp = 14'b00000000001000;
    8'd165:  Temp = 14'b00000000010000;
    8'd166:  Temp = 14'b00000000100000;
    8'd167:  Temp = 14'b00000001000000;
    8'd168:  Temp = 14'b00000010000000;
    8'd169:  Temp = 14'b00000100000000;
    8'd170:  Temp = 14'b00001000000000;
    8'd171:  Temp = 14'b00010000000000;
    8'd172:  Temp = 14'b00100000000000;
    8'd173:  Temp = 14'b01000000000000;
    8'd174:  Temp = 14'b10000000000000;
    8'd175:  Temp = 14'b00000000000001;
    8'd176:  Temp = 14'b00000000000010;
    8'd177:  Temp = 14'b00000000000100;
    8'd178:  Temp = 14'b00000000001000;
    8'd179:  Temp = 14'b00000000010000;
    8'd180:  Temp = 14'b00000000100000;
    8'd181:  Temp = 14'b00000001000000;
    8'd182:  Temp = 14'b00000010000000;
    8'd183:  Temp = 14'b00000100000000;
    8'd184:  Temp = 14'b00001000000000;
    8'd185:  Temp = 14'b00010000000000;
    8'd186:  Temp = 14'b00100000000000;
    8'd187:  Temp = 14'b01000000000000;
    8'd188:  Temp = 14'b10000000000000;
    8'd189:  Temp = 14'b00000000000001;
    8'd190:  Temp = 14'b00000000000010;
    8'd191:  Temp = 14'b00000000000100;
    8'd192:  Temp = 14'b00000000001000;
    8'd193:  Temp = 14'b00000000010000;
    8'd194:  Temp = 14'b00000000100000;
    8'd195:  Temp = 14'b00000001000000;
    8'd196:  Temp = 14'b00000010000000;
    8'd197:  Temp = 14'b00000100000000;
    8'd198:  Temp = 14'b00001000000000;
    8'd199:  Temp = 14'b00010000000000;
    8'd200:  Temp = 14'b00100000000000;
    8'd201:  Temp = 14'b01000000000000;
    8'd202:  Temp = 14'b10000000000000;
    8'd203:  Temp = 14'b00000000000001;
    8'd204:  Temp = 14'b00000000000010;
    8'd205:  Temp = 14'b00000000000100;
    8'd206:  Temp = 14'b00000000001000;
    8'd207:  Temp = 14'b00000000010000;
    8'd208:  Temp = 14'b00000000100000;
    8'd209:  Temp = 14'b00000001000000;
    8'd210:  Temp = 14'b00000010000000;
    8'd211:  Temp = 14'b00000100000000;
    8'd212:  Temp = 14'b00001000000000;
    8'd213:  Temp = 14'b00010000000000;
    8'd214:  Temp = 14'b00100000000000;
    8'd215:  Temp = 14'b01000000000000;
    8'd216:  Temp = 14'b10000000000000;
    8'd217:  Temp = 14'b00000000000001;
    8'd218:  Temp = 14'b00000000000010;
    8'd219:  Temp = 14'b00000000000100;
    8'd220:  Temp = 14'b00000000001000;
    8'd221:  Temp = 14'b00000000010000;
    8'd222:  Temp = 14'b00000000100000;
    8'd223:  Temp = 14'b00000001000000;
    8'd224:  Temp = 14'b00000010000000;
    8'd225:  Temp = 14'b00000100000000;
    8'd226:  Temp = 14'b00001000000000;
    8'd227:  Temp = 14'b00010000000000;
    8'd228:  Temp = 14'b00100000000000;
    8'd229:  Temp = 14'b01000000000000;
    8'd230:  Temp = 14'b10000000000000;
    8'd231:  Temp = 14'b00000000000001;
    8'd232:  Temp = 14'b00000000000010;
    8'd233:  Temp = 14'b00000000000100;
    8'd234:  Temp = 14'b00000000001000;
    8'd235:  Temp = 14'b00000000010000;
    8'd236:  Temp = 14'b00000000100000;
    8'd237:  Temp = 14'b00000001000000;
    8'd238:  Temp = 14'b00000010000000;
    8'd239:  Temp = 14'b00000100000000;
    8'd240:  Temp = 14'b00001000000000;
    8'd241:  Temp = 14'b00010000000000;
    8'd242:  Temp = 14'b00100000000000;
    8'd243:  Temp = 14'b01000000000000;
    8'd244:  Temp = 14'b10000000000000;
    8'd245:  Temp = 14'b00000000000001;
    8'd246:  Temp = 14'b00000000000010;
    8'd247:  Temp = 14'b00000000000100;
    8'd248:  Temp = 14'b00000000001000;
    8'd249:  Temp = 14'b00000000010000;
    8'd250:  Temp = 14'b00000000100000;
    8'd251:  Temp = 14'b00000001000000;
    8'd252:  Temp = 14'b00000010000000;
    8'd253:  Temp = 14'b00000100000000;
    8'd254:  Temp = 14'b00001000000000;
    8'd255:  Temp = 14'b00010000000000;

			endcase
		else
			Temp = 0;
	end
	
	// If the display has common anode then invert segment bits
	assign Segments_o = COMMON_CATHODE ? Temp : ~Temp;
	
endmodule
`default_nettype wire
