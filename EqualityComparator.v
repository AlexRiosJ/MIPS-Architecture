/******************************************************************
 * Description
 *  This is the equality comparator for branch earlier
 *  1.0
 * Author:
 *  Alejandro Rios Jasso
 *  Javier Ochoa Pardo
 * email:
 *  is708932@iteso.mx
 *  is702811@iteso.mx
 * Date:
 *  08/04/2019
 ******************************************************************/
module EqualityComparator (input [31:0] ReadData1,
                           input [31:0] ReadData2,
                           output reg Zero);
    
    always@(*)
        Zero = (ReadData1 - ReadData2 == 0) ? 1'b1 : 1'b0;

endmodule
