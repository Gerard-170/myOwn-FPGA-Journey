//Button-debouncer instance
module button_debouncer(
	//Inputs
	input rst,
	input clk,
	input button,
	
	//Output
	output db_button
);

	//Internal signals
	reg delay1, delay2, delay3; 
	
	always @ (posedge clk or posedge rst) begin
		if (rst == 1'b1) begin
			delay1 <= 1'b0;
			delay2 <= 1'b0;
			delay3 <= 1'b0;
		end else begin
			delay1 <= button;
			delay2 <= delay1;
			delay3 <= delay2;
		end
	end
	
	assign db_button = delay1 & delay2 & delay3;
	
endmodule