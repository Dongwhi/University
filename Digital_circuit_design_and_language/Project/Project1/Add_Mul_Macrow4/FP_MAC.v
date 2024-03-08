module FP_MAC(
	input clk, 
	input reset_n, 
	input val_MAC, 
	input enA, enB, 
	input [15:0] opA, opB,
	input enADD, 
	input [15:0] opADD, 
	output val_o, 
	output [15:0] out_o
);

//Pipe Reg0 - MUL - Pipe Reg1 - ADD - Pipe Reg2 ->OUT

	/*
	reg	[4:0] creg;
	wire	Zero = (creg == 0);	// counter is zero
	wire	en = (creg != 0); // en when counter reg is not zero
	*/
	
	//Simple Counter-based CTRL
	// If start -> Set creg to count. If Zero -> Stop decrement.
	always @(posedge clk or negedge reset_n) begin
		if (~reset_n) begin
			/*creg <= 0;*/
			Ain_r0 <= 0;
			Bin_r0 <= 0;
			ADDin_r1 <= 0;
			mul_r1 <= 0;
			sum_r2 <= 0;
			val_AB <= 0;
			val_out <= 0;
			/*
			En_reg0 <= 0;
			En_reg1 <= 0;
			En_reg2 <= 0;
			*/
		end
		/*
		if (start) creg <= count;
		if (en) creg <= creg - 1;
		*/
	end
	
	//assign finish = (!en) && (!En_reg0) && (!En_reg1) && En_reg2;
	
	//DATAPATH (Declare any additional regs/wires if required.)
	//reg En_reg0, En_reg1, En_reg2;
	reg [15:0] Ain_r0, Bin_r0;
	reg [15:0] ADDin_r1;
	wire [15:0] mul_out, sum_out;
	reg [15:0] mul_r1, sum_r2;
	
	/*
	always @(posedge clk) begin
		if (en) En_reg0 <= 1; else En_reg0 <= 0;
		if (En_reg0) En_reg1 <= 1; else En_reg1 <= 0;
		if (En_reg1) En_reg2 <= 1; else En_reg2 <= 0;
	end
	*/
	
	//Pipe Reg0
	always @(posedge clk) begin
		if (reset_n == 1) begin
			if (enA == 1 && val_MAC == 1) Ain_r0 <= opA;
			else Ain_r0 <= Ain_r0;
			if (enB == 1 && val_MAC == 1) Bin_r0 <= opB;
			else Bin_r0 <= Bin_r0;
		end
	end
	
	//MUL
	FP_MUL u1(.opA_i(Ain_r0), .opB_i(Bin_r0), .MUL_o(mul_out));

	//Pipe Reg1
	always @(posedge clk) begin
		mul_r1 <= mul_out;
		if(enADD == 1 && val_MAC == 1) ADDin_r1 <= opADD;
		else ADDin_r1 <= 16'b0;
	end

	//ADD
	FP_ADD u2(.opA_i(mul_r1), .opB_i(ADDin_r1), .ADD_o(sum_out));
	
	//Pipe Reg2
	/*
	always @(posedge clk) begin
		sum_r2 <= sum_out;
	end
	*/
	
	
	//output
	assign out_o = sum_out;
	
	//val 신호는 처음에 enA, enB가 1이고, 다음클럭에 enADD가 1이면 그 다음 클럭에 1이 된다.
	//즉 필요한건 이전에 enA, enB가 동시에 1이었으면 지금 1이 되는 변수와, 그 변수와 enADD가 동시에 1이면 다음클럭에 1이되는 변수
	reg val_AB;
	reg val_out;
	always @(posedge clk)begin
		if (enA == 1 && enB == 1 && val_MAC == 1) val_AB <= 1;
		else val_AB <= 0;
	end
	always @(posedge clk)begin
		if (val_AB == 1 && enADD == 1 && val_MAC == 1) val_out <= 1;
		else val_out <= 0;
	end
	assign val_o = val_out;
	
endmodule

