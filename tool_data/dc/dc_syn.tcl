# ----------------------------------------------------------------------
# Copyright (c) 2026 VIRTUS CC-UFCG. All rights reserved
# VIRTUS CC-UFCG Confidential Proprietary
# 
# Use, copy or distribuition of this code is not allowed without
# VIRTUS CC-UFCG explicit written consent.
# ----------------------------------------------------------------------
#
# Id: dc_syn.v_2026-11-05_by_AnaBeatrizMarinho
#
# Project: 		CI Expert 2026
# Description:	Tamplate to Logic Syntesis
# ----------------------------------------------------------------------

########################################################################
########################################################################
############################ DC SETUP ##################################
########################################################################
########################################################################

########################################################################
# User variables setup
########################################################################

# Design name
set DESIGN      "cv32e40p"

# Project directories
set PRJT_BASE   "/home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7"

set DB_DIR      "${PRJT_BASE}/db"
set RTL_DIR     "${PRJT_BASE}/rtl"
set OUT_DIR     "${PRJT_BASE}/outputs"
set RPT_DIR     "${PRJT_BASE}/rpt"


# Optional directories
set SDC_DIR     "${PRJT_BASE}/constraints"
#set UPF_DIR     "${PRJT_BASE}/upf"

########################################################################
# Create output directories
########################################################################

set PRE_LAYOUT "${RPT_DIR}/preLayout"

########################################################################
# Work library
########################################################################

define_design_lib WORK -path ./WORK

########################################################################
# Multicore setup
########################################################################

set_host_options -max_cores 8

########################################################################
# Library setup
########################################################################

# Search path
set search_path "$DB_DIR $RTL_DIR"

