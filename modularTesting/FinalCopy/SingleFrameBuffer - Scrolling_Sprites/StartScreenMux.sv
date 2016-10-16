
module  StartScreenMux 
( 	
				input frame_Clk, Reset,
				input[9:0] DrawX, DrawY,

				input logic[5:0] FrameCount,
				input logic[1:0] gameState,
				input logic[4:0] pixelIn,
				
				output logic[4:0] pixelOut
);

enum logic {Screen1, Screen2} ScreenCurr, ScreenNext;


always_ff @ (posedge frame_Clk)
begin
	if(Reset)
			ScreenCurr <= Screen1;
	else
			ScreenCurr <= ScreenNext;
end

// Next State Logic for Screen
always_comb
begin
	ScreenNext = ScreenCurr;	
	case(ScreenCurr)
		Screen1:
			begin
				if(FrameCount == 6'b111111)
					ScreenNext = Screen2;			
			end
		Screen2:
			begin
				if(FrameCount == 6'b111111)
					ScreenNext = Screen1;			
			end
	endcase
end						


// Output logic:
always_comb
begin
	pixelOut = pixelIn;
	if(ScreenCurr == Screen2 && 90 < DrawX && DrawX < 335 && gameState == 2'b00 && 300 < DrawY && DrawY < 340)
		pixelOut = 5'b0;
end


endmodule
