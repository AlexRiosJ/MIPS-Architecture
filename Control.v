/******************************************************************
 * Description
 *  This is control unit for the MIPS processor. The control unit is
 *  in charge of generation of the control signals. Its only input
 *  corresponds to opcode from the instruction.
 *  1.0
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
module Control (input [5:0] OP,
                input [5:0] Func, // JR Use only
                output [1:0] RegDst,
                output [1:0] Jump,
                output BranchEQ,
                output BranchNE,
                output MemRead,
                output [1:0] MemtoReg,
                output MemWrite,
                output ALUSrc,
                output RegWrite,
                output [3:0]ALUOp);

localparam R_Type      = 0;
localparam I_Type_ADDI = 6'h8;
localparam I_Type_ORI  = 6'hd;
localparam I_Type_LUI  = 6'hf;
localparam I_Type_ANDI = 6'hc;
localparam I_Type_BEQ  = 6'h4;
localparam I_Type_BNE  = 6'h5;
localparam I_Type_LW   = 6'h23;
localparam I_Type_SW   = 6'h2b;
localparam J_Type_J    = 6'h2;
localparam J_Type_JAL  = 6'h3;

reg [15:0] ControlValues;

always@(OP or Func) begin
    casex(OP)
        /* RegDest[1:0]_Jump[1:0]_ALUSrc_MemtoReg[1:0]_RegWrite_MemRead_MemWrite_BranchEQ_BranchNE_ALUOp[3:0] */
        R_Type:         ControlValues = (Func == 6'h8) ? 16'b01_10_0_00_1_0_0_0_0_0000 : 16'b01_00_0_00_1_0_0_0_0_0000; // JR or just R_Type
        I_Type_ADDI:    ControlValues = 16'b00_00_1_00_1_0_0_0_0_0001;
        I_Type_ORI:     ControlValues = 16'b00_00_1_00_1_0_0_0_0_0010;
        I_Type_LUI:     ControlValues = 16'b00_00_1_00_1_0_0_0_0_0011;
        I_Type_ANDI:    ControlValues = 16'b00_00_1_00_1_0_0_0_0_0100;
        I_Type_BEQ:     ControlValues = 16'bxx_00_0_xx_0_0_0_1_0_0101;
        I_Type_BNE:     ControlValues = 16'bxx_00_0_xx_0_0_0_0_1_0110;
        I_Type_LW:      ControlValues = 16'b00_00_1_01_1_1_0_0_0_0111;
        I_Type_SW:      ControlValues = 16'bxx_00_1_xx_0_0_1_0_0_1000;
        J_Type_J:       ControlValues = 16'bxx_01_x_xx_x_0_x_x_x_xxxx;
        J_Type_JAL:     ControlValues = 16'b10_01_x_10_1_0_0_x_x_xxxx;
        
        default:
        ControlValues = 10'b0000000000;
    endcase
end

assign RegDst   = ControlValues[15:14];
assign Jump     = ControlValues[13:12];
assign ALUSrc   = ControlValues[11];
assign MemtoReg = ControlValues[10:9];
assign RegWrite = ControlValues[8];
assign MemRead  = ControlValues[7];
assign MemWrite = ControlValues[6];
assign BranchEQ = ControlValues[5];
assign BranchNE = ControlValues[4];
assign ALUOp    = ControlValues[3:0];

endmodule


