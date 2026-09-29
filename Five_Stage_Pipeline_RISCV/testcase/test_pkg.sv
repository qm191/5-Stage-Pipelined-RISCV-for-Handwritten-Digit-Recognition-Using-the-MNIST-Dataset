package test_pkg;
    import riscv_pkg::*;

    // 1. Base Class 
    `include "base_test.sv"

    // 2. Test Scenarios
    `include "basic_pass_through_test.sv"
    `include "ALU_store_test.sv"
    `include "load_use_hazard_test.sv"
    `include "ALU_forwarding_test.sv"
    `include "store_data_hazard_test.sv"
    `include "control_hazard_test.sv"
    `include "load_then_add_test.sv"

endpackage : test_pkg