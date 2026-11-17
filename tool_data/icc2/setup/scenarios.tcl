# -------------------------------------------------------------------------------------
# Copyright (c) 2026 VIRTUS CC-UFCG. All rights reserved
# VIRTUS CC-UFCG Confidential Proprietary
# 
# Use, copy or distribuition of this code is not allowed without
# VIRTUS CC-UFCG explicit written consent.
# -------------------------------------------------------------------------------------
#
# Id: scenarios.tcl_2026-05-04_by_LuizHenriqueNascimento
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

set modeNames [list  <name of the mode>]
foreach modeName $modeNames {
    create_mode $modeName
}

########################################
# Create corners
# set cornerNames [list FFm40_1P32 SS125_1P08 TT25_1P20]
# foreach cornerName $cornerNames {
#     create_corner $cornerName
# }

set cornerNames [list <name of the mode>]
foreach cornerName $cornerNames {
    create_corner $cornerName
}

#------------ Corner FF ------------------------------------------
# current_corner FFm40_1P32
# set_operating_conditions -analysis_type on_chip_variation \
#                          -library tcbn65lplt_ccs

# set_pvt_configuration    -clear_filter all \
#                          -add \
#                          -name rule1 -process_label bc \
#                          -process_numbers {1} \
#                          -voltages 1.32 \
#                          -temperatures -40

# read_parasitic_tech         -sanity_check advanced \
#                             -tlup ${TLUPLUS_MIN_FILE} \
#                             -layermap ${TLUPLUS_MAP_FILE} \
#                             -name minTLU

# set_parasitic_parameters    -corners FFm40_1P32 \
#                             -early_spec minTLU \
#                             -early_temperature -40 \
#                             -late_spec  minTLU \
#                             -late_temperature -40 \
#                             -library ${DESIGN}_icc2.dlib

#------------ Corner SS ------------------------------------------
# current_corner SS125_1P08
# set_operating_conditions -analysis_type on_chip_variation \
#                          -library tcbn65lpwc_ccs

# set_pvt_configuration -clear_filter all \
#                       -add \
#                       -name rule2 \
#                       -process_label wc \
#                       -process_numbers {1} \
#                       -voltages 1.08 \
#                       -temperatures 125

# read_parasitic_tech -sanity_check advanced \
#                     -tlup ${TLUPLUS_MAX_FILE} \
#                     -layermap ${TLUPLUS_MAP_FILE} \
#                     -name maxTLU

# set_parasitic_parameters -corners SS125_1P08 \
#                          -early_spec maxTLU \
#                          -early_temperature 125 \
#                          -late_spec maxTLU \
#                          -late_temperature 125 \
#                          -library ${DESIGN}_icc2.dlib

#------------ Corner TT ------------------------------------------
current_corner <set name of the corner TT here>
set_operating_conditions -analysis_type on_chip_variation \
                         -library <name of the .db>

set_pvt_configuration -clear_filter all \
                      -add \
                      -name rule3 \
                      -process_label <name of the process> \
                      -process_numbers {1} \
                      -voltages <Voltage> \
                      -temperatures <temp>

read_parasitic_tech         -sanity_check advanced \
                            -tlup ${TLUPLUS_TYP_FILE} \
                            -layermap ${TLUPLUS_MAP_FILE} \
                            -name typTLU

set_parasitic_parameters    -corners <name of the corner> \
                            -early_spec typTLU \
                            -early_temperature 25 \
                            -late_spec  typTLU \
                            -late_temperature 25 \
                            -library ${DESIGN}.dlib

########################################
# CREATE SCENARIOS: COMBINE MODES AND CORNERS
# Scnearios are combinations of modes and corners and are created using <create_scenario>
# command. Scenarios determine which timing and power analyses are performed.

# create_scenario -name bc -mode func_fast -corner FFm40_1P32
# create_scenario -name wc -mode func_slow -corner SS125_1P08
create_scenario -name <name of the process> -mode <name of the mode> -corner <name of the corner>

# Use the set_scenario_status command to enable or disable specific analysis types (such as setup,
# hold, or power) for each scenario.

# set_scenario_status bc -setup true \
#                        -hold true \
#                        -max_capacitance true \
#                        -min_capacitance true \
#                        -max_transition true 

# set_scenario_status wc -setup true \
#                        -hold true \
#                        -max_capacitance true \
#                        -min_capacitance true \
#                        -max_transition true 

set_scenario_status <name of the process> -setup true \
                       -hold true \
                       -max_capacitance true \
                       -min_capacitance true \
                       -max_transition true 


report_scenarios -all > ${RPT_DIR}/${DESIGN}_report_scenarios.rpt

########################################
# Load Scenario specific constraints and Settings
########################################

# current_scenario bc
# source ${PRJT_BASE}/../outputs/cnn_wb_top.sdc

# current_scenario wc
# source ${PRJT_BASE}/../outputs/cnn_wb_top.sdc

current_scenario <name of the scenario>
source ${PRJT_BASE}/../outputs/cnn_wb_top.sdc

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
set scenarioNames [list <name of the scenario>]
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

