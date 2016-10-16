module Register16Bit
(				
				input Clk, Load, Reset,
				input  [15:0]  Data_In,
            
            output logic [15:0]  Data_Out
);

    always_ff @ (posedge Clk) // sequential logic
    begin
				if(~Reset)
					Data_Out <= 16'b0;
				else if(Load)
					Data_Out <= Data_In;
				else 
					Data_Out <= Data_Out;
    end

endmodule
