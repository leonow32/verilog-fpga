// 230628

`default_nettype none
module StrobeGenerator #(
	parameter	CLOCK_HZ	= 10_000_000,
	parameter	PERIOD_NS	= 100
)(
	input wire  Clock,
	input wire  Reset,
	input wire  Enable_i,
	output reg  Strobe_o
);
	
	localparam real CLOCK_PERIOD_NS = 1_000_000_000.0 / CLOCK_HZ;
	localparam real DELAY_TICKS = PERIOD_NS / CLOCK_PERIOD_NS;
	
	localparam DELAY = (CLOCK_HZ * PERIOD_NS / 1_000_000_000) - 1;
	localparam WIDTH = $clog2(DELAY + 1);
	
	initial begin
		if(DELAY <= 0)
			$fatal(0, "Wrong DELAY value: %d", DELAY);
	end
	
	reg [WIDTH-1:0] Counter;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Counter      <= DELAY;
			Strobe_o     <= 1'b0;
		end else if(Enable_i) begin
			if(!Counter) begin
				Counter  <= DELAY;
				Strobe_o <= 1'b1;
			end else begin
				Counter  <= Counter - 1'b1;
				Strobe_o <= 1'b0;
			end 
		end else begin
			Counter <= DELAY;
		end
	end
	
endmodule
`default_nettype wire