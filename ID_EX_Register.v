/******************************************************************
 * Description
 *  This is the Instruction Decode to Execute Register
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
module ID_EX_Register (input clk,
                       input reset,
                       input reg_write_in,
                       input [1:0] mem_to_reg_in,
                       input mem_write_in,
                       input mem_read_in,
                       input branch_ne_in,
                       input branch_eq_in,
                       input [3:0] aluop_in,
                       input alu_src_in,
                       input [1:0] reg_dst_in,
                       input [31:0] read_data_1_in,
                       input [31:0] read_data_2_in,
                       input [4:0] rt_in,
                       input [4:0] rd_in,
                       input [4:0] shamt_in,
                       input [31:0] immediate_extend_in,
                       input [31:0] pc_plus_4_in,
                       output reg reg_write_out,
                       output reg [1:0] mem_to_reg_out,
                       output reg mem_write_out,
                       output reg mem_read_out,
                       output reg branch_ne_out,
                       output reg branch_eq_out,
                       output reg [3:0] aluop_out,
                       output reg alu_src_out,
                       output reg [1:0] reg_dst_out,
                       output reg [31:0] read_data_1_out,
                       output reg [31:0] read_data_2_out,
                       output reg [4:0] rt_out,
                       output reg [4:0] rd_out,
                       output reg [4:0] shamt_out,
                       output reg [31:0] immediate_extend_out,
                       output reg [31:0] pc_plus_4_out);
    
    
    
    always@(negedge reset or posedge clk) begin
        if (reset == 0) begin
            reg_write_out        <= 0;
            mem_to_reg_out       <= 0;
            mem_write_out        <= 0;
            mem_read_out         <= 0;
            branch_ne_out        <= 0;
            branch_eq_out        <= 0;
            aluop_out            <= 0;
            alu_src_out          <= 0;
            reg_dst_out          <= 0;
            read_data_1_out      <= 0;
            read_data_2_out      <= 0;
            rt_out               <= 0;
            rd_out               <= 0;
            shamt_out            <= 0;
            immediate_extend_out <= 0;
            pc_plus_4_out        <= 0;
        end
        else begin
            reg_write_out        <= reg_write_in;
            mem_to_reg_out       <= mem_to_reg_in;
            mem_write_out        <= mem_write_in;
            mem_read_out         <= mem_read_in;
            branch_ne_out        <= branch_ne_in;
            branch_eq_out        <= branch_eq_in;
            aluop_out            <= aluop_in;
            alu_src_out          <= alu_src_in;
            reg_dst_out          <= reg_dst_in;
            read_data_1_out      <= read_data_1_in;
            read_data_2_out      <= read_data_2_in;
            rt_out               <= rt_in;
            rd_out               <= rd_in;
            shamt_out            <= shamt_in;
            immediate_extend_out <= immediate_extend_in;
            pc_plus_4_out        <= pc_plus_4_in;
        end
    end
    
endmodule
