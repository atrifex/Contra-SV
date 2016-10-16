
module  finalProjectTopLevel( 	input         CLOCK_50, PS2_CLK, PS2_DAT, 
											input[3:0]    KEY, //bit 0 is set up as Reset
											input[1:0]	  SW,
											output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
										  output [8:0]  LEDG,
										  output [17:0] LEDR,
										  // VGA Interface
											output [7:0]  VGA_R,					//VGA Red
															 VGA_G,					//VGA Green
															 VGA_B,					//VGA Blue
											output        VGA_CLK,				//VGA Clock
															 VGA_SYNC_N,			//VGA Sync signal
															 VGA_BLANK_N,			//VGA Blank signal
															 VGA_VS,					//VGA virtical sync signal
															 VGA_HS					//VGA horizontal sync signal
				
											);

    logic Reset_h, Reset_sh, vssig, Clk, playerOnWire, keyIsPressed, jumpingFlag;
    logic [9:0] drawxsig, drawysig, playerposXWire, playerposYWire, playerHeightWire, playerWidthWire, playerPixelWire;
	
	enum logic[1:0] {Wait, PressKey,KeyRelease} keyCur, keyNext;
	logic[10:0] address;
	
	logic [4:0]colorValue;
	logic [1:0] gameStateWire;
	logic [7:0] keyCode1Wire, keyCode2Wire, keyCode3Wire, keyCode4Wire;
	logic [2:0] keyPriority1Wire, keyPriority2Wire, keyPriority3Wire, keyPriority4Wire;
	logic[6:0] FrameCountWire;
	
	logic[4:0] spriteVal;
	
	//assign keycode ={4'b0, ~(KEY[3]), ~(KEY[2]), ~(KEY[1]), ~(KEY[0])}; // The push buttons are active low
	assign Clk = CLOCK_50;
	assign Reset= (SW[1]); // Switches are active high


	//Fill in the connections for the rest of the modules
	

		

	Player heroInst
	(									.Reset(Reset),
										.frame_clk(VGA_CLK),
										.VS(VGA_VS),
										.Clk(Clk),
										.keycode(keyCode1Wire),
										.keyPress(LEDR[6:0]),
										.gameState(gameStateWire),
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.frameCount(FrameCountWire[0]),
										
										.playerPixels(playerPixelWire),
										.playerHeight(playerHeightWire),
										.playerWidth(playerWidthWire),
										.playerOn(playerOnWire)
	);
	
	

	pixelLogic pixelLogicInst
	(
										.Clk(Clk),
										.Reset(Reset),
										.playerPixel(playerPixelWire),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.playerHeight(playerHeightWire),
										.playerWidth(playerWidthWire),
										.playerOn(playerOnWire),
										
										
										.pixelOut(spriteVal)
	
	);
	
	
    vga_controller vgasync_instance
	 (
										.Clk(Clk),
										.Reset(Reset),
										.hs(VGA_HS),
										.vs(VGA_VS),
										.pixel_clk(VGA_CLK),
										.blank(VGA_BLANK_N),
										.sync(VGA_SYNC_N),
										.DrawX(drawxsig),
										.DrawY(drawysig)

	 );


    Color_Mapper5Bit color_instance
	 (
										.memMappedValue(colorValue),
										.Red(VGA_R),
										.Green(VGA_G),
										.Blue(VGA_B)
	 );

	GameController gameControllerInst
	(
										.Clk(Clk),
										.Reset(Reset),
										.keycode(keyCode1Wire | keyCode2Wire | keyCode3Wire | keyCode4Wire),
										.playerDead(       ),
										.gameState(gameStateWire)
	);



	FrameBuffer frameBufferInst
	(
	
										.Clk(Clk), 
										.frame_Clk(VGA_CLK),
										.blank(VGA_BLANK_N),
										.Reset(Reset),
										.DrawX(drawxsig),
										.DrawY(drawysig),
										
										.pixelIn(spriteVal),
										.pixelOut(colorValue)	// this is the pixel data that we output ----> encoded bit	
				
	);
	
	FrameCounter frameCount
	(
										.frame_Clk(VGA_CLK),
										.Reset(Reset), 
										.VS(VGA_VS),
										
										.FrameCount(FrameCountWire)
	);
	
	
	
	keyboard PS2Controller
	(
										.Clk(Clk),
										.psClk(PS2_CLK),
										.psData(PS2_DAT),
										.reset(Reset),
										.key1(keyCode1Wire),
										.key2(keyCode2Wire),
										.key3(keyCode3Wire),
										.key4(keyCode4Wire),
										.key1Priority(keyPriority1Wire),
										.key2Priority(keyPriority2Wire),
										.key3Priority(keyPriority3Wire),
										.key4Priority(keyPriority4Wire),
										.keyCount(LEDR[6:0]),
										.Shooting(LEDG[0]),
										.Jumping(LEDG[1]),  //jumpingFlag
										.press(keyIsPressed)
	
	);
	
	/*

	 HexDriver hex_inst_0 ({2'b00,keyPriority1Wire[2:0]}, HEX0);
	 HexDriver hex_inst_1 ({4'b00}, HEX1);


	 HexDriver hex_inst_2 ({2'b00,keyPriority2Wire[2:0]}, HEX2);
	 HexDriver hex_inst_3 ({4'b00}, HEX3);

	 HexDriver hex_inst_4 ({2'b00,keyPriority3Wire[2:0]}, HEX4);
	 HexDriver hex_inst_5 ({4'b00}, HEX5);

	 
	 HexDriver hex_inst_6 ({2'b00,keyPriority4Wire[2:0]}, HEX6);
	 HexDriver hex_inst_7 ({4'b00}, HEX7);

	*/
	

	 HexDriver hex_inst_0 (keyCode1Wire[3:0], HEX0);
	 HexDriver hex_inst_1 (keyCode1Wire[7:4], HEX1);

	 HexDriver hex_inst_2 (keyCode2Wire[3:0], HEX2);
	 HexDriver hex_inst_3 (keyCode2Wire[7:4], HEX3);
	 
	 HexDriver hex_inst_4 (keyCode3Wire[3:0], HEX4);
	 HexDriver hex_inst_5 (keyCode3Wire[7:4], HEX5);
	 
	 
	 HexDriver hex_inst_6 (keyCode4Wire[3:0], HEX6);
	 HexDriver hex_inst_7 (keyCode4Wire[7:4], HEX7);

endmodule
