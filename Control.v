/******************************************************************
 * Description
 *	This is control unit for the MIPS processor. The control unit is
 *	in charge of generation of the control signals. Its only input
 *	corresponds to opcode from the instruction.
 *	1.0
 * Version:
 *	1.0
 * Author:
 *	Alejandro Rios Jasso
 *	Javier Ochoa Pardo
 * email:
 *	is708932@iteso.mx
 *	is702811@iteso.mx
 * Date:
 *	29/03/2019
 ******************************************************************/
module Control (input [5:0]OP,
                output RegDst,
					 output Jump,
                output BranchEQ,
                output BranchNE,
					 output MemRead,
                output MemtoReg,
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
localparam J_Type_J	  = 6'h2;

reg [12:0] ControlValues;

always@(OP) begin
    casex(OP)
		  /* RegDest_Jump_ALUSrc_MemtoReg_RegWrite_MemRead_MemWrite_BranchEQ_BranchNE_ALUOp[3:0] */
        R_Type:       	ControlValues = 13'b1_0_0_0_1_0_0_0_0_0000;
        I_Type_ADDI:  	ControlValues = 13'b0_0_1_0_1_0_0_0_0_0001;
        I_Type_ORI:   	ControlValues = 13'b0_0_1_0_1_0_0_0_0_0010;
        I_Type_LUI:		ControlValues = 13'b0_0_1_0_1_0_0_0_0_0011;
        I_Type_ANDI:		ControlValues = 13'b0_0_1_0_1_0_0_0_0_0100;
        I_Type_BEQ:		ControlValues = 13'bx_0_0_x_0_0_0_1_0_0101;
		  I_Type_BNE:		ControlValues = 13'bx_0_0_x_0_0_0_0_1_0110;
        I_Type_LW:		ControlValues = 13'b0_0_1_1_1_1_0_0_0_0111;
        I_Type_SW:		ControlValues = 13'bx_0_1_x_0_0_1_0_0_1000;
		  J_Type_J:			ControlValues = 13'bx_1_x_x_x_0_x_x_x_xxxx;
        
        default:
        ControlValues = 10'b0000000000;
    endcase
end

assign RegDst   = ControlValues[12];
assign Jump		 = ControlValues[11];
assign ALUSrc   = ControlValues[10];
assign MemtoReg = ControlValues[9];
assign RegWrite = ControlValues[8];
assign MemRead  = ControlValues[7];
assign MemWrite = ControlValues[6];
assign BranchEQ = ControlValues[5];
assign BranchNE = ControlValues[4];
assign ALUOp    = ControlValues[3:0];

endmodule


