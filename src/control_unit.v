module Control_Unit (
    input wire [6:0] opcode,
    input wire stall,

    output reg regWrite,
    output reg memRead,
    output reg memWrite,
    output reg branch,
    output reg jump,
    output reg aluSrc,
    output reg wbSrc,
    output reg [1:0] aluOp
);

    always @(*) begin
        if (stall) begin
            // Desactiva señales si hay hazard
            regWrite = 0;
            memRead  = 0;
            memWrite = 0;
            branch   = 0;
            jump     = 0;
            aluSrc   = 0;
            wbSrc    = 0;
            aluOp    = 2'b00;
        end else begin
            // Valores por defecto (para instrucciones no reconocidas)
            regWrite = 0;
            memRead  = 0;
            memWrite = 0;
            branch   = 0;
            jump     = 0;
            aluSrc   = 0;
            wbSrc    = 0;
            aluOp    = 2'b00;

            case (opcode)
                7'b0110011: begin // R-type (ADD, SUB, etc.)
                    regWrite = 1;
                    aluSrc   = 0;
                    wbSrc    = 0;
                    aluOp    = 2'b10;
                end

                7'b0010011: begin // I-type (ADDI, etc.)
                    regWrite = 1;
                    aluSrc   = 1;
                    wbSrc    = 0;
                    aluOp    = 2'b10;
                end

                7'b0000011: begin // LW
                    regWrite = 1;
                    memRead  = 1;
                    aluSrc   = 1;
                    wbSrc    = 1;
                    aluOp    = 2'b00;
                end

                7'b0100011: begin // SW
                    memWrite = 1;
                    aluSrc   = 1;
                    aluOp    = 2'b00;
                end

                7'b1100011: begin // BEQ
                    branch   = 1;
                    aluOp    = 2'b01;
                end

                7'b1101111: begin // JAL
                    regWrite = 1;
                    jump     = 1;
                    wbSrc    = 0; // Usualmente se guarda pc + 4
                    aluOp    = 2'b00;
                end

                default: begin
                    // Todo desactivado
                end
            endcase
        end
    end
endmodule
