module program_counter
#(
    parameter WIDTH = 32
)
(
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 enable,
    input  wire [WIDTH-1:0]     pc_next,
    output reg  [WIDTH-1:0]     pc
);

    always @(posedge clk) begin
        if (rst)
            pc <= {WIDTH{1'b0}};
        else if (enable)
            pc <= pc_next;
    end

endmodule
