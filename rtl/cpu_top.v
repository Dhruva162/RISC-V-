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
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] immediate;
    wire [31:0] alu_operand_a;
    wire [31:0] alu_operand_b;
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

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign funct7_bit5 = instruction[30];

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
        .instruction(instruction)
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
        .write_enable(reg_write),
        .read_addr1(rs1),
        .read_addr2(rs2),
        .write_addr(rd),
        .write_data(writeback_data),
        .read_data1(rs1_data),
        .read_data2(rs2_data)
    );

    immediate_generator immediate_generator_inst (
        .instruction(instruction),
        .immediate(immediate)
    );

    mux2 #(.WIDTH(32)) alu_src_mux (
        .d0(rs2_data),
        .d1(immediate),
        .sel(alu_src),
        .y(alu_operand_b)
    );

    assign alu_operand_a = (opcode == 7'b0010111) ? pc : rs1_data;

    alu alu_inst (
        .a(alu_operand_a),
        .b(alu_operand_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(alu_zero)
    );

    data_memory #(
        .ADDR_WIDTH(DMEM_ADDR_WIDTH)
    ) data_memory_inst (
        .clk(clk),
        .rst(rst),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .funct3(funct3),
        .address(alu_result),
        .write_data(rs2_data),
        .read_data(read_data)
    );

    branch_unit branch_unit_inst (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .funct3(funct3),
        .branch(branch),
        .branch_taken(branch_taken)
    );

    adder #(.WIDTH(32)) pc_plus4_adder (
        .a(pc),
        .b(32'd4),
        .y(pc_plus4)
    );

    adder #(.WIDTH(32)) pc_target_adder (
        .a(pc),
        .b(immediate),
        .y(pc_target)
    );

    assign jalr_target = (rs1_data + immediate) & 32'hffff_fffe;
    assign pc_link = pc_plus4;
    assign take_target = branch_taken | jump;

    mux4 #(.WIDTH(32)) result_mux (
        .d0(alu_result),
        .d1(read_data),
        .d2(pc_link),
        .d3(immediate),
        .sel(result_src),
        .y(writeback_data)
    );

    assign pc_next = jalr ? jalr_target :
                     take_target ? pc_target :
                     pc_plus4;

endmodule
