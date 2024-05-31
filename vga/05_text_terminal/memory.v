// 240528

`default_nettype none

module Memory(
	input wire Clock,
	input wire Reset,
	
	input AnalyzeRequest_i,
	input [7:0] DataFromUART_i,
	
	input ReadRequest_i,
	input [6:0] Column_i,		// Range 0..79
	input [4:0] Row_i,			// Range 0..29
	input [3:0] Line_i,			// Range 0..15
	
	output [7:0] Pixels_o,
	output [5:0] Color_o
);
	
	reg WriteRequest;
	reg [2:0] ColorForeground;
	reg [2:0] ColorBackground;
	reg [6:0] CursorX;			// Range 0..79
	reg [4:0] CursorY;			// 
	
	
	// State machine to analyze data from UART
	
	// Jeżeli DataFromUART_i[7] == 0 to odebrany został bajt
	// i musi zostać zapisany do pamięci razem z 
	// ostatnio odebranym rejestrem kolorów, po czym inkrementujemy
	// adres pamięci o 1 (jeden adres przechwouje tekst i kolor)
	// Jeżeli DataFromUART_i[7] == 1 to odebrany został kolor i 
	// należy go zapisać do tymczasowego rejestru kolorów.
	
	
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			WriteRequest <= 0;
			ColorForeground <= 3'b111;
			ColorBackground <= 3'b000;
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
						CursorY <= CursorY + 1;
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
				8'h00,
				8'h1B: begin
					CursorX <= 0;
					CursorY <= 0;
				end
				
				// Text
				8'b0XXXXXXX: begin
					WriteRequest <= 1;
				end
				
				// Color
				8'b1XXXXXXX: begin
					ColorForeground <= DataFromUART_i[6:4];
					ColorBackground <= DataFromUART_i[2:0];
				end
			
			endcase
		end
		
		// If previously received data has to be saved
		// Then save it to the memory and increment the cursors
		else if(WriteRequest) begin
			WriteRequest <= 0;
			
			if(CursorX != 79) begin
				CursorX <= CursorX + 1;
			end else begin
				CursorX <= 0;
				if(CursorY != 29)
					CursorY <= CursorY + 1;
				else
					CursorY <= 0;
			end
		end
	end
	
	// Memory of text and color
	// Pamięć tekstu i koloru
	// 2400 wpisów po 16 bitów
	// EBR może pracować w układzie 512x18bit
	
	// Text and color memory
	wire [11:0] TextWriteAddress = CursorY * 80 + CursorX;		// Range 0..2399
	wire [11:0] TextReadAddress  = Row_i * 80 + Column_i;
	wire [15:0] DataFromTextRAM;
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(12),
		.DATA_WIDTH(16),
		.MEMORY_DEPTH(2400)
	) TextRAM(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(1'b1),							// Czy to potrzebne
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
	);
	
	// Pamięć czcionki
	// Znaki od 0 do 127, 16 bajtów na znak
	// 2048 bajtów na całą pamięć czcionki
	//wire [7:0] 
	
	// characters 0...127
	
	
	//wire [10:0] FontAddress = (Row_i * 80 + Column_i) * 16 + Line_i
	
	
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
		.Data_o()
	);
	
endmodule

`default_nettype wire
