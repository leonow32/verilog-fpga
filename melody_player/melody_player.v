// 230704

`default_nettype none
module MelodyPlayer #(
	parameter  CLOCK_HZ = 10_000_000
)(
	input wire Clock,
	input wire Reset,
	input wire Play_i,
	input wire Stop_i,
	output wire SoundWave_o
);
	
	// Variables
	reg [15:0] Duration_ms;
	reg [15:0] HalfPeriod_us;
	reg Request;
	wire SoundGeneratorBusy;
	wire SoundGeneratorDone;
	
	// Melody memory
	reg        ReadEnable;
	reg  [7:0] Address;
	wire [7:0] Data;
	ROM MusicMemory(
		.Clock(Clock),
		.Reset(Reset),
		.ReadEnable_i(ReadEnable),
		.Address_i(Address),
		.Data_o(Data)
	);
	
	// State machine
	reg [2:0] State;
	localparam IDLE				= 3'd0;
	localparam DUMMY            = 3'd1;
	localparam READ_DURATION_H	= 3'd2;
	localparam READ_DURATION_L	= 3'd3;
	localparam READ_HPERIOD_H	= 3'd4;
	localparam READ_HPERIOD_L	= 3'd5;
	localparam PLAYING			= 3'd6;
	
	// State machine to read data from memory
	// and push it to the sound generator
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			State         <= IDLE;
			Request       <= 0;
			Duration_ms   <= 0;
			HalfPeriod_us <= 0;
			ReadEnable    <= 0;
			Address       <= 0;
		end else begin
			case(State)
				IDLE: begin
					if(Play_i) begin
						Address    <= 0;
						ReadEnable <= 1'b1;
						State      <= DUMMY;
					end
				end
				
				DUMMY: begin
					Address           <= Address + 1'b1;
					State             <= READ_DURATION_H;
				end
				
				READ_DURATION_H: begin
					Duration_ms[15:8] <= Data;
					Address           <= Address + 1'b1;
					State             <= READ_DURATION_L;
				end
				
				READ_DURATION_L: begin
					Duration_ms[7:0]  <= Data;
					Address           <= Address + 1'b1;
					State             <= READ_HPERIOD_H;
				end
				
				READ_HPERIOD_H: begin
					HalfPeriod_us[15:8] <= Data;
					Address             <= Address + 1'b1;
					State               <= READ_HPERIOD_L;
				end
				
				READ_HPERIOD_L: begin
					HalfPeriod_us[7:0]  <= Data;
					Address             <= Address + 1'b1;
					ReadEnable          <= 1'b0;
					Request             <= 1'b1;
					State               <= PLAYING;
				end
				
				PLAYING: begin
					Request <= 1'b0;
					if(Duration_ms == 16'd0)
						State      <= IDLE;
					else if(SoundGeneratorDone) begin
						ReadEnable <= 1'b1;
						State      <= READ_DURATION_H;
					end
					
					// TODO Stop
				end
			endcase
		end
	end
	
	// Instantiate SoundGenerator
	SoundGenerator #(
		.CLOCK_HZ(CLOCK_HZ)
	) SoundGenerator_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Request_i(Request),
		.Duration_ms_i(Duration_ms),
		.HalfPeriod_us_i(HalfPeriod_us),
		.SoundWave_o(SoundWave_o),
		.Busy_o(SoundGeneratorBusy),
		.Done_o(SoundGeneratorDone)
	);
	
endmodule
`default_nettype wire
