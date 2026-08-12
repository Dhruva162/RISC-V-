module hazard_unit
(
    input wire       ex_mem_read,
    input wire [4:0] ex_rd,
    input wire [4:0] id_rs1,
    input wire [4:0] id_rs2,

    output reg       pc_write,
    output reg       if_id_write,
    output reg       id_ex_flush
);

    always @(*) begin
        pc_write = 1'b1;
        if_id_write = 1'b1;
        id_ex_flush = 1'b0;

        if (ex_mem_read && (ex_rd != 5'b0) &&
            ((ex_rd == id_rs1) || (ex_rd == id_rs2))) begin
            pc_write = 1'b0;
            if_id_write = 1'b0;
            id_ex_flush = 1'b1;
        end
    end

endmodule
