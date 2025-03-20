module RegisterFile (
    input wire clk,
    input wire rst,                  // Reset global
    input wire we,                   // Señal de escritura
    input wire [4:0] rs1, rs2, rd,     // Direcciones de registros
    input wire [31:0] wd,            // Dato a escribir
    output reg [31:0] rd1, rd2        // Datos leídos
);

    reg [31:0] registers [0:31];  // Banco de registros (32 registros de 32 bits)
    integer i;
    
    // Inicializar todos los registros a 0
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    // Escritura en el banco de registros
    // x0 se protege: si rd es 0, no se escribe
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (we && (rd != 5'b00000)) begin
            registers[rd] <= wd;
        end
    end

    // Lectura combinacional con bypass, protegiendo x0:
    always @(*) begin
        // Si se está leyendo x0, siempre retorna 0.
        if (rs1 == 5'b00000)
            rd1 = 32'b0;
        else if ((rs1 == rd) && we && (rd != 5'b00000))
            rd1 = wd; // Bypass: si se escribe en el mismo ciclo, usar el valor nuevo.
        else
            rd1 = registers[rs1];

        if (rs2 == 5'b00000)
            rd2 = 32'b0;
        else if ((rs2 == rd) && we && (rd != 5'b00000))
            rd2 = wd;
        else
            rd2 = registers[rs2];
    end

endmodule
