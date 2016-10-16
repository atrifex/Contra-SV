


module  playerMovement 
( 
				input	 Clk, Reset, frame_clk, VS, frameCounter_3, Jumping,	// frame_clk is useful
				input logic [3:0]   keycode,		// WILL BE BASED ON PUSH BUTTONS FOR NOW
				input logic keyPress,
				input logic [1:0]   gameState, 	// makes sure that the player module ignores keycodes if we are not in the play state.
				input logic [9:0] platformStart, platformEnd, platformHeight, PlayerHeight, PlayerWidth,
				
				
				output logic[9:0]  PlayerX, PlayerY, 
				output logic[1:0]  Lives,			// will use later
				output logic Direction, onPlatform,
				output logic playerMoving, scrollEnable
);
    
    logic [9:0] Player_X_Pos, Player_X_Motion, Player_Y_Pos, Player_Y_Motion, PlayerHeightNext, PlayerWidthNext /*NEED TO PUT SOMETHING HERE*/, PlayerXMotionNext, PlayerYMotionNext;
	 logic DirectionNext;
	 
    parameter [9:0] Player_X_Start= 30;  			// Center position on the X axis
    parameter [9:0] Player_Y_Start= 168; 			// Center position on the Y axis
    parameter [9:0] Player_X_Restart= 30;			// Center position on the X axis
    parameter [9:0] Player_Y_Restart= 75;			// Center position on the Y axis
	 
    parameter [9:0] Player_X_Min= 20;       		// Leftmost point on the X axis
    parameter [9:0] Player_X_Max=639;     			// Rightmost point on the X axis
    parameter [9:0] Player_Scrolling_Max=320;    	// Rightmost point on the X axis
	 parameter [9:0] Player_Y_Min=0;       			// Topmost point on the Y axis
    parameter [9:0] Player_Y_Max=479;     			// Bottommost point on the Y axis
    parameter [9:0] Player_X_Step=2;      			// Step size on the X axis
    parameter [9:0] Player_Y_Step=2;      			// Step size on the X axis

	 parameter Right = 1'b0;
	 parameter Left  = 1'b1;
	 
	 parameter initialTime = 5'b0;
	 
	 assign onPlatformNext = ((Player_X_Pos + ( PlayerWidth >> 1 ) >= platformStart) && ((Player_X_Pos + (PlayerWidth >> 1 ))<= platformEnd) && ((platformHeight - PlayerY <= PlayerHeight + 4'd12) && (platformHeight - PlayerY >= PlayerHeight - 4'd8))) ? 1'b1 : 1'b0;
	 
	 logic[1:0] gameStateWire, gameStateLogic;
	 logic[4:0] gravityTime, gravityTimeNext;
	 logic onPlatformNext, playerMovingRight, jumpEnable;
	
	 enum logic[1:0] {jumpPressed, jumpWait, jumpEnd} jumpFlag, jumpNext;
	 
	 
	 always_comb
	 begin: Scroll_Enable
			if(Player_X_Pos > Player_Scrolling_Max && playerMovingRight == 1'b1)
				scrollEnable = 1'b1;
			else
				scrollEnable = 1'b0;
	 end 
	 
	 
	 /*
	 always_ff @ (posedge Clk)
	 begin
		gameStateWire <= gameState;
		gameStateLogic <= gameStateWire;
	 end*/
	 
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
				Lives 	 <= 2'b11;		
				onPlatform <= 1'b1;
				jumpFlag <= jumpWait;
        end
        else if ( Player_Y_Pos > Player_Y_Max || Player_X_Pos > Player_X_Max)
        begin 
				Player_Y_Motion <= 10'd0; //Player_Y_Step;
				Player_X_Motion <= 10'd0; //Player_X_Step;
				Player_Y_Pos <= Player_Y_Restart;
				Player_X_Pos <= Player_X_Restart;
				Direction <= Right;											// points Right
				Lives 	 <= 2'b11;		
				onPlatform <= 1'b0;
				jumpFlag <= jumpWait;
        end
		  else
        begin 			  
				 Player_Y_Motion = PlayerYMotionNext; 				 // Player is somewhere in the middle, don't bounce, just keep moving
				 Player_X_Motion = PlayerXMotionNext; 				 // Player is somewhere in the middle, don't bounce, just keep moving
				 Player_Y_Pos <= (Player_Y_Pos + Player_Y_Motion);  // Update Player position
				 Player_X_Pos <= (Player_X_Pos + Player_X_Motion);
				 Direction <= DirectionNext;
				 onPlatform <= onPlatformNext;
				 jumpFlag <= jumpNext;
			end  
		
    end
	 
	always_ff @ (posedge frameCounter_3)
    begin
		if(Reset || onPlatform || Player_Y_Pos > Player_Y_Max || Player_X_Pos > Player_X_Max)
			gravityTime <= 10'b0;
		else
			if(gravityTime >= 3'd6)
				gravityTime <= gravityTime;
			else
				gravityTime <= gravityTimeNext;
	 end
	 
	 
	 // Next State
	 always_comb
	 begin
		jumpNext = jumpFlag;
		
		case(jumpFlag)
		jumpWait:
		begin
			if(Jumping)
				jumpNext = jumpPressed;
		end
		
		jumpPressed: jumpNext = jumpEnd;
		
		jumpEnd:
		begin
			if(~Jumping)
				jumpNext = jumpWait;
		end
		endcase
	 end
	 

	 // Output logic
	 always_comb
	 begin
		jumpEnable = 1'b0;
		
		if(jumpFlag == jumpPressed)
			jumpEnable = 1'b1;	
	 end	

	
	 always_comb
	 begin
		PlayerYMotionNext = Player_Y_Motion;
		PlayerXMotionNext = Player_X_Motion;
		playerMoving = 1'b0;
		playerMovingRight = 1'b0;
		DirectionNext = Direction;
		gravityTimeNext = gravityTime;
		
		if(~keyPress)
		begin
			PlayerXMotionNext = 10'd0; 
			if(onPlatform)
			begin
				PlayerYMotionNext = 10'd0;
				gravityTimeNext = 5'd0;
			end
			else
			begin
				PlayerYMotionNext = gravityTime;
				gravityTimeNext = gravityTime + 2'd3;
				playerMoving = 1'b1;
			end
		end
		//else if(shootingEnable)
		else
			begin
				if(Jumping && onPlatform)
				begin
					PlayerYMotionNext = -70;
					gravityTimeNext = -15;
					playerMoving = 1'b1;
				end
				else
				begin
					case (keycode)
						4'h0: // Waiting PS2 Controller
							begin						
								PlayerXMotionNext = 10'd0; 
								playerMoving = 1'b0;	
								if(onPlatform)
								begin
									PlayerYMotionNext = 10'd0;
									gravityTimeNext = 5'd0;
								end
								else
								begin
									PlayerYMotionNext = gravityTime;
									gravityTimeNext = gravityTime + 2'd3;
									playerMoving = 1'b1;
								end				
							end 
						4'h1: // W - UP - PS2 Controller
							begin						
								PlayerXMotionNext = 10'd0; 
								playerMoving = 1'b0;			
								if(onPlatform)
								begin
									PlayerYMotionNext = 10'd0;
									gravityTimeNext = 5'd0;
								end
								else
								begin
									PlayerYMotionNext = gravityTime;
									gravityTimeNext = gravityTime + 2'd3;
									playerMoving = 1'b1;
								end	
							end 
						//8'h08: // A
						4'h2: // A - Left - PS2
							begin
								DirectionNext = Left;						
								playerMoving = 1'b1;	
								
								if( Player_X_Pos <= Player_X_Min) 
									PlayerXMotionNext = 10'd0; 	
								else							
									PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
									
								if(onPlatform)
								begin
									PlayerYMotionNext = 10'd0;
									gravityTimeNext = 5'd0;
								end
								else
								begin
									PlayerYMotionNext = gravityTime;
									gravityTimeNext = gravityTime + 2'd3;
									playerMoving = 1'b1;
								end		
							end 	
						//8'h04: // S
						4'h3: // S - Down - PS2
							begin
								playerMoving = 1'b0;
								PlayerXMotionNext = 10'd0;
								if(onPlatform)
								begin
									PlayerYMotionNext = 10'd0;
									gravityTimeNext = 5'd0;
								end
								else
								begin
									PlayerYMotionNext = gravityTime;
									gravityTimeNext = gravityTime + 2'd3;
									playerMoving = 1'b1;
								end
							end 
						//8'h01: // D
						4'h4: // D - Right - PS2
							begin
								DirectionNext = Right;
								playerMoving = 1'b1;
								playerMovingRight = 1'b1;
								
								if(Player_X_Pos > Player_Scrolling_Max)
									PlayerXMotionNext = 10'd0; 	
								else
									PlayerXMotionNext = Player_X_Step; 	
									
								if(onPlatform)
								begin
									PlayerYMotionNext = 10'd0;
									gravityTimeNext = 5'd0;
								end
								else
								begin
									PlayerYMotionNext = gravityTime;
									gravityTimeNext = gravityTime + 2'd3;
									playerMoving = 1'b1;
								end
							end
						4'h5 : // WA - UPLEFT - PS2
							begin
								DirectionNext = Left;
								playerMoving = 1'b1;
								
								if( Player_X_Pos <= Player_X_Min) 
									PlayerXMotionNext = 10'd0; 	
								else							
									PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
								
								if(onPlatform)
								begin
									PlayerYMotionNext = 10'd0;
									gravityTimeNext = 5'd0;
								end
								else
								begin
									PlayerYMotionNext = gravityTime;
									gravityTimeNext = gravityTime + 2'd3;
									playerMoving = 1'b1;
								end
							end
						4'h6: // WD - UPRight - PS2
							begin
								DirectionNext = Right;
								playerMoving = 1'b1;
								playerMovingRight = 1'b1;
								
								if(Player_X_Pos > Player_Scrolling_Max)
									PlayerXMotionNext = 10'd0; 	
								else
									PlayerXMotionNext = Player_X_Step; 
								
								if(onPlatform)
								begin
									PlayerYMotionNext = 10'd0;
									gravityTimeNext = 5'd0;
								end
								else
								begin
									PlayerYMotionNext = gravityTime;
									gravityTimeNext = gravityTime + 2'd3;
									playerMoving = 1'b1;
								end
							end
						4'h7: // SA - DownLeft - PS2
							begin
								DirectionNext = Left;	
								playerMoving = 1'b1;
								
								if( Player_X_Pos <= Player_X_Min) 
									PlayerXMotionNext = 10'd0; 	
								else							
									PlayerXMotionNext = (~ (Player_X_Step) + 1'b1);  // 2's complement.
								
								if(onPlatform)
								begin
									PlayerYMotionNext = 10'd0;
									gravityTimeNext = 5'd0;
								end
								else
								begin
									PlayerYMotionNext = gravityTime;
									gravityTimeNext = gravityTime + 2'd3;
									playerMoving = 1'b1;
								end
							end
						4'h8: // SD - DownRight - PS2
							begin
								DirectionNext = Right;
								playerMoving = 1'b1;
								playerMovingRight = 1'b1;
								
								if(Player_X_Pos > Player_Scrolling_Max)
									PlayerXMotionNext = 10'd0; 	
								else
									PlayerXMotionNext = Player_X_Step; 

								if(onPlatform)
								begin
									PlayerYMotionNext = 10'd0;
									gravityTimeNext = 5'd0;
								end
								else
								begin
									PlayerYMotionNext = gravityTime;
									gravityTimeNext = gravityTime + 2'd3;
									playerMoving = 1'b1;
								end
							end
					default:
						begin
							playerMoving = 1'b0;
							PlayerYMotionNext = 10'd0;
							PlayerXMotionNext = 10'd0;
							if(onPlatform)
							begin
								PlayerYMotionNext = 10'd0;
								gravityTimeNext = 5'd0;
							end
							else
							begin
								PlayerYMotionNext = gravityTime;
								gravityTimeNext = gravityTime + 2'd3;
								playerMoving = 1'b1;
							end
							
						end
					endcase
				end
			end
	end
       
	 always_comb
	 begin
		PlayerX = Player_X_Pos;
		if (Jumping && onPlatform)
			PlayerY = Player_Y_Pos + Player_Y_Motion;
		else if(onPlatform)
			PlayerY =  platformHeight - PlayerHeight - 2'd2;
		else if (keycode == 4'h1)
			PlayerY = Player_Y_Pos - 5'd23;
		else if(keycode == 4'h3)
			PlayerY = Player_Y_Pos + 6'd36;
		else
			PlayerY = Player_Y_Pos;
		
	 end
   
    //assign PlayerS = /*NEED TO PUT SOMETHING HERE*/;
    

endmodule
