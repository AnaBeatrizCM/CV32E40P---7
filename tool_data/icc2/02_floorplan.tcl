# -------------------------------------------------------------------------------------
# Copyright (c) 2026 VIRTUS CC-UFCG. All rights reserved
# VIRTUS CC-UFCG Confidential Proprietary
#
# Copy, distribuition or use of this code is not allowed without
# VIRTUS CC-UFCG explicit written consent.
# -------------------------------------------------------------------------------------
#
# Id: floorplan.tcl_2026-05-05_by_AnaBeatriz_MarcosLeal
#
# Project: 		CI Expert/UFCG - Physical Design Track
# Description:	Floorplan creation script:
#                * Defines IO cells (if necessary)
#                * Defines Floorplan
#                * Defines Powerplan
#                * Routes power nets
#                * Runs rail analysis
# -------------------------------------------------------------------------------------

###############################################################################
# Tech & ICC2 Setup
###############################################################################
source      /home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/tool_data/icc2/setup/tech_setup.tcl
source      /home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/tool_data/icc2/setup/icc2_setup.tcl

###############################################################################
# Design Setup
###############################################################################
set PREV_STAGE          "01_init_design"
set DESIGN_STAGE        "02_floorplan"

###############################################################################
# ICC2 Open created library and block
###############################################################################
# Open created Design Library
open_lib                $PRJT_BASE/dlib/${DESIGN}.dlib/

# Make a copy of last stage block and rename to the new stage
copy_block 		-from_block cv32e40p_top.design \
    			-to_block cv32e40p/02_floorplan.design

# set the copy as the current design to work
current_block          ${DESIGN}/${DESIGN_STAGE}

open_block             cv32e40p/02_floorplan.design

# Analysis scenarios
get_scenarios
report_scenarios -nosplit
current_scenario

# Enable clock reconvergence pessimism removal as_user_default
# Remove the pessimism from the timing calculation caused by charged clock paths
#set_app_options -as_user_default -name time.remove_clock_reconvergence_pessimism -value true

# Generate SVF for Formality tool
set_svf -append  ${OUT_DIR}/${DESIGN}.svf

# #############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################
# ##############################################################################################################################################################

# ################################################################################
# # ICC2 Creates floorplan
# ################################################################################
# # By default, the initialize_floorplan command creates site arrays. To modify Rows you must use -use_site_row

initialize_floorplan -shape R -orientation N -side_ratio {1 1 1 1} -core_offset {1}

shape_blocks

create_placement

# ###############################################################################
# # prePlacement timing driven
# ###############################################################################

set_attribute -name routing_direction [get_layer M4] -value  vertical 
set_attribute -name routing_direction [get_layer M5] -value  horizontal
set_attribute -name routing_direction [get_layer M6] -value  vertical 
set_attribute -name routing_direction [get_layer M7] -value  horizontal 
set_attribute -name routing_direction [get_layer M8] -value  vertical 
set_attribute -name routing_direction [get_layer M9] -value  horizontal 

set_app_options -list {plan.place.congestion_driven_mode both}
# ## Creates a rough placement of the cells only for floorplaning purpose
create_placement -floorplan -use_seed_locs -timing_driven -incremental -effort high

report_app_options plan.place*

# # Unplace all std cells, since only macro place at this stage
# #reset_placement -spread_cells
# #reset_placement

# ###############################################################################
# # prePlacement congestion driven
# ###############################################################################
# # After all relative place constraints set
# # Effort level for congestion-driven restructuring
set_app_options  -name place.coarse.cong_restruct        -value on
set_app_options  -name place.coarse.cong_restruct_effort -value ultra
set_app_options  -name plan.place.congestion_driven_mode -value both

create_placement -floorplan -congestion -congestion_effort high

# ###############################################################################
# # Power Logical Connections
# ###############################################################################
# # Create new PG nets
get_ports
get_terminals

#create_net                  -power          VDD
#create_net                  -ground         VSS

set_net_type                -net            VDD    -type   power
set_net_type                -net            VSS   -type    ground

connect_pg_net              -net            VDD        [get_pins -physical_context {*/VDD}]
connect_pg_net              -net            VSS        [get_pins -physical_context {*/VSS}]

connect_pg_net -automatic
###############################################################################
# PG Ring Creation
###############################################################################
remove_redundant_shapes -remove_floating_shapes false \
                        -remove_dangling_shapes true

remove_routes -lib_cell_pin_connect
remove_routes -stripe
remove_routes -ring

connect_pg_net
set_pg_via_master_rule pgvia_8x10 -via_array_dimension {8 10}

set power_nets {VDD}
set ground_nets {VSS}
foreach_in_collection corner [get_cells -filter design_type==corner] {
	foreach net [concat $power_nets $ground_nets] { 
		connect_supply_net ${net} -port "[get_object_name $corner]/${net}"
	}
}


set_app_options -name plan.pgroute.ignore_signal_route -value true

## PG RING 
create_pg_ring_pattern ring_pattern -horizontal_layer M9 \
   -horizontal_width {1} -horizontal_spacing {1} \
   -vertical_layer M8 -vertical_width {1} -vertical_spacing {1} \
   -track_alignment auto 
  

set_pg_strategy core_ring \
   -pattern {{name: ring_pattern} \
   {nets: {VDD VSS}} {offset: {2 2}}} \
   -core

compile_pg -strategies core_ring

# set_pg_via_master_rule staple_via -contact_code VIA_SA_1 -via_array_dimension {2 1} -allow_multiple {0.2 0}

