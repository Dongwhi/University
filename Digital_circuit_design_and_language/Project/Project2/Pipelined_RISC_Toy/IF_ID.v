module IF_ID(
	input CLK, 
	input RSTN, 
	input [31:0] PC_plus_4, 
	input Stall, 
	output [31:0] IF_ID_out
);
	reg [31:0] out_contents;
	
	always @(posedge CLK or negedge RSTN)begin
		if (~RSTN) out_contents <= 32'b0;
		else if (Stall == 1) out_contents <= out_contents;
		else out_contents <= PC_plus_4;
	end
	
	assign IF_ID_out = out_contents;
	
endmodule