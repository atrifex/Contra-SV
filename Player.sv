

module  Player 
( 
				input Reset, frame_clk, 	// frame_clk is vertical sync
				input[7:0] 	  keycode,		
				input [1:0]   gameState, 	// makes sure that the player module ignores keycodes if we are not in the play state.
				output [9:0]  PlayerX, PlayerY, PlayerS
);
    
    logic [9:0] Player_X_Pos, Player_X_Motion, Player_Y_Pos, Player_Y_Motion, Player_Size, PlayerXMotionNext, PlayerYMotionNext;
	 
    parameter [9:0] Player_X_Center=320;  // Center position on the X axis
    parameter [9:0] Player_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Player_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Player_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Player_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Player_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Player_X_Step=1;      // Step size on the X axis
    parameter [9:0] Player_Y_Step=1;      // Step size on the Y axis

    assign Player_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Player
        if (Reset)  // Asynchronous Reset
        begin 
            Player_Y_Motion <= 10'd0; //Player_Y_Step;
				Player_X_Motion <= 10'd0; //Player_X_Step;
				Player_Y_Pos <= Player_Y_Center;
				Player_X_Pos <= Player_X_Center;
        end
           
        else 
        begin 
				 				  
				 Player_Y_Motion <= PlayerYMotionNext;  // Player is somewhere in the middle, don't bounce, just keep moving
				 Player_X_Motion <= PlayerXMotionNext;  // Player is somewhere in the middle, don't bounce, just keep moving
				 Player_Y_Pos <= (Player_Y_Pos + Player_Y_Motion);  // Update Player position
				 Player_X_Pos <= (Player_X_Pos + Player_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Player_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Player_Y_pos.  Will the new value of Player_Y_Motion be used,
          or the old?  How will this impact behavior of the Player during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
	 
	 always_comb
	 begin
		PlayerYMotionNext = Player_Y_Motion;
		PlayerXMotionNext = Player_X_Motion;				  
				
	 	case (keycode)
	 	   8'd26: // W
				begin
					if ( (Player_Y_Pos - Player_Size) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
						begin
							PlayerYMotionNext = Player_Y_Step;
							PlayerXMotionNext = 10'd0; 
						end
				else if ( (Player_Y_Pos + Player_Size) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
						begin
							PlayerXMotionNext = 10'd0; 
							PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
						end
				else if ( (Player_X_Pos - Player_Size) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
					  begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = Player_X_Step; 	
					  end
				else if ( (Player_X_Pos + Player_Size) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
				     begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
					  end
				else
					begin 
						PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);
						PlayerXMotionNext = 10'd0;	
					end							
				end 
			8'd04: // A
				begin
					if ( (Player_Y_Pos - Player_Size) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
						begin
							PlayerYMotionNext = Player_Y_Step;
							PlayerXMotionNext = 10'd0; 
						end
				else if ( (Player_Y_Pos + Player_Size) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
						begin
							PlayerXMotionNext = 10'd0; 
							PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
						end
				else if ( (Player_X_Pos - Player_Size) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
					  begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = Player_X_Step; 	
					  end
				else if ( (Player_X_Pos + Player_Size) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
				     begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
					  end
				else
					begin 
						PlayerYMotionNext = 10'd0;
						PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);
					end						
				end 	
	 	   8'd22: // S 
				begin
					if ( (Player_Y_Pos - Player_Size) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
						begin
							PlayerYMotionNext = Player_Y_Step;
							PlayerXMotionNext = 10'd0; 
						end
				else if ( (Player_Y_Pos + Player_Size) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
						begin
							PlayerXMotionNext = 10'd0; 
							PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
						end
				else if ( (Player_X_Pos - Player_Size) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
					  begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = Player_X_Step; 	
					  end
				else if ( (Player_X_Pos + Player_Size) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
				     begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
					  end
				else
					begin 
						PlayerYMotionNext = Player_Y_Step;
						PlayerXMotionNext = 10'd0;
					end	
				end 
	 	   8'd07: // D
				begin
					if ( (Player_Y_Pos - Player_Size) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
						begin
							PlayerYMotionNext = Player_Y_Step;
							PlayerXMotionNext = 10'd0; 
						end
				else if ( (Player_Y_Pos + Player_Size) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
						begin
							PlayerXMotionNext = 10'd0; 
							PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
						end
				else if ( (Player_X_Pos - Player_Size) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
					  begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = Player_X_Step; 	
					  end
				else if ( (Player_X_Pos + Player_Size) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
				     begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
					  end
				else
					begin 
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = Player_X_Step;
					end				
				end
	 	default:
			begin
				if ( (Player_Y_Pos - Player_Size) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
						begin
							PlayerYMotionNext = Player_Y_Step;
							PlayerXMotionNext = 10'd0; 
						end
				else if ( (Player_Y_Pos + Player_Size) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
						begin
							PlayerXMotionNext = 10'd0; 
							PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
						end
				else if ( (Player_X_Pos - Player_Size) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
					  begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = Player_X_Step; 	
					  end
				else if ( (Player_X_Pos + Player_Size) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
				     begin
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
					  end
				else
					begin 
						PlayerYMotionNext = Player_Y_Motion;
						PlayerXMotionNext = Player_X_Motion;
					end		
			end
		endcase
	 end
       
    assign PlayerX = Player_X_Pos;
   
    assign PlayerY = Player_Y_Pos;
   
    assign PlayerS = Player_Size;
    

endmodule
