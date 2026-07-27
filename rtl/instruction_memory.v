module instruction_memory
#(
    parameter ADDR_WIDTH = 10,
    parameter INIT_FILE = ""
)
(
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    localparam DEPTH = (1 << ADDR_WIDTH);

    reg [31:0] memory [0:DEPTH-1];
    integer i;

    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            memory[i] = 32'h00000013;
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, memory);
    end

    assign instruction = memory[address[ADDR_WIDTH+1:2]];

endmodule
