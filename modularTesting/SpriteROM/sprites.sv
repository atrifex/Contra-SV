
module  sprites 
( 
					input Clk,
					input[10:0]address,		// 11 bits are required to address memory
					
					output[4:0] pixelData	// this is the pixel data that we output ----> encoded bits
);
    
logic [4:0] SpriteRom [0:1079]; 			// test sprite ROM
		// width 5 bits, 1080 address spaces, 3 such banks to store the there different sprites.
		
integer i,h;
//integer sp0, sp1, sp2;

initial
	begin
		//$readmemh("Left.txt", SpriteRom[0]);
		//$readmemh("Left_Up.txt", SpriteRom[1]);
		$readmemh("Right.txt", SpriteRom);				// cant use readmemh to read into multidemensinal memory
		$display("rSpriteRom:");
		for (i=0; i < 1080; i=i+1)
			$display("%d:%h",i,SpriteRom[i]);
		
		
			/*
		sp0 = $fopenr("Left.txt");
		sp1 = $fopenr("Right.txt");
		sp2 = $fopenr("Left_Up.txt");
		
		for( i = 0; i<1080; i = i + 1)
		begin
			rv = $fscanf(sp0, "%h", SpriteRom[0][i]);
			rv = $fscanf(sp1, "%h", SpriteRom[1][i]);
			rv = $fscanf(sp2, "%h", SpriteRom[2][i]);
		end		
		
		sp0 = $fcloser("Left.txt");
		sp1 = $fcloser("Right.txt");
		sp2 = $fcloser("Left_Up.txt");	
		*/	
		
	end

	
	always_ff @ (posedge Clk)
	begin
			pixelData <= SpriteRom[address];
	end
	

endmodule
