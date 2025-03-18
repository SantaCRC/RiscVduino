module RegisterFile (
    input wire clk,
    input wire rst,                  // Reset global
    input wire we,                   // Señal de escritura
    input wire [4:0] rs1, rs2, rd,   // Direcciones de registros
    input wire [31:0] wd,            // Dato a escribir
    output reg [31:0] rd1, rd2        // Datos leídos
);

    reg [31:0] registers [0:31];  // Banco de registros (32 registros de 32 bits)

    // Inicializar todos los registros en 0 (útil para simulaciones)
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    // Escritura en el banco de registros
    always @(posedge clk) begin
        if (we && rd != 5'b00000)  // Evitar escritura en x0
            registers[rd] <= wd;
    end

    // Lectura combinacional con protección de x0
    always @(*) begin
        rd1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];  // Si rs1 == x0, forzar a 0
        rd2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];  // Si rs2 == x0, forzar a 0
    end

endmodule
