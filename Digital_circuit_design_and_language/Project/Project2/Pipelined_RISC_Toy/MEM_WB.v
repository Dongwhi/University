module MEM_WB(
	input CLK, 
	input RSTN, 
	input [1:0] WB_control, 
	input [31:0] ALUresult_or_PC_plus_4, 
	input [4:0] rd, 
	input Stall, 
	output [38:0] MEM_WB_out
);
	reg [38:0] out_contents;
	
	always @(posedge CLK or negedge RSTN)begin
		if (~RSTN) out_contents <= 39'b0;
		else if (Stall == 1'b1) out_contents <= {2'b0, 
			ALUresult_or_PC_plus_4, 
			rd};
		else out_contents <= {WB_control, 
			ALUresult_or_PC_plus_4, 
			rd};
	end
	
	assign MEM_WB_out = out_contents;
	
endmodule