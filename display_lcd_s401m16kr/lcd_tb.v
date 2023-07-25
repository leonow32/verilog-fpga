// 230419

`timescale 1ns/1ns	// time-unit, precision
`default_nettype none

module LCD_tb();
	
	parameter CLOCK_HZ	= 1_000_000;
	parameter HALF_PERIOD_NS = 1_000_000_000 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	reg        Reset    = 1'b0;
	reg  [7:0] Digit3_r = 8'b00000000;
	reg  [7:0] Digit2_r = 8'b00000000;
	reg  [7:0] Digit1_r = 8'b00010000;
	reg  [7:0] Digit0_r = 8'b00000000;
	wire [3:0] ComPWM_w;
	wire [7:0] SegPWM_w;
	
	// Instantiate device under test
	LCD #(
		.CLOCK_HZ(CLOCK_HZ),
		.CHANGE_COM_US(50)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Digit3_i(Digit3_r),
		.Digit2_i(Digit2_r),
		.Digit1_i(Digit1_r),
		.Digit0_i(Digit0_r),
		.ComPWM_o(ComPWM_w),
		.SegPWM_o(SegPWM_w)
	);
	
	initial begin
		$dumpfile("lcd.vcd");
		$dumpvars(0, LCD_tb);
		$dumpvars(2, DUT.ComAnalog_r[0]);
		$dumpvars(2, DUT.ComAnalog_r[1]);
		$dumpvars(2, DUT.ComAnalog_r[2]);
		$dumpvars(2, DUT.ComAnalog_r[3]);
		$dumpvars(2, DUT.SegAnalog_r[0]);
		$dumpvars(2, DUT.SegAnalog_r[1]);
		$dumpvars(2, DUT.SegAnalog_r[2]);
		$dumpvars(2, DUT.SegAnalog_r[3]);
		$dumpvars(2, DUT.SegAnalog_r[4]);
		$dumpvars(2, DUT.SegAnalog_r[5]);
		$dumpvars(2, DUT.SegAnalog_r[6]);
		$dumpvars(2, DUT.SegAnalog_r[7]);
	end

	initial begin
		$timeformat(-6, 3, "us", 10);
		$display("===== START =====");
		$display("CLOCK_HZ = %9d", CLOCK_HZ);

		#1 Reset = 1'b1;

		$display("      time C0 C1 C2 C3 S0 S1 S2 S3 S4 S5 S6 S7");	
		$monitor("%t  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d  %d", 
				$realtime, 
				DUT.ComAnalog_r[0],
				DUT.ComAnalog_r[1],
				DUT.ComAnalog_r[2],
				DUT.ComAnalog_r[3],
				DUT.SegAnalog_r[0],
				DUT.SegAnalog_r[1],
				DUT.SegAnalog_r[2],
				DUT.SegAnalog_r[3],
				DUT.SegAnalog_r[4],
				DUT.SegAnalog_r[5],
				DUT.SegAnalog_r[6],
				DUT.SegAnalog_r[7],
			);

		repeat(8) begin
			@(posedge DUT.ChangeState_w);
		end
		
		//@(negedge DUT.ChangeState_w);
		
		#1 $display("===== END =====");
		#1 $finish;
	end

endmodule
`default_nettype wire
