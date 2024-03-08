module macrow4(
	input clk, 
	input reset_n, 
	input enX, 
	input [3:0] enW, 
	input [15:0] X_i, W_i,
	output valid_o, 
	output [15:0] Y_o
);
	
	parameter w3 = 4'b1000, w2 = 4'b0100, w1 = 4'b0010, w0 = 4'b0001;
	reg [15:0] Xin;
	reg [15:0] Win[0:3];
	integer i;
	reg sub_clk;
	
	always @(clk)begin
		sub_clk <= clk;
	end
	
	
	always @(posedge clk or negedge reset_n) begin
		if (~reset_n) begin
			Xin <= 0;
			for (i = 0; i < 4; i++)begin
				Win[i] <= 0;
				enA[i] <= 0;
				enB[i] <= 0;
				enADD[i] <= 0;
				val_to[i] <= 0;
			end
			count <= 0;
		end
	end
	
	//X_i가 유효한 신호이면(enX == 1이면) Xin에 X_i를 저장
	always @(posedge clk)begin
		if (enX == 1) Xin <= X_i;
		else Xin <= Xin;
	end
	
		
	//W_i 입력을 enW 신호에 따라 Win reg에 저장
	always @(posedge clk)begin
		case(enW)
			w0: Win[0] <= W_i;
			w1: Win[1] <= W_i;
			w2: Win[2] <= W_i;
			w3: Win[3] <= W_i;
		endcase
	end
	
	//추가 필요 변수
	reg enA[0:3];
	reg enB[0:3];
	reg enADD[0:3];
	wire [15:0] Wout[0:3];
	reg val_to[0:3];
	wire val_from[0:3];
	
	//각 MAC을 순서대로 사용하기 위해 enX가 1인 상황을 count하는 변수 필요. 4번(연속 아니어도 됨) enX가 1이었으면 이때부터 출력이 유효(valid_o == 1)
	reg [3:0] count;
	parameter mac0 = 4'b0000, mac1 = 4'b1000, mac2 = 4'b0100, mac3 = 4'b0010, mac4 = 4'b0001;
	
	/*
	always @(posedge enX)begin
		enA[0] <= 1;
		enB[0] <= 1;
		enADD[0] <= 1;
		val_to[0] <= 1;
	end
	always @(negedge clk)begin
		for (i = 0; i < 3; i++)begin
			if (enA[i] == 1) enA[i+1] <= 1;
			else enA[i+1] <= 0;
			if (enB[i] == 1) enB[i+1] <= 1;
			else enB[i+1] <= 0;
			if (enADD[i] == 1) enADD[i+1] <= 1;
			else enADD[i+1] <= 0;
			if (val_to[i] == 1) val_to[i+1] <= 1;
			else val_to[i+1] <= 0;
		end
	end
	*/
	
	always @(posedge clk)begin
		if (enX == 1 && reset_n == 1) begin
			case(count)
				mac0: begin
					enA[0] <= 1;
					enB[0] <= 1;
					enADD[0] <= 1;
					val_to[0] <= 1;
					count <= mac1;
				end
				mac1: begin
					enA[1] <= 1;
					enB[1] <= 1;
					enADD[1] <= 1;
					val_to[1] <= 1;
					count <= mac2;
				end
				mac2: begin
					enA[2] <= 1;
					enB[2] <= 1;
					enADD[2] <= 1;
					val_to[2] <= 1;
					count <= mac3;
				end
				mac3: begin
					enA[3] <= 1;
					enB[3] <= 1;
					enADD[3] <= 1;
					val_to[3] <= 1;
					count <= mac4;
				end
				mac4: count <= mac4;
			endcase
		end
	end
	
	
	FP_MAC u1(.clk(sub_clk),  .reset_n(reset_n), .val_MAC(val_to[0]), .enA(enA[0]), .enB(enB[0]), .opA(Xin), .opB(Win[0]), .enADD(enADD[0]), .opADD(16'b0), .val_o(val_from[0]), .out_o(Wout[0]));
	FP_MAC u2(.clk(sub_clk),  .reset_n(reset_n), .val_MAC(val_to[1]), .enA(enA[1]), .enB(enB[1]), .opA(Xin), .opB(Win[1]), .enADD(enADD[1]), .opADD(Wout[0]), .val_o(val_from[1]), .out_o(Wout[1]));
	FP_MAC u3(.clk(sub_clk),  .reset_n(reset_n), .val_MAC(val_to[2]), .enA(enA[2]), .enB(enB[2]), .opA(Xin), .opB(Win[2]), .enADD(enADD[2]), .opADD(Wout[1]), .val_o(val_from[2]), .out_o(Wout[2]));
	FP_MAC u4(.clk(sub_clk),  .reset_n(reset_n), .val_MAC(val_to[3]), .enA(enA[3]), .enB(enB[3]), .opA(Xin), .opB(Win[3]), .enADD(enADD[3]), .opADD(Wout[2]), .val_o(val_from[3]), .out_o(Wout[3]));
	
	assign valid_o = val_from[3];
	assign Y_o = Wout[3];
	
endmodule

