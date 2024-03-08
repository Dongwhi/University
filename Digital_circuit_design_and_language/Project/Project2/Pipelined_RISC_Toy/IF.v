module IF(
	input CLK, 
	input RSTN, 
	input [31:0] next_PC, 
	input Stall, 
	output [31:0] IF_out
);
	reg [31:0] out_contents;
	
	always @(posedge CLK or negedge RSTN)begin
		if (~RSTN) out_contents <= 32'b0;
		else if (Stall == 1) out_contents <= out_contents;
		else out_contents <= next_PC;
	end
	
	assign IF_out = out_contents;
	
endmodule