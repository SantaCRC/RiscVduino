module control_unit(
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,      // Extraído de la instrucción (bits [14:12])
    input  wire       funct7_bit,  // Bit 30 de funct7 (0 para ADD, 1 para SUB en R-type)
    output reg        ALUSrc,
    output reg        MemtoReg,
    output reg        RegWrite,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        Branch,
    output reg        Jump,
    output reg [3:0]  ALUControl  // Señal de control final para la ALU
);

    // Definiciones de opcodes para RV32I
    localparam R_TYPE  = 7'b0110011;
    localparam I_LOAD  = 7'b0000011;
    localparam I_ALU   = 7'b0010011;
    localparam S_TYPE  = 7'b0100011;
    localparam B_TYPE  = 7'b1100011;
    localparam JAL     = 7'b1101111;
    localparam JALR    = 7'b1100111;
    localparam LUI     = 7'b0110111;
    localparam AUIPC   = 7'b0010111;

    // Definiciones para la ALU (4 bits)
    localparam ADD_OP  = 4'b0011;
    localparam SUB_OP  = 4'b0100;
    localparam AND_OP  = 4'b0000;
    localparam OR_OP   = 4'b0001;
    localparam XOR_OP  = 4'b0010;
    localparam SLL_OP  = 4'b0101;
    localparam SRL_OP  = 4'b0110;
    localparam SRA_OP  = 4'b0111;
    localparam SLT_OP  = 4'b1000;
    localparam SLTU_OP = 4'b1001;

    always @(*) begin
        // Valores por defecto
        ALUSrc      = 1'b0;
        MemtoReg    = 1'b0;
        RegWrite    = 1'b0;
        MemRead     = 1'b0;
        MemWrite    = 1'b0;
        Branch      = 1'b0;
        Jump        = 1'b0;
        ALUControl  = ADD_OP;  // Por defecto se usa ADD

        case (opcode)
            R_TYPE: begin
                ALUSrc   = 1'b0;
                RegWrite = 1'b1;
                // Para R-type, diferenciamos según funct3 y funct7_bit
                case (funct3)
                    3'b000: begin // ADD o SUB
                        if (funct7_bit)
                            ALUControl = SUB_OP;  // SUB si funct7_bit = 1
                        else
                            ALUControl = ADD_OP;  // ADD si funct7_bit = 0
                    end
                    3'b111: ALUControl = AND_OP;  // AND
                    3'b110: ALUControl = OR_OP;   // OR
                    3'b100: ALUControl = XOR_OP;  // XOR
                    3'b001: ALUControl = SLL_OP;  // SLL
                    3'b101: begin
                        if (funct7_bit)
                            ALUControl = SRA_OP; // SRA
                        else
                            ALUControl = SRL_OP; // SRL
                    end
                    3'b010: ALUControl = SLT_OP;  // SLT
                    3'b011: ALUControl = SLTU_OP; // SLTU
                    default: ALUControl = ADD_OP;
                endcase
            end

            I_ALU: begin // Inmediatos (addi, andi, etc.)
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                case (funct3)
                    3'b000: ALUControl = ADD_OP;  // addi
                    3'b111: ALUControl = AND_OP;  // andi
                    3'b110: ALUControl = OR_OP;   // ori
                    3'b100: ALUControl = XOR_OP;  // xori
                    3'b001: ALUControl = SLL_OP;  // slli
                    3'b101: begin
                        if (funct7_bit)
                            ALUControl = SRA_OP; // srai
                        else
                            ALUControl = SRL_OP; // srli
                    end
                    3'b010: ALUControl = SLT_OP;  // slti
                    3'b011: ALUControl = SLTU_OP; // sltiu
                    default: ALUControl = ADD_OP;
                endcase
            end

            I_LOAD: begin // Load (lw, etc.)
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                ALUControl = ADD_OP;  // Se usa ADD para calcular la dirección
            end

            S_TYPE: begin // Store (sw, etc.)
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUControl = ADD_OP;  // ADD para calcular dirección efectiva
            end

            B_TYPE: begin // Branch (beq, bne, etc.)
                Branch   = 1'b1;
                // Para branches, se suele usar SUB para comparar
                ALUControl = SUB_OP;
            end

            JAL: begin // Jump and Link
                Jump     = 1'b1;
                RegWrite = 1'b1;
                ALUControl = ADD_OP; // No se usa en el cálculo de salto, se usa para PC+4
            end

            JALR: begin // Jump and Link Register
                ALUSrc   = 1'b1;
                Jump     = 1'b1;
                RegWrite = 1'b1;
                ALUControl = ADD_OP;
            end

            LUI: begin // Load Upper Immediate
                RegWrite = 1'b1;
                // LUI se usa para cargar la parte alta de un inmediato.
                // La ALU normalmente no se usa para esto; sin embargo, se puede definir ALUControl = 0 o un código especial.
                ALUControl = 4'b0000;
            end

            AUIPC: begin // Add Upper Immediate to PC
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUControl = ADD_OP;  // Suma el PC con el inmediato
            end

            default: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ALUControl = ADD_OP;
            end
        endcase
    end

endmodule
