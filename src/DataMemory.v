module data_memory(
    input wire clk,
    input wire MemWrite,
    input wire MemRead,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);

// Memoria interna BRAM de 1KB (256 x 32 bits)
reg [31:0] memory [0:255];

always @(posedge clk) begin
    if (MemWrite) begin
        memory[addr[9:2]] <= write_data;
    end
end

always @(*) begin
    if (MemRead) begin
        read_data = memory[addr[9:2]];
    end else begin
        read_data = 32'b0;
    end
end

endmodule