create_pg_std_cell_conn_pattern rail_pattern \
                                -layers {M1} 
                                

# # Create the std cell rails for the pattern created
set_pg_strategy M1_rails \
                 -pattern   { {name: rail_pattern} {nets: {VDD VSS}}} \
                 -extension  {{stop: inermost_ring} } \
                 -core

# set_pg_strategy_via_rule rail_rule \
#                  -via_rule { \
#                   { {strategies: {M1_rails}} \
#                   {{existing: strap}{layers: M2}} \
#                   {via_master:staple_via} {between_parallel: true} } \
#                   { {intersection: undefined}{via_master: NIL} }}

compile_pg -strategies M1_rails -via_rule {rail_rule}

#############################################################################
create_pg_mesh_pattern pg_mesh2 -layers { {{vertical_layer: M2 } {width: 0.15} {spacing: 5} {pitch: 10} {trim: true} }}  -via_rule {}
set_pg_strategy  pg_strategy2  -core  -pattern {{pattern: pg_mesh2}{nets: {VSS VDD }} } -extension {{stop: inermost_ring}}
compile_pg -strategies pg_strategy2 -via_rule {rail_rule}

create_pg_mesh_pattern pg_mesh3 -layers { {{horizontal_layer: M3} {width: 0.4} {spacing: 11} {pitch: 13} {trim: true}}} -via_rule {}
set_pg_strategy  pg_strategy3  -core  -pattern {{pattern: pg_mesh3}{nets: {VSS VDD }} } -extension {{stop: inermost_ring}}
compile_pg -strategies pg_strategy3 

create_pg_mesh_pattern pg_mesh4 -layers { {{vertical_layer: M4 } {width: 0.75} {spacing: 10} {pitch: 20} {trim: true} }}  -via_rule {}
set_pg_strategy  pg_strategy4  -core  -pattern {{pattern: pg_mesh4}{nets: {VSS VDD }} } -extension {{stop: inermost_ring}}
compile_pg -strategies pg_strategy4 -via_rule {rail_rule}

# create_pg_mesh_pattern pg_mesh5 -layers { {{horizontal_layer: M5} {width: 4} {spacing: 20} {pitch: 320} {trim: true}}} -via_rule {}
# set_pg_strategy  pg_strategy5  -core  -pattern {{pattern: pg_mesh5}{nets: {VSS VDD }} } -extension {{stop: inermost_ring}}
# compile_pg -strategies pg_strategy5 

create_pg_mesh_pattern pg_mesh8 -layers { {{vertical_layer: M8 } {width: 1} {spacing: 15} {pitch: 25} {trim: true} }}  -via_rule {}
set_pg_strategy  pg_strategy8 -core -pattern {{pattern: pg_mesh8}{nets: {VSS VDD }} } -extension {{stop: outermost_ring}}
compile_pg -strategies pg_strategy8 

create_pg_mesh_pattern pg_mesh9 -layers { {{horizontal_layer: M9 } {width: 1} {spacing: 10} {pitch: 25} {trim: true} }}  -via_rule {}
set_pg_strategy  pg_strategy9 -core -pattern {{pattern: pg_mesh9}{nets: {VSS VDD }} } -extension {{stop: outermost_ring}}
compile_pg -strategies pg_strategy9

legalize_placement

set_block_pin_constraints -self -pin_spacing_distance 8 -sides {1 2 3 4} -allowed_layers {M4 M5 M6 M7} -hard_constraints {location spacing layer}
place_pins -self


save_lib

###############################################################################
# Remove all placement blockages
###############################################################################
remove_placement_blockages   -all -verbose
remove_routing_blockages     -all -verbose

###############################################################################
# Global Route
###############################################################################
# Creates a rough routing of the cells after the Power Planning
remove_placement_blockages [get_placement_blockages *]
route_global -floorplan true -congestion_map_only true

check_pg_missing_vias
check_pg_drc -ignore_std_cells
check_pg_connectivity -check_std_cell_pins none

###############################################################################
# Report_timing
###############################################################################
file mkdir             ${RPT_DIR}/${DESIGN_STAGE}
report_qor              -significant_digits 3 \
                        -scenarios [get_scenarios] \
                        > ${RPT_DIR}/report_qor.rpt

###############################################################################
# Reports
###############################################################################
report_utilization           > ${RPT_DIR}/report_utilization_postFloorplan.rpt

# Reports the routing track direction, startpoint, number of tracks and pitch
#report_tracks

report_design -floorplan     > ${RPT_DIR}/report_design.rpt

###############################################################################
# Creates abstract and frame views of the design
###############################################################################
create_abstract	-read_only

create_frame

###############################################################################
# Generate Floorplan DEF file
###############################################################################
write_floorplan	        -force \
                        -output ${OUT_DIR}/${DESIGN}.fp

# Writes the floorplan for Design Compiler Synopsys tool
write_floorplan	        -force -output ${OUT_DIR}/${DESIGN}.fp.dc -net_types {power ground} -include_physical_status {fixed locked}

write_def               -include_tech_via_definitions \
                        -include {rows_tracks vias blockages specialnets} \
                        "${OUT_DIR}/floorplan.def"

###############################################################################
# ICC2 Save Design
###############################################################################
save_block              -as ${DESIGN}/${DESIGN_STAGE} \
                        -compress

#close_lib

###############################################################################
###############################################################################
############################ FINISH FLOORPLAN #################################
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


