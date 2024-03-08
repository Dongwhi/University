module EX_MEM(
	input CLK, 
	input RSTN, 
	input [1:0] WB_control, 
	input [4:0] MEM_control, 
	input [31:0] PC_plus_4, 
	input [31:0] Read_data1, 
	input [31:0] PC_plus_4_plus_SignextIMM22, 
	input Brc, 
	input [31:0] ALUresult, 
	input [31:0] Read_data2, 
	input [4:0] rd, 
	input Stall, 
	output [172:0] EX_MEM_out
);
	reg [172:0] out_contents;
	
	always @(posedge CLK or negedge RSTN)begin
		if (~RSTN) out_contents <= 173'b0;
		else if (Stall == 1'b1) out_contents <= {2'b0, 
			5'b0, 
			PC_plus_4, 
			Read_data1, 
			PC_plus_4_plus_SignextIMM22, 
			Brc, 
			ALUresult, 
			Read_data2, 
			rd};
		else out_contents <= {WB_control, 
			MEM_control, 
			PC_plus_4, 
			Read_data1, 
			PC_plus_4_plus_SignextIMM22, 
			Brc, 
			ALUresult, 
			Read_data2, 
			rd};
	end
	
	assign EX_MEM_out = out_contents;
	
endmodule