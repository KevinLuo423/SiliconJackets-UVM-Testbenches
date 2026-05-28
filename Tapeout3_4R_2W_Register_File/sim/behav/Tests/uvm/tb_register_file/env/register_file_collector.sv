/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_collector.sv
* Author        :   Kevin Luo
* Date          :   02/13/2026

    Coverage collector for register file.
-------------------------------------------------------------------------------------------------*/
class register_file_collector extends uvm_subscriber#(register_file_seq_item);
    `uvm_component_utils(register_file_collector)

    // uvm_analysis_imp #(register_file_seq_item, register_file_collector) cvg_port;       // Since this class extends UVM subscriber, we don't need to create an analysis port
    register_file_seq_item item;
    
    //--------------------------------------------
    // Coverage Group
    //--------------------------------------------
    covergroup register_file_cg;
        // Options control how the coverage engine (Xcelium) reports the data
        option.per_instance = 1;
        option.name = "Register_File_4R2W_Coverage";

        // Empty brackets [] create a separate bin for every value in the range
        
        // 5.1 Read Ports
        cp_raddr0: coverpoint item.raddr0 { bins all_regs[] = {[0:31]}; }
        cp_raddr1: coverpoint item.raddr1 { bins all_regs[] = {[0:31]}; }
        cp_raddr2: coverpoint item.raddr2 { bins all_regs[] = {[0:31]}; }
        cp_raddr3: coverpoint item.raddr3 { bins all_regs[] = {[0:31]}; }

        // 5.2 Write Ports
        cp_waddr0: coverpoint item.waddr0 { bins all_regs[] = {[0:31]}; }
        cp_waddr1: coverpoint item.waddr1 { bins all_regs[] = {[0:31]}; }

        // Crosses create a bin for every single combination of coverpoints or let you use {} to make custom cross bins

        // 5.3 Write Enables
        cp_we0: coverpoint item.we0;
        cp_we1: coverpoint item.we1;
        cross_write_enables: cross cp_we0, cp_we1;

        // 5.4 Write-After-Write (WAW) otherwise known as write collision or simultaneous writes
        cross_WAW: cross cp_waddr0, cp_waddr1, cp_we0, cp_we1 {
            // Tells tool to NOT automatically create a bin for every single combination (cap the # of bins it can make at 0)
            option.cross_auto_bin_max = 0;
            
            bins simulatenous_writes = cross_WAW with (cp_waddr0 == cp_waddr1);

        }

        // 5.5 Read-After-Write (RAW) in the same cycle
        // Coverpoint is composed of ternary operators that result in the address that the RAW is affecting
        cp_RAW: coverpoint (
            (item.we0 && (item.waddr0 == item.raddr0 || item.waddr0 == item.raddr1 || item.waddr0 == item.raddr2 || item.waddr0 == item.raddr3)) ? item.waddr0 :
            (item.we1 && (item.waddr1 == item.raddr0 || item.waddr1 == item.raddr1 || item.waddr1 == item.raddr2 || item.waddr1 == item.raddr3)) ? item.waddr1 : -1
        ) {
            // creates exactly 32 bins (one per register)
            bins all_regs[] = { [0:31] };
        }

        // 5.6 Concurrent read
        cross_concurrent_read: cross cp_raddr0, cp_raddr1, cp_raddr2, cp_raddr3 {
            // Tells tool to NOT automatically create a bin for every single combination (cap the # of bins it can make at 0)
            option.cross_auto_bin_max = 0;

            bins simulatenous_reads = cross_concurrent_read with (cp_raddr0 == cp_raddr1 && cp_raddr0 == cp_raddr2 && cp_raddr0 == cp_raddr3);
        }

        // 5.7 Reset
        cp_reset: coverpoint item.reset;
    endgroup

    //--------------------------------------------
    // Constructor
    //--------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name, parent);

        item = register_file_seq_item::type_id::create("item");
        register_file_cg = new();
        `uvm_info("CVG_CLASS", "Inside Constsructor", UVM_HIGH)
    endfunction: new

    //--------------------------------------------
    // Build Phase
    //--------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("CVG_CLASS", "Build Phase", UVM_HIGH)
    endfunction: build_phase

    //--------------------------------------------
    // Write Function
    //--------------------------------------------
    function void write(register_file_seq_item t);

        // Copies broadcasted transaction into item
        item.copy(t);
        // Updates bins using that transaction
        register_file_cg.sample();
    endfunction: write

    function void report_phase(uvm_phase phase);
        real total_cov;
        real raddr0_cov, raddr1_cov, raddr2_cov, raddr3_cov;
        real waddr0_cov, waddr1_cov, wdata0_cov;
        real we0_cov, we1_cov, x_we_cov;
        real x_WAW_cov;
        real RAW_cov;
        real x_concurrent_read_cov;
        real reset_cov;

        super.report_phase(phase);
        
        total_cov             = register_file_cg.get_inst_coverage();
        raddr0_cov            = register_file_cg.cp_raddr0.get_inst_coverage();
        raddr1_cov            = register_file_cg.cp_raddr1.get_inst_coverage();
        raddr2_cov            = register_file_cg.cp_raddr2.get_inst_coverage();
        raddr3_cov            = register_file_cg.cp_raddr3.get_inst_coverage();
        waddr0_cov            = register_file_cg.cp_waddr0.get_inst_coverage();
        waddr1_cov            = register_file_cg.cp_waddr1.get_inst_coverage();
        we0_cov               = register_file_cg.cp_we0.get_inst_coverage();
        we1_cov               = register_file_cg.cp_we1.get_inst_coverage();
        x_we_cov              = register_file_cg.cross_write_enables.get_inst_coverage();
        x_WAW_cov             = register_file_cg.cross_WAW.get_inst_coverage();
        RAW_cov               = register_file_cg.cp_RAW.get_inst_coverage();
        x_concurrent_read_cov = register_file_cg.cross_concurrent_read.get_inst_coverage();
        reset_cov             = register_file_cg.cp_reset.get_inst_coverage();


        `uvm_info("CVG_REPORT", $sformatf({
            "\n==================================================\n",
            "         REGISTER FILE COVERAGE SUMMARY        \n",
            "==================================================\n",
            " OVERALL TOTAL       : %6.2f%%\n",
            "--------------------------------------------------\n",
            " Read Addr 0         : %6.2f%%\n",
            " Read Addr 1         : %6.2f%%\n",
            " Read Addr 2         : %6.2f%%\n",
            " Read Addr 3         : %6.2f%%\n",
            "--------------------------------------------------\n",
            " Write Addr 0        : %6.2f%%\n",
            " Write Addr 1        : %6.2f%%\n",
            "--------------------------------------------------\n",
            " Write Enable 0      : %6.2f%%\n",
            " Write Enable 1      : %6.2f%%\n",
            " Write Enable Cross  : %6.2f%%\n",
            "--------------------------------------------------\n",
            " Write-After-Write   : %6.2f%%\n",
            " Read-After-Write    : %6.2f%%\n",
            " Concurrent Read     : %6.2f%%\n",
            "--------------------------------------------------\n",
            " Reset               : %6.2f%%\n",
            "=================================================="
        }, 
        total_cov, 
        raddr0_cov, raddr1_cov, raddr2_cov, raddr3_cov, 
        waddr0_cov, waddr1_cov, 
        we0_cov, we1_cov, 
        x_we_cov,
        x_WAW_cov, 
        RAW_cov,
        x_concurrent_read_cov,
        reset_cov), UVM_NONE)
        
    endfunction

endclass