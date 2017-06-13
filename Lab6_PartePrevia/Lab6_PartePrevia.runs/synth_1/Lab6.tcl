# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Diego/LabDigitales2017/Lab6_PartePrevia/Lab6_PartePrevia.cache/wt [current_project]
set_property parent.project_path C:/Users/Diego/LabDigitales2017/Lab6_PartePrevia/Lab6_PartePrevia.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/Diego/LabDigitales2017/Lab6_PartePrevia/Lab6_PartePrevia.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/Diego/LabDigitales2017/Lab6_PartePrevia/Lab6_PartePrevia.srcs/sources_1/imports/Lab6_PS2_VGA_reference/kbd_ms.v
  C:/Users/Diego/LabDigitales2017/Lab6_PartePrevia/Lab6_PartePrevia.srcs/sources_1/imports/Downloads/clockuru.v
  C:/Users/Diego/LabDigitales2017/Lab6_PartePrevia/Lab6_PartePrevia.srcs/sources_1/new/Lab6.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Diego/LabDigitales2017/Lab6_PartePrevia/Lab6_PartePrevia.srcs/constrs_1/imports/LabDigitales2017/The Final Alcachofita.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Diego/LabDigitales2017/Lab6_PartePrevia/Lab6_PartePrevia.srcs/constrs_1/imports/LabDigitales2017/The Final Alcachofita.xdc}}]


synth_design -top Lab6 -part xc7a100tcsg324-1


write_checkpoint -force -noxdef Lab6.dcp

catch { report_utilization -file Lab6_utilization_synth.rpt -pb Lab6_utilization_synth.pb }