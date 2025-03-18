module instruction_memory(
    input wire [31:0] addr,         // Dirección del PC
    output wire [31:0] instruction  // Instrucción leída
);

// Memoria interna de 256 instrucciones de 32 bits (ajusta según necesidades)
reg [31:0] memory [0:255];

// Inicialización de memoria desde archivo externo
initial begin
    $readmemh("program.mem", memory);
end

// Salida: la instrucción correspondiente a la dirección actual
assign instruction = memory[addr[9:2]]; // Se ignoran los 2 bits menos significativos

endmodule
