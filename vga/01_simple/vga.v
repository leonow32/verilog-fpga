// 230426

`default_nettype none
module VGA #(
	parameter	CLOCK_HZ	= 25_175_000
)(
	input  wire Clock,		// Must be 25 MHz
	input  wire Reset,
	output reg  Red_o,
	output reg  Green_o,
	output reg  Blue_o,
	output reg  HSync_o,
	output reg  VSync_o
);
	
	reg [2:0] TestData;
	
	// Timing for 640x400 70Hz
	// localparam H_ACTIVE			= 640;
	// localparam H_FRONT			= 16;
	// localparam H_SYNC			= 96;
	// localparam H_BACK			= 48;
	// localparam V_ACTIVE			= 400;
	// localparam V_FRONT			= 12;
	// localparam V_SYNC			= 2;
	// localparam V_BACK			= 35;
	
	// Timing for 640x480 60Hz
	localparam H_ACTIVE			= 640;
	localparam H_FRONT			= 16;
	localparam H_SYNC			= 96;
	localparam H_BACK			= 48;
	localparam V_ACTIVE			= 480;
	localparam V_FRONT			= 10;
	localparam V_SYNC			= 2;
	localparam V_BACK			= 33;
	
	// Calculations
	localparam H_TOTAL			= H_ACTIVE + H_FRONT + H_SYNC + H_BACK;
	localparam V_TOTAL			= V_ACTIVE + V_FRONT + V_SYNC + V_BACK;
	
	localparam H_GOTO_FRONT		= H_ACTIVE - 1;				// 639
	localparam H_GOTO_SYNC		= H_GOTO_FRONT + H_FRONT;	// 655
	localparam H_GOTO_BACK		= H_GOTO_SYNC + H_SYNC;		// 751
	localparam H_GOTO_ACTIVE	= H_GOTO_BACK + H_BACK;		// 799
	localparam V_GOTO_FRONT		= V_ACTIVE - 1;				// 479
	localparam V_GOTO_SYNC		= V_GOTO_FRONT + V_FRONT;	// 489
	localparam V_GOTO_BACK		= V_GOTO_SYNC + V_SYNC;		// 491
	localparam V_GOTO_ACTIVE	= V_GOTO_BACK + V_BACK;		// 524
	
	// Counters
	reg [$clog2(H_TOTAL)-1:0] HCounter;
	reg [$clog2(V_TOTAL)-1:0] VCounter;
	
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
			if(HCounter != H_TOTAL - 1)
				HCounter <= HCounter + 1'b1;
			else begin
				HCounter <= 0;
				if(VCounter != V_TOTAL - 1)
					VCounter <= VCounter + 1'b1;
				else
					VCounter <= 0;
			end
		end
	end
	
	// Horizontal state machine
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Red_o 	<= 0;
			Green_o	<= 0;
			Blue_o	<= 0;
			HSync_o	<= 1;
			HState	<= ACTIVE;
			
		end else begin
			case(HState)
				ACTIVE: begin
					if(VState == ACTIVE) begin
						Red_o   <= TestData[0];
						Green_o <= TestData[1];
						Blue_o  <= TestData[2];
						
						//Red_o   <= TestData[5];
						//Green_o <= TestData[6];
						//Blue_o  <= TestData[7];
						
						//Red_o   <= 1'b1;
						//Green_o <= 1'b1;
						//Blue_o  <= 1'b1;
						
						//{Red_o, Green_o, Blue_o} <= TestData + VCounter[2:0];
						
						
					end else begin
						Red_o   <= 0;
						Green_o <= 0;
						Blue_o  <= 0;
					end
					
					HSync_o <= 1;
					
					if(HCounter == H_GOTO_FRONT)
						HState <= FRONT;
				end
					
				FRONT: begin
					Red_o   <= 0;
					Green_o <= 0;
					Blue_o  <= 0;
					HSync_o <= 1;
					if(HCounter == H_GOTO_SYNC)
						HState <= SYNC;
				end
				
				SYNC: begin
					Red_o   <= 0;
					Green_o <= 0;
					Blue_o  <= 0;
					HSync_o <= 0;
					if(HCounter == H_GOTO_BACK)
						HState <= BACK;
				end
				
				BACK: begin
					Red_o   <= 0;
					Green_o <= 0;
					Blue_o  <= 0;
					HSync_o <= 1;
					if(HCounter == H_GOTO_ACTIVE)
						HState <= ACTIVE;
				end
			endcase
		end	
	end
	
	// Vertical state machine
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			VSync_o  	<= 1;
			VState	<= ACTIVE;
		end else begin
			case(VState)
				ACTIVE: begin
					VSync_o <= 1;
					if(VCounter == V_GOTO_FRONT && HCounter == H_GOTO_ACTIVE)
						VState <= FRONT;
				end
				
				FRONT: begin
					VSync_o <= 1;
					if(VCounter == V_GOTO_SYNC && HCounter == H_GOTO_ACTIVE)
						VState <= SYNC;
				end
				
				SYNC: begin
					VSync_o <= 0;
					if(VCounter == V_GOTO_BACK && HCounter == H_GOTO_ACTIVE)
						VState <= BACK;
				end
				
				BACK: begin
					VSync_o <= 1;
					if(VCounter == V_GOTO_ACTIVE && HCounter == H_GOTO_ACTIVE)
						VState <= ACTIVE;
				end
			
			endcase
		end
	end
	
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			TestData <= 3'b001;
		else if(HState == ACTIVE)
			TestData <= {TestData[1:0], TestData[2]};
	end
	
	
endmodule
`default_nettype wire
