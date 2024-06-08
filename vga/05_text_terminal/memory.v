// 240528

`default_nettype none

module Memory(
	input wire Clock,
	input wire Reset,
	
	// Write request from UART to text and color memory
	input wire AnalyzeRequest_i,
	input wire [7:0] DataFromUART_i,
	
	// Read request from VGA controller to the memory
	input wire ReadRequest_i,
	input wire [6:0] Column_i,		// Range 0..79
	input wire [4:0] Row_i,			// Range 0..29
	input wire [3:0] Line_i,		// Range 0..15
	
	// Output from font memory to VGA controller
	output reg  [7:0] Pixels_o,
	output reg  [2:0] ColorForeground_o,
	output reg  [2:0] ColorBackground_o
);
	
	reg WriteStep1;
	reg WriteStep2;
	reg WriteRequest;
	reg [7:0] WriteBuffer;
	reg [12:0] WriteAddress;
	
	reg [7:0] ColorBuffer;
	// reg [2:0] ColorForeground;
	// reg [2:0] ColorBackground;
	
	// Currently pointed character to be written
	reg [6:0] CursorX;										// Range 0..79
	reg [4:0] CursorY;										// Range 0..29
	
	wire [31:0] WriteCharNum = CursorY * 80 + CursorX;		// Range 0..2399
	wire [31:0] ReadCharNum  = Row_i * 80 + Column_i;
	
	// State machine to analyze data from UART
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			WriteStep1   <= 0;
			WriteStep2   <= 0;
			WriteRequest <= 0;
			WriteBuffer  <= 0;
			WriteAddress <= 0;
			
			ColorBuffer  <= 8'b1_111_0_000;		// Default color: white text on black background
			CursorX      <= 0;
			CursorY      <= 0;
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
				
				// Color
				8'b1XXXXXXX: begin
					ColorBuffer <= DataFromUART_i;
				end
				
				// Text
				8'b0XXXXXXX: begin
					WriteStep1   <= 1;						// Data memory will save ASCII code from UART in next cycle
					
					WriteRequest <= 1;						// Tell the memory to save data on the next clock cycle
					WriteBuffer  <= DataFromUART_i;
					WriteAddress <= {WriteCharNum[11:0], 1'b0};
				end
			endcase
		end
		
		// In previous clock cycle, the ASCII code has been saved to address [XXXXXXXXXXXX0]
		// Now save ColorBuffer to address [XXXXXXXXXXXX0]
		else if(WriteStep1) begin
			WriteStep1 <= 0;
			WriteStep2 <= 1;
			
			WriteRequest <= 1;						// Tell the memory to save data on the next clock cycle
			WriteBuffer  <= ColorBuffer;
			WriteAddress <= {WriteCharNum[11:0], 1'b1};
		end
		
		// In previous clock cycle, the ASCII code has been saved to address [XXXXXXXXXXXX0]
		// Now clear the request and move the cursor
		else if(WriteStep2) begin
			WriteStep2   <= 0;
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
	// Each EBR can store 1024x8 bit
	
	// Text and color memory
	
	
	
	
	
	// wire [15:0] DataFromTextRAM;
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(13),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(4800)
	) DataRAM(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(1'b1),
		.WriteEnable_i(WriteRequest),
//		.ReadAddress_i(ReadAddress),
		.ReadAddress_i(13'd0),
		.WriteAddress_i(WriteAddress),
		.Data_i(WriteBuffer),
//		.Data_o(DataFromTextRAM)
		.Data_o()
	);
	
	
	
	/*
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
		.WriteEnable_i(WriteStep1 && (TextWriteAddress[11:9] == 3'd0)),
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
		.WriteEnable_i(WriteStep1 && (TextWriteAddress[11:9] == 3'd1)),
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
		.WriteEnable_i(WriteStep1 && (TextWriteAddress[11:9] == 3'd2)),
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
		.WriteEnable_i(WriteStep1 && (TextWriteAddress[11:9] == 3'd3)),
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
		.WriteEnable_i(WriteStep1 && (TextWriteAddress[11:9] == 3'd4)),
		.ReadAddress_i(TextReadAddress[8:0]),
		.WriteAddress_i(TextWriteAddress[8:0]),
		.Data_i(TextDataToWrite),
		.Data_o(DataFromTextRAM_4)
	);
	*/
	
	
	
	
	
	
	
	// Font memory
	// Characters from 0 to 127.
	// Character size is 16x8 pixels.
	// 16 bytes per characher.
	// Whole memory is 2048 bytes.
	
	/*
	wire [7:0] DataFromFontROM;
	
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
	*/
	
endmodule

`default_nettype wire
