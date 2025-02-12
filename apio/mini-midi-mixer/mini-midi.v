module mini_midi (
	//Inputs
	input				rst,
	input				clk,
	input				set,
	input				key_zero,
	input				key_one,
	
	//Outputs
	output	 [1:0]	led
);

	wire input_rst;
	wire input_set;
	wire input_key0;
	wire input_key1;
	
	wire db_rst;
	wire db_set;
	wire db_key0;
	wire db_key1;
	
	assign input_rst = ~rst;
	assign input_set = ~set;
	assign input_key0 = ~key_zero;
	assign input_key1 = ~key_one;
	
	wire clk_led;
	reg go = 0;
	wire [3:0] counter_wire;
	wire intermediate_go;
	reg counter_reset = 0;

	wire [7:0] read_test;
	
	// States
	reg	[1:0]	state;
	localparam STATE_IDLE		= 2'd0;
	localparam STATE_PLAYING	= 2'd1;
	localparam STATE_SETTING	= 2'd2;
	
	// Storage elements (set some initial values to 0)
	reg 			w_en = 0;
	reg				r_en = 0;
	reg		[3:0]	w_addr = 4'b0000;
	reg		[3:0]	r_addr = 4'b0000;
	reg		[7:0]	w_data = 0;
	
	//Button debouncer blocks:
	
	button_debouncer set_debouncer(
		.rst(input_rst),
		.clk(clk),
		.button(input_set),
		.db_button(db_set)
		);
		
	button_debouncer key0_debouncer(
		.rst(input_rst),
		.clk(clk),
		.button(input_key0),
		.db_button(db_key0)
		);
		
	button_debouncer key1_debouncer(
		.rst(input_rst),
		.clk(clk),
		.button(input_key1),
		.db_button(db_key1)
		);
		
	//Clock divider for leds period = 0.5s:3000000
	clock_divider #(.COUNT_WIDTH(32), .MAX_COUNT(3000000 - 1)) clk_leds(
		.clk(clk),
		.rst(input_rst),
		.out(clk_led)
	);
	
	//Memory instance
	memory #(.INIT_FILE ("mem_init.txt")) my_memory(
		.clk(clk),
		.w_en(w_en),
		.r_en(r_en),
		.w_addr(w_addr),
		.r_addr(r_addr),
		.w_data(w_data),
		.r_data(read_test)
		);
	
	//Counter
		counter		#(.option(1))	counter_block	(
		.clk(clk_led),
		.rst(counter_reset),
		.go_btn(go),
		.o_led(counter_wire),
		.done_sig(intermediate_go)
	);
	
	always @ (posedge clk or posedge input_rst) begin
		//On reset, return to idle state
		if (input_rst == 1'b1) begin
			state <= STATE_IDLE;
		//Define the state transitions
		end else begin
			case (state)
				STATE_IDLE: state <= STATE_PLAYING;
				
				STATE_PLAYING: begin
					if (db_set == 1'b1) begin
						state <= STATE_SETTING; 
					end else begin 
						state <= STATE_PLAYING;
					end
				end
				
				STATE_SETTING: begin
					if (db_set == 1'b0) begin
						state <= STATE_PLAYING;
					end else begin
						state <= STATE_SETTING;
					end
				end
				default: state <= STATE_PLAYING;
			endcase
		end
	end
	
	//Handle Memory Writing
	always @ (posedge clk or posedge input_rst) begin
		//On reset, return to idle state
		if (input_rst == 1'b1) begin
			w_en <= 0;
		end else begin
			if (state == STATE_SETTING) begin
				w_data <= {input_key1, input_key0};
				w_en <= 1;
			end else begin
					if (w_en == 1'b1) begin
						w_addr <= w_addr + 1;
					end
					w_en <= 0;
			end
		end
	end
	
	//Handle the LED and memory reading
	always @ (posedge clk or posedge input_rst) begin
		if (input_rst == 1'b1) begin
			r_en <=0;
			counter_reset <= 1;
		end else begin
			if (state == STATE_PLAYING) begin
				counter_reset <= 0;
				go <= 1;
				r_addr <= counter_wire;
				r_en <= 1;				
			end else begin
				r_en <=0;
				go <= 0;
				counter_reset <= 1;
			end
		end
	end
	
	
	assign led = {read_test[1], read_test[0]};
	
endmodule