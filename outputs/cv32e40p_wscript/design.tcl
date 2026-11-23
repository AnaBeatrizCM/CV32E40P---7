################################################################################
#
# Created by fc write_script on Mon Nov 23 11:58:45 2026
#
################################################################################

################################################################################
#
# Units
# time_unit               : 1e-09
# resistance_unit         : 1000000
# capacitive_load_unit    : 1e-15
# voltage_unit            : 1
# current_unit            : 1e-06
# power_unit              : 1e-12
################################################################################


set_budget_options -adjust_latency prects  -top_level
set_app_options -name lib.setting.enable_process_number_scaling -value false \
    -quiet
set_app_options -as_user_default -name time.port_slew_lower_threshold_rise \
    -value 20 -quiet
set_app_options -as_user_default -name time.port_slew_lower_threshold_fall \
    -value 20 -quiet
set_app_options -as_user_default -name time.port_slew_upper_threshold_rise \
    -value 80 -quiet
set_app_options -as_user_default -name time.port_slew_upper_threshold_fall \
    -value 80 -quiet
set_app_options -as_user_default -name time.port_input_threshold_rise -value 50 \
    -quiet
set_app_options -as_user_default -name time.port_input_threshold_fall -value 50 \
    -quiet
set_app_options -as_user_default -name time.port_output_threshold_rise -value \
    50 -quiet
set_app_options -as_user_default -name time.port_output_threshold_fall -value \
    50 -quiet
set_app_options -as_user_default -name time.port_slew_derate_from_library \
    -value 1 -quiet
set_app_options -name gui.batch_x_display -value default -quiet

## Encrypted set_app_options
set dirName [file dirname [file normalize [info script]]]
if {[file exists  ${dirName}/top.tcl___synenc_proc_]} {
  redirect /dev/null {source -continue_on_error \
    ${dirName}/top.tcl___synenc_proc_ }
}

if {[sizeof_collection [get_cell_buses -hierarchical -quiet \
    {core_i/if_stage_i/prefetch_buffer_i/fifo_i/read_pointer_q_reg} ]] == 0} {
  create_cell_bus -reference __wvGtech__/*SEQGEN.1839103_120_2 -create_cells \
    -cell core_i/if_stage_i/prefetch_buffer_i/fifo_i read_pointer_q_reg[0:0]
}

if {[sizeof_collection [get_cell_buses -hierarchical -quiet \
    {core_i/if_stage_i/prefetch_buffer_i/fifo_i/write_pointer_q_reg} ]] == 0} {
  create_cell_bus -reference __wvGtech__/*SEQGEN.1839103_120_2 -create_cells \
    -cell core_i/if_stage_i/prefetch_buffer_i/fifo_i write_pointer_q_reg[0:0]
}

restore_mpn_restrictions
# MD5_SIGNATURE: 008458015DD92B7010EC0B91A9CE3DBF 
