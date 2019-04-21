/******************************************************************
 * Description
 *  This is the top-level of a MIPS processor that can execute the next set of instructions:
 *      add
 *      addi
 *      sub
 *      or
 *      ori
 *      and
 *      andi
 *      nor
 *      lw
 *      sw
 *      beq
 *      bne
 *      j
 *      jal
 *      jr
 * This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
 * Parameter MEMORY_DEPTH configures the program memory to allocate the program to
 * be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
 * This processor was made for computer architecture class at ITESO.
 * Version:
 *  1.5
 * Author:
 *  Alejandro Rios Jasso
 *  Javier Ochoa Pardo
 * email:
 *  is708932@iteso.mx
 *  is702811@iteso.mx
 * Date:
 *  05/04/2019
 ******************************************************************/


module MIPS_Processor #(parameter MEMORY_DEPTH = 256)
                       (input clk,
                        input reset,
                        input [7:0] PortIn,
                        output [31:0] ALUResultOut,
                        output [31:0] PortOut);
    //******************************************************************/
    //******************************************************************/
    assign  PortOut = 0;
    
    //******************************************************************/
    //******************************************************************/
    // signals to connect modules
    wire [1:0] jump_wire;
    wire branch_ne_wire; //
    wire branch_eq_wire; //
    wire [1:0] reg_dst_wire; //
    wire not_zero_and_branch_ne_wire; //
    wire zero_and_branch_eq_wire; //
    wire alu_src_wire; //
    wire reg_write_wire; //
    wire zero_wire; //
    wire pc_src_wire;
    wire mem_read_wire;
    wire mem_write_wire;
    wire [1:0] mem_to_reg_wire;
    wire [31:0] write_data_wire;
    wire [31:0] read_data_wire;
    wire [3:0] aluop_wire; //
    wire [3:0] alu_operation_wire; //
    wire [4:0] write_register_wire; //
    wire [31:0] pc_wire; //
    wire [31:0] instruction_bus_wire_IF; //
    wire [31:0] instruction_bus_wire_ID; //
    wire [31:0] read_data_1_wire; //
    wire [31:0] read_data_2_wire; //
    wire [31:0] immediate_extend_wire; //
    wire [31:0] read_data_2_or_immediate_wire; //
    wire [31:0] alu_result_wire; //
    wire [31:0] branch_adder_output_wire;
    wire [31:0] pc_plus_4_wire_IF; //
    wire [31:0] pc_plus_4_wire_ID; //
    wire [31:0] next_pc_wire_1;
    wire [31:0] next_pc_wire_2;
    wire [31:0] shift_left_2_1_wire;
    wire [27:0] jump_address_wire;
    
    // **** Pipeline Stages ****
    IF_Stage
    IF_Stage
    (
    #(
    .MEMORY_DEPTH(MEMORY_DEPTH)
    )
    // Inputs
    .clk(clk),
    .reset(reset),
    .pc_src_M(pc_src_wire_M),
    .pc_branch_M(pc_branch_wire_M),
    // Outputs
    .instruction_bus(instruction_bus_wire_IF),
    .pc_plus_4_IF(pc_plus_4_wire_IF)
    )

    // **** Pipeline Registers ****
    IF_ID_Register 
    IF_ID_Register
    (
    // Inputs
    .clk(clk),
    .reset(reset),
    .instruction_in(instruction_bus_wire_IF),
    .pc_in(pc_plus_4_wire_IF),

    // Outputs
    .instruction_out(instruction_bus_wire_ID),
    .pc_out(pc_plus_4_wire_ID)
    )

    // Multiplexer2to1
    // PC_Src_MUX
    // (
    // .Selector(pc_src_wire),
    // .MUX_Data0(pc_plus_4_wire),
    // .MUX_Data1(branch_adder_output_wire),
    // .MUX_Output(next_pc_wire_1)
    // );
    
    // Adder32bits
    // PC_Adder
    // (
    // .Data0(pc_wire),
    // .Data1(4),
    // .Result(pc_plus_4_wire)
    // );
    
    ShiftLeft2
    Shift_Left_2_1
    (
    .DataInput(immediate_extend_wire),
    .DataOutput(shift_left_2_1_wire)
    );
    
    ShiftLeft2
    Shift_Left_2_2
    (
    .DataInput(instruction_bus_wire[25:0]),
    .DataOutput(jump_address_wire)
    );
    
    Adder32bits
    Branch_Adder
    (
    .Data0(pc_plus_4_wire),
    .Data1(shift_left_2_1_wire),
    .Result(branch_adder_output_wire)
    );
    
    Multiplexer3to1
    PC_Src_MUX_2
    (
    .Selector(jump_wire),
    .MUX_Data0(next_pc_wire_1),
    .MUX_Data1({pc_plus_4_wire[31:28], jump_address_wire & 28'h000_03ff}), // 10 bit mask for ROM
    .MUX_Data2(read_data_1_wire),
    .MUX_Output(next_pc_wire_2)
    );
    
    // PC_Register
    // ProgramCounter
    // (
    // .clk(clk),
    // .reset(reset),
    // .NewPC(next_pc_wire_2),
    // .PCValue(pc_wire)
    // );
    
    // ProgramMemory
    // #(
    // .MEMORY_DEPTH(MEMORY_DEPTH)
    // )
    // ROMProgramMemory
    // (
    // .Address(pc_wire),
    // .Instruction(instruction_bus_wire)
    // );
    
    Control
    ControlUnit
    (
    .OP(instruction_bus_wire[31:26]),
    .Func(instruction_bus_wire[5:0]),
    .RegDst(reg_dst_wire),
    .Jump(jump_wire),
    .BranchEQ(branch_eq_wire),
    .BranchNE(branch_ne_wire),
    .MemRead(mem_read_wire),
    .MemtoReg(mem_to_reg_wire),
    .MemWrite(mem_write_wire),
    .ALUOp(aluop_wire),
    .ALUSrc(alu_src_wire),
    .RegWrite(reg_write_wire)
    );
    
    /************/
    SignExtend
    SignExtendForConstants
    (
    .DataInput(instruction_bus_wire[15:0]),
    .SignExtendOutput(immediate_extend_wire)
    );
    
    //******************************************************************/
    //******************************************************************/
    //******************************************************************/
    //******************************************************************/
    //******************************************************************/
    Multiplexer3to1
    #(
    .NBits(5)
    )
    Reg_Dst_MUX
    (
    .Selector(reg_dst_wire),
    .MUX_Data0(instruction_bus_wire[20:16]),
    .MUX_Data1(instruction_bus_wire[15:11]),
    .MUX_Data2(5'b11111),
    .MUX_Output(write_register_wire)
    );
    
    RegisterFile
    Register_File
    (
    .clk(clk),
    .reset(reset),
    .RegWrite(reg_write_wire),
    .WriteRegister(write_register_wire),
    .ReadRegister1(instruction_bus_wire[25:21]),
    .ReadRegister2(instruction_bus_wire[20:16]),
    .WriteData(write_data_wire),
    .ReadData1(read_data_1_wire),
    .ReadData2(read_data_2_wire)
    );
    
    Multiplexer2to1
    #(
    .NBits(32)
    )
    ALU_Src_MUX
    (
    .Selector(alu_src_wire),
    .MUX_Data0(read_data_2_wire),
    .MUX_Data1(immediate_extend_wire),
    .MUX_Output(read_data_2_or_immediate_wire)
    );
    
    ALUControl
    ArithmeticLogicUnitControl
    (
    .ALUOp(aluop_wire),
    .ALUFunction(instruction_bus_wire[5:0]), // Shamt
    .ALUOperation(alu_operation_wire)
    );
    
    ALU
    ArithmeticLogicUnit
    (
    .ALUOperation(alu_operation_wire),
    .A(read_data_1_wire),
    .B(read_data_2_or_immediate_wire),
    .Shamt(instruction_bus_wire[10:6]),
    .Zero(zero_wire),
    .ALUResult(alu_result_wire)
    );
    
    ANDGate
    BranchEQ_AND_Gate
    (
    .A(branch_eq_wire),
    .B(zero_wire),
    .C(zero_and_branch_eq_wire)
    );
    
    ANDGate
    BranchNE_AND_Gate
    (
    .A(branch_ne_wire),
    .B(~zero_wire),
    .C(not_zero_and_branch_ne_wire)
    );
    
    ORGate
    Branch_OR_Gate
    (
    .A(zero_and_branch_eq_wire),
    .B(not_zero_and_branch_ne_wire),
    .C(pc_src_wire)
    );
    
    DataMemory
    Data_Memory_RAM
    (
    .clk(clk),
    .WriteData(read_data_2_wire),
    .Address(alu_result_wire),
    .MemWrite(mem_write_wire),
    .MemRead(mem_read_wire),
    .ReadData(read_data_wire)
    );
    
    Multiplexer3to1
    Result_MUX
    (
    .Selector(mem_to_reg_wire),
    .MUX_Data0(alu_result_wire),
    .MUX_Data1(read_data_wire),
    .MUX_Data2(pc_plus_4_wire),
    .MUX_Output(write_data_wire)
    );
    
    assign ALUResultOut = alu_result_wire;
    
endmodule
    
