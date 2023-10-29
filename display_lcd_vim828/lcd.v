// 231029

`include "vim828_defines.vh"

`default_nettype none
module LCD #(
	parameter	CLOCK_HZ      = 10_000_000,
	parameter	CHANGE_COM_US = 1000
)(
	input  wire       Clock,
	input  wire       Reset,
	
	// Rightmost character = 0
	// Leftmost character  = 7
	// Segment order in each input = pnmlkjihgfedcba
	input  wire [14:0] Bitmap7_i,
	input  wire [14:0] Bitmap6_i,
	input  wire [14:0] Bitmap5_i,
	input  wire [14:0] Bitmap4_i,
	input  wire [14:0] Bitmap3_i,
	input  wire [14:0] Bitmap2_i,
	input  wire [14:0] Bitmap1_i,
	input  wire [14:0] Bitmap0_i, 
	
	// Connect this output to LCD pins
	// Each line needs a RC filter to smooth PWM signal
	// R = 4k7
	// C = 10n
	output wire [36:1] Pin_o
);
	
	// PWM generator to create 0, 1/3, 2/3 and 1 voltage levels
	wire [3:0] Voltage;
	LCD_PWM LCD_PWM_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Voltage0_o(Voltage[0]),  // 0V
		.Voltage1_o(Voltage[1]),  // 1V
		.Voltage2_o(Voltage[2]),  // 2V
		.Voltage3_o(Voltage[3])   // 3V
	);
	
	// Strobe for changing the state
	wire ChangeState;
	
	StrobeGenerator #(
		.CLOCK_HZ(CLOCK_HZ),
		.PERIOD_US(CHANGE_COM_US)
	) StrobeGenerator_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Enable_i(1'b1),
		.Strobe_o(ChangeState)
	);
	
	// State machine
	reg [2:0] State /* synthesis syn_encoding = "sequential" */;
	localparam [2:0] COM_0H = 3'd0;
	localparam [2:0] COM_1H = 3'd1;
	localparam [2:0] COM_2H = 3'd2;
	localparam [2:0] COM_3H = 3'd3;
	localparam [2:0] COM_0L = 3'd4;
	localparam [2:0] COM_1L = 3'd5;
	localparam [2:0] COM_2L = 3'd6;
	localparam [2:0] COM_3L = 3'd7;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) 
			State <= 0;
		else if(ChangeState)
			State <= State + 1'b1;
	end
	
	reg [1:0] PinVoltage[36:1];
	
	// Part H
	// - Active COM:   3
	// - Inactive COM: 1
	// - Active SEG:   0
	// - Inactive SEG: 2
	// Part L
	// - Active COM:   0
	// - Inactive COM: 2
	// - Active SEG:   3
	// - Inactive SEG: 1

	always @(*) begin
		case(State)
			COM_0H: begin
				PinVoltage[`COM0] = 2'd3;
				PinVoltage[`COM1] = 2'd1;
				PinVoltage[`COM2] = 2'd1;
				PinVoltage[`COM3] = 2'd1;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0_i[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0__FED] = 2'd2;
				PinVoltage[`SEG0_IJKN] = Bitmap0_i[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_HGLM] = Bitmap0_i[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1_i[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1__FED] = 2'd2;
				PinVoltage[`SEG1_IJKN] = Bitmap1_i[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_HGLM] = Bitmap1_i[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2_i[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2__FED] = 2'd2;
				PinVoltage[`SEG2_IJKN] = Bitmap2_i[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_HGLM] = Bitmap2_i[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3_i[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3__FED] = 2'd2;
				PinVoltage[`SEG3_IJKN] = Bitmap3_i[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_HGLM] = Bitmap3_i[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4_i[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4__FED] = 2'd2;
				PinVoltage[`SEG4_IJKN] = Bitmap4_i[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_HGLM] = Bitmap4_i[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5_i[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5__FED] = 2'd2;
				PinVoltage[`SEG5_IJKN] = Bitmap5_i[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_HGLM] = Bitmap5_i[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6_i[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6__FED] = 2'd2;
				PinVoltage[`SEG6_IJKN] = Bitmap6_i[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_HGLM] = Bitmap6_i[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7_i[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7__FED] = 2'd2;
				PinVoltage[`SEG7_IJKN] = Bitmap7_i[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_HGLM] = Bitmap7_i[`BIT_H] ? 2'd0 : 2'd2;
			end
			
			COM_1H: begin
				PinVoltage[`COM0] = 2'd1;
				PinVoltage[`COM1] = 2'd3;
				PinVoltage[`COM2] = 2'd1;
				PinVoltage[`COM3] = 2'd1;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0_i[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0__FED] = Bitmap0_i[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_IJKN] = Bitmap0_i[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_HGLM] = Bitmap0_i[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1_i[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1__FED] = Bitmap1_i[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_IJKN] = Bitmap1_i[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_HGLM] = Bitmap1_i[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2_i[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2__FED] = Bitmap2_i[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_IJKN] = Bitmap2_i[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_HGLM] = Bitmap2_i[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3_i[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3__FED] = Bitmap3_i[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_IJKN] = Bitmap3_i[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_HGLM] = Bitmap3_i[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4_i[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4__FED] = Bitmap4_i[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_IJKN] = Bitmap4_i[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_HGLM] = Bitmap4_i[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5_i[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5__FED] = Bitmap5_i[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_IJKN] = Bitmap5_i[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_HGLM] = Bitmap5_i[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6_i[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6__FED] = Bitmap6_i[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_IJKN] = Bitmap6_i[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_HGLM] = Bitmap6_i[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7_i[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7__FED] = Bitmap7_i[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_IJKN] = Bitmap7_i[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_HGLM] = Bitmap7_i[`BIT_G] ? 2'd0 : 2'd2;
			end
			
			COM_2H: begin
				PinVoltage[`COM0] = 2'd1;
				PinVoltage[`COM1] = 2'd1;
				PinVoltage[`COM2] = 2'd3;
				PinVoltage[`COM3] = 2'd1;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0_i[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0__FED] = Bitmap0_i[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_IJKN] = Bitmap0_i[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_HGLM] = Bitmap0_i[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1_i[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1__FED] = Bitmap1_i[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_IJKN] = Bitmap1_i[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_HGLM] = Bitmap1_i[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2_i[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2__FED] = Bitmap2_i[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_IJKN] = Bitmap2_i[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_HGLM] = Bitmap2_i[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3_i[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3__FED] = Bitmap3_i[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_IJKN] = Bitmap3_i[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_HGLM] = Bitmap3_i[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4_i[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4__FED] = Bitmap4_i[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_IJKN] = Bitmap4_i[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_HGLM] = Bitmap4_i[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5_i[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5__FED] = Bitmap5_i[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_IJKN] = Bitmap5_i[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_HGLM] = Bitmap5_i[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6_i[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6__FED] = Bitmap6_i[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_IJKN] = Bitmap6_i[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_HGLM] = Bitmap6_i[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7_i[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7__FED] = Bitmap7_i[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_IJKN] = Bitmap7_i[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_HGLM] = Bitmap7_i[`BIT_L] ? 2'd0 : 2'd2;
			end
			
			COM_3H: begin
				PinVoltage[`COM0] = 2'd1;
				PinVoltage[`COM1] = 2'd1;
				PinVoltage[`COM2] = 2'd1;
				PinVoltage[`COM3] = 2'd3;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0_i[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0__FED] = Bitmap0_i[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_IJKN] = Bitmap0_i[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_HGLM] = Bitmap0_i[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1_i[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1__FED] = Bitmap1_i[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_IJKN] = Bitmap1_i[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_HGLM] = Bitmap1_i[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2_i[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2__FED] = Bitmap2_i[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_IJKN] = Bitmap2_i[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_HGLM] = Bitmap2_i[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3_i[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3__FED] = Bitmap3_i[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_IJKN] = Bitmap3_i[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_HGLM] = Bitmap3_i[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4_i[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4__FED] = Bitmap4_i[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_IJKN] = Bitmap4_i[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_HGLM] = Bitmap4_i[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5_i[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5__FED] = Bitmap5_i[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_IJKN] = Bitmap5_i[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_HGLM] = Bitmap5_i[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6_i[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6__FED] = Bitmap6_i[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_IJKN] = Bitmap6_i[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_HGLM] = Bitmap6_i[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7_i[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7__FED] = Bitmap7_i[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_IJKN] = Bitmap7_i[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_HGLM] = Bitmap7_i[`BIT_M] ? 2'd0 : 2'd2;
			end
			
			COM_0L: begin
				PinVoltage[`COM0] = 2'd0;
				PinVoltage[`COM1] = 2'd2;
				PinVoltage[`COM2] = 2'd2;
				PinVoltage[`COM3] = 2'd2;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0_i[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0__FED] = 2'd1;
				PinVoltage[`SEG0_IJKN] = Bitmap0_i[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_HGLM] = Bitmap0_i[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1_i[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1__FED] = 2'd1;
				PinVoltage[`SEG1_IJKN] = Bitmap1_i[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_HGLM] = Bitmap1_i[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2_i[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2__FED] = 2'd1;
				PinVoltage[`SEG2_IJKN] = Bitmap2_i[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_HGLM] = Bitmap2_i[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3_i[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3__FED] = 2'd1;
				PinVoltage[`SEG3_IJKN] = Bitmap3_i[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_HGLM] = Bitmap3_i[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4_i[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4__FED] = 2'd1;
				PinVoltage[`SEG4_IJKN] = Bitmap4_i[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_HGLM] = Bitmap4_i[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5_i[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5__FED] = 2'd1;
				PinVoltage[`SEG5_IJKN] = Bitmap5_i[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_HGLM] = Bitmap5_i[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6_i[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6__FED] = 2'd1;
				PinVoltage[`SEG6_IJKN] = Bitmap6_i[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_HGLM] = Bitmap6_i[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7_i[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7__FED] = 2'd1;
				PinVoltage[`SEG7_IJKN] = Bitmap7_i[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_HGLM] = Bitmap7_i[`BIT_H] ? 2'd3 : 2'd1;
				
			end
			
			COM_1L: begin
				PinVoltage[`COM0] = 2'd2;						// COM0
				PinVoltage[`COM1] = 2'd0;						// COM1
				PinVoltage[`COM2] = 2'd2;						// COM2
				PinVoltage[`COM3] = 2'd2;						// COM3
				
				PinVoltage[`SEG0_ABCP] = Bitmap0_i[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0__FED] = Bitmap0_i[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_IJKN] = Bitmap0_i[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_HGLM] = Bitmap0_i[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1_i[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1__FED] = Bitmap1_i[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_IJKN] = Bitmap1_i[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_HGLM] = Bitmap1_i[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2_i[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2__FED] = Bitmap2_i[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_IJKN] = Bitmap2_i[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_HGLM] = Bitmap2_i[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3_i[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3__FED] = Bitmap3_i[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_IJKN] = Bitmap3_i[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_HGLM] = Bitmap3_i[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4_i[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4__FED] = Bitmap4_i[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_IJKN] = Bitmap4_i[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_HGLM] = Bitmap4_i[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5_i[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5__FED] = Bitmap5_i[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_IJKN] = Bitmap5_i[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_HGLM] = Bitmap5_i[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6_i[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6__FED] = Bitmap6_i[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_IJKN] = Bitmap6_i[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_HGLM] = Bitmap6_i[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7_i[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7__FED] = Bitmap7_i[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_IJKN] = Bitmap7_i[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_HGLM] = Bitmap7_i[`BIT_G] ? 2'd3 : 2'd1;
			end
			
			COM_2L: begin
				PinVoltage[`COM0] = 2'd2;						// COM0
				PinVoltage[`COM1] = 2'd2;						// COM1
				PinVoltage[`COM2] = 2'd0;						// COM2
				PinVoltage[`COM3] = 2'd2;						// COM3
				
				PinVoltage[`SEG0_ABCP] = Bitmap0_i[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0__FED] = Bitmap0_i[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_IJKN] = Bitmap0_i[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_HGLM] = Bitmap0_i[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1_i[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1__FED] = Bitmap1_i[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_IJKN] = Bitmap1_i[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_HGLM] = Bitmap1_i[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2_i[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2__FED] = Bitmap2_i[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_IJKN] = Bitmap2_i[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_HGLM] = Bitmap2_i[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3_i[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3__FED] = Bitmap3_i[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_IJKN] = Bitmap3_i[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_HGLM] = Bitmap3_i[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4_i[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4__FED] = Bitmap4_i[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_IJKN] = Bitmap4_i[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_HGLM] = Bitmap4_i[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5_i[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5__FED] = Bitmap5_i[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_IJKN] = Bitmap5_i[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_HGLM] = Bitmap5_i[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6_i[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6__FED] = Bitmap6_i[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_IJKN] = Bitmap6_i[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_HGLM] = Bitmap6_i[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7_i[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7__FED] = Bitmap7_i[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_IJKN] = Bitmap7_i[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_HGLM] = Bitmap7_i[`BIT_L] ? 2'd3 : 2'd1;
			end
			
			COM_3L: begin
				PinVoltage[`COM0] = 2'd2;						// COM0
				PinVoltage[`COM1] = 2'd2;						// COM1
				PinVoltage[`COM2] = 2'd2;						// COM2
				PinVoltage[`COM3] = 2'd0;						// COM3
				
				PinVoltage[`SEG0_ABCP] = Bitmap0_i[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0__FED] = Bitmap0_i[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_IJKN] = Bitmap0_i[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_HGLM] = Bitmap0_i[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1_i[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1__FED] = Bitmap1_i[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_IJKN] = Bitmap1_i[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_HGLM] = Bitmap1_i[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2_i[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2__FED] = Bitmap2_i[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_IJKN] = Bitmap2_i[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_HGLM] = Bitmap2_i[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3_i[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3__FED] = Bitmap3_i[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_IJKN] = Bitmap3_i[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_HGLM] = Bitmap3_i[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4_i[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4__FED] = Bitmap4_i[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_IJKN] = Bitmap4_i[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_HGLM] = Bitmap4_i[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5_i[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5__FED] = Bitmap5_i[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_IJKN] = Bitmap5_i[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_HGLM] = Bitmap5_i[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6_i[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6__FED] = Bitmap6_i[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_IJKN] = Bitmap6_i[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_HGLM] = Bitmap6_i[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7_i[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7__FED] = Bitmap7_i[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_IJKN] = Bitmap7_i[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_HGLM] = Bitmap7_i[`BIT_M] ? 2'd3 : 2'd1;
				
			end
			
			default: begin
				/*
				ComAnalog[0] = 2'dX;
				ComAnalog[1] = 2'dX;
				ComAnalog[2] = 2'dX;
				ComAnalog[3] = 2'dX;
				SegAnalog[0] = 2'dX;
				SegAnalog[1] = 2'dX;
				SegAnalog[2] = 2'dX;
				SegAnalog[3] = 2'dX;
				SegAnalog[4] = 2'dX;
				SegAnalog[5] = 2'dX;
				SegAnalog[6] = 2'dX;
				SegAnalog[7] = 2'dX;
				*/
			end
			
		endcase
	end
	
	// Assign outputs
	/*assign Pin_o[ 1] = Voltage[PinVoltage[1]];
	assign Pin_o[ 3] = Voltage[PinVoltage[3]];
	assign Pin_o[18] = Voltage[PinVoltage[18]];
	assign Pin_o[19] = Voltage[PinVoltage[19]];
	assign Pin_o[36] = Voltage[PinVoltage[36]];
	*/
	
	/*
	integer i;
	for(i=1; i<=36; i=i+1) begin
		assign Pin_o[i] = Voltage[PinVoltage[i]];
	end
	*/
	
	generate
		genvar i;
		for(i=1; i<=36; i=i+1) begin
			assign Pin_o[i] = Voltage[PinVoltage[i]];
		end
	endgenerate
	
	/*
	assign ComPWM_o[0] = 
	assign ComPWM_o[1] = Voltage[ComAnalog[1]];
	assign ComPWM_o[2] = Voltage[ComAnalog[2]];
	assign ComPWM_o[3] = Voltage[ComAnalog[3]];
	assign SegPWM_o[0] = Voltage[SegAnalog[0]];
	assign SegPWM_o[1] = Voltage[SegAnalog[1]];
	assign SegPWM_o[2] = Voltage[SegAnalog[2]];
	assign SegPWM_o[3] = Voltage[SegAnalog[3]];
	assign SegPWM_o[4] = Voltage[SegAnalog[4]];
	assign SegPWM_o[5] = Voltage[SegAnalog[5]];
	assign SegPWM_o[6] = Voltage[SegAnalog[6]];
	assign SegPWM_o[7] = Voltage[SegAnalog[7]];
	*/
	
endmodule
`default_nettype wire
