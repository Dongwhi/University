module ALU(
	input [4:0] ALUcontrol, 
	input signed [31:0] IN1, 
	input signed [31:0] IN2, 
	input i, 
	input [4:0] shamt, 
	input [2:0] cond, 
	input [4:0] rb, 
	output signed [31:0] ALUresult, 
	output Brc
);
	reg signed [31:0] result;
	wire unsigned [4:0] shamt_rc;
	reg Brc_reg;
	
	assign shamt_rc = IN2[4:0];
	assign Brc = Brc_reg;
	
	parameter ADDI = 5'b00000,
		ANDI = 5'b00001,
		ORI = 5'b00010,
		MOVI = 5'b00011,
		ADD = 5'b00100,
		SUB = 5'b00101,
		NEG = 5'b00110,
		NOT = 5'b00111,
		AND = 5'b01000,
		OR = 5'b01001,
		XOR = 5'b01010,
		LSR = 5'b01011,
		ASR = 5'b01100,
		SHL = 5'b01101,
		ROR = 5'b01110,
		BR = 5'b01111,
		BRL = 5'b10000,
		J = 5'b10001,
		JL = 5'b10010,
		LD = 5'b10011,
		LDR = 5'b10100,
		ST = 5'b10101,
		STR = 5'b10110;
	
	always @(IN1 or IN2 or ALUcontrol)begin
		case(ALUcontrol)
			ADDI: begin
				result = IN1 + IN2;
				Brc_reg = 1'b0;
			end
			ANDI: begin
				result = IN1 & IN2;
				Brc_reg = 1'b0;
			end
			ORI: begin
				result = IN1 | IN2;
				Brc_reg = 1'b0;
			end
			MOVI: begin
				result = IN2;
				Brc_reg = 1'b0;
			end
			ADD: begin
				result = IN1 + IN2;
				Brc_reg = 1'b0;
			end
			SUB: begin
				result = IN1 - IN2;
				Brc_reg = 1'b0;
			end
			NEG: begin
				result = (~IN2) + 32'b0000_0000_0000_0000_0000_0000_0000_0001;
				Brc_reg = 1'b0;
			end
			NOT: begin
				result = ~IN2;
				Brc_reg = 1'b0;
			end
			AND: begin
				result = IN1 & IN2;
				Brc_reg = 1'b0;
			end
			OR: begin
				result = IN1 | IN2;
				Brc_reg = 1'b0;
			end
			XOR: begin
				result = IN1 ^ IN2;
				Brc_reg = 1'b0;
			end
			LSR: begin
				Brc_reg = 1'b0;
				case(i)
					1'b0: begin
						result = (IN1 >> shamt);
					end
					1'b1: begin
						result = (IN1 >> shamt_rc);
					end
				endcase
			end
			ASR: begin
				Brc_reg = 1'b0;
				case(i)
					1'b0: begin
						result = (IN1 >>> shamt);
					end
					1'b1: begin
						result = (IN1 >>> shamt_rc);
					end
				endcase
			end
			SHL: begin
				Brc_reg = 1'b0;
				case(i)
					1'b0: begin
						result = (IN1 << shamt);
					end
					1'b1: begin
						result = (IN1 << shamt_rc);
					end
				endcase
			end
			ROR: begin
				Brc_reg = 1'b0;
				case(i)
					1'b0: begin
						result = (IN1 << (32 - shamt)) | (IN1 >> shamt);
					end
					1'b1: begin
						result = (IN1 << (32 - shamt_rc)) | (IN1 >> shamt_rc);
					end
				endcase
			end
			BR: begin
				result = 32'b0;
				case(cond)
					3'b000: Brc_reg = 1'b0;
					3'b001: Brc_reg = 1'b1;
					3'b010: if (IN2 == 0) Brc_reg = 1'b1;
						else Brc_reg = 1'b0;
					3'b011: if (IN2 != 0) Brc_reg = 1'b1;
						else Brc_reg = 1'b0;
					3'b100: if (IN2 >= 0) Brc_reg = 1'b1;
						else Brc_reg = 1'b0;
					3'b101: if (IN2 < 0) Brc_reg = 1'b1;
						else Brc_reg = 1'b0;
				endcase
			end
			BRL: begin
				result = 32'b0;
				case(cond)
					3'b000: Brc_reg = 1'b0;
					3'b001: Brc_reg = 1'b1;
					3'b010: if (IN2 == 0) Brc_reg = 1'b1;
						else Brc_reg = 1'b0;
					3'b011: if (IN2 != 0) Brc_reg = 1'b1;
						else Brc_reg = 1'b0;
					3'b100: if (IN2 >= 0) Brc_reg = 1'b1;
						else Brc_reg = 1'b0;
					3'b101: if (IN2 < 0) Brc_reg = 1'b1;
						else Brc_reg = 1'b0;
				endcase
			end
			//J: 
			//JL: 
			LD: begin
				Brc_reg = 1'b0;
				if (rb == 5'b11111) begin
					result = {15'b0, IN2[16:0]};
				end else begin
					result = IN1 + IN2;
				end
			end
			//LDR: 
			ST: begin
				Brc_reg = 1'b0;
				if (rb == 5'b11111) begin
					result = {15'b0, IN2[16:0]};
				end else begin
					result = IN1 + IN2;
				end
			end
			//STR: 
		endcase
	end
	
	assign ALUresult = result;
	
endmodule