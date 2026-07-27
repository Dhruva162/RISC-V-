module control_unit
(
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire       funct7_bit5,
    output wire       reg_write,
    output wire       mem_write,
    output wire       mem_read,
    output wire       branch,
    output wire       jump,
    output wire       jalr,
    output wire       alu_src,
    output wire [1:0] result_src,
    output wire [3:0] alu_control
);

    wire [1:0] alu_op;

    main_decoder main_decoder_inst (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .alu_src(alu_src),
        .result_src(result_src),
        .alu_op(alu_op)
    );

    alu_decoder alu_decoder_inst (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7_bit5(funct7_bit5),
        .opcode_bit5(opcode[5]),
        .alu_control(alu_control)
    );

endmodule
