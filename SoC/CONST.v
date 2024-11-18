module TB_LFSR3B;
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg                     CLK;                    // To DUT of LFSR3B.v
   reg                     EN;                     // To DUT of LFSR3B.v
   reg                     RSTN;                   // To DUT of LFSR3B.v
   // End of automatics
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [2:0]              OUT;                    // From DUT of LFSR3B.v
   reg [2:0]               OUT_EXP;                    // From DUT of LFSR3B.v
   // End of automatics
   LFSR3B
     DUT
       (/*AUTOINST*/
        // Outputs
        .OUT                                   (OUT[2:0]),
        // Inputs
        .CLK                                   (CLK),
        .RSTN                                  (RSTN),
        .EN                                    (EN));
   //for input dumpiing & output result
   integer                 i;
   integer                 input_file;
   integer                 result_file;
   integer                 scan_result;

   initial begin
	    input_file = $fopen("./out.txt","r");
	    result_file = $fopen(`MYLOG,"w");
	    if (input_file ==0 || result_file ==0) begin
		     $display("Error:unable to open file");
		     $finish;
	    end
		$fwrite(result_file,"TCK: %.2fns\n", `TCK);
	    CLK = 0;
	    RSTN = 0;
	    EN = 0;
	    #(10*`TCK);
	    RSTN =1;
	    while (!$feof(input_file))begin
		     scan_result = $fscanf(input_file, "%b\n",OUT_EXP);
		     if(scan_result !=1) begin
		        $display("error reading from file!");
		        $finish;
		     end
		     @(posedge CLK) begin
		        EN =1;
		        if(OUT == OUT_EXP) $fwrite(result_file,"at time %.2fns, PASS:Expected=%b,Actual=%b\n",$time,OUT_EXP,OUT);
		        else $fwrite(result_file,"at time %.2fns, FAIL:Expected=%b,Actual=%b\n",$time,OUT_EXP,OUT);
	       end
      end
	    $fclose(input_file);
	    $fclose(result_file);
	    $finish;
   end
   always begin
	    #(0.5*`TCK) CLK = ~CLK;
   end
endmodule
