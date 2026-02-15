/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_driver.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025

    Driver for register file.
-------------------------------------------------------------------------------------------------*/

class register_file_driver extends uvm_driver#(register_file_seq_item);
    `uvm_component_utils(register_file_driver)
    virtual register_file_if driver_vif;
    register_file_seq_item item;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "register_file_driver", uvm_component parent);
        super.new(name, parent);
        `uvm_info("DRIVER_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Build Phase
    //--------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("DRIVER_CLASS", "Build Phase", UVM_HIGH)

        // Get virtual interface
        if (!uvm_config_db #(virtual register_file_if)::get(this, "", "vif", driver_vif)) begin
            `uvm_error("DRIVER_CLASS", "Failed to get vif from config DB")
        end
    endfunction: build_phase

    //--------------------------------------------
    // Connect Phase
    //--------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("DRIVER_CLASS", "Connect Phase", UVM_HIGH)
    endfunction: connect_phase

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("DRIVER_CLASS", "Run Phase", UVM_HIGH)

        // Logic
        forever begin
            item = register_file_seq_item::type_id::create("item");
            seq_item_port.get_next_item(item);
            drive(item);
            `uvm_info("DRIVER CLASS", $sformatf("sent"), UVM_HIGH)
            seq_item_port.item_done();
        end

    endtask: run_phase

    //--------------------------------------------
    // Drive
    //--------------------------------------------
    task drive(register_file_seq_item item);
        if (item.clock_edge == POSEDGE) begin
            $display("drive positive");
            @(driver_vif.pos_drv_cb);

            driver_vif.pos_drv_cb.waddr0 <= item.waddr0;
            driver_vif.pos_drv_cb.waddr1 <= item.waddr1;
            driver_vif.pos_drv_cb.wdata0 <= item.wdata0;
            driver_vif.pos_drv_cb.wdata1 <= item.wdata1;

            driver_vif.pos_drv_cb.we0 <= item.we0;
            driver_vif.pos_drv_cb.we1 <= item.we1;
            driver_vif.pos_drv_cb.reset <= item.reset;

            driver_vif.pos_drv_cb.raddr0 <= item.raddr0;
            driver_vif.pos_drv_cb.raddr1 <= item.raddr1;
            driver_vif.pos_drv_cb.raddr2 <= item.raddr2;
            driver_vif.pos_drv_cb.raddr3 <= item.raddr3;
        end else if (item.clock_edge == NEGEDGE) begin
            $display("driving negative");
            @(driver_vif.neg_drv_cb);

            driver_vif.neg_drv_cb.waddr0 <= item.waddr0;
            driver_vif.neg_drv_cb.waddr1 <= item.waddr1;
            driver_vif.neg_drv_cb.wdata0 <= item.wdata0;
            driver_vif.neg_drv_cb.wdata1 <= item.wdata1;

            driver_vif.neg_drv_cb.we0 <= item.we0;
            driver_vif.neg_drv_cb.we1 <= item.we1;
            driver_vif.neg_drv_cb.reset <= item.reset;

            driver_vif.neg_drv_cb.raddr0 <= item.raddr0;
            driver_vif.neg_drv_cb.raddr1 <= item.raddr1;
            driver_vif.neg_drv_cb.raddr2 <= item.raddr2;
            driver_vif.neg_drv_cb.raddr3 <= item.raddr3;
        end
    endtask: drive

endclass : register_file_driver

