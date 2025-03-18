module riscv_top(
    input wire clk,
    input wire reset
);

// Señales internas
wire [31:0] pc, pc_next;
wire [31:0] instruction;
wire [31:0] read_data1, read_data2, write_data_rf;
wire [31:0] alu_result, operand2;
wire [31:0] read_data_dm;
wire zero_flag;

// Señales de control
wire RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, Jump;
wire [3:0] ALUOp;

// Program Counter
program_counter PC(
    .clk(clk),
    .reset(reset),
    .pc_next(pc_next),
    .pc(pc)
);

// Instruction Memory
instruction_memory IMEM(
    .addr(pc),
    .instruction(instruction)
);

// Control Unit
control_unit CU(
    .opcode(instruction[6:0]),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .Jump(Jump),
    .ALUOp(ALUOp)
);

// Register File
RegisterFile REGFILE(
    .clk(clk),
    .rst(reset),                 // Reset global conectado al reset del sistema
    .we(RegWrite),               // Señal de escritura desde la unidad de control
    .rs1(instruction[19:15]),    // Dirección del primer registro fuente
    .rs2(instruction[24:20]),    // Dirección del segundo registro fuente
    .rd(instruction[11:7]),      // Dirección del registro destino
    .wd(write_data_rf),          // Dato que se escribirá en el registro destino
    .rd1(read_data1),            // Primer dato leído
    .rd2(read_data2)             // Segundo dato leído
);


// ALU Operand Selector
assign operand2 = (ALUSrc) ? {{20{instruction[31]}}, instruction[31:20]} : read_data2;

// ALU
ALU ALU(
    .operand_a(read_data1),             // Primer operando desde registro
    .operand_b(operand2),               // Segundo operando (registro o inmediato)
    .alu_control(ALUOp),        // Señal de control adaptada (ajustar según diseño)
    .result(alu_result),                // Resultado de la operación ALU
    .zero_flag(zero_flag)               // Bandera de resultado cero
);


// Data Memory
data_memory DMEM(
    .clk(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .addr(alu_result),
    .write_data(read_data2),
    .read_data(read_data_dm)
);

// Writeback selector
assign write_data_rf = (MemtoReg) ? read_data_dm : alu_result;

// Next PC Logic (simple increment by 4 for now)
assign pc_next = pc + 32'd4;

endmodule