module LZdetect2(
	IN,
	VALID,
	POSITION
);
	input [1:0] IN;
	output VALID, POSITION;
	
	assign VALID = IN[1] | IN[0];
	assign POSITION = ~IN[1];
	
endmodule

