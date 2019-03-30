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
                //output BranchEQ,
                //output BranchNE,
					 output Branch,
                output MemRead,
                output MemtoReg,
                output MemWrite,
                output ALUSrc,
                output RegWrite,
                output [2:0]ALUOp);

localparam R_Type      = 0;
localparam I_Type_ADDI = 6'h8;
localparam I_Type_ORI  = 6'hd;
localparam I_Type_LUI  = 6'hf;
localparam I_Type_ANDI = 6'hc;
localparam I_Type_BEQ  = 6'h4;
localparam I_Type_LW   = 6'h23;
localparam I_Type_SW   = 6'h2b;

reg [10:0] ControlValues;

always@(OP) begin
    casex(OP)
		  /* RegDest_ALUSrc_MemtoReg-RegWrite_MemRead-MemWrite_Branch_ALUOp[] */
        R_Type:       	ControlValues = 10'b1_0_01_00_0_111;
        I_Type_ADDI:  	ControlValues = 10'b0_1_01_00_0_000;
        I_Type_ORI:   	ControlValues = 10'b0_1_01_00_0_001;
        I_Type_LUI:		ControlValues = 10'b0_1_01_00_0_010;
        I_Type_ANDI:		ControlValues = 10'b0_1_01_00_0_011;
        I_Type_BEQ:		ControlValues = 10'bx_0_x0_00_1_100;
        I_Type_LW:		ControlValues = 10'b0_1_11_00_0_101;
        I_Type_SW:		ControlValues = 10'bx_1_x0_01_0_110;
        
        default:
        ControlValues = 10'b0000000000;
    endcase
end

assign RegDst   = ControlValues[9];
assign ALUSrc   = ControlValues[8];
assign MemtoReg = ControlValues[7];
assign RegWrite = ControlValues[6];
assign MemRead  = ControlValues[5];
assign MemWrite = ControlValues[4];
assign Branch   = ControlValues[3];
assign ALUOp    = ControlValues[2:0];

endmodule


