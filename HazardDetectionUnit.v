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
                            input [1:0] MemToReg_ME,
                            input BranchEQ_ID,
                            input BranchNE_ID,
                            input RegWrite_EX,
                            input RegWrite_ME,
                            input [4:0] WriteReg_EX,
                            input [4:0] WriteReg_ME,
                            output reg Stall_IF,
                            output reg Stall_ID,
                            output reg Flush_EX,
                            output reg ForwardA_ID,
                            output reg ForwardB_ID);

    wire lwstall;
    wire branchstall;
    
    always@(*)
    begin
        lwstall <= (MemToReg_EX == 2'b01 && ((Rs_ID == Rt_EX) || (Rt_ID == Rt_EX)));
        branchstall <= (((BranchNE_ID || BranchEQ_ID) && RegWrite_EX && (WriteReg_EX == Rs_ID || WriteReg_EX == Rt_ID)) || 
                        ((BranchNE_ID || BranchEQ_ID) && MemToReg_ME && (WriteReg_ME == Rs_ID || WriteReg_ME == Rt_ID)))

        Stall_IF <= Stall_ID <= Flush_EX <= (lwstall || branchstall);

        ForwardA_ID <= (Rs_ID != 0) && (Rs_ID == WriteReg_ME) && RegWrite_ME;
        ForwardB_ID <= (Rt_ID != 0) && (Rt_ID == WriteReg_ME) && RegWrite_ME;
    end
    
endmodule
