/******************************************************************
 * Description
 *  This is the forwarding unit
 *  1.0
 * Author:
 *  Alejandro Rios Jasso
 *  Javier Ochoa Pardo
 * email:
 *  is708932@iteso.mx
 *  is702811@iteso.mx
 * Date:
 *  05/05/2019
 ******************************************************************/
module ForwardingUnit (input EX_ME_reg_write,
                       input ME_WB_reg_write,
                       input [4:0] ID_EX_rs,
                       input [4:0] ID_EX_rt,
                       input [4:0] EX_ME_write_register,
                       input [4:0] ME_WB_write_register,
                       output reg [1:0] ForwardA,
                       output reg [1:0] ForwardB);
    
    always @(*)
    begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        if(EX_ME_reg_write
        && (EX_ME_write_register != 0)
        && (EX_ME_write_register == ID_EX_rs))
        begin
            ForwardA = 2'b10;
        end
        if(EX_ME_reg_write
        && (EX_ME_write_register != 0)
        && (EX_ME_write_register == ID_EX_rt))
        begin
            ForwardB = 2'b10;
        end

        if(ME_WB_reg_write
        && (ME_WB_write_register != 0)
        && !(EX_ME_reg_write && (EX_ME_write_register != 0)
            && (EX_ME_write_register != ID_EX_rs))
        && (ME_WB_write_register == ID_EX_rs))
        begin
            ForwardA = 2'b01;
        end
        if(ME_WB_reg_write
        && (ME_WB_write_register != 0)
        && !(EX_ME_reg_write && (EX_ME_write_register != 0)
            && (EX_ME_write_register != ID_EX_rt))
        && (ME_WB_write_register == ID_EX_rt))
        begin
            ForwardB = 2'b01;
        end
    end

endmodule
