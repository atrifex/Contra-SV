module platformDetector
(
						input Clk, Reset, blank, VS, onPlatform, ScrollEnable,
						input logic[9:0] DrawX, DrawY, PlayerX, PlayerY, PlayerHeight,
						input logic[4:0] backgroundPixel,

						output logic[9:0] PlatformX1, PlatformX2, PlatformY
);

logic[9:0] PlatformX1Next, PlatformX2Next, PlatformYNext;
logic platformFlag, platformFlagNext;

enum logic[2:0] {PlatformNotSeen, PlatformStart, PlatformWait, PlatformEnd, PlatformSeen} PlatformStateCurr, PlatformStateNext;

always_ff @ (posedge Clk)		// frame clk
begin
	if((Reset == 1'b1) || (VS == 1'b0))
		begin
			PlatformX1 <= PlatformX1Next;
			PlatformX2 <= PlatformX2Next;
			PlatformY  <= PlatformYNext;
			PlatformStateCurr <= PlatformNotSeen;
			platformFlag <= 1'b0;
		end
	else
		begin
			PlatformX1 <= PlatformX1Next;
			PlatformX2 <= PlatformX2Next;
			PlatformY  <= PlatformYNext;
			PlatformStateCurr <= PlatformStateNext;
			platformFlag <= platformFlagNext;
		end
end 

// Next State
always_comb
begin
		PlatformStateNext = PlatformStateCurr;
		if((DrawY >=  PlayerY + PlayerHeight) && platformFlag == 1'b0 && (onPlatform == 1'b0 || ScrollEnable == 1'b1))
		begin
			case(PlatformStateCurr)
			PlatformNotSeen:
			begin
				if((backgroundPixel == 5'h17 || backgroundPixel == 5'h18 ) && blank == 1'b1)
					PlatformStateNext = PlatformStart;
			end
			
			PlatformStart:
			begin
				PlatformStateNext = PlatformWait;
			end
			
			PlatformWait:
			begin
				if((backgroundPixel != 5'h17 && backgroundPixel != 5'h18 ) && blank == 1'b1)
					PlatformStateNext = PlatformEnd;
				else if(DrawX == 9'd500)
					PlatformStateNext = PlatformEnd;
			end
			
			PlatformEnd:
			begin
				PlatformStateNext = PlatformSeen;
			end
			endcase 
		end
end

// Output logic
always_comb
begin
		PlatformX1Next = PlatformX1;
		PlatformX2Next = PlatformX2;
		PlatformYNext  = PlatformY; 
		platformFlagNext = platformFlag;
		
		if((DrawY >= PlayerY + PlayerHeight) && platformFlag == 1'b0 && (onPlatform == 1'b0 || ScrollEnable == 1'b1))
		begin	
			case(PlatformStateCurr)	
			PlatformStart:
			begin
				PlatformYNext = DrawY;
				PlatformX1Next = DrawX - 1'b1;
			end
			
			PlatformEnd:
			begin
				platformFlagNext = 1'b1;
				PlatformX2Next = DrawX - 2'd2;
			end
			endcase 
		end
end
endmodule 