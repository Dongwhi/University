module ID_EX(
	input CLK, 
	input RSTN, 
	input [1:0] WB_control, 
	input [4:0] MEM_control, 
	input [5:0] EX_control, 
	input [31:0] PC_plus_4, 
	input [31:0] SignextIMM22, 
	input [4:0] rb, 
	input [31:0] Read_data1, 
	input [31:0] Read_data2, 
	input [31:0] SignextIMM17, 
	input i, 
	input [4:0] shamt, 
	input [2:0] cond, 
	input [4:0] rd, 
	input Stall, 
	output [191:0] ID_EX_out
);
	reg [191:0] out_contents;
	
	always @(posedge CLK or negedge RSTN)begin
		if (~RSTN) out_contents <= 192'b0;
		else if (Stall == 1'b1) out_contents <={2'b0, 
			5'b0, 
			6'b0, 
			PC_plus_4, 
			SignextIMM22, 
			rb, 
			Read_data1, 
			Read_data2, 
			SignextIMM17, 
			i, 
			shamt, 
			cond, 
			rd};
		else out_contents <= {WB_control, 
			MEM_control, 
			EX_control, 
			PC_plus_4, 
			SignextIMM22, 
			rb, 
			Read_data1, 
			Read_data2, 
			SignextIMM17, 
			i, 
			shamt, 
			cond, 
			rd};
	end
	
	assign ID_EX_out = out_contents;
	
endmodule