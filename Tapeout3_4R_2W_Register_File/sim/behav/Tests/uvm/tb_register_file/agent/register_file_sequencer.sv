/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_sequencer.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025

    Sequencer for register file.
-------------------------------------------------------------------------------------------------*/

class register_file_sequencer extends uvm_sequencer #(register_file_seq_item);
    `uvm_component_utils(register_file_sequencer)

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "register_file_sequencer", uvm_component parent);
        super.new(name, parent);
        `uvm_info("SEQUENCER_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new
    
    //--------------------------------------------
    // Build Phase
    //--------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("SEQUENCER_CLASS", "Build Phase!", UVM_HIGH)
    endfunction: build_phase


    //--------------------------------------------
    // Connect Phase
    //--------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("SEQUENCER_CLASS", "Connect Phase!", UVM_HIGH)
    endfunction: connect_phase
  
  
endclass : register_file_sequencer