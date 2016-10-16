module keyCodeGenerator
( 
								input [2:0] keyCount,
								input [7:0] keyCode1, keyCode2,
								
								output [3:0] keyCode
);



always_comb
begin
	case(keyCount)
		3'd1:
		begin
				case(keyCode1)
					8'h1D: keyCode = 4'h1; // w
					8'h1C: keyCode = 4'h2; // a
					8'h1B: keyCode = 4'h3; // s
					8'h23: keyCode = 4'h4; // d
					default: keyCode = 4'h0;
				endcase
		end

		
		3'd2:
		begin
				case(keyCode1)
					8'h1D: // w + something
					begin
						case(keyCode2)
							8'h1C: keyCode = 4'h5; // wa
							8'h23: keyCode = 4'h6; // wd
							default: keyCode = 4'h1;
						endcase
					end
					8'h1C: // a + something
					begin
						case(keyCode2)
							8'h1D: keyCode = 4'h5; // wa
							8'h1B: keyCode = 4'h7; // sa
							default: keyCode = 4'h2;
						endcase
					end
					8'h1B:  // s + something
					begin
						case(keyCode2)
							8'h1C: keyCode = 4'h7; // sa
							8'h23: keyCode = 4'h8; // sd
							default: keyCode = 4'h3;
						endcase
					end
					8'h23:  // d + something
					begin
						case(keyCode2)
							8'h1D: keyCode = 4'h6; // wd
							8'h1B: keyCode = 4'h8; // sd
							default: keyCode = 4'h4;
						endcase
					end 
					default: keyCode = 4'h0;
				endcase
		end
		default: keyCode = 4'h0;
	endcase
end

endmodule