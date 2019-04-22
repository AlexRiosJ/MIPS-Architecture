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
    wire reg_dst_wire_ID;
    wire [31:0] read_data_1_wire_ID;
    wire [31:0] read_data_2_wire_ID;
    wire [31:0] immediate_extend_wire_ID;

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
    wire reg_dst_wire_EX;
    wire [31:0] read_data_1_wire_EX;
    wire [31:0] read_data_2_wire_EX;
    wire [31:0] immediate_extend_wire_EX;
    wire [31:0] src_B_wire_EX;
    wire [4:0] shamt_wire_EX;
    wire zero_wire_EX;
    wire [31:0] alu_result_wire_EX;
	 wire [4:0] rt_wire_EX;
	 wire [4:0] rd_wire_EX;
    wire [4:0] write_register_wire_EX;
    wire [31:0] pc_branch_wire_EX;
    wire [3:0] alu_operation_wire;
    wire [31:0] shift_left_2_1_wire;

    // Memory stage wires
    wire reg_write_wire_ME;
    wire [1:0] mem_to_reg_wire_ME;
    wire mem_write_wire_ME;
    wire mem_read_wire_ME;
    wire branch_ne_wire_ME;
    wire branch_eq_wire_ME;
    wire zero_wire_ME;
    wire [31:0] alu_result_wire_ME;
    wire [31:0] write_data_wire_ME;
    wire [4:0] write_register_wire_ME;
    wire [31:0] pc_branch_wire_ME;
    wire [31:0] read_data_wire_ME;
    wire zero_and_branch_eq_wire;
    wire not_zero_and_branch_ne_wire;
    wire pc_src_wire_ME;

    // Write Back wires
    wire reg_write_wire_WB;
    wire [1:0] mem_to_reg_wire_WB;
    wire [31:0] alu_result_wire_WB;
    wire [31:0] read_data_wire_WB;
    wire [4:0] write_register_wire_WB;
	 wire [31:0] write_data_wire_WB;

    // signals to connect modules
    wire [1:0] jump_wire;
    wire branch_ne_wire; //
    wire branch_eq_wire; //
    wire [1:0] reg_dst_wire; //
    wire alu_src_wire; //
    wire reg_write_wire; //
    wire zero_wire; //
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
    .Selector(pc_src_wire_ME),
    .MUX_Data0(pc_plus_4_wire_IF),
    .MUX_Data1(pc_branch_wire_ME),
    .MUX_Output(next_pc_wire)
    );
    
    PC_Register
    ProgramCounter
    (
    .clk(clk),
    .reset(reset),
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
    .reset(reset),
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

    SignExtend
    SignExtendForConstants
    (
    .DataInput(instruction_bus_wire_ID[15:0]),
    .SignExtendOutput(immediate_extend_wire_ID)
    );

    // ************************************************************************** //
    // ******************************** ID EX Register ************************** //
    ID_EX_Register 
    ID_EX_Register
    (
    // Inputs
    .clk(clk),
    .reset(reset),
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
    .MUX_Data0(read_data_2_wire_EX),
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
    .A(read_data_1_wire_EX),
    .B(src_B_wire_EX),
    .Shamt(shamt_wire_EX),
    .Zero(zero_wire_EX),
    .ALUResult(alu_result_wire_EX)
    );

    ShiftLeft2
    Shift_Left_2_1
    (
    .DataInput(immediate_extend_wire_EX),
    .DataOutput(shift_left_2_1_wire)
    );

    Adder32bits
    Branch_Adder
    (
    .Data0(pc_plus_4_wire_EX),
    .Data1(shift_left_2_1_wire),
    .Result(pc_branch_wire_EX)
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
    .branch_ne_in(branch_ne_wire_EX),
    .branch_eq_in(branch_eq_wire_EX),
    .zero_in(zero_wire_EX),
    .alu_result_in(alu_result_wire_EX),
    .write_data_in(read_data_2_wire_EX),
    .write_reg_in(write_register_wire_EX),
    .pc_branch_in(pc_branch_wire_EX),

     // Outputs
    .reg_write_out(reg_write_wire_ME),
    .mem_to_reg_out(mem_to_reg_wire_ME),
    .mem_write_out(mem_write_wire_ME),
    .mem_read_out(mem_read_wire_ME),
    .branch_ne_out(branch_ne_wire_ME),
    .branch_eq_out(branch_eq_wire_ME),
    .zero_out(zero_wire_ME),
    .alu_result_out(alu_result_wire_ME),
    .write_data_out(write_data_wire_ME),
    .write_reg_out(write_register_wire_ME),
    .pc_branch_out(pc_branch_wire_ME)
    );
    
    // ************************************************************************** //
    // ******************************** ME Stage ******************************** //
    ANDGate
    BranchEQ_AND_Gate
    (
    .A(branch_eq_wire_ME),
    .B(zero_wire_ME),
    .C(zero_and_branch_eq_wire)
    );
    
    ANDGate
    BranchNE_AND_Gate
    (
    .A(branch_ne_wire_ME),
    .B(~zero_wire_ME),
    .C(not_zero_and_branch_ne_wire)
    );
    
    ORGate
    Branch_OR_Gate
    (
    .A(zero_and_branch_eq_wire),
    .B(not_zero_and_branch_ne_wire),
    .C(pc_src_wire_ME)
    );

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
    .write_reg_out(write_register_wire_WB),
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
    
