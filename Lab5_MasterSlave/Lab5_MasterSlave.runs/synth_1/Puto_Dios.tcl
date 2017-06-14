# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Xilinx/lab_5/lab_5.cache/wt [current_project]
set_property parent.project_path C:/Xilinx/lab_5/lab_5.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Xilinx/lab_5/lab_5.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/sources_1/imports/imports/5.2.3/ssdec.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/uart/data_sync.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/sources_1/imports/imports/Downloads/unsigned_to_bcd.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/sources_1/imports/imports/5.2.3/display.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/sources_1/imports/imports/Downloads/clockuru.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/sources_1/imports/new/ALU.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/uart/uart_tx.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/uart/uart_rx.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/uart/uart_baud_tick_gen.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/TX_sequence.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/TX_control.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/bcd_to_ss.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/sources_1/new/UART_RX_CTRL.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/sources_1/imports/Downloads/TX_CTRL.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/sources_1/imports/new/No_ALU.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/unsigned_to_bcd.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/UART_tx_control_wrapper.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/uart/uart_basic.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/pb_debouncer.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/display_mux.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/clk_divider.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/sources_1/new/Slave_Endpoint_top.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/imports/new/master_endpoint_top.v
  C:/Xilinx/lab_5/lab_5.srcs/sources_1/new/Puto_Dios.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Xilinx/lab_5/lab_5.srcs/constrs_1/imports/new/UART_master_endpoint_constraints.xdc
set_property used_in_implementation false [get_files C:/Xilinx/lab_5/lab_5.srcs/constrs_1/imports/new/UART_master_endpoint_constraints.xdc]


synth_design -top Puto_Dios -part xc7a100tcsg324-1


write_checkpoint -force -noxdef Puto_Dios.dcp

catch { report_utilization -file Puto_Dios_utilization_synth.rpt -pb Puto_Dios_utilization_synth.pb }
