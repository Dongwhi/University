module RISC_TOY( 
	input CLK, 
	input RSTN, 
	output IREQ, 
	output [29:0] IADDR, 
	input [31:0] INSTR, 
	output DREQ, 
	output DRW, 
	output [29:0] DADDR, 
	output [31:0] DWDATA,
	input [31:0] DRDATA
);
	reg sub_clk;
	always @(CLK)begin
		sub_clk <= CLK;
	end
	
	// ID_EX이것도 Stall 해야하나? 해야한다면 어떻게 해야하나?
	//-----------------------Variables----------------------------
	
	//IF
	wire [31:0] current_PC_IF;
	wire [31:0] PC_plus_4_IF;
	wire [31:0] next_PC_IF;
	wire PCSrc_IF;
	
	//ID
	wire RegWrite_ID;
	wire MemtoReg_ID;
	wire Branch_ID;
	wire Jump_ID;
	wire LDRSTR_ID;
	wire MemWrite_ID;
	wire MemRead_ID;
	wire ALUSrc_ID;
	wire [4:0]ALUcontrol_ID;
	wire RegDst_ID;
	wire Branch_Jump_ID;
	
	wire [31:0] IF_ID_out;
	wire [31:0] PC_plus_4_ID;
	wire [31:0] Instruction_ID;
	wire [31:0] SignextIMM17_ID;
	wire [31:0] SignextIMM22_ID;
	wire [31:0] Read_data1_ID;
	wire [31:0] Read_data2_ID;
	wire [4:0] Read_register1_ID;
	wire [4:0] Read_register2_ID;
	wire [4:0] rc;
	wire [4:0] ra;
	wire i_ID;
	wire [4:0] shamt_ID;
	wire [2:0] cond_ID;
	wire [4:0] rd_ID;
	
	//EX
	wire RegWrite_EX;
	wire MemtoReg_EX;
	wire Branch_EX;
	wire Jump_EX;
	wire LDRSTR_EX;
	wire MemWrite_EX;
	wire MemRead_EX;
	wire ALUSrc_EX;
	wire [4:0]ALUcontrol_EX;
	
	wire [191:0] ID_EX_out;
	wire [31:0] PC_plus_4_EX;
	wire [31:0] SignextIMM17_EX;
	wire [31:0] SignextIMM22_EX;
	wire [4:0] rb_EX;
	wire [31:0] Read_data1_EX;
	wire [31:0] Read_data2_EX;
	wire i_EX;
	wire [4:0] shamt_EX;
	wire [2:0] cond_EX;
	wire [4:0] rd_EX;
	wire [31:0] ALU_IN1_EX;
	wire [31:0] ALU_IN2_EX;
	wire Brc_EX;
	wire [31:0] ALUresult_EX;

	//MEM
	wire RegWrite_MEM;
	wire MemtoReg_MEM;
	wire Branch_MEM;
	wire Jump_MEM;
	wire LDRSTR_MEM;
	wire MemWrite_MEM;
	wire MemRead_MEM;
	
	wire [172:0] EX_MEM_out;
	wire [31:0] PC_plus_4_MEM;
	wire [31:0] Read_data1_MEM;
	wire [31:0] PC_plus_4_plus_SignextIMM22_MEM;
	wire Brc_MEM;
	wire [31:0] ALUresult_MEM;
	wire [31:0] Read_data2_MEM;
	wire [4:0] rd_MEM;
	wire [31:0] Address_MEM;
	wire [31:0] next_PC_MEM;
	wire [31:0] PC_plus_4_or_ALUresult_MEM;
	
	//WB
	wire RegWrite_WB;
	wire MemtoReg_WB;
	
	wire [38:0] MEM_WB_out;
	wire [31:0] Mem_Read_data_WB;
	wire [31:0] PC_plus_4_or_ALUresult_WB;
	wire [4:0] rd_WB;
	wire [31:0] Reg_Write_data_WB;
	
	
	
	//-----------------------Units, additional function----------------------------
	
	//IF
	assign PC_plus_4_IF = current_PC_IF + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
	assign next_PC_IF = (PCSrc_IF == 1)? next_PC_MEM : PC_plus_4_IF;
	assign PCSrc_IF = Branch_MEM | Jump_MEM;
	
	IF IFu(
					.CLK(CLK), 
					.RSTN(RSTN), 
					.next_PC(next_PC_IF), 
					.Stall(Stall_PC), 
					.IF_out(current_PC_IF)
	);

	//IF_ID
	IF_ID IF_IDu(
					.CLK(CLK),
					.RSTN(RSTN),
					.PC_plus_4(PC_plus_4_IF),
					.Stall(Stall_IF_ID),
					.IF_ID_out(IF_ID_out)
	);
	
	//ID
	assign PC_plus_4_ID = IF_ID_out;
	assign Instruction_ID = (INRS == 1'b1)? 32'b0 : INSTR;
	assign Read_register1_ID = Instruction_ID[21:17];
	assign Read_register2_ID = (RegDst_ID == 0)? Instruction_ID[16:12] : Instruction_ID[26:22];
	assign rc = Instruction_ID[16:12];
	assign ra = Instruction_ID[26:22];
	assign i_ID = Instruction_ID[5];
	assign shamt_ID = Instruction_ID[4:0];
	assign cond_ID = Instruction_ID[2:0];
	assign rd_ID = Instruction_ID[26:22];
	assign Branch_Jump_ID = Branch_ID | Branch_EX | Branch_MEM | Jump_ID | Jump_EX | Jump_MEM;
	
	Main_control Main_controlu(
					.opCode(Instruction_ID[31:27]),
					.RegWrite(RegWrite_ID),
					.MemtoReg(MemtoReg_ID),
					.Branch(Branch_ID),
					.Jump(Jump_ID),
					.LDRSTR(LDRSTR_ID),
					.MemWrite(MemWrite_ID),
					.MemRead(MemRead_ID),
					.ALUSrc(ALUSrc_ID),
					.ALUcontrol(ALUcontrol_ID),
					.RegDst(RegDst_ID)
	);
	REGFILE    #(.AW(5), .ENTRY(32))    RegFile (
                    .CLK    (CLK),
                    .RSTN    (RSTN),
                    .WEN    (~RegWrite_WB),
                    .WA     (rd_WB),
                    .DI     (Reg_Write_data_WB),
                    .RA0    (Read_register1_ID),
                    .RA1    (Read_register2_ID),
                    .DOUT0  (Read_data1_ID),
                    .DOUT1  (Read_data2_ID)
    );
	Sign_extension_17 Signext17(
					.IMM17(Instruction_ID[16:0]), 
					.Signext_IMM17(SignextIMM17_ID)
	);
	Sign_extension_22 Signext22(
					.IMM22(Instruction_ID[21:0]), 
					.Signext_IMM22(SignextIMM22_ID)
	);
	
	//ID_EX
	ID_EX ID_EXu(
					.CLK(CLK), 
					.RSTN(RSTN),
					.WB_control({RegWrite_ID, MemtoReg_ID}), 
					.MEM_control({Branch_ID, Jump_ID, LDRSTR_ID, MemWrite_ID, MemRead_ID}), 
					.EX_control({ALUSrc_ID, ALUcontrol_ID}),
					.PC_plus_4(PC_plus_4_ID),
					.SignextIMM22(SignextIMM22_ID),
					.rb(Read_register1_ID),
					.Read_data1(Read_data1_ID), 
					.Read_data2(Read_data2_ID), 
					.SignextIMM17(SignextIMM17_ID),
					.i(i_ID),
					.shamt(shamt_ID),
					.cond(cond_ID),
					.rd(rd_ID),
					.Stall(Stall_ID_EX), 
					.ID_EX_out(ID_EX_out)
	);
	
	//EX
	assign RegWrite_EX = ID_EX_out[191];
	assign MemtoReg_EX = ID_EX_out[190];
	assign Branch_EX = ID_EX_out[189];
	assign Jump_EX = ID_EX_out[188];
	assign LDRSTR_EX = ID_EX_out[187];
	assign MemWrite_EX = ID_EX_out[186];
	assign MemRead_EX = ID_EX_out[185];
	assign ALUSrc_EX = ID_EX_out[184];
	assign ALUcontrol_EX = ID_EX_out[183:179];
	assign PC_plus_4_EX = ID_EX_out[178:147];
	assign SignextIMM22_EX = ID_EX_out[146:115];
	assign rb_EX = ID_EX_out[114:110];
	assign Read_data1_EX = ID_EX_out[109:78];
	assign Read_data2_EX = ID_EX_out[77:46];
	assign SignextIMM17_EX = ID_EX_out[45:14];
	assign i_EX = ID_EX_out[13];
	assign shamt_EX = ID_EX_out[12:8];
	assign cond_EX = ID_EX_out[7:5];
	assign rd_EX = ID_EX_out[4:0];
	assign ALU_IN1_EX = Read_data1_EX;
	assign ALU_IN2_EX = (ALUSrc_EX == 1'b0)? Read_data2_EX : SignextIMM17_EX;
	
	ALU ALUu(
					.ALUcontrol(ALUcontrol_EX), 
					.IN1(ALU_IN1_EX), 
					.IN2(ALU_IN2_EX), 
					.i(i_EX), 
					.shamt(shamt_EX), 
					.cond(cond_EX), 
					.rb(rb_EX), 
					.ALUresult(ALUresult_EX), 
					.Brc(Brc_EX)
	);
	
	//EX_MEM
	EX_MEM EX_MEMu(
					.CLK(CLK), 
					.RSTN(RSTN), 
					.WB_control({RegWrite_EX, MemtoReg_EX}), 
					.MEM_control({Branch_EX, Jump_EX, LDRSTR_EX, MemWrite_EX, MemRead_EX}), 
					.PC_plus_4(PC_plus_4_EX), 
					.Read_data1(Read_data1_EX), 
					.PC_plus_4_plus_SignextIMM22(PC_plus_4_EX + SignextIMM22_EX), 
					.Brc(Brc_EX), 
					.ALUresult(ALUresult_EX), 
					.Read_data2(Read_data2_EX), 
					.rd(rd_EX), 
					.Stall(Stall_EX_MEM), 
					.EX_MEM_out(EX_MEM_out)
	);
	
	//MEM
	assign RegWrite_MEM = EX_MEM_out[172];
	assign MemtoReg_MEM = EX_MEM_out[171];
	assign Branch_MEM = EX_MEM_out[170];
	assign Jump_MEM = EX_MEM_out[169];
	assign LDRSTR_MEM = EX_MEM_out[168];
	assign MemWrite_MEM = EX_MEM_out[167];
	assign MemRead_MEM = EX_MEM_out[166];
	assign PC_plus_4_MEM = EX_MEM_out[165:134];
	assign Read_data1_MEM = EX_MEM_out[133:102];
	assign PC_plus_4_plus_SignextIMM22_MEM = EX_MEM_out[101:70];
	assign Brc_MEM = EX_MEM_out[69];
	assign ALUresult_MEM = EX_MEM_out[68:37];
	assign Read_data2_MEM = EX_MEM_out[36:5];
	assign rd_MEM = EX_MEM_out[4:0];
	assign Address_MEM = (LDRSTR_MEM == 1)? PC_plus_4_plus_SignextIMM22_MEM : ALUresult_MEM;	
	assign next_PC_MEM = (((~Branch_MEM) & Jump_MEM) == 0)? ((Branch_MEM == 0)? PC_plus_4_MEM : Read_data1_MEM) : PC_plus_4_plus_SignextIMM22_MEM;
	assign PC_plus_4_or_ALUresult_MEM = (Jump_MEM == 0)? ALUresult_MEM : PC_plus_4_MEM;
	
	//MEM_WB
	MEM_WB MEM_WBu(
					.CLK(CLK), 
					.RSTN(RSTN), 
					.WB_control({RegWrite_MEM, MemtoReg_MEM}), 
					.ALUresult_or_PC_plus_4(PC_plus_4_or_ALUresult_MEM), 
					.rd(rd_MEM), 
					.Stall(Stall_MEM_WB), 
					.MEM_WB_out(MEM_WB_out)
	);
	
	//WB	
	assign RegWrite_WB = MEM_WB_out[38];
	assign MemtoReg_WB = MEM_WB_out[37];
	assign PC_plus_4_or_ALUresult_WB = MEM_WB_out[36:5];
	assign rd_WB = MEM_WB_out[4:0];
	assign Mem_Read_data_WB = DRDATA;
	assign Reg_Write_data_WB = (MemtoReg_WB == 1)? Mem_Read_data_WB : PC_plus_4_or_ALUresult_WB;
	
	
	//-----------------------Stall control----------------------------
	wire Stall_PC;
	wire Stall_IF_ID;
	wire Stall_ID_EX;
	wire Stall_EX_MEM;
	wire Stall_MEM_WB;
	wire INRS;
	
	Stall_control Stall_controlu(
					.CLK(sub_clk), 
					.RSTN(RSTN), 
					.dr_ID_EX(rd_EX), 
					.dr_EX_MEM(rd_MEM), 
					.dr_MEM_WB(rd_WB), 
					.rr1(Read_register1_ID), 
					.rr2(Read_register2_ID), 
					.Branch(Branch_ID),
					.Jump(Jump_ID), 
					.Stall_PC(Stall_PC), 
					.Stall_IF_ID(Stall_IF_ID), 
					.Stall_ID_EX(Stall_ID_EX), 
					.Stall_EX_MEM(Stall_EX_MEM), 
					.Stall_MEM_WB(Stall_MEM_WB), 
					.INRS(INRS)
	);
	
	
	//-----------------------Output----------------------------
	assign IREQ = ~Stall_IF_ID; //Stall_IF_ID이 0일 때만 Instruction을 불러옴
	assign IADDR = current_PC_IF[29:0];
	assign DADDR = Address_MEM[29:0];
	assign DREQ = MemWrite_MEM | MemRead_MEM;;
	assign DRW = MemWrite_MEM;
	assign DWDATA = Read_data2_MEM;
	
	
endmodule