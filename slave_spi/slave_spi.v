// 240405

`default_nettype none

module SlaveSPI (
	input  wire Clock,
	input  wire Reset,
	
	input  wire CS_i,					// Chip select, active low
	input  wire SCK_i,					// Serial clock
	input  wire MOSI_i,					// Master Out, Slave In
	output reg  MISO_o,					// Master In, Slave Out
	//output wire MISO_o,					// Master In, Slave Out
	//output wire MISO_Enable_o,			// 1 - MISO active, 0 - MISO tristated
	
	input  wire [7:0] DataToSend_i,		// Byte to be sent via MISO
	output reg  [7:0] DataReceived_o,	// Byte received from MOSI
	output reg  Done_o					// High strobe after transfer of a byte is done
);
	
	// Syncronize CS, SCK and MOSI with clock domain
	wire SyncCS;
	wire SyncSCK;
	wire SyncMOSI;
	
	Synchronizer #(
		.WIDTH(3)
	) Synchronizer_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Async_i({CS_i, SCK_i, MOSI_i}),
		.Sync_o({SyncCS, SyncSCK, SyncMOSI})
	);
	
	// Recognize ongoing transmission
	wire TransmissionInProgress = !SyncCS;
	
	// Recognize the beginning of the transmission
	wire TransmissionStart;
	
	EdgeDetector EdgeDetectorCS(
		.Clock(Clock),
		.Reset(Reset),
		.Signal_i(SyncCS),
		.RisingEdge_o(),
		.FallingEdge_o(TransmissionStart)
	);
	
	// Recognize clock events
	wire InputSampleRequest;
	wire OutputShiftRequest;
	
	EdgeDetector EdgeDetectorSCK(
		.Clock(Clock),
		.Reset(Reset),
		.Signal_i(SyncSCK),
		.RisingEdge_o(InputSampleRequest),
		.FallingEdge_o(OutputShiftRequest)
	);
	
	// Receiver
	reg [2:0] BitCounter;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			BitCounter		<= 0;
			DataReceived_o	<= 0;
		end 
		
		else if(TransmissionStart) begin
			BitCounter		<= 0;
		end
		
		else if(TransmissionInProgress && InputSampleRequest) begin
			BitCounter		<= BitCounter + 1'b1;
			DataReceived_o	<= {DataReceived_o[6:0], SyncMOSI};
		end
	end
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			Done_o <= 0;
		else if(InputSampleRequest && BitCounter == 3'd7)
			Done_o <= 1;
		else
			Done_o <= 0;
	end
	
	// Transmiter
	reg [7:0] DataToSend;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			DataToSend <= 0;
		end 
		
		else if(TransmissionStart || (OutputShiftRequest && BitCounter == 3'd0)) begin
			DataToSend <= DataToSend_i;
		end
		
		else if(OutputShiftRequest) begin
			DataToSend <= DataToSend << 1;
		end
	end
	
	//assign MISO_o = TransmissionInProgress ? DataToSend[7] : 1'b0;
	
	always @(*) begin
		if(TransmissionInProgress)
			MISO_o = DataToSend[7];
		else
			MISO_o = 1'bZ;
	end
	
	// assign MISO_o = DataToSend[7];
	// assign MISO_Enable_o = TransmissionInProgress;

endmodule

`default_nettype wire
