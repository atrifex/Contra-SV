 
module  finalProjectTopLevel( 	input         CLOCK_50, PS2_CLK, PS2_DAT,
											input[3:0]    KEY, //bit 0 is set up as Reset
											input[1:0]	  SW,
											output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
										  output [8:0]  LEDG,
										  output [17:0] LEDR,
										  
										  // VGA Interface
											output [7:0] 	VGA_R,					//VGA Red
																VGA_G,					//VGA Green
																VGA_B,					//VGA Blue
											output      	VGA_CLK,				//VGA Clock
																VGA_SYNC_N,			//VGA Sync signal
																VGA_BLANK_N,			//VGA Blank signal
																VGA_VS,					//VGA virtical sync signal
																VGA_HS,					//VGA horizontal sync signal
											
											// SRAM Signals
											input[15:0] SRAM_DQ,
											output[19:0] SRAM_ADDR,
											output SRAM_CE_N, SRAM_UB_N, SRAM_LB_N, SRAM_OE_N, SRAM_WE_N
											);
	
	// Parameters can be used to standardize some of the game states
	parameter[1:0] START		= 2'b00;
	parameter[1:0] PLAY		= 2'b01;
	parameter[1:0] GAMEOVER	= 2'b10;
	
	
   logic Reset_h, Reset_sh, vssig, Clk, BuffScrollEnable, scrollEnableWire, SRAM_ReadWire, jumpEnableWire, keyIsPressed, playerOnWire, shootingEnableWire;
   logic [9:0] drawxsig, drawysig, playerposXWire, playerposYWire, playerHeightWire, playerWidthWire, playerPixelWire;
   logic [9:0] platformX1Wire, platformX2Wire, platformYMaxWire;

	logic bulletOn1Wire, bulletOn2Wire, bulletOn3Wire, bulletOn4Wire, bulletOn5Wire, bulletOn6Wire, directionWire;
	
	logic [7:0] keyCode1Wire, keyCode2Wire, keyCode3Wire, keyCode4Wire;

	logic [4:0] buffPixel, pixelOut, pixelLogicOut, completeKeyCode;
	logic [1:0] gameStateWire;
	logic[7:0] keycode;
	logic[6:0] FrameCountWire;
	logic [12:0] FramePtrWire;
	logic [3:0] keyCodeWire;
	logic [2:0] keyCountWire;
 
	assign LEDG[0] = jumpEnableWire;
	assign LEDG[1] = shootingEnableWire;
	
	assign LEDR[0] = keyIsPressed;
	
	logic[15:0] BackgroundPixelWire;
	
	//assign keycode ={4'b0, ~(KEY[3]), ~(KEY[2]), ~(KEY[1]), ~(KEY[0])}; // The push buttons are active low
	assign Clk = CLOCK_50;
	assign Reset= (SW[1]); // Switches are active high

	//The connections for nios_system might be named different depending on how you set up Qsys
	
		Register5Bits keySyncReg
		(
										.Clk(VGA_VS),
										.Reset(Reset),
										.Data_In({jumpEnableWire, keyCodeWire}),
										.Data_Out(completeKeyCode)
										
		);
	
		keyboard PS2Controller
		(
										.Clk(Clk),
										.psClk(PS2_CLK),
										.psData(PS2_DAT),
										.reset(Reset),
										.key1(keyCode1Wire),
										.key2(keyCode2Wire),
										.keyCount(keyCountWire),
										.Shooting(shootingEnableWire),
										.Jumping(jumpEnableWire),  //jumpingFlag
										.press(keyIsPressed)
	
		);

		keyCodeGenerator letsGenerateMeSomeKeys
		(
										.keyCount(keyCountWire),
										.keyCode1(keyCode1Wire),
										.keyCode2(keyCode2Wire),
										
										.keyCode(keyCodeWire)
		);
	
		BulletTopLevel BulletTopLevelInst
		(
										.Reset(Reset), 
										.VS(VGA_VS),  // frame_clk is vertical sync
										.shootingEnable(shootingEnableWire), 
										.collision(1'b0),
										.keycode(completeKeyCode[3:0]),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire), 
										.PlayerHeight(playerHeightWire),
										.PlayerWidth(playerWidthWire), 
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.direction(directionWire),
										
										.bulletOn1(bulletOn1Wire), 
										.bulletOn2(), 
										.bulletOn3(), 
										.bulletOn4(), 
										.bulletOn5(), 
										.bulletOn6()
		);
		
		
		Player heroInst
		(									
										.Reset(Reset),
										.frame_clk(VGA_CLK),
										.VS(VGA_VS),
										.Clk(Clk),
										.keycode(completeKeyCode),
										.keyPress(keyIsPressed),
										.gameState(gameStateWire),
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.frameCounter(FrameCountWire),
										
										.PlatformStart(platformX1Wire),
										.PlatformEnd(platformX2Wire), 
										.PlatformHeight(platformYMaxWire),										
										.onPlatform(LEDG[8]),
										
										.playerPixels(playerPixelWire),
										.playerOn(playerOnWire),
										.PlayerHeight(playerHeightWire), 
										.PlayerWidth(playerWidthWire),
										.scrollEnable(scrollEnableWire),
										.directionOut(directionWire)
		);
		
	  pixelLogic pixelLogicInst
	  (
										.Clk(Clk),
										.Reset(Reset),
										.playerPixel(playerPixelWire),
										.backgroundPixel(BackgroundPixelWire[4:0]),
										.playerOn(playerOnWire),
										.bulletOn1(bulletOn1Wire), 
										
										.pixelOut(pixelLogicOut)
		
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

	StartScreenMux startScreen_instance
	(
										.frame_Clk(VGA_CLK), 
										.Reset(Reset),
										.FrameCount(FrameCountWire),
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.gameState(gameStateWire),
										.pixelIn(buffPixel),
										.pixelOut(pixelOut)	
	);
	
	 Color_Mapper5Bit color_instance
	 (
										.memMappedValue(pixelOut),
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.Red(VGA_R),
										.Green(VGA_G),
										.Blue(VGA_B)
	 );

	GameController gameControllerInst
	(
										.Clk(Clk),
										.Reset(Reset),
										.keycode({shootingEnableWire,completeKeyCode}),
										.playerDead(       ),
										.gameState(gameStateWire)
	);

	
	FrameCounter frameCount
	(
										.frame_Clk(VGA_CLK),
										.Reset(Reset), 
										.VS(VGA_VS),
										
										.FrameCount(FrameCountWire)
	);
	
	
	Register1Bit ScrollEnableBuff
	(
										.Clk(VGA_VS), 
										.Reset(Reset),
										.D(scrollEnableWire),
										.Q(BuffScrollEnable)
	);
	
	FrameBuffer frameBufferInst
	(
	
										.Clk(Clk), 
										.frame_Clk(VGA_CLK),
										.blank(VGA_BLANK_N),
										.Reset(Reset),
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.gameState(gameStateWire),
										.ScrollEnable(BuffScrollEnable),
										.pixelIn(pixelLogicOut),
										.pixelOut(buffPixel),	// this is the pixel data that we output ----> encoded bit	
										.SRAM_Read(SRAM_ReadWire)
	);
	
	
	SRAM_Controller	sramControllerInst
	(
										.Clk(VGA_CLK), 
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.FramePtr(FramePtrWire),						// going to pretend that we are not scrolling at first
										.SRAM_DataImport(SRAM_DQ),			// DATA COMING FROM THE SRAM
										.SRAM_AddrExport(SRAM_ADDR),
										.CE(SRAM_CE_N), 
										.UB(SRAM_UB_N), 
										.LB(SRAM_LB_N), 
										.OE(SRAM_OE_N),
										.WE(SRAM_WE_N),
										
										.Data(BackgroundPixelWire)
	);
	
	
	
	FramePtrRegister framePtrInst
	(				
										.Clk(VGA_VS),
										.Reset(Reset), 
										.ScrollEnable(BuffScrollEnable),
										.FramePtr(FramePtrWire)
	);
	
	platformDetector platformDetectorInstance
		(	
										.Clk(VGA_CLK), 
										.Reset(Reset), 
										.blank(VGA_BLANK_N),
										.DrawX(drawxsig),
										.DrawY(drawysig),
										.VS(VGA_VS),
										.onPlatform(LEDG[8]),
										.ScrollEnable(BuffScrollEnable),


										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.PlayerHeight(playerHeightWire),
										.backgroundPixel(BackgroundPixelWire[4:0]),
										
										.PlatformX1(platformX1Wire),
										.PlatformX2(platformX2Wire),
										.PlatformY(platformYMaxWire)
		); 
	
	
	
/*
	 HexDriver hex_inst_0 (completeKeyCode[3:0], HEX0);
	 HexDriver hex_inst_1 ({4'b0}, HEX1);
*/	
	
	 HexDriver hex_inst_0 (platformX1Wire[3:0], HEX0);
	 HexDriver hex_inst_1 (platformX1Wire[7:4], HEX1);
	 
	 HexDriver hex_inst_2 (platformX2Wire[3:0],HEX2);
	 HexDriver hex_inst_3 (platformX2Wire[7:0], HEX3);

	 HexDriver hex_inst_4 (platformYMaxWire[3:0], HEX4);
	 HexDriver hex_inst_5 (platformYMaxWire[7:4], HEX5);
	 
	 HexDriver hex_inst_6 (playerHeightWire[3:0], HEX6);
	 HexDriver hex_inst_7 (playerHeightWire[7:4], HEX7);

	
endmodule
