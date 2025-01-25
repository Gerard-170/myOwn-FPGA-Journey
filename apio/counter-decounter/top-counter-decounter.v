module top_design (

	//Inputs
	input		clk,
	input		go_btn,
	input		rst_btn,
	
	// Outputs
	output	[3:0]	led,		// Not reg element!
	output			done_sig
);
	// Internal signals
	reg [3:0] switch;
	wire rst;
	wire go;
	wire intermediate_go;
	wire final_go;
	wire m_clk;
	wire [3:0] counter_wire;
	wire [3:0] decounter_wire;
	
	//Invert active-low button
	assign rst = ~rst_btn;
	assign go = ~go_btn;
	
	initial begin
		switch <= 4'h0;
	end
	
	//Instatiate the first clock divider module
	clock_divider	#(.COUNT_WIDTH(32), .MAX_COUNT(1500000 - 1))	div_1	(
		.clk(clk),
		.rst(rst),
		.out(m_clk)
	);
	
	counter			#(.option(1))									counter_block	(
		.clk(m_clk),
		.rst(rst),
		.go_btn(go),
		.o_led(counter_wire),
		.done_sig(intermediate_go)
	);
	
	counter			#(.option(0))									decounter_block	(
		.clk(m_clk),
		.rst(rst),
		.go_btn(intermediate_go),
		.o_led(decounter_wire),
		.done_sig(final_go)
	);

	always @ (posedge m_clk or posedge rst) begin
		if (rst == 1'b1) begin
			switch <= 4'h0;
		end else if (intermediate_go == 1'b1) begin
			switch <= 4'hf;
		end else if (done_sig == 1'b1) begin
			switch <= 4'h0;
		end
	end
	//Handle done signal
	assign done_sig = intermediate_go | final_go;
	//Handle the LED Counter
	assign led = counter_wire | (decounter_wire & switch);

endmodule

	
