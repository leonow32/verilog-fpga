`timescale 1ns/1ns  // time-unit, precision

`default_nettype none
module RAM_tb();

	parameter CLOCK_HZ	= 10_000_000;
	parameter HALF_PERIOD_NS = 1_000_000_000 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS Clock = !Clock;
	end
	
	// Variables
	reg        Reset       = 1'b0;
	reg        ReadEnable  = 1'b0;
	reg        WriteEnable = 1'b0;
	reg  [3:0] Address;
	reg  [7:0] DataIn      = 8'hX;
	wire [7:0] DataOut;
	
	// Instantiate device under test
	RAM #(
		.ADDRESS_WIDTH(4),
		.DATA_WIDTH(8)//,
		//.MEMORY_FILE("data.mem")
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadEnable),
		.WriteEnable_i(WriteEnable),
		.Address_i(Address),
		.Data_i(DataIn),
		.Data_o(DataOut)
	);
	
	// Variable dump
	initial begin
		$dumpfile("ram.vcd");
		$dumpvars(0, RAM_tb);
	end

	// Test sequence
	integer i;
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");
		$display("        Time Address DataIn DataOut");
		$monitor("%t       %H   %H    %H", 
			$realtime, 
			Address, 
			DataIn,
			DataOut
		);
		
		@(posedge Clock);
		Reset <= 1'b1;
		
		// Pause
		@(posedge Clock);
		
		// Save AA to 0A
		Address     <= 8'h0A;
		DataIn      <= 8'hAA;
		WriteEnable <= 1'b1;
		@(posedge Clock);
		
		// Save 33 to 03
		Address     <= 8'h03;
		DataIn      <= 8'h33;
		WriteEnable <= 1'b1;
		@(posedge Clock);
		
		// Deactivate write
		Address     <= 8'hX;
		DataIn      <= 8'hX;
		WriteEnable <= 1'b0;
		@(posedge Clock);
		
		// Fast read
		ReadEnable <= 1'b1;
		for(i=0; i<=16; i=i+1) begin
			Address <= i;
			@(posedge Clock);
		end
		
		ReadEnable <= 1'b0;
		
		// Pause
		repeat(2) @(posedge Clock);
		
		$display("===== END =====");
		$finish;
	end

endmodule
`default_nettype wire