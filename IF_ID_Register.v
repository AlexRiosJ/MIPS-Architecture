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
                       input enable,
                       input [31:0] instruction_in,
                       input [31:0] pc_plus_4_in,
                       output reg [31:0] instruction_out,
                       output reg [31:0] pc_plus_4_out);
    
    always@(negedge reset or posedge clk) begin
        if (reset == 0) begin
            pc_plus_4_out   <= 0;
            instruction_out <= 0;
        end
        else if(enable == 1) begin
            pc_plus_4_out   <= pc_plus_4_in;
            instruction_out <= instruction_in;
        end
    end
    
endmodule
