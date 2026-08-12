module forwarding_unit
(
    input wire [4:0] ex_rs1,
    input wire [4:0] ex_rs2,
    input wire [4:0] mem_rd,
    input wire [4:0] wb_rd,
    input wire       mem_reg_write,
    input wire       wb_reg_write,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);

    always @(*) begin
        forward_a = 2'b00;
        forward_b = 2'b00;

        if (mem_reg_write && (mem_rd != 5'b0) && (mem_rd == ex_rs1))
            forward_a = 2'b10;
        else if (wb_reg_write && (wb_rd != 5'b0) && (wb_rd == ex_rs1))
            forward_a = 2'b01;

        if (mem_reg_write && (mem_rd != 5'b0) && (mem_rd == ex_rs2))
            forward_b = 2'b10;
        else if (wb_reg_write && (wb_rd != 5'b0) && (wb_rd == ex_rs2))
            forward_b = 2'b01;
    end

endmodule
