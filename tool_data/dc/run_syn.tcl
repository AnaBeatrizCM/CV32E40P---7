set DESIGN   cv32e40p_core
set RTL      ../rtl
# caminho SAED32
set LIB_PATH /home/marcos.leal/Desktop/Physical_Design_MarcosLeal/CV32E40P/CV32E40P---7/db

set search_path   [list . $LIB_PATH $RTL $RTL/include]
set target_library "saed32rvt_tt0p85v25c.db"   ;# confira o nome exato na sua pasta
set link_library   "* $target_library"

file mkdir results reports
define_design_lib WORK -path ./work

# 1) Ler RTL (pacotes primeiro!)
set BHV $RTL/../bhv

analyze -format sverilog [list \
  $RTL/include/cv32e40p_apu_core_pkg.sv \
  $RTL/include/cv32e40p_fpu_pkg.sv \
  $RTL/include/cv32e40p_pkg.sv \
  $RTL/cv32e40p_if_stage.sv \
  $RTL/cv32e40p_cs_registers.sv \
  $RTL/cv32e40p_register_file_ff.sv \
  $RTL/cv32e40p_load_store_unit.sv \
  $RTL/cv32e40p_id_stage.sv \
  $RTL/cv32e40p_aligner.sv \
  $RTL/cv32e40p_decoder.sv \
  $RTL/cv32e40p_compressed_decoder.sv \
  $RTL/cv32e40p_fifo.sv \
  $RTL/cv32e40p_prefetch_buffer.sv \
  $RTL/cv32e40p_hwloop_regs.sv \
  $RTL/cv32e40p_mult.sv \
  $RTL/cv32e40p_int_controller.sv \
  $RTL/cv32e40p_ex_stage.sv \
  $RTL/cv32e40p_alu_div.sv \
  $RTL/cv32e40p_alu.sv \
  $RTL/cv32e40p_ff_one.sv \
  $RTL/cv32e40p_popcnt.sv \
  $RTL/cv32e40p_apu_disp.sv \
  $RTL/cv32e40p_controller.sv \
  $RTL/cv32e40p_obi_interface.sv \
  $RTL/cv32e40p_prefetch_controller.sv \
  $RTL/cv32e40p_sleep_unit.sv \
  $BHV/cv32e40p_sim_clock_gate.sv \
  $RTL/cv32e40p_core.sv ]

# 2) Elaborar com parâmetros simples (sem FPU, sem extensões PULP)
elaborate $DESIGN -parameters "FPU=0,PULP_XPULP=0,PULP_CLUSTER=0"
current_design $DESIGN
link
check_design > reports/check_design.rpt

# 3) Restrições
source constraints/cv32e40p.sdc

# 4) Síntese
compile_ultra

# 5) Relatórios e saídas
report_timing -max_paths 10 -nworst 1 > reports/timing.rpt
report_constraint -all_violators      > reports/violators.rpt
report_qor                            > reports/qor.rpt
report_area -hierarchy                > reports/area.rpt
report_power                          > reports/power.rpt
check_timing                          > reports/check_timing.rpt

write -format verilog -hierarchy -output results/${DESIGN}_netlist.v
write -format ddc     -hierarchy -output results/${DESIGN}.ddc
write_sdc results/${DESIGN}.sdc
exit
