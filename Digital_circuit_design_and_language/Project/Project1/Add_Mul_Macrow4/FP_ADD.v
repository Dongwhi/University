module FP_ADD(
	input [15:0] opA_i, opB_i,
	output [15:0] ADD_o
);
	//내부 변수
	reg SIGN_A, SIGN_B; //sign 저장용 reg
	reg [4:0] EXPO_A, EXPO_B; //exponent 저장용 reg
	reg [9:0] MANT_A, MANT_B; //mantisa 저장용 reg
	
	reg Sign; //출력의 sign
	reg [4:0] Exponent; //출력의 exponent
	reg [9:0] Mantisa; //출력의 mantisa
	
	reg [21:0] Mant_val_A, Mant_val_B; //각 Mantisa의 MSB에 Denormalized일 때 0, normalized일 때 1을 추가하고 그 뒤에 0을 10개 붙인 후 맨 앞에 0을(overflow방지)붙여서 저장할 reg
	reg [21:0] Mant_A_shifted, Mant_B_shifted; //각 Mant_val_A, B를 알맞게 shift한 값을 저장할 reg
	reg [21:0] Mant_result; //Mantisa의 합(혹은 차)을 저장할 reg
	reg [41:0] Mant_rounded; //Mant_result의 양끝에 0을 10bit씩 추가하고 반올림된 Mantisa의 합(혹은 차)을 저장할 reg
	reg [4:0] Expo_result; //A, B중 exponent가 높은 수의 exponent를 저장할 reg
	reg signed [6:0] Expo_shifted; //Exponent의 덧셈이 mantisa에 의해 normaliz된 값을 저장할 reg
	reg signed [6:0] Expo_shifted_plus_10; //if 조건문에서 +10을 쓰면 unsigned value로 작용해서 미리 더해준 값을 따로 저장
	reg [5:0] denorm_round_ind; //if 조건문에서 변수의 합을 받아들이지 못해서 다른 변수에 합을 따로 저장한 후 사용하기 위한 reg
	reg [5:0] round_bit_ind; //위와 같은 이유
	
	reg [1:0] AB_abs; //A와 B의 절댓값 크기 비교 정보를 담은 reg
	reg [1:0] AB_sign; //A와 B의 부호 정보를 담은 reg
	parameter AB_same = 2'b00, A_bigger_B = 2'b01, B_bigger_A = 2'b10; //A와 B의 절댓값의 크기 비교 결과를 나타내는 parameter
	parameter nA_nB = 2'b00, nA_pB = 2'b01, pA_nB = 2'b10, pA_pB = 2'b11; //A와 B의 부호를 나타내는  parameter
	
	wire [2:0] zero_count[0:2]; //Mant_result에서 22비트를 8비트씩 3개로 묶었을 때 각 묶음에서 처음 1이 나오는 위치. 마지막 묶음은 LSB에 00 추가.
	wire valid[0:2]; //세 묶음 각각이 1을 포함하는지 여부
	reg [4:0] zero_detected; //Mant_result에서 처음 1이 나오는 위치
	reg [4:0] zero_index; //Mant_result에서 처음 1이 나오는 곳의 인덱스
	
	reg denorm; //출력을 denormalized로 만들어야 할 때 1
	reg unsigned [5:0] denorm_ind; //denormalization할 때 Mantisa에 넣을 값의 시작점의 index
	
	reg round_bit; //rount bit를 저장할 reg
	reg [41:0] round_val; //반올림을 위해 더할 값을 저장할 reg
	integer count; //for문을 위한 정수

	reg [15:0] add_out; //ADD_o에 값을 줄 때 always 안에서 주면 에러가 나서 한 번 거쳐서 주려고 만든 변수
	
	//sign, exponent, mantisa 분리
	always @(*) begin
		SIGN_A = opA_i[15]; //sign 저장
		SIGN_B = opB_i[15];
		EXPO_A = opA_i[14:10]; //exponent 저장
		EXPO_B = opB_i[14:10];	
		MANT_A = opA_i[9:0]; //mantisa 저장
		MANT_B = opB_i[9:0];
	end
	
	//normalized, denormalized에 따라 mantisa의 실질적 value 조절
	always @*begin
		if (EXPO_A == 0) Mant_val_A = {2'b00, MANT_A, 10'b0}; //Denormalized일 때 mantisa의 MSB에 0 추가
		else Mant_val_A = {1'b0, 1'b1, MANT_A, 10'b0}; //normalized일 때 mantisa의 MSB에 1 추가
		if (EXPO_B == 0) Mant_val_B = {2'b00, MANT_B, 10'b0}; //Denormalized일 때 mantisa의 MSB에 0 추가
		else Mant_val_B = {1'b0, 1'b1, MANT_B, 10'b0}; //normalized일 때 mantisa의 MSB에 1 추가
	end
	
	//A와 B의 exponent에 따라 mantisa를 shift하기.
	always @*begin
		if (EXPO_A == EXPO_B)begin //두 수의 exponent가 같을 때
			Mant_A_shifted = Mant_val_A;
			Mant_B_shifted = Mant_val_B;
		end else if (EXPO_A > EXPO_B)begin
			Mant_A_shifted = Mant_val_A;
			Mant_B_shifted = Mant_val_B >> (EXPO_A - EXPO_B);
		end else if (EXPO_A < EXPO_B)begin
			Mant_A_shifted = Mant_val_A >> (EXPO_B - EXPO_A);
			Mant_B_shifted = Mant_val_B;
		end
	end
	
	//A와 B의 shift된 mantisa의 절댓값 크기에 따라 AB_abs 변수 조절
	always @*begin
		if (EXPO_A == EXPO_B)begin //두 수의 exponent가 같을 
			Expo_result = EXPO_A;
			if (Mant_A_shifted == Mant_B_shifted) AB_abs = AB_same;
			else if (Mant_A_shifted > Mant_B_shifted) AB_abs = A_bigger_B;
			else if (Mant_val_A < Mant_B_shifted) AB_abs = B_bigger_A;
		end else if (EXPO_A > EXPO_B)begin
			Expo_result = EXPO_A;
			AB_abs = A_bigger_B;
		end else if (EXPO_A < EXPO_B)begin
			Expo_result = EXPO_B;
			AB_abs = B_bigger_A;
		end
	end
	
	//A와 B의 부호에 따라 AB_sign 변수 조절
	always @*begin
		if (SIGN_A == 1'b1 && SIGN_B == 1'b1) AB_sign = nA_nB;
		else if (SIGN_A == 1'b1 && SIGN_B == 1'b0) AB_sign = nA_pB;
		else if (SIGN_A == 1'b0 && SIGN_B == 1'b1) AB_sign = pA_nB;
		else if (SIGN_A == 1'b0 && SIGN_B == 1'b0) AB_sign = pA_pB;
	end
	
	//A, B의 shift된 절댓값과 부호에 따라 출력의 Mantisa(반올림 전)과 Sign 결정
	always @*begin
		case(AB_sign)
			nA_nB : begin
				Sign = 1'b1;
				Mant_result = Mant_A_shifted + Mant_B_shifted;
			end
			nA_pB : begin
				case(AB_abs)
					AB_same : begin
						Sign = 1'b0;
						Mant_result = 22'b0;
					end
					A_bigger_B : begin
						Sign = 1'b1;
						Mant_result = Mant_A_shifted - Mant_B_shifted;
					end
					B_bigger_A : begin
						Sign = 1'b0;
						Mant_result = Mant_B_shifted - Mant_A_shifted;
					end
				endcase
			end
			pA_nB : begin
				case(AB_abs)
					AB_same : begin
						Sign = 1'b0;
						Mant_result = 22'b0;
					end
					A_bigger_B : begin
						Sign = 1'b0;
						Mant_result = Mant_A_shifted - Mant_B_shifted;
					end
					B_bigger_A : begin
						Sign = 1'b1;
						Mant_result = Mant_B_shifted - Mant_A_shifted;
					end
				endcase
			end
			pA_pB : begin
				Sign = 1'b0;
				Mant_result = Mant_A_shifted + Mant_B_shifted;
			end
		endcase
	end
	
	
	//LZdetect8로 8bit씩 처음 나오는 1의 위치 구하기
	LZdetect8 u1(.IN(Mant_result[21:14]), .VALID(valid[0]), .POSITION(zero_count[0])); //Mant_result의 앞 8비트에서 처음 나오는 1의 위치
	LZdetect8 u2(.IN(Mant_result[13:6]), .VALID(valid[1]), .POSITION(zero_count[1])); //Mant_result의 중간 8비트에서 처음 나오는 1의 위치
	LZdetect8 u3(.IN({Mant_result[5:0], 2'b00}), .VALID(valid[2]), .POSITION(zero_count[2])); //Mant_result의 끝 6비트에서 처음 나오는 1의 위치
	//Mantisa의 합에서 처음 나오는 1의 위치 구하기
	always @(*)begin
		if (valid[0] == 1) zero_detected = zero_count[0];
		else if (valid[1] == 1) zero_detected = zero_count[1] + 8;
		else if (valid[2] == 1) zero_detected = zero_count[2] + 16;
		else zero_detected = 5'b11111; //Mantisa의 합이 0이면 1의 위치에 해당하는 변수를 5'b11111로 설정
	end
	always @*begin
		zero_index = 21-zero_detected;
	end
	
	//출력의 exponent 구하기
	always @*begin
		Expo_shifted = Expo_result + 1 - zero_detected;
		Expo_shifted_plus_10 = Expo_shifted + 10;
	end
	always @(*) begin
		if (EXPO_A == 5'b11111 || EXPO_B == 5'b11111) begin //입력이 overlfow라면 
			Exponent = 5'b11111;
			denorm = 0;
		end else if (zero_detected == 0) begin //mantisa의 곱에서 1이 맨 처음 자리에 나왔다면
			if (Expo_result + 1 >= 31) begin //exponent의 합에 1을 더했을 때 31 이상이라면
				Exponent = 5'b11111; //출력의 exponent를 11111로
			end else begin //enponent의 합이 적절한 범위 안쪽이라면
				Exponent = Expo_result + 1; //출력의 exponent를 계산된 값으로
			end
			denorm = 0;
		end else if (Expo_shifted > 0) begin //mantisa를 normaliz하기 위해 exponent를 줄였을 때 exponent가 적절한 범위 안쪽이라면
			Exponent = Expo_shifted;
			denorm = 0;
		end else if (Expo_shifted <= 0) begin //mantisa를 normaliz하기 위해 exponent를 줄였을 때 exponent가 0 이하가 된다면
			Exponent = 5'b00000;
			denorm = 1;
		end
	end
	
	//반올림하기
	always @*begin
		denorm_round_ind = 21-zero_detected-Expo_shifted+1;
		round_bit_ind = 21-zero_detected - 10 - Expo_shifted;
	end
	always @(*) begin
		if (denorm == 1)begin //denormalize 형태로 써야한다면
			if (zero_index < Expo_shifted_plus_10) begin //처음 나온 1 뒤에 남은 bit 수가 적어 반올림이 필요없을 때
				Mant_rounded = {10'b0, Mant_result, 10'b0};
			end else begin //
				round_bit = Mant_result[round_bit_ind];
				for (count = 0; count < 42; count++)begin
					if (count == denorm_round_ind) round_val[count] = 1;
					else round_val[count] = 0;
				end
				Mant_rounded = {10'b0, Mant_result, 10'b0} + ((round_bit == 0)? {42'b0}:round_val);
			end
		end else if (21-zero_detected < 11) begin //normalize일 때는 처음 나온 1 뒤에 11개보다 적은 bit가 남아있다면 반올림이 필요없으므로
			Mant_rounded = {10'b0, Mant_result, 10'b0}; //길이만 늘려서 Mant_rounded를 초기화
		end else begin //11bits 이상 남아있다면
			round_bit = Mant_result[21-zero_detected-11]; //round bit를 구하고
			for (count = 0; count < 42; count++)begin
				if (count == 21-zero_detected) round_val[count] = 1;
				else round_val[count] = 0;
			end
			Mant_rounded = {10'b0, Mant_result, 10'b0} + ((round_bit == 0)? {32'b0}:round_val);
		end
	end
	
	
	//출력의 mantisa 구하기
	always @*begin
		denorm_ind = 21 - zero_detected + 20 - Expo_shifted - 1;
	end
	always @(*) begin
		if (zero_detected == 5'b11111) begin //mantisa가 0이면
			Mantisa = 10'b0000_0000_00;
		end else if (denorm == 1) begin //출력이 denormalized로 만들어야 하는 범위라면
			Mantisa = Mant_rounded[denorm_ind -: 10];
		end else begin //출력이 normalized로 만들 수 있는 범위라면
			Mantisa = Mant_rounded[21 - zero_detected + 10 - 1 -: 10]; //Mantisa는 처음 나온 1의 바로 다음 10bits
		end
	end
	
	//출력 concatenation하기
	always @(*) begin
		if (EXPO_A != 5'b11111 && EXPO_B != 5'b11111) add_out = {Sign, Exponent, Mantisa}; //입력이 overflow가 아닐 때만 계산 결과를 concatenation하기
		else add_out = 16'b0_11111_0000000000; //입력이 overflow라면 출력을 15'b0_11111_0000000000로 만들기
	end
	
	//MUL_o에 값 넣기
	assign ADD_o = add_out;
	
	
endmodule

