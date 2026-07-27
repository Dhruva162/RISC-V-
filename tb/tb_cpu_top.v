`timescale 1ns/1ps

module tb_cpu_top;

    reg clk;
    reg rst;
    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] alu_result;

    integer errors;

    cpu_top #(
        .IMEM_ADDR_WIDTH(8),
        .DMEM_ADDR_WIDTH(8),
        .IMEM_INIT_FILE("")
    ) dut (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instruction(instruction),
        .alu_result(alu_result)
    );

    always #5 clk = ~clk;

    function [31:0] i_type;
        input [11:0] imm;
        input [4:0] rs1;
        input [2:0] funct3;
        input [4:0] rd;
        input [6:0] opcode;
        begin
            i_type = {imm, rs1, funct3, rd, opcode};
        end
    endfunction

    function [31:0] r_type;
        input [6:0] funct7;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;
        input [4:0] rd;
        input [6:0] opcode;
        begin
            r_type = {funct7, rs2, rs1, funct3, rd, opcode};
        end
    endfunction

    function [31:0] s_type;
        input [11:0] imm;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;
        input [6:0] opcode;
        begin
            s_type = {imm[11:5], rs2, rs1, funct3, imm[4:0], opcode};
        end
    endfunction

    function [31:0] b_type;
        input [12:0] imm;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;
        input [6:0] opcode;
        begin
            b_type = {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], opcode};
        end
    endfunction

    function [31:0] u_type;
        input [19:0] imm;
        input [4:0] rd;
        input [6:0] opcode;
        begin
            u_type = {imm, rd, opcode};
        end
    endfunction

    function [31:0] j_type;
        input [20:0] imm;
        input [4:0] rd;
        input [6:0] opcode;
        begin
            j_type = {imm[20], imm[10:1], imm[11], imm[19:12], rd, opcode};
        end
    endfunction

    task check_reg;
        input [4:0] regnum;
        input [31:0] expected;
        begin
            if (dut.register_file_inst.registers[regnum] !== expected) begin
                $display("FAIL x%0d=%h expected=%h", regnum, dut.register_file_inst.registers[regnum], expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        errors = 0;

        dut.instruction_memory_inst.memory[0]  = i_type(12'd5, 5'd0, 3'b000, 5'd1, 7'b0010011);
        dut.instruction_memory_inst.memory[1]  = i_type(12'd7, 5'd0, 3'b000, 5'd2, 7'b0010011);
        dut.instruction_memory_inst.memory[2]  = r_type(7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011);
        dut.instruction_memory_inst.memory[3]  = s_type(12'd0, 5'd3, 5'd0, 3'b010, 7'b0100011);
        dut.instruction_memory_inst.memory[4]  = i_type(12'd0, 5'd0, 3'b010, 5'd4, 7'b0000011);
        dut.instruction_memory_inst.memory[5]  = b_type(13'd8, 5'd4, 5'd3, 3'b000, 7'b1100011);
        dut.instruction_memory_inst.memory[6]  = i_type(12'd1, 5'd0, 3'b000, 5'd5, 7'b0010011);
        dut.instruction_memory_inst.memory[7]  = u_type(20'h12345, 5'd6, 7'b0110111);
        dut.instruction_memory_inst.memory[8]  = j_type(21'd8, 5'd7, 7'b1101111);
        dut.instruction_memory_inst.memory[9]  = i_type(12'd2, 5'd0, 3'b000, 5'd8, 7'b0010011);
        dut.instruction_memory_inst.memory[10] = i_type(12'd3, 5'd0, 3'b000, 5'd9, 7'b0010011);

        repeat (2) @(posedge clk);
        rst = 0;
        repeat (12) @(posedge clk);
        #1;

        check_reg(5'd1, 32'd5);
        check_reg(5'd2, 32'd7);
        check_reg(5'd3, 32'd12);
        check_reg(5'd4, 32'd12);
        check_reg(5'd5, 32'd0);
        check_reg(5'd6, 32'h1234_5000);
        check_reg(5'd7, 32'd36);
        check_reg(5'd8, 32'd0);
        check_reg(5'd9, 32'd3);

        if (errors == 0)
            $display("tb_cpu_top PASS");
        else
            $display("tb_cpu_top FAIL errors=%0d", errors);
        $finish;
    end

endmodule
