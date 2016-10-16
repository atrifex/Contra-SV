//-------------------------------------------------------------------------
//      Mem2IO.vhd                                                       --
//      Stephen Kempf                                                    --
//                                                                       --
//      Revised 03-15-2006                                               --
//              03-22-2007                                               --
//              07-26-2013                                               --
//              03-04-2014                                               --
//                                                                       --
//      For use with ECE 385 Experiment 6                                --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  addressMux 
( 	
		input logic[19:0]	readAddress,
		input logic[19:0] 	writeAddress,
		
		input logic			select,
			
		output logic[20:0] 	address
);

always_comb
	begin
		if(select)
			address = writeAddress;
		else
			address = readAddress;
	end
endmodule
