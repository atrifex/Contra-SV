
module  finalProjectTopLevel( 	input         CLOCK_50,
											input[3:0]    KEY, //bit 0 is set up as Reset
											input[1:0]	  SW,
								//output [6:0]  HEX0, HEX1,// HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  //output [8:0]  LEDG,
							  //output [17:0] LEDR,
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

    logic Reset_h, Reset_sh, vssig, Clk;
    logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;

	logic [5:0]colorValue;
	logic [15:0] colorCounter;
	logic [1:0] gameStateWire;

	assign Clk = CLOCK_50;
	assign Reset=~(KEY[3]);  // The push buttons are active low



	//The connections for nios_system might be named different depending on how you set up Qsys
	

	//Fill in the connections for the rest of the modules
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


    Color_Mapper8Bit color_instance
	 (
										.Clk(Clk),
										.memMappedValue(colorValue),
										.Red(VGA_R),
										.Green(VGA_G),
										.Blue(VGA_B)
	 );

	GameController gameControllerInst
	(
										.Clk(Clk),
										.Reset(Reset),
										.keycode({5'b0, ~(KEY[2]), ~(KEY[1]), ~(KEY[0])}),
										.playerDead(    ),
										.gameState(gameStateWire)
	);




	/*
	SIMPLE STATE MACHINE TO TEST GAME STATE CONTROLLER
	*/
	always_ff @ (posedge Clk)
	begin
		if(gameStateWire == 2'b01)		// if we are in the play state
		begin
			if(colorValue == 6'h3C || VGA_VS == 1'b0)
				begin
					colorValue <= 6'h00;
					colorCounter <= 16'b0000;
				end
			else if(colorCounter == 16'h36B0)
				begin
					colorValue <= colorValue + 6'h01;
					colorCounter <= 16'b0000;
				end
			else
				colorCounter <= colorCounter + 16'b0001;
		end
		else
		begin
				colorValue <= 6'h00;
				colorCounter <= 16'b0000;
		end
	end

endmodule
