//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input [2:0] pixel_value,            // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
	 
	 
	 
	 logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
   assign VGA_R = Red;
   assign VGA_G = Green;
   assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
   always_comb
   begin
		if(DrawX % 10'd20 == 0 || DrawX % 10'd20 == 1 || DrawY % 10'd20 == 0 || DrawY % 10'd20 == 1)
		begin
			Red = 8'd34;
			Green = 8'd47;
			Blue = 8'd59;
		end
		else if(DrawX < 10'd140 || DrawX > 10'd500)
		begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else
		begin
			unique case(pixel_value)
				3'd0: begin // BLANK
					Red = 8'd38;
					Green = 8'd57;
					Blue = 8'd61;
				end
				
				3'd1: begin // TRI, YELLOW
					Red = 8'd222;
					Green = 8'd217;
					Blue = 8'd24;
				end
				
				3'd2: begin // reverse L, PURPLE
					Red = 8'd173;
					Green = 8'd32;
					Blue = 8'd222;
				end
				
				3'd3: begin // L, BLUE
					Red = 8'd4;
					Green = 8'd82;
					Blue = 8'd228;
				end
				
				3'd4: begin // Square, ORANGE
					Red = 8'd234;
					Green = 8'd110;
					Blue = 8'd5;
				end
				
				3'd5: begin //rightface S, RED
					Red = 8'd236;
					Green = 8'd5;
					Blue = 8'd40;
				end
				
				3'd6: begin // leftface S, GREEN
					Red = 8'd0;
					Green = 8'd238;
					Blue = 8'd60;
				end
				
				3'd7: begin // 4-Block, LIGHTBLUE
					Red = 8'd0;
					Green = 8'd255;
					Blue = 8'd255;
				end
			endcase
		end
	end
endmodule
