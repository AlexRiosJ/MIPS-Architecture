/******************************************************************
 * Description
 *  This is a  an 2to1 multiplexer that can be parameterized in its bit-width.
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

module Multiplexer2to1 #(parameter NBits = 32)
                        (input Selector,
                         input [NBits-1:0] MUX_Data0,
                         input [NBits-1:0] MUX_Data1,
                         output reg [NBits-1:0] MUX_Output);
    
    always@(Selector,MUX_Data1,MUX_Data0) begin
        if (Selector)
            MUX_Output = MUX_Data1;
        else
            MUX_Output = MUX_Data0;
    end
    
endmodule
