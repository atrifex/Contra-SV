
module  FrameBuffer 
( 
					input Clk, Reset, frame_Clk, VS,
					input[9:0] DrawX, DrawY,
					
					input [4:0] pixelIn,		// 
					output[4:0] pixelOut			// this is the pixel data that we output ----> encoded bits
);
 
enum logic[1:0] {Read_Write, SwappedRead_Write, Swap, SwapBack} frameStateCurr, frameStateNext;
 

// We could initialize it ----> or we can have an initialize state that takes care of it in hardware	

logic[4:0] frameOut, pixelWrite, topOut, bottomOut; 		// based on pixelIn and last value, we decide what we need to write.
logic readWriteSelect, CE; 
logic[31:0] Address;

assign Address = DrawX + DrawY*640;


//Register5Bits frameRegister(.Clk(frame_Clk), .Reset(Reset),.Data_In(frameOut), .Data_Out(pixelOut));

frameRAM TopFrame(.Clk(Clk),.we(readWriteSelect&CE), .data_In(pixelIn), .write_address(Address),.read_address(Address),.data_Out(topOut));
frameRAM BottomFrame(.Clk(Clk), .we((~readWriteSelect)&CE), .data_In(pixelIn), .write_address(Address),.read_address(Address),.data_Out(bottomOut));



always_ff @ (posedge Clk)
begin
	if(Reset)
		frameStateCurr<= Read_Write;
	else
		frameStateCurr <= frameStateNext;
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
	CE = 1'b1;
	readWriteSelect = 1'b0;
	pixelOut = topOut;

	
	if(Read_Write == frameStateCurr)
		begin
			readWriteSelect = 1'b1;
			pixelOut = topOut;
		end
	else if (SwappedRead_Write == frameStateCurr)
		begin
			readWriteSelect = 1'b0;
			pixelOut = bottomOut;
		end
	else
		CE = 0;
end


always_comb
begin
	if(pixelIn == 5'h15)
		pixelWrite = pixelOut;
	else
		pixelWrite = pixelIn;
end

endmodule 