verdiSetActWin -dock widgetDock_<Watch>
simSetSimulator "-vcssv" -exec \
           "/home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/simv_tb" \
           -args \
           "+firmware=example_tb/core/custom/hello_world.hex +maxcycles=10000 -sml=verdi +UVM_VERDI_TRACE=UVM_AWARE -ucli2Proc -ucli"
debImport "-dbdir" \
          "/home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/simv_tb.daidir"
debLoadSimResult \
           /home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/inter.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "547" "256" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiWindowResize -win $_Verdi_1 "547" "256" "1309" "700"
verdiDockWidgetSetCurTab -dock widgetDock_<Member>
verdiSetActWin -dock widgetDock_<Member>
srcHBSelect "tb_top.wrapper_i" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_top" -win $_nTrace1
srcSetScope "tb_top" -delim "." -win $_nTrace1
srcHBSelect "tb_top.wrapper_i" -win $_nTrace1
srcSetScope "tb_top.wrapper_i" -delim "." -win $_nTrace1
srcHBSelect "tb_top.wrapper_i.ram_i" -win $_nTrace1
srcSetScope "tb_top.wrapper_i.ram_i" -delim "." -win $_nTrace1
srcHBSelect "tb_top.wrapper_i.ram_i.dp_ram_i" -win $_nTrace1
srcSetScope "tb_top.wrapper_i.ram_i.dp_ram_i" -delim "." -win $_nTrace1
srcHBSelect "tb_top" -win $_nTrace1
srcSetScope "tb_top" -delim "." -win $_nTrace1
srcHBSelect "tb_top" -win $_nTrace1
verdiDockWidgetSetCurTab -dock widgetDock_<Signal_List>
verdiSetActWin -dock widgetDock_<Signal_List>
srcSignalViewSelect "tb_top.CLK_PHASE_HI"
verdiDockWidgetSetCurTab -dock widgetDock_<Local>
verdiSetActWin -dock widgetDock_<Local>
verdiDockWidgetSetCurTab -dock widgetDock_<Signal_List>
verdiSetActWin -dock widgetDock_<Signal_List>
srcSignalViewSelect "tb_top.rst_n"
debExit
