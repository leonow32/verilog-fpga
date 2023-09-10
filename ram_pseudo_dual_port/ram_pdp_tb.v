`timescale 1ns/1ns

`default_nettype none
module PseudoDualPortRAM_tb();

	parameter CLOCK_READ_HZ	            = 10_000_000;
	parameter real HALF_PERIOD_READ_NS  = 1_000_000_000.0 / (2 * CLOCK_READ_HZ);
	
	parameter CLOCK_WRITE_HZ	        = 15_000_000;
	parameter real HALF_PERIOD_WRITE_NS = 1_000_000_000.0 / (2 * CLOCK_WRITE_HZ);
	
	// Clock generator for read port
	reg ClockRead = 1'b1;
	always begin
		#HALF_PERIOD_READ_NS;
		ClockRead = !ClockRead;
	end
	
	// Clock generator for write port
	reg ClockWrite = 1'b1;
	always begin
		#HALF_PERIOD_WRITE_NS;
		ClockWrite = !ClockWrite;
	end
	
	// Variables
	reg        Reset       = 1'b0;
	reg        ReadEnable  = 1'b0;
	reg        WriteEnable = 1'b0;
	reg  [3:0] AddressRead;
	reg  [3:0] AddressWrite;
	reg  [7:0] DataIn;
	wire [7:0] DataOut;
	integer    r;
	integer    w;
	
	// Instantiate device under test
	PseudoDualPortRAM #(
		.ADDRESS_WIDTH(4),
		.DATA_WIDTH(8)
	) DUT(
		.ClockRead(ClockRead),
		.ClockWrite(ClockWrite),
		.Reset(Reset),
		.ReadEnable_i(ReadEnable),
		.WriteEnable_i(WriteEnable),
		.AddressRead_i(AddressRead),
		.AddressWrite_i(AddressWrite),
		.Data_i(DataIn),
		.Data_o(DataOut)
	);
	
	// Variable dump
	initial begin
		$dumpfile("ram_pdp.vcd");
		$dumpvars(0, PseudoDualPortRAM_tb);
		
		// Dump all data from the memory
		for(r=0; r<=15; r=r+1) begin
			$dumpvars(2, DUT.Memory[r]);
		end
	end

	// Test sequence for write
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");
		$display("        Time AddressWrite DataIn AddressRead DataOut");
		$monitor("%t            %H     %H           %H      %H", 
			$realtime, 
			AddressWrite, 
			DataIn,
			AddressRead,
			DataOut
		);
		
		@(posedge ClockWrite);
		Reset <= 1'b1;
		@(posedge ClockWrite);
		
		// Write some data
		for(w=0; w<=15; w=w+1) begin
			WriteData(w, $urandom_range(8'h00, 8'hFF));
		end
		WriteEnd();
	end
	
	// Test sequence for read
	initial begin
		repeat(5) @(posedge ClockRead);
		
		// Read the data
		ReadEnable <= 1'b1;
		for(r=0; r<=15; r=r+1) begin
			AddressRead <= r;
			@(posedge ClockRead);
		end
		
		AddressRead <= 4'dX;
		ReadEnable  <= 1'b0;
		
		// Pause
		repeat(2) @(posedge ClockRead);
		
		$display("===== END =====");
		$finish;
	end
	
	task WriteData(input [3:0] Adr, input [7:0] Dat); 
		begin
			AddressWrite <= Adr;
			DataIn       <= Dat;
			WriteEnable  <= 1'b1;
			@(posedge ClockWrite);
		end
	endtask
	
	task WriteEnd(); 
		begin
			AddressWrite <= 4'dX;
			DataIn       <= 8'dX;
			WriteEnable  <= 1'b0;
			@(posedge ClockWrite);
		end
	endtask

endmodule
`default_nettype wire
