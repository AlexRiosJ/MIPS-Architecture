/******************************************************************
 * Description
 *      This is an OR gate:
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
module ORGate (input A,
                input B,
                output reg C);
    
    always@(*)
        C = A | B;
    
endmodule