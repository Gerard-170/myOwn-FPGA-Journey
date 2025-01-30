// Defines timescale for simulation: <time_unit> / <time_precision>
// This specific keyword is brought by Icarus Verilog simulator, but it could be different for others
//Also the name _tb.v in this file is used by apio for testbench
`timescale 1 ns / 10 ps



// Define our testbench
module clock_divider_tb();
	
	//Internal signals
	wire	out;
	
	//Storage elements (Set initial values to 0)
	reg		clk = 0;
	reg		rst = 0;
	
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
	
	// Instatiate the unit under test (UUT)
	clock_divider #(.COUNT_WIDTH(4), .MAX_COUNT(6 - 1)) uut (
		.clk(clk),
		.rst(rst),
		.out(out)
	);
	
	//Pulse reset line high at the beginning
	initial begin
		#10
		rst = 1'b1;
		#1
		rst = 1'b0;
	end
	
	//Run simulation (output to .vcd files)
	initial begin
		
		//Create simulation output file
		$dumpfile("clk-div_tb.vcd");
		$dumpvars(0, clock_divider_tb);
		
		// Wait for given amount of time for simulation to complete
		#(DURATION)
		
		// Notify and end simulation
		$display("Finished!");
		$finish;
	end
	
endmodule