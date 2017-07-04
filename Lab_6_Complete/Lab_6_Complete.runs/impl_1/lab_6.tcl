proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.cache/wt [current_project]
  set_property parent.project_path C:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.xpr [current_project]
  set_property ip_output_repo C:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  add_files -quiet C:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.runs/synth_1/lab_6.dcp
  add_files -quiet C:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp
  set_property netlist_only true [get_files C:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp]
  read_xdc -mode out_of_context -ref clk_wiz_0 -cells inst c:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc
  set_property processing_order EARLY [get_files c:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clk_wiz_0 -cells inst c:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc
  set_property processing_order EARLY [get_files c:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
  read_xdc -ref clk_wiz_0 -cells inst c:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc
  set_property processing_order EARLY [get_files c:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
  read_xdc {{C:/GitHub/LabDigitales2017/Lab_6_Complete/Lab_6_Complete.srcs/constrs_1/imports/LabDigitales2017/The Final Alcachofita.xdc}}
  link_design -top lab_6 -part xc7a100tcsg324-1
  write_hwdef -file lab_6.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force lab_6_opt.dcp
  catch { report_drc -file lab_6_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force lab_6_placed.dcp
  catch { report_io -file lab_6_io_placed.rpt }
  catch { report_utilization -file lab_6_utilization_placed.rpt -pb lab_6_utilization_placed.pb }
  catch { report_control_sets -verbose -file lab_6_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force lab_6_routed.dcp
  catch { report_drc -file lab_6_drc_routed.rpt -pb lab_6_drc_routed.pb -rpx lab_6_drc_routed.rpx }
  catch { report_methodology -file lab_6_methodology_drc_routed.rpt -rpx lab_6_methodology_drc_routed.rpx }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file lab_6_timing_summary_routed.rpt -rpx lab_6_timing_summary_routed.rpx }
  catch { report_power -file lab_6_power_routed.rpt -pb lab_6_power_summary_routed.pb -rpx lab_6_power_routed.rpx }
  catch { report_route_status -file lab_6_route_status.rpt -pb lab_6_route_status.pb }
  catch { report_clock_utilization -file lab_6_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force lab_6_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  catch { write_mem_info -force lab_6.mmi }
  write_bitstream -force -no_partial_bitfile lab_6.bit 
  catch { write_sysdef -hwdef lab_6.hwdef -bitfile lab_6.bit -meminfo lab_6.mmi -file lab_6.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

