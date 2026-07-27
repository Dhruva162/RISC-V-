`timescale 1ns/1ps

module tb_memory;

    reg         clk;
    reg         rst;
    reg         mem_write;
    reg         mem_read;
    reg  [2:0]  funct3;
    reg  [31:0] address;
    reg  [31:0] write_data;
    wire [31:0] read_data;

    integer errors;

    data_memory #(.ADDR_WIDTH(8)) dut (
        .clk(clk),
        .rst(rst),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .funct3(funct3),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    task store;
        input [2:0] size;
        input [31:0] addr;
        input [31:0] data;
        begin
            funct3 = size;
            address = addr;
            write_data = data;
            mem_write = 1;
            mem_read = 0;
            @(posedge clk);
            #1;
            mem_write = 0;
        end
    endtask

    task load_check;
        input [2:0] size;
        input [31:0] addr;
        input [31:0] expected;
        begin
            funct3 = size;
            address = addr;
            mem_read = 1;
            #1;
            if (read_data !== expected) begin
                $display("FAIL load funct3=%b addr=%h data=%h expected=%h", size, addr, read_data, expected);
                errors = errors + 1;
            end
            mem_read = 0;
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        mem_write = 0;
        mem_read = 0;
        funct3 = 0;
        address = 0;
        write_data = 0;
        errors = 0;

        repeat (2) @(posedge clk);
        rst = 0;

        store(3'b010, 32'd4, 32'h80ff_7f01);
        load_check(3'b010, 32'd4, 32'h80ff_7f01);
        load_check(3'b000, 32'd4, 32'h0000_0001);
        load_check(3'b000, 32'd7, 32'hffff_ff80);
        load_check(3'b100, 32'd7, 32'h0000_0080);
        load_check(3'b001, 32'd6, 32'hffff_80ff);
        load_check(3'b101, 32'd6, 32'h0000_80ff);

        store(3'b000, 32'd16, 32'h0000_00aa);
        load_check(3'b100, 32'd16, 32'h0000_00aa);

        store(3'b001, 32'd20, 32'h0000_8123);
        load_check(3'b001, 32'd20, 32'hffff_8123);

        if (errors == 0)
            $display("tb_memory PASS");
        else
            $display("tb_memory FAIL errors=%0d", errors);
        $finish;
    end

endmodule
