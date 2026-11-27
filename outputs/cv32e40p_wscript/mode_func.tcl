################################################################################
#
# Created by fc write_script on Fri Nov 27 13:41:19 2026
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


# /home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/constraints/cv32e40p_core.sdc, \
#   line 130
create_clock -name clk_i -period 5 -waveform {0 2.5} [get_ports {clk_i}]
# MD5_SIGNATURE: 66B57A799186417473563382CD2219AC 
