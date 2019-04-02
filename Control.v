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

reg [11:0] ControlValues;

always@(OP) begin
    casex(OP)
		  /* RegDest_ALUSrc_MemtoReg-RegWrite_MemRead-MemWrite_Branch_ALUOp[] */
        R_Type:       	ControlValues = 12'b1_0_01_00_00_0000;
        I_Type_ADDI:  	ControlValues = 12'b0_1_01_00_00_0001;
        I_Type_ORI:   	ControlValues = 12'b0_1_01_00_00_0010;
        I_Type_LUI:		ControlValues = 12'b0_1_01_00_00_0011;
        I_Type_ANDI:		ControlValues = 12'b0_1_01_00_00_0100;
        I_Type_BEQ:		ControlValues = 12'bx_0_x0_00_10_0101;
		  I_Type_BNE:		ControlValues = 12'bx_0_x0_00_01_0110;
        I_Type_LW:		ControlValues = 12'b0_1_11_10_00_0111;
        I_Type_SW:		ControlValues = 12'bx_1_x0_01_00_1000;
        
        default:
        ControlValues = 10'b0000000000;
    endcase
end

assign RegDst   = ControlValues[11];
assign ALUSrc   = ControlValues[10];
assign MemtoReg = ControlValues[9];
assign RegWrite = ControlValues[8];
assign MemRead  = ControlValues[7];
assign MemWrite = ControlValues[6];
assign BranchEQ = ControlValues[5];
assign BranchNE = ControlValues[4];
assign ALUOp    = ControlValues[3:0];

endmodule


