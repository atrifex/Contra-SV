


module  playerMovement 
( 
				input	 Clk, Reset, frame_clk, VS, 	// frame_clk is useful
				input logic[7:0]   keycode,		// WILL BE BASED ON PUSH BUTTONS FOR NOW
				input logic keyPress,
				input logic [1:0]   gameState, 	// makes sure that the player module ignores keycodes if we are not in the play state.
				
				
				output logic[9:0]  PlayerX, PlayerY, 
				output logic[1:0]  Lives,			// will use later
				output logic Direction,
				output logic playerMoving
);
    
    logic [9:0] Player_X_Pos, Player_X_Motion, Player_Y_Pos, Player_Y_Motion, PlayerHeightNext, PlayerWidthNext /*NEED TO PUT SOMETHING HERE*/, PlayerXMotionNext, PlayerYMotionNext;
	 logic DirectionNext;
	 
    parameter [9:0] Player_X_Start= 30;  // Center position on the X axis
    parameter [9:0] Player_Y_Start= 168;  // Center position on the Y axis
	 
    parameter [9:0] Player_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Player_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Player_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Player_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Player_X_Step=2;      // Step size on the X axis
    parameter [9:0] Player_Y_Step=2;      // Step size on the X axis

	 parameter Right = 1'b0;
	 parameter Left  = 1'b1;
	 
	 logic[1:0] gameStateWire, gameStateLogic;
	 
	 always_ff @ (posedge Clk)
	 begin
		gameStateWire <= gameState;
		gameStateLogic <= gameStateWire;
	 end
	 
	 // WILL NEED TO CHANGE THIS SO THAT WE CAN DO JUMP
	 // parameter [9:0] Player_Y_Step=1;      // Step size on the Y axis

	 logic resetLogic, gameLogic;
	 //assign gameLogic = (gameStateLogic == 2'b01)? 1'b0 : 1'b1;
	 //assign resetLogic = (Reset | gameLogic)? 1'b1 : 1'b0;
   
    always_ff @ (posedge Reset or posedge VS )
    begin: Move_Player
        if (Reset)  // Asynchronous Reset
        begin 
				Player_Y_Motion <= 10'd0; //Player_Y_Step;
				Player_X_Motion <= 10'd0; //Player_X_Step;
				Player_Y_Pos <= Player_Y_Start;
				Player_X_Pos <= Player_X_Start;
				Direction <= Right;											// points Right
				Lives 	 <= 2'b11;											// three lives to start with
        end
        else 
        begin 			  
				 Player_Y_Motion <= PlayerYMotionNext; 				 // Player is somewhere in the middle, don't bounce, just keep moving
				 Player_X_Motion <= PlayerXMotionNext; 				 // Player is somewhere in the middle, don't bounce, just keep moving
				 Player_Y_Pos <= (Player_Y_Pos + Player_Y_Motion);  // Update Player position
				 Player_X_Pos <= (Player_X_Pos + Player_X_Motion);
				 Direction <= DirectionNext;
			end  
			
			
    end
	 
	 always_comb
	 begin
		PlayerYMotionNext = Player_Y_Motion;
		PlayerXMotionNext = Player_X_Motion;
		playerMoving = 1'b0;
		DirectionNext = Direction;
		
		if(keyPress == 0)
		begin
			PlayerYMotionNext = 10'd0;
			PlayerXMotionNext = 10'd0; 
		end
		else
		begin
			case (keycode)
				//8'h02: // W - UP - KEY[3:0]
				8'h1D: // W - UP - PS2 Controller
					begin						
						PlayerYMotionNext = 10'd0;
						PlayerXMotionNext = 10'd0; 
						
						playerMoving = 1'b0;
						/*
						if ( (Player_Y_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
							begin
								PlayerYMotionNext = Player_Y_Step;
								PlayerXMotionNext = 10'd0; 
								end
						else if ( (Player_Y_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
								begin
									PlayerXMotionNext = 10'd0; 
									PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
								end
						else if ( (Player_X_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
							begin
								PlayerYMotionNext = 10'd0;	
								PlayerXMotionNext = Player_X_Step; 	
							end
						else if ( (Player_X_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
							begin
								PlayerYMotionNext = 10'd0;	
								PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
							end
						else
							begin 
								PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);
								PlayerXMotionNext = 10'd0;	
							end*/						
					end 
				//8'h08: // A
				8'h1C: // A - PS2
					begin
						DirectionNext = Left;
						
						
						playerMoving = 1'b1;
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
						/*
						if ( (Player_Y_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
							begin
								PlayerYMotionNext = Player_Y_Step;
								PlayerXMotionNext = 10'd0; 
							end
					else if ( (Player_Y_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
							begin
								PlayerXMotionNext = 10'd0; 
								PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
							end
					else if ( (Player_X_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
						begin
							PlayerYMotionNext = 10'd0;	
							PlayerXMotionNext = Player_X_Step; 	
						end
					else if ( (Player_X_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
						begin
							PlayerYMotionNext = 10'd0;	
							PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
						end
					else
						begin 
							PlayerYMotionNext = 10'd0;
							PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);
						end		*/				
					end 	
				//8'h04: // S
				8'h1B: // S = PS2
					begin
						playerMoving = 1'b0;
						
						PlayerYMotionNext = 10'd0;
						PlayerXMotionNext = 10'd0; 
						/*
						if ( (Player_Y_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
							begin
								PlayerYMotionNext = Player_Y_Step;
								PlayerXMotionNext = 10'd0; 
							end
					else if ( (Player_Y_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
							begin
								PlayerXMotionNext = 10'd0; 
								PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
							end
					else if ( (Player_X_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
						begin
							PlayerYMotionNext = 10'd0;	
							PlayerXMotionNext = Player_X_Step; 	
						end
					else if ( (Player_X_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
						begin
							PlayerYMotionNext = 10'd0;	
							PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
						end
					else
						begin 
							PlayerYMotionNext = Player_Y_Step;
							PlayerXMotionNext = 10'd0;
						end	*/
					end 
				//8'h01: // D
				8'h23: // D - PS2
					begin
						
						PlayerYMotionNext = 10'd0;	
						PlayerXMotionNext = Player_X_Step; 	
						DirectionNext = Right;
					
						playerMoving = 1'b1;
					/*
						if ( (Player_Y_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
							begin
								PlayerYMotionNext = Player_Y_Step;
								PlayerXMotionNext = 10'd0; 
							end
					else if ( (Player_Y_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
							begin
								PlayerXMotionNext = 10'd0; 
								PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
							end
					else if ( (Player_X_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
						begin
							PlayerYMotionNext = 10'd0;	
							PlayerXMotionNext = Player_X_Step; 	
						end
					else if ( (Player_X_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
						begin
							PlayerYMotionNext = 10'd0;	
							PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
						end
					else
						begin 
							PlayerYMotionNext = 10'd0;	
							PlayerXMotionNext = Player_X_Step;
						end		*/		
					end
			default:
				begin
					
					playerMoving = 1'b0;
					PlayerYMotionNext = 10'd0;
					PlayerXMotionNext = 10'd0;
				
					/*
					if ( (Player_Y_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_Y_Min )  // Player is at the top edge, BOUNCE!
							begin
								PlayerYMotionNext = Player_Y_Step;
								PlayerXMotionNext = 10'd0; 
							end
					else if ( (Player_Y_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_Y_Max )  // Player is at the bottom edge, BOUNCE!
							begin
								PlayerXMotionNext = 10'd0; 
								PlayerYMotionNext = (~ (Player_Y_Step) + 1'b1);  // 2's complement.
							end
					else if ( (Player_X_Pos - /*NEED TO PUT SOMETHING HERE) <= Player_X_Min )  // Player is at the left edge, BOUNCE!
						begin
							PlayerYMotionNext = 10'd0;	
							PlayerXMotionNext = Player_X_Step; 	
						end
					else if ( (Player_X_Pos + /*NEED TO PUT SOMETHING HERE) >= Player_X_Max )  // Player is at the right edge, BOUNCE!
						begin
							PlayerYMotionNext = 10'd0;	
							PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
						end
					else
						begin 
							PlayerYMotionNext = Player_Y_Motion;
							PlayerXMotionNext = Player_X_Motion;
						end*/	
				end
			endcase
		end
	 end
       
    assign PlayerX = Player_X_Pos;
   
    assign PlayerY = Player_Y_Pos;
   
    //assign PlayerS = /*NEED TO PUT SOMETHING HERE*/;
    

endmodule
