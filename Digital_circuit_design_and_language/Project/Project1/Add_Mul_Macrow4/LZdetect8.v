module LZdetect8(
	IN,
	VALID,
	POSITION
);
	input [7:0] IN;
	output VALID;
	output [2:0] POSITION;
	
	wire V_Upper, V_Lower;
	wire [1:0] P_Upper, P_Lower;
	
	LZdetect4 u32 (IN[7:4], V_Upper, P_Upper);
	LZdetect4 u10 (IN[3:0], V_Lower, P_Lower);
	
	assign VALID = V_Upper | V_Lower;
	assign POSITION[2] = ~V_Upper;
	assign POSITION[1:0] = V_Upper? P_Upper : P_Lower;
	
endmodule

