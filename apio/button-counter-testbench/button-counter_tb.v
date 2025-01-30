// Defines timescale for simulation: <time_unit> / <time_precision>
// This specific keyword is brought by Icarus Verilog simulator, but it could be different for others
//Also the name _tb.v in this file is used by apio for testbench
`timescale 1 ns / 10 ps

module button_counter_uut ();

	reg rst = 0;
	reg clk = 0;
	
	//Internal storage elements
	wire		div_clk;
	
	reg input_signal = 0;
	wire [3:0] led = 0;
	
	// Variables for randomize
	reg [3:0] val;
	reg [31:0] seed;
	integer delay_count;
	
	//Simulation time: 10000 * 1 ns = 10 us
	localparam DURATION = 10000;
	
	// Generate clock signal: 1 / ((2 * 41.67) * 1 ns) = 11,999,040.08 MHz
	always begin
		
		//Delay for 41.67 time units
		//10 ps precision means that 41.667 is rounded to 41.67 ns
		#41.667
		
		//Toggle Clock line
		clk = ~clk;
	end
	
	
	// Clock Divider
	clock_divider  #(.COUNT_WIDTH(4), .MAX_COUNT(4 - 1)) clk_source (
		.clk(clk),
		.rst(rst),
		.out(div_clk)
	);
	
	button_counter counter_uut (
		.clk(div_clk),
		.rst(rst),
		.button(input_signal),
		.led(led)
	);

	//Pulse reset line high at the beginning
	initial begin
		#10
		rst = 1'b1;
		#1
		rst = 1'b0;
	end
	
	//Simulated pulse
	initial begin
		#20
		for (integer i = 0; i < 5; i += 1) begin
			val = $random(seed) % 3;
			delay_count = val;
			$display ("i=%0d seed=%0d val=0x%0h val=%0d", i, seed, val, val);
			// Delay
			#delay_count;
			input_signal = input_signal + 1;
		end
	end
	
	//Run simulation (output to .vcd files)
	initial begin
		
		//Create simulation output file
		$dumpfile("button-counter_tb.vcd");
		$dumpvars(0, button_counter_uut);
		
		// Wait for given amount of time for simulation to complete
		#(DURATION)
		// Notify and end simulation
		$display("Finished!");
		$finish;
	end

endmodule
		
	