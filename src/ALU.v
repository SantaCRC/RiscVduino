module ALU(
    input wire [31:0] operand_a,  // First operand
    input wire [31:0] operand_b,  // Second operand or immediate value
    input wire [3:0] alu_control,  // Control signal selecting the operation
    output reg [31:0] result,  // Result of the operation
    output reg zero_flag       // Indicates if the result is zero
);

// ALU operation codes for RISC-V 32I
localparam AND_OP  = 4'b0000;  // AND operation
localparam OR_OP   = 4'b0001;  // OR operation
localparam XOR_OP  = 4'b0010;  // XOR operation
localparam ADD_OP  = 4'b0011;  // Addition (ADD, ADDI)
localparam SUB_OP  = 4'b0100;  // Subtraction (SUB)
localparam SLL_OP  = 4'b0101;  // Logical Left Shift (SLL, SLLI)
localparam SRL_OP  = 4'b0110;  // Logical Right Shift (SRL, SRLI)
localparam SRA_OP  = 4'b0111;  // Arithmetic Right Shift (SRA, SRAI)
localparam SLT_OP  = 4'b1000;  // Set Less Than (SLT, SLTI)
localparam SLTU_OP = 4'b1001;  // Set Less Than Unsigned (SLTU, SLTIU)
localparam BEQ_OP  = 4'b1010;  // Branch if Equal (BEQ)
localparam BNE_OP  = 4'b1011;  // Branch if Not Equal (BNE)

always @(*) begin
    case (alu_control)
        AND_OP:   result = operand_a & operand_b;  // AND operation
        OR_OP:    result = operand_a | operand_b;  // OR operation
        XOR_OP:   result = operand_a ^ operand_b;  // XOR operation
        ADD_OP:   result = operand_a + operand_b;  // Addition (ADD, ADDI)
        SUB_OP:   result = operand_a - operand_b;  // Subtraction (SUB)
        SLL_OP:   result = operand_a << operand_b[4:0];  // Logical Left Shift (SLL, SLLI)
        SRL_OP:   result = operand_a >> operand_b[4:0];  // Logical Right Shift (SRL, SRLI)
        SRA_OP:   result = $signed(operand_a) >>> operand_b[4:0];  // Arithmetic Right Shift (SRA, SRAI)
        SLT_OP:   result = ($signed(operand_a) < $signed(operand_b)) ? 32'b1 : 32'b0; // Set Less Than (SLT, SLTI)
        SLTU_OP:  result = (operand_a < operand_b) ? 32'b1 : 32'b0; // Set Less Than Unsigned (SLTU, SLTIU)

        // Comparison operations for conditional branches
        BEQ_OP:   result = (operand_a == operand_b) ? 32'b1 : 32'b0; // Branch if Equal (BEQ)
        BNE_OP:   result = (operand_a != operand_b) ? 32'b1 : 32'b0; // Branch if Not Equal (BNE)

        default:  result = 32'b0;  // Default case for undefined operations
    endcase

    zero_flag = (result == 32'b0); // Activate 'zero_flag' if the result is zero
end

endmodule