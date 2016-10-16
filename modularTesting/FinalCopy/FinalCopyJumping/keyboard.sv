//-------------------------------------------------------------------------
//      PS2 Keyboard interface                                           --
//      Sai Ma, Marie Liu                                                           --
//      11-13-2014                                                       --
//                                                                       --
//      For use with ECE 385 Final Project                     --
//      ECE Department @ UIUC                                            --
//-------------------------------------------------------------------------
module keyboard(input logic Clk, psClk, psData, reset,
					 output logic [7:0] key1, key2, key3, key4,
					 output logic[6:0] keyCount,
					 output logic press,
					 output logic[2:0] key1Priority,key2Priority,key3Priority,key4Priority,
					 output logic keyFull, Shooting, Jumping);


	logic Q1, Q2, en, enable, shiftout1, shiftout2;
	logic[2:0] Press;
	logic [4:0] Count;
	logic [10:0] Byte_1, Byte_2;
	logic [7:0] Data, Typematic_Keycode, keyReleased;
	logic [9:0] counter;
	logic [6:0] keyCounter;
	logic [2:0] keyPriority[1:4];
	logic [7:0] keyCode1, keyCode2, keyCode3, keyCode4;
	logic [7:0] key1Next, key2Next, key3Next, key4Next;
	
	assign keyCount = keyCounter;
	
	assign key1Priority = keyPriority[1];
	assign key2Priority = keyPriority[2];
	assign key3Priority = keyPriority[3];
	assign key4Priority = keyPriority[4];

	assign press = keyCount[6] | keyCount[5] | keyCount[4] | keyCount[3] | keyCount[2] | keyCount[1] | keyCount[0] | Shooting | Jumping;

	
	
	always_ff @ (posedge Clk)
	begin
			key1 <= key1Next;
			key2 <= key2Next;
			key3 <= key3Next;
			key4 <= key4Next;
	end 
	
	always_comb
	begin			
		key1Next = key1;
		key2Next = key2;
		key3Next = key3;
		key4Next = key4;
	
		if(key1Priority == 3'b001)
			key1Next = keyCode1;
		else if(key2Priority == 3'b001)
			key1Next = keyCode2;
		else if(key3Priority == 3'b001)
			key1Next = keyCode3;
		else if(key4Priority == 3'b001)
			key1Next = keyCode4;
		else
			key1Next = 8'h00;

		if(key1Priority == 3'b010)
			key2Next = keyCode1;
		else if(key2Priority == 3'b010)
			key2Next = keyCode2;
		else if(key3Priority == 3'b010)
			key2Next = keyCode3;
		else if(key4Priority == 3'b010)
			key2Next = keyCode4;
		else
			key2Next = 8'h00;
		
		if(key1Priority == 3'b011)
			key3Next = keyCode1;
		else if(key2Priority == 3'b011)
			key3Next = keyCode2;
		else if(key3Priority == 3'b011)
			key3Next = keyCode3;
		else if(key4Priority == 3'b011)
			key3Next = keyCode4;
		else
			key3Next = 8'h00;	
			
		if(key1Priority == 3'b100)
			key4Next = keyCode1;
		else if(key2Priority == 3'b100)
			key4Next = keyCode2;
		else if(key3Priority == 3'b100)
			key4Next = keyCode3;
		else if(key4Priority == 3'b100)
			key4Next = keyCode4;
		else
			key4Next = 8'h00;
			
	end 
	
	//Counter to sync ps2 clock and system clock
	always_ff @(posedge Clk or posedge reset)
	begin
		if(reset)
		begin
			counter <= 10'b0000000000;
			enable <= 1'b1;
		end
		else if (counter == 10'b0111111111)
		begin
			counter <= 10'b0000000000;
			enable <= 1'b1;
		end
		else
		begin
			counter <= counter + 1'b1;
			enable <= 1'b0;
		end
	end

	//edge detector of PS2 clock
	always_ff @(posedge Clk)
	begin
		if(enable==1)
		begin
			if((reset)|| (Count==5'b01011))
				Count <= 5'b00000;
		else if(Q1==0 && Q2==1)
			begin
				Count <= Count + 1'b1;
				en <= 1'b1;
			end
		end
	end

	always_ff @(posedge Clk)
	begin
		if(reset)
		begin
			Press<= 2'b10;
		end
		else if(Count == 5'd11)
		begin
			// An extended key code will be recieved. This driver does not fully support extended key codes, so these are ignored.
			if (Byte_2[9:2] == 8'hE0)	// ignores  special keys
			begin
				// Do nothing
				Press <= 2'b10;
			end

			// An as-of-yet unknown key will be released.
			else if (Byte_2[9:2] == 8'hF0)	
			begin
				// Do nothing
				Press <= 2'b10;
			end

			// A key has been released.
			else if (Byte_1[9:2] == 8'hF0)
			begin
				if(Byte_2[9:2] == 8'h6B)
					Shooting <= 1'b0;				
				else if(Byte_2[9:2] == 8'h73)	
					Jumping <= 1'b0;
				else
					begin
						keyReleased <= Byte_2[9:2];
						Press <= 2'b00;

						if (keyReleased == Typematic_Keycode)
							Typematic_Keycode <= 8'h00;			// if the key is released, then it is not being repeated.
					end
			end
			else if(Byte_2[9:2] == 8'h6B)
			begin  
				Press <= 2'b10;
				Shooting <= 1'b1;
			end
			else if(Byte_2[9:2] == 8'h73)
			begin  
				Press <= 2'b10;
				Jumping <= 1'b1;
			end
			// This make code is a repeat.
			else if (Byte_2[9:2] == Typematic_Keycode)	// this is if we have just seen this code.
			begin
				// Do nothing
				Press <= 2'b10;
			end

			// A key has been pressed.
			else if (Byte_1[9:2] != 8'hF0 && (Byte_2[9:2] == 8'h1D || Byte_2[9:2] == 8'h1C || Byte_2[9:2] == 8'h1B || Byte_2[9:2] == 8'h23))
			begin
				Data <= Byte_2[9:2];
				Press <= 2'b01;
				Typematic_Keycode <= Byte_2[9:2];		// sets up key that has been pressed as if it is pressed down
			end
		end
	end
	
	always_ff @ (posedge Clk)
	begin
	if(reset)
		begin
			keyCode1 <= 8'h00;
			keyCode2 <= 8'h00;
			keyCode3 <= 8'h00;
			keyCode4 <= 8'h00;
			keyCounter <= 7'h00;
			keyFull <= 1'b0;
		end
	else if(Press == 2'b01 && Data != keyCode1 && Data != keyCode2 && Data != keyCode3 && Data != keyCode4)
		begin	
			if(keyCode1 == 8'h00)
			begin
				keyPriority[1] <= keyCounter + 1'b1;
				keyCounter <= keyCounter + 1'b1;
				keyCode1 <= Data;
			end
			else if(keyCode2 == 8'h00)
			begin
				keyPriority[2] <= keyCounter + 1'b1;
				keyCounter <= keyCounter + 1'b1;
				keyCode2 <= Data;
			end
			else if(keyCode3 == 8'h00)
			begin
				keyPriority[3] <= keyCounter + 1'b1;
				keyCounter <= keyCounter + 1'b1;
				keyCode3 <= Data;
			end
			else if(keyCode4 == 8'h00)
			begin
				keyPriority[4] <= keyCounter + 1'b1;
				keyCounter <= keyCounter + 1'b1;
				keyCode4 <= Data;
			end
		end
	else if(Press == 2'b00)
		begin
			if(keyReleased == keyCode1) 
			begin
			
				if(keyPriority[2] > keyPriority[1])
					keyPriority[2] <= keyPriority[2] - 1'b1; 
				if(keyPriority[3] > keyPriority[1])
					keyPriority[3] <= keyPriority[3] - 1'b1; 
				if(keyPriority[4] > keyPriority[1])
					keyPriority[4] <= keyPriority[4] - 1'b1; 
				keyPriority[1] <= 3'b00;
				
				keyCounter <= keyCounter - 1'b1;
				keyCode1 <= 8'h00;
			end
			if(keyReleased == keyCode2) 
			begin
			
				if(keyPriority[1] > keyPriority[2])
					keyPriority[1] <= keyPriority[1] - 1'b1; 
				if(keyPriority[3] > keyPriority[2])
					keyPriority[3] <= keyPriority[3] - 1'b1; 
				if(keyPriority[4] > keyPriority[2])
					keyPriority[4] <= keyPriority[4] - 1'b1; 
				keyPriority[2] <= 3'b00;	
				
				keyCounter <= keyCounter - 1'b1;
				keyCode2 <= 8'h00;
			end			
			if(keyReleased == keyCode3) 
			begin
			
				if(keyPriority[1] > keyPriority[3])
					keyPriority[1] <= keyPriority[1] - 1'b1; 
				if(keyPriority[2] > keyPriority[3])
					keyPriority[2] <= keyPriority[2] - 1'b1; 
				if(keyPriority[4] > keyPriority[3])
					keyPriority[4] <= keyPriority[4] - 1'b1; 
				keyPriority[3] <= 3'b00;
				
				keyCounter <= keyCounter - 1'b1;
				keyCode3 <= 8'h00;
			end			
			if(keyReleased == keyCode4) 
			begin
			
				if(keyPriority[1] > keyPriority[4])
					keyPriority[1] <= keyPriority[1] - 1'b1; 
				if(keyPriority[2] > keyPriority[4])
					keyPriority[2] <= keyPriority[2] - 1'b1; 
				if(keyPriority[3] > keyPriority[4])
					keyPriority[3] <= keyPriority[3] - 1'b1; 
				keyPriority[4] <= 3'b00;
				
				keyCounter <= keyCounter - 1'b1;
				keyCode4 <= 8'h00;
			end			
		end
	else
		begin
			keyCode1 <= keyCode1;
			keyCode2 <= keyCode2;
			keyCode3 <= keyCode3;
			keyCode4 <= keyCode4;
			keyFull <= keyFull;
		end
	end
	
	Dreg Dreg_instance1 ( .*,
								 .Load(enable),
								 .Reset(reset),
								 .D(psClk),
								 .Q(Q1) );
   Dreg Dreg_instance2 ( .*,
								 .Load(enable),
								 .Reset(reset),
								 .D(Q1),
								 .Q(Q2) );

	reg_11 reg_B(
					.Clk(psClk),  // maybe change to Q2
					.Reset(reset),
					.Shift_In(psData),
					.Load(1'b0),
					.Shift_En(en),
					.D(11'd0),
					.Shift_Out(shiftout2),
					.Data_Out(Byte_2)
					);

	reg_11 reg_A(
					.Clk(psClk), // maybe change to q2
					.Reset(reset),
					.Shift_In(shiftout2),
					.Load(1'b0),
					.Shift_En(en),
					.D(11'd0),
					.Shift_Out(shiftout1),
					.Data_Out(Byte_1)
					);

endmodule
