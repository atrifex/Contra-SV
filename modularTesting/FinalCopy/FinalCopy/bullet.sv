
module  Bullet
(
				input Reset, VS,  // frame_clk is vertical sync
				input shootingEnable, collision, direction,
				input[3:0] keycode,
				input [9:0]  PlayerX, PlayerY, PlayerHeight, PlayerWidth, DrawX, DrawY,
				
				output logic bullet_on
				
);
    
    logic [9:0] Bullet_X_Pos, Bullet_X_PosNext, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_PosNext, Bullet_Y_Motion, Bullet_Size, BulletXMotionNext, BulletYMotionNext;
	logic [9:0] BulletXMotionNextSaved, BulletYMotionNextSaved;
	logic[9:0]  BulletX, BulletY;
	

    parameter [9:0] Bullet_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bullet_X_Step=3;      // Step size on the X axis
    parameter [9:0] Bullet_Y_Step=3;      // Step size on the Y axis
	 parameter RIGHT = 1'b0;
	 
    assign Bullet_Size = 3;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
	enum logic[1:0] {shootPressed, shootWait, shooting, shootEnd} shootFlag, shootNext;
	logic shootEnable;
   
   
	int DistX, DistY, Size;
	assign DistX = DrawX - BulletX;
	assign DistY = DrawY - BulletY;
	  
	   always_ff @ (posedge VS)
	   begin 
			if(Reset)
				shootFlag <= shootWait;
			else
				shootFlag <= shootNext;
	   end
	  
	  
	 // Next State
	 always_comb
	 begin
		shootNext = shootFlag;
		
		case(shootFlag)
		shootWait:
		begin
			if(shootingEnable)
				shootNext = shootPressed;
		end
		
		shootPressed: 
		begin
			if(((Bullet_X_Pos > Bullet_X_Max) || (Bullet_X_Pos < Bullet_X_Min ) || (Bullet_Y_Pos > Bullet_Y_Max) || (Bullet_Y_Pos < Bullet_Y_Min)))
				shootNext = shootEnd;
		end
		
		shootEnd:
		begin
			if(~shootingEnable)
				shootNext = shootWait;
		end
		endcase
	 end
	 

	 // Output logic
	 always_comb
	 begin
		shootEnable = 1'b0;
		
		if(shootFlag == shootPressed)
			shootEnable = 1'b1;	
	 end	 
	  
	  
	  
	always_comb
	begin
		if((DistX*DistX + DistY*DistY) <= (Bullet_Size * Bullet_Size)) 
			bullet_on = 1'b1;
		else 
			bullet_on = 1'b0;
	 end
	 
	 always_ff @ (posedge shootingEnable)
	 begin
	 	BulletXMotionNextSaved <= BulletXMotionNext;
		BulletYMotionNextSaved <= BulletYMotionNext;
	 end
	 
   
    always_ff @ (posedge VS)
    begin: Move_Bullet					
				if(shootEnable == 1'b0)
				begin
					Bullet_X_Pos <= Bullet_X_PosNext;			
					Bullet_Y_Pos <= Bullet_Y_PosNext;
					Bullet_Y_Motion <= 10'b0;
					Bullet_X_Motion <= 10'b0;
				end
				else if(Bullet_X_Pos > Bullet_X_Max )
				begin
					Bullet_X_Pos <= Bullet_X_PosNext;			
					Bullet_Y_Pos <= Bullet_Y_PosNext;
					Bullet_Y_Motion <= 10'b0;
					Bullet_X_Motion <= 10'b0;
				end
				else if(Bullet_X_Pos < Bullet_X_Min )
				begin
					Bullet_X_Pos <= Bullet_X_PosNext;			
					Bullet_Y_Pos <= Bullet_Y_PosNext;
					Bullet_Y_Motion <= 10'b0;
					Bullet_X_Motion <= 10'b0;
				end
				else if(Bullet_Y_Pos > Bullet_Y_Max )
				begin
					Bullet_X_Pos <= Bullet_X_PosNext;			
					Bullet_Y_Pos <= Bullet_Y_PosNext;
					Bullet_Y_Motion <= 10'b0;
					Bullet_X_Motion <= 10'b0;
				end
				else if(Bullet_Y_Pos < Bullet_Y_Min) 
				begin
					Bullet_X_Pos <= Bullet_X_PosNext;			
					Bullet_Y_Pos <= Bullet_Y_PosNext;
					Bullet_Y_Motion <= 10'b0;
					Bullet_X_Motion <= 10'b0;
				end
				else if(collision == 1'b1)
				begin
					Bullet_X_Pos <= Bullet_X_PosNext;			
					Bullet_Y_Pos <= Bullet_Y_PosNext;
					Bullet_Y_Motion <= 10'b0;
					Bullet_X_Motion <= 10'b0;
				end		
				else
				begin
					 Bullet_Y_Motion <= BulletYMotionNextSaved;  // Bullet is somewhere in the middle, don't bounce, just keep moving
					 Bullet_X_Motion <= BulletXMotionNextSaved;  // Bullet is somewhere in the middle, don't bounce, just keep moving
					 Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);  // Update Bullet position
					 Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
				end
    end
	 
	 
	 
	 always_comb
	 begin
		BulletYMotionNext = Bullet_Y_Motion;
		BulletXMotionNext = Bullet_X_Motion;		
		Bullet_X_PosNext = Bullet_X_Pos;
		Bullet_Y_PosNext = Bullet_Y_Pos;
		
		if(shootFlag == shootWait)
		begin
			case (keycode[3:0])
			4'h0: 
			begin
				if(direction == RIGHT)
				begin
					Bullet_X_PosNext = PlayerX + PlayerWidth - 3'd5;
					Bullet_Y_PosNext = PlayerY + (PlayerHeight >> 1) - 4'd5;
				end
				else
				begin
					Bullet_X_PosNext = PlayerX + 3'd5;
					Bullet_Y_PosNext = PlayerY + (PlayerHeight >> 1) - 4'd5;
				end
			end
			4'h1: 
			begin
				if(direction == RIGHT)
				begin
					Bullet_X_PosNext = PlayerX + (PlayerWidth >> 1) + 3'd3;
					Bullet_Y_PosNext = PlayerY + 3'd5;
				end
				else
				begin
					Bullet_X_PosNext = PlayerX + (PlayerWidth >> 1) - 3'd3;
					Bullet_Y_PosNext = PlayerY + 3'd5;
				end
			end
			4'h2:
			begin
				Bullet_X_PosNext = PlayerX + 3'd5;
				Bullet_Y_PosNext = PlayerY + (PlayerHeight >> 1) - 4'd5;
			end
			4'h3:
			begin
				if(direction == RIGHT)
				begin
					Bullet_X_PosNext = PlayerX + PlayerWidth - 4'd5;
					Bullet_Y_PosNext = PlayerY + (PlayerHeight >> 1);
				end
				else
				begin
					Bullet_X_PosNext = PlayerX + 4'd5;
					Bullet_Y_PosNext = PlayerY + (PlayerHeight >> 1);
				end
			end
			4'h4:
			begin
				Bullet_X_PosNext = PlayerX + (PlayerWidth >> 1) + 3'd3;
				Bullet_Y_PosNext = PlayerY + (PlayerHeight >> 1) - 4'd5;
			end
			4'h5:
			begin
				Bullet_X_PosNext = PlayerX + 4'd5;
				Bullet_Y_PosNext = PlayerY + 4'd5;
			end
			4'h6:
			begin
				Bullet_X_PosNext = PlayerX + PlayerWidth - 4'd5;
				Bullet_Y_PosNext = PlayerY + 4'd5;
			end
			4'h7:
			begin
				Bullet_X_PosNext = PlayerX + 4'd5;
				Bullet_Y_PosNext = PlayerY + PlayerHeight - 5'd10;
			end
			4'h8:
			begin
				Bullet_X_PosNext = PlayerX + PlayerWidth - 4'd5;
				Bullet_Y_PosNext = PlayerY + PlayerHeight  - 5'd10;
			end
			default:
			begin
				if(direction == RIGHT)
				begin
					Bullet_X_PosNext = PlayerX + PlayerWidth;
					Bullet_Y_PosNext = PlayerY + (PlayerHeight >> 1);
				end
				else
				begin
					Bullet_X_PosNext = PlayerX;
					Bullet_Y_PosNext = PlayerY + (PlayerHeight >> 1);
				end
			end
			endcase
		end
			
		  case (keycode[3:0])
			4'h0: 
			begin
				if(direction == RIGHT)
				begin
					BulletXMotionNext = Bullet_X_Step;
					BulletYMotionNext = 10'b00;
				end
				else
				begin
					BulletXMotionNext = ~(Bullet_X_Step) + 1'b1;
					BulletYMotionNext = 10'b00;
				end
			end
			4'h1: 
			begin
				BulletXMotionNext = 10'b00;
				BulletYMotionNext = ~(Bullet_Y_Step) + 1'b1;
			end
			4'h2:
			begin
					BulletXMotionNext = ~(Bullet_X_Step) + 1'b1;
					BulletYMotionNext = 10'b00;		
			end
			4'h3:
			begin
				if(direction == RIGHT)
				begin
					BulletXMotionNext = Bullet_X_Step;
					BulletYMotionNext = 10'b00;
				end
				else
				begin
					BulletXMotionNext = ~(Bullet_X_Step) + 1'b1;
					BulletYMotionNext = 10'b00;
				end
			end
			4'h4:
			begin
				BulletXMotionNext = Bullet_X_Step;
				BulletYMotionNext = 10'b00;
			end
			4'h5:
			begin
				BulletXMotionNext = ~(Bullet_X_Step) + 1'b1;
				BulletYMotionNext = ~(Bullet_Y_Step) + 1'b1;
			end
			4'h6:
			begin
				BulletXMotionNext = Bullet_X_Step;
				BulletYMotionNext = ~(Bullet_Y_Step) + 1'b1;
			end
			4'h7:
			begin
				BulletXMotionNext = ~(Bullet_X_Step) + 1'b1;
				BulletYMotionNext = Bullet_Y_Step;
			end
			4'h8:
			begin
				BulletXMotionNext = Bullet_X_Step;
				BulletYMotionNext = Bullet_Y_Step;			
			end
			default:
			begin
				if(direction == RIGHT)
				begin
					BulletXMotionNext = Bullet_X_Step;
					BulletYMotionNext = 10'b00;
				end
				else
				begin
					BulletXMotionNext = ~(Bullet_X_Step) + 1'b1;
					BulletYMotionNext = 10'b00;
				end
			end
			endcase
			
	 end
       
    assign BulletX = Bullet_X_Pos;
   
    assign BulletY = Bullet_Y_Pos;
   
    assign BulletS = Bullet_Size;
    

endmodule
