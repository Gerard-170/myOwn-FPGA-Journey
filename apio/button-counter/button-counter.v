// Count up on each button press and display on LEDs

module button_counter (

	//Inputs
	input		[1:0]	button,
	input				cclk,
	
	//Outputs
	output reg	[3:0]	led
);

	//Max Counts for clock divider and counter
	localparam MAX_CLK_COUNT	= 24'd150000;

	// We will normally use the same 190Hz frequency for cclk that is used to refresh the 7-segment displays, 
	wire rst;
	wire clk;
	
	//Internal storage elements
	reg			div_clk;
	reg [23:0]	clk_count;
	
	//Reset is the inverse of the first button
	assign rst = ~button[0];
	
	// Clock signal is the inverse of the second button
	assign clk = ~button[1];
	
	reg delay1, delay2, delay3; 
	wire output_singal;
	
	always @ (posedge div_clk or posedge rst) begin
		if (rst == 1'b1) begin
			delay1 <= 1'b0;
			delay2 <= 1'b0;
			delay3 <= 1'b0;
		end else begin
			delay1 <= clk;
			delay2 <= delay1;
			delay3 <= delay2;
		end
		
	end

	assign output_singal = delay1 & delay2 & delay3;

	// Clock divider
	always @ (posedge cclk or posedge rst) begin
		if (rst == 1'b1) begin
			clk_count <= 24'b0;
		end else if (clk_count == MAX_CLK_COUNT) begin
			clk_count <= 24'b0;
			div_clk <= ~div_clk;
		end else begin
			clk_count <= clk_count + 1;
		end
	end
	
	// Count up on clock rising edge or reset on button push
	always @ (posedge output_singal or posedge rst) begin
		if (rst == 1'b1) begin
			led <= 4'b0000;
		end else begin
			led <= led + 1'b1;
		end
	end
endmodule
		
	