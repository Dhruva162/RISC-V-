module register_file
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5
)
(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  write_enable,
    input  wire [ADDR_WIDTH-1:0] read_addr1,
    input  wire [ADDR_WIDTH-1:0] read_addr2,
    input  wire [ADDR_WIDTH-1:0] write_addr,
    input  wire [DATA_WIDTH-1:0] write_data,
    output wire [DATA_WIDTH-1:0] read_data1,
    output wire [DATA_WIDTH-1:0] read_data2
);

    reg [DATA_WIDTH-1:0] registers [0:31];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= {DATA_WIDTH{1'b0}};
        end else begin
            if (write_enable && (write_addr != 5'd0))
                registers[write_addr] <= write_data;
            registers[0] <= {DATA_WIDTH{1'b0}};
        end
    end

    assign read_data1 = (read_addr1 == 5'd0) ? {DATA_WIDTH{1'b0}} : registers[read_addr1];
    assign read_data2 = (read_addr2 == 5'd0) ? {DATA_WIDTH{1'b0}} : registers[read_addr2];

endmodule
