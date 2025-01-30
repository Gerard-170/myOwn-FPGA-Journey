//Button-Counter instance
module button_counter(
	//Inputs
	input rst,
	input clk,
	input button,
	
	//Output
	output reg[3:0]	led
);

	//Internal signals
	reg delay1, delay2, delay3; 
	wire output_signal;
	
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
	
	assign output_signal = delay1 & delay2 & delay3;
	
	// Count up on clock rising edge or reset on button push
	always @ (posedge output_signal or posedge rst) begin
		if (rst == 1'b1) begin
			led <= 4'b0000;
		end else begin
			led <= led + 1'b1;
		end
	end
endmodule