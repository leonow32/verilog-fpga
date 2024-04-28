// 230426

`default_nettype none
module VGA(
	input  wire Clock,		// Must be 25 MHz or 25.175 MHz
	input  wire Reset,
	
	output reg  Red_o,
	output reg  Green_o,
	output reg  Blue_o,
	output reg  HSync_o,
	output reg  VSync_o
);
	
	// Counters
	reg [9:0] HCounter;
	reg [9:0] VCounter;
	
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
			if(HCounter != 799)
				HCounter <= HCounter + 1'b1;
			else begin
				HCounter <= 0;
				if(VCounter != 524)
					VCounter <= VCounter + 1'b1;
				else
					VCounter <= 0;
			end
		end
	end
	
	// For color test pattern
	wire [6:0] Sum = HCounter[9:4] + VCounter[9:4];
	wire [2:0] ColorSelector = Sum[2:0];
	
	// Horizontal state machine
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Red_o 	<= 0;
			Green_o	<= 0;
			Blue_o	<= 0;
			HSync_o	<= 1;
			HState	<= ACTIVE;
		end 
		
		else begin
			case(HState)
				ACTIVE: begin
					if(VState != ACTIVE) begin
						{Red_o, Green_o, Blue_o} <= 3'b000;
					end else begin
						case(ColorSelector) 
							3'd0:	{Red_o, Green_o, Blue_o} <= 3'b100;
							3'd1:	{Red_o, Green_o, Blue_o} <= 3'b110;
							3'd2:	{Red_o, Green_o, Blue_o} <= 3'b010;
							3'd3:	{Red_o, Green_o, Blue_o} <= 3'b011;
							3'd4:	{Red_o, Green_o, Blue_o} <= 3'b001;
							3'd5:	{Red_o, Green_o, Blue_o} <= 3'b101;
							3'd6:	{Red_o, Green_o, Blue_o} <= 3'b000;
							3'd7:	{Red_o, Green_o, Blue_o} <= 3'b111;
						endcase
					end 
					
					HSync_o <= 1;
					if(HCounter == 639)
						HState <= FRONT;
				end
					
				FRONT: begin
					Red_o   <= 0;
					Green_o <= 0;
					Blue_o  <= 0;
					HSync_o <= 1;
					if(HCounter == 655)
						HState <= SYNC;
				end
				
				SYNC: begin
					Red_o   <= 0;
					Green_o <= 0;
					Blue_o  <= 0;
					HSync_o <= 0;
					if(HCounter == 751)
						HState <= BACK;
				end
				
				BACK: begin
					Red_o   <= 0;
					Green_o <= 0;
					Blue_o  <= 0;
					HSync_o <= 1;
					if(HCounter == 799)
						HState <= ACTIVE;
				end
			endcase
		end	
	end
	
	// Vertical state machine
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			VSync_o <= 1;
			VState	<= ACTIVE;
		end 
		
		else if(HCounter == 799) begin
			case(VState)
				ACTIVE: begin
					VSync_o <= 1;
					if(VCounter == 479)
						VState <= FRONT;
				end
				
				FRONT: begin
					VSync_o <= 1;
					if(VCounter == 489)
						VState <= SYNC;
				end
				
				SYNC: begin
					VSync_o <= 0;
					if(VCounter == 491)
						VState <= BACK;
				end
				
				BACK: begin
					VSync_o <= 1;
					if(VCounter == 524)
						VState <= ACTIVE;
				end
			
			endcase
		end
	end
	
endmodule
`default_nettype wire
