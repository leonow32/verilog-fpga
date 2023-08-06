// 230804

`default_nettype none
module StrobeGenerator #(
	parameter	CLOCK_HZ	= 10_000_000,
	parameter	PERIOD_NS	= 100_000
)(
	input wire  Clock,
	input wire  Reset,
	input wire  Enable_i,
	output reg  Strobe_o
);
	
	//localparam real CLOCK_HZ_REAL = $itor(CLOCK_HZ);
	//localparam real PERIOD_NS_REAL = $itor(PERIOD_NS);
	//localparam real DELAY_REAL = (CLOCK_HZ_REAL * PERIOD_NS_REAL / 1_000_000_000.0) - 1.0;
	//localparam DELAY = $rtoi(DELAY_REAL);
	localparam DELAY = (CLOCK_HZ * PERIOD_NS / 1_000_000_000) - 1;
	localparam WIDTH = $clog2(DELAY + 1);
	
	initial begin
		$display("DELAY     = %9d", DELAY);
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
