module id_ex_register
(
    input wire clk,
    input wire rst,

    input wire        reg_write_in,
    input wire        mem_write_in,
    input wire        mem_read_in,
    input wire        branch_in,
    input wire        jump_in,
    input wire        jalr_in,
    input wire        alu_src_in,
    input wire [1:0]  result_src_in,
    input wire [3:0]  alu_control_in,

    input wire [31:0] pc_in,
    input wire [31:0] pc_plus4_in,
    input wire [31:0] rs1_data_in,
    input wire [31:0] rs2_data_in,
    input wire [31:0] immediate_in,
    input wire [4:0]  rs1_in,
    input wire [4:0]  rs2_in,
    input wire [4:0]  rd_in,
    input wire [2:0]  funct3_in,
    input wire [6:0]  opcode_in,

    output reg        reg_write_out,
    output reg        mem_write_out,
    output reg        mem_read_out,
    output reg        branch_out,
    output reg        jump_out,
    output reg        jalr_out,
    output reg        alu_src_out,
    output reg [1:0]  result_src_out,
    output reg [3:0]  alu_control_out,

    output reg [31:0] pc_out,
    output reg [31:0] pc_plus4_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] immediate_out,
    output reg [4:0]  rs1_out,
    output reg [4:0]  rs2_out,
    output reg [4:0]  rd_out,
    output reg [2:0]  funct3_out,
    output reg [6:0]  opcode_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_write_out  <= 1'b0;
            mem_write_out  <= 1'b0;
            mem_read_out   <= 1'b0;
            branch_out     <= 1'b0;
            jump_out       <= 1'b0;
            jalr_out       <= 1'b0;
            alu_src_out    <= 1'b0;
            result_src_out <= 2'b00;
            alu_control_out <= 4'b0000;

            pc_out         <= 32'b0;
            pc_plus4_out   <= 32'b0;
            rs1_data_out   <= 32'b0;
            rs2_data_out   <= 32'b0;
            immediate_out  <= 32'b0;
            rs1_out        <= 5'b0;
            rs2_out        <= 5'b0;
            rd_out         <= 5'b0;
            funct3_out     <= 3'b0;
            opcode_out     <= 7'b0;
        end else begin
            reg_write_out  <= reg_write_in;
            mem_write_out  <= mem_write_in;
            mem_read_out   <= mem_read_in;
            branch_out     <= branch_in;
            jump_out       <= jump_in;
            jalr_out       <= jalr_in;
            alu_src_out    <= alu_src_in;
            result_src_out <= result_src_in;
            alu_control_out <= alu_control_in;

            pc_out         <= pc_in;
            pc_plus4_out   <= pc_plus4_in;
            rs1_data_out   <= rs1_data_in;
            rs2_data_out   <= rs2_data_in;
            immediate_out  <= immediate_in;
            rs1_out        <= rs1_in;
            rs2_out        <= rs2_in;
            rd_out         <= rd_in;
            funct3_out     <= funct3_in;
            opcode_out     <= opcode_in;
        end
    end

endmodule
