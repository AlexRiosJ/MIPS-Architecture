/******************************************************************
 * Description
 *  This is the Instruction Decode Stage
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
module ID_Stage (input clk,
                 input reset,
                 input instruction_bus,
                 input pc_plus_4_in,
                 input write_data_W,
                 input reg_write_W,
                 output reg [31:0] read_data_1,
                 output reg [31:0] read_data_2,
                 output reg [4:0] instruction_bus_20_16,
                 output reg [4:0] instruction_bus_15_11,
                 output reg [31:0] sign_extend,
                 output reg [31:0] pc_plus_4_out,
                 output reg reg_wirte_ID,
                 output reg mem_to_reg_ID,
                 output reg mem_write_ID,
                 output reg branch_eq_ID,
                 output reg branch_ne_ID,
                 



    
    
endmodule
