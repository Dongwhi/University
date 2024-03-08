module Main_control( 
	input [31:27] opCode, 
	
	output RegWrite, 
	output MemtoReg, 
	output Branch, 
	output Jump, 
	output LDRSTR, 
	output MemWrite, 
	output MemRead, 
	output ALUSrc, 
	output [4:0]ALUcontrol, 
	output RegDst
);	
	wire A = opCode[31];
	wire B = opCode[30];
	wire C = opCode[29];
	wire D = opCode[28];
	wire E = opCode[27];
	
	assign RegWrite = (A|(~B)|(~C)|(~D)|(~E))&((~A)|B|C|D|(~E))&((~A)|B|(~C)|D|(~E))&((~A)|B|(~C)|(~D)|E);
	assign MemtoReg = (A&(~B)&(~C)&D&E)|(A&(~B)&C&(~D)&(~E));
	assign Branch = (A&(~B)&(~C)&D&E)|(A&(~B)&C&(~D)&(~E));
	assign Jump = (A&(~B)&(~C)&(~D)&(~E))|(A&(~B)&(~C)&(~D)&E)|(A&(~B)&(~C)&D&(~E));
	assign LDRSTR = (A&(~B)&C&(~D)&(~E))|(A&(~B)&C&D&(~E));
	assign MemWrite = (A&(~B)&C&(~D)&E)|(A&(~B)&C&D&(~E));
	assign MemRead = (A&(~B)&(~C)&D&E)|(A&(~B)&C&(~D)&(~E));
	assign ALUSrc = ((~A)&(~B)&(~C))|(A&(~B)&(~C)&D&E)|(A&(~B)&C&(~D)&E);
	assign ALUcontrol = opCode;
	assign RegDst = (A&(~B)&C&(~D)&E)|(A&(~B)&C&D&(~E));
	
endmodule