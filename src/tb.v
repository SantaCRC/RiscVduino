`timescale 1ns/1ps

module riscv_tb();

// Señales del testbench
reg clk;
reg reset;

// Genera reloj de 100MHz
initial clk = 0;
always #5 clk = ~clk;  // Periodo 10ns (100MHz)

// Inicialización del reset
initial begin
    reset = 1;
    #20;               // Reset activo por 20ns
    reset = 0;
end

// Instancia módulo riscv_top
riscv_top UUT(
    .clk(clk),
    .reset(reset)
);

// Finaliza simulación tras cierto tiempo
initial begin
    #500;              // Simula por 500ns (ajusta según necesidad)
    $finish;
end

// Genera archivo VCD para GTKWave
initial begin
    $dumpfile("riscv_wave.vcd");
    $dumpvars(0, riscv_tb);
end

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        $dumpvars(0, riscv_tb.UUT.REGFILE.registers[i]);
    end
end


endmodule