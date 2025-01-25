// Top-Level design that produces 2 different divided clocks
module top_design (

	//Inputs
	input		clk,
	input		rst_btn,
	
	// Outputs
	output	[1:0]	led		// Not reg element!
);

	// Internal signals
	wire rst;
	
	//Invert active-low button
	assign rst = ~rst_btn;
	
	//Instatiate the first clock divider module
	clock_divider	div_1	(
		.clk(clk),
		.rst(rst),
		.out(led[0])
	);
	defparam div_1.COUNT_WIDTH	=	32;
	defparam div_1.MAX_COUNT	=	1500000 - 1;
	
	
	// Instantiate the second clock divider module
	clock_divider	div_2	(
		.clk(clk),
		.rst(rst),
		.out(led[1])
	);
	
endmodule