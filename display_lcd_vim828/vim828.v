// 231109

`default_nettype none
module VIM828 #(
	parameter CLOCK_HZ      = 10_000_000,
	parameter CHANGE_COM_US = 1000
)(
	input wire Clock,
	input wire Reset,
	
	// Rightmost character = 0
	// Leftmost character  = 7
	// Segment order in each input = nmlkjihgfedcba
	input wire [13:0] Segments7_i,
	input wire [13:0] Segments6_i,
	input wire [13:0] Segments5_i,
	input wire [13:0] Segments4_i,
	input wire [13:0] Segments3_i,
	input wire [13:0] Segments2_i,
	input wire [13:0] Segments1_i,
	input wire [13:0] Segments0_i,
	
	input wire [ 7:0] DecimalPoints_i,
	
	// Connect this output to LCD pins
	// Each line needs a RC filter to smooth PWM signal
	// R = 4k7
	// C = 10n
	output wire [36:1] Pin_o
);
	
	// Join together segments data with decimal points
	wire [14:0] Bitmap7 = {DecimalPoints_i[7], Segments7_i};
	wire [14:0] Bitmap6 = {DecimalPoints_i[6], Segments6_i};
	wire [14:0] Bitmap5 = {DecimalPoints_i[5], Segments5_i};
	wire [14:0] Bitmap4 = {DecimalPoints_i[4], Segments4_i};
	wire [14:0] Bitmap3 = {DecimalPoints_i[3], Segments3_i};
	wire [14:0] Bitmap2 = {DecimalPoints_i[2], Segments2_i};
	wire [14:0] Bitmap1 = {DecimalPoints_i[1], Segments1_i};
	wire [14:0] Bitmap0 = {DecimalPoints_i[0], Segments0_i};
	
	// PWM generator to create 0, 1/3, 2/3 and 1 voltage levels
	wire [3:0] Voltage;
	VIM828_PWM VIM828_PWM_inst(
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
	
	// Increment of state variable
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) 
			State <= 0;
		else if(ChangeState)
			State <= State + 1'b1;
	end
	
	// A matrix of 36 elements that are 2-bit variables
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
				
				PinVoltage[`SEG0_ABCP] = Bitmap0[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0__FED] = 2'd2;
				PinVoltage[`SEG0_IJKN] = Bitmap0[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_HGLM] = Bitmap0[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1__FED] = 2'd2;
				PinVoltage[`SEG1_IJKN] = Bitmap1[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_HGLM] = Bitmap1[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2__FED] = 2'd2;
				PinVoltage[`SEG2_IJKN] = Bitmap2[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_HGLM] = Bitmap2[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3__FED] = 2'd2;
				PinVoltage[`SEG3_IJKN] = Bitmap3[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_HGLM] = Bitmap3[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4__FED] = 2'd2;
				PinVoltage[`SEG4_IJKN] = Bitmap4[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_HGLM] = Bitmap4[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5__FED] = 2'd2;
				PinVoltage[`SEG5_IJKN] = Bitmap5[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_HGLM] = Bitmap5[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6__FED] = 2'd2;
				PinVoltage[`SEG6_IJKN] = Bitmap6[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_HGLM] = Bitmap6[`BIT_H] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7[`BIT_A] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7__FED] = 2'd2;
				PinVoltage[`SEG7_IJKN] = Bitmap7[`BIT_I] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_HGLM] = Bitmap7[`BIT_H] ? 2'd0 : 2'd2;
			end
			
			COM_1H: begin
				PinVoltage[`COM0] = 2'd1;
				PinVoltage[`COM1] = 2'd3;
				PinVoltage[`COM2] = 2'd1;
				PinVoltage[`COM3] = 2'd1;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0__FED] = Bitmap0[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_IJKN] = Bitmap0[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_HGLM] = Bitmap0[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1__FED] = Bitmap1[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_IJKN] = Bitmap1[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_HGLM] = Bitmap1[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2__FED] = Bitmap2[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_IJKN] = Bitmap2[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_HGLM] = Bitmap2[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3__FED] = Bitmap3[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_IJKN] = Bitmap3[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_HGLM] = Bitmap3[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4__FED] = Bitmap4[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_IJKN] = Bitmap4[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_HGLM] = Bitmap4[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5__FED] = Bitmap5[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_IJKN] = Bitmap5[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_HGLM] = Bitmap5[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6__FED] = Bitmap6[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_IJKN] = Bitmap6[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_HGLM] = Bitmap6[`BIT_G] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7[`BIT_B] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7__FED] = Bitmap7[`BIT_F] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_IJKN] = Bitmap7[`BIT_J] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_HGLM] = Bitmap7[`BIT_G] ? 2'd0 : 2'd2;
			end
			
			COM_2H: begin
				PinVoltage[`COM0] = 2'd1;
				PinVoltage[`COM1] = 2'd1;
				PinVoltage[`COM2] = 2'd3;
				PinVoltage[`COM3] = 2'd1;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0__FED] = Bitmap0[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_IJKN] = Bitmap0[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_HGLM] = Bitmap0[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1__FED] = Bitmap1[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_IJKN] = Bitmap1[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_HGLM] = Bitmap1[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2__FED] = Bitmap2[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_IJKN] = Bitmap2[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_HGLM] = Bitmap2[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3__FED] = Bitmap3[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_IJKN] = Bitmap3[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_HGLM] = Bitmap3[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4__FED] = Bitmap4[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_IJKN] = Bitmap4[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_HGLM] = Bitmap4[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5__FED] = Bitmap5[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_IJKN] = Bitmap5[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_HGLM] = Bitmap5[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6__FED] = Bitmap6[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_IJKN] = Bitmap6[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_HGLM] = Bitmap6[`BIT_L] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7[`BIT_C] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7__FED] = Bitmap7[`BIT_E] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_IJKN] = Bitmap7[`BIT_K] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_HGLM] = Bitmap7[`BIT_L] ? 2'd0 : 2'd2;
			end
			
			COM_3H: begin
				PinVoltage[`COM0] = 2'd1;
				PinVoltage[`COM1] = 2'd1;
				PinVoltage[`COM2] = 2'd1;
				PinVoltage[`COM3] = 2'd3;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0__FED] = Bitmap0[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_IJKN] = Bitmap0[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG0_HGLM] = Bitmap0[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1__FED] = Bitmap1[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_IJKN] = Bitmap1[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG1_HGLM] = Bitmap1[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2__FED] = Bitmap2[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_IJKN] = Bitmap2[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG2_HGLM] = Bitmap2[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3__FED] = Bitmap3[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_IJKN] = Bitmap3[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG3_HGLM] = Bitmap3[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4__FED] = Bitmap4[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_IJKN] = Bitmap4[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG4_HGLM] = Bitmap4[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5__FED] = Bitmap5[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_IJKN] = Bitmap5[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG5_HGLM] = Bitmap5[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6__FED] = Bitmap6[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_IJKN] = Bitmap6[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG6_HGLM] = Bitmap6[`BIT_M] ? 2'd0 : 2'd2;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7[`BIT_P] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7__FED] = Bitmap7[`BIT_D] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_IJKN] = Bitmap7[`BIT_N] ? 2'd0 : 2'd2;
				PinVoltage[`SEG7_HGLM] = Bitmap7[`BIT_M] ? 2'd0 : 2'd2;
			end
			
			COM_0L: begin
				PinVoltage[`COM0] = 2'd0;
				PinVoltage[`COM1] = 2'd2;
				PinVoltage[`COM2] = 2'd2;
				PinVoltage[`COM3] = 2'd2;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0__FED] = 2'd1;
				PinVoltage[`SEG0_IJKN] = Bitmap0[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_HGLM] = Bitmap0[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1__FED] = 2'd1;
				PinVoltage[`SEG1_IJKN] = Bitmap1[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_HGLM] = Bitmap1[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2__FED] = 2'd1;
				PinVoltage[`SEG2_IJKN] = Bitmap2[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_HGLM] = Bitmap2[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3__FED] = 2'd1;
				PinVoltage[`SEG3_IJKN] = Bitmap3[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_HGLM] = Bitmap3[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4__FED] = 2'd1;
				PinVoltage[`SEG4_IJKN] = Bitmap4[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_HGLM] = Bitmap4[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5__FED] = 2'd1;
				PinVoltage[`SEG5_IJKN] = Bitmap5[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_HGLM] = Bitmap5[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6__FED] = 2'd1;
				PinVoltage[`SEG6_IJKN] = Bitmap6[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_HGLM] = Bitmap6[`BIT_H] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7[`BIT_A] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7__FED] = 2'd1;
				PinVoltage[`SEG7_IJKN] = Bitmap7[`BIT_I] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_HGLM] = Bitmap7[`BIT_H] ? 2'd3 : 2'd1;
				
			end
			
			COM_1L: begin
				PinVoltage[`COM0] = 2'd2;
				PinVoltage[`COM1] = 2'd0;
				PinVoltage[`COM2] = 2'd2;
				PinVoltage[`COM3] = 2'd2;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0__FED] = Bitmap0[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_IJKN] = Bitmap0[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_HGLM] = Bitmap0[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1__FED] = Bitmap1[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_IJKN] = Bitmap1[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_HGLM] = Bitmap1[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2__FED] = Bitmap2[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_IJKN] = Bitmap2[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_HGLM] = Bitmap2[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3__FED] = Bitmap3[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_IJKN] = Bitmap3[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_HGLM] = Bitmap3[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4__FED] = Bitmap4[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_IJKN] = Bitmap4[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_HGLM] = Bitmap4[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5__FED] = Bitmap5[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_IJKN] = Bitmap5[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_HGLM] = Bitmap5[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6__FED] = Bitmap6[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_IJKN] = Bitmap6[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_HGLM] = Bitmap6[`BIT_G] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7[`BIT_B] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7__FED] = Bitmap7[`BIT_F] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_IJKN] = Bitmap7[`BIT_J] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_HGLM] = Bitmap7[`BIT_G] ? 2'd3 : 2'd1;
			end
			
			COM_2L: begin
				PinVoltage[`COM0] = 2'd2;
				PinVoltage[`COM1] = 2'd2;
				PinVoltage[`COM2] = 2'd0;
				PinVoltage[`COM3] = 2'd2;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0__FED] = Bitmap0[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_IJKN] = Bitmap0[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_HGLM] = Bitmap0[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1__FED] = Bitmap1[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_IJKN] = Bitmap1[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_HGLM] = Bitmap1[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2__FED] = Bitmap2[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_IJKN] = Bitmap2[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_HGLM] = Bitmap2[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3__FED] = Bitmap3[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_IJKN] = Bitmap3[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_HGLM] = Bitmap3[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4__FED] = Bitmap4[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_IJKN] = Bitmap4[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_HGLM] = Bitmap4[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5__FED] = Bitmap5[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_IJKN] = Bitmap5[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_HGLM] = Bitmap5[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6__FED] = Bitmap6[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_IJKN] = Bitmap6[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_HGLM] = Bitmap6[`BIT_L] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7[`BIT_C] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7__FED] = Bitmap7[`BIT_E] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_IJKN] = Bitmap7[`BIT_K] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_HGLM] = Bitmap7[`BIT_L] ? 2'd3 : 2'd1;
			end
			
			COM_3L: begin
				PinVoltage[`COM0] = 2'd2;
				PinVoltage[`COM1] = 2'd2;
				PinVoltage[`COM2] = 2'd2;
				PinVoltage[`COM3] = 2'd0;
				
				PinVoltage[`SEG0_ABCP] = Bitmap0[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0__FED] = Bitmap0[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_IJKN] = Bitmap0[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG0_HGLM] = Bitmap0[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG1_ABCP] = Bitmap1[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1__FED] = Bitmap1[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_IJKN] = Bitmap1[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG1_HGLM] = Bitmap1[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG2_ABCP] = Bitmap2[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2__FED] = Bitmap2[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_IJKN] = Bitmap2[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG2_HGLM] = Bitmap2[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG3_ABCP] = Bitmap3[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3__FED] = Bitmap3[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_IJKN] = Bitmap3[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG3_HGLM] = Bitmap3[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG4_ABCP] = Bitmap4[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4__FED] = Bitmap4[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_IJKN] = Bitmap4[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG4_HGLM] = Bitmap4[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG5_ABCP] = Bitmap5[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5__FED] = Bitmap5[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_IJKN] = Bitmap5[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG5_HGLM] = Bitmap5[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG6_ABCP] = Bitmap6[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6__FED] = Bitmap6[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_IJKN] = Bitmap6[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG6_HGLM] = Bitmap6[`BIT_M] ? 2'd3 : 2'd1;
				
				PinVoltage[`SEG7_ABCP] = Bitmap7[`BIT_P] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7__FED] = Bitmap7[`BIT_D] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_IJKN] = Bitmap7[`BIT_N] ? 2'd3 : 2'd1;
				PinVoltage[`SEG7_HGLM] = Bitmap7[`BIT_M] ? 2'd3 : 2'd1;
				
			end
			
		endcase
	end
	
	// Assign outputs
	generate
		genvar i;
		for(i=1; i<=36; i=i+1) begin
			assign Pin_o[i] = Voltage[PinVoltage[i]];
		end
	endgenerate
	
endmodule
`default_nettype wire
