 module  playerROM
( 
		input [4:0] data_In,
		input [20:0] write_address, read_address,
		input we, Clk,

		output logic [4:0] data_Out
);		
	

logic [4:0] SpriteRom [0:101239]; 			// test sprite ROM 		

initial
begin
	 $readmemh("SpriteText/spriteTotalMem.txt", SpriteRom); // Will probably have it standing still
end

always_ff @ (posedge Clk) begin
	if (we)
		SpriteRom[write_address] <= data_In;
	data_Out<= SpriteRom[read_address];
end


endmodule 

