/******************************************************************
* Description
*	This is the verifaction envioroment ofr testeting the basic MIPS
*	procesor.
* Version:
*	1.0
* Author:
*  Alejandro Rios Jasso
*  Javier Ochoa Pardo
* email:
*  is708932@iteso.mx
*  is702811@iteso.mx
* Date:
*  05/04/2019
******************************************************************/

module MIPS_Processor_TB;
reg clk = 0;
reg reset = 0; 
reg [7:0] PortIn; 
wire [31:0] ALUResultOut;  
wire [31:0] PortOut;  
  
MIPS_Processor
DUV
(
    .clk(clk),
    .reset(reset),
    .ALUResultOut(ALUResultOut),
    .PortOut(PortOut)
);
/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk = !clk;
  end
/*********************************************************/
initial begin // reset generator
    #5 reset = 1;
end
/*********************************************************/
initial begin // reset generator
    #4 PortIn = 3;
end

/*********************************************************/

endmodule