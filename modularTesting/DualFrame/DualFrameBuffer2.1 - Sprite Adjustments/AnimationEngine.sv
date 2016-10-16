module  AnimationEngine 
( 	
				input frame_Clk, Reset, VS,
				input[9:0] DrawX, DrawY,

				input logic[1:0] gameState,
				input logic[4:0] pixelIn,
				
				output logic[4:0] pixelOut
);

endmodule 