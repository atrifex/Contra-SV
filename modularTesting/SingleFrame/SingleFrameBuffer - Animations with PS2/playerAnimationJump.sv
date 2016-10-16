module  playerAnimationJump
( 	
				input Reset, moving, frame_Clk, playerDirection, frameCounter_0,
				input [9:0] DrawX, DrawY, 
				input [9:0] PlayerX,PlayerY,
				input [3:0] keycode,
					
				//input logic[1:0] gameState,
				
				output playerOn,	// this is the pixel data that we output ----> encoded bits
				output [20:0] spriteAddress,
				output [9:0] PlayerHeight, PlayerWidth
);

parameter [20:0] initialOffset = 21'd42724;
parameter [9:0] playerHeight = 10'd40;
parameter [9:0] playerWidth = 10'd40;
parameter [20:0] rightOffset = 21'd0;
parameter [20:0] leftOffset = 21'd50620; 



enum logic[3:0] {player1, player2, player3, player4, player5, player6} playerCurr, playerNext;

logic[3:0] counter;
logic [20:0] animationOffset;
logic[31:0] nextSpriteAddress, currSpriteAddress, nextframeOffset, currframeOffset;

assign playerOn = (DrawX <= $unsigned(PlayerX) + $unsigned(playerWidth)) && (DrawX > PlayerX + 1'b1)  && (DrawY < $unsigned(PlayerY) + $unsigned(playerHeight)) && (DrawY >= PlayerY) ? 1'b1 : 1'b0;
assign spriteAddress = currSpriteAddress;
assign PlayerHeight = playerHeight;
assign PlayerWidth = playerWidth;


	
always_ff @ (posedge frame_Clk)	
begin
		if(Reset)
			begin
				currSpriteAddress <= 21'b0; 
				currframeOffset <= rightOffset;
			end
		else
			begin
				currSpriteAddress <= nextSpriteAddress;
				currframeOffset <= nextframeOffset;  
			end
end

always_comb
begin
	nextSpriteAddress = currSpriteAddress;
	nextframeOffset = currframeOffset;
	
	if(playerDirection)
		nextframeOffset = leftOffset;
	else
		nextframeOffset = rightOffset;
	
	if(DrawX == PlayerX && DrawY == PlayerY)
		nextSpriteAddress = animationOffset + currframeOffset;	
	else if(playerOn)
		nextSpriteAddress = (DrawX - PlayerX) + (DrawY - PlayerY)*playerWidth + animationOffset + currframeOffset;
		
end



always_ff @ (posedge frameCounter_0)
begin
	if(Reset)
		begin
			playerCurr <= player1;
			counter <= 4'b0;
		end 
	else
		begin
			playerCurr <= playerNext;
			if(counter == 4'b0011 || ~moving)
				counter <= 4'b0;
			else
				counter <= counter + 1'b1;
			
			unique case(playerCurr)
				player1:
				begin
					animationOffset <= initialOffset;
				end
				
				player2:
				begin
					animationOffset <= initialOffset + playerHeight*playerWidth*1;
				end
				
				player3:
				begin
					animationOffset <= initialOffset + playerHeight*playerWidth*2;
				end
				
				player4:
				begin
					animationOffset <= initialOffset + playerHeight*playerWidth*3;
				end
				
				player5:
				begin
					animationOffset <= initialOffset + playerHeight*playerWidth*2;
				end
				
				player6:
				begin
					animationOffset <= initialOffset + playerHeight*playerWidth*1;
				end
				
				default:
				begin
					animationOffset <= initialOffset;
				end
			endcase
					
		end
end



always_comb
begin
	playerNext = playerCurr;
	unique case(playerCurr)
	player1:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player2;
		else if(~moving)
			playerNext = player1;
	end
	
	player2:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player3;
		else if(~moving)
			playerNext = player1;
	end
	
	player3:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player4;
		else if(~moving)
			playerNext = player1;
	end
	
	player4:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player5;
		else if(~moving)
			playerNext = player1;
	end
	
	player5:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player6;
		else if(~moving)
			playerNext = player1;
	end
	
	player6:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player1;
		else if(~moving)
			playerNext = player1;
	end
	endcase

end
endmodule 