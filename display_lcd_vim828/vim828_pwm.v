// 231031

`default_nettype none
module VIM828_PWM(
	input wire 	Clock,
	input wire 	Reset,
	output wire	Voltage0_o,	// Output 0% duty cycle
	output wire	Voltage1_o,	// Output 33% duty cycle
	output wire	Voltage2_o,	// Output 66% duty cycle
	output wire	Voltage3_o	// Output 100% duty cycle
);
	
	// Simple State machine
	reg [1:0] State /* synthesis syn_state_machine = 1 */;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			State <= 2'b00;
		else if(State == 2'b00)
			State <= 2'b01;
		else if(State == 2'b01)
			State <= 2'b11;
		else
			State <= 2'b00;
	end
	
	// Assign outputs
	assign Voltage0_o = 1'b0;
	assign Voltage1_o = State[1];
	assign Voltage2_o = State[0];
	assign Voltage3_o = 1'b1;

endmodule

`default_nettype wire
