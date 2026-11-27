set PRJT_BASE "/home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7"

create_workspace saed32rvt \
 -tech /home/xmen-aluno/physical_design_AnaBeatriz/hands/CV32E40P---7/tech/tf/saed32nm_1p9m.tf \
 -flow exploration

read_db ${PRJT_BASE}/db/saed32rvt_ff1p16vn40c.db
read_db ${PRJT_BASE}/db/saed32rvt_ss0p7v125c.db
read_db ${PRJT_BASE}/db/saed32rvt_tt1p05v25c.db

read_lef ${PRJT_BASE}/lef/saed32nm_rvt_1p9m.lef

group_libs

process_workspaces -output ${PRJT_BASE}/ndm_lib/saed32rvt_ff.ndm
process_workspaces -output ${PRJT_BASE}/ndm_lib/saed32rvt_tt.ndm
process_workspaces -output ${PRJT_BASE}/ndm_lib/saed32rvt_ss.ndm

#remove_workspace



