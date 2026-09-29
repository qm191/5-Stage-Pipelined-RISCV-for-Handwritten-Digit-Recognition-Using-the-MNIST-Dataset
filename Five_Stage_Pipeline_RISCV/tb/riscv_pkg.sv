package  riscv_pkg;
	typedef logic [31:0] data_mem_t [0:1023];
	`include "transaction.sv"
	`include "generator.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "scoreboard.sv"
	`include "environment.sv"
endpackage
	