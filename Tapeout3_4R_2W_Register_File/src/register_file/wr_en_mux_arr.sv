module wr_en_mux_arr (
    input logic[31:0] writeData0,
    input logic[31:0] writeData1,
    input logic[4:0] writeAddr0,
    input logic[4:0] writeAddr1,
    input logic[31:0] currentRegData [32],
    input logic writeEn0,
    input logic writeEn1,

    output logic[31:0] writeRegData [32]
);

    always_comb begin
        foreach (currentRegData[i]) begin
            if (i == writeAddr0 && writeEn0) begin
                writeRegData[i] = writeData0;
            end else if (i == writeAddr1 && writeEn1) begin
                writeRegData[i] = writeData1;
            end else begin
                writeRegData[i] = currentRegData[i];
            end
        end
    end
endmodule