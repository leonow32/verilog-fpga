`timescale 1ns/1ps  // time-unit, precision

`default_nettype none
module top_tb();

	parameter CLOCK_HZ     = 25_175_000;
	parameter BAUD         = 100000;
	parameter WIDTH_CHARS  = 80;			// 80 characters * 8 pixels wide  = 640 pixels total
	parameter HEIGHT_CHARS = 30;			// 30 characters * 16 pixels tall = 480 pixels total
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2.0 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	reg       TxRequest = 0;
	reg [7:0] TxData = 8'h00;
	wire      TxDone;
	wire      TxRxCommon;
	integer i;
	
	// Instantiate UART transmitter
	UartTx #(
		.CLOCK_HZ(CLOCK_HZ),
		.BAUD(BAUD)
	) UartTx_Inst(
		.Clock(Clock),
		.Reset(Reset),
		.Start_i(TxRequest),
		.Data_i(TxData),
		.Busy_o(),
		.Done_o(TxDone),
		.Tx_o(TxRxCommon)
	);
	
	// Task to send a byte via UART transmitter
	task UartSend(input [7:0] Data);
		begin
			$display("%t Transmitting: %d %s", $realtime, Data, Data);
			TxData    <= Data;
			TxRequest <= 1'b1;
			@(posedge Clock);
			TxData    <= 8'bxxxxxxxx;
			TxRequest <= 1'b0;
			@(posedge TxDone);
		end
	endtask
	
	// Instantiate device under test
	top #(
		.CLOCK_HZ(CLOCK_HZ),
		.BAUD(BAUD)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.UartRx_i(TxRxCommon),
		.HSync_o(),
		.VSync_o(),
		.Red_o(),
		.Green_o(),
		.Blue_o()
	);

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
		
		for(i=32; i<=159; i=i+1) begin
			UartSend(i);
		end
		
		UartSend("A");
		UartSend("B");
		UartSend("C");
		UartSend("D");
		UartSend(8'h01);
		UartSend(8'h02);
		UartSend(8'h03);
		UartSend("U");
		
		
		// Transmit image to the memory
		/*repeat(WIDTH_CHARS * HEIGHT_CHARS) begin
			// TransmitSPI(8'b01010101);
			// TransmitSPI(8'b10101010);
			
			// TransmitSPI(8'b11111111);
			// TransmitSPI(8'b11111111);
			
			TransmitUART(8'b11111111);
			TransmitUART(8'b00000000);
		end*/
		
		repeat(10) @(posedge Clock);
		
		// wait(DUT.VGA_inst.VCounter == 524 && DUT.VGA_inst.HCounter == 799);
		// wait(DUT.VGA_inst.VCounter == 500);
		
		$display("====== END ======");
		$finish;
	end
	
	// Some wires to have a look inside the memory
	wire [7:0] CharRAM_0000 = DUT.CharRAM_0.Memory[0];
	wire [7:0] CharRAM_0001 = DUT.CharRAM_0.Memory[1];
	wire [7:0] CharRAM_0002 = DUT.CharRAM_0.Memory[2];
	wire [7:0] CharRAM_1023 = DUT.CharRAM_0.Memory[1023];
	wire [7:0] CharRAM_1024 = DUT.CharRAM_1.Memory[0];
	wire [7:0] CharRAM_2047 = DUT.CharRAM_1.Memory[1023];
	wire [7:0] CharRAM_2048 = DUT.CharRAM_2.Memory[0];
	wire [7:0] CharRAM_2399 = DUT.CharRAM_2.Memory[351];
	
endmodule
`default_nettype wire
