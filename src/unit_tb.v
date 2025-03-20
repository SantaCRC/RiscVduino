`timescale 1ns/1ps
module alu_control_tb_combined;

  // Entradas para la Control Unit
  reg [6:0] opcode;
  reg [2:0] funct3;
  reg       funct7_bit;

  // Entradas para la ALU
  reg [31:0] operand_a, operand_b;
  
  // Salidas de la Control Unit
  wire ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;
  wire [3:0] ALUControl;
  
  // Salidas de la ALU
  wire [31:0] result;
  wire zero_flag;
  
  // Instanciamos la unidad de control "todo en uno"
  control_unit CU (
    .opcode(opcode),
    .funct3(funct3),
    .funct7_bit(funct7_bit),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .Jump(Jump),
    .ALUControl(ALUControl)
  );
  
  // Instanciamos la ALU
  ALU uut (
    .operand_a(operand_a),
    .operand_b(operand_b),
    .alu_control(ALUControl),
    .result(result),
    .zero_flag(zero_flag)
  );
  
  initial begin
    $dumpfile("alu_control_tb_combined.vcd");
    $dumpvars(0, alu_control_tb_combined);
    
    // ------------------------------
    // Prueba R-type ADD: add x?, x?, x?
    // Se espera que la ALU sume operand_a + operand_b.
    // Configuración: opcode = R_TYPE, funct3 = 000, funct7_bit = 0  => ADD
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7_bit = 1'b0;  // ADD
    operand_a = 32'd10;
    operand_b = 32'd5;
    #10;
    $display("R-type ADD: %d + %d = %d, ALUControl=%b", operand_a, operand_b, result, ALUControl);
    
    // ------------------------------
    // Prueba R-type SUB: sub x?, x?, x?
    // Se espera que la ALU realice la resta: 10 - 5 = 5.
    // Configuración: opcode = R_TYPE, funct3 = 000, funct7_bit = 1  => SUB
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7_bit = 1'b1;  // SUB
    operand_a = 32'd10;
    operand_b = 32'd5;
    #10;
    $display("R-type SUB: %d - %d = %d, ALUControl=%b", operand_a, operand_b, result, ALUControl);
    
    // ------------------------------
    // Prueba R-type AND: and x?, x?, x?
    // Se espera: 10 & 5 = 0 (10: 1010, 5: 0101)
    opcode = 7'b0110011;
    funct3 = 3'b111;
    funct7_bit = 1'b0;  // No afecta en AND
    operand_a = 32'd10;
    operand_b = 32'd5;
    #10;
    $display("R-type AND: %d & %d = %d, ALUControl=%b", operand_a, operand_b, result, ALUControl);
    
    // ------------------------------
    // Prueba I-type ADDI: addi x?, x?, imm
    // Se espera: 7 + 8 = 15 (para addi, la ALU realiza suma)
    opcode = 7'b0010011;  // I_ALU
    funct3 = 3'b000;      // addi
    funct7_bit = 1'b0;    // No usado en addi
    operand_a = 32'd7;
    operand_b = 32'd8;    // En I-type, operand_b es el inmediato
    #10;
    $display("I-type ADDI: %d + %d = %d, ALUControl=%b", operand_a, operand_b, result, ALUControl);
    
    // ------------------------------
    // Prueba I-type Logical: andi (por ejemplo)
    opcode = 7'b0010011;  // I_ALU
    funct3 = 3'b111;      // andi
    funct7_bit = 1'b0;    // No influye
    operand_a = 32'd12;   // 12: 1100
    operand_b = 32'd5;    // 5: 0101, 12 & 5 = 4 (0100)
    #10;
    $display("I-type ANDI: %d & %d = %d, ALUControl=%b", operand_a, operand_b, result, ALUControl);
    
    $finish;
  end

endmodule
