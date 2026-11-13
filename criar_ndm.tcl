set PRJT_BASE "/home/marcos.leal/Desktop/Physical_Design_MarcosLeal/CV32E40P/CV32E40P---7"

create_workspace saed32_std -flow aggregate

read_ndm ${PRJT_BASE}/ndm_lib/saed32hvt_tt.ndm
read_ndm ${PRJT_BASE}/ndm_lib/saed32rvt_tt.ndm
read_ndm ${PRJT_BASE}/ndm_lib/saed32lvt_tt.ndm

check_workspace                       ;# avisa se células de libs diferentes se "eclipsam"
set_lib_order {saed32hvt_tt saed32rvt_tt saed32lvt_tt}
commit_workspace -output ${PRJT_BASE}/ndm_lib/saed32_std_tt.ndm
