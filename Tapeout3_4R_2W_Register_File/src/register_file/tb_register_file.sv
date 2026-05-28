module tb_register_file import register_file_pkg::*; ();

    // Generate the clock
    localparam CLK_PERIOD = 20; // Clock Period is at 20ns
    localparam DUTY_CYCLE = 0.5;
    // Define Clock Logic Value
    logic clock_tb;
    
    initial begin
	forever // Run the clock forever
	begin		
		#(CLK_PERIOD*DUTY_CYCLE) clock_tb = 1'b1; // wait duty cycle then set clock high
		#(CLK_PERIOD*DUTY_CYCLE) clock_tb = 1'b0; // wait duty cycle then set clock low
	end
	end

    // Input Wires
    logic resetn_tb;   // global reset
    logic [ADDR_W-1:0] readAddr0_tb, readAddr1_tb, readAddr2_tb, readAddr3_tb;  // input read addresses
    logic [ADDR_W-1:0] writeAddr0_tb, writeAddr1_tb;  // input write addresses
    logic [DATA_W-1:0] writeData0_tb, writeData1_tb; // input write data
    logic writeEn0_tb, writeEn1_tb;

    // Output Wires
    logic [DATA_W-1:0] readData0_tb, readData1_tb, readData2_tb, readData3_tb; // input write data

    // Instantiate a register file to test
    register_file DUT (
        .writeAddr0         (writeAddr0_tb),
        .writeAddr1         (writeAddr1_tb),
        .writeData0         (writeData0_tb),
        .writeData1         (writeData1_tb),
        .writeEn0           (writeEn0_tb),
        .writeEn1           (writeEn1_tb),
        .clock              (clock_tb),
        .resetn             (resetn_tb),
        .readAddr0          (readAddr0_tb),
        .readAddr1          (readAddr1_tb),
        .readAddr2          (readAddr2_tb),
        .readAddr3          (readAddr3_tb),
        .readData0          (readData0_tb),
        .readData1          (readData1_tb),
        .readData2          (readData2_tb),
        .readData3          (readData3_tb)
    ) ;

    initial begin
        // These two lines just allow visibility of signals in the simulation
        $shm_open("waves.shm");
        $shm_probe("AC");
        $display("\n--------------Beginning Simulation!--------------\n");
        $display("Time: %t", $time);
        @(posedge clk_tb);
        initialize_signals();
        #1000

        // Insert test sequence here or something
        
        #1000
        $display("\n-------------Finished Simulation!----------------\n");
        $display("Time: %t", $time);
        $writememb("memory_contents.txt", DUT.regs.Registers);
        $finish;
    end

    // Task to set the initial state of the signals. Task is called up above
    task initialize_signals();
    begin
        $display("--------------Initializing Signals---------------\n");
        $display("Time: %t", $time);
        reset_tb            = 1'b0;
        readAddr0_tb        = 5'b00000;
        readAddr1_tb        = 5'b00000;
        readAddr2_tb        = 5'b00000;
        readAddr3_tb        = 5'b00000;
        writeAddr0_tb       = 5'b00000;
        writeAddr1_tb       = 5'b00000;
        writeData0_tb       = 32'b00000000000000000000000000000000;
        writeData1_tb       = 32'b00000000000000000000000000000000;
        writeEn0_tb         = 1'b0;
        writeEn1_tb         = 1'b0;
        @(posedge clk_tb);
        reset_tb              = 1'b1;
    end
    endtask
	
endmodule 
