/******************************************************************
 * Description
 *  This is the Instruction Fetch to Instruction Decode Register
 *  1.0
 * Author:
 *  Alejandro Rios Jasso
 *  Javier Ochoa Pardo
 * email:
 *  is708932@iteso.mx
 *  is702811@iteso.mx
 * Date:
 *  21/04/2019
 ******************************************************************/
module IF_ID_Register (input clk,
                       input reset,
                       input instruction_in,
                       input pc_in,
                       output reg [31:0] instruction_out,
                       output reg [31:0] pc_out);
    
    always@(negedge reset or posedge clk) begin
        if (reset == 0) begin
            pc_out          <= 0;
            instruction_out <= 0;
        end
        else begin
            pc_out          <= pc_in;
            instruction_out <= instruction_in;
        end
    end
    
endmodule
