module FramePtrRegister 
(				
						input Clk, Reset, ScrollEnable,
						output logic [12:0]  FramePtr
);

always_ff @ (posedge Clk or posedge Reset) // sequential logic
begin
   if (Reset) 
			FramePtr <= 13'd0; // parallel out of 0 
	else if(ScrollEnable)
			if(!(FramePtr >= 13'd3473))
				FramePtr <= FramePtr + 1'd1;
//	else
	//		FramePtr <= FramePtr;
end

endmodule


