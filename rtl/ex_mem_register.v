module ex_mem_register
(
    input wire clk,
    input wire rst,

    input wire        reg_write_in,
    input wire        mem_write_in,
    input wire        mem_read_in,
    input wire [1:0]  result_src_in,

    input wire [31:0] alu_result_in,
    input wire [31:0] rs2_data_in,
    input wire [31:0] pc_plus4_in,
    input wire [31:0] immediate_in,
    input wire [4:0]  rd_in,
    input wire [2:0]  funct3_in,

    output reg        reg_write_out,
    output reg        mem_write_out,
    output reg        mem_read_out,
    output reg [1:0]  result_src_out,

    output reg [31:0] alu_result_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] pc_plus4_out,
    output reg [31:0] immediate_out,
    output reg [4:0]  rd_out,
    output reg [2:0]  funct3_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_write_out  <= 1'b0;
            mem_write_out  <= 1'b0;
            mem_read_out   <= 1'b0;
            result_src_out <= 2'b00;

            alu_result_out <= 32'b0;
            rs2_data_out   <= 32'b0;
            pc_plus4_out   <= 32'b0;
            immediate_out  <= 32'b0;
            rd_out         <= 5'b0;
            funct3_out     <= 3'b0;
        end else begin
            reg_write_out  <= reg_write_in;
            mem_write_out  <= mem_write_in;
            mem_read_out   <= mem_read_in;
            result_src_out <= result_src_in;

            alu_result_out <= alu_result_in;
            rs2_data_out   <= rs2_data_in;
            pc_plus4_out   <= pc_plus4_in;
            immediate_out  <= immediate_in;
            rd_out         <= rd_in;
            funct3_out     <= funct3_in;
        end
    end

endmodule
