// 230419

`default_nettype none
module LCD_PWM(
	input wire 	Clock,
	input wire 	Reset,
	output wire	Voltage0_o,	// Output 0% duty cycle
	output wire	Voltage1_o,	// Output 33% duty cycle
	output wire	Voltage2_o,	// Output 66% duty cycle
	output wire	Voltage3_o	// Output 100% duty cycle
);
	
	// Simple State_r machine
	reg [1:0] State_r /* synthesis syn_state_machine = 1 */;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			State_r <= 2'b00;
		else if(State_r == 2'b00)
			State_r <= 2'b01;
		else if(State_r == 2'b01)
			State_r <= 2'b11;
		else
			State_r <= 2'b00;
	end
	
	// Assign outputs
	assign Voltage0_o = 1'b0;
	assign Voltage1_o = State_r[1];
	assign Voltage2_o = State_r[0];
	assign Voltage3_o = 1'b1;

endmodule

`default_nettype wire