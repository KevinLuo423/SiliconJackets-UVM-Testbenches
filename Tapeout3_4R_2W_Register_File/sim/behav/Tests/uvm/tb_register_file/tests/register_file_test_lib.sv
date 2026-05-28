/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_test_lib.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025
-------------------------------------------------------------------------------------------------*/

//----------------------------------------------------------------
//
// TEST: Simple Test. Sets a default sequence. 
//
//----------------------------------------------------------------

class simple_register_file_test extends base_register_file_test;
    `uvm_component_utils(simple_register_file_test)
    register_file_simple_seq seq;
    register_file_reset_seq reset_seq;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "simple_register_file_test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("SIMPLE_TEST_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("SIMPLE_TEST_CLASS", "Run Phase", UVM_HIGH)

        phase.raise_objection(this);

        // simple sequence
        repeat(50) begin
            `uvm_info("SIMPLE_TEST_CLASS", "Simple Sequence", UVM_LOW)
            seq = register_file_simple_seq::type_id::create("seq");
            seq.start(env.agnt.seqr);
        end
        
        `uvm_info("BASIC_TEST_CLASS", "Reset Sequence", UVM_LOW)
        reset_seq = register_file_reset_seq::type_id::create("reset_seq");
        assert(reset_seq.randomize());
        reset_seq.start(env.agnt.seqr);

        phase.drop_objection(this);
    endtask: run_phase
endclass : simple_register_file_test



//----------------------------------------------------------------
//
// TEST: Basic Test. Tests basic functionality.
//
//----------------------------------------------------------------

class basic_register_file_test extends base_register_file_test;
    `uvm_component_utils(basic_register_file_test)
    register_file_reset_seq reset_seq;
    register_file_init_seq init_seq;
    register_file_direct_seq direct_seq;
    register_file_filler_seq filler_seq;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "basic_register_file_test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("BASIC_TEST_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("BASIC_TEST_CLASS", "Run Phase", UVM_HIGH)

        phase.raise_objection(this);

        // 1.1
        `uvm_info("BASIC_TEST_CLASS", "Reset Sequence", UVM_LOW)
        reset_seq = register_file_reset_seq::type_id::create("reset_seq");
        assert(reset_seq.randomize());
        reset_seq.start(env.agnt.seqr);

        `uvm_info("BASIC_TEST_CLASS", "Direct Sequence", UVM_LOW)
        direct_seq = register_file_direct_seq::type_id::create("direct_seq");
        assert(direct_seq.randomize());
        direct_seq.start(env.agnt.seqr);

        // 1.2
        `uvm_info("BASIC_TEST_CLASS", "Init Sequence", UVM_LOW)
        init_seq = register_file_init_seq::type_id::create("init_seq");
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        `uvm_info("BASIC_TEST_CLASS", "Filler Sequence", UVM_LOW)
        filler_seq = register_file_filler_seq::type_id::create("filler_seq");
        assert(filler_seq.randomize());
        filler_seq.start(env.agnt.seqr);

        `uvm_info("BASIC_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr2 == 12;
            raddr3 == 18;
        });
        direct_seq.start(env.agnt.seqr);

        // 1.3
        `uvm_info("BASIC_TEST_CLASS", "Init Sequence", UVM_LOW)
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        `uvm_info("BASIC_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr0 == 5;
            raddr1 == 12;
            raddr2 == 3;
            raddr3 == 9;
        });
        direct_seq.start(env.agnt.seqr);

        `uvm_info("BASIC_TEST_CLASS", "Filler Sequence", UVM_LOW)
        assert(filler_seq.randomize() with {
            raddr0 == 5;
            raddr1 == 12;
            raddr2 == 3;
            raddr3 == 9;
        });
        filler_seq.start(env.agnt.seqr);

        // 1.4
        `uvm_info("BASIC_TEST_CLASS", "Init Sequence", UVM_LOW)
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        for (int i = 0; i < (1<<ADDR_W); i++) begin
            `uvm_info("BASIC_TEST_CLASS", "Direct Sequence", UVM_LOW)

            assert(direct_seq.randomize() with {
                we1 == 0;
                raddr0 == i;
            });
            direct_seq.start(env.agnt.seqr);
        end

        // 2.1
        `uvm_info("BASIC_TEST_CLASS", "Init Sequence", UVM_LOW)
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        `uvm_info("BASIC_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            we0 == 0;
            we1 == 0;
            raddr0 == 5;
        });
        direct_seq.start(env.agnt.seqr);

        `uvm_info("BASIC_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            we0 == 0;
            raddr1 == 5;
        });
        direct_seq.start(env.agnt.seqr);

        // 2.2
        `uvm_info("BASIC_TEST_CLASS", "Reset Sequence", UVM_LOW)
        assert(reset_seq.randomize());
        reset_seq.start(env.agnt.seqr);

        `uvm_info("BASIC_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize());
        direct_seq.start(env.agnt.seqr);

        `uvm_info("BASIC_TEST_CLASS", "END Sequence", UVM_LOW)
        assert(reset_seq.randomize());
        reset_seq.start(env.agnt.seqr);

        phase.drop_objection(this);
    endtask: run_phase
