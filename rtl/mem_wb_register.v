module mem_wb_register
(
    input wire clk,
    input wire rst,

    input wire        reg_write_in,
    input wire [1:0]  result_src_in,

    input wire [31:0] alu_result_in,
    input wire [31:0] read_data_in,
    input wire [31:0] pc_plus4_in,
    input wire [31:0] immediate_in,
    input wire [4:0]  rd_in,

    output reg        reg_write_out,
    output reg [1:0]  result_src_out,

    output reg [31:0] alu_result_out,
    output reg [31:0] read_data_out,
    output reg [31:0] pc_plus4_out,
    output reg [31:0] immediate_out,
    output reg [4:0]  rd_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_write_out  <= 1'b0;
            result_src_out <= 2'b00;

            alu_result_out <= 32'b0;
            read_data_out  <= 32'b0;
            pc_plus4_out   <= 32'b0;
            immediate_out  <= 32'b0;
            rd_out         <= 5'b0;
        end else begin
            reg_write_out  <= reg_write_in;
            result_src_out <= result_src_in;

            alu_result_out <= alu_result_in;
            read_data_out  <= read_data_in;
            pc_plus4_out   <= pc_plus4_in;
            immediate_out  <= immediate_in;
            rd_out         <= rd_in;
        end
    end

endmodule
