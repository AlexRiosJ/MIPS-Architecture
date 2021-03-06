/******************************************************************
 * Description
 *  This is  a ROM memory that represents the program memory.
 *  Internally, the memory is read without a signal clock. The initial
 *  values (program) of this memory are written from a file named text.dat.
 * Version:
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
module ProgramMemory #(parameter MEMORY_DEPTH = 32,
                       parameter DATA_WIDTH = 32)
                      (input [(DATA_WIDTH-1):0] Address, output reg [(DATA_WIDTH-1):0] Instruction);
    wire [(DATA_WIDTH-1):0] RealAddress;
    
    assign RealAddress = {2'b0,Address[(DATA_WIDTH-1):2]};
    
    // Declare the ROM variable
    reg [DATA_WIDTH-1:0] rom[MEMORY_DEPTH-1:0];
    
    initial
    begin
        $readmemh("./sources/text_matrix.dat", rom); // Cambiar
    end
    
    always @ (RealAddress)
    begin
        Instruction = rom[RealAddress];
    end
    
endmodule
