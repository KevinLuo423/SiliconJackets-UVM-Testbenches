package register_file_env_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import register_file_pkg::*;
  import register_file_types_pkg::*;
  import register_file_seq_pkg::*;
  import register_file_agent_pkg::*;
  `include "register_file_collector.sv"
  `include "register_file_sb.sv"
  `include "register_file_env.sv"

endpackage : register_file_env_pkg
