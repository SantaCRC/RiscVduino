module control_unit(
    input [6:0] opcode,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg Jump,
    output reg [3:0] ALUOp
);

// Definición de los opcodes RV32I
localparam R_TYPE  = 7'b0110011;
localparam I_LOAD  = 7'b0000011;
localparam I_ALU   = 7'b0010011;
localparam S_TYPE  = 7'b0100011;
localparam B_TYPE  = 7'b1100011;
localparam JAL     = 7'b1101111;
localparam JALR    = 7'b1100111;
localparam LUI     = 7'b0110111;
localparam AUIPC   = 7'b0010111;

always @(*) begin
    // Valores predeterminados (evita latch)
    ALUSrc   = 1'b0;
    MemtoReg = 0;
    RegWrite = 0;
    MemRead  = 0;
    MemWrite = 0;
    Branch   = 0;
    Jump     = 0;
    ALUOp    = 2'b00;

    case(opcode)
        R_TYPE: begin // R-Type
            ALUSrc   = 0;
            RegWrite = 1;
            ALUOp    = 2'b10;
        end

        I_ALU: begin // I-Type inmediato (addi, andi, ori, etc.)
            ALUSrc   = 1;
            RegWrite = 1;
            ALUOp    = 2'b11;
        end

        I_LOAD: begin // Load (lw, lb, lh)
            ALUSrc   = 1;
            MemRead  = 1;
            MemtoReg = 1;
            RegWrite = 1;
            ALUOp    = 2'b00;
        end

        S_TYPE: begin // Store (sw, sb, sh)
            ALUSrc   = 1;
            MemWrite = 1;
            ALUOp    = 2'b00;
        end

        B_TYPE: begin // Branch (beq, bne, etc.)
            Branch = 1;
            ALUOp  = 2'b01;
        end

        JAL: begin // Jump and Link (JAL)
            Jump     = 1;
            RegWrite = 1;
            ALUOp    = 2'b00;
        end

        JALR: begin // Jump and Link Register (JALR)
            ALUSrc   = 1;
            Jump     = 1;
            RegWrite = 1;
            ALUOp    = 2'b00;
        end

        LUI: begin // Load Upper Immediate
            RegWrite = 1;
            ALUOp    = 2'b00;
        end

        AUIPC: begin // Add Upper Immediate to PC
            RegWrite = 1;
            ALUOp    = 2'b00;
        end

        default: begin // Instrucción no reconocida
            ALUSrc   = 0;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead  = 0;
            MemWrite = 0;
            Branch   = 0;
            Jump     = 0;
            ALUOp    = 2'b00;
        end
    endcase
end

endmodule
