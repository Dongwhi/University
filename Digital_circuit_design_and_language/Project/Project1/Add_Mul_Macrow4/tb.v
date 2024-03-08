`timescale 1ns / 10ps

module tb_macrow4();
	
	parameter period = 10;
	reg CLK, clr_n;

	initial begin
		CLK = 1'b0;
		forever #5 CLK = ~CLK;
	end
	
	reg enX;
	reg [3:0] enW;
	reg [15:0] X_i, W_i;
	wire valid_o;
	wire [15:0] Y_o;

	macrow4 uMAC(.clk(CLK), .reset_n(clr_n), .enX(enX), .enW(enW), .X_i(X_i), .W_i(W_i), .valid_o(valid_o), .Y_o(Y_o));

	initial begin
		//초기화
		clr_n = 1'b1; enX = 1'b0; enW = 4'b0000; W_i = 16'b0; X_i = 16'b0;
		#(period) clr_n = 1'b0;
		#(period) clr_n = 1'b1;
		
		//W에 값 넣어주기
		#(period) enW = 4'b0001;
		W_i = 16'b1_00000_0001010101;
		#(period) enW = 4'b0010;
		W_i = 16'b1_00000_0001010101;
		#(period) enW = 4'b0100;
		W_i = 16'b1_00000_0001010101;
		#(period) enW = 4'b1000;
		W_i = 16'b1_00000_0001010101;
		/*
		#(period) enW = 4'b0001;
		W_i = 16'b0_00100_0101010101;
		#(period) enW = 4'b0010;
		W_i = 16'b0_00100_0000010101;
		#(period) enW = 4'b0100;
		W_i = 16'b0_00100_0101000000;
		#(period) enW = 4'b1000;
		W_i = 16'b0_00100_1010101010;
		*/
		
		
		//X 입력 시작
		#(period) enW = 4'b0000;
		#(period) enX = 1'b1;
		X_i = 16'b0_01100_0101010101;
		#(period) X_i = 16'b0_01100_0101010101;
		#(period) X_i = 16'b0_01100_0101010101;
		#(period) X_i = 16'b0_01100_0101010101;
		
		#(period) X_i = 16'b0_11001_0001110011;
		#(period) X_i = 16'b0_11001_0001110011;
		#(period) X_i = 16'b0_11001_0001110011;
		#(period) X_i = 16'b0_11001_0001110011;
		
		/*
		X_i = 16'b0_01100_0101010101;
		#(period) X_i = 16'b0_01100_0101010101;
		#(period) X_i = 16'b0_01100_0101010101;
		#(period) X_i = 16'b0_01100_0101010101;
		
		#(period) X_i = 16'b0_00100_0101010101;
		#(period) X_i = 16'b0_00010_0111000011;
		#(period) X_i = 16'b0_01101_0000001101;
		#(period) X_i = 16'b0_10001_0000000101;
		*/
		#(period) enX = 1'b0;
		#(200)
		$finish();
	end

	initial begin
		$dumpfile("mactest.dmp");
		$dumpvars;
	end

endmodule



