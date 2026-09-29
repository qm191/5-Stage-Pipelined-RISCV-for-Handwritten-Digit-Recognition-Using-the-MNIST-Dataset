##################################################################################################
# Project: RISC-V Core Verification - TCL Script for QuestaSim/ModelSim
# Execution: Load script with 'do run.do' or 'source run.do'
##################################################################################################

# Danh sách tất cả testcases trong project RISC-V

set TEST_LIST { \
    basic_pass_through_test \
    ALU_store_test          \
    load_use_hazard_test    \
    ALU_forwarding_test     \
    store_data_hazard_test  \
    control_hazard_test     \
    load_then_add_test      \
}

# ------------------------------------------------------------------------------------------------
# 1. Hàm dọn dẹp các file rác / log cũ
# ------------------------------------------------------------------------------------------------
proc clean {} {
    if {[file exists work]} { file delete -force work }
    if {[file exists log]}  { file delete -force log }
    if {[file exists coverage]} { file delete -force coverage }
    foreach f [glob -nocomplain *.log *.wlf *.ucdb transcript compile.log] {
        file delete -force $f
    }
    puts "\[INFO\] Cleaned all build, simulation logs, and coverage files."
}

# ------------------------------------------------------------------------------------------------
# 2. Hàm biên dịch (Compile)
# ------------------------------------------------------------------------------------------------
proc build {} {
    if {![file exists log]} { file mkdir log }
    if {![file exists work]} { 
        vlib work 
        vmap work work
    }
    puts "\[INFO\] Compiling project using compile.f..."
    if {[catch {vlog -coveropt 3 +cover=bcestf -sv -f compile.f} err]} {
        puts "\[ERROR\] Compilation Failed: $err"
    } else {
        puts "\[INFO\] Compilation Successful!"
    }
}

# ------------------------------------------------------------------------------------------------
# 3. Hàm chạy 1 testcase bất kỳ (Có hỗ trợ truyền Seed)
# Cú pháp: run_test <ten_testcase> [seed]
# ------------------------------------------------------------------------------------------------
proc run_test {{test_name "load_then_add_test"} {seed "1"}} {
    if {![file exists log]} { file mkdir log }

    puts "=========================================================================="
    puts "\[INFO\] Running RISC-V Testcase: $test_name | Seed: $seed"
    puts "=========================================================================="

    # Lệnh vsim chỉ định Top Module là tb_top và kích hoạt bài test qua Plusarg +<test_name>
    set cmd "vsim -sv_seed $seed -coverage -coveranalysis -debugDB -l log/${test_name}_${seed}.log -voptargs=+acc -assertdebug -c testbench -do \"coverage save -codeAll -cvg -onexit ${test_name}.ucdb; log -r /*; run -all; exit\" +${test_name}"
    
    eval $cmd
    
    # Tạo liên kết run.log cho bài test vừa chạy
    if {[file exists log/${test_name}_${seed}.log]} {
        file copy -force log/${test_name}_${seed}.log run.log
    }
    puts "\[INFO\] Test execution finished. Log file: log/${test_name}_${seed}.log"
}

# ------------------------------------------------------------------------------------------------
# 4. Hàm chạy toàn bộ danh sách Testcases (Regression)
# ------------------------------------------------------------------------------------------------
proc run_all {} {
    global TEST_LIST
    build
    puts "\n=========================================================================="
    puts "                      STARTING REGRESSION RUN ALL                         "
    puts "=========================================================================="
    foreach t $TEST_LIST {
        puts "\n>>>> Running: $t <<<<"
        run_test $t 1
    }
    puts "\n=========================================================================="
    puts "                     ALL TESTS COMPLETED SUCCESSFULLY                      "
    puts "=========================================================================="
}

# ------------------------------------------------------------------------------------------------
# 5. Hàm xem Waveform giao diện đồ họa GUI
# ------------------------------------------------------------------------------------------------
proc wave {} {
    if {[file exists vsim.wlf]} {
        dataset open vsim.wlf sim_wave
        add wave -r sim_wave:/testbench/*
        radix -hex
        puts "\[INFO\] Loaded waveform successfully."
    } else {
        puts "\[ERROR\] vsim.wlf not found! Please run a test first."
    }
}

# ------------------------------------------------------------------------------------------------
# 6. Hàm xuất Coverage Report dạng Text
# ------------------------------------------------------------------------------------------------
proc gen_cov {} {
    if {![file exists coverage]} { file mkdir coverage }
    set ucdb_files [glob -nocomplain *.ucdb]
    
    if {[llength $ucdb_files] == 0} {
        puts "\[ERROR\] No .ucdb files found! Please run tests (e.g., run_all) first."
        return
    }
    
    puts "\[INFO\] Merging following UCDB files into IP.ucdb: $ucdb_files"
    eval vcover merge IP.ucdb $ucdb_files
    
    puts "\[INFO\] Generating Summary Text Report..."
    vcover report IP.ucdb -output coverage/summary_report.txt
    
    puts "\[INFO\] Generating Detailed Text Report..."
    vcover report -zeros -details -code bcesft -annotate -All -codeAll IP.ucdb -output coverage/detail_report.txt
    
    puts "\[INFO\] Done! Text reports are saved in the 'coverage' folder."
}

# ------------------------------------------------------------------------------------------------
# 7. Hàm xuất Coverage Report dạng HTML
# ------------------------------------------------------------------------------------------------
proc gen_html {} {
    if {![file exists coverage]} { file mkdir coverage }
    set ucdb_files [glob -nocomplain *.ucdb]
    
    if {[llength $ucdb_files] == 0} {
        puts "\[ERROR\] No .ucdb files found! Please run tests (e.g., run_all) first."
        return
    }
    
    puts "\[INFO\] Merging following UCDB files into IP.ucdb: $ucdb_files"
    eval vcover merge IP.ucdb $ucdb_files
    
    puts "\[INFO\] Generating HTML Report..."
    vcover report -zeros -details -code bcesft -annotate -testhitdataAll -html -htmldir coverage/html_report IP.ucdb
    
    puts "\[INFO\] Done! Open 'coverage/html_report/index.html' in your browser to view."
}

# ------------------------------------------------------------------------------------------------
# 8. Hàm trợ giúp Hướng dẫn các lệnh
# ------------------------------------------------------------------------------------------------
proc help {} {
    puts "=========================================================================="
    puts "                       RISC-V CORE TCL SCRIPT HELP                        "
    puts "=========================================================================="
    puts "  build                  : Compile all SV files listed in compile.f"
    puts "  run_test <test_name>   : Run a specific testcase (e.g., run_test load_weight_input_test)"
    puts "  run_all                : Build and run ALL testcases sequentially"
    puts "  wave                   : Open wave viewer GUI for tb_top"
    puts "  gen_cov                : Merge .ucdb files & generate Text Coverage Reports"
    puts "  gen_html               : Merge .ucdb files & generate HTML Coverage Report"
    puts "  clean                  : Delete compiled libraries, logs, and coverage files"
    puts "  help                   : Display this help menu"
    puts "=========================================================================="
}

# Thông báo khi nạp script thành công
help