// 230329

module DisplayMultiplex #(
	parameter CLOCK_HZ			= 10_000_000,
	parameter SWITCH_PERIOD_US	= 1000,
	parameter DIGITS			= 8
)(
	input					Clock,
	input					Reset,
	input	[DIGITS*4-1:0]	Data,
	input	[  DIGITS-1:0]	DecimalPoints,
	output	[  DIGITS-1:0]	Cathodes,
	output	[         7:0]	Segments
);
	
	// Blank leading zeros
	wire [DIGITS-1:0] Visible;
	generate
		genvar i;
		for(i=0; i<DIGITS; i=i+1) begin
			case(i)
				0:			assign Visible[i] = 1'b1;
				DIGITS-1:	assign Visible[i] = |Data[i*4+3:i*4];
				default:	assign Visible[i] = |Data[i*4+3:i*4] || Visible[i+1];
			endcase
		end
	endgenerate
	
	// Strobe signal to change active cathode and actually displayed digit
	wire SwitchCathode;
	StrobeGenerator #(
		.CLOCK_HZ(CLOCK_HZ),
		.PERIOD_US(SWITCH_PERIOD_US)
	) StrobeGenerator0(
		.Clock(Clock),
		.Reset(Reset),
		.Enable_i(1'b1),
		.Strobe_o(SwitchCathode)
	);
	
	// Change cathode
	localparam CNT_WIDTH = $clog2(DIGITS);
	reg [CNT_WIDTH-1:0] Selector;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) 
			Selector <= 0;
		else if(SwitchCathode) begin
			if(Selector == DIGITS - 1)
				Selector <= 0;
			else
				Selector <= Selector + 1'b1; 
		end
	end
	
	// Select one of cathodes
	assign Cathodes = (1'b1 << Selector);
	
	// Select data to be displayed
	wire [3:0] TempData = Data[(Selector*4+3)-:4];
	
	// Check if this digit has to be visible
	wire Enable = Visible[Selector];
	
	// Decimal point enable
	assign Segments[7] = DecimalPoints[Selector];

	// 7 segment decoder instance
	Decoder7seg #(
		.COMMON_CATHODE(1)
	) Decoder7seg0(
		.Enable_i(Enable),
		.Data_i(TempData),
		.Segments_o(Segments[6:0])
	);
	
endmodule
