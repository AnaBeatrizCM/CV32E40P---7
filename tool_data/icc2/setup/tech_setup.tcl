# --------------------------------------------------------------------------------
# Copyright (c) 2026 VIRTUS CC-UFCG. All rights reserved
# VIRTUS CC-UFCG Confidential Proprietary
# 
# Use, copy or distribuition of this code is not allowed without
# VIRTUS CC-UFCG explicit written consent.
# --------------------------------------------------------------------------------
#
# Id: tech_setp.tcl_2026-04-14_by_AnaBeatriz_MarcosLeal
#
# Project: 		CI Expert/UFCG - Physical Design Track
# Description:	Technology Setup to Instr Decoder Design to the test SAED32 EDK
# --------------------------------------------------------------------------------



## User variables Setup
set DESIGN              "cv32e40p"
set PRJT_BASE           "/home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7" 
set DLIB_DIR            "${PRJT_BASE}/dlib"  
set LEF_DIR             "${PRJT_BASE}/lef"
set TECH_DIR            "${PRJT_BASE}/tech/tf"
set NDM_DIR             "${PRJT_BASE}/ndm_lib"
set OUT_DIR             "${PRJT_BASE}/outputs"
set RPT_DIR 		"${PRJT_BASE}/reports"


###############################################################################
# Tech Files Variables
###############################################################################

set TECH_FILE           "${TECH_DIR}/saed32nm_1p9m.tf"
set REFERENCE_LIBRARY [list \
    ${NDM_DIR}/saed32rvt_tt0p85v25c.ndm \
    ${NDM_DIR}/saed32rvt_ff0p95v25c.ndm \
    ${NDM_DIR}/saed32rvt_ss0p75v125c.ndm \
]

#-----------------------------------------------------------------------------------------------
# TLU plus file (similar to captable)
set TLUPLUS_TYP_FILE   "$TECH_DIR/saed32nm_1p9m_nominal.tluplus"
set TLUPLUS_MIN_FILE   "$TECH_DIR/saed32nm_1p9m_Cmin.tluplus"
set TLUPLUS_MAX_FILE   "$TECH_DIR/saed32nm_1p9m_Cmax.tluplus"
set TLUPLUS_MAP_FILE   "$TECH_DIR/saed32nm_fc_layer.map"
#-----------------------------------------------------------------------------------------------

###############################################################################
# Power/Ground Variables
###############################################################################

# Set power and ground ports
set POWER_PORT              VDD  
set GROUND_PORT             VSS   

# Set power and ground nets
set POWER_NET               VDD    
set GROUND_NET              VSS

# Set Std cells PG pins
set STD_CELLS_POWER_PIN     VDD
set STD_CELLS_GROUND_PIN    VSS

###############################################################################
# Std cells Definitions
###############################################################################

# STD Cell site height
#set SITE_HEIGHT              1.672
# STD Cell site width
#set SITE_WIDTH               0.200

# Tie cells
set TIE_HIGH                 "TIEH_RVT"
set TIE_LOW                  "TIEL_RVT"

# Max fanout
set MAX_FANOUT              8

# Clock Buffers
# set CLOCK_BUFFERS           ""


# set CLOCK_ROOT_CELL         ""

# Delay cells
set DELAY_CELLS             "DELLN3X2_RVT DELLN2X2_RVT DELLN1X2_RVT"

# Filler cells
# By default, tool insert cells in order specified. Specify from the largest to smallest. 
# set FILLER_CELLS           ""

#set FILLER_CELLS          ""

#set IO_FILLER_CELLS         ""

# Decap cells
# By default, tool insert cells in order specified. Specify from the largest to smallest. 
set DECAP_CELLS            "DCAP_RVT"

# set ENDCAP_CELLS            ""

# TAP CELL (well/substrate)
# set TAP_CELL                ""
# set TAP_CELL_DISTANCE       ""

# Antenna cells
set ANTENNA_DIODES          "ANTENNA_RVT"

# Spare cells
# set SPARE_CELLS            ""

###############################################################################
# Finish tech_setup
###############################################################################
echo "********************************************************************************"
echo "********************************************************************************"
puts "\[VIRTUS-CC\] INFO: The Technology Setup for the ${DESIGN} has been completed."
echo "********************************************************************************"
echo "********************************************************************************"





