// Count up on each button press and display on LEDs	
module clock_divider(
	
	//inputs
	input m_clock,
	input rst_button,
	
	//outputs
	output reg o_clock
);
	wire rst;
	reg [23:0] q;
	// Reset is the inverse of the first button
	assign rst = ~rst_button;
	
	//Clock signal 1Hz
	
	always @ (posedge m_clock) begin
		if (rst == 1'b1) begin
			q <= 24'b0;
			o_clock <= 1'b0;
		end else begin
			q <= q + 1'b1;
			// when q reach 6M it changes output state
			if (q == 24'b010110111000110110000000 || q == 24'b0) begin
				o_clock <= ~o_clock;
			end
		end
	end
endmodule


module button_counter(

	//inputs
	input		[1:0]	button,
	input	clk,
	
	//Outputs
	output	reg	[3:0]	led
);
	wire current_clock;
	wire m_reset;
	
	assign m_reset = ~button[0];
	
	clock_divider clk1 (.m_clock(clk), .rst_button(button[0]), .o_clock(current_clock));
	
	//Count up on clock rising edge or reset on button push
	always @ (posedge current_clock or posedge m_reset) begin 
		if (m_reset == 1'b1) begin
			led <= 4'b0000;
		end else begin
			led <= led + 1'b1;
		end
	end

endmodule