module Program_Counter (
    input wire clk,
    input wire reset,
    input wire pc_write,            // ← Controla si el PC puede avanzar
    input wire [31:0] pc_next,      // ← Dirección siguiente (PC + 4, branch, jump, etc.)
    output reg [31:0] pc            // → Dirección actual
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'h00000000;     // Reinicio del programa
        else if (pc_write)
            pc <= pc_next;          // Avanza si está permitido
        // Si pc_write == 0 → Stall: mantiene su valor actual
    end

endmodule
