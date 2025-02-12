//Inferred block RAM, we let synthetyzer tool to guess whether or not this is a RAM block, at least Yosys has a module and keyword to use a Block ram on FPGAs, Vivaado and icestudio have a GUI block for RAM blocks
module memory # (

	// Parameters
	parameter INIT_FILE = ""
) (

	//inputs
	input				clk,
	input				w_en,
	input				r_en,
	input	[3:0]		w_addr,
	input	[3:0]		r_addr,
	input	[7:0]		w_data,
	
	//Outputs
	output	reg [7:0]	r_data
);

	integer i;

	// Declare memory [7:0] widhth data, [0:15] (decimal format) data address
	reg [7:0]	mem[0:15];
	
	//Interact with the memory block
	always @ (posedge clk) begin
		
		//Write to memory
		if (w_en == 1'b1) begin
			mem[w_addr] <= w_data;
		end
		
		//Read from memry
		if (r_en == 1'b1) begin
			r_data <= mem [r_addr];
		end
	
	end
	
	//Initialization (if available) from datasheet iCE40 family's SysRAM can work as ROM when the content of the RAM is pre-loaded during device configuration
	initial if (INIT_FILE) begin
		$readmemh(INIT_FILE, mem);
	end
	

endmodule