module Register5Bits (input Clk, Reset,
					  input  [4:0]  Data_In,
					  output logic [4:0]  Data_Out);

    always_ff @ (posedge Clk) // sequential logic
    begin
    if (Reset) 
        Data_Out <= 5'h00; // parallel out of 0 
	else 
		Data_Out <= Data_In;
    end

endmodule


