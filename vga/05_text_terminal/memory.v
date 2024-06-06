// 240528

`default_nettype wire

module Memory(
	input wire Clock,
	input wire Reset,
	
	input wire AnalyzeRequest_i,
	input wire [7:0] DataFromUART_i,
	
	input wire ReadRequest_i,
	input wire [6:0] Column_i,		// Range 0..79
	input wire [4:0] Row_i,			// Range 0..29
	input wire [3:0] Line_i,		// Range 0..15
	
	output reg  [7:0] Pixels_o,
	output reg  [2:0] ColorForeground_o,
	output reg  [2:0] ColorBackground_o
	
	,
	output wire [11:0] DebugTextWriteAddress,
//	output wire [15:0] DebugTextDataToWrite,
	output wire [ 7:0] DebugTextDataToWrite,
	output wire [ 7:0] DebugDataFromTextRAM,
	output wire [11:0] DebugTextReadAddress
);
	
	reg WriteRequest;
	reg [2:0] ColorForeground;
	reg [2:0] ColorBackground;
	reg [6:0] CursorX;				// Range 0..79
	reg [4:0] CursorY;				// 
	
	
	// State machine to analyze data from UART
	

	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			WriteRequest <= 0;
			// ColorForeground <= 3'b111;
			// ColorBackground <= 3'b000;
			CursorX <= 0;
			CursorY <= 0;
		end 
		
		// If new data was received be UART module
		// Then analyze what to do with this data
		else if(AnalyzeRequest_i) begin
			casex(DataFromUART_i)
				
				// New line
				8'h10: begin
					if(CursorY != 29)
						CursorY <= CursorY + 1'b1;
					else
						CursorY <= 0;
				end
				
				// Carrige return
				8'h13: begin
					CursorX <= 0;
				end
				
				// Backspace
				8'h08: begin
					if(CursorX != 0)
						CursorX <= CursorX - 1'b1;
					else begin
						CursorX <= 79;
						if(CursorY != 0)
							CursorY <= CursorY - 1'b1;
						else
							CursorY <= 29;
					end
				end
				
				// Cursor back to home
				8'h1B: begin
					CursorX <= 0;
					CursorY <= 0;
				end
				
				// Text
				8'b0XXXXXXX: begin
					WriteRequest <= 1;
				end
				
				// Color
				// 8'b1XXXXXXX: begin
					// ColorForeground <= DataFromUART_i[6:4];
					// ColorBackground <= DataFromUART_i[2:0];
				// end
			
			endcase
		end
		
		// If previously received data has to be saved
		// Then save it to the memory and increment the cursors
		else if(WriteRequest) begin
			WriteRequest <= 0;
			
			if(CursorX != 79) begin
				CursorX <= CursorX + 1'b1;
			end else begin
				CursorX <= 0;
				if(CursorY != 29)
					CursorY <= CursorY + 1'b1;
				else
					CursorY <= 0;
			end
		end
	end
	
	// Memory of text and color
	// 2400 words of 16 bits
	// EBR can store 512x18bit
	
	// Text and color memory
	wire [31:0] Temp1 = CursorY * 80 + CursorX;
	wire [11:0] TextWriteAddress = Temp1[11:0];		// Range 0..2399
	
	assign DebugTextWriteAddress = TextWriteAddress;
	
	wire [31:0] Temp2 = Row_i * 80 + Column_i;
	wire [11:0] TextReadAddress  = Temp2[11:0];
	
	// wire [15:0] TextDataToWrite = {
		// 1'b0, 					// [15]
		// ColorForeground[2:0], 	// [14:12]
		// 1'b0, 					// [11]
		// ColorBackground[2:0], 	// [10:8]
		// DataFromUART_i[7:0]		// [7:0]
	// };
	
	wire [7:0] TextDataToWrite = {
		DataFromUART_i[7:0]		// [7:0]
	};
	
	
	assign DebugTextDataToWrite = TextDataToWrite;
	
	
	
	
	
	/*
	// wire [15:0] DataFromTextRAM;
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(12),
		.DATA_WIDTH(16),
		.MEMORY_DEPTH(2400)
	) TextRAM(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(1'b1),
		.WriteEnable_i(WriteRequest),
		.ReadAddress_i(TextReadAddress),
		.WriteAddress_i(TextWriteAddress),
		.Data_i({
			1'b0, 
			ColorForeground[2:0], 
			1'b0, 
			ColorBackground[2:0], 
			DataFromUART_i[7:0]
		}),
		.Data_o(DataFromTextRAM)
	);*/
	
	
	// IP Express generated module
	/*
	wire [15:0] DataFromTextRAM;
	
	text_ram text_ram_inst(
		.WrAddress(TextWriteAddress), 
		.RdAddress(TextReadAddress), 
		.Data(TextDataToWrite), 
		.WE(WriteRequest), 
		.RdClock(Clock), 
		.RdClockEn(1'b1), 
		.Reset(Reset), 
		.WrClock(Clock), 
		.WrClockEn(1'b1),
		.Q(DataFromTextRAM)
	);
	
	assign DebugTextReadAddress = TextReadAddress;
	*/
	
	wire [7:0] DataFromTextRAM_0;
	wire [7:0] DataFromTextRAM_1;
	wire [7:0] DataFromTextRAM_2;
	wire [7:0] DataFromTextRAM_3;
	wire [7:0] DataFromTextRAM_4;
	
	wire [7:0] DataFromTextRAM = (TextReadAddress[11:9] == 3'd0) ? DataFromTextRAM_0 :
								 (TextReadAddress[11:9] == 3'd1) ? DataFromTextRAM_1 :
								 (TextReadAddress[11:9] == 3'd2) ? DataFromTextRAM_2 :
								 (TextReadAddress[11:9] == 3'd3) ? DataFromTextRAM_3 :
								                                   DataFromTextRAM_4;
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(9),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(512)
	) TextRAM_0(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(TextReadAddress[11:9] == 3'd0),
		.WriteEnable_i(WriteRequest && (TextWriteAddress[11:9] == 3'd0)),
		.ReadAddress_i(TextReadAddress[8:0]),
		.WriteAddress_i(TextWriteAddress[8:0]),
		.Data_i(TextDataToWrite),
		.Data_o(DataFromTextRAM_0)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(9),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(512)
	) TextRAM_1(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(TextReadAddress[11:9] == 3'd1),
		.WriteEnable_i(WriteRequest && (TextWriteAddress[11:9] == 3'd1)),
		.ReadAddress_i(TextReadAddress[8:0]),
		.WriteAddress_i(TextWriteAddress[8:0]),
		.Data_i(TextDataToWrite),
		.Data_o(DataFromTextRAM_1)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(9),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(512)
	) TextRAM_2(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(TextReadAddress[11:9] == 3'd2),
		.WriteEnable_i(WriteRequest && (TextWriteAddress[11:9] == 3'd2)),
		.ReadAddress_i(TextReadAddress[8:0]),
		.WriteAddress_i(TextWriteAddress[8:0]),
		.Data_i(TextDataToWrite),
		.Data_o(DataFromTextRAM_2)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(9),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(512)
	) TextRAM_3(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(TextReadAddress[11:9] == 3'd3),
		.WriteEnable_i(WriteRequest && (TextWriteAddress[11:9] == 3'd3)),
		.ReadAddress_i(TextReadAddress[8:0]),
		.WriteAddress_i(TextWriteAddress[8:0]),
		.Data_i(TextDataToWrite),
		.Data_o(DataFromTextRAM_3)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(9),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(352)
	) TextRAM_4(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(TextReadAddress[11:9] == 3'd4),
		.WriteEnable_i(WriteRequest && (TextWriteAddress[11:9] == 3'd4)),
		.ReadAddress_i(TextReadAddress[8:0]),
		.WriteAddress_i(TextWriteAddress[8:0]),
		.Data_i(TextDataToWrite),
		.Data_o(DataFromTextRAM_4)
	);
	
	assign DebugDataFromTextRAM = DataFromTextRAM;
	
	// Font memory
	// Characters from 0 to 127.
	// Character size is 16x8 pixels.
	// 16 bytes per characher.
	// Whole memory is 2048 bytes.
	
	wire [7:0] DataFromFontROM;
	//wire [7:0] DataFromFontROM = 16'h6241;
	
	ROM #(
		.ADDRESS_WIDTH(11),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(2048),
		.MEMORY_FILE("font_0_127.mem")
	) FontROM(
		.Clock(Clock),
		.Reset(Reset),
		.ReadEnable_i(1'b1),
		.Address_i({
			DataFromTextRAM[6:0],
			Line_i[3:0]
		}),
		.Data_o(DataFromFontROM)
	);
	
	/*
	// IP Express generated module
	FontROM FontROM_inst(
		.Address({
			DataFromTextRAM[6:0],
			Line_i[3:0]
		}),
		.OutClock(Clock),
		.OutClockEn(1'b1),
		.Reset(Reset),
		.Q(DataFromFontROM)
	);*/
	
	reg [1:0] DelayLine;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			DelayLine <= 3'b001;
		else if(ReadRequest_i)
			DelayLine <= 3'b001;
		else	
			DelayLine <= DelayLine << 1;
	end
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Pixels_o          <= 0;
			ColorForeground_o <= 3'b111;
			ColorBackground_o <= 3'b000;
		end 
		
		else if(DelayLine[1]) begin
			Pixels_o          <= DataFromFontROM;
			// Pixels_o          <= DataFromTextRAM[7:0];
			// ColorForeground_o <= DataFromTextRAM[14:12];
			// ColorBackground_o <= DataFromTextRAM[10:8];
			ColorForeground_o <= 3'b011;
			ColorBackground_o <= 3'b001;
		end
	end
	
endmodule

`default_nettype none
