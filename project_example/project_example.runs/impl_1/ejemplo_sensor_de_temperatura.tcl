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
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/GitHub/LabDigitales2017/project_example/project_example.cache/wt [current_project]
  set_property parent.project_path C:/GitHub/LabDigitales2017/project_example/project_example.xpr [current_project]
  set_property ip_output_repo C:/GitHub/LabDigitales2017/project_example/project_example.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  add_files -quiet C:/GitHub/LabDigitales2017/project_example/project_example.runs/synth_1/ejemplo_sensor_de_temperatura.dcp
  read_xdc {{C:/GitHub/LabDigitales2017/project_example/project_example.srcs/constrs_1/imports/LabDigitales2017/The Final Alcachofita.xdc}}
  link_design -top ejemplo_sensor_de_temperatura -part xc7a100tcsg324-1
  write_hwdef -file ejemplo_sensor_de_temperatura.hwdef
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
  write_checkpoint -force ejemplo_sensor_de_temperatura_opt.dcp
  catch { report_drc -file ejemplo_sensor_de_temperatura_drc_opted.rpt }
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
  write_checkpoint -force ejemplo_sensor_de_temperatura_placed.dcp
  catch { report_io -file ejemplo_sensor_de_temperatura_io_placed.rpt }
  catch { report_utilization -file ejemplo_sensor_de_temperatura_utilization_placed.rpt -pb ejemplo_sensor_de_temperatura_utilization_placed.pb }
  catch { report_control_sets -verbose -file ejemplo_sensor_de_temperatura_control_sets_placed.rpt }
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
  write_checkpoint -force ejemplo_sensor_de_temperatura_routed.dcp
  catch { report_drc -file ejemplo_sensor_de_temperatura_drc_routed.rpt -pb ejemplo_sensor_de_temperatura_drc_routed.pb -rpx ejemplo_sensor_de_temperatura_drc_routed.rpx }
  catch { report_methodology -file ejemplo_sensor_de_temperatura_methodology_drc_routed.rpt -rpx ejemplo_sensor_de_temperatura_methodology_drc_routed.rpx }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file ejemplo_sensor_de_temperatura_timing_summary_routed.rpt -rpx ejemplo_sensor_de_temperatura_timing_summary_routed.rpx }
  catch { report_power -file ejemplo_sensor_de_temperatura_power_routed.rpt -pb ejemplo_sensor_de_temperatura_power_summary_routed.pb -rpx ejemplo_sensor_de_temperatura_power_routed.rpx }
  catch { report_route_status -file ejemplo_sensor_de_temperatura_route_status.rpt -pb ejemplo_sensor_de_temperatura_route_status.pb }
  catch { report_clock_utilization -file ejemplo_sensor_de_temperatura_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force ejemplo_sensor_de_temperatura_routed_error.dcp
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
  catch { write_mem_info -force ejemplo_sensor_de_temperatura.mmi }
  write_bitstream -force -no_partial_bitfile ejemplo_sensor_de_temperatura.bit 
  catch { write_sysdef -hwdef ejemplo_sensor_de_temperatura.hwdef -bitfile ejemplo_sensor_de_temperatura.bit -meminfo ejemplo_sensor_de_temperatura.mmi -file ejemplo_sensor_de_temperatura.sysdef }
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

