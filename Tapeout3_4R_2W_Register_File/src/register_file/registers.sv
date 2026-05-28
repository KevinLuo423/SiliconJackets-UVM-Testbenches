module registers (
    input logic[31:0] writeData [32],
    input logic clock,
    input logic resetn,
    
    output logic[31:0] readData [32]
);

    logic[31:0] Registers [32];

    always_ff @(posedge clock) begin
        if (!resetn)
            Registers <= '{32{32'h0000}};
        else
            Registers <= writeData;
    end

    always_comb begin
        readData = Registers;
    end
endmodule