endclass : basic_register_file_test



//----------------------------------------------------------------
//
// TEST: Edge Test. Tests edge case functionality.
//
//----------------------------------------------------------------

class edge_register_file_test extends base_register_file_test;
    `uvm_component_utils(edge_register_file_test)
    register_file_reset_seq reset_seq;
    register_file_init_seq init_seq;
    register_file_direct_seq direct_seq;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "edge_register_file_test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("EDGE_TEST_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("EDGE_TEST_CLASS", "Run Phase", UVM_HIGH)

        phase.raise_objection(this);

        // 3.1
        `uvm_info("EDGE_TEST_CLASS", "Init Sequence", UVM_LOW)
        init_seq = register_file_init_seq::type_id::create("init_seq");
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        direct_seq = register_file_direct_seq::type_id::create("direct_seq");
        assert(direct_seq.randomize() with {
            we0 == 0;
            we1 == 0;
            raddr0 == 7;
            raddr1 == 7;
            raddr2 == 7;
            raddr3 == 7;
        });
        direct_seq.start(env.agnt.seqr);

        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            we0 == 0;
            raddr0 == 7;
            raddr1 == 7;
            raddr2 == 7;
            raddr3 == 7;
        });
        direct_seq.start(env.agnt.seqr);

        // 3.2
        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr0 == 5;
            raddr1 == 5;
            wdata1 == 'hCAFEBABE;
        });
        direct_seq.start(env.agnt.seqr);

        // 3.3
        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr0 == 5;
            raddr1 == 5;
        });
        direct_seq.start(env.agnt.seqr);

        // 3.4
        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr0 == 0;
            raddr1 == 0;
            raddr2 == 0;
            raddr3 == 0;
        });
        direct_seq.start(env.agnt.seqr);

        `uvm_info("EDGE_TEST_CLASS", "END Sequence", UVM_LOW)
        reset_seq = register_file_reset_seq::type_id::create("reset_seq");
        assert(reset_seq.randomize());
        reset_seq.start(env.agnt.seqr);

        phase.drop_objection(this);
    endtask: run_phase
endclass : edge_register_file_test



//----------------------------------------------------------------
//
// TEST: Complete Test. Tests all functionality.
//
//----------------------------------------------------------------

class complete_register_file_test extends base_register_file_test;
    `uvm_component_utils(complete_register_file_test)
    register_file_simple_seq seq;
    register_file_reset_seq reset_seq;
    register_file_init_seq init_seq;
    register_file_direct_seq direct_seq;
    register_file_filler_seq filler_seq;

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new(string name = "complete_register_file_test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("COMPLETE_TEST_CLASS", "Inside Constructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Run Phase
    //--------------------------------------------
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("COMPLETE_TEST_CLASS", "Run Phase", UVM_HIGH)

        phase.raise_objection(this);

        // 1.1
        `uvm_info("COMPLETE_TEST_CLASS", "Reset Sequence", UVM_LOW)
        reset_seq = register_file_reset_seq::type_id::create("reset_seq");
        assert(reset_seq.randomize());
        reset_seq.start(env.agnt.seqr);

        `uvm_info("COMPLETE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        direct_seq = register_file_direct_seq::type_id::create("direct_seq");
        assert(direct_seq.randomize());
        direct_seq.start(env.agnt.seqr);

        // 1.2
        `uvm_info("COMPLETE_TEST_CLASS", "Init Sequence", UVM_LOW)
        init_seq = register_file_init_seq::type_id::create("init_seq");
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        `uvm_info("COMPLETE_TEST_CLASS", "Filler Sequence", UVM_LOW)
        filler_seq = register_file_filler_seq::type_id::create("filler_seq");
        assert(filler_seq.randomize());
        filler_seq.start(env.agnt.seqr);

        `uvm_info("COMPLETE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr2 == 12;
            raddr3 == 18;
        });
        direct_seq.start(env.agnt.seqr);

        // 1.3
        `uvm_info("COMPLETE_TEST_CLASS", "Init Sequence", UVM_LOW)
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        `uvm_info("COMPLETE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr0 == 5;
            raddr1 == 12;
            raddr2 == 3;
            raddr3 == 9;
        });
        direct_seq.start(env.agnt.seqr);

        `uvm_info("COMPLETE_TEST_CLASS", "Filler Sequence", UVM_LOW)
        assert(filler_seq.randomize() with {
            raddr0 == 5;
            raddr1 == 12;
            raddr2 == 3;
            raddr3 == 9;
        });
        filler_seq.start(env.agnt.seqr);

        // 1.4
        `uvm_info("COMPLETE_TEST_CLASS", "Init Sequence", UVM_LOW)
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        for (int i = 0; i < (1<<ADDR_W); i++) begin
            `uvm_info("COMPLETE_TEST_CLASS", "Direct Sequence", UVM_LOW)

            assert(direct_seq.randomize() with {
                we1 == 0;
                raddr0 == i;
            });
            direct_seq.start(env.agnt.seqr);
        end

        // 2.1
        `uvm_info("COMPLETE_TEST_CLASS", "Init Sequence", UVM_LOW)
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        `uvm_info("COMPLETE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            we0 == 0;
            we1 == 0;
            raddr0 == 5;
        });
        direct_seq.start(env.agnt.seqr);

        `uvm_info("COMPLETE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            we0 == 0;
            raddr1 == 5;
        });
        direct_seq.start(env.agnt.seqr);

        // 2.2
        `uvm_info("COMPLETE_TEST_CLASS", "Reset Sequence", UVM_LOW)
        assert(reset_seq.randomize());
        reset_seq.start(env.agnt.seqr);

        `uvm_info("COMPLETE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize());
        direct_seq.start(env.agnt.seqr);

        // 3.1
        `uvm_info("EDGE_TEST_CLASS", "Init Sequence", UVM_LOW)
        assert(init_seq.randomize());
        init_seq.start(env.agnt.seqr);

        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            we0 == 0;
            we1 == 0;
            raddr0 == 7;
            raddr1 == 7;
            raddr2 == 7;
            raddr3 == 7;
        });
        direct_seq.start(env.agnt.seqr);

        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            we0 == 0;
            raddr0 == 7;
            raddr1 == 7;
            raddr2 == 7;
            raddr3 == 7;
        });
        direct_seq.start(env.agnt.seqr);

        // 3.2
        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr0 == 5;
            raddr1 == 5;
            wdata1 == 'hCAFEBABE;
        });
        direct_seq.start(env.agnt.seqr);

        // 3.3
        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr0 == 5;
            raddr1 == 5;
        });
        direct_seq.start(env.agnt.seqr);

        // 3.4
        `uvm_info("EDGE_TEST_CLASS", "Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr0 == 0;
            raddr1 == 0;
            raddr2 == 0;
            raddr3 == 0;
        });
        direct_seq.start(env.agnt.seqr);

        // 3.5
        `uvm_info("EDGE_TEST_CLASS", "LOOK HERE Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            raddr0 == 5;
            raddr1 == 12;
            raddr2 == 5;
            raddr3 == 12;
            wdata0 == 'hCAFEBAB1;
        });
        direct_seq.start(env.agnt.seqr);

        `uvm_info("EDGE_TEST_CLASS", "LOOK HERE NEG Direct Sequence", UVM_LOW)
        assert(direct_seq.randomize() with {
            wdata0 == 'h8BADF00D;
            wdata1 == 'h8BADF00D;
            raddr0 == 12;
            raddr1 == 5;
            raddr2 == 12;
            raddr3 == 5;
            clock_edge == NEGEDGE;
        });
        direct_seq.start(env.agnt.seqr);

        assert(filler_seq.randomize());
        filler_seq.start(env.agnt.seqr);

        // // Constrained-Random Stimulus Testing
        // seq = register_file_simple_seq::type_id::create("seq");
        // repeat(100) begin
        //     `uvm_info("EDGE_TEST_CLASS", "Simple Sequence", UVM_LOW)
        //     assert(seq.randomize());
        //     seq.start(env.agnt.seqr);
        // end


        // END
        `uvm_info("COMPLETE_TEST_CLASS", "END", UVM_LOW)
        assert(filler_seq.randomize());
        filler_seq.start(env.agnt.seqr);

        phase.drop_objection(this);
    endtask: run_phase
endclass : complete_register_file_test