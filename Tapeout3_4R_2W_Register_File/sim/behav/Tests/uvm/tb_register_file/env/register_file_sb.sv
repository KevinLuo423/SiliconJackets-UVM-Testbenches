/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_sb.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025

    Scoreboard for register file.
-------------------------------------------------------------------------------------------------*/

class register_file_sb extends uvm_scoreboard;
    `uvm_component_utils(register_file_sb)

    uvm_analysis_imp #(register_file_seq_item, register_file_sb) sb_port;
    register_file_seq_item transactions_queue[$];

    logic [DATA_W-1:0] exp_registers [(2**ADDR_W)];

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "register_file_sb", uvm_component parent);
        super.new(name, parent);
        `uvm_info("SCOREBOARD_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Build Phase
    //--------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("SCOREBOARD_CLASS", "Build Phase", UVM_HIGH)

        sb_port = new("scoreboard_port", this);
    endfunction: build_phase

    //--------------------------------------------
    // Connect Phase
    //--------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("SCOREBOARD_CLASS", "Connect Phase", UVM_HIGH)
    endfunction: connect_phase

    //--------------------------------------------
    // Write Method
    //--------------------------------------------
    function void write(register_file_seq_item item);
        transactions_queue.push_back(item);
    endfunction: write

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("SCOREBOARD_CLASS", "Run Phase", UVM_HIGH)

        // 1) Get transaction data
        // 2) Calculate expected data
        // 3) Compare transaction and expected data
        // 4) Score transaction accordingly

        foreach(exp_registers[i]) begin
            exp_registers[i] = 'x;
        end

        forever begin
            register_file_seq_item curr_trans;
            wait((transactions_queue.size() != 0));
            curr_trans = transactions_queue.pop_front();
            compare(curr_trans);
        end

    endtask: run_phase

    //--------------------------------------------
    // Compare Method
    //--------------------------------------------
    task compare(register_file_seq_item curr_trans);
        logic [DATA_W-1:0] actual_rdata0;
        logic [DATA_W-1:0] actual_rdata1;
        logic [DATA_W-1:0] actual_rdata2;
        logic [DATA_W-1:0] actual_rdata3;
        logic [DATA_W-1:0] exp_rdata0;
        logic [DATA_W-1:0] exp_rdata1;
        logic [DATA_W-1:0] exp_rdata2;
        logic [DATA_W-1:0] exp_rdata3;

        // Expected Value Logic
        if (curr_trans.clock_edge == POSEDGE) begin
            $display($sformatf("%s", curr_trans.clock_edge == NEGEDGE ? "NEG" : "POS"));
            if (curr_trans.reset == 0) begin
                exp_registers = '{default: '0};
                `uvm_info("SCOREBOARD_CLASS", $sformatf("RESET!"), UVM_HIGH)
            end
            else begin
                if (curr_trans.we1 && curr_trans.waddr1 != 0) begin
                    exp_registers[curr_trans.waddr1] = curr_trans.wdata1;
                    `uvm_info("SCOREBOARD_CLASS", $sformatf("0x%0h SET TO %0d ON WPORT 1!", curr_trans.waddr1, curr_trans.wdata1), UVM_HIGH)
                end
                if (curr_trans.we0 && curr_trans.waddr0 != 0) begin
                    exp_registers[curr_trans.waddr0] = curr_trans.wdata0;
                    `uvm_info("SCOREBOARD_CLASS", $sformatf("0x%0h SET TO %0d ON WPORT 0!", curr_trans.waddr0, curr_trans.wdata0), UVM_HIGH)
                end
            end
        end

        exp_registers[0] = 0;

        actual_rdata0 = curr_trans.rdata0;
        actual_rdata1 = curr_trans.rdata1;
        actual_rdata2 = curr_trans.rdata2;
        actual_rdata3 = curr_trans.rdata3;
        exp_rdata0 = exp_registers[curr_trans.raddr0];
        exp_rdata1 = exp_registers[curr_trans.raddr1];
        exp_rdata2 = exp_registers[curr_trans.raddr2];
        exp_rdata3 = exp_registers[curr_trans.raddr3];
        `uvm_info("SCOREBOARD_CLASS", $sformatf("raddr1 %0d !", exp_registers[30]), UVM_HIGH)

        // Compare & Score
        if (actual_rdata0 === exp_rdata0 && actual_rdata1 === exp_rdata1 && actual_rdata2 === exp_rdata2 && actual_rdata3 === exp_rdata3)
        begin
            `uvm_info("SCOREBOARD_CLASS", $sformatf(
                "%s Transaction Passed!\nReset=%0b\nWrite Port 0: EN=%0b Addr=0x%0h Data=0x%0h\nWrite Port 1: EN=%0b Addr=0x%0h Data=0x%0h\nRead Port 0: Addr=0x%3h Actual=0x%8h Expected=0x%0h\nRead Port 1: Addr=0x%3h Actual=0x%8h Expected=0x%0h\nRead Port 2: Addr=0x%3h Actual=0x%8h Expected=0x%0h\nRead Port 3: Addr=0x%3h Actual=0x%-8h Expected=0x%0h\n",
                curr_trans.clock_edge == POSEDGE ? "Posedge" : "Negedge",
                curr_trans.reset,
                curr_trans.we0, curr_trans.waddr0, curr_trans.wdata0,
                curr_trans.we1, curr_trans.waddr1, curr_trans.wdata1,
                curr_trans.raddr0, actual_rdata0, exp_rdata0,
                curr_trans.raddr1, actual_rdata1, exp_rdata1,
                curr_trans.raddr2, actual_rdata2, exp_rdata2,
                curr_trans.raddr3, actual_rdata3, exp_rdata3),
                UVM_LOW)
        end
        else begin
            `uvm_error("SCOREBOARD_CLASS", $sformatf(
                "%s Transaction Failed!\nReset=%0b\nWrite Port 0: EN=%0b Addr=0x%0h Data=0x%0h\nWrite Port 1: EN=%0b Addr=0x%0h Data=0x%0h\nRead Port 0: Addr=0x%3h Actual=0x%8h Expected=0x%0h\nRead Port 1: Addr=0x%3h Actual=0x%8h Expected=0x%0h\nRead Port 2: Addr=0x%3h Actual=0x%8h Expected=0x%0h\nRead Port 3: Addr=0x%3h Actual=0x%-8h Expected=0x%0h\n",
                curr_trans.clock_edge == POSEDGE ? "Posedge" : "Negedge",
                curr_trans.reset,
                curr_trans.we0, curr_trans.waddr0, curr_trans.wdata0,
                curr_trans.we1, curr_trans.waddr1, curr_trans.wdata1,
                curr_trans.raddr0, actual_rdata0, exp_rdata0,
                curr_trans.raddr1, actual_rdata1, exp_rdata1,
                curr_trans.raddr2, actual_rdata2, exp_rdata2,
                curr_trans.raddr3, actual_rdata3, exp_rdata3))
        end
    endtask: compare
endclass : register_file_sb
