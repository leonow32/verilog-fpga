# Binary to BCD converter - Double Dabble algorithm

![Status](https://img.shields.io/badge/STATUS-READY-green.svg)

Converter of binary values to BCD code, which is often used by display controllers. It uses the Double Dabble algorithm in a combinational implementation.

## Instantiation

```verilog
	DoubleDabble #(
		.INPUT_BITS(),
		.OUTPUT_DIGITS(),
		.OUTPUT_BITS()      // Optional
	) DUT(
		.Binary_i(),
		.BCD_o()
	);
```

## Port description

+ **INPUT_BITS** - The number of bits of the input value.
+ **OUTPUT_DIGITS** - How many digits are to be included in the result. 
+ **OUTPUT_BITS** - Optional parameter. Defaults to `OUTPUT_DIGITS` * 4, since there are 4 bits for each digit in the BCD code. However, if the most significant digit can change in an incomplete range (e.g. from 0 to 3) then there is no need for 4 bits, but 2.
+ **Binary_i** - Input binary value.
+ **BCD_o** - Output in BCD code.
