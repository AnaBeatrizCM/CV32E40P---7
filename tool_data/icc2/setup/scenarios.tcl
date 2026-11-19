# -------------------------------------------------------------------------------------
# Copyright (c) 2026 VIRTUS CC-UFCG. All rights reserved
# VIRTUS CC-UFCG Confidential Proprietary
# 
# Use, copy or distribuition of this code is not allowed without
# VIRTUS CC-UFCG explicit written consent.
# -------------------------------------------------------------------------------------
#
# Id: scenarios.tcl_2026-11-19_by_AnaBeatrizMarinho
#
# Project: 		Ci Expert - UFCG
# Description:	Mode, Corner and Scenarios creation.
#                Analysis settings for scenarios:
#                * Setup: all or WCCOM/SS
#                * Hold : all or WCCOM/SS, BCCOM/FF
#                * Dynamic power: all
#                * Leakage power: all
#                * cornerNames --> found in 'operating_conditions' property of a liberty file (.lib) 
#                                  nomenclature: <operating_conditions>_<temperature>_<voltage>
#                                  ex.: NCCOM_25c_1p8v or WCLCOM_m40c_1p62v                  
#                * library --> found in the 'library' property of a liberty file (.lib)
# -------------------------------------------------------------------------------------


# Cleanup any previous mode, corner and scenario definitions
remove_scenarios -all
remove_modes     -all
remove_corners   -all

########################################
# Create modes
# set modeNames [list func_slow func_typ func_fast]
# foreach modeName $modeNames {
#     create_mode $modeName
# }

set modeNames [list  func]
foreach modeName $modeNames {
    create_mode $modeName
}

########################################
# Create corners
# set cornerNames [list corner_tt SS125_1P08 TT25_1P20]
# foreach cornerName $cornerNames {
#     create_corner $cornerName
# }

set cornerNames [list corner_tt corner_ff corner_ss]
foreach cornerName $cornerNames {
    create_corner $cornerName
}

#------------ Corner FF ------------------------------------------
 current_corner corner_ff
 set_operating_conditions -analysis_type on_chip_variation \
                          -library saed32rvt_ff0p95v25c

 set_pvt_configuration    -clear_filter all \
                          -add \
                          -name rule1 -process_label func_ff \
                          -process_numbers {1} \
                          -voltages 0.95 \
                          -temperatures 25

 read_parasitic_tech         -sanity_check advanced \
                             -tlup ${TLUPLUS_MIN_FILE} \
                             -layermap ${TLUPLUS_MAP_FILE} \
                             -name minTLU

 set_parasitic_parameters    -corners corner_ff \
                             -early_spec minTLU \
                             -early_temperature -40 \
                             -late_spec  minTLU \
                             -late_temperature -40 \
                             -library ${DESIGN}.dlib

#------------ Corner SS ------------------------------------------
 current_corner corner_ss
 set_operating_conditions -analysis_type on_chip_variation \
                          -library saed32rvt_ss0p75v125c
 set_pvt_configuration -clear_filter all \
                       -add \
                       -name rule2 \
                       -process_label func_ss \
                       -process_numbers {1} \
                       -voltages 0.75 \
                       -temperatures 125

 read_parasitic_tech -sanity_check advanced \
                     -tlup ${TLUPLUS_MAX_FILE} \
                     -layermap ${TLUPLUS_MAP_FILE} \
                     -name maxTLU

 set_parasitic_parameters -corners corner_ss \
                          -early_spec maxTLU \
                          -early_temperature 125 \
                          -late_spec maxTLU \
                          -late_temperature 125 \
                          -library ${DESIGN}.dlib

#------------ Corner TT ------------------------------------------
current_corner corner_tt
set_operating_conditions -analysis_type on_chip_variation \
                         -library saed32rvt_tt0p85v25c

set_pvt_configuration -clear_filter all \
                      -add \
                      -name rule3 \
                      -process_label func_tt \
                      -process_numbers {1} \
                      -voltages 0.85 \
                      -temperatures 25

read_parasitic_tech         -sanity_check advanced \
                            -tlup ${TLUPLUS_TYP_FILE} \
                            -layermap ${TLUPLUS_MAP_FILE} \
                            -name typTLU

set_parasitic_parameters    -corners corner_tt \
                            -early_spec typTLU \
                            -early_temperature 25 \
                            -late_spec  typTLU \
                            -late_temperature 25 \
                            -library ${DESIGN}.dlib

########################################
# CREATE SCENARIOS: COMBINE MODES AND CORNERS
# Scnearios are combinations of modes and corners and are created using <create_scenario>
# command. Scenarios determine which timing and power analyses are performed.

create_scenario -name func_ff -mode func -corner corner_ff
create_scenario -name func_ss -mode func -corner corner_ss
create_scenario -name func_tt -mode func -corner corner_tt

# Use the set_scenario_status command to enable or disable specific analysis types (such as setup,
# hold, or power) for each scenario.

set_scenario_status func_ff -setup true \
                       -hold true \
                       -max_capacitance true \
                       -min_capacitance true \
                       -max_transition true 

set_scenario_status func_ss -setup true \
                       -hold true \
                       -max_capacitance true \
                       -min_capacitance true \
                       -max_transition true 

set_scenario_status func_tt -setup true \
                       -hold true \
                       -max_capacitance true \
                       -min_capacitance true \
                       -max_transition true 


report_scenarios -all > ${RPT_DIR}/${DESIGN}_report_scenarios.rpt

########################################
# Load Scenario specific constraints and Settings
########################################

current_scenario func_ff
source ${PRJT_BASE}/constraints/cv32e40p_core.sdc

current_scenario func_ss
source ${PRJT_BASE}/constraints/cv32e40p_core.sdc

current_scenario func_tt
source ${PRJT_BASE}/constraints/cv32e40p_core.sdc

###############################################################################
# General output settings
###############################################################################
# Removes duplicate Scenarios, Modes and Corners for the current block
remove_duplicate_timing_contexts

# Generates a TCL script to check the constraints of each mode, corner and scenario
write_script -force -output ${OUT_DIR}/${DESIGN}_wscript

# Write SDC to check the loaded constraints
write_sdc    -output ${OUT_DIR}/write_sdc_${DESIGN}.sdc

###############################################################################
# Checks and reports
###############################################################################

# exec mkdir ${RPT_DIR}/${DESIGN_STAGE}
check_timing    > ${RPT_DIR}/check_timing.rpt

# set scenarioNames [list bc wc tc]
set scenarioNames [list func_ff func_ss func_tt]
foreach scenario $scenarioNames {
    current_scenario $scenario
    report_exceptions        > ${RPT_DIR}/${DESIGN}_report_exceptions_$scenario.rpt
    report_case_analysis     > ${RPT_DIR}/${DESIGN}_report_case_analysis_$scenario.rpt
    report_disable_timing    > ${RPT_DIR}/${DESIGN}_report_disable_timing_$scenario.rpt
}

report_scenarios > ${RPT_DIR}/${DESIGN}_report_scenarios_2.rpt

###############################################################################
# Finish Scenarios Definitions
###############################################################################
echo "*****************************************************************************************"
echo "*****************************************************************************************"
puts "\[VIRTUS-CC\] INFO: The Scenarios (MCMM) Definitions for the ${DESIGN} has been completed."
echo "*****************************************************************************************"
echo "*****************************************************************************************"

