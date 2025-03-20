`timescale 1ns/1ps
module alu_tb;

  // Entradas para la ALU
  reg [31:0] operand_a, operand_b;
  reg [3:0] alu_control;
  
  // Salidas de la ALU
  wire [31:0] result;
  wire zero_flag;
  
  // Instanciamos el módulo ALU
  ALU uut (
    .operand_a(operand_a),
    .operand_b(operand_b),
    .alu_control(alu_control),
    .result(result),
    .zero_flag(zero_flag)
  );
  
  initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);
    
    // Prueba 1: ADD 10 + 5 = 15
    operand_a = 10;
    operand_b = 5;
    alu_control = 4'b0011;  // ADD_OP
    #10;
    $display("ADD: %d + %d = %d, zero_flag=%b", operand_a, operand_b, result, zero_flag);
    
    // Prueba 2: SUB 10 - 5 = 5
    operand_a = 10;
    operand_b = 5;
    alu_control = 4'b0100;  // SUB_OP
    #10;
    $display("SUB: %d - %d = %d, zero_flag=%b", operand_a, operand_b, result, zero_flag);
    
    // Prueba 3: AND 10 & 5
    operand_a = 10;   // 32'h0000000A
    operand_b = 5;    // 32'h00000005; 10 (0b1010) & 5 (0b0101) = 0
    alu_control = 4'b0000;  // AND_OP
    #10;
    $display("AND: %d & %d = %d, zero_flag=%b", operand_a, operand_b, result, zero_flag);
    
    // Prueba 4: OR 10 | 5 => 15
    operand_a = 10;
    operand_b = 5;
    alu_control = 4'b0001;  // OR_OP
    #10;
    $display("OR: %d | %d = %d, zero_flag=%b", operand_a, operand_b, result, zero_flag);
    
    // Prueba 5: XOR 10 ^ 5 
    operand_a = 10;
    operand_b = 5;
    alu_control = 4'b0010;  // XOR_OP
    #10;
    $display("XOR: %d ^ %d = %d, zero_flag=%b", operand_a, operand_b, result, zero_flag);
    
    // Prueba 6: SLL: 10 << 2 = 40
    operand_a = 10;
    operand_b = 2;  // se usa operand_b[4:0]
    alu_control = 4'b0101;  // SLL_OP
    #10;
    $display("SLL: %d << 2 = %d, zero_flag=%b", operand_a, result, zero_flag);
    
    // Prueba 7: SRL: 16 >> 2 = 4
    operand_a = 16;
    operand_b = 2;
    alu_control = 4'b0110;  // SRL_OP
    #10;
    $display("SRL: %d >> 2 = %d, zero_flag=%b", operand_a, result, zero_flag);
    
    // Prueba 8: SRA: -16 >>> 2 = -4
    operand_a = -16;  // en complemento a 2, -16 = 0xFFFFFFF0
    operand_b = 2;
    alu_control = 4'b0111;  // SRA_OP
    #10;
    $display("SRA: %d >>> 2 = %d, zero_flag=%b", operand_a, result, zero_flag);
    
    // Prueba 9: SLT: if (3 < 5) -> 1, else 0
    operand_a = 3;
    operand_b = 5;
    alu_control = 4'b1000;  // SLT_OP
    #10;
    $display("SLT: (%d < %d) -> %d, zero_flag=%b", operand_a, operand_b, result, zero_flag);
    
    // Prueba 10: SLTU: unsigned, e.g. 5 < 10 -> 1
    operand_a = 5;
    operand_b = 10;
    alu_control = 4'b1001;  // SLTU_OP
    #10;
    $display("SLTU: (%d < %d unsigned) -> %d, zero_flag=%b", operand_a, operand_b, result, zero_flag);
    
    // Prueba 11: BEQ: if 5==5 then result=1
    operand_a = 5;
    operand_b = 5;
    alu_control = 4'b1010;  // BEQ_OP
    #10;
    $display("BEQ: (%d == %d) -> %d, zero_flag=%b", operand_a, operand_b, result, zero_flag);
    
    // Prueba 12: BNE: if 5 != 10 then result=1
    operand_a = 5;
    operand_b = 10;
    alu_control = 4'b1011;  // BNE_OP
    #10;
    $display("BNE: (%d != %d) -> %d, zero_flag=%b", operand_a, operand_b, result, zero_flag);
    
    $finish;
  end

endmodule
