module register_file import register_file_pkg::*; (
    input logic[ADDR_W-1:0] writeAddr0,
    input logic[ADDR_W-1:0] writeAddr1,
    input logic[DATA_W-1:0] writeData0,
    input logic[DATA_W-1:0] writeData1,

    input logic writeEn0,
    input logic writeEn1,
    input logic clock,
    input logic resetn,

    input logic[ADDR_W-1:0] readAddr0,
    input logic[ADDR_W-1:0] readAddr1,
    input logic[ADDR_W-1:0] readAddr2,
    input logic[ADDR_W-1:0] readAddr3,
    output logic[DATA_W-1:0] readData0,
    output logic[DATA_W-1:0] readData1,
    output logic[DATA_W-1:0] readData2,
    output logic[DATA_W-1:0] readData3
    
);

    /* Internal Signals */
    logic [DATA_W-1:0] reg_array   [DATA_W];   // output of registers module
    logic [DATA_W-1:0] wr_array    [DATA_W];   // output of wr_en_mux_arr module
    logic [DATA_W-1:0] regs_input  [DATA_W];   // registers after forcing x0 to be 0

    /* Write Enable Multiplexer Array */
    wr_en_mux_arr wr_mux (
        .writeData0     (writeData0),
        .writeData1     (writeData1),
        .writeAddr0     (writeAddr0),
        .writeAddr1     (writeAddr1),
        .currentRegData (reg_array),
        .writeEn0       (writeEn0),
        .writeEn1       (writeEn1),
        .writeRegData   (wr_array)
    );

    // Force register x0 to be 0
    always_comb begin
        regs_input = wr_array;
        regs_input[0] = 32'h00000000;
    end

    /* Register Array */
    registers regs (
        .writeData (regs_input),
        .clock     (clock),
        .resetn    (resetn),
        .readData  (reg_array)
    );

    /* Read Multiplexers */
    multiplexer mux0 (
        .data    (reg_array),
        .addr    (readAddr0),
        .outData (readData0)
    );

    multiplexer mux1 (
        .data    (reg_array),
        .addr    (readAddr1),
        .outData (readData1)
    );

    multiplexer mux2 (
        .data    (reg_array),
        .addr    (readAddr2),
        .outData (readData2)
    );

    multiplexer mux3 (
        .data    (reg_array),
        .addr    (readAddr3),
        .outData (readData3)
    );
    
endmodule