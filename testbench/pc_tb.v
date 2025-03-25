`timescale 1ns/1ps

module test_pc;
    // Señales de prueba
    reg clk, reset;
    reg pc_write;
    reg [31:0] pc_next;
    wire [31:0] pc;

    // Instancia del módulo PC con pc_write
    Program_Counter uut (
        .clk(clk),
        .reset(reset),
        .pc_write(pc_write),
        .pc_next(pc_next),
        .pc(pc)
    );

    // Generación del reloj
    always #5 clk = ~clk; // Período de 10ns

    initial begin
        $dumpfile("test_pc.vcd");
        $dumpvars(0, test_pc);

        // Inicialización
        clk = 0;
        reset = 1;
        pc_write = 1;
        pc_next = 32'h00000004;
        #10 reset = 0; // Quitamos el reset

        // 🚶 Avance normal
        #10 pc_next = pc + 4; // PC = 8
        #10 pc_next = pc + 4; // PC = 12

        // ⏸️ Simulamos un stall
        #10 pc_write = 0; pc_next = pc + 4; // Debe quedarse en 12
        #10 pc_write = 1; // Se reactiva

        // 🚀 Salto manual
        #10 pc_next = 32'h00000020; // PC = 32
        #10 pc_next = pc + 4; // PC = 36

        #50;
        $finish;
    end
endmodule
