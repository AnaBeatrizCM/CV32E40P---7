set PRJT_BASE "/home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7"

create_workspace saed32rvt_tt \
 -tech /home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/tech/tf/saed32nm_1p9m.tf \
 -flow exploration

read_db ${PRJT_BASE}/db/saed32rvt_ff0p95v25c.db
#read_db ${PRJT_BASE}/db/saed32rvt_ss0p75v125c.db" 
#read_db "${PRJT_BASE}/db/saed32rvt_tt0p85v25c.db"

read_lef ${PRJT_BASE}/lef/saed32nm_rvt_1p9m.lef

group_libs

process_workspaces -output ${PRJT_BASE}/ndm_lib/saed32rvt_ff.ndm
#process_workspaces -output ${PRJT_BASE}/ndm_lib/saed32rvt_tt.ndm
#process_workspaces -output ${PRJT_BASE}/ndm_lib/saed32rvt_ss.ndm

#remove_workspace



