module LZdetect4(
	IN,
	VALID,
	POSITION
);
	input [3:0] IN;
	output VALID;
	output [1:0] POSITION;
	
	wire V_Upper, V_Lower, P_Upper, P_Lower;
	
	LZdetect2 u32 (IN[3:2], V_Upper, P_Upper);
	LZdetect2 u10 (IN[1:0], V_Lower, P_Lower);
	
	assign VALID = V_Upper | V_Lower;
	assign POSITION[1] = ~V_Upper;
	assign POSITION[0] = V_Upper? P_Upper : P_Lower;
	
endmodule

