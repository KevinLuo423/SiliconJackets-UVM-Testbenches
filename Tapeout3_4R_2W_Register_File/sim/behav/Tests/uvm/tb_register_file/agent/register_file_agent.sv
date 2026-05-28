/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_agent.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025

    Agent for register file.
-------------------------------------------------------------------------------------------------*/

class register_file_agent extends uvm_agent;
    `uvm_component_utils(register_file_agent)
    register_file_driver drv;
    register_file_monitor mon;
    register_file_sequencer seqr;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "register_file_agent", uvm_component parent);
        super.new(name, parent);
        `uvm_info("AGENT_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Build Phase
    //--------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AGENT_CLASS", "Build Phase", UVM_HIGH)

        drv = register_file_driver::type_id::create("drv", this);
        mon = register_file_monitor::type_id::create("mon", this);
        seqr = register_file_sequencer::type_id::create("seqr", this);
    endfunction: build_phase

    //--------------------------------------------
    // Connect Phase
    //--------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("AGENT_CLASS", "Connect Phase", UVM_HIGH)

        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction: connect_phase

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("AGENT_CLASS", "Run Phase", UVM_HIGH)

        // Logic

    endtask: run_phase
endclass : register_file_agent