// 230426

`default_nettype none
module VGA(
	input  wire Clock,		// Must be 25 MHz or 25.175 MHz
	input  wire Reset,
	
	output reg [10:0] RequestedAddress,
	input wire [7:0] DataFromRAM,
	
	output reg  Red_o,
	output reg  Green_o,
	output reg  Blue_o,
	output reg  HSync_o,
	output reg  VSync_o
);
	
	// Counters
	reg [9:0] HCounter;		// Max 799
	reg [9:0] VCounter;		// Max 524
	
	wire [2:0] LineInPage = VCounter[2:0];
	wire [6:0] PageNumber = VCounter[9:3];
	
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
			// HDivider <= 0;
			// VDivider <= 0;
			// HPixel <= 0;
			// VPixel <= 0;
		end else begin
			if(HCounter != 799) begin
				HCounter <= HCounter + 1'b1;
				// if(HDivider == 4) begin
					// HDivider <= 0;
					// HPixel <= HPixel + 1'b1;
				// end else begin
					// HDivider <= HDivider + 1'b1;
				// end
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
			// Red_o 	<= 0;
			// Green_o	<= 0;
			// Blue_o	<= 0;
			// HSync_o	<= 1;
			HState	<= ACTIVE;
		end 
		
		else begin
			case(HState)
				ACTIVE: begin
					// if(VState != ACTIVE)
						// {Red_o, Green_o, Blue_o} <= 3'b000;
					// else if(DataFromRAM[LineInPage])
						// {Red_o, Green_o, Blue_o} <= 3'b111;
					// else
						// {Red_o, Green_o, Blue_o} <= 3'b000;
					
					// HSync_o <= 1;
					if(HCounter == 639)
						HState <= FRONT;
				end
					
				FRONT: begin
					// Red_o   <= 0;
					// Green_o <= 0;
					// Blue_o  <= 0;
					// HSync_o <= 1;
					if(HCounter == 655)
						HState <= SYNC;
				end
				
				SYNC: begin
					// Red_o   <= 0;
					// Green_o <= 0;
					// Blue_o  <= 0;
					// HSync_o <= 0;
					if(HCounter == 751)
						HState <= BACK;
				end
				
				BACK: begin
					// Red_o   <= 0;
					// Green_o <= 0;
					// Blue_o  <= 0;
					// HSync_o <= 1;
					if(HCounter == 799)
						HState <= ACTIVE;
				end
			endcase
		end	
	end
	
	// Vertical state machine
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			// VSync_o <= 1;
			VState	<= ACTIVE;
		end 
		
		else if(HCounter == 799) begin
			case(VState)
				ACTIVE: begin
					// VSync_o <= 1;
					if(VCounter == 479)
						VState <= FRONT;
				end
				
				FRONT: begin
					// VSync_o <= 1;
					if(VCounter == 489)
						VState <= SYNC;
				end
				
				SYNC: begin
					// VSync_o <= 0;
					if(VCounter == 491)
						VState <= BACK;
				end
				
				BACK: begin
					// VSync_o <= 1;
					if(VCounter == 524)
						VState <= ACTIVE;
				end
			
			endcase
		end
	end
	
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
			if(HState == ACTIVE && VState == ACTIVE) begin
				if(HDivider == 4) begin
					HDivider <= 0;
					HPixel <= HPixel + 1'b1;
				end else begin
					HDivider <= HDivider + 1'b1;
				end
			end else begin
				HDivider <= 0;
				HPixel <= 0;
			end
			
			if(HCounter == 799) begin
				if(VState == ACTIVE && VCounter != 479) begin
					if(VDivider == 4) begin
						VDivider <= 0;
						VPixel <= VPixel + 1'b1;
					end else begin
						VDivider <= VDivider + 1'b1;
					end
				end else begin
					VDivider <= 0;
					VPixel <= 0;
				end
			end 
		end
	end
	
	// Pixel 5x5
	// reg [2:0] Divider;
	
	
	// always @(posedge Clock, negedge Reset) begin
		// if(!Reset) begin
			// Divider = 0;
			// RequestedAddress = 0;
		// end 
		
		// else if(HState == ACTIVE) begin
			// if(Divider == 4) begin
				// Divider <= 0;
				// RequestedAddress <= RequestedAddress + 1'b1;
			// end else begin
				// Divider <= Divider + 1'b1;
			// end
		// end
	// end
	
	
endmodule
`default_nettype wire
