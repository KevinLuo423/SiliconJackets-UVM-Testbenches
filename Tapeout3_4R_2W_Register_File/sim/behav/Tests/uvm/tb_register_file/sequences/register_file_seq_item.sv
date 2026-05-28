/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_seq_item.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025

    Object class for sequence item.
-------------------------------------------------------------------------------------------------*/

import register_file_pkg::*;

// Considered an "Object Class", not a "Component Class"
class register_file_seq_item extends uvm_sequence_item;

    //--------------------------------------------
    // Sequence Items
    //--------------------------------------------

    // Inputs
    rand logic [ADDR_W-1:0] waddr0;
    rand logic [ADDR_W-1:0] waddr1;
    rand logic [DATA_W-1:0] wdata0;
    rand logic [DATA_W-1:0] wdata1;

    rand logic we0;
    rand logic we1;
    rand logic reset;

    rand logic [ADDR_W-1:0] raddr0;
    rand logic [ADDR_W-1:0] raddr1;
    rand logic [ADDR_W-1:0] raddr2;
    rand logic [ADDR_W-1:0] raddr3;

    // Outputs
    logic [DATA_W-1:0] rdata0;
    logic [DATA_W-1:0] rdata1;
    logic [DATA_W-1:0] rdata2;
    logic [DATA_W-1:0] rdata3;

    // Edge Control
    rand clock_edge_e clock_edge;

    // UVM Automation Macros
    //      without this, methods like "copy()" won't work. here we specify which fields should be "copyable", in this case all of them.
    `uvm_object_utils_begin(register_file_seq_item)
        
        // Inputs
        `uvm_field_int(waddr0, UVM_ALL_ON)
        `uvm_field_int(waddr1, UVM_ALL_ON)
        `uvm_field_int(wdata0, UVM_ALL_ON)
        `uvm_field_int(wdata1, UVM_ALL_ON)
        
        `uvm_field_int(we0,    UVM_ALL_ON)
        `uvm_field_int(we1,    UVM_ALL_ON)
        `uvm_field_int(reset,  UVM_ALL_ON)

        `uvm_field_int(raddr0, UVM_ALL_ON)
        `uvm_field_int(raddr1, UVM_ALL_ON)
        `uvm_field_int(raddr2, UVM_ALL_ON)
        `uvm_field_int(raddr3, UVM_ALL_ON)

        // Outputs
        `uvm_field_int(rdata0, UVM_ALL_ON)
        `uvm_field_int(rdata1, UVM_ALL_ON)
        `uvm_field_int(rdata2, UVM_ALL_ON)
        `uvm_field_int(rdata3, UVM_ALL_ON)

        // Edge Control
        `uvm_field_int(rdata3, UVM_ALL_ON | UVM_NOCOMPARE)
        
    `uvm_object_utils_end

    //--------------------------------------------
    // Default Constraints
    //--------------------------------------------
    constraint default_clock_edge { 
        soft clock_edge == POSEDGE;
    }
    

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "register_file_seq_item");
        super.new(name);
    endfunction: new
endclass : register_file_seq_item