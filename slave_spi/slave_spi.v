// 240405

`default_nettype none

module SlaveSPI (
	input  wire Clock,
	input  wire Reset,
	
	input  wire CS_i,					// Chip select, active low
	input  wire SCK_i,					// Serial clock
	input  wire MOSI_i,					// Master Out, Slave In
	output wire MISO_o,					// Master In, Slave Out
	
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
	
	// 
	reg [2:0] BitsReceived;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			BitsReceived	<= 0;
			DataReceived_o	<= 0;
		end 
		
		else if(TransmissionStart) begin
			BitsReceived	<= 0;
		end
		
		else if(InputSampleRequest) begin
			DataReceived_o	<= {DataReceived_o[6:0], SyncMOSI};
			BitsReceived	<= BitsReceived + 1'b1;
			
			if(BitsReceived == 3'd7) begin
				Done_o		<= 1'b1;
			end
		end
		
		// if(BitsReceived == 3'd7) begin
			// BitsReceived	<= 0;
		// end
		
		Done_o 				<= 0;
	end

endmodule

`default_nettype wire
