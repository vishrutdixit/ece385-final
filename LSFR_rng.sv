module LSFR_rng #(parameter seed = 16'h600d)
(
	input  Clk,
	input  Reset,
	output logic [2:0] Out
);

//-----------------------------------------------------------------------//
//																								 //
//		We use a Linear Feedback Shift Register to provide 					 //
//		psuedo-random tetris block shapes. 											 //
//																								 //
//		The design follows the 16-bit Fibonacci LFSR: 							 //
//		https://en.wikipedia.org/wiki/Linear-feedback_shift_register		 //
//																								 //
//		The right-most 3 bits of the state (state[2:0) are used as the 	 //
//		ouput, replacing 3'b000 with 3'b111 since there are only 7 			 //
//		possible shapes.																	 //
//																								 //
//-----------------------------------------------------------------------//

logic [15:0] state;

initial
begin
	state = seed;
end

logic in;
assign in = (((state[0]^state[2])^state[3])^state[5]);

always_comb
begin
	if(state[2:0] != 3'b000)
		//Out = state[2:0];
		Out = {state[0],state[7],state[15]};
	else
		Out = 3'b001;
end

always_ff @(posedge Clk)
begin
  if (Reset) 
	 state <= seed;
  else
	 state <= {in, state[15:1]};
end

endmodule