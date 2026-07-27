module alu
#(
    parameter WIDTH = 32
)
(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [3:0]       alu_control,
    output reg  [WIDTH-1:0] result,
    output wire             zero
);

    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_SLL  = 4'b0010;
    localparam ALU_SLT  = 4'b0011;
    localparam ALU_SLTU = 4'b0100;
    localparam ALU_XOR  = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SRA  = 4'b0111;
    localparam ALU_OR   = 4'b1000;
    localparam ALU_AND  = 4'b1001;
    localparam ALU_COPY_B = 4'b1010;

    always @(*) begin
        case (alu_control)
            ALU_ADD:    result = a + b;
            ALU_SUB:    result = a - b;
            ALU_SLL:    result = a << b[4:0];
            ALU_SLT:    result = ($signed(a) < $signed(b)) ? {{(WIDTH-1){1'b0}}, 1'b1} : {WIDTH{1'b0}};
            ALU_SLTU:   result = (a < b) ? {{(WIDTH-1){1'b0}}, 1'b1} : {WIDTH{1'b0}};
            ALU_XOR:    result = a ^ b;
            ALU_SRL:    result = a >> b[4:0];
            ALU_SRA:    result = $signed(a) >>> b[4:0];
            ALU_OR:     result = a | b;
            ALU_AND:    result = a & b;
            ALU_COPY_B: result = b;
            default:    result = {WIDTH{1'b0}};
        endcase
    end

    assign zero = (result == {WIDTH{1'b0}});

endmodule
