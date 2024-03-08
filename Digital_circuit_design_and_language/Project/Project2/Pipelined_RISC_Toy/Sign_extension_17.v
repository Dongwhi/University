module Sign_extension_17(
	input signed [16:0] IMM17, 
	output signed [31:0] Signext_IMM17
);

	assign Signext_IMM17 = {{15{IMM17[16]}}, IMM17};
endmodule