module Stall_control(
	input CLK,
	input RSTN, 
	input [4:0] dr_ID_EX, 
	input [4:0] dr_EX_MEM, 
	input [4:0] dr_MEM_WB, 
	input [4:0] rr1, 
	input [4:0] rr2, 
	input Branch, 
	input Jump, 
	output Stall_PC, 
	output Stall_IF_ID, 
	output Stall_ID_EX, 
	output Stall_EX_MEM, 
	output Stall_MEM_WB, 
	output INRS
);
	
	reg [2:0] Stall_Count;
	reg Stall_PC_en;
	reg Stall_IF_ID_en;
	reg Stall_ID_EX_en;
	reg Stall_EX_MEM_en;
	reg Stall_MEM_WB_en;
	reg INRS_en;
	reg [1:0] reset_count;
	reg C_hazard;
	reg [1:0] start_count;
	parameter stall_0 = 4'b0000, 
		stall_1 = 4'b0001, 
		stall_2 = 4'b0010, 
		stall_3 = 4'b0100,
		stall_4 = 4'b1000;
	parameter reset_0 = 2'b00, 
		reset_1 = 2'b01, 
		reset_2 = 2'b10;
	parameter start_0 = 2'b00, 
		start_1 = 2'b01, 
		start_2 = 2'b10;
	always @(negedge CLK)begin
		if (RSTN == 1'b0) begin
			reset_count <= reset_2;
			Stall_PC_en <= 1'b0;
			Stall_IF_ID_en <= 1'b0;
			Stall_ID_EX_en <= 1'b1;
			Stall_EX_MEM_en <= 1'b1;
			Stall_MEM_WB_en <= 1'b1;
			INRS_en <= 1'b1;
			start_count <= start_0;
		end else begin
			case(reset_count)
				reset_2: begin
					Stall_Count <= stall_0;
					reset_count <= reset_1;
					Stall_PC_en <= 1'b0;
					Stall_IF_ID_en <= 1'b0;
					Stall_ID_EX_en <= 1'b1;
					Stall_EX_MEM_en <= 1'b1;
					Stall_MEM_WB_en <= 1'b1;
				end
				reset_1: begin
					INRS_en <= 1'b0;
					case (Stall_Count)
						stall_0: begin
							if (Branch == 1'b1 | Jump == 1'b1)begin
								Stall_Count <= stall_4;
								Stall_PC_en <= 1'b1;
								Stall_IF_ID_en <= 1'b1;
								Stall_ID_EX_en <= 1'b0;
								Stall_EX_MEM_en <= 1'b0;
								Stall_MEM_WB_en <= 1'b0;
							end else begin
								Stall_PC_en <= 1'b0;
								Stall_IF_ID_en <= 1'b0;
								Stall_ID_EX_en <= 1'b0;
								Stall_EX_MEM_en <= 1'b0;
								Stall_MEM_WB_en <= 1'b0;
								reset_count <= reset_0;
								C_hazard <= 1'b0;
								start_count <= start_2;
							end
						end
						stall_1: begin
							if (Branch == 1'b1 | Jump == 1'b1)begin
								Stall_Count <= stall_4;
								Stall_PC_en <= 1'b1;
								Stall_IF_ID_en <= 1'b1;
								Stall_ID_EX_en <= 1'b0;
								Stall_EX_MEM_en <= 1'b0;
								Stall_MEM_WB_en <= 1'b0;
							end else begin
								Stall_Count <= stall_0;
								Stall_PC_en <= 1'b0;
								Stall_IF_ID_en <= 1'b0;
								Stall_ID_EX_en <= 1'b0;
								Stall_EX_MEM_en <= 1'b0;
								Stall_MEM_WB_en <= 1'b0;
								reset_count <= reset_0;
								C_hazard <= 1'b0;
								start_count <= start_2;
							end
						end
						stall_2: begin
							Stall_Count <= stall_1;
							Stall_PC_en <= 1'b0;
							Stall_IF_ID_en <= 1'b0;
							Stall_ID_EX_en <= 1'b1;
							Stall_EX_MEM_en <= 1'b1;
							Stall_MEM_WB_en <= 1'b1;
						end
						stall_3: begin
							Stall_Count <= stall_2;
							Stall_PC_en <= 1'b0;
							Stall_IF_ID_en <= 1'b1;
							Stall_ID_EX_en <= 1'b1;
							Stall_EX_MEM_en <= 1'b1;
							Stall_MEM_WB_en <= 1'b0;
						end
						stall_4: begin
							Stall_Count <= stall_3;
							Stall_PC_en <= 1'b1;
							Stall_IF_ID_en <= 1'b1;
							Stall_ID_EX_en <= 1'b1;
							Stall_EX_MEM_en <= 1'b0;
							Stall_MEM_WB_en <= 1'b0;
						end
					endcase
				end
				reset_0: begin
					case(Stall_Count)
						stall_0: begin
							case(start_count)
								start_2: begin
									if (Branch == 1'b1 | Jump == 1'b1) begin
										Stall_Count <= stall_4;
										C_hazard <= 1'b1;
									end else if (rr1 == dr_ID_EX | rr2 == dr_ID_EX) begin
										Stall_Count <= stall_3;
										Stall_PC_en <= 1'b1;
										Stall_IF_ID_en <= 1'b1;
										Stall_ID_EX_en <= 1'b1;
										Stall_EX_MEM_en <= 1'b0;
										Stall_MEM_WB_en <= 1'b0;
									end else begin
										Stall_Count <= stall_0;
										start_count <= start_1;
									end
								end
								start_1: begin
									if (Branch == 1'b1 | Jump == 1'b1) begin
										Stall_Count <= stall_4;
										C_hazard <= 1'b1;
									end else if (rr1 == dr_ID_EX | rr2 == dr_ID_EX) begin
										Stall_Count <= stall_3;
										Stall_PC_en <= 1'b1;
										Stall_IF_ID_en <= 1'b1;
										Stall_ID_EX_en <= 1'b1;
										Stall_EX_MEM_en <= 1'b0;
										Stall_MEM_WB_en <= 1'b0;
									end else if (rr1 == dr_EX_MEM | rr2 == dr_EX_MEM) begin
										Stall_Count <= stall_2;
										Stall_PC_en <= 1'b1;
										Stall_IF_ID_en <= 1'b1;
										Stall_ID_EX_en <= 1'b1;
										Stall_EX_MEM_en <= 1'b1;
										Stall_MEM_WB_en <= 1'b0;
									end else begin
										Stall_Count <= stall_0;
										start_count <= start_0;
									end
								end
								start_0: begin
									if (Branch == 1'b1 | Jump == 1'b1) begin
										Stall_Count <= stall_4;
										C_hazard <= 1'b1;
									end else if (rr1 == dr_ID_EX | rr2 == dr_ID_EX) begin
										Stall_Count <= stall_3;
										Stall_PC_en <= 1'b1;
										Stall_IF_ID_en <= 1'b1;
										Stall_ID_EX_en <= 1'b1;
										Stall_EX_MEM_en <= 1'b0;
										Stall_MEM_WB_en <= 1'b0;
									end else if (rr1 == dr_EX_MEM | rr2 == dr_EX_MEM) begin
										Stall_Count <= stall_2;
										Stall_PC_en <= 1'b1;
										Stall_IF_ID_en <= 1'b1;
										Stall_ID_EX_en <= 1'b1;
										Stall_EX_MEM_en <= 1'b1;
										Stall_MEM_WB_en <= 1'b0;
									end else if (rr1 == dr_MEM_WB | rr2 == dr_MEM_WB) begin
										Stall_Count <= stall_1;
										Stall_PC_en <= 1'b1;
										Stall_IF_ID_en <= 1'b1;
										Stall_ID_EX_en <= 1'b1;
										Stall_EX_MEM_en <= 1'b1;
										Stall_MEM_WB_en <= 1'b1;
									end else begin
										Stall_Count <= stall_0;
										start_count <= start_0;
									end
								end
							endcase
						end
						stall_4: begin
							Stall_Count <= stall_3;
							Stall_PC_en <= 1'b1;
							Stall_IF_ID_en <= 1'b1;
							Stall_ID_EX_en <= 1'b1;
							Stall_EX_MEM_en <= 1'b0;
							Stall_MEM_WB_en <= 1'b0;
						end
						stall_3: begin
							case(C_hazard)
								1'b1: begin
									Stall_Count <= stall_2;
									Stall_PC_en <= 1'b0;
									Stall_IF_ID_en <= 1'b1;
									Stall_ID_EX_en <= 1'b1;
									Stall_EX_MEM_en <= 1'b1;
									Stall_MEM_WB_en <= 1'b0;
								end
								1'b0: begin
									Stall_Count <= stall_2;
									Stall_PC_en <= 1'b1;
									Stall_IF_ID_en <= 1'b1;
									Stall_ID_EX_en <= 1'b1;
									Stall_EX_MEM_en <= 1'b1;
									Stall_MEM_WB_en <= 1'b0;
								end
							endcase
						end
						stall_2: begin
							case(C_hazard)
								1'b1: begin
									Stall_Count <= stall_1;
									Stall_PC_en <= 1'b0;
									Stall_IF_ID_en <= 1'b0;
									Stall_ID_EX_en <= 1'b1;
									Stall_EX_MEM_en <= 1'b1;
									Stall_MEM_WB_en <= 1'b1;
								end
								1'b0: begin
									Stall_Count <= stall_1;
									Stall_PC_en <= 1'b1;
									Stall_IF_ID_en <= 1'b1;
									Stall_ID_EX_en <= 1'b1;
									Stall_EX_MEM_en <= 1'b1;
									Stall_MEM_WB_en <= 1'b1;
								end
							endcase
						end
						stall_1: begin
							case(C_hazard)
								1'b1: begin
									Stall_Count <= stall_0;
									Stall_PC_en <= 1'b0;
									Stall_IF_ID_en <= 1'b0;
									Stall_ID_EX_en <= 1'b0;
									Stall_EX_MEM_en <= 1'b0;
									Stall_MEM_WB_en <= 1'b0;
									C_hazard <= 1'b0;
								end
								1'b0: begin
									Stall_Count <= stall_0;
									Stall_PC_en <= 1'b0;
									Stall_IF_ID_en <= 1'b0;
									Stall_ID_EX_en <= 1'b0;
									Stall_EX_MEM_en <= 1'b0;
									Stall_MEM_WB_en <= 1'b0;
								end
							endcase
						end
					endcase
				end
			endcase
		end
	end
		
	assign Stall_PC = Stall_PC_en;
	assign Stall_IF_ID = Stall_IF_ID_en;
	assign Stall_ID_EX = Stall_ID_EX_en;
	assign Stall_EX_MEM = Stall_EX_MEM_en;
	assign Stall_MEM_WB = Stall_MEM_WB_en;
	assign INRS = INRS_en;
	
	
endmodule