/*-----------------------------------------------------------------------------------------------
* File Name     :   register_file_tb_top.sv
* Author        :   Kevin Luo
* Date          :   12/08/2025
-------------------------------------------------------------------------------------------------*/

//--------------------------------------------
// Standard Setup
//--------------------------------------------
timeunit 1ns;
timeprecision 100ps;
import uvm_pkg::*;
`include "uvm_macros.svh"

//--------------------------------------------
// Include Files
//--------------------------------------------
import register_file_pkg::*;
import register_file_types_pkg::*;
import register_file_test_pkg::*;
import register_file_seq_pkg::*;
import register_file_agent_pkg::*;
import register_file_env_pkg::*;

module register_file_tb_top;

    //--------------------------------------------
    // Instantiation
    //--------------------------------------------

    // Instatiate clock
    logic clock;

    // Instantiate interface
    register_file_if intf(clock);

    // Instantiate DUT
    register_file dut(
        // Inputs
        .writeAddr0(intf.waddr0),
        .writeAddr1(intf.waddr1),
        .writeData0(intf.wdata0),
        .writeData1(intf.wdata1),

        .writeEn0(intf.we0),
        .writeEn1(intf.we1),
        .clock(intf.clk),
        .resetn(intf.reset),

        .readAddr0(intf.raddr0),
        .readAddr1(intf.raddr1),
        .readAddr2(intf.raddr2),
        .readAddr3(intf.raddr3),

        // Outputs
        .readData0(intf.rdata0),
        .readData1(intf.rdata1),
        .readData2(intf.rdata2),
        .readData3(intf.rdata3)
    );

    //--------------------------------------------
    // Initialization
    //--------------------------------------------

    // Set interface as "vif" in configuration DB for all components
    initial begin
        uvm_config_db #(virtual register_file_if)::set(null, "*", "vif", intf);
    end

    // Start tests
    initial begin
        run_test("complete_register_file_test");
    end

    // Starting the clock
    initial begin
        clock = 0;
        #5;
        forever begin
            clock = ~clock;
            #2;
        end
    end

    // Safety check: terminates simulation after certain amount of clock cycles
    initial begin
        #500000;
        $display("Exceeded max amount of clock cycles! Ending simulation.");
        $finish();
    end

    // Debugging
    initial begin
        uvm_top.set_report_verbosity_level_hier(UVM_MEDIUM);
        // uvm_top.set_report_verbosity_level_hier(UVM_WARNING);
    end


endmodule : register_file_tb_top
