/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_base_seq.svh
* Author        :   Kevin Luo
* Date          :   12/08/2025

    Base sequence structure for register file.
-------------------------------------------------------------------------------------------------*/

class register_file_base_seq extends uvm_sequence #(register_file_seq_item);
    `uvm_object_utils(register_file_base_seq)

    register_file_seq_item reset_pkt;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name="register_file_seq");
        super.new(name);
        `uvm_info("BASE_SEQ", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Body
    //--------------------------------------------
    task body();
        `uvm_info("BASE_SEQ", "Inside Body Task", UVM_HIGH)

        reset_pkt = register_file_seq_item::type_id::create("reset_pkt");
        start_item(reset_pkt);
        void'(reset_pkt.randomize() with {reset_pkt.reset==1;});
        finish_item(reset_pkt);
    endtask: body
endclass : register_file_base_seq