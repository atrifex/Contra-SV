
module  FrameBuffer 
( 
					input Clk, Reset, VS, HS,
					input[1:0] gameState,
					input[18:0] readAddress,		// 11 bits are required to address memory
					input[18:0] writeAddress,		// 11 bits are required to address memory

					output[4:0] pixelData	// this is the pixel data that we output ----> encoded bits
);
    
logic [4:0] TopFrame [0:307199]; 			// test sprite ROM
logic [4:0] BottomFrame[0:307199]; 			// test sprite ROM
logic [15:0] colorCounter;

logic[18:0] startAddress;

logic[13:0] startCounter;						// start counter to work with initial image

		// width 5 bits, 1080 address spaces, 3 such banks to store the there different sprites.
		
integer i;
//integer sp0, sp1, sp2;

initial
begin
		$readmemh("SpriteText/contraStart.txt", TopFrame);				// cant use readmemh to read into multidemensinal memory
		/*
		$display("TopFrame:");
		for (i=0; i < 307200; i=i+1)
			$display("%d:%h",i,TopFrame[21980 + i]);
		*/
		
		$readmemh("SpriteText/contraStart1.txt", BottomFrame);				// cant use readmemh to read into multidemensinal memory
		/*
		$display("BottomFrame:");
		for (i=0; i < 307200; i=i+1)
			$display("%d:%h",i,BottomFrame[21980 + i]);
		*/
end
	

always_ff @ (posedge Clk)
begin
	if(Reset)
	begin
		startCounter <= 14'b0;	
		startAddress <= 19'b0;
		pixelData <= 5'h00;
		colorCounter <= 16'b0000;
	end
	else
	begin
		if(gameState == 2'b00 && VS == 1'b0)
			startCounter <= startCounter + 14'b000001;
		else
			startCounter <= startCounter;
		
		if(VS || HS)
		begin
			startAddress <= startAddress + 19'b00001;
			if(startCounter[13] == 1'b0)
				pixelData <= TopFrame[startAddress];
			else
				pixelData <= BottomFrame[startAddress];
		end
		else if(gameState == 2'b01)							// if we are in the play state
		begin
			if(pixelData == 5'h15 || VS ==  1'b0)
				begin
					pixelData <= 5'h00;
					colorCounter <= 16'b0000;
				end
			else if(colorCounter == 16'h36B0)
				begin
					pixelData <= pixelData + 5'h01;
					colorCounter <= 16'b0000;
				end
			else
				colorCounter <= colorCounter + 16'b0001;
		end
		else
			pixelData <= 5'b0;
	end
end

/*
always_comb
begin
	
	case(gameState)
	2'b00: 
	begin
		
			
	end
	
	2'b01:
	
	2'b10:
	
	endcase
end

always_comb
begin





end

*/

endmodule
