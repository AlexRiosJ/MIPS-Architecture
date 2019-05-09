/******************************************************************
 * Description
 *  This is the Execute to Memory Register
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
module EX_ME_Register (input clk,
                       input reset,
                       input reg_write_in,
                       input [1:0] mem_to_reg_in,
                       input mem_write_in,
                       input mem_read_in,
                       input [31:0] alu_result_in,
                       input [31:0] write_data_in,
                       input [4:0] write_reg_in,
                       input [31:0] pc_branch_in,
                       output reg reg_write_out,
                       output reg [1:0] mem_to_reg_out,
                       output reg mem_write_out,
                       output reg mem_read_out,
                       output reg [31:0] alu_result_out,
                       output reg [31:0] write_data_out,
                       output reg [4:0] write_reg_out,
                       output reg [31:0] pc_branch_out);
    
    always@(negedge reset or posedge clk) begin
        if (reset == 0) begin
            reg_write_out  <= 0;
            mem_to_reg_out <= 0;
            mem_write_out  <= 0;
            mem_read_out   <= 0;
            alu_result_out <= 0;
            write_data_out <= 0;
            write_reg_out  <= 0;
            pc_branch_out  <= 0;
        end
        else begin
            reg_write_out  <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            mem_write_out  <= mem_write_in;
            mem_read_out   <= mem_read_in;
            alu_result_out <= alu_result_in;
            write_data_out <= write_data_in;
            write_reg_out  <= write_reg_in;
            pc_branch_out  <= pc_branch_in;
        end
    end
    
endmodule
