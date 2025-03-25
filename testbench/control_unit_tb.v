`timescale 1ns/1ps

module test_control_unit;

    // Entradas
    reg [6:0] opcode;
    reg stall;

    // Salidas
    wire regWrite, memRead, memWrite, branch, jump, aluSrc, wbSrc;
    wire [1:0] aluOp;

    // Instancia de la Unidad de Control
    Control_Unit dut (
        .opcode(opcode),
        .stall(stall),
        .regWrite(regWrite),
        .memRead(memRead),
        .memWrite(memWrite),
        .branch(branch),
        .jump(jump),
        .aluSrc(aluSrc),
        .wbSrc(wbSrc),
        .aluOp(aluOp)
    );

    initial begin
        $dumpfile("tests/test_control_unit.vcd");
        $dumpvars(0, test_control_unit);

        // 🧹 Inicializamos
        opcode = 7'b0000000;
        stall = 0;

        // 🚀 Probar R-type: ADD
        #10 opcode = 7'b0110011; // R-type
        #10 opcode = 7'b0010011; // I-type: ADDI
        #10 opcode = 7'b0000011; // LW
        #10 opcode = 7'b0100011; // SW
        #10 opcode = 7'b1100011; // BEQ
        #10 opcode = 7'b1101111; // JAL

        // ⏸️ Activamos stall: todo debe ir a 0
        #10 stall = 1;
            opcode = 7'b0000011; // LW (pero con stall activo)

        // ✅ Quitamos stall: señales deben volver a ser válidas
        #10 stall = 0;

        // 🧪 Código no reconocido
        #10 opcode = 7'b1111111;

        #20 $finish;
    end

endmodule
