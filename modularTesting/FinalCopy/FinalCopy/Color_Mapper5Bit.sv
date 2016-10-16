


module  Color_Mapper5Bit 
(
										input[9:0] DrawX, DrawY,
										input logic  [4:0]  memMappedValue,
										output logic [7:0]  Red, Green, Blue
);



// maps 8-bit value to a set of 255 colors to create an image on the screen
always_comb
begin
	case(memMappedValue)
			5'h00:
				begin
					Red	= 8'h00;
					Green	= 8'h00;
					Blue	= 8'h00;
				end
			5'h01:
				begin
					Red	= 8'hF8;
					Green	= 8'h38;
					Blue	= 8'h00;
				end
			5'h02:
				begin
					Red	= 8'hF0;
					Green	= 8'hD0;
					Blue	= 8'hB0;
				end
			5'h03:
				begin
					Red	= 8'h50;
					Green	= 8'h30;
					Blue	= 8'h00;
				end
			5'h04:
				begin
					Red	= 8'hFF;
					Green	= 8'hE0;
					Blue	= 8'hA8;
				end
			5'h05:
				begin
					Red	= 8'h00;
					Green	= 8'h58;
					Blue	= 8'hF8;
				end
			5'h06:
				begin
					Red	= 8'hFC;
					Green	= 8'hFC;
					Blue	= 8'hFC;
				end
			5'h07:
				begin
					Red	= 8'hBC;
					Green	= 8'hBC;
					Blue	= 8'hBC;
				end
			5'h08:
				begin
					Red	= 8'hA4;
					Green	= 8'h00;
					Blue	= 8'h00;
				end
			5'h09:
				begin
					Red	= 8'hD8;
					Green	= 8'h28;
					Blue	= 8'h00;
				end
			5'h0A:
				begin
					Red	= 8'hFC;
					Green	= 8'h74;
					Blue	= 8'h60;
				end
			5'h0B:
				begin
					Red	= 8'hFC;
					Green	= 8'hBC;
					Blue	= 8'hB0;
				end
			5'h0C:
				begin
					Red	= 8'hF0;
					Green	= 8'hBC;
					Blue	= 8'h3C;
				end
			5'h0D:
				begin
					Red	= 8'hAE;
					Green	= 8'hAC;
					Blue	= 8'hAE;
				end
			5'h0E:
				begin
					Red	= 8'h36;
					Green	= 8'h33;
					Blue	= 8'h01;
				end
			5'h0F:
				begin
					Red	= 8'h6C;
					Green	= 8'h6C;
					Blue	= 8'h01;
				end
			5'h10:
				begin
					Red	= 8'hBB;
					Green	= 8'hBD;
					Blue	= 8'h00;
				end
			5'h11:
				begin
					Red	= 8'h88;
					Green	= 8'hD5;
					Blue	= 8'h00;
				end
			5'h12:
				begin
					Red	= 8'h39;
					Green	= 8'h88;
					Blue	= 8'h02;
				end
			5'h13:
				begin
					Red	= 8'h65;
					Green	= 8'hB0;
					Blue	= 8'hFF;
				end
			5'h14:
				begin
					Red	= 8'h15;
					Green	= 8'h5B;
					Blue	= 8'hD8;
				end
			5'h15:
				begin
					Red	= 8'h80;
					Green	= 8'h00;
					Blue	= 8'h80;
				end
			5'h16:
				begin
					Red	= 8'h24;
					Green	= 8'h18;
					Blue	= 8'h8A;			
				end
			5'h17:
				begin
					Red	= 8'h39;
					Green	= 8'h88;
					Blue	= 8'h02;			
				end
			5'h18:
				begin
					Red	= 8'hFC;
					Green	= 8'hFC;
					Blue	= 8'hFC;		
				end
			default:
				begin
					Red	= 8'h00;
					Green	= 8'h00;
					Blue	= 8'h00;
				end
	endcase
	
	if(DrawX >= 639 || DrawX <= 1)
		begin
					Red	= 8'h00;
					Green	= 8'h00;
					Blue	= 8'h00;
		end
end

endmodule
