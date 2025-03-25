`timescale 1ns/1ps

module test_if;
    reg clk, reset;
    reg pc_write;
    reg [31:0] pc_next;
    wire [31:0] pc;
    wire [31:0] instruction;

    // Instancia del Program Counter con pc_write
    Program_Counter PC (
        .clk(clk),
        .reset(reset),
        .pc_write(pc_write),
        .pc_next(pc_next),
        .pc(pc)
    );

    // Instancia de la memoria de instrucciones
    Instruction_Memory IMEM (
        .address(pc),
        .instruction(instruction)
    );

    // Generación de reloj
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tests/test_if.vcd");
        $dumpvars(0, test_if);

        clk = 0;
        reset = 1;
        pc_write = 1;
        pc_next = 0;

        #10 reset = 0;

        // 🔁 Avanza normalmente
        #10 pc_next = pc + 4;  // PC = 4
        #10 pc_next = pc + 4;  // PC = 8

        // ⏸️ Simulamos un stall: pc_write = 0
        #10 pc_write = 0; pc_next = pc + 4;  // PC se mantiene en 8
        #10 pc_write = 0; pc_next = pc + 4;  // Aún se mantiene

        // ▶️ Quitamos el stall: pc avanza de nuevo
        #10 pc_write = 1; pc_next = pc + 4;  // PC = 12
        #10 pc_next = pc + 4;               // PC = 16

        #20 $finish;
    end
endmodule
