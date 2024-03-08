/*****************************************
    testbench.v

    Project 2
    
    Team XX : 
        2023000000    Kim Mina
        2023000001    Lee Minho
*****************************************/

module testbench;

    reg             CLK, RSTN;

    /// CLOCK Generator ///
    parameter   PERIOD = 10.0;
    parameter   HPERIOD = PERIOD/2.0;

    initial CLK <= 1'b0;
    always #(HPERIOD) CLK <= ~CLK;


    wire              IREQ;
    wire    [29:0]    IADDR;
    wire    [31:0]    INSTR;
    wire              DREQ;
    wire              DRW;
    wire    [29:0]    DADDR;
    wire    [31:0]    DWDATA;
    wire    [31:0]    DRDATA;

	RISC_TOY	RISC_TOY	(
		.CLK		(CLK),
		.RSTN		(RSTN),
		.IREQ		(IREQ),
		.IADDR		(IADDR),
		.INSTR		(INSTR),
		.DREQ		(DREQ),
		.DRW		(DRW),
		.DADDR		(DADDR),
		.DWDATA		(DWDATA),
		.DRDATA		(DRDATA)
	);

	SRAM	INST_MEM	(
		.CLK		(CLK),
		.CSN		(~IREQ),
		.A			(IADDR[11:2]),
		.WEN		(1'b1),
		.DI			(),
		.DOUT		(INSTR)
	);

	SRAM	DATA_MEM	(
		.CLK		(CLK),
		.CSN		(~DREQ),
		.A			(DADDR[11:2]),
		.WEN		(~DRW),
		.DI			(DWDATA),
		.DOUT		(DRDATA)
	);

	

	// --------------------------------------------
	// Load test vector to inst and data memory
	// --------------------------------------------
	// Caution : Assumption : input file has hex data like below. 
	//			 input file : M[0x03]M[0x02]M[0x01]M[0x00]
	//                        M[0x07]M[0x06]M[0x05]M[0x04]
	//									... 
	
	
	defparam testbench.INST_MEM.MEM_FILE = "inst.hex";
	defparam testbench.INST_MEM.WRITE = 1;

	initial begin
		RSTN <= 1'b0;
		#(10*PERIOD)
		RSTN <= 1'b1;
		/*
		18400011 //MOVI $1, 17      : 00011_00001_00000_00000000000010001
		18800005 //MOVI $2, 5       : 00011_00010_00000_00000000000000101
		20c22000 //ADD $3, &1, &2   : 00100_00001_00010_00010_000000000000 !!Data hazard($2) here!!
		0102009b //ADDI $4, $1, 155 : 00000_00100_00001_00000000010011011
		*/
		#(2000*PERIOD);
		$finish();
	end

	/// Waveform Dump ///
	initial begin
		$display("Dump variables..");
		$dumpfile("./DUMP_FILE");
		$dumpvars;
	end

endmodule

