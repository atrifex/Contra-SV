
module  FrameBuffer 
( 
					input Clk, Reset, frame_Clk, blank, ScrollEnable,
					input[9:0] DrawX, DrawY,
					input logic[1:0] gameState,

					input [4:0] pixelIn,		// 
					output[4:0] pixelOut,	// this is the pixel data that we output ----> encoded bits

					output logic SRAM_Read
);
 
enum logic {Read_Write, Wait} frameStateCurr, frameStateNext;
 

// We could initialize it ----> or we can have an initialize state that takes care of it in hardware	

logic[4:0] frameOut, pixelWrite; 		// based on pixelIn and last value, we decide what we need to write.
logic writeEnable; 
logic[31:0] Address, writeAddress;

parameter[1:0] START		= 2'b00;
parameter[1:0] PLAY		= 2'b01;
parameter[1:0] GAMEOVER	= 2'b10;
	
assign Address = (DrawX + DrawY*640);
//sign Address = (DrawX < 24 && DrawY < 45)?(DrawX + DrawY*24): 32'h11111;
//assign writeAddress = (DrawX == 0 && DrawY == 0)? 31'b0: (DrawX + DrawY*640 -1);

assign writeAddress = (ScrollEnable)?($unsigned(Address) - $unsigned(1'b1)): Address;

//Register5Bits frameRegister(.Clk(frame_Clk), .Reset(Reset),.Data_In(frameOut), .Data_Out(pixelOut));

frameRAM frameInst(.Clk(Clk),.we(writeEnable), .data_In(pixelWrite), .write_address(writeAddress),.read_address(Address),.data_Out(pixelOut));
//frameRAM frameInst(.Clk(Clk),.we(writeEnable), .data_In(pixelWrite), .write_address(Address),.read_address(Address),.data_Out(pixelOut));


always_ff @ (posedge Clk)
begin
	if(Reset)
		frameStateCurr<= Wait;
	else
		frameStateCurr <= frameStateNext;
end

// next state logic
always_comb
begin
	frameStateNext = frameStateCurr;
	case(frameStateCurr)
		Read_Write: frameStateNext = Wait;
		Wait:
			begin
				if(blank)
					frameStateNext = Read_Write;
			end
		
	endcase
end

//output logic
always_comb
begin
	writeEnable = 1'b0;
	SRAM_Read = 1'b0;
	
	case(frameStateCurr)
		Read_Write: writeEnable = 1'b1;
		Wait:	SRAM_Read = 1'b1;
	endcase

end


always_comb
begin
	if(gameState == START || pixelIn == 5'h15)
		pixelWrite = pixelOut;
	else
		pixelWrite = pixelIn;
end

endmodule 