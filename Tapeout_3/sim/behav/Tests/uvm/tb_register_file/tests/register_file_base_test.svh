/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_base_test.svh
* Author        :   Kevin Luo
* Date          :   12/08/2025

    Define base structure for register file tests.
-------------------------------------------------------------------------------------------------*/

class base_register_file_test extends uvm_test;
    `uvm_component_utils(base_register_file_test)
    register_file_env env;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "base_register_file_test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("BASE_TEST_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Build Phase
    //--------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BASE_TEST_CLASS", "Build Phase", UVM_HIGH)

        env = register_file_env::type_id::create("env", this);
    endfunction: build_phase

    //--------------------------------------------
    // Connect Phase
    //--------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("BASE_TEST_CLASS", "Connect Phase", UVM_HIGH)

        // Connect monitor with scoreboard

    endfunction: connect_phase

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("BASE_TEST_CLASS", "Run Phase", UVM_HIGH)

        // phase.raise_objection(this);
        
        // base sequence
        // seq = register_file_base_seq::type_id::create("seq");
        // seq.start(env.agnt.seqr);

        // phase.raise_objection(this);

    endtask: run_phase

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("FINAL_STATUS", $sformatf("\n************************************\n          TEST COMPLETED\n************************************"), UVM_NONE)
    endfunction

endclass : base_register_file_test