module board
(
	input 				Clk, Reset, frame_clk,
	input 	[9:0] 	DrawX, DrawY,
	input 	[7:0] 	keycode,
	input 	[2:0] 	random,
	output 	[2:0]		pixel_value,
	output				new_rand
)

	logic frame_clk_delayed, frame_clk_rising_edge;
   always_ff @ (posedge Clk) 
		begin
			frame_clk_delayed <= frame_clk;
			frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
		end
	