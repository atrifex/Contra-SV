
module  FrameBuffer 
( 
					input Clk, Reset, frame_Clk, VS,
					input[9:0] DrawX, DrawY,
					
					input [4:0] pixelIn,		// 
					output[4:0] pixelOut			// this is the pixel data that we output ----> encoded bits
);
 
enum logic[1:0] {Read_Write, SwappedRead_Write, Swap, SwapBack} frameStateCurr, frameStateNext;
 

logic [4:0] TopFrame[0:1079]; 				// Frame buffer through the use of onchip memory
logic [4:0] BottomFrame [0:1079]; 				// Frame buffer through the use of onchip memory

// We could initialize it ----> or we can have an initialize state that takes care of it in hardware	

logic[4:0] frameOut, pixelWrite, lastPixel; 		// based on pixelIn and last value, we decide what we need to write.
logic readWriteSelect; 
logic[31:0] Address;

assign Address = DrawX + DrawY*24;

Register5Bits frameRegister(.Clk(frame_Clk), .Reset(Reset), .Load(readWriteSelect),.Data_In(frameOut), .Data_Out(pixelOut));

always_ff @ (posedge Clk)
begin
	if(Reset)
		begin
			frameStateCurr <= Read_Write;
			frameOut <= 5'b0;
		end
	else
		begin
			frameStateCurr <= frameStateNext;
			if(DrawX < 24 && DrawY < 45)
			begin
				if(frameStateCurr == Read_Write && readWriteSelect == 1'b1)
					begin
						frameOut <= TopFrame[Address];
						BottomFrame[Address] <= pixelWrite;
					end
				else if(frameStateCurr == SwappedRead_Write && readWriteSelect == 1'b1) 
					begin
						frameOut <= BottomFrame[Address];
						TopFrame[Address] <= pixelWrite;
					end
				else
					begin
						BottomFrame[Address] <= BottomFrame[Address];
						TopFrame[Address] <= TopFrame[Address];
						frameOut <= 5'b00;
					end
			end
			else 
				frameOut <= 5'b0;
		end
end

// next state logic
always_comb
begin
	frameStateNext = frameStateCurr;
	case(frameStateCurr)
		Read_Write:	 
			begin
				if(VS)
					frameStateNext = Read_Write; 
				else
					frameStateNext = Swap;
			end
		Swap:
			begin
				if(VS)
					frameStateNext = SwappedRead_Write;
			end
		SwappedRead_Write:
			begin
				if(VS)
						frameStateNext = SwappedRead_Write; 
				else
						frameStateNext = SwapBack;
			end
		SwapBack:
			begin
				if(VS)
					frameStateNext = Read_Write;
			end
	endcase
end

//output logic
always_comb
begin
	if(Read_Write == frameStateCurr || frameStateCurr == SwappedRead_Write)
		readWriteSelect = 1'b1;
	else
		readWriteSelect = 1'b0;		
end


always_comb
begin
	if(pixelIn == 5'h15)
		pixelWrite = pixelOut;
	else
		pixelWrite = pixelIn;
end

endmodule

/*
always_ff @ (negedge Clk)
begin
	if(DrawX < 640 && DrawY < 480)
		Frame[Address-1]<= pixelWrite;
	else
		Frame[Address-1]<=Frame[Address-1];
end

always_ff @ (posedge Clk)
begin
	if(DrawX < 640 && DrawY < 480)
	begin
		pixelOut <= Frame[Address];
	end
	else
		pixelOut <= 5'b0;
end

// choosing which pixel to write
always_comb
begin
	if(pixelIn == 5'h15)
		pixelWrite = pixelOut;
	else
		pixelWrite = pixelIn;
end
*/