
module  FrameCounter
( 	
				input frame_Clk, Reset, VS,
				
				output logic[5:0] FrameCount
);

enum logic[1:0] {VSyncFrontPorch, VSync, VSyncBackPorch} VStateCurr, VStateNext;

logic[5:0] counter;

assign FrameCount = counter;

always_ff @ (posedge frame_Clk)
begin
	if(Reset)
		begin
			counter <= 6'b0;
			VStateCurr <= VSyncFrontPorch; 
		end 
	else
		begin
			VStateCurr <= VStateNext;
			if(counter == 6'b111111)
				counter <= 6'b0;
			else if(VStateCurr == VSync)
				counter <= counter + 6'b000001;
			else
				counter <= counter;				
		end
end

// Next State
always_comb
begin
	VStateNext = VStateCurr;	
	case(VStateCurr)
		VSyncFrontPorch:
			begin
				if(~VS)
					VStateNext = VSync;
			end
		VSync: VStateNext = VSyncBackPorch;
		VSyncBackPorch:
			begin
				if(VS)
					VStateNext = VSyncFrontPorch;
			end
	endcase
end

endmodule
