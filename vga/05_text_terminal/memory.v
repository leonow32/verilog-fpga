// 240528

`default_nettype none

module Memory(
	input wire Clock,
	input wire Reset,
	
	// Write request from UART to text and color memory
	input wire AnalyzeRequest_i,
	input wire [7:0] DataFromUART_i,
	
	// Read request from VGA controller to the memory
	input wire GetImageRequest_i,
	input wire [6:0] Column_i,		// Range 0..79
	input wire [4:0] Row_i,			// Range 0..29
	input wire [3:0] Line_i,		// Range 0..15 (each char is made of 16 lines)
	
	// Output from font memory to VGA controller
	output reg  [7:0] Pixels_o,
	output reg  [2:0] ColorForeground_o,
	output reg  [2:0] ColorBackground_o
);
	
	// Variables to handle data write to image memory
	reg        WriteStep1;
	reg        WriteStep2;
	reg        WriteRequest;
	reg [ 7:0] WriteBuffer;
	reg [12:0] WriteAddress;
	reg [ 7:0] ColorBuffer;
	
	// Currently pointed character to be written
	reg [ 6:0] CursorX;										// Range 0..79
	reg [ 4:0] CursorY;										// Range 0..29
	
	wire [31:0] WriteCharNum = CursorY * 80 + CursorX;		// Range 0..2399
	
	// State machine to analyze data from UART and save it to image RAM
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
				8'h0D: begin
					CursorX <= 0;
					
					if(CursorY != 29)
						CursorY <= CursorY + 1'b1;
					else
						CursorY <= 0;
				end
				
				// Backspace
				8'h7F: begin
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
			WriteStep1   <= 0;
			WriteStep2   <= 1;
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
	
	// Read ASCII and color form image RAM
	reg [ 2:0] ReadState;	
	reg [12:0] ReadAddress;
	reg [10:0] FontAddress;
	
	wire [31:0] ReadCharNum  = Row_i * 80 + Column_i;		// Range 0..2399
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			ReadState         <= 0;
			ReadAddress       <= 0;
			FontAddress       <= 0;
			Pixels_o          <= 0;
			ColorForeground_o <= 0;
			ColorBackground_o <= 0;
		end 
		
		else case(ReadState)
			0: begin
				if(GetImageRequest_i) begin
					ReadAddress <= {ReadCharNum[11:0], 1'b0};			// Request ASCII code from image RAM
					ReadState   <= ReadState + 1'b1;					// Go to next state
				end
			end
			
			1: begin
				ReadAddress <= {ReadCharNum[11:0], 1'b1};				// Request color from image RAM
				ReadState   <= ReadState + 1'b1;						// Go to next state
			end
			
			2: begin
				FontAddress <= {DataFromImageRAM[6:0], Line_i[3:0]};	// Request font bitmap, DataFromImageRAM is ASCII code requested two clocls earlier
				ReadState   <= ReadState + 1'b1;						// Go to next state
			end
			
			3: begin
				// Do nothing here, just wait for FontROM to output pixel data
				ReadState <= ReadState + 1'b1;							// Go to next state
			end
			
			4: begin
				Pixels_o          <= DataFromFontROM[7:0];
				ColorForeground_o <= DataFromImageRAM[6:4];
				ColorBackground_o <= DataFromImageRAM[2:0];
				ReadState         <= 0;
			end
			
		endcase
	end
	
	// Image memory - text and color data
	// Each EBR can store 1024x8 bit	
	wire [7:0] DataFromImageRAM_[0:4];
	// wire [7:0] DataFromImageRAM_0;
	// wire [7:0] DataFromImageRAM_1;
	// wire [7:0] DataFromImageRAM_2;
	// wire [7:0] DataFromImageRAM_3;
	// wire [7:0] DataFromImageRAM_4;
	
	wire [7:0] DataFromImageRAM = (ReadAddress[12:10] == 3'd0) ? DataFromImageRAM_[0] :
								  (ReadAddress[12:10] == 3'd1) ? DataFromImageRAM_[1] :
								  (ReadAddress[12:10] == 3'd2) ? DataFromImageRAM_[2] :
								  (ReadAddress[12:10] == 3'd3) ? DataFromImageRAM_[3] :
								                                 DataFromImageRAM_[4];
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) ImageRAM_0(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadAddress[12:10] == 3'd0),
		.WriteEnable_i(WriteRequest && (WriteAddress[12:10] == 3'd0)),
		.ReadAddress_i(ReadAddress[9:0]),
		.WriteAddress_i(WriteAddress[9:0]),
		.Data_i(WriteBuffer),
		.Data_o(DataFromImageRAM_[0])
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) ImageRAM_1(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadAddress[12:10] == 3'd1),
		.WriteEnable_i(WriteRequest && (WriteAddress[12:10] == 3'd1)),
		.ReadAddress_i(ReadAddress[9:0]),
		.WriteAddress_i(WriteAddress[9:0]),
		.Data_i(WriteBuffer),
		.Data_o(DataFromImageRAM_[1])
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) ImageRAM_2(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadAddress[12:10] == 3'd2),
		.WriteEnable_i(WriteRequest && (WriteAddress[12:10] == 3'd2)),
		.ReadAddress_i(ReadAddress[9:0]),
		.WriteAddress_i(WriteAddress[9:0]),
		.Data_i(WriteBuffer),
		.Data_o(DataFromImageRAM_[2])
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) ImageRAM_3(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadAddress[12:10] == 3'd3),
		.WriteEnable_i(WriteRequest && (WriteAddress[12:10] == 3'd3)),
		.ReadAddress_i(ReadAddress[9:0]),
		.WriteAddress_i(WriteAddress[9:0]),
		.Data_i(WriteBuffer),
		.Data_o(DataFromImageRAM_[3])
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(704)
	) ImageRAM_4(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadAddress[12:10] == 3'd4),
		.WriteEnable_i(WriteRequest && (WriteAddress[12:10] == 3'd4)),
		.ReadAddress_i(ReadAddress[9:0]),
		.WriteAddress_i(WriteAddress[9:0]),
		.Data_i(WriteBuffer),
		.Data_o(DataFromImageRAM_[4])
	);
	
	// Font memory
	// Characters from 0 to 127.
	// Character size is 16x8 pixels.
	// 16 bytes per characher.
	// Whole memory is 2048 bytes.
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
		.Address_i(FontAddress),
		.Data_o(DataFromFontROM)
	);
	
endmodule

`default_nettype wire
