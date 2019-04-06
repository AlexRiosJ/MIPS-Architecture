/******************************************************************
 * Description
 *  This module performes a sign-extend operation that is need with
 *  in instruction like andi or ben.
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
module SignExtend (input [15:0] DataInput,
                   output[31:0] SignExtendOutput);

assign  SignExtendOutput = {{16{DataInput[15]}},DataInput[15:0]};

endmodule // signExtend
