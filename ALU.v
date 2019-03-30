/******************************************************************
 * Description
 *	This is an 32-bit arithetic logic unit that can execute the next set of operations:
 *		add
 *		sub
 *		or
 *		and
 *		nor
 *		lui
 *		sll
 *		srl
 * This ALU is written by using behavioral description.
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

module ALU (input [3:0] ALUOperation,
            input [31:0] A,
            input [31:0] B,
				input [4:0] Shamt,
            output reg Zero,
            output reg [31:0] ALUResult);

localparam AND = 4'b0000;
localparam OR  = 4'b0001;
localparam NOR = 4'b0010;
localparam ADD = 4'b0011;
localparam SUB = 4'b0100;
localparam LUI = 4'b0101;
localparam SLL = 4'b0110;
localparam SRL = 4'b0111;

always @ (A or B or ALUOperation)
begin
    case (ALUOperation)
        ADD:	ALUResult = A + B;
        SUB:	ALUResult = A - B;
        AND:	ALUResult = A & B;
        OR: 	ALUResult = A | B;
        NOR:	ALUResult = ~(A | B);
        LUI:	ALUResult = {B, 16'b0};
        SLL:	ALUResult = A << Shamt;
        SRL:	ALUResult = A >> Shamt;
        default:
        ALUResult = 0;
    endcase // case(control)
    Zero = (ALUResult == 0) ? 1'b1 : 1'b0;
end // always @ (A or B or control)

endmodule // ALU
