// 240525

`default_nettype none

`default_nettype wire
module Memory(
	input  wire Clock,		// Must be 25 MHz or 25.175 MHz
	input  wire Reset,
	
	input Request_i,
	input [6:0] Column,
	input [4:0] Row,
	input [3:0] Line,
	
	output
	
	
);

	// Pamięć tekstu i koloru
	// 2400 wpisów po 16 bitów
	// EBR może pracować w układzie 512x18bit
	
	// Pamięć czcionki
	// Znaki od 0 do 127, 16 bajtów na znak
	// 2048 bajtów na całą pamięć czcionki
	
endmodule
