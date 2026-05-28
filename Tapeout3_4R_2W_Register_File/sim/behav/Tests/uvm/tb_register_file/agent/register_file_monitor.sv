/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_monitor.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025

    Monitor for register file.
-------------------------------------------------------------------------------------------------*/

class register_file_monitor extends uvm_monitor;
    `uvm_component_utils(register_file_monitor)
    virtual register_file_if monitor_vif;
    register_file_seq_item item;

    uvm_analysis_port #(register_file_seq_item) monitor_port;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "register_file_monitor", uvm_component parent);
        super.new(name, parent);
        `uvm_info("MONITOR_CLASS", "Inside Constructor", UVM_HIGH);
    endfunction: new

    //--------------------------------------------
    // Build Phase
    //--------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MONITOR_CLASS", "Build Phase", UVM_HIGH)
        
        monitor_port = new("monitor_port", this);

        // Get virtual interface
        if (!(uvm_config_db #(virtual register_file_if)::get(this, "", "vif", monitor_vif))) begin
            `uvm_error("MONITOR_CLASS", "Failed to get vif from config DB")
        end
    endfunction: build_phase

    //--------------------------------------------
    // Connect Phase
    //--------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("MONITOR_CLASS", "Connect Phase", UVM_HIGH)
    endfunction: connect_phase

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("MONITOR_CLASS", "Run Phase", UVM_HIGH)

        forever begin
            item = register_file_seq_item::type_id::create("item");

            monitor(item);

            // send item to scoreboard
            monitor_port.write(item);

            $display("new loop monitor");

        end
    endtask: run_phase

    //--------------------------------------------
    // Monitor
    //--------------------------------------------
    task monitor(register_file_seq_item item);
        $display($sformatf("the clock is %s", item.clock_edge == POSEDGE ? "posedge" : "negedge"));
        fork
            begin
                @(monitor_vif.pos_mon_cb);
                $display("READING positive");

                // sample inputs
                item.waddr0 = monitor_vif.pos_mon_cb.waddr0;
                item.waddr1 = monitor_vif.pos_mon_cb.waddr1;
                item.wdata0 = monitor_vif.pos_mon_cb.wdata0;
                item.wdata1 = monitor_vif.pos_mon_cb.wdata1;

                item.we0 = monitor_vif.pos_mon_cb.we0;
                item.we1 = monitor_vif.pos_mon_cb.we1;
                item.reset = monitor_vif.pos_mon_cb.reset;

                item.raddr0 = monitor_vif.pos_mon_cb.raddr0;
                item.raddr1 = monitor_vif.pos_mon_cb.raddr1;
                item.raddr2 = monitor_vif.pos_mon_cb.raddr2;
                item.raddr3 = monitor_vif.pos_mon_cb.raddr3;

                // sample outputs
                item.rdata0 = monitor_vif.rdata0;
                item.rdata1 = monitor_vif.rdata1;
                item.rdata2 = monitor_vif.rdata2;
                item.rdata3 = monitor_vif.rdata3;

                // report clock edge
                item.clock_edge = POSEDGE;
            end

            begin
                $display("READING negative");
                @(monitor_vif.neg_mon_cb);

                // sample inputs
                item.waddr0 = monitor_vif.neg_mon_cb.waddr0;
                item.waddr1 = monitor_vif.neg_mon_cb.waddr1;
                item.wdata0 = monitor_vif.neg_mon_cb.wdata0;
                item.wdata1 = monitor_vif.neg_mon_cb.wdata1;

                item.we0 = monitor_vif.neg_mon_cb.we0;
                item.we1 = monitor_vif.neg_mon_cb.we1;
                item.reset = monitor_vif.neg_mon_cb.reset;

                item.raddr0 = monitor_vif.neg_mon_cb.raddr0;
                item.raddr1 = monitor_vif.neg_mon_cb.raddr1;
                item.raddr2 = monitor_vif.neg_mon_cb.raddr2;
                item.raddr3 = monitor_vif.neg_mon_cb.raddr3;

                // sample outputs
                item.rdata0 = monitor_vif.rdata0;
                item.rdata1 = monitor_vif.rdata1;
                item.rdata2 = monitor_vif.rdata2;
                item.rdata3 = monitor_vif.rdata3;

                // report clock edge
                item.clock_edge = NEGEDGE;
            end
        join_any
        disable fork;
    endtask: monitor
endclass : register_file_monitor