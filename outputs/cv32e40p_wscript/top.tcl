################################################################################
#
# Design name:  cv32e40p_top
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


set dirName [file dirname [file normalize [info script]]]
set extName "tcl"
set_user_units -input -type time -value 1ns
set_user_units -input -type resistance -value 1MOhm
set_user_units -input -type capacitance -value 1fF
set_user_units -input -type voltage -value 1V
set_user_units -input -type current -value 1uA
set_user_units -output -type time -value 1ns
set_user_units -output -type resistance -value 1MOhm
set_user_units -output -type capacitance -value 1fF
set_user_units -output -type voltage -value 1V
set_user_units -output -type current -value 1uA

set cornerNames [list corner_tt corner_ff corner_ss]
foreach cornerName $cornerNames {
  create_corner $cornerName
}

set modeNames [list func]
foreach modeName $modeNames {
  create_mode $modeName
}

create_scenario -name func_tt -mode func -corner corner_tt
set_scenario_status func_tt -setup true -hold true -leakage_power true \
    -dynamic_power true -max_transition true -max_capacitance true \
    -min_capacitance true -cell_em false -signal_em false -glitch_power false \
    -ir_drop false -si_noise false -thermal false -active true
set_scenario_si_filtering func_tt -si_xtalk_composite_aggr_mode statistical

create_scenario -name func_ff -mode func -corner corner_ff
set_scenario_status func_ff -setup true -hold true -leakage_power true \
    -dynamic_power true -max_transition true -max_capacitance true \
    -min_capacitance true -cell_em false -signal_em false -glitch_power false \
    -ir_drop false -si_noise false -thermal false -active true
set_scenario_si_filtering func_ff -si_xtalk_composite_aggr_mode statistical

create_scenario -name func_ss -mode func -corner corner_ss
set_scenario_status func_ss -setup true -hold true -leakage_power true \
    -dynamic_power true -max_transition true -max_capacitance true \
    -min_capacitance true -cell_em false -signal_em false -glitch_power false \
    -ir_drop false -si_noise false -thermal false -active true
set_scenario_si_filtering func_ss -si_xtalk_composite_aggr_mode statistical

foreach cornerName $cornerNames {
  current_corner $cornerName
  source ${dirName}/corner_${cornerName}.${extName}
}

foreach modeName $modeNames {
  current_mode $modeName
  source ${dirName}/mode_${modeName}.${extName}
}

current_scenario func_tt
source ${dirName}/scenario_func_tt.${extName}
if {[file exists ${dirName}/func_tt_act.${extName}]} {
  source ${dirName}/func_tt_act.${extName}
}
current_scenario func_ff
source ${dirName}/scenario_func_ff.${extName}
if {[file exists ${dirName}/func_ff_act.${extName}]} {
  source ${dirName}/func_ff_act.${extName}
}
current_scenario func_ss
source ${dirName}/scenario_func_ss.${extName}
if {[file exists ${dirName}/func_ss_act.${extName}]} {
  source ${dirName}/func_ss_act.${extName}
}

source ${dirName}/design.${extName}

if {[file exists ${dirName}/cts.${extName}]} {
  source ${dirName}/cts.${extName}
}
current_mode func
current_corner corner_tt
# End of script
# MD5_SIGNATURE: 377920486BAD25C0A47716CDF0A11DC7 
