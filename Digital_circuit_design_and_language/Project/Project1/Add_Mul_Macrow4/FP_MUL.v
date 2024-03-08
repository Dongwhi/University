module FP_MUL(
	input [15:0] opA_i, opB_i,
	output [15:0] MUL_o
);
	//내부 변수
	reg SIGN_A, SIGN_B; //sign 저장용 reg
	reg [4:0] EXPO_A, EXPO_B; //exponent 저장용 reg
	reg [9:0] MANT_A, MANT_B; //mantisa 저장용 reg
	
	reg Sign; //출력의 sign
	reg [4:0] Exponent; //출력의 exponent
	reg [9:0] Mantisa; //출력의 mantisa
	
	reg [10:0] Mant_val_A, Mant_val_B; //각 Mantisa의 MSB에 Denormalized일 때 0, normalized일 때 1을 추가하여 저장할 reg
	reg signed [6:0] Expo_result; //Exponent의 덧셈을 저장할 reg
	reg signed [6:0] Expo_shifted; //Exponent의 덧셈이 mantisa에 의해 normaliz된 값을 저장할 reg
	reg [21:0] Mant_result; //Mantisa의 곱셈을 저장할 reg
	reg [32:0] Mant_rounded; //Mantisa의 곱셈에서 적절한 위치를 반올림한 결과를 저장할 reg
	reg signed [6:0] Expo_shifted_plus_10; //if 조건문에서 +10을 쓰면 unsigned value로 작용해서 미리 더해준 값을 따로 저장
	reg [5:0] denorm_round_ind; //if 조건문에서 변수의 합을 받아들이지 못해서 다른 변수에 합을 따로 저장한 후 사용하기 위한 reg
	reg [5:0] round_bit_ind; //위와 같은 이유
	
	wire [2:0] zero_count1[0:2]; //Mant_result에서 22비트를 8비트씩 3개로 묶었을 때 각 묶음에서 처음 1이 나오는 위치. 마지막 묶음은 LSB에 00 추가.
	wire valid1[0:2]; //세 묶음 각각이 1을 포함하는지 여부
	reg [4:0] zero_detected1; //Mant_result에서 처음 1이 나오는 위치
	reg [4:0] zero_index; //Mant_result에서 처음 1이 나오는 곳의 인덱스
	
	wire [2:0] zero_count2[0:2]; //Mant_rounded에서 MSB 24비트를 8비트씩 3개로 묶었을 때 각 묶음에서 처음 1이 나오는 위치
	wire valid2[0:2]; //세 묶음 각각이 1을 포함하는지 여부
	reg [4:0] zero_detected2; //Mant_rounded에서 처음 1이 나오는 위치
	
	reg denorm; //출력을 denormalized로 만들어야 할 때 1
	
	reg round_bit; //rount bit를 저장할 reg
	reg [32:0] round_val; //반올림을 위해 더할 값을 저장할 reg
	integer count; //for문을 위한 정수
	
	reg [15:0] mul_out; //MUL_o에 값을 줄 때 always 안에서 주면 에러가 나서 한 번 거쳐서 주려고 만든 변수
	reg [63:0] Mant_rounded_den; //denormalization할 때 첫 1 왼쪽에 0이 더 있어야해서 Mant_rounded의 왼쪽에 0을 추가한 변수 
	reg unsigned [5:0] denorm_ind; //denormalization할 때 Mantisa에 넣을 값의 시작점의 index
	
	reg Ex_A_den, Ex_B_den;
	
	//sign, exponent, mantisa 분리
	always @(*) begin
		SIGN_A = opA_i[15]; //sign 저장
		SIGN_B = opB_i[15];
		EXPO_A = opA_i[14:10]; //exponent 저장
		EXPO_B = opB_i[14:10];	
		MANT_A = opA_i[9:0]; //mantisa 저장
		MANT_B = opB_i[9:0];
	end

	//denormalize에서 Exponent가 0일 때와 normalize에서 Exponent가 1일 때가 같으므로
	always @* begin
		if (EXPO_A == 5'b00000) Ex_A_den = 1;
		else Ex_A_den = 0;
		if (EXPO_B == 5'b00000) Ex_B_den = 1;
		else Ex_B_den = 0;
	end
	
	//출력의 sign 정하기
	always @* begin
		Sign = SIGN_A ^ SIGN_B; //출력의 sign 결정
	end
	
	
	//출력의 exponent, mantisa를 구하기 위한 준비
	always @* begin
		Expo_result = {1'b0, EXPO_A} + {1'b0, EXPO_B} - 15; //A와 B의 exponent를 더하면 bias가 2번 더해진 꼴이므로 bias를 한 번 빼줌
	end
	
	
	always @(*)begin
		if (EXPO_A == 0) Mant_val_A = {1'b0, MANT_A}; //Denormalized일 때 mantisa의 MSB에 0 추가
		else Mant_val_A = {1'b1, MANT_A}; //normalized일 때 mantisa의 MSB에 1 추가
		if (EXPO_B == 0) Mant_val_B = {1'b0, MANT_B}; //Denormalized일 때 mantisa의 MSB에 0 추가
		else Mant_val_B = {1'b1, MANT_B}; //normalized일 때 mantisa의 MSB에 1 추가
	end
	
	
	always @* begin
		Mant_result = Mant_val_A * Mant_val_B;
	end
	
	//LZdetect8로 8bit씩 처음 나오는 1의 위치 구하기
	LZdetect8 u1(.IN(Mant_result[21:14]), .VALID(valid1[0]), .POSITION(zero_count1[0])); //Mant_result의 앞 8비트에서 처음 나오는 1의 위치
	LZdetect8 u2(.IN(Mant_result[13:6]), .VALID(valid1[1]), .POSITION(zero_count1[1])); //Mant_result의 중간 8비트에서 처음 나오는 1의 위치
	LZdetect8 u3(.IN({Mant_result[5:0], 2'b00}), .VALID(valid1[2]), .POSITION(zero_count1[2])); //Mant_result의 끝 6비트에서 처음 나오는 1의 위치
	LZdetect8 u11(.IN(Mant_rounded[32:25]), .VALID(valid2[0]), .POSITION(zero_count2[0])); //Mant_rounded의 첫 번째 8비트에서 처음 나오는 1의 위치
	LZdetect8 u12(.IN(Mant_rounded[24:17]), .VALID(valid2[1]), .POSITION(zero_count2[1])); //Mant_rounded의 두 번째 8비트에서 처음 나오는 1의 위치
	LZdetect8 u13(.IN({Mant_rounded[16:9]}), .VALID(valid2[2]), .POSITION(zero_count2[2])); //Mant_rounded의 세 번째 8비트에서 처음 나오는 1의 위치
	//Mantisa의 곱 전체에서 처음 나오는 1의 위치 구하기
	always @(*)begin
		if (valid1[0] == 1) zero_detected1 = zero_count1[0];
		else if (valid1[1] == 1) zero_detected1 = zero_count1[1] + 8;
		else if (valid1[2] == 1) zero_detected1 = zero_count1[2] + 16;
		else zero_detected1 = 5'b11111; //Mantisa의 곱이 0이면 1의 위치에 해당하는 변수를 5'b11111로 설정
		if (valid2[0] == 1) zero_detected2 = zero_count2[0];
		else if (valid2[1] == 1) zero_detected2 = zero_count2[1] + 8;
		else if (valid2[2] == 1) zero_detected2 = zero_count2[2] + 16;
	end
	always @*begin
		zero_index = 21-zero_detected1;
	end
	
	//출력의 exponent 구하기
	always @*begin
		Expo_shifted = Expo_result + 1 - zero_detected1 + Ex_A_den + Ex_B_den;
		Expo_shifted_plus_10 = Expo_shifted + 10;
	end
	always @(*) begin
		if (EXPO_A == 5'b11111 || EXPO_B == 5'b11111) begin //입력이 overlfow라면 
			Exponent = 5'b11111;
			denorm = 0;
		end else if(zero_detected1 == 0) begin //mantisa의 곱에서 1이 맨 처음 자리에 나왔다면
			if (Expo_result + 1 >= 31) begin //exponent의 합에 1을 더했을 때 31 이상이라면
				Exponent = 5'b11111; //출력의 exponent를 11111로
			end else begin //enponent의 합이 적절한 범위 안쪽이라면
				Exponent = Expo_result + 1; //출력의 exponent를 계산된 값으로
			end
			denorm = 0;
		end else if (Expo_shifted > 0) begin //mantisa를 normaliz하기 위해 exponent를 줄여야 할 때 exponent가 적절한 범위 안쪽이라면
			Exponent = Expo_shifted;
			denorm = 0;
		end else if (Expo_shifted <= 0) begin //mantisa를 normaliz하기 위해 exponent를 줄여야 할 때 exponent가 0 이하가 된다면
			Exponent = 5'b00000;
			denorm = 1;
			
		end
	end

	//반올림하기. 처음 나온 1 뒤의 11번째 bit가 1이면 뒤 10번째 bit에 +1 0이면 +0
	always @*begin
		denorm_round_ind = 21-zero_detected1-Expo_shifted+1;
		round_bit_ind = 21-zero_detected1 - 10 - Expo_shifted;
	end
	always @(*) begin
		if (denorm == 1) begin //denormalize 해야한다면 
			if (zero_index < Expo_shifted_plus_10) begin //처음 나온 1 뒤에 남은 bit 수가 적어 반올림이 필요없을 때
				Mant_rounded = {1'b0, Mant_result, 10'b0};
			end else begin //
				round_bit = Mant_result[round_bit_ind];
				for (count = 0; count < 33; count++)begin
					if (count == denorm_round_ind) round_val[count] = 1;
					else round_val[count] = 0;
				end
				Mant_rounded = {1'b0, Mant_result, 10'b0} + ((round_bit == 0)? {32'b0}:round_val);
			end
		end else if (21-zero_detected1 < 11) begin //처음 나온 1 뒤에 11개보다 적은 bit가 남아있다면 반올림이 필요없으므로
			Mant_rounded = {1'b0, Mant_result, 10'b0}; //길이만 늘려서 Mant_rounded를 초기화
		end else begin //11bits 이상 남아있다면
			round_bit = Mant_result[21-zero_detected1-11]; //round bit를 구하고
			for (count = 0; count < 33; count++)begin
				if (count == 21-zero_detected1) round_val[count] = 1;
				else round_val[count] = 0;
			end
			Mant_rounded = {1'b0, Mant_result, 10'b0} + ((round_bit == 0)? {32'b0}:round_val);
		end
	end

	//출력의 mantisa 구하기
	always @*begin
		Mant_rounded_den = {31'b0, Mant_rounded};
	end
	always @*begin
		denorm_ind = 32 - zero_detected2 - Expo_shifted;
	end
	always @(*) begin
		if (zero_detected1 == 5'b11111) begin //mantisa가 0이면
			Mantisa = 10'b0000_0000_00;
		end else if (denorm == 1) begin //출력이 denormalized로 만들어야 하는 범위라면
			Mantisa = Mant_rounded_den[denorm_ind -: 10];
		end else begin //출력이 normalized로 만들 수 있는 범위라면
			Mantisa = Mant_rounded[32 - zero_detected2 - 1 -: 10]; //Mantisa는 처음 나온 1의 바로 다음 10bits
		end
	end
	//출력 concatenation하기
	always @(*) begin
		if (EXPO_A != 5'b11111 && EXPO_B != 5'b11111) mul_out = {Sign, Exponent, Mantisa}; //입력이 overflow가 아닐 때만 계산 결과를 concatenation하기
		else mul_out = 16'b0_11111_0000000000; //입력이 overflow라면 출력을 15'b0_11111_0000000000로 만들기
	end
	
	
	//MUL_o에 값 넣기
	assign MUL_o = mul_out;
	
endmodule

