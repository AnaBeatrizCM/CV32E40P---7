# --------------------------------------------------------------------------------
# Copyright (c) 2026 VIRTUS CC-UFCG. All rights reserved
# VIRTUS CC-UFCG Confidential Proprietary
# 
# Use, copy or distribuition of this code is not allowed without
# VIRTUS CC-UFCG explicit written consent.
# --------------------------------------------------------------------------------
#
# Id: ICC2_setup.tcl_2026-04-14_by_LuizHenriqueNascimento
#
# Project: 		CI Expert/UFCG - Physical Design Track
# Description:	Technology Setup to Instr Decoder Design to the test SAED32 EDK
# --------------------------------------------------------------------------------



## User variables Setup

set DESIGN       "cv32e40p"
set PRJT_BASE    "/home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7"
set TECH_DIR     "${PRJT_BASE}/tech/tf"
set DB_DIR       "${PRJT_BASE}/db"
set NDM_DIR      "${PRJT_BASE}/ndm_lib"
set OUT_DIR      "${PRJT_BASE}/outputs"
set RPT_DIR      "${PRJT_BASE}/rpt"

###############################################################################
# Tech Files Variables
###############################################################################


set TECH_FILE           [glob $TECH_DIR/*.tf] 
set REFERENCE_LIBRARY [list \
    ${NDM_DIR}/saed32rvt_tt0p85v25c.ndm \
    ${NDM_DIR}/saed32rvt_ff0p95v25c.ndm \
    ${NDM_DIR}/saed32rvt_ss0p75v125c.ndm \
]

#-----------------------------------------------------------------------------------------------
# TLU plus file (similar to captable) FALTA!
set TLUPLUS_TYP_FILE   "$TECH_DIR/saed32nm_1p9m_nominal.tluplus"
set TLUPLUS_MIN_FILE   "$TECH_DIR/saed32nm_1p9m_Cmin.tluplus"
set TLUPLUS_MAX_FILE   "$TECH_DIR/saed32nm_1p9m_Cmax.tluplus"
set TLUPLUS_MAP_FILE   "$TECH_DIR/saed32nm_fc_layer.map"
#-----------------------------------------------------------------------------------------------

###############################################################################
# Finish ICC2_setup
###############################################################################
echo "********************************************************************************"
echo "********************************************************************************"
puts "\[VIRTUS-CC\] INFO: The IC Compiler II Setup for the ${DESIGN} has been completed."
echo "********************************************************************************"
echo "********************************************************************************"





