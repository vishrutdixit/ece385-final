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

   // Creating grid
   always_comb
   begin

   // Color outline of grid: squares are 18 x 18 pixels
		if(
            (DrawX > 10'd60 && DrawX < 10'd260 && DrawY > 10'd40 && DrawY < 10'd440 && DrawX % 10'd20 <= 1)      || // left playboard                                                                          ||
            (DrawX > 10'd60 && DrawX < 10'd260 && DrawY > 10'd40 && DrawY < 10'd440 && DrawY % 10'd20 <= 1)      ||
            (DrawX > 10'd380 && DrawX < 10'd580 && DrawY > 10'd40 && DrawY < 10'd440 && DrawX % 10'd20 <= 1)     || // right playboard                                                                          ||
            (DrawX > 10'd380 && DrawX < 10'd580 && DrawY > 10'd40 && DrawY < 10'd440 && DrawY % 10'd20 <= 1)     ||
            (DrawX > 10'd20 && DrawX < 10'd60 && DrawY < 10'd80 && DrawY > 10'd40 && DrawX % 10'd10 == 0)       || // left hold grid
            (DrawX > 10'd20 && DrawX < 10'd60 && DrawY < 10'd80 && DrawY > 10'd40 && DrawY % 10'd10 == 0)       ||
            (DrawX > 10'd340 && DrawX < 10'd380 && DrawY < 10'd80 && DrawY > 10'd40 && DrawX % 10'd10 == 0)     || // right hold grid
            (DrawX > 10'd340 && DrawX < 10'd380 && DrawY < 10'd80 && DrawY > 10'd40 && DrawY % 10'd10 == 0)     ||
            (DrawX > 10'd260 && DrawX < 10'd300 && DrawY < 10'd240 && DrawY > 10'd40 && DrawX % 10'd10 == 0)    || // left upcoming
            (DrawX > 10'd260 && DrawX < 10'd300 && DrawY < 10'd240 && DrawY > 10'd40 && DrawY % 10'd10 == 0)    ||
            (DrawX > 10'd580 && DrawX < 10'd620 && DrawY < 10'd240 && DrawY > 10'd40 && DrawX % 10'd10 == 0)    || // right upcoming
            (DrawX > 10'd580 && DrawX < 10'd620 && DrawY < 10'd240 && DrawY > 10'd40 && DrawY % 10'd10 == 0)
            )
		begin
			Red = 8'd34;
			Green = 8'd47;
			Blue = 8'd59;
		end

    // Color inactive regions of board
		else if(
                (DrawY < 10'd40)                                            || // upper most
                (DrawY > 10'd440)                                           || // lower most
                (DrawX < 10'd20)                                            || // left most
                (DrawX > 10'd620)                                           || // right most
                (DrawY > 10'd80 && DrawX < 10'd60)                          || // left most under hold
                (DrawX > 10'd300 && DrawX < 10'd340)                        || // middle region
                (DrawY > 10'd240 && DrawX > 10'd580)                        || // bottom right
                (DrawX > 10'd300 && DrawX < 10'd380 && DrawY > 10'd80)      || // under hold on right side
                (DrawX > 10'd260 && DrawX < 10'd380 && DrawY > 10'd240)        // under upcoming on left side
                )
		begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end

    // Different regions
		else
		begin
			unique case(pixel_value)
				3'd0: begin // BLANK
					Red = 8'd38;
					Green = 8'd57;
					Blue = 8'd61;
				end

				3'd1: begin // TRI, light blue
                    Red = 8'd0;
					Green = 8'd238;
					Blue = 8'd60;
				end

				3'd2: begin // reverse L, yellow
                    Red = 8'd222;
					Green = 8'd217;
					Blue = 8'd24;
				end

				3'd3: begin // L, purple
                    Red = 8'd173;
					Green = 8'd32;
					Blue = 8'd222;
				end

				3'd4: begin // Square, blue
                    Red = 8'd4;
					Green = 8'd82;
					Blue = 8'd228;
				end

				3'd5: begin //rightface S, orange
                    Red = 8'd234;
					Green = 8'd110;
					Blue = 8'd5;
				end

				3'd6: begin // leftface S, red
                    Red = 8'd236;
					Green = 8'd5;
					Blue = 8'd40;
				end

				3'd7: begin // 4-Block, green
					Red = 8'd0;
					Green = 8'd255;
					Blue = 8'd255;
				end
			endcase
		end
	end
endmodule
