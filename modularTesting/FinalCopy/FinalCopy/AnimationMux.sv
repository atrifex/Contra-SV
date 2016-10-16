module addressAndPlayerOnMux
(
				input [20:0] address1, address2, address3, address4, address5, address6, address7,
				input playerOn1, playerOn2, playerOn3, playerOn4, playerOn5, playerOn6, playerOn7,
				input [9:0] playerHeight1, playerHeight2, playerHeight3, playerHeight4, playerHeight5, playerHeight6, playerHeight7,
				input [9:0] playerWidth1, playerWidth2, playerWidth3, playerWidth4, playerWidth5, playerWidth6, playerWidth7, 
				input [4:0] keycode,
				input onPlatform,
				
				output [20:0] spriteAddress,
				output spriteOn,
				output [9:0] PlayerHeight, PlayerWidth
);

always_comb
begin
	if(!onPlatform || keycode[4])
	begin
		spriteAddress = address7;
		spriteOn = playerOn7;
		PlayerHeight = playerHeight7;
		PlayerWidth = playerWidth7;
	end
	else
	begin
		case (keycode[3:0])
			4'h0: 
			begin
				spriteAddress = address1;
				spriteOn = playerOn1;
				PlayerHeight = playerHeight1;
				PlayerWidth = playerWidth1;
			end
			4'h1: 
			begin
				spriteAddress = address4;
				spriteOn = playerOn4;
				PlayerHeight = playerHeight4;
				PlayerWidth = playerWidth4;
			end
			4'h2:
			begin
				spriteAddress = address2;
				spriteOn = playerOn2;
				PlayerHeight = playerHeight2;
				PlayerWidth = playerWidth2;
			end
			4'h3:
			begin
				spriteAddress = address3;
				spriteOn = playerOn3;
				PlayerHeight = playerHeight3;
				PlayerWidth = playerWidth3;
			end
			4'h4:
			begin
				spriteAddress = address2;
				spriteOn = playerOn2;
				PlayerHeight = playerHeight2;
				PlayerWidth = playerWidth2;
			end
			4'h5:
			begin
				spriteAddress = address6;
				spriteOn = playerOn6;
				PlayerHeight = playerHeight6;
				PlayerWidth = playerWidth6;
			end
			4'h6:
			begin
				spriteAddress = address6;
				spriteOn = playerOn6;
				PlayerHeight = playerHeight6;
				PlayerWidth = playerWidth6;
			end
			4'h7:
			begin
				spriteAddress = address5;
				spriteOn = playerOn5;
				PlayerHeight = playerHeight5;
				PlayerWidth = playerWidth5;
			end
			4'h8:
			begin
				spriteAddress = address5;
				spriteOn = playerOn5;
				PlayerHeight = playerHeight5;
				PlayerWidth = playerWidth5;
			end
			default:
			begin
				spriteAddress = address1;
				spriteOn = playerOn1;
				PlayerHeight = playerHeight1;
				PlayerWidth = playerWidth1;
			end
		endcase
	end
end

endmodule 