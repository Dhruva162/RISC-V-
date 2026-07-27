module main_decoder
(
    input  wire [6:0] opcode,
    output reg        reg_write,
    output reg        mem_write,
    output reg        mem_read,
    output reg        branch,
    output reg        jump,
    output reg        jalr,
    output reg        alu_src,
    output reg  [1:0] result_src,
    output reg  [1:0] alu_op
);

    always @(*) begin
        reg_write  = 1'b0;
        mem_write  = 1'b0;
        mem_read   = 1'b0;
        branch     = 1'b0;
        jump       = 1'b0;
        jalr       = 1'b0;
        alu_src    = 1'b0;
        result_src = 2'b00;
        alu_op     = 2'b00;

        case (opcode)
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                alu_op    = 2'b10;
            end
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b10;
            end
            7'b0000011: begin
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                alu_src    = 1'b1;
                result_src = 2'b01;
                alu_op     = 2'b00;
            end
            7'b0100011: begin
                mem_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b00;
            end
            7'b1100011: begin
                branch  = 1'b1;
                alu_src = 1'b0;
                alu_op  = 2'b01;
            end
            7'b0110111: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                result_src = 2'b11;
                alu_op     = 2'b11;
            end
            7'b0010111: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                result_src = 2'b10;
                alu_op     = 2'b00;
            end
            7'b1101111: begin
                reg_write  = 1'b1;
                jump       = 1'b1;
                result_src = 2'b10;
            end
            7'b1100111: begin
                reg_write  = 1'b1;
                jump       = 1'b1;
                jalr       = 1'b1;
                alu_src    = 1'b1;
                result_src = 2'b10;
                alu_op     = 2'b00;
            end
            default: begin
                reg_write  = 1'b0;
                mem_write  = 1'b0;
                mem_read   = 1'b0;
                branch     = 1'b0;
                jump       = 1'b0;
                jalr       = 1'b0;
                alu_src    = 1'b0;
                result_src = 2'b00;
                alu_op     = 2'b00;
            end
        endcase
    end

endmodule
