
module  StartScreenMux 
( 	
				input frame_Clk, Reset, VS,
				input[9:0] DrawX, DrawY,

				input logic[1:0] gameState,
				input logic[4:0] pixelIn,
				
				output logic[4:0] pixelOut
);

enum logic {Screen1, Screen2} ScreenCurr, ScreenNext;
enum logic[1:0] {VSyncFrontPorch, VSync, VSyncBackPorch} VStateCurr, VStateNext;

logic[5:0] counter;

always_ff @ (posedge frame_Clk)
begin
	if(Reset)
		begin
			ScreenCurr <= Screen1;
			counter <= 6'b0;
			VStateCurr <= VSyncFrontPoarch; 
		end 
	else
		begin
			ScreenCurr <= ScreenNext;
			VStateCurr <= VStateNext;
			if(counter == 6'b111111)
				counter <= 6'b0;
			else if(VStateCurr == VSync)
				counter <= counter + 6'b000001;
			else
				counter <= counter;				
		end
end

// Next State Logic for Screen
always_comb
begin
	ScreenNext = ScreenCurr;	
	case(ScreenCurr)
		Screen1:
			begin
				if(counter == 6'b111111)
					ScreenNext = Screen2;			
			end
		Screen2:
			begin
				if(counter == 6'b111111)
					ScreenNext = Screen1;			
			end
	endcase
end						

// Next State logic for VState
always_comb
begin
	VStateNext = VStateCurr;	
	case(VStateCurr)
		VSyncFrontPoarch:
			begin
				if(~VS)
					VStateNext = VSync;
			end
		VSync: VStateNext = VSyncBackPoarch;
		VSyncBackPoarch:
			begin
				if(VS)
					VStateNext = VSyncFrontPoarch;
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
