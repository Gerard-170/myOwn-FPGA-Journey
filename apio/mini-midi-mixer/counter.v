module counter#(

	//Parameters
	parameter			option		= 1
) (
	
	//Inputs
	input				clk,
	input				rst,
	input				go_btn,
	
	//Outputs
	output	reg			done_sig,
	output	reg[3:0]	o_led
);


// States
localparam STATE_IDLE		= 2'd0;
localparam STATE_COUNTING	= 2'd1;
localparam STATE_DECOUNTING = 2'd2;

//Max Counts for clock divider and counter
localparam MAX_LED_COUNT	= 4'hf;
localparam MIN_LED_COUNT	= 4'h0;

reg	[1:0]	state;
	
// State transition logic
always @ (posedge clk or posedge rst) begin
	
	//On reset, return to idle state
	if (rst == 1'b1) begin
		state <= STATE_IDLE;
		
	//Define the state transitions
	end else begin
		case (state)
		
			//Wait for go button to be pressed
			STATE_IDLE: begin
				done_sig <= 1'b0;
				if (go_btn == 1'b1) begin
					if (option == 1) begin
						state <= STATE_COUNTING;
					end else begin
						state <= STATE_DECOUNTING;
					end
				end
			end
			
			//Go from couting to decounting if couting reaches max
			STATE_COUNTING: begin
				if (o_led == MAX_LED_COUNT) begin
					done_sig <= 1'b1;
					state <= STATE_IDLE;
				end
			end
			
			//Go from decouting to done if couting reaches min
			STATE_DECOUNTING: begin
				if (o_led == MIN_LED_COUNT) begin
					done_sig <= 1'b1;
					state <= STATE_IDLE;
				end
			end			
			// Go to idle if in unknown State
			default: state <= STATE_IDLE;
		endcase
	end
end

//Handle the LED Counter
always @ (posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		o_led <= 4'd0;
	end else begin
		if (state == STATE_COUNTING) begin
			o_led <= o_led + 1;
		end else if ((state == STATE_DECOUNTING) && (o_led != MIN_LED_COUNT)) begin
			o_led <= o_led - 1;
		end else begin
			if (option == 1) begin
				o_led <= 4'h0;
			end else if(state == STATE_IDLE) begin
				o_led <= 4'hf;
			end
			
		end
	end
end

endmodule
