// 240414

`default_nettype none

module top (
	input wire TopIn,
	input wire TopEnable,
	output wire TopOut
);
	
	TriState TriState_inst(
		.DataIn(TopIn),
		.OutputEnable(TopEnable),
		.DataOut(TopOut)
	);

endmodule

`default_nettype wire
