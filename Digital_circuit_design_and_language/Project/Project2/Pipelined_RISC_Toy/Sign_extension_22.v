module Sign_extension_22(
	input signed [21:0] IMM22, 
	output signed [31:0] Signext_IMM22
);

	assign Signext_IMM22 = {{9{IMM22[21]}}, IMM22};
endmodule