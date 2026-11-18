# -------------------------------------------------------------------------------------
# Copyright (c) 2026 VIRTUS CC-UFCG. All rights reserved
# VIRTUS CC-UFCG Confidential Proprietary
# 
# Use, copy or distribuition of this code is not allowed without
# VIRTUS CC-UFCG explicit written consent.
# -------------------------------------------------------------------------------------
# Id: initial_design.tcl_2026-11-17_by_AnaBeatriz
#
# Project: 		CI Expert/UFCG - Physical Design Track
# Description:	Design initialization Script:
#                * Sets Labraries
#                * Creates design DB
#                * Imports prelayout netlist to DB
#                * Sets Timing scenarios
# -------------------------------------------------------------------------------------

###############################################################################
# Tech & ICC2 Setup
###############################################################################
source      "/home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/tool_data/icc2/setup/icc2_setup.tcl" 
source      "/home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/tool_data/icc2/setup/tech_setup.tcl" 

###############################################################################
# Design Setup
###############################################################################
set DESIGN_STAGE        "cv32e40p"

printvar search_path
printvar link_library

###############################################################################
# ICC2 Create Design Library
###############################################################################

#create_lib -technology $TECH_FILE -ref_libs $REFERENCE_LIBRARY ../../../outputs/${DESIGN}.dlib

if { [file exists $PRJT_BASE/dlib/${DESIGN}.dlib] } {
    file delete -force $PRJT_BASE/dlib/${DESIGN}.dlib
}


create_lib -ref_libs $REFERENCE_LIBRARY ${DLIB_DIR}/${DESIGN}.dlib
save_lib
###############################################################################
# ICC2 Open created library
###############################################################################
# Open created design library
open_lib             ${DLIB_DIR}/${DESIGN}.dlib

report_lib  $PRJT_BASE/dlib/${DESIGN}.dlib \
            -nosplit \
            -timing_arcs \
            -parasitic_tech \
            -physical \
            -antenna \
            -routability \
            -pattern_must_join_pin \
            -placement_constraints \
            -wire_tracks \
            -wire_track_colors \
            -verbose \
            -include_db_mapping

################################################################################
# ICC2 Import prelayout netlist
################################################################################
read_verilog $PRJT_BASE/outputs/preLayout_cv32e40.v -top ${DESIGN}
# Make sure that all cells in the netlist are found in the libs reference
link_block
current_block

sizeof_collection [get_flat_cells]
# sizeof_collection [get_cells -filter pad_cell]

# Generate SVF for Formality tool
set_svf    ${OUT_DIR}/$DESIGN.svf

# set_app_options -as_user_default -name time.remove_clock_reconvergence_pessimism -value true

################################################################################
# Create analysis scenarios
################################################################################
#source  $PRJT_BASE/tool_data/icc2/setup/scenarios.tcl> -echo -verbose

#current_scenario tc

#report_lib -parasitic_tech <file.dlib>

#report_parasitic_parameters > ${RPT_DIR}/report_parasitic_parameters.rpt

#get_corners
#all_corners

# Adding app option to avoid assign in netlist
#set_app_options -name opt.port.eliminate_verilog_assign -value true

###############################################################################
# ICC2 Save Design
###############################################################################
save_lib
save_block    -as ${DESIGN}/${DESIGN_STAGE} \
              -compress

###############################################################################
###############################################################################
######################## FINISH INITIAL DESIGN ###############################
###############################################################################
###############################################################################
echo "*****************************************************************************************"
echo "*****************************************************************************************"
puts "\[VIRTUS-CC\] INFO: The ${DESIGN_STAGE} for the ${DESIGN} has been completed."
puts "\[VIRTUS-CC\] INFO: Calling GUI ..."
echo "*****************************************************************************************"
echo "*****************************************************************************************"
date
after 5000
start_gui 
return
exit
