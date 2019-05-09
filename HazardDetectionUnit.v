/******************************************************************
 * Description
 *  This is the hazard detection unit
 *  1.0
 * Author:
 *  Alejandro Rios Jasso
 *  Javier Ochoa Pardo
 * email:
 *  is708932@iteso.mx
 *  is702811@iteso.mx
 * Date:
 *  08/05/2019
 ******************************************************************/
module HazardDetectionUnit (input [4:0] Rs_ID,
                            input [4:0] Rt_ID,
                            input [4:0] Rt_EX,
                            input [1:0] MemToReg_EX,
                            output reg Stall_IF,
                            output reg Stall_ID,
                            output reg Flush_EX);

    always@(*)
    begin
        if(MemToReg_EX == 2'b01 && ((Rs_ID == Rt_EX) || (Rt_ID == Rt_EX))) begin
            {Stall_ID, Stall_IF, Flush_EX} <= 1;
        end
    end
    
endmodule
