module testbench();

timeunit 10ns;

timeprecision 1ns;


logic Reset = 0;
logic Clk = 0;
//logic frame_clk = 0;
logic  [2:0] rand1,rand2;
//logic [1:0] check, down_check;
//logic [2:0] random, pixel_value, moving_block, moving_block_in;
//logic [9:0] DrawX, DrawY;
//logic [7:0] cmd_count;
//logic [1:0] stream_counter, stream_counter_in;
//logic [5:0] slide_counter, slide_counter_in;
//logic [7:0] last_cmd;
//logic rotate_lockout;
//logic [4:0] left_x, right_x, top_y, bottom_y;
//logic [4:0] moving_block_x_1, moving_block_x_2, moving_block_x_3, moving_block_x_4, moving_block_y_1, moving_block_y_2, moving_block_y_3, moving_block_y_4;
//logic [4:0] counter_counter, counter, counter_in, counter_counter_in;
//logic [7:0] keycode;
//grid grid (.*);

LSFR_rng #(.seed(16'hacac)) rng1(.Reset(Reset), .Clk(Clk), .Out(rand1)); //0x600d = 24589
LSFR_rng #(.seed(16'hfafa)) rng2(.Reset(Reset), .Clk(Clk), .Out(rand2)); //0xbeef = 48879

// The clock is driven, by code provided by SO - allows for clock cycle without having to manually key in values 
always begin : CLOCK_CYCLE
#1 Clk = ~Clk;
	//DrawX = DrawX + 1;
	//DrawY = DrawY + 1;
end

//always begin : VGA_CYCLE
//#5 frame_clk = ~frame_clk;
//end

//always begin : KEYCODE_CYCLE
//#20 keycode = keycode ^ 8'h1A;
//end

initial begin: CLOCK_INIT
    Clk = 0;
	 //frame_clk = 0;
	 //keycode = 8'h1A;
	 //random = 3'd1;
	 
end 

always_ff @(posedge Clk)
begin
	//counter = grid.counter;
	//counter_in = grid.counter_in;
	//moving_block = grid.moving_block;
	//moving_block_in = grid.moving_block_in;
	//counter_counter = grid.counter_counter;
	//counter_counter_in = grid.counter_counter_in;
	
	
	//slide_counter = grid.slide_counter;
	//slide_counter_in = grid.slide_counter_in;
	//stream_counter = grid.stream_counter;
	//stream_counter_in = grid.stream_counter_in;
	//rotate_lockout = grid.rotate_lockout;
	//last_cmd = grid.last_cmd;
	//cmd_count = grid.cmd_count;
	//check = grid.check;
	//down_check = grid.down_check;
	//moving_block_x_1 = grid.moving_block_x[0];
	//moving_block_x_2 = grid.moving_block_x[1];
	//moving_block_x_3 = grid.moving_block_x[2];
	//moving_block_x_4 = grid.moving_block_x[3];
	
	//moving_block_y_1 = grid.moving_block_y[0];
	//moving_block_y_2 = grid.moving_block_y[1];
	//moving_block_y_3 = grid.moving_block_y[2];
	//moving_block_y_4 = grid.moving_block_y[3];
	
	//left_x = grid.left_x;
	//right_x = grid.right_x;
	//bottom_y = grid.bottom_y;
	//top_y = grid.top_y;


end

// nomenclature as standardized. Continues to fetch values from memory_contents.

initial begin: TEST_VECTORS

#1 Reset = 1;
#1 Reset = 0;

//#12 random = 3'd3;

end
endmodule 