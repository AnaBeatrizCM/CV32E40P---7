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


set_scaling_lib_group -all
set_parasitic_parameters -early_spec minTLU -early_temperature -40 -late_spec \
    minTLU -late_temperature -40
# MD5_SIGNATURE: 15257D4D7EA6D0E4AB19EF92664F3C6A 
