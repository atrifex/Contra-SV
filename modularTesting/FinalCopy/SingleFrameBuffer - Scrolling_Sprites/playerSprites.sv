
module  playerSprites
( 
					input Reset, frame_Clk, 
					input playerDirection,
					input [9:0] DrawX, DrawY, 
					input [9:0] PlayerX,PlayerY,PlayerHeight, PlayerWidth, 
					input [31:0] animationOffset,
					
					output playerOn,	// this is the pixel data that we output ----> encoded bits
					output [31:0] spriteAddress
);
 
parameter rightOffset = 0;
parameter leftOffset = 20736; 
 
logic[31:0] nextSpriteAddress, currSpriteAddress, nextOffset, currOffset;

logic [9:0] playerPixelX, playerPixelY;

logic[4:0] nextPixel, currPixel;

assign playerOn = (DrawX < $unsigned(PlayerX) + $unsigned(PlayerWidth)) && (DrawX > PlayerX)  && (DrawY < $unsigned(PlayerY) + $unsigned(PlayerHeight)) && (DrawY > PlayerY) ? 1'b1 : 1'b0;

//assign spriteAddress = (playerPixelX%24) + (playerPixelY%45)*24;
//(DrawX%24) + (DrawY%45)*24;

assign spriteAddress = currSpriteAddress;
	
always_ff @ (posedge frame_Clk)	
begin
		if(Reset)
			begin
				currSpriteAddress <= 12'b0;
				//currOffset <= rightOffset;
			end
		else
			begin
				currSpriteAddress <= nextSpriteAddress;
				//currOffset <= nextOffset;  
			end
end

always_comb
begin
	nextSpriteAddress = currSpriteAddress;
	
	if(DrawX == PlayerX && DrawY == PlayerY)
	begin
		nextSpriteAddress = animationOffset;	
	end
	else if(playerOn)
	begin
		nextSpriteAddress = (DrawX - PlayerX) + (DrawY - PlayerY)*PlayerWidth + animationOffset;
	end
	
	//if(playerDirection)
end

endmodule
