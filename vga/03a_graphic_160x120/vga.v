// 230426

`default_nettype none
module VGA(
	input  wire Clock,		// Must be 25 MHz or 25.175 MHz
	input  wire Reset,
	
	output wire [11:0] RequestedAddress_o,
	input  wire [ 7:0] DataFromRAM_i,
	
	output reg  Red_o,
	output reg  Green_o,
	output reg  Blue_o,
	output reg  HSync_o,
	output reg  VSync_o
);
	
	// Counters for 640*480 screen resolution
	reg [9:0] HCounter;		// Max 799
	reg [9:0] VCounter;		// Max 524
	
	// Horizontal and vertical counter
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
	
	// Cursor position for 128x96 screen resolution
	reg [2:0] HDivider;		// Max 3
	reg [2:0] VDivider;		// Max 3
	reg [7:0] HPixel;		// Max 159
	reg [6:0] VPixel;		// Max 119
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			HDivider <= 0;
			VDivider <= 0;
			HPixel <= 0;
			VPixel <= 0;
		end else begin
			// Simple but 3x times slower clock
			// HPixel <= HCounter / 4;
			// VPixel <= VCounter / 4;
			
			if(HDivider == 3) begin
				HDivider <= 0;
				if(HCounter == 799) begin
					HPixel <= 0;
					if(VCounter == 524) begin
						VPixel <= 0;
						VDivider <= 0;
					end else if(VDivider == 3) begin
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
	assign RequestedAddress_o[11:0] = PageNumber * 160 + HPixel;
	
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
	
endmodule
`default_nettype wire
