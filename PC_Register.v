/******************************************************************
 * Description
 *  This is a register of 32-bit that corresponds to the PC counter.
 *  This register does not have an enable signal.
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

module PC_Register #(parameter N = 32)
                    (input clk,
                     input reset,
                     input enable,
                     input [N-1:0] NewPC,
                     output reg [N-1:0] PCValue);
    
    always@(negedge reset or posedge clk) begin
        if (reset == 0)
            PCValue <= 0;
        else if(enable == 1)
            PCValue <= NewPC;
    end
    
endmodule
