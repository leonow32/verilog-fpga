	// Character memory
	wire [11:0] CharWriteAddress = CursorY * 80 + CursorX;		// Range 0..2399
	wire [11:0] CharReadAddress;
	
	// Multiplexer for memory outputs
	wire [7:0] CharDataFromRAM_0;
	wire [7:0] CharDataFromRAM_1;
	wire [7:0] CharDataFromRAM_2;
	wire [7:0] CharDataFromRAM = (CharReadAddress[11:10] == 2'd0) ? CharDataFromRAM_0 :
								 (CharReadAddress[11:10] == 2'd1) ? CharDataFromRAM_1 :
								 (CharReadAddress[11:10] == 2'd2) ? CharDataFromRAM_2 :
								 8'd0;
	
	// Memory blocks
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) CharRAM_0(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(CharReadAddress[11:10] == 2'd0),							// Czy to potrzebne
		.WriteEnable_i(CharWriteRequest && (CharWriteAddress[11:10] == 2'd0)),
		.ReadAddress_i(CharReadAddress[9:0]),
		.WriteAddress_i(CharWriteAddress[9:0]),
		.Data_i(DataFromUART),
		.Data_o(CharDataFromRAM_0)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024)
	) CharRAM_1(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(CharReadAddress[11:10] == 2'd1),							// Czy to potrzebne
		.WriteEnable_i(CharWriteRequest && (CharWriteAddress[11:10] == 2'd1)),
		.ReadAddress_i(CharReadAddress[9:0]),
		.WriteAddress_i(CharWriteAddress[9:0]),
		.Data_i(DataFromUART),
		.Data_o(CharDataFromRAM_1)
	);
	
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(352)
	) CharRAM_2(
		.ReadClock(Clock),
		.WriteClock(Clock),
		.Reset(Reset),
		.ReadEnable_i(CharReadAddress[11:10] == 2'd2),							// Czy to potrzebne
		.WriteEnable_i(CharWriteRequest && (CharWriteAddress[11:10] == 2'd2)),
		.ReadAddress_i(CharReadAddress[9:0]),
		.WriteAddress_i(CharWriteAddress[9:0]),
		.Data_i(DataFromUART),
		.Data_o(CharDataFromRAM_2)
	);
	*/
	
	// Font Memory
	/*
	wire [10:0] FontAddress;
	
	wire [7:0] FontDataFromROM_0;
	wire [7:0] FontDataFromROM_1;
	wire [7:0] FontDataFromROM = (FontAddress[10] == 1'd0) ? FontDataFromROM_0 : FontDataFromROM_1;
	
	// Characters 32...95
	ROM #(
		.ADDRESS_WIDTH(10),
		.DATA_WIDTH(8),
		.MEMORY_DEPTH(1024),
		.MEMORY_FILE("font_32_95.mem")
	) FontROM_0(
		.Clock(Clock),
		.Reset(Reset),
		.ReadEnable_i(1'b1),
		.Address_i(FontAddress[9:0]),
		.Data_o(FontDataFromROM_0)
	);
	
	