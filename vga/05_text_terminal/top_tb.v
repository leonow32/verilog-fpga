`timescale 1ns/1ps  // time-unit, precision

`default_nettype none
module top_tb();

	parameter CLOCK_HZ     = 25_175_000;
	parameter BAUD         = 10_000_000;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2.0 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg       Reset = 0;
	reg       TxRequest = 0;
	reg [7:0] TxData = 8'h00;
	wire      TxDone;
	wire      TxRxCommon;
	integer   i;
	
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
			//$display("%t Transmitting: %d %s", $realtime, Data, Data);
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
		
		UartSend("A");
		UartSend("B");
		UartSend("C");
		UartSend(8'b1_100_0_001);	// Color
		UartSend("D");
		UartSend("E");
		UartSend(8'h7F);			// Backspace
		UartSend("F");
		UartSend("G");
		UartSend(8'h0D);			// New line
		UartSend(8'h01);
		UartSend(8'h0D);			// New line
		UartSend(8'h01);
		UartSend(8'h0D);			// New line
		UartSend(8'h01);
		UartSend("0");
		UartSend("1");
		UartSend("2");
		UartSend("3");
		UartSend("4");
		UartSend("5");
		UartSend("6");
		UartSend("7");
		UartSend("8");
		UartSend("9");
		UartSend("0");
		UartSend("1");
		UartSend("2");
		UartSend("3");
		UartSend("4");
		UartSend("5");
		UartSend("6");
		UartSend("7");
		UartSend("8");
		UartSend("9");
		
		// repeat(40) begin
			// UartSend(8'b1_101_0_000);	// Color
			// UartSend(8'h01);
			// UartSend(8'b1_011_0_000);	// Color
			// UartSend(8'h01);
		// end
		
		repeat(10) @(posedge Clock);
		
		wait(DUT.VGA_inst.VCounter == 524 && DUT.VGA_inst.HCounter == 799);
		wait(DUT.VGA_inst.VCounter == 500);
		
		$display("====== END ======");
		$finish;
	end
	
	// Some wires to have a look inside the memory	
	wire [7:0] ImageRAM_0000 = DUT.Memory_inst.ImageRAM_0.Memory[0];
	wire [7:0] ImageRAM_0001 = DUT.Memory_inst.ImageRAM_0.Memory[1];
	wire [7:0] ImageRAM_0002 = DUT.Memory_inst.ImageRAM_0.Memory[2];
	wire [7:0] ImageRAM_0003 = DUT.Memory_inst.ImageRAM_0.Memory[3];
	wire [7:0] ImageRAM_0004 = DUT.Memory_inst.ImageRAM_0.Memory[4];
	wire [7:0] ImageRAM_0005 = DUT.Memory_inst.ImageRAM_0.Memory[5];
	wire [7:0] ImageRAM_0006 = DUT.Memory_inst.ImageRAM_0.Memory[6];
	wire [7:0] ImageRAM_0007 = DUT.Memory_inst.ImageRAM_0.Memory[7];
	wire [7:0] ImageRAM_0008 = DUT.Memory_inst.ImageRAM_0.Memory[8];
	wire [7:0] ImageRAM_0009 = DUT.Memory_inst.ImageRAM_0.Memory[9];
	wire [7:0] ImageRAM_0510 = DUT.Memory_inst.ImageRAM_0.Memory[510];
	wire [7:0] ImageRAM_0511 = DUT.Memory_inst.ImageRAM_0.Memory[511];
	wire [7:0] ImageRAM_0512 = DUT.Memory_inst.ImageRAM_0.Memory[512];
	wire [7:0] ImageRAM_0513 = DUT.Memory_inst.ImageRAM_0.Memory[513];
	wire [7:0] FontROM_0016 = DUT.Memory_inst.FontROM.Memory[16];
	wire [7:0] FontROM_0017 = DUT.Memory_inst.FontROM.Memory[17];
	wire [7:0] FontROM_0018 = DUT.Memory_inst.FontROM.Memory[18];
	
endmodule
`default_nettype wire
