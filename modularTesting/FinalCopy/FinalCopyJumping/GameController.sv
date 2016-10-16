//-------------------------------------------------------------------------
//      Mem2IO.vhd                                                       --
//      Stephen Kempf                                                    --
//                                                                       --
//      Revised 03-15-2006                                               --
//              03-22-2007                                               --
//              07-26-2013                                               --
//              03-04-2014                                               --
//                                                                       --
//      For use with ECE 385 Experiment 6                                --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  GameController ( 	input logic Clk, Reset,
							input logic[5:0] keycode,
							input logic playerDead,
							
							output logic[1:0] gameState
						);
						
						
enum logic[1:0] {Start, Play, GameOver} gameStateCurr, gameStateNext;

always_ff @ (posedge Clk)
begin
	if(Reset)
		gameStateCurr <= Start;
	else
		gameStateCurr <= gameStateNext;
end

// Next State Logic
always_comb
begin
	gameStateNext = gameStateCurr; 
	
	unique case(gameStateCurr)
	Start:
		begin
			if(keycode)
				gameStateNext = Play;
		end	
	Play:
		begin
			if(playerDead)
				gameStateNext = GameOver;
		end
	GameOver:
		begin
			if(keycode)
				gameStateNext = Play;
		end
		
	endcase
end

//Output Logic

always_comb
begin
	unique case(gameStateCurr)
	
	Start:		gameState = 2'b00; 		// Starting state
			
	Play:			gameState = 2'b01; 		// Play state
		
	GameOver: 	gameState = 2'b10; 		// GameOverState state	
		
	endcase	

end

endmodule
