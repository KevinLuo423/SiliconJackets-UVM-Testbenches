/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_env.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025

    Environment for register file.
-------------------------------------------------------------------------------------------------*/

class register_file_env extends uvm_env;
    `uvm_component_utils(register_file_env)
    register_file_agent agnt;
    register_file_sb sb;
    register_file_collector cvg;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "register_file_env", uvm_component parent);
        super.new(name, parent);
        `uvm_info("ENV_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Build Phase
    //--------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ENV_CLASS", "Build Phase", UVM_HIGH)

        agnt = register_file_agent::type_id::create("agnt", this);
        sb = register_file_sb::type_id::create("sb", this);
        cvg = register_file_collector::type_id::create("cvg", this);
    endfunction: build_phase

    //--------------------------------------------
    // Connect Phase
    //--------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("ENV_CLASS", "Connect Phase", UVM_HIGH)

        agnt.mon.monitor_port.connect(sb.sb_port);
        agnt.mon.monitor_port.connect(cvg.analysis_export);
    endfunction: connect_phase

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("ENV_CLASS", "Run Phase", UVM_HIGH)

        // Logic

    endtask: run_phase
endclass : register_file_env