module pixelLogic
(						
						input Clk, Reset, playerOn,
						input[4:0] playerPixel, backgroundPixel,
						
						output logic [4:0] pixelOut


);


always_ff @(posedge Clk)
begin
	if(Reset)
		pixelOut <= 5'h15;
	else
		begin
			if(playerOn)
			begin
				if(playerPixel != 5'h15)
					pixelOut <= playerPixel;
				else
					pixelOut <= backgroundPixel;
			end
			else
				pixelOut <= backgroundPixel;
		end

end

endmodule
