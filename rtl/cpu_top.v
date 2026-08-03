module cpu_top
#(
    parameter IMEM_ADDR_WIDTH = 10,
    parameter DMEM_ADDR_WIDTH = 12,
    parameter IMEM_INIT_FILE = ""
)
(
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] pc,
    output wire [31:0] instruction,
    output wire [31:0] alu_result
);

    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] pc_target;
    wire [31:0] jalr_target;
    wire [31:0] if_instruction;
    wire [31:0] id_instruction;
    wire [31:0] id_pc;
    wire [31:0] id_pc_plus4;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] immediate;
    wire [31:0] alu_operand_a;
    wire [31:0] alu_operand_b;
    wire [31:0] ex_alu_result;
    wire [31:0] read_data;
    wire [31:0] writeback_data;
    wire [31:0] pc_link;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire       funct7_bit5;

    wire       reg_write;
    wire       mem_write;
    wire       mem_read;
    wire       branch;
    wire       jump;
    wire       jalr;
    wire       alu_src;
    wire [1:0] result_src;
    wire [3:0] alu_control;
    wire       branch_taken;
    wire       take_target;
    wire       alu_zero;

    wire       ex_reg_write;
    wire       ex_mem_write;
    wire       ex_mem_read;
    wire       ex_branch;
    wire       ex_jump;
    wire       ex_jalr;
    wire       ex_alu_src;
    wire [1:0] ex_result_src;
    wire [3:0] ex_alu_control;
    wire [31:0] ex_pc;
    wire [31:0] ex_pc_plus4;
    wire [31:0] ex_rs1_data;
    wire [31:0] ex_rs2_data;
    wire [31:0] ex_immediate;
    wire [4:0] ex_rs1;
    wire [4:0] ex_rs2;
    wire [4:0] ex_rd;
    wire [2:0] ex_funct3;
    wire [6:0] ex_opcode;

    wire       mem_reg_write;
    wire       mem_mem_write;
    wire       mem_mem_read;
    wire [1:0] mem_result_src;
    wire [31:0] mem_alu_result;
    wire [31:0] mem_rs2_data;
    wire [31:0] mem_pc_plus4;
    wire [31:0] mem_immediate;
    wire [4:0] mem_rd;
    wire [2:0] mem_funct3;

    wire       wb_reg_write;
    wire [1:0] wb_result_src;
    wire [31:0] wb_alu_result;
    wire [31:0] wb_read_data;
    wire [31:0] wb_pc_plus4;
    wire [31:0] wb_immediate;
    wire [4:0] wb_rd;

    assign instruction = id_instruction;
    assign alu_result = ex_alu_result;
    assign opcode = id_instruction[6:0];
    assign rd = id_instruction[11:7];
    assign funct3 = id_instruction[14:12];
    assign rs1 = id_instruction[19:15];
    assign rs2 = id_instruction[24:20];
    assign funct7_bit5 = id_instruction[30];

    program_counter pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    instruction_memory #(
        .ADDR_WIDTH(IMEM_ADDR_WIDTH),
        .INIT_FILE(IMEM_INIT_FILE)
    ) instruction_memory_inst (
        .address(pc),
        .instruction(if_instruction)
    );

    if_id_register if_id_register_inst (
        .clk(clk),
        .rst(rst),
        .instruction_in(if_instruction),
        .pc_in(pc),
        .pc_plus4_in(pc_plus4),
        .instruction_out(id_instruction),
        .pc_out(id_pc),
        .pc_plus4_out(id_pc_plus4)
    );

    control_unit control_unit_inst (
        .opcode(opcode),
        .funct3(funct3),
        .funct7_bit5(funct7_bit5),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .alu_src(alu_src),
        .result_src(result_src),
        .alu_control(alu_control)
    );

    register_file register_file_inst (
        .clk(clk),
        .rst(rst),
        .write_enable(wb_reg_write),
        .read_addr1(rs1),
        .read_addr2(rs2),
        .write_addr(wb_rd),
        .write_data(writeback_data),
        .read_data1(rs1_data),
        .read_data2(rs2_data)
    );

    immediate_generator immediate_generator_inst (
        .instruction(instruction),
        .immediate(immediate)
    );

    id_ex_register id_ex_register_inst (
        .clk(clk),
        .rst(rst),
        .reg_write_in(reg_write),
        .mem_write_in(mem_write),
        .mem_read_in(mem_read),
        .branch_in(branch),
        .jump_in(jump),
        .jalr_in(jalr),
        .alu_src_in(alu_src),
        .result_src_in(result_src),
        .alu_control_in(alu_control),
        .pc_in(id_pc),
        .pc_plus4_in(id_pc_plus4),
        .rs1_data_in(rs1_data),
        .rs2_data_in(rs2_data),
        .immediate_in(immediate),
        .rs1_in(rs1),
        .rs2_in(rs2),
        .rd_in(rd),
        .funct3_in(funct3),
        .opcode_in(opcode),
        .reg_write_out(ex_reg_write),
        .mem_write_out(ex_mem_write),
        .mem_read_out(ex_mem_read),
        .branch_out(ex_branch),
        .jump_out(ex_jump),
        .jalr_out(ex_jalr),
        .alu_src_out(ex_alu_src),
        .result_src_out(ex_result_src),
        .alu_control_out(ex_alu_control),
        .pc_out(ex_pc),
        .pc_plus4_out(ex_pc_plus4),
        .rs1_data_out(ex_rs1_data),
        .rs2_data_out(ex_rs2_data),
        .immediate_out(ex_immediate),
        .rs1_out(ex_rs1),
        .rs2_out(ex_rs2),
        .rd_out(ex_rd),
        .funct3_out(ex_funct3),
        .opcode_out(ex_opcode)
    );

    mux2 #(.WIDTH(32)) alu_src_mux (
        .d0(ex_rs2_data),
        .d1(ex_immediate),
        .sel(ex_alu_src),
        .y(alu_operand_b)
    );

    assign alu_operand_a = (ex_opcode == 7'b0010111) ? ex_pc : ex_rs1_data;

    alu alu_inst (
        .a(alu_operand_a),
        .b(alu_operand_b),
        .alu_control(ex_alu_control),
        .result(ex_alu_result),
        .zero(alu_zero)
    );

    ex_mem_register ex_mem_register_inst (
        .clk(clk),
        .rst(rst),
        .reg_write_in(ex_reg_write),
        .mem_write_in(ex_mem_write),
        .mem_read_in(ex_mem_read),
        .result_src_in(ex_result_src),
        .alu_result_in(ex_alu_result),
        .rs2_data_in(ex_rs2_data),
        .pc_plus4_in(ex_pc_plus4),
        .immediate_in(ex_immediate),
        .rd_in(ex_rd),
        .funct3_in(ex_funct3),
        .reg_write_out(mem_reg_write),
        .mem_write_out(mem_mem_write),
        .mem_read_out(mem_mem_read),
        .result_src_out(mem_result_src),
        .alu_result_out(mem_alu_result),
        .rs2_data_out(mem_rs2_data),
        .pc_plus4_out(mem_pc_plus4),
        .immediate_out(mem_immediate),
        .rd_out(mem_rd),
        .funct3_out(mem_funct3)
    );

    data_memory #(
        .ADDR_WIDTH(DMEM_ADDR_WIDTH)
    ) data_memory_inst (
        .clk(clk),
        .rst(rst),
        .mem_write(mem_mem_write),
        .mem_read(mem_mem_read),
        .funct3(mem_funct3),
        .address(mem_alu_result),
        .write_data(mem_rs2_data),
        .read_data(read_data)
    );

    mem_wb_register mem_wb_register_inst (
        .clk(clk),
        .rst(rst),
        .reg_write_in(mem_reg_write),
        .result_src_in(mem_result_src),
        .alu_result_in(mem_alu_result),
        .read_data_in(read_data),
        .pc_plus4_in(mem_pc_plus4),
        .immediate_in(mem_immediate),
        .rd_in(mem_rd),
        .reg_write_out(wb_reg_write),
        .result_src_out(wb_result_src),
        .alu_result_out(wb_alu_result),
        .read_data_out(wb_read_data),
        .pc_plus4_out(wb_pc_plus4),
        .immediate_out(wb_immediate),
        .rd_out(wb_rd)
    );

    branch_unit branch_unit_inst (
        .rs1_data(ex_rs1_data),
        .rs2_data(ex_rs2_data),
        .funct3(ex_funct3),
        .branch(ex_branch),
        .branch_taken(branch_taken)
    );

    adder #(.WIDTH(32)) pc_plus4_adder (
        .a(pc),
        .b(32'd4),
        .y(pc_plus4)
    );

    adder #(.WIDTH(32)) pc_target_adder (
        .a(ex_pc),
        .b(ex_immediate),
        .y(pc_target)
    );

    assign jalr_target = (ex_rs1_data + ex_immediate) & 32'hffff_fffe;
    assign pc_link = wb_pc_plus4;
    assign take_target = branch_taken | ex_jump;

    mux4 #(.WIDTH(32)) result_mux (
        .d0(wb_alu_result),
        .d1(wb_read_data),
        .d2(pc_link),
        .d3(wb_immediate),
        .sel(wb_result_src),
        .y(writeback_data)
    );

    assign pc_next = ex_jalr ? jalr_target :
                     take_target ? pc_target :
                     pc_plus4;

endmodule
