/******************************************************************
 * Description
 *	This is the top-level of a MIPS processor that can execute the next set of instructions:
 *		add
 *		addi
 *		sub
 *		ori
 *		or
 *		and
 *		nor
 * This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
 * Parameter MEMORY_DEPTH configures the program memory to allocate the program to
 * be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
 * This processor was made for computer architecture class at ITESO.
 * Version:
 *	1.5
 * Author:
 *	Dr. JosÃ© Luis Pizano Escalante
 * email:
 *	luispizano@iteso.mx
 * Date:
 *	2/09/2018
 ******************************************************************/


module MIPS_Processor #(parameter MEMORY_DEPTH = 32,
                        parameter PC_INCREMENT = 4)
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
    // wire branch_ne_wire; //
    // wire branch_eq_wire; //
	 wire branch_wire;
    wire reg_dst_wire; // 
    wire not_zero_and_brach_ne; //
    wire zero_and_brach_eq; //
    wire or_for_branch; //
    wire alu_src_wire; //
    wire reg_write_wire; //
    wire zero_wire; //
	 wire pc_src_wire;
	 wire mem_read_wire;
	 wire mem_write_wire;
	 wire mem_to_reg_wire;
	 wire [31:0] write_data_wire;
	 wire [31:0] read_data_wire;
    wire [2:0] aluop_wire; //
    wire [3:0] alu_operation_wire; //
    wire [4:0] write_register_wire; //
    wire [31:0] mux_pc_wire; //
    wire [31:0] pc_wire; //
    wire [31:0] instruction_bus_wire; //
    wire [31:0] read_data_1_wire; //
    wire [31:0] read_data_2_wire; //
    wire [31:0] immediate_extend_wire; //
    wire [31:0] read_data_2_or_immediate_wire; //
    wire [31:0] alu_result_wire; //
	 wire [31:0] alu_result_2_wire;
    wire [31:0] pc_plus_4_wire; //
    wire [31:0] pc_to_branch_wire; //
	 wire [31:0] next_pc_wire;
	 wire [31:0] shift_left_2_1_wire;
    
    //******************************************************************/
    //******************************************************************/
    //******************************************************************/
    //******************************************************************/
    //******************************************************************/
	 Multiplexer2to1
    MUX_ForPC_Or_Branch
    (
    .Selector(pc_src_wire),
    .MUX_Data0(pc_plus_4_wire),
    .MUX_Data1(alu_result_2_wire),
    .MUX_Output(next_pc_wire)
    );
	 
	 Adder32bits
    PC_Plus_4
    (
    .Data0(pc_wire),
    .Data1(PC_INCREMENT),
    .Result(pc_plus_4_wire)
    );
	 
	 ShiftLeft2
	 Shif_Left_2_1
	 (
	 .DataInput(immediate_extend_wire),
	 .DataOutput(shift_left_2_1_wire)
	 );
	 
	 Adder32bits
	 PC_plus_4_plus_instruction
	 (
	 .Data0(pc_plus_4_wire),
	 .Data1(shift_left_2_1_wire),
	 .Result(alu_result_2_wire)
	 );
	 
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
	 
	 Control
    ControlUnit
    (
    .OP(instruction_bus_wire[31:26]),
    .RegDst(reg_dst_wire),
    //.BranchNE(branch_ne_wire),
    //.BranchEQ(branch_eq_wire),
	 .Branch(branch_wire),
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
    Multiplexer2to1
    #(
    .NBits(5)
    )
    MUX_ForRTypeAndIType
    (
    .Selector(reg_dst_wire),
    .MUX_Data0(instruction_bus_wire[20:16]),
    .MUX_Data1(instruction_bus_wire[15:11]),
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
    MUX_ForReadDataAndInmediate
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
	 AND_Gate_For_Branches
	 (
	 .A(branch_wire),
	 .B(zero_wire),
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
	 
	 Multiplexer2to1
	 Data_Memory_MUX
	 (
    .Selector(mem_to_reg_wire),
    .MUX_Data0(alu_result_wire),
    .MUX_Data1(read_data_wire),
    .MUX_Output(write_data_wire)
    );
    
    assign ALUResultOut = alu_result_wire;
    
endmodule
    
