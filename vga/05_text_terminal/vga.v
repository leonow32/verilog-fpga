// 230426

`default_nettype none
module VGA(
	input  wire Clock,		// Must be 25 MHz or 25.175 MHz
	input  wire Reset,
	
	output wire       MemoryReadRequest_o,
	output wire [6:0] Column_o,			// Range 0..79
	output wire [4:0] Row_o,			// Range 0..29
	output wire [3:0] Line_o,			// Range 0..15
	
	input wire       DataReady_i,
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
	
	// Signal generation
	reg [2:0] CharHCounter;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			CharHCounter <= 3'd7;
		else if(HCounter[2:0] == 2)
			CharHCounter <= 3'd7;
		else
			CharHCounter <= CharHCounter - 1'b1;
	end
	
	// Horizontal timing
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			HSync_o <= 1;
			{Red_o, Green_o, Blue_o} <= 3'b000;
		end 
		
		// Horizontal active area
		else if(HCounter >= 3 && HCounter <= 642 && VCounter <= 479) begin
			if(PixelsToDisplay_i[CharHCounter])
				{Red_o, Green_o, Blue_o} <= ColorForeground_i;
			else
				{Red_o, Green_o, Blue_o} <= ColorBackground_i;
		end
		
		// Horizontal front porch
		else if(HCounter >= 643 && HCounter <= 658) 
			{HSync_o, Red_o, Green_o, Blue_o} <= 4'b1000;
		
		// Horizontal sync pulse
		else if(HCounter >= 659 && HCounter <= 754)
			{HSync_o, Red_o, Green_o, Blue_o} <= 4'b0000;
		
		// Horizontal back porch
		else
			{HSync_o, Red_o, Green_o, Blue_o} <= 4'b1000;
	end
	
	// Vertical timing
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			VSync_o <= 1;
		else if(HCounter == 3) begin
			if(VCounter == 490 || VCounter == 491) 	// Vertical sync pulse
				VSync_o <= 0;
			else 									// Active area, front and back porch
				VSync_o <= 1;
		end
	end
	
endmodule

`default_nettype wire
