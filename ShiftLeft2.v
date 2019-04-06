/******************************************************************
 * Description
 * This performs a shift left opeartion in roder to calculate the brances.
 * 1.0
 * Author:
 *  Alejandro Rios Jasso
 *  Javier Ochoa Pardo
 * email:
 *  is708932@iteso.mx
 *  is702811@iteso.mx
 * Date:
 *  05/04/2019
 ******************************************************************/
module ShiftLeft2 (input [31:0] DataInput,
                   output reg [31:0] DataOutput);
                   
always @ (DataInput)
    DataOutput = {DataInput[29:0], 1'b0, 1'b0};

endmodule // leftShift2
