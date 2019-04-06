/******************************************************************
 * Description
 *  This is a an adder that can be parameterized in its bit-width.
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

module Adder32bits #(parameter NBits = 32)
                    (input [NBits-1:0] Data0,
                     input [NBits-1:0] Data1,
                     output [NBits-1:0] Result);
    
    assign Result = Data1 + Data0;
    
endmodule
