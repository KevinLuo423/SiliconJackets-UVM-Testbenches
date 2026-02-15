package register_file_agent_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import register_file_types_pkg::*;
    import register_file_seq_pkg::*;
    `include "register_file_monitor.sv"
    `include "register_file_driver.sv"
    `include "register_file_sequencer.sv"
    `include "register_file_agent.sv"
endpackage : register_file_agent_pkg