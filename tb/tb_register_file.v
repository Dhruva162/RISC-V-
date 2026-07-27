`timescale 1ns/1ps

module tb_register_file;

    reg         clk;
    reg         rst;
    reg         write_enable;
    reg  [4:0]  read_addr1;
    reg  [4:0]  read_addr2;
    reg  [4:0]  write_addr;
    reg  [31:0] write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    integer errors;

    register_file dut (
        .clk(clk),
        .rst(rst),
        .write_enable(write_enable),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    task expect;
        input [31:0] actual;
        input [31:0] expected;
        begin
            #1;
            if (actual !== expected) begin
                $display("FAIL actual=%h expected=%h", actual, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        write_enable = 0;
        read_addr1 = 0;
        read_addr2 = 0;
        write_addr = 0;
        write_data = 0;
        errors = 0;

        repeat (2) @(posedge clk);
        rst = 0;

        write_enable = 1;
        write_addr = 5'd5;
        write_data = 32'h1234_5678;
        @(posedge clk);
        #1;
        read_addr1 = 5'd5;
        expect(read_data1, 32'h1234_5678);

        write_addr = 5'd0;
        write_data = 32'hffff_ffff;
        @(posedge clk);
        #1;
        read_addr1 = 5'd0;
        expect(read_data1, 32'h0000_0000);

        write_enable = 0;
        write_addr = 5'd6;
        write_data = 32'hdead_beef;
        @(posedge clk);
        #1;
        read_addr2 = 5'd6;
        expect(read_data2, 32'h0000_0000);

        if (errors == 0)
            $display("tb_register_file PASS");
        else
            $display("tb_register_file FAIL errors=%0d", errors);
        $finish;
    end

endmodule
