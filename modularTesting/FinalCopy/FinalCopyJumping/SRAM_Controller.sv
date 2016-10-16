
module  SRAM_Controller 
( 
						input Clk,
						input logic [9:0] DrawX, DrawY, 
						input logic [12:0] FramePtr,
						input logic [15:0] SRAM_DataImport,
						
						
						output logic [19:0] SRAM_AddrExport,
						output logic [15:0] Data,
						output logic CE, UB, LB, OE, WE		// control the SDRAM
);
 
assign CE = 1'b0;
assign UB = 1'b0;
assign LB = 1'b0;
assign OE = 1'b0;
assign WE = 1'b1;
 
assign SRAM_AddrExport = ({16'd0,DrawX}+ {13'd0,FramePtr}) + (({3'b000, DrawY})*$unsigned(13'd4114)) >> 1;

always_ff @ (posedge Clk)
begin
		Data <= SRAM_DataImport;
end
endmodule
