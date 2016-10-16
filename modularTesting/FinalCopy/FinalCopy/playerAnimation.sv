module  playerAnimation
( 	
				input Reset, frameCounter_0, moving,
				
				input[9:0] playerHeight, playerWidth,

				//input logic[1:0] gameState,
				
				output logic [31:0] animationOffset
);

enum logic[5:0] {player1, player2, player3, player4, player5, player6, player7, player8, playerWait} playerCurr, playerNext;
enum logic[3:0] {playerRight, playerLeft, playerJump, playerShootRight, playerShootLeft, player} playerMovementCurr, playerMovementNext;

logic[3:0] counter;
logic [1:0] playerMovementCounter;

parameter waitOffset = 3264;

always_ff @ (posedge frameCounter_0)
begin
	if(Reset)
		begin
			playerCurr <= playerWait;
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
				playerWait:
				begin
					animationOffset <= 32'b0;
				end
			
				player1:
				begin
					animationOffset <= waitOffset + playerHeight*playerWidth*0;
				end
				
				player2:
				begin
					animationOffset <= waitOffset + playerHeight*playerWidth*1;
				end
				
				player3:
				begin
					animationOffset <= waitOffset + playerHeight*playerWidth*2;
				end
				
				player4:
				begin
					animationOffset <= waitOffset + playerHeight*playerWidth*3;
				end
				
				player5:
				begin
					animationOffset <= waitOffset + playerHeight*playerWidth*4;
				end
				
				player6:
				begin
					animationOffset <= waitOffset + playerHeight*playerWidth*3;
				end
				
				player7:
				begin
					animationOffset <= waitOffset + playerHeight*playerWidth*2;
				end
				
				player8:
				begin
					animationOffset <= waitOffset + playerHeight*playerWidth*1;
				end
				default:
				begin
					animationOffset <= 32'b0;
				end
			endcase
					
		end
end



always_comb
begin
	playerNext = playerCurr;
	unique case(playerCurr)
	playerWait:
	begin
		if(moving)
			playerNext = player1;
	end

	
	player1:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player2;
		else if(~moving)
			playerNext = playerWait;
	end
	
	player2:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player3;
		else if(~moving)
			playerNext = playerWait;
	end
	
	player3:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player4;
		else if(~moving)
			playerNext = playerWait;
	end
	
	player4:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player5;
		else if(~moving)
			playerNext = playerWait;
	end
	
	player5:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player6;
		else if(~moving)
			playerNext = playerWait;
	end
	
	player6:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player7;
		else if(~moving)
			playerNext = playerWait;
	end
	
	player7:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player8;
		else if(~moving)
			playerNext = playerWait;
	end
	
	player8:
	begin
		if(counter == 4'b0011 && moving)
			playerNext = player1;
		else if(~moving)
			playerNext = playerWait;
	end
	endcase

end

endmodule 