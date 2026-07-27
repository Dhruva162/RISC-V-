`timescale 1ns/1ps

module tb_alu;

    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0]  alu_control;
    wire [31:0] result;
    wire        zero;

    integer errors;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    task check;
        input [3:0] control;
        input [31:0] in_a;
        input [31:0] in_b;
        input [31:0] expected;
        begin
            alu_control = control;
            a = in_a;
            b = in_b;
            #1;
            if (result !== expected) begin
                $display("FAIL control=%0d a=%h b=%h result=%h expected=%h", control, in_a, in_b, result, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        check(4'b0000, 32'd10, 32'd5, 32'd15);
        check(4'b0001, 32'd10, 32'd5, 32'd5);
        check(4'b0010, 32'h0000_0001, 32'd4, 32'h0000_0010);
        check(4'b0011, 32'hffff_ffff, 32'd1, 32'd1);
        check(4'b0100, 32'hffff_ffff, 32'd1, 32'd0);
        check(4'b0101, 32'ha5a5_0000, 32'h00ff_00ff, 32'ha55a_00ff);
        check(4'b0110, 32'h8000_0000, 32'd4, 32'h0800_0000);
        check(4'b0111, 32'h8000_0000, 32'd4, 32'hf800_0000);
        check(4'b1000, 32'hf000_0000, 32'h0000_000f, 32'hf000_000f);
        check(4'b1001, 32'hffff_0000, 32'h00ff_00ff, 32'h00ff_0000);
        check(4'b1010, 32'h1111_1111, 32'h2222_2222, 32'h2222_2222);

        if (errors == 0)
            $display("tb_alu PASS");
        else
            $display("tb_alu FAIL errors=%0d", errors);
        $finish;
    end

endmodule
