/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_seq_lib.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025
-------------------------------------------------------------------------------------------------*/

//--------------------------------------------
// Simple Sequence: randomized stimulus
//--------------------------------------------
class register_file_simple_seq extends register_file_base_seq;
    `uvm_object_utils(register_file_simple_seq)
    register_file_seq_item pkt;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name="register_file_simple_seq");
        super.new(name);
        `uvm_info("SIMPLE_SEQ", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Body
    //--------------------------------------------
    task body();
        `uvm_info("SIMPLE_SEQ", "Inside Body Task", UVM_HIGH)

        pkt = register_file_seq_item::type_id::create("pkt");

        start_item(pkt);
        if (!(pkt.randomize() with { reset == 1; })) begin
            `uvm_error("SIMPLE_SEQ", "Randomization failed")
        end
        finish_item(pkt);
    endtask: body
endclass : register_file_simple_seq



//--------------------------------------------
// Reset Sequence: reset packet
//--------------------------------------------
class register_file_reset_seq extends register_file_base_seq;
    `uvm_object_utils(register_file_reset_seq)

    register_file_seq_item pkt;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name="register_file_reset_seq");
        super.new(name);
        `uvm_info("RESET_SEQ", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Body
    //--------------------------------------------
    task body();
        `uvm_info("RESET_SEQ", "Inside Body Task", UVM_HIGH)

        pkt = register_file_seq_item::type_id::create("pkt");
        start_item(pkt);
        void'(pkt.randomize() with {reset==0;});
        finish_item(pkt);
    endtask: body
endclass : register_file_reset_seq



//--------------------------------------------
// Initialize Sequence: load initialized state
//--------------------------------------------
class register_file_init_seq extends register_file_base_seq;
    `uvm_object_utils(register_file_init_seq)
    register_file_seq_item pkt;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name="register_file_init_seq");
        super.new(name);
        `uvm_info("INIT_SEQ", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Body
    //--------------------------------------------
    task body();
        `uvm_info("INIT_SEQ", "Inside Body Task", UVM_HIGH)

        for (int i = 0; i < (1<<ADDR_W); i = i + 2) begin
            `uvm_info("INIT_SEQ", $sformatf("Init Sequence %0d", i), UVM_LOW)
            pkt = register_file_seq_item::type_id::create("pkt");
            start_item(pkt);
            void'(pkt.randomize() with {
                pkt.reset == 1;
                pkt.we0 == 1;
                pkt.waddr0 == local::i;
                pkt.raddr0 == local::i;
                pkt.wdata0 == (1<<(DATA_W-4)) + local::i;
                pkt.we1 == 1;
                pkt.waddr1 == local::i + 1;
                pkt.raddr1 == local::i + 1;
                pkt.wdata1 == (1<<(DATA_W-4)) + local::i + 1;
            });
            finish_item(pkt);
        end

    endtask: body
endclass : register_file_init_seq



//--------------------------------------------
// Directed Sequence: directed stimulus
//--------------------------------------------
class register_file_direct_seq extends register_file_base_seq;
    `uvm_object_utils(register_file_direct_seq)
    register_file_seq_item pkt;
    rand bit [ADDR_W-1:0] raddr0;
    rand bit [ADDR_W-1:0] raddr1;
    rand bit [ADDR_W-1:0] raddr2;
    rand bit [ADDR_W-1:0] raddr3;
    rand bit we0;
    rand bit we1;
    rand bit [DATA_W-1:0] wdata0;
    rand bit [DATA_W-1:0] wdata1;
    rand clock_edge_e clock_edge;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name="register_file_direct_seq");
        super.new(name);
        `uvm_info("DIRECT_SEQ", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Constraint
    //--------------------------------------------
    constraint default_constraints { 
        soft we0 == 1'b1;
        soft we1 == 1'b1; 
        soft raddr0 != 'b0;
        soft raddr1 != 'b0;
        soft raddr2 != 'b0;
        soft raddr3 != 'b0;
        soft wdata0 == 'hCAFEBABE;
        soft wdata1 == 'hDEADBEEF;
        soft clock_edge == POSEDGE;
    }

    //--------------------------------------------
    // Body
    //--------------------------------------------
    task body();
        `uvm_info("DIRECT_SEQ", "Inside Body Task", UVM_HIGH)

        pkt = register_file_seq_item::type_id::create("pkt");
        start_item(pkt);
        void'(pkt.randomize() with {
            pkt.reset == 1;
            pkt.we0 == local::we0;
            pkt.waddr0 == pkt.raddr0;
            pkt.wdata0 == local::wdata0;
            pkt.we1 == local::we1;
            pkt.waddr1 == pkt.raddr1;
            pkt.wdata1 == local::wdata1;

            pkt.raddr0 == local::raddr0;
            pkt.raddr1 == local::raddr1;
            pkt.raddr2 == local::raddr2;
            pkt.raddr3 == local::raddr3;

            pkt.clock_edge == local::clock_edge;
        });
        finish_item(pkt);

    endtask: body
endclass : register_file_direct_seq


//--------------------------------------------
// Filler Sequence: no writes
//--------------------------------------------
class register_file_filler_seq extends register_file_base_seq;
    `uvm_object_utils(register_file_filler_seq)
    register_file_seq_item pkt;
    rand bit [ADDR_W-1:0] raddr0;
    rand bit [ADDR_W-1:0] raddr1;
    rand bit [ADDR_W-1:0] raddr2;
    rand bit [ADDR_W-1:0] raddr3;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name="register_file_filler_seq");
        super.new(name);
        `uvm_info("FILLER_SEQ", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Body
    //--------------------------------------------
    task body();
        `uvm_info("FILLER_SEQ", "Inside Body Task", UVM_HIGH)

        pkt = register_file_seq_item::type_id::create("pkt");
        start_item(pkt);
        void'(pkt.randomize() with {
            pkt.reset == 1;
            pkt.we0 == 0;
            pkt.we1 == 0;

            pkt.raddr0 == local::raddr0;
            pkt.raddr1 == local::raddr1;
            pkt.raddr2 == local::raddr2;
            pkt.raddr3 == local::raddr3;
        });
        finish_item(pkt);

    endtask: body
endclass : register_file_filler_seq