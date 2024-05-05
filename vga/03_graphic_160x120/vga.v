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
	
	// State machines
	reg [1:0] HState;
	reg [1:0] VState;
	
	// States
	localparam ACTIVE = 0;
	localparam FRONT  = 1;
	localparam SYNC   = 2;
	localparam BACK   = 3;
	
	// Horizontal and vertical counter
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			HCounter <= 0;
			VCounter <= 0;
		end else begin
			if(HCounter != 799) begin
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
	end
	
	// Horizontal state machine
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			HState	<= ACTIVE;
		end 
		
		else begin
			case(HState)
				ACTIVE: begin
					if(HCounter == 639)
						HState <= FRONT;
				end
					
				FRONT: begin
					if(HCounter == 655)
						HState <= SYNC;
				end
				
				SYNC: begin
					if(HCounter == 751)
						HState <= BACK;
				end
				
				BACK: begin
					if(HCounter == 799)
						HState <= ACTIVE;
				end
			endcase
		end	
	end
	
	// Vertical state machine
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			VState	<= ACTIVE;
		end 
		
		else if(HCounter == 799) begin
			case(VState)
				ACTIVE: begin
					if(VCounter == 479)
						VState <= FRONT;
				end
				
				FRONT: begin
					if(VCounter == 489)
						VState <= SYNC;
				end
				
				SYNC: begin
					if(VCounter == 491)
						VState <= BACK;
				end
				
				BACK: begin
					if(VCounter == 524)
						VState <= ACTIVE;
				end
			
			endcase
		end
	end
	
	// Counters for 160*120 screen resolution (640*480/4 = 160*120)
	reg [1:0] HDivider;		// Max 3
	reg [1:0] VDivider;		// Max 3
	reg [7:0] HPixel;		// Max 159
	reg [6:0] VPixel;		// Max 119
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			HDivider <= 0;
			VDivider <= 0;
			HPixel   <= 0;
			VPixel   <= 0;
		end else begin
			if(HState == ACTIVE && VState == ACTIVE && HCounter != 639) begin
				if(HDivider == 3) begin
					HDivider <= 0;
					HPixel   <= HPixel + 1'b1;
				end else begin
					HDivider <= HDivider + 1'b1;
				end
			end else begin
				HDivider <= 0;
				HPixel   <= 0;
			end
			
			if(HCounter == 799) begin
				if(VState == ACTIVE && VCounter != 479) begin
					if(VDivider == 3) begin
						VDivider <= 0;
						VPixel   <= VPixel + 1'b1;
					end else begin
						VDivider <= VDivider + 1'b1;
					end
				end else begin
					VDivider <= 0;
					VPixel   <= 0;
				end
			end 
		end
	end
	
	wire [2:0] LineInPage = VPixel[2:0];
	wire [3:0] PageNumber = VPixel[6:3];
	
	assign RequestedAddress_o[11:0] = (VPixel/8) * 160 + HPixel;
	
	// Output signals
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Red_o   <= 0;
			Green_o <= 0;
			Blue_o  <= 0;
			HSync_o <= 1;
			VSync_o <= 1;
		end 
		
		else begin
			
			// Vertical sync pulse
			if(VState == SYNC)
				VSync_o <= 0;
			else
				VSync_o <= 1;
			
			// Horizontal sync pulse
			if(HState == SYNC)
				HSync_o <= 0;
			else
				HSync_o <= 1;
				
			// RGB signals
			if(HDivider == 1) begin
				if(HState == ACTIVE && VState == ACTIVE && DataFromRAM_i[LineInPage])
					{Red_o, Green_o, Blue_o} <= 3'b111;
				else
					{Red_o, Green_o, Blue_o} <= 3'b000;
			end
			
			if(HState == ACTIVE && VState == ACTIVE) begin
				if(HDivider == 1 && DataFromRAM_i[LineInPage])
					{Red_o, Green_o, Blue_o} <= 3'b111;
			end else begin
				{Red_o, Green_o, Blue_o} <= 3'b000;
			end
		end
	end
	
endmodule
`default_nettype wire
