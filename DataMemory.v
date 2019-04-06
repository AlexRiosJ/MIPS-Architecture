/******************************************************************
 * Description
 *  This is the data memory for the MIPS processor
 *  1.0
 * Author:
 *  Alejandro Rios Jasso
 *  Javier Ochoa Pardo
 * email:
 *  is708932@iteso.mx
 *  is702811@iteso.mx
 * Date:
 *  05/04/2019
 ******************************************************************/

module DataMemory #(parameter DATA_WIDTH = 32,
                    parameter MEMORY_DEPTH = 1024)
                   (input [DATA_WIDTH-1:0] WriteData,
                    input [DATA_WIDTH-1:0] Address,
                    input MemWrite,
                    MemRead,
                    clk,
                    output [DATA_WIDTH-1:0] ReadData);
    
    // Declare the RAM variable
    reg [DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];
    wire [DATA_WIDTH-1:0] ReadDataAux;
    
    always @ (posedge clk)
    begin
        // Write
        if (MemWrite)
            ram[Address & 32'h0000_03ff] <= WriteData;
    end
    assign ReadDataAux = ram[Address & 32'h0000_03ff];
    assign ReadData    = {DATA_WIDTH{MemRead}} & ReadDataAux;
        
endmodule
