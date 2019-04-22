/******************************************************************
 * Description
 *  This is the Memory to Write Back Register
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
module ME_WB_Register (input clk,
                       input reset,
                       input reg_write_in,
                       input [1:0] mem_to_reg_in,
                       input [31:0] alu_result_in,
                       input [31:0] read_data_in,
                       input [4:0] write_reg_in,
                       output reg reg_write_out,
                       output reg [1:0] mem_to_reg_out,
                       output reg [31:0] alu_result_out,
                       output reg [31:0] read_data_out,
                       output reg [4:0] write_reg_out);
    
    always@(negedge reset or posedge clk) begin
        if (reset == 0) begin
            reg_write_out  <= 0;
            mem_to_reg_out <= 0;
            alu_result_out <= 0;
            read_data_out  <= 0;
            write_reg_out  <= 0;
        end
        else begin
            reg_write_out  <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            alu_result_out <= alu_result_in;
            read_data_out  <= read_data_in;
            write_reg_out  <= write_reg_in;
        end
    end
    
endmodule
