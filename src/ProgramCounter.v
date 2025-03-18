module program_counter(
    input wire clk,              // Señal de reloj
    input wire reset,            // Reset activo alto
    input wire [31:0] pc_next,   // Siguiente valor del PC (para saltos)
    output reg [31:0] pc         // Valor actual del PC
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc <= 32'b0;             // Al resetear, PC se reinicia a 0
    end else begin
        pc <= pc_next;           // Actualiza el PC con el siguiente valor
    end
end

endmodule
