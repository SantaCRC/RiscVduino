`timescale 1ns/1ps

module test_if_id_register;

    // Entradas
    reg clk, reset, stall, flush;
    reg [31:0] pc_in, pc_plus4_in, instruction_in;

    // Salidas
    wire [31:0] pc_out, pc_plus4_out, instruction_out;

    // Instancia del módulo
    IF_ID_Register dut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .pc_in(pc_in),
        .pc_plus4_in(pc_plus4_in),
        .instruction_in(instruction_in),
        .pc_out(pc_out),
        .pc_plus4_out(pc_plus4_out),
        .instruction_out(instruction_out)
    );

    // Reloj
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tests/test_if_id_register.vcd");
        $dumpvars(0, test_if_id_register);

        clk = 0;
        reset = 1;
        stall = 0;
        flush = 0;
        pc_in = 0;
        pc_plus4_in = 4;
        instruction_in = 32'h00000013; // NOP

        // Esperamos un ciclo con reset
        #10 reset = 0;

        // 🚀 Ciclo normal: se actualiza el contenido
        #10 pc_in = 32'h00000004;
            pc_plus4_in = 32'h00000008;
            instruction_in = 32'h00100093; // ADDI x1, x0, 1

        // ⏸️ Ciclo con stall: no cambia nada
        #10 stall = 1;
            pc_in = 32'h00000008;
            pc_plus4_in = 32'h0000000C;
            instruction_in = 32'h00200113; // ADDI x2, x0, 2

        // ▶️ Quitamos stall: vuelve a actualizar
        #10 stall = 0;

        // 🧼 Ciclo con flush: se borra todo
        #10 flush = 1;
            pc_in = 32'h0000000C;
            pc_plus4_in = 32'h00000010;
            instruction_in = 32'h003081B3; // ADD x3, x1, x3

        // ✅ Volvemos a estado normal
        #10 flush = 0;
            pc_in = 32'h00000010;
            pc_plus4_in = 32'h00000014;
            instruction_in = 32'h00408233; // ADD x4, x1, x4

        #20 $finish;
    end
endmodule
