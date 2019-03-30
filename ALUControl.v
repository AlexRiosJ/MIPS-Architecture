/******************************************************************
 * Description
 *	This is the control unit for the ALU. It receves an signal called
 *	ALUOp from the control unit and a signal called ALUFunction from
 *	the intrctuion field named function.
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
module ALUControl (input [2:0] ALUOp,
                   input [5:0] ALUFunction,
                   output [3:0] ALUOperation);

localparam R_Type_AND  = 9'b111_100100;
localparam R_Type_OR   = 9'b111_100101;
localparam R_Type_NOR  = 9'b111_100111;
localparam R_Type_ADD  = 9'b111_100000;
localparam R_Type_SUB  = 9'b111_100010;
localparam R_Type_SLL  = 9'b111_000000;
localparam R_Type_SRL  = 9'b111_000010;
localparam I_Type_ADDI = 9'b000_xxxxxx;
localparam I_Type_ORI  = 9'b001_xxxxxx;
localparam I_Type_LUI  = 9'b010_xxxxxx;
localparam I_Type_ANDI = 9'b011_xxxxxx;
localparam I_Type_BEQ  = 9'b100_xxxxxx;
localparam I_Type_LW   = 9'b101_xxxxxx;
localparam I_Type_SW   = 9'b110_xxxxxx;

reg [3:0] ALUControlValues;
wire [8:0] Selector;

assign Selector = {ALUOp, ALUFunction};

always@(Selector)begin									  // Operation
	 casex(Selector)
        R_Type_AND:	 ALUControlValues = 4'b0000; // AND
        R_Type_OR: 	 ALUControlValues = 4'b0001; // OR
        R_Type_NOR:	 ALUControlValues = 4'b0010; // NOR
        R_Type_ADD:	 ALUControlValues = 4'b0011; // ADD
        R_Type_SUB:	 ALUControlValues = 4'b0100; // SUB
        R_Type_SLL:	 ALUControlValues = 4'b0110; // SLL
        R_Type_SRL:	 ALUControlValues = 4'b0111; // SRL
        I_Type_ADDI:  ALUControlValues = 4'b0011; // ADD
        I_Type_ORI:   ALUControlValues = 4'b0001; // OR
        I_Type_LUI:	 ALUControlValues = 4'b0101; // LUI
        I_Type_ANDI:  ALUControlValues = 4'b0000; // AND
        I_Type_BEQ:	 ALUControlValues = 4'b0100; // SUB
        I_Type_LW:	 ALUControlValues = 4'b0011; // ADD
        I_Type_SW:	 ALUControlValues = 4'b0011; // ADD
        default:      ALUControlValues = 4'b1001;
    endcase
end

assign ALUOperation = ALUControlValues;

endmodule
