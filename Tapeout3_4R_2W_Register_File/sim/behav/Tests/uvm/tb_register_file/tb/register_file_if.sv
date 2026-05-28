interface register_file_if(input logic clk);

    // Number of Registers
    parameter NUM_REG = 32;

    // Length of Address (length of bits)
    parameter ADDR_W = 5;

    // Length of Data (length of bits)
    parameter DATA_W = 32;

    logic [ADDR_W-1:0] waddr0;
    logic [ADDR_W-1:0] waddr1;
    logic [DATA_W-1:0] wdata0;
    logic [DATA_W-1:0] wdata1;

    logic we0;
    logic we1;
    logic reset;

    logic [ADDR_W-1:0] raddr0;
    logic [ADDR_W-1:0] raddr1;
    logic [ADDR_W-1:0] raddr2;
    logic [ADDR_W-1:0] raddr3;

    logic [DATA_W-1:0] rdata0;
    logic [DATA_W-1:0] rdata1;
    logic [DATA_W-1:0] rdata2;
    logic [DATA_W-1:0] rdata3;
    
    //--------------------------------------------
    // Clocking Blocks
    //--------------------------------------------

    // Positive edge DRIVER clocking block
    clocking pos_drv_cb @(posedge clk);
        default output #1;
        output waddr0, waddr1;
        output wdata0, wdata1;
        output we0, we1;
        output raddr0, raddr1, raddr2, raddr3;
        output reset;
    endclocking

    // Positive edge MONITOR clocking block
    clocking pos_mon_cb @(posedge clk);
        default input #0;
        input waddr0, waddr1;
        input wdata0, wdata1;
        input we0, we1;
        input raddr0, raddr1, raddr2, raddr3;
        input rdata0, rdata1, rdata2, rdata3;
        input reset;
    endclocking

    // Negative edge DRIVER clocking block
    clocking neg_drv_cb @(negedge clk);
        default output #1;
        output waddr0, waddr1;
        output wdata0, wdata1;
        output we0, we1;
        output raddr0, raddr1, raddr2, raddr3;
        output reset;
    endclocking

    // Negative edge MONITOR clocking block
    clocking neg_mon_cb @(negedge clk);
        default input #0;
        input waddr0, waddr1;
        input wdata0, wdata1;
        input we0, we1;
        input raddr0, raddr1, raddr2, raddr3;
        input rdata0, rdata1, rdata2, rdata3;
        input reset;
    endclocking



    //--------------------------------------------
    // Assertions
    //--------------------------------------------

    // 4.1
    property zero_register;
        @(posedge clk)
        ((raddr0 == 0) |-> (rdata0 == 0) and
        (raddr1 == 0) |-> (rdata1 == 0) and
        (raddr2 == 0) |-> (rdata2 == 0) and
        (raddr3 == 0) |-> (rdata3 == 0));
    endproperty: zero_register

    // 4.2
    property sync_reset;
        @(pos_mon_cb)
        reset === 0 |=> (rdata0 === 0 && rdata1 === 0 && rdata2 === 0 && rdata3 === 0);
    endproperty: sync_reset
    property not_async_reset;
        @(negedge reset) 
        (!clk) |-> ($stable(rdata0) && $stable(rdata1) && $stable(rdata2) && $stable(rdata3));
    endproperty: not_async_reset

    // 4.3
    property reads_reflect_writes;
        @(pos_mon_cb) disable iff (reset == 0)
        ((((waddr0 != 0 && we0) |=>
            ((raddr0 == $past(waddr0)) -> (rdata0 == $past(wdata0))) &&
            ((raddr1 == $past(waddr0)) -> (rdata1 == $past(wdata0))) &&
            ((raddr2 == $past(waddr0)) -> (rdata2 == $past(wdata0))) &&
            ((raddr3 == $past(waddr0)) -> (rdata3 == $past(wdata0)))
        ))
        and
        (((waddr1 != 0 && we1 && !(we0 && waddr0 == waddr1)) |=>
            ((raddr0 == $past(waddr1)) -> (rdata0 == $past(wdata1))) &&
            ((raddr1 == $past(waddr1)) -> (rdata1 == $past(wdata1))) &&
            ((raddr2 == $past(waddr1)) -> (rdata2 == $past(wdata1))) &&
            ((raddr3 == $past(waddr1)) -> (rdata3 == $past(wdata1)))
        )))
    endproperty: reads_reflect_writes

    // 4.4
    property write0_priority;
        @(pos_mon_cb) disable iff (reset == 0)
        ((we0 == 1 && we1 == 1 && waddr0 == waddr1) |=>
            (((raddr0 == $past(waddr0)) -> (rdata0 == $past(wdata0))) and
            ((raddr1 == $past(waddr0)) -> (rdata1 == $past(wdata0))) and
            ((raddr2 == $past(waddr0)) -> (rdata2 == $past(wdata0))) and
            ((raddr3 == $past(waddr0)) -> (rdata3 == $past(wdata0)))
        ));
    endproperty: write0_priority

    assert property (zero_register)
        else $fatal("ASSERTION ERROR: 4.1");
    assert property (sync_reset)
        else $fatal("ASSERTION ERROR: 4.2 sync_reset");
    assert property (not_async_reset)
        else $fatal("ASSERTION ERROR: 4.2 not_async_reset");
    assert property (reads_reflect_writes)
        else $fatal("ASSERTION ERROR: 4.3");
    assert property (write0_priority) 
        else $fatal("ASSERTION ERROR: 4.4");

endinterface: register_file_if