# Target libraries
set target_library [glob ${DB_DIR}/*.db]

# Synthetic library
set synthetic_library ""

# Link library
set link_library "* $target_library $synthetic_library"

########################################################################
# HDL setup
########################################################################

# More detailed messages during elaboration
set hdlin_reporting_level comprehensive

# Treat always blocks with set/reset as synchronous when applicable
set hdlin_ff_always_sync_set_reset true

# Warning/error control for inferred latches
set_app_var hdlin_check_no_latch true

########################################################################
# SVF setup for Formality
########################################################################

set_svf ${OUT_DIR}/${DESIGN}.svf

# Enable hierarchical guide map flow
set_app_var hdlin_enable_hier_map true


########################################################################
########################################################################
############################ READ RTL ##################################
########################################################################
########################################################################

# Option 1: Read RTL using filelist
#analyze -f verilog -vcs "-verilog +libext+.v +libext+.sv -f ${RTL_DIR}/file.f" -work WORK

# Option 2: Read RTL files manually
######## ATUALIZAR FILES
analyze -format verilog ${RTL_DIR}/Register.v
analyze -format	verilog ${RTL_DIR}/Register_Pipeline_Simple.v
analyze -format	verilog ${RTL_DIR}/Width_Adjuster.v
analyze -format	verilog ${RTL_DIR}/CarryIn_Binary.v
analyze -format	verilog ${RTL_DIR}/Adder_Subtractor_Binary.v
analyze -format	verilog ${RTL_DIR}/Counter_Binary.v
analyze -format	verilog ${RTL_DIR}/clock_switchover.v


# Elaborate top design
elaborate ${DESIGN}

# Set current design
current_design ${DESIGN}

########################################################################
# SVF flow commands
########################################################################

set_verification_top

########################################################################
# Link and uniquify
########################################################################

link
uniquify


########################################################################
########################################################################
########################## CONSTRAINTS #################################
########################################################################
########################################################################

# Load SDC constraints
# Prefer source when the SDC contains Tcl commands
# source ${SDC_DIR}/${DESIGN}.sdc

# If you do not have an SDC yet, you may generate a temporary one
write_sdc ${OUT_DIR}/${DESIGN}_initial.sdc

########################################################################
# Check design before synthesis
########################################################################

list_designs
current_design ${DESIGN}


########################################################################
########################################################################
######################## PRE-COMPILE REPORTS ###########################
########################################################################
########################################################################

set STAGE "01_precompile"
file mkdir ${RPT_DIR}/${STAGE}

check_design  > ${RPT_DIR}/${STAGE}/${DESIGN}_check_design.rpt
check_timing  > ${RPT_DIR}/${STAGE}/${DESIGN}_check_timing.rpt
report_clock  > ${RPT_DIR}/${STAGE}/${DESIGN}_report_clock.rpt

# Save unmapped/generic design
write_file -format ddc -hier -out ${OUT_DIR}/${DESIGN}_gtech.ddc


########################################################################
########################################################################
############################ COMPILE ###################################
########################################################################
########################################################################

# Avoid assign statements in the mapped netlist
set_fix_multiple_port_nets -all -buffer_constants [all_designs]

# First compile
compile_ultra -incremental -no_autoungroup


########################################################################
# Reports after first compile
########################################################################

set STAGE "02_compile"
file mkdir ${RPT_DIR}/${STAGE}

report_timing                       > ${RPT_DIR}/${STAGE}/${DESIGN}_report_timing.rpt
report_qor                          > ${RPT_DIR}/${STAGE}/${DESIGN}_report_qor.rpt
report_area -designware             > ${RPT_DIR}/${STAGE}/${DESIGN}_report_area_dw.rpt
report_area -hierarchy -nosplit     > ${RPT_DIR}/${STAGE}/${DESIGN}_report_area_hierarchy.rpt
report_power -verbose               > ${RPT_DIR}/${STAGE}/${DESIGN}_report_power.rpt
report_clock_gating                 > ${RPT_DIR}/${STAGE}/${DESIGN}_report_clock_gating.rpt
analyze_datapath                    > ${RPT_DIR}/${STAGE}/${DESIGN}_analyze_datapath.rpt


########################################################################
########################################################################
######################## INCREMENTAL COMPILE ###########################
########################################################################
########################################################################

compile_ultra -incremental -no_autoungroup

set STAGE "03_incrcompile"
file mkdir ${RPT_DIR}/${STAGE}

report_timing                       > ${RPT_DIR}/${STAGE}/${DESIGN}_report_timing.rpt
report_qor                          > ${RPT_DIR}/${STAGE}/${DESIGN}_report_qor.rpt
report_power -verbose               > ${RPT_DIR}/${STAGE}/${DESIGN}_report_power.rpt
report_clock_gating                 > ${RPT_DIR}/${STAGE}/${DESIGN}_report_clock_gating.rpt


########################################################################
########################################################################
######################## AREA OPTIMIZATION #############################
########################################################################
########################################################################

optimize_netlist -area -no_boundary_optimization

set STAGE "04_optnetlist"
file mkdir ${RPT_DIR}/${STAGE}

report_timing                       > ${RPT_DIR}/${STAGE}/${DESIGN}_report_timing.rpt
report_qor                          > ${RPT_DIR}/${STAGE}/${DESIGN}_report_qor.rpt
report_power -verbose               > ${RPT_DIR}/${STAGE}/${DESIGN}_report_power.rpt
report_clock_gating                 > ${RPT_DIR}/${STAGE}/${DESIGN}_report_clock_gating.rpt


########################################################################
########################################################################
######################## SAVE DESIGN ###################################
########################################################################
########################################################################

# Save mapped design
write_file -format ddc     -hier -out ${OUT_DIR}/${DESIGN}.ddc
write_file -format verilog -hier -out ${OUT_DIR}/${DESIGN}.v

# Save constraints
write_sdc ${OUT_DIR}/${DESIGN}.sdc

# Save SDF
write_sdf ${OUT_DIR}/${DESIGN}.sdf
exec gzip -f ${OUT_DIR}/${DESIGN}.sdf

# Save parasitics only if running in topographical mode
if {[shell_is_in_topographical_mode]} {
    write_parasitics -format reduced -out ${OUT_DIR}/${DESIGN}_mapped.spf
}


########################################################################
########################################################################
######################## FINAL REPORTS #################################
########################################################################
########################################################################

set STAGE "05_final"
file mkdir ${RPT_DIR}/${STAGE}

# General checks
check_design                        > ${RPT_DIR}/${STAGE}/${DESIGN}_check_design.rpt
check_timing                        > ${RPT_DIR}/${STAGE}/${DESIGN}_check_timing.rpt

# Timing reports
report_constraint -all_violators -significant_digits 4 \
                                    > ${RPT_DIR}/${STAGE}/${DESIGN}_constraints_violators.rpt

report_timing -significant_digits 4 \
                                    > ${RPT_DIR}/${STAGE}/${DESIGN}_report_timing_setup.rpt

report_timing -delay_type min -significant_digits 4 \
                                    > ${RPT_DIR}/${STAGE}/${DESIGN}_report_timing_hold.rpt

# QoR reports
report_qor -significant_digits 4    > ${RPT_DIR}/${STAGE}/${DESIGN}_report_qor.rpt
report_clock_gating                 > ${RPT_DIR}/${STAGE}/${DESIGN}_report_clock_gating.rpt
report_disable_timing               > ${RPT_DIR}/${STAGE}/${DESIGN}_report_disable_timing.rpt

# Area and power
report_area -designware             > ${RPT_DIR}/${STAGE}/${DESIGN}_report_area_dw.rpt
report_area -hierarchy -nosplit     > ${RPT_DIR}/${STAGE}/${DESIGN}_report_area_hierarchy.rpt
report_power -hierarchy -verbose    > ${RPT_DIR}/${STAGE}/${DESIGN}_report_power.rpt

# Cells
report_cell                         > ${RPT_DIR}/${STAGE}/${DESIGN}_report_cell.rpt


########################################################################
########################################################################
######################## LATCH REPORT ##################################
########################################################################
########################################################################

echo " " > ${RPT_DIR}/${STAGE}/${DESIGN}_latch_inferred.rpt

redirect -tee ${RPT_DIR}/${STAGE}/${DESIGN}_latch_inferred.rpt -append {
    echo "**********************************"
    echo "* Inferred Latches Report"
    echo "* Design Name: $DESIGN"
    echo "**********************************"
    echo " "

    echo "${DESIGN} has [sizeof_collection [all_registers -level_sensitive]] latches"
    echo " "

    if {[sizeof_collection [all_registers -level_sensitive]] > 0} {
        foreach instance [get_object_name [all_registers -level_sensitive]] {
            echo "Latch instance name: $instance -> latch cell name: [get_attr $instance ref_name]"
        }
    }
}


########################################################################
########################################################################
######################## CLOSE SVF #####################################
########################################################################
########################################################################

set_svf -append ${OUT_DIR}/${DESIGN}.svf


########################################################################
########################################################################
############################ EXIT ######################################
########################################################################
########################################################################

echo "*********************************************************************************"
puts "Logic synthesis for ${DESIGN} has been completed."
echo "*********************************************************************************"

# exit
