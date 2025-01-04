/* Module: 1 bit full adder */
module and_gate (
	//Inputs
	input	[2:0]	button,
	
	//Outputs
	output	[1:0]	led
);
	//Wire (net) declarations (internal to module)
	wire xor_a_b;
	wire and_a_b;
	wire and_cin_xor_a_b;
	
	// Out S
	assign xor_a_b = button[0] ^ button [1];
	assign led[0] = xor_a_b ^ button[2];
	
	//out carry
	assign and_a_b = button[0] & button [1];
	assign and_cin_xor_a_b = xor_a_b & button[2];
	assign led[1] = and_a_b | and_cin_xor_a_b;
	
endmodule