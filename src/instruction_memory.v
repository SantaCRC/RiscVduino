module Instruction_Memory (
    input wire [31:0] address,
    output wire [31:0] instruction
);
    reg [31:0] mem [0:255]; // Memoria de 256 instrucciones (1 KB)

    initial begin
        $readmemh("program/program.mem", mem); // Cargar archivo .mem con instrucciones
    end

    assign instruction = mem[address[9:2]]; // Direccionado por palabras (4 bytes)
endmodule
