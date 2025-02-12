//Defines timescale for simulation
`timescale 1 ns / 10 ps


module midi_tb();

	//Internal signals
	//Inputs
	reg		rst = 1;
	reg		clk = 0;
	reg		set = 1;
	reg		key_zero = 1;
	reg		key_one = 1;
	
	//Outputs
	wire	[1:0]	led;
	//Simulation time: 10000 * 1 ns = 10 us
	localparam	DURATION = 10000;
	
	//Generate clock signal = ~12 MHz
	always begin
		#41.67
		clk = ~clk;
	end
	
	mini_midi uut(
		.rst(rst),
		.clk(clk),
		.set(set),
		.key_zero(key_zero),
		.key_one(key_one),
		.led(led)
	);
	
	
	initial begin
		//Test 1: reset
		#(2 * 41.67)
		rst = 0;
		#(4 * 41.67)
		rst = 1;
		
		//
		#(2 * 41.67)
		set = 0;
		#(2 * 41.67)
		key_zero = 0;
		#(8 * 41.67)
		set = 1;
	end
	
	
		//Run simulation
	initial begin 
		//Create simulation output file
		$dumpfile("mini-midi_tb.vcd");
		$dumpvars(0, midi_tb);
		
		//Wait for a given amount of time for simulation to complete
		#(DURATION)
		
		//Notify and end simulation
		$display("Finished!");
		$finish;
	end

endmodule