module  Player 
( 
				input	 Reset, frame_clk, Clk, VS,	// frame_clk is useful
				input logic[4:0]   keycode,		// WILL BE BASED ON PUSH BUTTONS FOR NOW
				input logic keyPress,

				input logic [1:0]   gameState, 	// makes sure that the player module ignores keycodes if we are not in the play state.
				input logic [9:0] DrawX, DrawY,
				input logic [6:0]  frameCounter,
				
				output logic [4:0] playerPixels, 
				output logic [9:0] PlayerX, PlayerY, PlayerHeight, PlayerWidth,
				output logic playerOn
);


logic[9:0]  playerposXWire, playerposYWire;
logic[4:0] spriteVal;				
logic playerMovingWire, directionWire, playerOnWire1, playerOnWire2, playerOnWire3, playerOnWire4, playerOnWire5, playerOnWire6;
logic [20:0] spriteAddressWire, spriteAddressWire1, spriteAddressWire2, spriteAddressWire3, spriteAddressWire4, spriteAddressWire5, spriteAddressWire6;
logic [9:0] playerHeightWire1, playerHeightWire2, playerHeightWire3, playerHeightWire4, playerHeightWire5, playerHeightWire6;
logic [9:0] playerWidthWire1, playerWidthWire2, playerWidthWire3, playerWidthWire4, playerWidthWire5, playerWidthWire6;     
 
logic [2:0] directionStateNum;


assign PlayerX = playerposXWire;
assign PlayerY = playerposYWire;

	playerMovement playerMovementInst
	(									// INPUTS
										.Clk(Clk),
										.Reset(Reset),
										.frame_clk(frame_clk),
										.VS(VS),
										.keycode(keycode[3:0]),
										.keyPress(keyPress),
										.gameState(gameState),
										.frameCounter_3(frameCounter[2]),
										
										//OUTPUTS
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.Lives(),
										.Direction(directionWire),
										.playerMoving(playerMovingWire)
	);	
	
	playerROM playerROMInst
	(									//INPUTS
										.we(1'b0),
										.Clk(Clk),
										.data_In(5'h15),
										.write_address(32'b0),
										.read_address(spriteAddressWire),
										
										//OUTPUTS
										.data_Out(playerPixels)
	);
	 
	
	addressAndPlayerOnMux addressAndPlayerOnMuxInst
	(
										.address1(spriteAddressWire1),
										.address2(spriteAddressWire2),
										.address3(spriteAddressWire3),
										.address4(spriteAddressWire4),
										.address5(spriteAddressWire5),
										.address6(spriteAddressWire6),
										.playerOn1(playerOnWire1),
										.playerOn2(playerOnWire2),
										.playerOn3(playerOnWire3),
										.playerOn4(playerOnWire4),
										.playerOn5(playerOnWire5),
										.playerOn6(playerOnWire6),
										.playerHeight1(playerHeightWire1),
										.playerHeight2(playerHeightWire2),
										.playerHeight3(playerHeightWire3),
										.playerHeight4(playerHeightWire4),
										.playerHeight5(playerHeightWire5),
										.playerHeight6(playerHeightWire6),
										.playerWidth1(playerWidthWire1),
										.playerWidth2(playerWidthWire2),
										.playerWidth3(playerWidthWire3),
										.playerWidth4(playerWidthWire4),
										.playerWidth5(playerWidthWire5),
										.playerWidth6(playerWidthWire6),
										.keycode(keycode),
										
										.spriteAddress(spriteAddressWire),
										.spriteOn(playerOn),
										.PlayerHeight(PlayerHeight),
										.PlayerWidth(PlayerWidth)
	);
	 
	 
	 
	 
	 
	
	 playerAnimationWait playerAnimationWaitInst
	 (
										.Reset(Reset),
										.moving(playerMovingWire),
										.frame_Clk(frame_clk),
										.playerDirection(directionWire),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.keycode(keycode[3:0]),
										
										
										.playerOn(playerOnWire1),
										.spriteAddress(spriteAddressWire1),
										.PlayerHeight(playerHeightWire1),
										.PlayerWidth(playerWidthWire1)
	 
	 );
	 
	playerAnimationRunning playerAnimationRunningInst
	 (
										.Reset(Reset),
										.moving(playerMovingWire),
										.frame_Clk(frame_clk),
										.playerDirection(directionWire),
										.frameCounter_0(frameCounter[0]),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.keycode(keycode[3:0]),
										
										
										.playerOn(playerOnWire2),
										.spriteAddress(spriteAddressWire2),
										.PlayerHeight(playerHeightWire2),
										.PlayerWidth(playerWidthWire2)
	 
	 );
	 
	playerAnimationDown playerAnimationDownInst
	 (
										.Reset(Reset),
										.moving(playerMovingWire),
										.frame_Clk(frame_clk),
										.playerDirection(directionWire),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.keycode(keycode[3:0]),
										
										
										.playerOn(playerOnWire3),
										.spriteAddress(spriteAddressWire3),
										.PlayerHeight(playerHeightWire3),
										.PlayerWidth(playerWidthWire3)
	 
	 );
	 
	 playerAnimationUp playerAnimationUpInst
	 (
										.Reset(Reset),
										.moving(playerMovingWire),
										.frame_Clk(frame_clk),
										.playerDirection(directionWire),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.keycode(keycode[3:0]),
										
										
										.playerOn(playerOnWire4),
										.spriteAddress(spriteAddressWire4),
										.PlayerHeight(playerHeightWire4),
										.PlayerWidth(playerWidthWire4)
	 
	 );
	 
	  	playerAnimationDownRL playerAnimationDownRLInst
	 (
										.Reset(Reset),
										.moving(playerMovingWire),
										.frame_Clk(frame_clk),
										.playerDirection(directionWire),
										.frameCounter_0(frameCounter[0]),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.keycode(keycode[3:0]),
										
										
										.playerOn(playerOnWire5),
										.spriteAddress(spriteAddressWire5),
										.PlayerHeight(playerHeightWire5),
										.PlayerWidth(playerWidthWire5)
	 
	 );
	 
	 
	playerAnimationUpRL playerAnimationUpRLInst
	 (
										.Reset(Reset),
										.moving(playerMovingWire),
										.frame_Clk(frame_clk),
										.playerDirection(directionWire),
										.frameCounter_0(frameCounter[0]),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.keycode(keycode[3:0]),
										
										
										.playerOn(playerOnWire6),
										.spriteAddress(spriteAddressWire6),
										.PlayerHeight(playerHeightWire6),
										.PlayerWidth(playerWidthWire6)
	 
	 );
	 
	 /*
	playerAnimationJump playerAnimationJumpInst
	 (
										.Reset(Reset),
										.moving(playerMovingWire),
										.frame_Clk(frame_clk),
										.playerDirection(directionWire),
										.frameCounter_0(frameCounter[0]),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										.keycode(keycode[3:0]),
										
										
										.playerOn(playerOn),
										.spriteAddress(spriteAddressWire)
	 
	 );
	 
	playerAnimationDead playerAnimationDeadInst
	 (
										.Reset(Reset),
										.moving(playerMovingWire),
										.frame_Clk(frame_clk),
										.playerDirection(directionWire),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.PlayerX(playerposXWire),
										.PlayerY(playerposYWire),
										
										
										.playerOn(playerOn),
										.spriteAddress(spriteAddressWire)
	 
	 );
	 */

endmodule 
	