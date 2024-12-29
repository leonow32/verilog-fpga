`timescale 1ns/1ps  // time-unit, precision

`default_nettype none
module top_tb();

	parameter CLOCK_HZ  = 25_175_000;
	parameter SPI_DELAY = 40;
	parameter WIDTH     = 214;
	parameter HEIGHT    = 160;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2.0 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	reg CS    = 1;
	reg SCK   = 0;
	reg MOSI  = 0;
	
	// Instantiate device under test
	top DUT(
		.Clock(Clock),
		.Reset(Reset),
		.CS_i(CS),
		.SCK_i(SCK),
		.MOSI_i(MOSI),
		.DC_i(1'b1),
		.HSync_o(),
		.VSync_o(),
		.Red_o(),
		.Green_o(),
		.Blue_o()
	);
	
	// Task to send a byte from master to slave
	task TransmitSPI(input [7:0] Data);
		integer i;
		begin
			//$display("%t Transmitting: %H %b", $realtime, Data, Data);
			for(i=7; i>=0; i=i-1) begin
				SCK = 0;
				MOSI = Data[i];
				#SPI_DELAY;	
				SCK = 1;
				#SPI_DELAY;
			end
		end
	endtask

	// Variable dump
	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, top_tb);
	end

	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");

		@(posedge Clock);
		Reset <= 1;
		
		repeat(10) @(posedge Clock);
		
		// Transmit image to the memory
		CS = 0;
		repeat(WIDTH * HEIGHT / 16) begin
			// TransmitSPI(8'b01010101);
			// TransmitSPI(8'b10101010);
			
			// TransmitSPI(8'b11111111);
			// TransmitSPI(8'b11111111);
			
			TransmitSPI(8'b11111111);
			TransmitSPI(8'b00000000);
		end
		CS = 1;
		
		repeat(10) @(posedge Clock);
		
		wait(DUT.VGA_inst.VCounter == 524 && DUT.VGA_inst.HCounter == 799);
		wait(DUT.VGA_inst.VCounter == 500);
		
		$display("====== END ======");
		$finish;
	end
	
	// Some wires to have a look inside the memory
	wire [7:0] RAM_0000 = DUT.BitmapRAM_0.Memory[0];
	wire [7:0] RAM_0001 = DUT.BitmapRAM_0.Memory[1023];
	wire [7:0] RAM_1024 = DUT.BitmapRAM_1.Memory[0];
	wire [7:0] RAM_2047 = DUT.BitmapRAM_1.Memory[1023];
	wire [7:0] RAM_2048 = DUT.BitmapRAM_2.Memory[0];
	wire [7:0] RAM_3071	= DUT.BitmapRAM_2.Memory[1023];
	wire [7:0] RAM_3072 = DUT.BitmapRAM_3.Memory[0];
	wire [7:0] RAM_4095	= DUT.BitmapRAM_3.Memory[1023];
	wire [7:0] RAM_4096 = DUT.BitmapRAM_4.Memory[0];
	wire [7:0] RAM_4079	= DUT.BitmapRAM_4.Memory[183];
	
endmodule
`default_nettype wire
