module if_id_register
(
    input wire clk,
    input wire rst,

    input wire [31:0] instruction_in,
    input wire [31:0] pc_in,
    input wire [31:0] pc_plus4_in,

    output reg [31:0] instruction_out,
    output reg [31:0] pc_out,
    output reg [31:0] pc_plus4_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_out <= 32'b0;
            pc_out <= 32'b0;
            pc_plus4_out <= 32'b0;
        end else begin
            instruction_out <= instruction_in;
            pc_out <= pc_in;
            pc_plus4_out <= pc_plus4_in;
        end
    end

    
endmodule