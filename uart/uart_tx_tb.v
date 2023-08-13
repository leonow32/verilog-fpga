`timescale 1ns/1ns  // time-unit, precision

`default_nettype none
module UART_TX_tb();

	parameter CLOCK_HZ	          = 1_000_000;
	parameter real HALF_PERIOD_NS = 1_000_000_000.0 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	// Message to send
	reg [7:0] Memory [0:7];
	initial begin
		Memory[0] = "H";
		Memory[1] = "e";
		Memory[2] = "l";
		Memory[3] = "l";
		Memory[4] = "o";
		Memory[5] = 8'd0;
		Memory[6] = 8'd0;
		Memory[7] = 8'd0;
	end
	
	// Variables
	wire Busy;
	wire Done;
	reg Reset = 1'b0;
	reg Run   = 1'b0;
	reg [7:0] DataToSend;
	
	reg [2:0] Pointer;	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Pointer <= 0;
		end else if(Run || Done) begin
			Pointer <= Pointer + 1'b1;
		end else if(!Busy) begin
			Pointer <= 0;
		end
	end
	
	wire Request = Run || (Done && (Memory[Pointer] != 8'd0));
	
	// Instantiate device under test
	UART_TX #(
		.CLOCK_HZ(CLOCK_HZ),
		.BAUD(100_000)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Start_i(Request),
		.Data_i(Memory[Pointer]),
		.Busy_o(Busy),
		.Done_o(Done),
		.Tx_o()
	);
	
	// Variable dump
	initial begin
		$dumpfile("uart_tx.vcd");
		$dumpvars(0, UART_TX_tb);
	end

	// Test sequence
	integer i;
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");
		$display("TICKS = %9d", DUT.StrobeGeneratorTicks_inst.TICKS);
		// $display("WIDTH = %9d", DUT.WIDTH);
		
		@(posedge Clock);
		Reset <= 1'b1;
		
		repeat(10) @(posedge Clock);
		Run <= 1'b1;
		@(posedge Clock);
		Run <= 1'b0;
		
		repeat(800) @(posedge Clock);
		
		/*
		repeat(10) @(posedge Clock);
		Start      <= 1'b1;
//		DataToSend <= 8'b10101010;
//		DataToSend <= 8'b01010101;
		DataToSend <= 8'b11110000;
		@(posedge Clock);
		Start      <= 1'b0;
		DataToSend <= 8'bX;
		
		
		// Pause
		@(negedge DUT.Done_o);
		//@(posedge Clock);
		Start      <= 1'b1;
//		DataToSend <= 8'b10101010;
//		DataToSend <= 8'b01010101;
//		DataToSend <= 8'b11110000;
//		DataToSend <= 8'b00001111;
		DataToSend <= 8'b00110001;
		@(posedge Clock);
		Start      <= 1'b0;
		DataToSend <= 8'bX;
		
		@(negedge DUT.Done_o);
		repeat(100) @(posedge Clock);
		*/
		
		$display("====== END ======");
		$finish;
	end

endmodule
`default_nettype wire