// 230426

`default_nettype none
module VGA(
	input  wire Clock,		// Must be 25 MHz or 25.175 MHz
	input  wire Reset,
	
	output wire       MemoryReadRequest_o,
	output wire [6:0] Column_o,			// Range 0..79
	output wire [4:0] Row_o,			// Range 0..29
	output wire [3:0] Line_o,			// Range 0..15
	
	input wire [7:0] PixelsToDisplay_i,	// 1 - has to be displayed with foreground color, 0 - background color
	input wire [2:0] ColorForeground_i,	// RGB
	input wire [2:0] ColorBackground_i,	// RGB
	
	output reg  Red_o,
	output reg  Green_o,
	output reg  Blue_o,
	output reg  HSync_o,
	output reg  VSync_o
);
	
	// Counters for 640*480 screen resolution
	reg [9:0] HCounter;		// Max 799
	reg [9:0] VCounter;		// Max 524
	
	// Horizontal and vertical pixel counter
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			HCounter <= 0;
			VCounter <= 0;
		end 
		
		else if(HCounter != 799) begin
			HCounter <= HCounter + 1'b1;
		end
			
		else begin
			HCounter <= 0;
			if(VCounter != 524)
				VCounter <= VCounter + 1'b1;
			else
				VCounter <= 0;
		end
	end
	
	assign Column_o[6:0]       = HCounter[9:3];
	assign Row_o[4:0]          = VCounter[8:4];
	assign Line_o[3:0]         = VCounter[3:0];
	assign MemoryReadRequest_o = HCounter[2:0] == 8'd0;
	
	
	
	/*
	// Cursor position for 128x96 screen resolution
	reg [2:0] HDivider;		// Max 4
	reg [2:0] VDivider;		// Max 4
	reg [6:0] HPixel;		// Max 127
	reg [6:0] VPixel;		// Max 95
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			HDivider <= 0;
			VDivider <= 0;
			HPixel <= 0;
			VPixel <= 0;
		end else begin
			// Simple but 3x times slower clock
			// HPixel <= HCounter / 5;
			// VPixel <= VCounter / 5;
			
			if(HDivider == 4) begin
				HDivider <= 0;
				if(HCounter == 799) begin
					HPixel <= 0;
					if(VCounter == 524) begin
						VPixel <= 0;
						VDivider <= 0;
					end else if(VDivider == 4) begin
						VDivider <= 0;
						VPixel <= VPixel + 1'b1;
					end else begin
						VDivider <= VDivider + 1'b1;
					end
				end else begin
					HPixel <= HPixel + 1'b1;
				end
			end else begin
				HDivider <= HDivider + 1'b1;
			end
		end
	end
	
	wire [3:0] PageNumber = VPixel[6:3];
	wire [2:0] LineInPage = VPixel[2:0];
	assign RequestedAddress_o[10:0] = PageNumber * 128 + HPixel;
	
	// Horizontal timing
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			{HSync_o, Red_o, Green_o, Blue_o} <= 4'b1000;
		
		// Horizontal active area
		else if(HCounter >= 2 && HCounter <= 641 && VCounter >= 0 && VCounter <= 479) begin
			if(HDivider == 2) begin
				if(DataFromRAM_i[LineInPage])
					{HSync_o, Red_o, Green_o, Blue_o} <= 4'b1111;
				else
					{HSync_o, Red_o, Green_o, Blue_o} <= 4'b1000;
			end
		end
		
		// Horizontal front porch
		else if(HCounter >= 642 && HCounter <= 657) 
			{HSync_o, Red_o, Green_o, Blue_o} <= 4'b1000;
		
		// Horizontal sync pulse
		else if(HCounter >= 658 && HCounter <= 753)
			{HSync_o, Red_o, Green_o, Blue_o} <= 4'b0000;
		
		// Horizontal back porch
		else
			{HSync_o, Red_o, Green_o, Blue_o} <= 4'b1000;
	end
	
	// Vertical timing
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			VSync_o <= 1;
		else if(HCounter == 2) begin
			if(VCounter == 490 || VCounter == 491) 	// Vertical sync pulse
				VSync_o <= 0;
			else 									// Active area, front and back porch
				VSync_o <= 1;
		end
	end
	*/
	
endmodule
`default_nettype wire
