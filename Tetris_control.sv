module Tetris_control (input logic Clk, Reset, output logic [1:0] game_over_menu, input logic key, game_over);

	enum logic [1:0] { Menu, Game, Over}   State, Next_state;   // Internal state logic
	//1 is game over
	//0 is menu
	logic [1:0] game_over_menu_in;
	
	always_ff @ (posedge Clk)
	begin
			if(Reset)
			begin
				State <= Menu;
				game_over_menu[1] <= 0;
				game_over_menu[0] <= 1;
			end
			else
			begin
				State <= Next_state;
				game_over_menu <= game_over_menu_in;
			end
	end
   
	always_comb
	begin 
		Next_state = State;
		game_over_menu_in = game_over_menu;
		unique case(Next_state)
			Menu:begin
				if(game_over_menu_in[0] == 1'b0)
					Next_state = Game;
				else
					Next_state = Menu;
				end
			Game:begin
					if(game_over==1'b1)
						Next_state = Over;
					else
						Next_state = Game;
				end
			Over:begin
					Next_state = Over;
				end
			default:;
		endcase
		
		case(Next_state)
		Menu:
		begin
		if(key)
			game_over_menu_in[0] = 0;
		else
			game_over_menu_in[0] = 1;
		end
		Game:
		begin
		end
		
		Over:
		begin
			game_over_menu_in[1] = 1;
		end
		default:;
		endcase
		
	end 


	
endmodule
