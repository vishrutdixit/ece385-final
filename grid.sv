module display ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [7:0]	  keycode,
					input [2:0]   random,
					output logic [2:0] pixel_value,
					// Whether current pixel belongs to ball or background
					output logic new_rand
              );

	logic frame_clk_delayed, frame_clk_rising_edge;
	
	logic [1:0] stream_counter, stream_counter_in;
	logic [4:0] clear_line, clear_line_in;
	logic [7:0] cmd_count, cmd_count_in;
	logic hold;
	
	logic [2:0] regs[24][18], regs_in[24][18];
	logic [1:0] check, down_check;
	
	logic [5:0] slide_counter, slide_counter_in;
	logic [4:0] left_x, top_y, bottom_y, right_x, left_x_in, right_x_in, top_y_in, bottom_y_in, leftmost_rot_block, leftmost_rot_block_in, right_y;
	logic [2:0] moving_block, moving_block_in, hold_value, hold_value_in;
	logic [4:0] moving_block_x[4], moving_block_x_new[4], moving_block_x_temp[4], moving_block_y_temp[4];
	logic [4:0] moving_block_y[4], moving_block_y_new[4];
	
	logic rotate_lockout, rotate_lockout_in;
	logic [7:0] last_cmd, last_cmd_in;
	reg [4:0] extension[7:0];
	initial begin
		extension[7] <= 5'd3;
		extension[6] <= 5'd2;
		extension[5] <= 5'd2;
		extension[4] <= 5'd1;
		extension[3] <= 5'd2;
		extension[2] <= 5'd2;
		extension[1] <= 5'd2;
		extension[0] <= 5'd0;
	end
	logic [4:0] counter, counter_in, counter_counter, counter_counter_in;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	
	always_ff @ (posedge Clk)
	begin
		if (Reset)
		begin
			clear_line <= 0;
			moving_block <= 3'b0;
			counter_counter <= 5'b0;
			rotate_lockout <= 1'b0;
			cmd_count <= 8'b0;
			slide_counter <= 6'b0;
			leftmost_rot_block <= 5'b0;
			hold_value <= 3'b0;
			stream_counter <= 2'b0;
			last_cmd <= 8'b0;
			for(int i = 0; i < 4; i++)
			begin
				moving_block_x[i] <= 5'b0;
				moving_block_y[i] <= 5'b0;
			end
			counter <= 5'b0;
			left_x <= 5'b0;
			right_x <= 5'b0;
			top_y <= 5'b0;
			bottom_y <= 5'b0;
			for(int i = 0; i < 24; i++)
			begin
				for(int j = 0; j < 18; j++)
				begin
					regs[i][j] = 3'b0;
				end
			end
		end
		
		else
		begin
			right_x <= right_x_in;
			bottom_y <= bottom_y_in;
			top_y <= top_y_in;
		
			leftmost_rot_block <= leftmost_rot_block_in;
			stream_counter <= stream_counter_in;
			cmd_count <= cmd_count_in;
			clear_line <= clear_line_in;
			counter_counter <= counter_counter_in;
			moving_block <= moving_block_in;
			counter <= counter_in;
			moving_block_y <= moving_block_y_new;
			moving_block_x <= moving_block_x_new;
			regs <= regs_in;
			left_x <= left_x_in;
			slide_counter <= slide_counter_in;
			hold_value <= hold_value_in;
			last_cmd <= last_cmd_in;
			rotate_lockout <= rotate_lockout_in;
		end
	end
	
	always_comb
	begin
		clear_line_in = clear_line;
		moving_block_in = moving_block;
		counter_in = counter;
		cmd_count_in = cmd_count;
		last_cmd_in = last_cmd;
		rotate_lockout_in = rotate_lockout;
		regs_in = regs;
		hold = 0;
		hold_value_in = hold_value;
		stream_counter_in = stream_counter;
		counter_counter_in = counter_counter;
		moving_block_x_new = moving_block_x;
		leftmost_rot_block_in = 18;
		moving_block_y_new = moving_block_y;
		check = 0;
		down_check = 0;
		left_x_in = 17;
		slide_counter_in = slide_counter;
		bottom_y_in = 0;
		right_x_in = 0;
		top_y_in = 23;
		right_y = 0;
		
		for( int i = 0; i < 4; i++)
		begin
			if(moving_block_x[i] > right_x_in)
			begin
				right_x_in = moving_block_x[i];
				right_y = moving_block_y[i];
			end
			if(moving_block_x[i] < left_x_in)
				left_x_in = moving_block_x[i];
			
			if(moving_block_y[i] < top_y_in)
				top_y_in = moving_block_y[i];
			
			if(moving_block_y[i] > bottom_y_in)
				bottom_y_in = moving_block_y[i];
		end
		
		for(int i = 0; i < 4; i++)
		begin
			for(int j = 0; j < 18; j++)
			begin
				if( j > right_x_in && regs[moving_block_y[i]][j] != 0 && j < leftmost_rot_block_in)
					leftmost_rot_block_in = j;
			end
		end
		if(moving_block_in == 0 && slide_counter_in == 0)
		begin
			new_rand = 1;
			moving_block_in = random;
			hold_value_in = random;
			unique case(moving_block_in)
				3'd0: ;
				3'd1: begin // TRI
					moving_block_x_new[0] = 7;
					moving_block_x_new[1] = 8;
					moving_block_x_new[2] = 9;
					moving_block_x_new[3] = 8;
					moving_block_y_new[0] = 0;
					moving_block_y_new[1] = 0;
					moving_block_y_new[2] = 0;
					moving_block_y_new[3] = 1;
				end
				
				3'd2: begin // reverse L
					moving_block_x_new[0] = 9;
					moving_block_x_new[1] = 9;
					moving_block_x_new[2] = 9;
					moving_block_x_new[3] = 8;
					moving_block_y_new[0] = 0;
					moving_block_y_new[1] = 1;
					moving_block_y_new[2] = 2;
					moving_block_y_new[3] = 2;
				end
				
				3'd3: begin // L
					moving_block_x_new[0] = 8;
					moving_block_x_new[1] = 8;
					moving_block_x_new[2] = 8;
					moving_block_x_new[3] = 9;
					moving_block_y_new[0] = 0;
					moving_block_y_new[1] = 1;
					moving_block_y_new[2] = 2;
					moving_block_y_new[3] = 2;
				end
				
				3'd4: begin // square
					moving_block_x_new[0] = 8;
					moving_block_x_new[1] = 9;
					moving_block_x_new[2] = 8;
					moving_block_x_new[3] = 9;
					moving_block_y_new[0] = 0;
					moving_block_y_new[1] = 0;
					moving_block_y_new[2] = 1;
					moving_block_y_new[3] = 1;
				end
				
				3'd5: begin // rightface S
					moving_block_x_new[0] = 9;
					moving_block_x_new[1] = 9;
					moving_block_x_new[2] = 8;
					moving_block_x_new[3] = 8;
					moving_block_y_new[0] = 0;
					moving_block_y_new[1] = 1;
					moving_block_y_new[2] = 1;
					moving_block_y_new[3] = 2;
				end
				
				3'd6: begin // leftface S
					moving_block_x_new[0] = 8;
					moving_block_x_new[1] = 8;
					moving_block_x_new[2] = 9;
					moving_block_x_new[3] = 9;
					moving_block_y_new[0] = 0;
					moving_block_y_new[1] = 1;
					moving_block_y_new[2] = 1;
					moving_block_y_new[3] = 2;
				end
				
				3'd7: begin // I
					moving_block_x_new[0] = 7;
					moving_block_x_new[1] = 8;
					moving_block_x_new[2] = 9;
					moving_block_x_new[3] = 10;
					moving_block_y_new[0] = 0;
					moving_block_y_new[1] = 0;
					moving_block_y_new[2] = 0;
					moving_block_y_new[3] = 0;
				end
			endcase					
		end
		new_rand = 0;
		if (frame_clk_rising_edge)
		begin
			counter_counter_in = counter_counter + 5'b1;
			stream_counter_in = stream_counter + 2'b1;
			if(moving_block_in || slide_counter != 0)
			begin
				for (int i = 0; i < 4; i++)
				begin
					if(moving_block_y[i] >= 23) //collision check (bottom)
					begin
						//moving_block_y[i] = 0;
						//moving_block_in = 3'b0;
						down_check = 1;
					end
					else if (regs[moving_block_y[i] + 1][moving_block_x[i]] != 0) // collision check (brick)
					begin
						down_check = down_check + 1;
						for(int j = 0; j < 4; j++)
						begin
							if(j != i && moving_block_x[j] == moving_block_x[i] && moving_block_y[j] == moving_block_y[i] + 1)
								down_check = down_check - 1;
						end
					end
				end
				if(down_check)
				begin
					if(slide_counter == 0)
					begin
						slide_counter_in = 6'd60;
						moving_block_in = 3'b0;
					end
					else
						slide_counter_in = slide_counter - 6'b1;
				end
				else
				begin
					slide_counter_in = 0;
					moving_block_in = hold_value;
				end
					
			end			
			if(counter != 5'b0)
				counter_in = counter - 5'b1;
			if(stream_counter == 2'd2)
				stream_counter_in = 2'b0;
			
			if(moving_block_in || slide_counter_in) //counter delay
			begin
				last_cmd_in = keycode;
				if(counter == 0)
				begin
					if(keycode == last_cmd)
						cmd_count_in = cmd_count + 1;
				
					else
						cmd_count_in = 0;
				end
				unique case(keycode)
					8'h1A : begin // W press
						
						
						if(bottom_y-top_y+left_x > (leftmost_rot_block_in - 1))
						begin
							check = bottom_y-top_y+left_x - leftmost_rot_block_in + 1;
						end
						
						
						
						moving_block_x_temp[0] = moving_block_y[0] - top_y + left_x - check;
						moving_block_x_temp[1] = moving_block_y[1] - top_y + left_x - check;
						moving_block_x_temp[2] = moving_block_y[2] - top_y + left_x - check;
						moving_block_x_temp[3] = moving_block_y[3] - top_y + left_x - check;
						
						moving_block_y_temp[0] = extension[moving_block_in] + left_x + top_y - moving_block_x[0];
						moving_block_y_temp[1] = extension[moving_block_in] + left_x + top_y - moving_block_x[1];
						moving_block_y_temp[2] = extension[moving_block_in] + left_x + top_y - moving_block_x[2];
						moving_block_y_temp[3] = extension[moving_block_in] + left_x + top_y - moving_block_x[3];
						
						check = 0;
						for(int i = 0; i < 4; i++)
						begin
							if(moving_block_y_temp[i] >= 24)
								check = 1;
							else if(regs[moving_block_y_temp[i]][moving_block_x_temp[i]] != 0)
							begin
								check = check + 1;
								for(int j = 0; j < 4; j++)
								begin
									if((moving_block_x[j] == moving_block_x_temp[i]) && moving_block_y[j] == moving_block_y_temp[i])
										check = check - 2'd1;
								end
							end
						end
					
						if(check == 0 && rotate_lockout == 0 && counter == 0)
						begin
							hold = 1;
							for(int s = 0; s < 4; s++)
							begin
								rotate_lockout_in = 1'b1;
								moving_block_x_new[s] = moving_block_x_temp[s];
								moving_block_y_new[s] = moving_block_y_temp[s];
								
							end
							
							counter_in = 5'd8;
						end
						
						hold = 0;				
								
						
					end
					
					8'h04: begin // A press
						
						rotate_lockout_in = 1'b0;
						if(left_x <= 0)
							check = 2'd1;
						else
						begin
						
							for (int i = 0; i < 4; i++)
							begin
								if(regs[moving_block_y[i]][moving_block_x[i] - 1] != 0)
								begin
									check = check + 1;
									for(int j = 0; j < 4; j++)
									begin
										if(j != i && (moving_block_x[j] == moving_block_x[i] - 1) && moving_block_y[j] == moving_block_y[i])
											check = check - 5'd1;
									end
								end
							end
						end
						
						if(check == 0 && (counter == 5'd0 || (cmd_count >= 2 && stream_counter == 2'd2)))
						begin
							moving_block_x_new[0] = moving_block_x[0] - 5'd1;
							moving_block_x_new[1] = moving_block_x[1] - 5'd1;
							moving_block_x_new[2] = moving_block_x[2] - 5'd1;
							moving_block_x_new[3] = moving_block_x[3] - 5'd1;
							counter_in = 5'd8;
						end
						
					end
					
					8'h16 : begin // S press
						
						rotate_lockout_in = 1'b0;
						for (int i = 0; i < 4; i++)
						begin
							if(moving_block_x[i] < 0)
								check = 2'd1;
							else if(regs[moving_block_y[i] + 1][moving_block_x[i]] != 0)
							begin
								check = check + 2'd1;
								for(int j = 0; j < 4; j++)
								begin
									if(j != i && moving_block_x[j] == moving_block_x[i] && moving_block_y[j] == moving_block_y[i] + 1)
										check = check - 2'd1;
								end
							end
						end
			
						if(check == 0 && (counter == 0 || (cmd_count >= 2 && stream_counter == 2'd2)) && slide_counter == 0)
						begin
							moving_block_y_new[0] = moving_block_y[0] + 5'd1;
							moving_block_y_new[1] = moving_block_y[1] + 5'd1;
							moving_block_y_new[2] = moving_block_y[2] + 5'd1;
							moving_block_y_new[3] = moving_block_y[3] + 5'd1;
							counter_in = 5'd8;
							counter_counter_in = 5'd0;
						end
						
					end
					
					8'h07 : begin // D press
						
						rotate_lockout_in = 1'b0;
						if(right_x >= 17)
							check = 2'd1;
						else
						begin
						
							for (int i = 0; i < 4; i++)
							begin
							
								if(regs[moving_block_y[i]][moving_block_x[i] + 1] != 0)
								begin
									check = check + 2'd1;
									for(int j = 0; j < 4; j++)
									begin
										if(j != i && (moving_block_x[j] == moving_block_x[i] + 1) && (moving_block_y[j] == moving_block_y[i]))
											check = check - 2'd1;
									end
								end
							end
						end
						
						if(check == 0 && (counter == 0 || (cmd_count >= 2 && stream_counter == 2'd2)))
						begin
							moving_block_x_new[0] = moving_block_x[0] + 5'd1;
							moving_block_x_new[1] = moving_block_x[1] + 5'd1;
							moving_block_x_new[2] = moving_block_x[2] + 5'd1;
							moving_block_x_new[3] = moving_block_x[3] + 5'd1;
							counter_in = 5'd8;
						end
						
					end
					default: rotate_lockout_in = 1'b0;
					
						
				endcase
			end
			
			// AUTO SHIFT COUNTER INCREMENT CASE
			
			// AUTO SHIFT COUNTER EFFECT
			if(counter_counter == 5'd30)
			begin
				if(rotate_lockout_in == 5'b1)
					counter_counter_in = 5'd30;
				else
				begin
					if(moving_block_in)
					begin
						for(int i = 0; i < 4; i++)
						begin
							moving_block_y_new[i] = moving_block_y[i] + 5'd1;
						end
					end
					counter_counter_in = 5'b0;
				end
			end
			
			
			// UPDATE GRID VALUES, LOCATION
			
			for(int i = 0; i < 4; i++)
			begin
				regs_in[moving_block_y_new[i]][moving_block_x_new[i]] = hold_value;
				check = 0;
				for(int j = 0; j < 4; j++)
				begin
					if((moving_block_y[i] == moving_block_y_new[j]) && (moving_block_x[i] == moving_block_x_new[j]))
						check = 1;
				end
				if(check == 0)
					regs_in[moving_block_y[i]][moving_block_x[i]] = 0;
			end
			//check for full lines to clear!
			if(moving_block_in == 3'b0 && slide_counter_in == 0)
			begin
				for(int i = 0; i < 24; i++)
				begin
					clear_line_in = 5'b00000;
					for(int j = 0; j < 18; j++)
					begin
						if(regs_in[i][j] != 0)
							clear_line_in = clear_line_in +1'b1;
						else;
					end
					if(clear_line_in == 5'b10010)
					begin
						//input score increment here.
						for(int j = 0; j < 18; j++)
						begin
							regs_in[i][j] = 0; 
							for(int a = 0; a<i; a++)
							begin
								regs_in[i-a][j] = regs_in[i-a-1][j];
							end
						end

					end
				end
			end
			//OOF
		end
	end
	
	int BlockX, BlockY;
   assign BlockX = DrawX/20 - 7;
   assign BlockY = DrawY/20;
	always_comb
	begin
		if(BlockX < 0 || BlockX > 17)
			pixel_value = 0;
		else
			pixel_value = regs[BlockY][BlockX];
	end
endmodule
