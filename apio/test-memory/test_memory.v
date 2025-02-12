module test_memory(
	//Inputs
	input clk, 
	input set,
	input rst, 
	//Outputs
	output	 [1:0]	led
);
	wire input_rst;
	wire input_set;

	assign input_rst = ~rst;
	assign input_set = ~set;

	// Storage elements (set some initial values to 0)
	reg 			w_en = 0;
	reg				r_en = 0;
	reg		[3:0]	w_addr = 4'b0010;
	reg		[3:0]	r_addr = 4'b0010;
	reg		[7:0]	w_data = 3;
	
	wire [7:0] read_test;

	//Memory instance
	memory my_memory(
		.clk(clk),
		.w_en(w_en),
		.r_en(r_en),
		.w_addr(w_addr),
		.r_addr(r_addr),
		.w_data(w_data),
		.r_data(read_test)
		);
		
	always @ (posedge clk or posedge input_rst) begin
		//On reset, return to idle state
		if (input_rst == 1'b1) begin
			w_en <= 0;
			r_en <= 0;
		//Define the state transitions
		end else if (input_set == 1'b1) begin
			w_en <= 1;
			r_en <= 0;
		end else begin
			w_en <= 0;
			r_en <= 1;
		end
	end
	
	assign led[0] = read_test[0];
	assign led[1] = read_test[1];
	
endmodule