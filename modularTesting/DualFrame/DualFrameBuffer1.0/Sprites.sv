
module  Sprites 
( 
					input Clk,
					input[9:0] DrawX, DrawY,
					
					output[4:0] pixelData	// this is the pixel data that we output ----> encoded bits
);
    
logic [4:0] SpriteRom [0:1079]; 			// test sprite ROM
		// width 5 bits, 1080 address spaces, 3 such banks to store the there different sprites.
		
logic[31:0] Address;

assign Address = DrawX + DrawY*24;

 
integer i;
//integer sp0, sp1, sp2;

initial
	begin
	    $readmemh("SpriteText/Right.txt", SpriteRom);
	end

	
	always_ff @ (posedge Clk)	
	begin
			if(DrawX < 24 && DrawY < 45)
				pixelData <= SpriteRom[Address];
	end
	
	
	
endmodule
