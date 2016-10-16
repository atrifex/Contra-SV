module pixelLogic
(						
						input Clk, Reset, playerOn, bulletOn1,
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
			else if(bulletOn1)
				pixelOut <= 5'h06;
			else
				pixelOut <= backgroundPixel;
		end

end



endmodule
