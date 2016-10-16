module  playerAnimationDown
( 	
				input Reset, moving, frame_Clk, playerDirection,
				input [9:0] DrawX, DrawY, 
				input [9:0] PlayerX,PlayerY,
				input [3:0] keycode,
					
				//input logic[1:0] gameState,
				
				output playerOn,	// this is the pixel data that we output ----> encoded bits
				output [20:0] spriteAddress,
				output [9:0] PlayerHeight, PlayerWidth
);

parameter [20:0] initialOffset = 21'd21680;
parameter [9:0] playerHeight = 10'd34;
parameter [9:0] playerWidth = 10'd68;
parameter [20:0] rightOffset = 21'd0;
parameter [20:0] leftOffset = 21'd50620; 
 
logic[31:0] nextSpriteAddress, currSpriteAddress, nextframeOffset, currframeOffset;

assign playerOn = (DrawX <= $unsigned(PlayerX) + $unsigned(PlayerWidth)) && (DrawX > PlayerX + 1'b1)  && (DrawY < $unsigned(PlayerY) + $unsigned(PlayerHeight)) && (DrawY >= PlayerY) ? 1'b1 : 1'b0;
assign spriteAddress = currSpriteAddress;
assign PlayerHeight = playerHeight;
assign PlayerWidth = playerWidth;
	
always_ff @ (posedge frame_Clk)	
begin
		if(Reset || keycode != 4'h3)
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
		nextSpriteAddress = initialOffset + currframeOffset;	
	else if(playerOn)
		nextSpriteAddress = (DrawX - PlayerX) + (DrawY - PlayerY)*PlayerWidth + initialOffset + currframeOffset;
		
end

endmodule 