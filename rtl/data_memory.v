module data_memory
#(
    parameter ADDR_WIDTH = 12
)
(
    input  wire        clk,
    input  wire        rst,
    input  wire        mem_write,
    input  wire        mem_read,
    input  wire [2:0]  funct3,
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

    localparam DEPTH = (1 << ADDR_WIDTH);

    reg [7:0] memory [0:DEPTH-1];
    integer i;

    wire [ADDR_WIDTH-1:0] byte_addr;
    wire [7:0] byte0;
    wire [7:0] byte1;
    wire [7:0] byte2;
    wire [7:0] byte3;
    wire [15:0] halfword;
    wire [31:0] word;

    assign byte_addr = address[ADDR_WIDTH-1:0];
    assign byte0 = memory[byte_addr];
    assign byte1 = memory[byte_addr + {{(ADDR_WIDTH-1){1'b0}}, 1'b1}];
    assign byte2 = memory[byte_addr + {{(ADDR_WIDTH-2){1'b0}}, 2'd2}];
    assign byte3 = memory[byte_addr + {{(ADDR_WIDTH-2){1'b0}}, 2'd3}];
    assign halfword = {byte1, byte0};
    assign word = {byte3, byte2, byte1, byte0};

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < DEPTH; i = i + 1)
                memory[i] <= 8'b0;
        end else if (mem_write) begin
            case (funct3)
                3'b000:
                    memory[byte_addr] <= write_data[7:0];
                3'b001: begin
                    memory[byte_addr] <= write_data[7:0];
                    memory[byte_addr + {{(ADDR_WIDTH-1){1'b0}}, 1'b1}] <= write_data[15:8];
                end
                3'b010: begin
                    memory[byte_addr] <= write_data[7:0];
                    memory[byte_addr + {{(ADDR_WIDTH-1){1'b0}}, 1'b1}] <= write_data[15:8];
                    memory[byte_addr + {{(ADDR_WIDTH-2){1'b0}}, 2'd2}] <= write_data[23:16];
                    memory[byte_addr + {{(ADDR_WIDTH-2){1'b0}}, 2'd3}] <= write_data[31:24];
                end
                default:
                    memory[byte_addr] <= memory[byte_addr];
            endcase
        end
    end

    always @(*) begin
        if (mem_read) begin
            case (funct3)
                3'b000: read_data = {{24{byte0[7]}}, byte0};
                3'b001: read_data = {{16{halfword[15]}}, halfword};
                3'b010: read_data = word;
                3'b100: read_data = {24'b0, byte0};
                3'b101: read_data = {16'b0, halfword};
                default: read_data = 32'b0;
            endcase
        end else begin
            read_data = 32'b0;
        end
    end

endmodule
