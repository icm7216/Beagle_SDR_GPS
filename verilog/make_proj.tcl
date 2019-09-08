#*****************************************************************************************
# Vivado (TM) v2017.4 (64-bit)
#
# make_proj.tcl: Tcl script for re-creating project 'Kiwisdr'
#
# Generated by Vivado on Tue Aug 20 19:29:19 CEST 2019
# IP Build 2085800 on Fri Dec 15 22:25:07 MST 2017
#

## load KiwiSDR tcl definitions (kiwi::make_ipcores)
source kiwi.tcl

set part xc7a35tftg256-1

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the reference directory for source file relative paths (by default the value is script directory path)
set result_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::result_dir_loc] } {
  set result_dir $::result_dir_loc
}

# Set the project name
set project_name "KiwiSDR"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set project_name $::user_project_name
}

variable script_file
set script_file "make_proj.tcl"
set regen_ip "no"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--result_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--regen_ip\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argc]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--result_dir"   { incr i; set result_dir [lindex $::argv $i] }
      "--project_name" { incr i; set project_name [lindex $::argv $i] }
      "--regen_ip"     {         set regen_ip "yes" }
      "--help"         { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}
puts "==================== NAME: ${project_name} ===================="

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/Kiwisdr"]"

# Create project (if doesn't exist)
if {[string equal [open_project -quiet "KiwiSDR/KiwiSDR.xpr"] ""]} {
    set proj_create "yes"
    create_project ${project_name} ./${project_name} -part $part
} else {
    set proj_create "no"
}

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [current_project]
set_property \
    -dict [list corecontainer.enable {1} \
               default_lib {xil_defaultlib} \
               dsa.num_compute_units {60} \
               ip_cache_permissions {read write} \
               ip_output_repo "$proj_dir/${project_name}.cache/ip" \
               part {xc7a35tftg256-1} \
               sim.ip.auto_export_scripts {1} \
               xpm_libraries {XPM_MEMORY} ] \
    [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# transition from old generated file scheme
set rem_files [ list \
                "[file normalize ${origin_dir}/rx/cic_rx1.vh]" \
                "[file normalize ${origin_dir}/rx/cic_rx2.vh]" \
                "[file normalize ${origin_dir}/rx/cic_rx3.vh]" \
               ]
remove_files -quiet -fileset [get_filesets sources_1] $rem_files

# Set 'sources_1' fileset object
set files [ list \
                "[file normalize ${origin_dir}/kiwi.vh]" \
                "[file normalize ${origin_dir}/kiwi.cfg.vh]" \
                "[file normalize ${origin_dir}/kiwi.gen.vh]" \
                "[file normalize ${origin_dir}/kiwi.v]" \
                "[file normalize ${origin_dir}/host.v]" \
                "[file normalize ${origin_dir}/cpu.v]" \
                "[file normalize ${origin_dir}/rx/receiver.v]" \
                "[file normalize ${origin_dir}/rx/rx.v]" \
                "[file normalize ${origin_dir}/rx/rx_buffer.v]" \
                "[file normalize ${origin_dir}/rx/waterfall_1cic.v]" \
                "[file normalize ${origin_dir}/rx/gen.v]" \
                "[file normalize ${origin_dir}/rx/iq_mixer.v]" \
                "[file normalize ${origin_dir}/rx/iq_sampler_8k_32b.v]" \
                "[file normalize ${origin_dir}/rx/cic_prune_var.v]" \
                "[file normalize ${origin_dir}/rx/cic_comb.v]" \
                "[file normalize ${origin_dir}/rx/cic_integrator.v]" \
                "[file normalize ${origin_dir}/rx/cic_rx1_12k.vh]" \
                "[file normalize ${origin_dir}/rx/cic_rx1_20k.vh]" \
                "[file normalize ${origin_dir}/rx/cic_rx2_12k.vh]" \
                "[file normalize ${origin_dir}/rx/cic_rx2_20k.vh]" \
                "[file normalize ${origin_dir}/rx/cic_rx3_12k.vh]" \
                "[file normalize ${origin_dir}/rx/cic_rx3_20k.vh]" \
                "[file normalize ${origin_dir}/rx/cic_wf1.vh]" \
                "[file normalize ${origin_dir}/rx/cic_wf2.vh]" \
                "[file normalize ${origin_dir}/gps/gps.v]" \
                "[file normalize ${origin_dir}/gps/sampler.v]" \
                "[file normalize ${origin_dir}/gps/demod.v]" \
                "[file normalize ${origin_dir}/gps/cacode.v]" \
                "[file normalize ${origin_dir}/gps/e1bcode.v]" \
                "[file normalize ${origin_dir}/gps/logger.v]" \
                "[file normalize ${origin_dir}/support/mux.v]" \
                "[file normalize ${origin_dir}/support/sync_pulse.v]" \
                "[file normalize ${origin_dir}/support/sync_wire.v]" \
                "[file normalize ${origin_dir}/support/sync_reg.v]" \
                "[file normalize ${origin_dir}/ip/ip_add_u32b.v]" \
                "[file normalize ${origin_dir}/ip/ip_add_u30b.v]" \
                "[file normalize ${origin_dir}/ip/ip_acc_u32b.v]" \
                "[file normalize ${origin_dir}/ip/ip_dds_sin_cos_13b_15b.v]" \
                "[file normalize ${origin_dir}/ip/ip_dds_sin_cos_13b_15b_48b.v]" \
               ]
if {[string equal $proj_create "yes"]} {
    add_files -norecurse -fileset [get_filesets sources_1] $files
}

proc add_verilog_header_file fn {
    set file [file normalize $fn]
    set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
    set_property -name "file_type" -value "Verilog Header" -objects $file_obj
}

# Set 'sources_1' fileset file properties for remote files
if {[string equal $proj_create "yes"]} {
    add_verilog_header_file "$origin_dir/kiwi.vh"
    add_verilog_header_file "$origin_dir/kiwi.gen.vh"
    add_verilog_header_file "$origin_dir/rx/cic_rx1_12k.vh"
    add_verilog_header_file "$origin_dir/rx/cic_rx1_20k.vh"
    add_verilog_header_file "$origin_dir/rx/cic_rx2_12k.vh"
    add_verilog_header_file "$origin_dir/rx/cic_rx2_20k.vh"
    add_verilog_header_file "$origin_dir/rx/cic_rx3_12k.vh"
    add_verilog_header_file "$origin_dir/rx/cic_rx3_20k.vh"
    add_verilog_header_file "$origin_dir/rx/cic_wf1.vh"
    add_verilog_header_file "$origin_dir/rx/cic_wf2.vh"
}


# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set_property -name "top" -value "KiwiSDR" -objects [get_filesets sources_1]


# This makes up ipcores according to the property lists located in the directory ./ipcore_properties
if {[string equal $regen_ip "yes"]} {
    kiwi::make_ipcores
}

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Add/Import constrs file and set constrs file properties
set file "[file normalize ${origin_dir}/KiwiSDR.xdc]"
if {[string equal $proj_create "yes"]} {
    set file_added [add_files -norecurse -fileset \
                        [get_filesets constrs_1] \
                        $file]
}
#-- set file "$origin_dir/KiwiSDR.xdc"
#-- set file [file normalize $file]
set_property -name "file_type" -value "XDC" \
    -objects [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "KiwiSDR" -objects $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 \
        -part $part \
        -flow {Vivado Synthesis 2017} \
        -strategy "Vivado Synthesis Defaults" \
        -report_strategy {No Reports} \
        -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2017" [get_runs synth_1]
}
set obj [get_runs synth_1]
puts "==================== $obj ===================="
set_property \
    -dict [ list set_report_strategy_name {1} \
                report_strategy {Vivado Synthesis Default Reports} \
                set_report_strategy_name {0} ] \
    $obj

proc gen_report {name type steps runs} {
    if { [ string equal [get_report_configs -of_objects [get_runs ${runs}] ${name}] "" ] } {
        create_report_config -report_name ${name} -report_type ${type} -steps ${steps} -runs ${runs}
    }
    set obj [get_report_configs -of_objects [get_runs ${runs}] ${name}]
    if { $obj != "" } {
        set_property -name "is_enabled" -value "0" -objects $obj
    }
}
gen_report synth_1_synth_report_utilization_0 report_utilization:1.0 synth_design synth_1

set obj [get_runs synth_1]
set_property -dict [ list part {xc7a35tftg256-1} \
                         strategy {Vivado Synthesis Defaults} ] $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 \
        -part $part \
        -flow {Vivado Implementation 2017} \
        -strategy "Vivado Implementation Defaults" \
        -report_strategy {No Reports} \
        -constrset constrs_1 \
        -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2017" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property -dict [ list set_report_strategy_name {1} \
                         report_strategy {Vivado Implementation Default Reports} \
                         set_report_strategy_name {0} ] $obj


gen_report impl_1_init_report_timing_summary_0 report_timing_summary:1.0 init_design impl_1
gen_report impl_1_opt_report_drc_0             report_drc:1.0            opt_design impl_1
gen_report impl_1_opt_report_timing_summary_0 report_timing_summary:1.0 opt_design impl_1
gen_report impl_1_power_opt_report_timing_summary_0 report_timing_summary:1.0 power_opt_design impl_1
gen_report impl_1_place_report_io_0 report_io:1.0 place_design impl_1
gen_report impl_1_place_report_utilization_0 report_utilization:1.0 place_design impl_1
gen_report impl_1_place_report_control_sets_0 report_control_sets:1.0 place_design impl_1
gen_report impl_1_place_report_incremental_reuse_0 report_incremental_reuse:1.0 place_design impl_1
gen_report impl_1_place_report_incremental_reuse_1 report_incremental_reuse:1.0 place_design impl_1
gen_report impl_1_place_report_timing_summary_0 report_timing_summary:1.0 place_design impl_1
gen_report impl_1_post_place_power_opt_report_timing_summary_0 report_timing_summary:1.0 post_place_power_opt_design impl_1
gen_report impl_1_phys_opt_report_timing_summary_0 report_timing_summary:1.0 phys_opt_design impl_1
gen_report impl_1_route_report_drc_0 report_drc:1.0 route_design impl_1
gen_report impl_1_route_report_methodology_0 report_methodology:1.0 route_design impl_1
gen_report impl_1_route_report_power_0 report_power:1.0 route_design impl_1
gen_report impl_1_route_report_route_status_0 report_route_status:1.0 route_design impl_1
gen_report impl_1_route_report_timing_summary_0 report_timing_summary:1.0 route_design impl_1
gen_report impl_1_route_report_incremental_reuse_0 report_incremental_reuse:1.0 route_design impl_1
gen_report impl_1_route_report_clock_utilization_0 report_clock_utilization:1.0 route_design impl_1
gen_report impl_1_post_route_phys_opt_report_timing_summary_0 report_timing_summary:1.0 post_route_phys_opt_design impl_1

set_property \
    -dict [ list part $part \
                strategy {Vivado Implementation Defaults} \
                steps.write_bitstream.args.readback_file {0} \
                steps.write_bitstream.args.verbose {0} ] \
    [get_runs impl_1]

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:$project_name"

proc set_rx_cfg rx_cfg {
    # the following doesn't seem to work, so do it via kiwi.cfg.vh file included by kiwi.vh
    #set_property generic {RX_CFG=4} [current_fileset]
    set fdw [open "kiwi.cfg.vh" "w"]
    puts $fdw "parameter RX_CFG = ${rx_cfg};"
    close $fdw
}

set impl_dir KiwiSDR/KiwiSDR.runs/impl_1

set_rx_cfg 4
update_compile_order -fileset sources_1
reset_run -quiet synth_1
#launch_runs synth_1 -jobs 6
#launch_runs impl_1 -jobs 6
launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1
file copy -force $impl_dir/KiwiSDR.bit $result_dir/KiwiSDR.rx4.wf4.bit
file copy -force $impl_dir/usage_statistics_webtalk.html $result_dir/KiwiSDR.rx4.wf4.html

set_rx_cfg 8
update_compile_order -fileset sources_1
reset_run -quiet synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1
file copy -force $impl_dir/KiwiSDR.bit $result_dir/KiwiSDR.rx8.wf2.bit
file copy -force $impl_dir/usage_statistics_webtalk.html $result_dir/KiwiSDR.rx8.wf2.html

set_rx_cfg 3
update_compile_order -fileset sources_1
reset_run -quiet synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1
file copy -force $impl_dir/KiwiSDR.bit $result_dir/KiwiSDR.rx3.wf3.bit
file copy -force $impl_dir/usage_statistics_webtalk.html $result_dir/KiwiSDR.rx3.wf3.html

puts "INFO: Build complete:$project_name"
