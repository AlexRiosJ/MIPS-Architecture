/******************************************************************
 * Description
 *  This is the Instruction Fetch Stage
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
module IF_Stage #(parameter MEMORY_DEPTH = 256)
                 (input clk,
                 input reset,
                 input pc_src_M,
                 input pc_branch_M,
                 output reg [31:0] instruction_bus,
                 output reg [31:0] pc_plus_4_IF);

    wire [31:0] pc_wire;
    wire [31:0] next_pc_wire;
    wire [31:0] instruction_bus_wire;
    wire [31:0] pc_plus_4_wire;

    PC_Register
    ProgramCounter
    (
    .clk(clk),
    .reset(reset),
    .NewPC(next_pc_wire),
    .PCValue(pc_wire)
    );

    ProgramMemory
    #(
    .MEMORY_DEPTH(MEMORY_DEPTH)
    )
    ROMProgramMemory
    (
    .Address(pc_wire),
    .Instruction(instruction_bus_wire)
    );

    Adder32bits
    PC_Adder
    (
    .Data0(pc_wire),
    .Data1(4),
    .Result(pc_plus_4_wire)
    );

    Multiplexer2to1
    PC_Src_MUX
    (
    .Selector(pc_src_M),
    .MUX_Data0(pc_plus_4_wire),
    .MUX_Data1(pc_branch_M),
    .MUX_Output(next_pc_wire)
    );

    assign instruction_bus = instruction_bus_wire;
    assign pc_plus_4_IF = pc_plus_4_wire;

endmodule
