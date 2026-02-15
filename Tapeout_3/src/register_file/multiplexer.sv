module multiplexer (
    input logic[31:0] data [32],
    input logic[4:0] addr,
    output logic[31:0] outData
);
    always_comb begin
       outData = data[addr];
    end
endmodule