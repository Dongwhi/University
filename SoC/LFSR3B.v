module LFSR3B(/*AUTOARG*/
              // Outputs
              OUT,
              // Inputs
              CLK, RSTN, EN
              );
   input CLK;
   input RSTN;
   input EN;
   output reg [2:0] OUT;

   always@(posedge CLK, negedge RSTN) begin
      if(!RSTN) begin
         OUT <= 3'b100;
      end
      else begin
			OUT <= EN? {OUT[2]^OUT[0], OUT[2], OUT[1]} : OUT;
      end
   end
endmodule
