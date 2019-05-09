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

module MIPS_Processor #(parameter MEMORY_DEPTH = 256,
                        parameter PC_INCREMENT = 4)
                       (input clk,
                        input reset,
                        input [7:0] PortIn,
                        output [31:0] PortOut);
    assign PortOut = 0;
    
    // Instruction Fetch stage Wires
    wire [31:0] next_pc_wire;
    wire [31:0] pc_wire;
    wire [31:0] pc_plus_4_wire_IF;
    wire [31:0] instruction_bus_wire_IF;

    // Instruction Decode stage Wires
    wire [31:0] instruction_bus_wire_ID;
    wire [31:0] pc_plus_4_wire_ID;
    wire reg_write_wire_ID;
    wire [1:0] mem_to_reg_wire_ID;
    wire mem_write_wire_ID;
    wire mem_read_wire_ID;
    wire branch_ne_wire_ID;
    wire branch_eq_wire_ID;
    wire [3:0] aluop_wire_ID;
    wire alu_src_wire_ID;
    wire [1:0] reg_dst_wire_ID;
    wire [31:0] read_data_1_wire_ID;
    wire [31:0] read_data_2_wire_ID;
    wire [31:0] immediate_extend_wire_ID;
    wire zero_wire;
    wire pc_src_wire_ID;
    wire forwardA_ID_wire;
    wire forwardB_ID_wire;
    wire [31:0] forwardA_ID_mux_out_wire;
    wire [31:0] forwardB_ID_mux_out_wire;

    // Execute stage wires
    wire [31:0] pc_plus_4_wire_EX;
    wire reg_write_wire_EX;
    wire [1:0] mem_to_reg_wire_EX;
    wire mem_write_wire_EX;
    wire mem_read_wire_EX;
    wire branch_ne_wire_EX;
    wire branch_eq_wire_EX;
    wire [3:0] aluop_wire_EX;
    wire alu_src_wire_EX;
    wire [1:0] reg_dst_wire_EX;
    wire [31:0] read_data_1_wire_EX;
    wire [31:0] read_data_2_wire_EX;
    wire [31:0] immediate_extend_wire_EX;
    wire [31:0] src_B_wire_EX;
    wire [4:0] shamt_wire_EX;
    wire [31:0] alu_result_wire_EX;
    wire [4:0] rs_wire_EX;
	wire [4:0] rt_wire_EX;
	wire [4:0] rd_wire_EX;
    wire [4:0] write_register_wire_EX;
    wire [31:0] pc_branch_wire_EX;
    wire [3:0] alu_operation_wire;
    wire [31:0] shift_left_2_1_wire;
    wire [1:0] forwardA_wire;
    wire [1:0] forwardB_wire;
    wire [31:0] forwardA_mux_result_wire;
    wire [31:0] forwardB_mux_result_wire;

    // Memory stage wires
    wire reg_write_wire_ME;
    wire [1:0] mem_to_reg_wire_ME;
    wire mem_write_wire_ME;
    wire mem_read_wire_ME;
    wire [31:0] alu_result_wire_ME;
    wire [31:0] write_data_wire_ME;
    wire [4:0] write_register_wire_ME;
    wire [31:0] pc_branch_wire_ME;
    wire [31:0] read_data_wire_ME;

    // Write Back wires
    wire reg_write_wire_WB;
    wire [1:0] mem_to_reg_wire_WB;
    wire [31:0] alu_result_wire_WB;
    wire [31:0] read_data_wire_WB;
    wire [4:0] write_register_wire_WB;
	wire [31:0] write_data_wire_WB;

    // Hazard / Stall Flushes Wires
    wire stall_IF_wire;
    wire stall_ID_wire;
    wire flush_EX_wire;

    // signals to connect modules
    wire [1:0] jump_wire;
    wire [1:0] reg_dst_wire; //
    wire alu_src_wire; //
    wire reg_write_wire; //
    wire mem_read_wire;
    wire mem_write_wire;
    wire [1:0] mem_to_reg_wire;
    wire [31:0] write_data_wire;
    wire [3:0] aluop_wire; //
    wire [4:0] write_register_wire; //
    wire [31:0] instruction_bus_wire; //
    wire [31:0] read_data_1_wire; //
    wire [31:0] read_data_2_wire; //
    wire [31:0] immediate_extend_wire; //
    wire [31:0] read_data_2_or_immediate_wire; //
    wire [31:0] branch_adder_output_wire;
    wire [31:0] pc_plus_4_wire; //
    wire [27:0] jump_address_wire;
    
    // ******************************** IF Stage ******************************** //
    // Funcional sin j, jal y jr
    Multiplexer2to1
    PC_Src_MUX
    (
    .Selector(pc_src_wire_ID),
    .MUX_Data0(pc_plus_4_wire_IF),
    .MUX_Data1(pc_branch_wire_ID),
    .MUX_Output(next_pc_wire)
    );
    
    PC_Register
    ProgramCounter
    (
    .clk(clk),
    .reset(reset),
    .enable(~stall_IF_wire),
    .NewPC(next_pc_wire),
    .PCValue(pc_wire)
    );
    
    Adder32bits
    PC_Adder
    (
    .Data0(pc_wire),
    .Data1(PC_INCREMENT),
    .Result(pc_plus_4_wire_IF)
    );

    ProgramMemory
    #(
    .MEMORY_DEPTH(MEMORY_DEPTH)
    )
    ROMProgramMemory
    (
    .Address(pc_wire),
    .Instruction(instruction_bus_wire_IF)
    );

    // ************************************************************************** //
    // ******************************** IF ID Register ************************** //
    IF_ID_Register 
    IF_ID_Register
    (
    // Inputs
    .clk(clk),
    .reset(reset && ~pc_src_wire_ID),
    .enable(~stall_ID_wire),
    .instruction_in(instruction_bus_wire_IF),
    .pc_plus_4_in(pc_plus_4_wire_IF),

     // Outputs
    .instruction_out(instruction_bus_wire_ID),
    .pc_plus_4_out(pc_plus_4_wire_ID)
    );
    
    // ************************************************************************** //
    // ******************************** ID Stage ******************************** //
    Control
    ControlUnit
    (
    .OP(instruction_bus_wire_ID[31:26]),
    .Func(instruction_bus_wire_ID[5:0]),
    .RegDst(reg_dst_wire_ID),
    .Jump(jump_wire),
    .BranchEQ(branch_eq_wire_ID),
    .BranchNE(branch_ne_wire_ID),
    .MemRead(mem_read_wire_ID),
    .MemtoReg(mem_to_reg_wire_ID),
    .MemWrite(mem_write_wire_ID),
    .ALUOp(aluop_wire_ID),
    .ALUSrc(alu_src_wire_ID),
    .RegWrite(reg_write_wire_ID)
    );

    RegisterFile
    Register_File
    (
    .clk(clk),
    .reset(reset),
    .RegWrite(reg_write_wire_WB),
    .WriteRegister(write_register_wire_WB),
    .ReadRegister1(instruction_bus_wire_ID[25:21]),
    .ReadRegister2(instruction_bus_wire_ID[20:16]),
    .WriteData(write_data_wire_WB),
    .ReadData1(read_data_1_wire_ID),
    .ReadData2(read_data_2_wire_ID)
    );

    Multiplexer2to1
    ForwardA_ID_MUX
    (
    .Selector(forwardA_ID_wire),
    .MUX_Data0(read_data_1_wire_ID),
    .MUX_Data1(alu_result_wire_ME),
    .MUX_Output(forwardA_ID_mux_out_wire)
    );

    Multiplexer2to1
    ForwardB_ID_MUX
    (
    .Selector(forwardB_ID_wire),
    .MUX_Data0(read_data_2_wire_ID),
    .MUX_Data1(alu_result_wire_ME),
    .MUX_Output(forwardB_ID_mux_out_wire)
    );

    EqualityComparator
    EqualityComparator
    (
    .ReadData1(forwardA_ID_mux_out_wire),
    .ReadData2(forwardB_ID_mux_out_wire),
    .Zero(zero_wire)
    );

    Multiplexer2to1
    BranchEQ_NE_MUX
    (
    .Selector(zero_wire),
    .MUX_Data0(branch_ne_wire_ID),
    .MUX_Data1(branch_eq_wire_ID),
    .MUX_Output(pc_src_wire_ID)
    );

    SignExtend
    SignExtendForConstants
    (
    .DataInput(instruction_bus_wire_ID[15:0]),
    .SignExtendOutput(immediate_extend_wire_ID)
    );

    ShiftLeft2
    Shift_Left_2_1
    (
    .DataInput(immediate_extend_wire_ID),
    .DataOutput(shift_left_2_1_wire)
    );

    Adder32bits
    Branch_Adder
    (
    .Data0(pc_plus_4_wire_ID),
    .Data1(shift_left_2_1_wire),
    .Result(pc_branch_wire_ID)
    );

    // ************************************************************************** //
    // ******************************** ID EX Register ************************** //
    ID_EX_Register 
    ID_EX_Register
    (
    // Inputs
    .clk(clk),
    .reset(reset && ~flush_EX_wire),
    .reg_write_in(reg_write_wire_ID),
    .mem_to_reg_in(mem_to_reg_wire_ID),
    .mem_write_in(mem_write_wire_ID),
    .mem_read_in(mem_read_wire_ID),
    .branch_ne_in(branch_ne_wire_ID),
    .branch_eq_in(branch_eq_wire_ID),
    .aluop_in(aluop_wire_ID),
    .alu_src_in(alu_src_wire_ID),
    .reg_dst_in(reg_dst_wire_ID),
    .read_data_1_in(read_data_1_wire_ID),
    .read_data_2_in(read_data_2_wire_ID),
    .rs_in(instruction_bus_wire_ID[25:21]),
    .rt_in(instruction_bus_wire_ID[20:16]),
    .rd_in(instruction_bus_wire_ID[15:11]),
    .shamt_in(instruction_bus_wire_ID[10:6]),
    .immediate_extend_in(immediate_extend_wire_ID),
    .pc_plus_4_in(pc_plus_4_wire_ID),

     // Outputs
    .reg_write_out(reg_write_wire_EX),
    .mem_to_reg_out(mem_to_reg_wire_EX),
    .mem_write_out(mem_write_wire_EX),
    .mem_read_out(mem_read_wire_EX),
    .branch_ne_out(branch_ne_wire_EX),
    .branch_eq_out(branch_eq_wire_EX),
    .aluop_out(aluop_wire_EX),
    .alu_src_out(alu_src_wire_EX),
    .reg_dst_out(reg_dst_wire_EX),
    .read_data_1_out(read_data_1_wire_EX),
    .read_data_2_out(read_data_2_wire_EX),
    .rs_out(rs_wire_EX),
    .rt_out(rt_wire_EX),
    .rd_out(rd_wire_EX),
    .shamt_out(shamt_wire_EX),
    .immediate_extend_out(immediate_extend_wire_EX),
    .pc_plus_4_out(pc_plus_4_wire_EX)
    );
    
    // ************************************************************************** //
    // ******************************** EX Stage ******************************** //
    Multiplexer3to1
    #(
    .NBits(5)
    )
    Reg_Dst_MUX
    (
    .Selector(reg_dst_wire_EX),
    .MUX_Data0(rt_wire_EX),
    .MUX_Data1(rd_wire_EX),
    .MUX_Data2(5'b11111),
    .MUX_Output(write_register_wire_EX)
    );

    Multiplexer2to1
    ALU_Src_MUX
    (
    .Selector(alu_src_wire_EX),
    .MUX_Data0(forwardB_mux_result_wire),
    .MUX_Data1(immediate_extend_wire_EX),
    .MUX_Output(src_B_wire_EX)
    );

    ALUControl
    ArithmeticLogicUnitControl
    (
    .ALUOp(aluop_wire_EX),
    .ALUFunction(immediate_extend_wire_EX[5:0]),
    .ALUOperation(alu_operation_wire)
    );
    
    ALU
    ArithmeticLogicUnit
    (
    .ALUOperation(alu_operation_wire),
    .A(forwardA_mux_result_wire),
    .B(src_B_wire_EX),
    .Shamt(shamt_wire_EX),
    .ALUResult(alu_result_wire_EX)
    );

    Multiplexer3to1
    ForwardA_MUX
    (
    .Selector(forwardA_wire),
    .MUX_Data0(read_data_1_wire_EX),
    .MUX_Data1(write_data_wire_WB),
    .MUX_Data2(alu_result_wire_ME),
    .MUX_Output(forwardA_mux_result_wire)
    );

    Multiplexer3to1
    ForwardB_MUX
    (
    .Selector(forwardB_wire),
    .MUX_Data0(read_data_2_wire_EX),
    .MUX_Data1(write_data_wire_WB),
    .MUX_Data2(alu_result_wire_ME),
    .MUX_Output(forwardB_mux_result_wire)
    );

    // ************************************************************************** //
    // ******************************** EX ME Register ************************** //
    EX_ME_Register 
    EX_ME_Register
    (
    // Inputs
    .clk(clk),
    .reset(reset),
    .reg_write_in(reg_write_wire_EX),
    .mem_to_reg_in(mem_to_reg_wire_EX),
    .mem_write_in(mem_write_wire_EX),
    .mem_read_in(mem_read_wire_EX),
    .alu_result_in(alu_result_wire_EX),
    .write_data_in(forwardB_mux_result_wire),
    .write_reg_in(write_register_wire_EX),
    .pc_branch_in(pc_plus_4_wire_EX),

     // Outputs
    .reg_write_out(reg_write_wire_ME),
    .mem_to_reg_out(mem_to_reg_wire_ME),
    .mem_write_out(mem_write_wire_ME),
    .mem_read_out(mem_read_wire_ME),
    .alu_result_out(alu_result_wire_ME),
    .write_data_out(write_data_wire_ME),
    .write_reg_out(write_register_wire_ME),
    .pc_branch_out(pc_branch_wire_ME)
    );
    
    // ************************************************************************** //
    // ******************************** ME Stage ******************************** //
    DataMemory
    Data_Memory_RAM
    (
    .clk(clk),
    .WriteData(write_data_wire_ME),
    .Address(alu_result_wire_ME),
    .MemWrite(mem_write_wire_ME),
    .MemRead(mem_read_wire_ME),
    .ReadData(read_data_wire_ME)
    );

    // ************************************************************************** //
    // ******************************** ME WB Register ************************** //
    ME_WB_Register 
    ME_WB_Register
    (
    // Inputs
    .clk(clk),
    .reset(reset),
    .reg_write_in(reg_write_wire_ME),
    .mem_to_reg_in(mem_to_reg_wire_ME),
    .alu_result_in(alu_result_wire_ME),
    .read_data_in(read_data_wire_ME),
    .write_reg_in(write_register_wire_ME),

     // Outputs
    .reg_write_out(reg_write_wire_WB),
    .mem_to_reg_out(mem_to_reg_wire_WB),
    .alu_result_out(alu_result_wire_WB),
    .read_data_out(read_data_wire_WB),
    .write_reg_out(write_register_wire_WB)
    );
    
    // ************************************************************************** //
    // ******************************** WB Stage ******************************** //
    Multiplexer3to1
    Result_MUX
    (
    .Selector(mem_to_reg_wire_WB),
    .MUX_Data0(alu_result_wire_WB),
    .MUX_Data1(read_data_wire_WB),
    .MUX_Data2(pc_plus_4_wire_IF), // Cambiar despues porque es necesario que viaje por todos los pipelines
    .MUX_Output(write_data_wire_WB)
    );
    
    // ************************************************************************** //
    // ******************************** Forwarding Unit ************************ //
    ForwardingUnit
    ForwardingUnit
    (
    .EX_ME_reg_write(reg_write_wire_ME),
    .ME_WB_reg_write(reg_write_wire_WB),
    .ID_EX_rs(rs_wire_EX),
    .ID_EX_rt(rt_wire_EX),
    .EX_ME_write_register(write_register_wire_ME),
    .ME_WB_write_register(write_register_wire_WB),

    .ForwardA(forwardA_wire),
    .ForwardB(forwardB_wire)
    );

    // ************************************************************************* //
    // ******************************** Hazard Detection Unit ****************** //
    HazardDetectionUnit
    HazardDetectionUnit
    (
    .Rs_ID(instruction_bus_wire_ID[25:21]),
    .Rt_ID(instruction_bus_wire_ID[20:16]),
    .Rt_EX(rt_wire_EX),
    .MemToReg_EX(mem_to_reg_wire_EX),
    .MemToReg_ME(mem_to_reg_wire_ME),
    .BranchEQ_ID(branch_eq_wire_ID),
    .BranchNE_ID(branch_ne_wire_ID),
    .RegWrite_EX(reg_write_wire_EX),
    .RegWrite_ME(reg_write_wire_ME),
    .WriteReg_EX(write_register_wire_EX),
    .WriteReg_ME(write_register_wire_ME),

    .Stall_IF(stall_IF_wire),
    .Stall_ID(stall_ID_wire),
    .Flush_EX(flush_EX_wire),
    .ForwardA_ID(forwardA_ID_wire),
    .ForwardB_ID(forwardB_ID_wire)
    );

    // ****** Seccion del j, jal y jr que no se usa ****** //
    ShiftLeft2
    Shift_Left_2_2
    (
    .DataInput(instruction_bus_wire_ID[25:0]), // Cambiar despues porque es necesario que viaje por más pipelines
    .DataOutput(jump_address_wire) // Probablemente tenga que viajar por mas los pipelines
    );

    // MUX dudoso que sugiero que se coloque antes del pc en IF
    Multiplexer3to1
    PC_Src_MUX_2
    (
    .Selector(jump_wire),
    .MUX_Data0(next_pc_wire_1),
    .MUX_Data1({pc_plus_4_wire[31:28], jump_address_wire & 28'h000_03ff}), // 10 bit mask for ROM
    .MUX_Data2(read_data_1_wire),
    .MUX_Output(next_pc_wire_2)
    );
    
    // ************************************************************************** //
    
endmodule
    
