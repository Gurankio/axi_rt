
################################################################
# This is a generated script based on design: tbd_multidev_vip
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source tbd_multidev_vip_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axi_gran_burst_splitter_wrapper, axi_gran_burst_splitter_wrapper, axi_gran_burst_splitter_wrapper, axi_isolate_wrapper, axi_isolate_wrapper, axi_isolate_wrapper, axi_rt_master_logic_wrapper, constant_configurator

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xck26-sfvc784-2LV-c
   set_property BOARD_PART xilinx.com:kr260_som:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name tbd_multidev_vip

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  # Set the reference directory for source file relative paths (by default 
  # the value is script directory path)
  set origin_dir ./vivado_ws/kria_kr_260_projs/axi_rt-vivado-test/vivamir/vivado_ws/kria_kr_260_projs/axi_rt-vivado-test/vivamir/project/srcs

  # Use origin directory path location variable, if specified in the tcl shell
  if { [info exists ::origin_dir_loc] } {
     set origin_dir $::origin_dir_loc
  }

  set str_bd_folder [file normalize ${origin_dir}]
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2030 -severity "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_gid_msg -ssname BD::TCL -id 2031 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_gid_msg -ssname BD::TCL -id 2032 -severity "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2033 -severity "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_gid_msg -ssname BD::TCL -id 2034 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files -quiet */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2035 -severity "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_gid_msg -ssname BD::TCL -id 2036 -severity "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_gid_msg -ssname BD::TCL -id 2037 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  # NOTE - usage of <-dir> will create <$str_bd_folder/$design_name/$design_name.bd>
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_gid_msg -ssname BD::TCL -id 2038 -severity "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
delgranchio.it:axi_rt:axi_rt_device_budget:1.0\
xilinx.com:ip:axi_vip:1.1\
xilinx.com:ip:smartconnect:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
axi_gran_burst_splitter_wrapper\
axi_gran_burst_splitter_wrapper\
axi_gran_burst_splitter_wrapper\
axi_isolate_wrapper\
axi_isolate_wrapper\
axi_isolate_wrapper\
axi_rt_master_logic_wrapper\
constant_configurator\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set clock [ create_bd_port -dir I -type clk -freq_hz 100000000 clock ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {resetn} \
 ] $clock
  set resetn [ create_bd_port -dir I -type rst resetn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $resetn

  # Create instance: axi_gran_burst_split_0, and set properties
  set block_name axi_gran_burst_splitter_wrapper
  set block_cell_name axi_gran_burst_split_0
  if { [catch {set axi_gran_burst_split_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_gran_burst_split_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.AddrWidth {0x00000020} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000008} \
  ] $axi_gran_burst_split_0


  # Create instance: axi_gran_burst_split_1, and set properties
  set block_name axi_gran_burst_splitter_wrapper
  set block_cell_name axi_gran_burst_split_1
  if { [catch {set axi_gran_burst_split_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_gran_burst_split_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.AddrWidth {0x00000020} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000008} \
  ] $axi_gran_burst_split_1


  # Create instance: axi_gran_burst_split_2, and set properties
  set block_name axi_gran_burst_splitter_wrapper
  set block_cell_name axi_gran_burst_split_2
  if { [catch {set axi_gran_burst_split_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_gran_burst_split_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.AddrWidth {0x00000020} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000008} \
  ] $axi_gran_burst_split_2


  # Create instance: axi_isolate_wrapper_0, and set properties
  set block_name axi_isolate_wrapper
  set block_cell_name axi_isolate_wrapper_0
  if { [catch {set axi_isolate_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_isolate_wrapper_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.AddrWidth {0x00000020} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000008} \
  ] $axi_isolate_wrapper_0


  # Create instance: axi_isolate_wrapper_1, and set properties
  set block_name axi_isolate_wrapper
  set block_cell_name axi_isolate_wrapper_1
  if { [catch {set axi_isolate_wrapper_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_isolate_wrapper_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.AddrWidth {0x00000020} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000008} \
  ] $axi_isolate_wrapper_1


  # Create instance: axi_isolate_wrapper_2, and set properties
  set block_name axi_isolate_wrapper
  set block_cell_name axi_isolate_wrapper_2
  if { [catch {set axi_isolate_wrapper_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_isolate_wrapper_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.AddrWidth {0x00000020} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000008} \
  ] $axi_isolate_wrapper_2


  # Create instance: axi_rt_device_budget_0, and set properties
  set axi_rt_device_budget_0 [ create_bd_cell -type ip -vlnv delgranchio.it:axi_rt:axi_rt_device_budget:1.0 axi_rt_device_budget_0 ]
  set_property -dict [list \
    CONFIG.AxiAddrWidth {32} \
    CONFIG.AxiDataWidth {128} \
    CONFIG.AxiIdWidth {2} \
    CONFIG.AxiUserWidth {8} \
  ] $axi_rt_device_budget_0


  # Create instance: axi_rt_device_budget_1, and set properties
  set axi_rt_device_budget_1 [ create_bd_cell -type ip -vlnv delgranchio.it:axi_rt:axi_rt_device_budget:1.0 axi_rt_device_budget_1 ]
  set_property -dict [list \
    CONFIG.AxiAddrWidth {32} \
    CONFIG.AxiDataWidth {128} \
    CONFIG.AxiIdWidth {2} \
    CONFIG.AxiUserWidth {8} \
  ] $axi_rt_device_budget_1


  # Create instance: axi_rt_device_budget_2, and set properties
  set axi_rt_device_budget_2 [ create_bd_cell -type ip -vlnv delgranchio.it:axi_rt:axi_rt_device_budget:1.0 axi_rt_device_budget_2 ]
  set_property -dict [list \
    CONFIG.AxiAddrWidth {32} \
    CONFIG.AxiDataWidth {128} \
    CONFIG.AxiIdWidth {2} \
    CONFIG.AxiUserWidth {8} \
  ] $axi_rt_device_budget_2


  # Create instance: axi_rt_master_logic_0, and set properties
  set block_name axi_rt_master_logic_wrapper
  set block_cell_name axi_rt_master_logic_0
  if { [catch {set axi_rt_master_logic_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_rt_master_logic_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property CONFIG.Reclaiming {0x00000000} $axi_rt_master_logic_0


  # Create instance: axi_vip_0, and set properties
  set axi_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property -dict [list \
    CONFIG.ADDR_WIDTH {49} \
    CONFIG.ARUSER_WIDTH {8} \
    CONFIG.AWUSER_WIDTH {8} \
    CONFIG.BUSER_WIDTH {0} \
    CONFIG.DATA_WIDTH {128} \
    CONFIG.HAS_BRESP {1} \
    CONFIG.HAS_BURST {1} \
    CONFIG.HAS_CACHE {1} \
    CONFIG.HAS_LOCK {1} \
    CONFIG.HAS_PROT {1} \
    CONFIG.HAS_QOS {1} \
    CONFIG.HAS_REGION {1} \
    CONFIG.HAS_RRESP {1} \
    CONFIG.HAS_WSTRB {1} \
    CONFIG.ID_WIDTH {0} \
    CONFIG.INTERFACE_MODE {MASTER} \
    CONFIG.PROTOCOL {AXI4} \
    CONFIG.READ_WRITE_MODE {READ_WRITE} \
    CONFIG.RUSER_WIDTH {0} \
    CONFIG.SUPPORTS_NARROW {1} \
    CONFIG.WUSER_WIDTH {0} \
  ] $axi_vip_0


  # Create instance: axi_vip_1, and set properties
  set axi_vip_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1 ]
  set_property -dict [list \
    CONFIG.ADDR_WIDTH {49} \
    CONFIG.DATA_WIDTH {128} \
    CONFIG.INTERFACE_MODE {SLAVE} \
  ] $axi_vip_1


  # Create instance: axi_vip_2, and set properties
  set axi_vip_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_2 ]
  set_property -dict [list \
    CONFIG.ADDR_WIDTH {49} \
    CONFIG.ARUSER_WIDTH {8} \
    CONFIG.AWUSER_WIDTH {8} \
    CONFIG.BUSER_WIDTH {0} \
    CONFIG.DATA_WIDTH {128} \
    CONFIG.HAS_BRESP {1} \
    CONFIG.HAS_BURST {1} \
    CONFIG.HAS_CACHE {1} \
    CONFIG.HAS_LOCK {1} \
    CONFIG.HAS_PROT {1} \
    CONFIG.HAS_QOS {1} \
    CONFIG.HAS_REGION {1} \
    CONFIG.HAS_RRESP {1} \
    CONFIG.HAS_WSTRB {1} \
    CONFIG.ID_WIDTH {0} \
    CONFIG.INTERFACE_MODE {MASTER} \
    CONFIG.PROTOCOL {AXI4} \
    CONFIG.READ_WRITE_MODE {READ_WRITE} \
    CONFIG.RUSER_WIDTH {0} \
    CONFIG.SUPPORTS_NARROW {1} \
    CONFIG.WUSER_WIDTH {0} \
  ] $axi_vip_2


  # Create instance: axi_vip_3, and set properties
  set axi_vip_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_3 ]
  set_property -dict [list \
    CONFIG.ADDR_WIDTH {49} \
    CONFIG.ARUSER_WIDTH {8} \
    CONFIG.AWUSER_WIDTH {8} \
    CONFIG.BUSER_WIDTH {0} \
    CONFIG.DATA_WIDTH {128} \
    CONFIG.HAS_BRESP {1} \
    CONFIG.HAS_BURST {1} \
    CONFIG.HAS_CACHE {1} \
    CONFIG.HAS_LOCK {1} \
    CONFIG.HAS_PROT {1} \
    CONFIG.HAS_QOS {1} \
    CONFIG.HAS_REGION {1} \
    CONFIG.HAS_RRESP {1} \
    CONFIG.HAS_WSTRB {1} \
    CONFIG.ID_WIDTH {2} \
    CONFIG.INTERFACE_MODE {MASTER} \
    CONFIG.PROTOCOL {AXI4} \
    CONFIG.READ_WRITE_MODE {READ_WRITE} \
    CONFIG.RUSER_WIDTH {0} \
    CONFIG.SUPPORTS_NARROW {1} \
    CONFIG.WUSER_WIDTH {0} \
  ] $axi_vip_3


  # Create instance: constant_configurator_0, and set properties
  set block_name constant_configurator
  set block_cell_name constant_configurator_0
  if { [catch {set constant_configurator_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $constant_configurator_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.BudgetR0 {1} \
    CONFIG.BudgetR1 {1} \
    CONFIG.BudgetR2 {1} \
    CONFIG.BudgetW0 {1} \
    CONFIG.BudgetW1 {1} \
    CONFIG.BudgetW2 {1} \
    CONFIG.Enable0 {1} \
    CONFIG.Enable1 {1} \
    CONFIG.Enable2 {1} \
    CONFIG.ResetDelay {32} \
  ] $constant_configurator_0


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property CONFIG.NUM_SI {1} $smartconnect_0


  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property CONFIG.NUM_SI {1} $smartconnect_1


  # Create instance: smartconnect_2, and set properties
  set smartconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_2 ]
  set_property -dict [list \
    CONFIG.ADVANCED_PROPERTIES { __experimental_features__ {enable_multithreaded_mi 1}  __view__ { functional {  M00_Exit {NUM_READ_THREADS 4 NUM_WRITE_THREADS 4}  M01_Exit {NUM_READ_THREADS 4 NUM_WRITE_THREADS\
4}}}} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_2


  # Create instance: smartconnect_3, and set properties
  set smartconnect_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_3 ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {3} \
  ] $smartconnect_3


  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins axi_gran_burst_split_2/m_axi_rt_0] [get_bd_intf_pins axi_isolate_wrapper_2/s_axi_rt_0]
connect_bd_intf_net -intf_net [get_bd_intf_nets Conn] [get_bd_intf_pins axi_gran_burst_split_2/m_axi_rt_0] [get_bd_intf_pins axi_rt_device_budget_2/axi_0]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_0_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_0/m_axi_rt_0] [get_bd_intf_pins smartconnect_3/S00_AXI]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_1_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_1/m_axi_rt_0] [get_bd_intf_pins smartconnect_3/S01_AXI]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_2_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_2/m_axi_rt_0] [get_bd_intf_pins smartconnect_3/S02_AXI]
  connect_bd_intf_net -intf_net axi_vip_0_M_AXI [get_bd_intf_pins axi_vip_0/M_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_vip_2_M_AXI [get_bd_intf_pins axi_vip_2/M_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net axi_vip_3_M_AXI [get_bd_intf_pins axi_vip_3/M_AXI] [get_bd_intf_pins smartconnect_2/S00_AXI]
  connect_bd_intf_net -intf_net axi_write_buffer_wra_0_m_axi_rt_0 [get_bd_intf_pins axi_gran_burst_split_0/m_axi_rt_0] [get_bd_intf_pins axi_isolate_wrapper_0/s_axi_rt_0]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_write_buffer_wra_0_m_axi_rt_0] [get_bd_intf_pins axi_gran_burst_split_0/m_axi_rt_0] [get_bd_intf_pins axi_rt_device_budget_0/axi_0]
  connect_bd_intf_net -intf_net axi_write_buffer_wra_1_m_axi_rt_0 [get_bd_intf_pins axi_gran_burst_split_1/m_axi_rt_0] [get_bd_intf_pins axi_isolate_wrapper_1/s_axi_rt_0]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_write_buffer_wra_1_m_axi_rt_0] [get_bd_intf_pins axi_gran_burst_split_1/m_axi_rt_0] [get_bd_intf_pins axi_rt_device_budget_1/axi_0]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI1 [get_bd_intf_pins axi_gran_burst_split_0/s_axi_rt_0] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_gran_burst_split_1/s_axi_rt_0] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_2_M00_AXI [get_bd_intf_pins axi_gran_burst_split_2/s_axi_rt_0] [get_bd_intf_pins smartconnect_2/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_3_M00_AXI [get_bd_intf_pins axi_vip_1/S_AXI] [get_bd_intf_pins smartconnect_3/M00_AXI]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins axi_rt_device_budget_0/enable] [get_bd_pins axi_rt_master_logic_0/enable_0] [get_bd_pins constant_configurator_0/enable_0]
  connect_bd_net -net Net1 [get_bd_pins axi_rt_device_budget_0/budget_w] [get_bd_pins axi_rt_master_logic_0/budget_w_0] [get_bd_pins constant_configurator_0/budget_w_0]
  connect_bd_net -net Net4 [get_bd_pins axi_rt_device_budget_0/budget_r] [get_bd_pins axi_rt_master_logic_0/budget_r_0] [get_bd_pins constant_configurator_0/budget_r_0]
  connect_bd_net -net Net5 [get_bd_pins axi_rt_device_budget_1/budget_w] [get_bd_pins axi_rt_master_logic_0/budget_w_1] [get_bd_pins constant_configurator_0/budget_w_1]
  connect_bd_net -net Net6 [get_bd_pins axi_rt_device_budget_1/budget_r] [get_bd_pins axi_rt_master_logic_0/budget_r_1] [get_bd_pins constant_configurator_0/budget_r_1]
  connect_bd_net -net Net9 [get_bd_pins axi_rt_device_budget_2/budget_w] [get_bd_pins axi_rt_master_logic_0/budget_w_2] [get_bd_pins constant_configurator_0/budget_w_2]
  connect_bd_net -net Net10 [get_bd_pins axi_rt_device_budget_2/budget_r] [get_bd_pins axi_rt_master_logic_0/budget_r_2] [get_bd_pins constant_configurator_0/budget_r_2]
  connect_bd_net -net aresetn_1 [get_bd_ports resetn] [get_bd_pins axi_gran_burst_split_0/resetn] [get_bd_pins axi_gran_burst_split_1/resetn] [get_bd_pins axi_gran_burst_split_2/resetn] [get_bd_pins axi_isolate_wrapper_0/resetn] [get_bd_pins axi_isolate_wrapper_1/resetn] [get_bd_pins axi_isolate_wrapper_2/resetn] [get_bd_pins axi_rt_device_budget_0/aresetn] [get_bd_pins axi_rt_device_budget_1/aresetn] [get_bd_pins axi_rt_device_budget_2/aresetn] [get_bd_pins axi_rt_master_logic_0/resetn] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins axi_vip_1/aresetn] [get_bd_pins axi_vip_2/aresetn] [get_bd_pins axi_vip_3/aresetn] [get_bd_pins constant_configurator_0/aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn] [get_bd_pins smartconnect_2/aresetn] [get_bd_pins smartconnect_3/aresetn]
  connect_bd_net -net axi_rt_device_budget_0_budget_spent_r [get_bd_pins axi_isolate_wrapper_0/isolate_r] [get_bd_pins axi_rt_device_budget_0/budget_spent_r]
  connect_bd_net -net axi_rt_device_budget_0_budget_spent_w [get_bd_pins axi_isolate_wrapper_0/isolate_w] [get_bd_pins axi_rt_device_budget_0/budget_spent_w]
  connect_bd_net -net axi_rt_device_budget_0_budget_used_r [get_bd_pins axi_rt_device_budget_0/budget_used_r] [get_bd_pins axi_rt_master_logic_0/device_budget_used_r_0]
  connect_bd_net -net axi_rt_device_budget_0_budget_used_w [get_bd_pins axi_rt_device_budget_0/budget_used_w] [get_bd_pins axi_rt_master_logic_0/device_budget_used_w_0]
  connect_bd_net -net axi_rt_device_budget_1_budget_spent_r [get_bd_pins axi_isolate_wrapper_1/isolate_r] [get_bd_pins axi_rt_device_budget_1/budget_spent_r]
  connect_bd_net -net axi_rt_device_budget_1_budget_spent_w [get_bd_pins axi_isolate_wrapper_1/isolate_w] [get_bd_pins axi_rt_device_budget_1/budget_spent_w]
  connect_bd_net -net axi_rt_device_budget_1_budget_used_r [get_bd_pins axi_rt_device_budget_1/budget_used_r] [get_bd_pins axi_rt_master_logic_0/device_budget_used_r_1]
  connect_bd_net -net axi_rt_device_budget_1_budget_used_w [get_bd_pins axi_rt_device_budget_1/budget_used_w] [get_bd_pins axi_rt_master_logic_0/device_budget_used_w_1]
  connect_bd_net -net axi_rt_device_budget_2_budget_spent_r [get_bd_pins axi_isolate_wrapper_2/isolate_r] [get_bd_pins axi_rt_device_budget_2/budget_spent_r]
  connect_bd_net -net axi_rt_device_budget_2_budget_spent_w [get_bd_pins axi_isolate_wrapper_2/isolate_w] [get_bd_pins axi_rt_device_budget_2/budget_spent_w]
  connect_bd_net -net axi_rt_device_budget_2_budget_used_r [get_bd_pins axi_rt_device_budget_2/budget_used_r] [get_bd_pins axi_rt_master_logic_0/device_budget_used_r_2]
  connect_bd_net -net axi_rt_device_budget_2_budget_used_w [get_bd_pins axi_rt_device_budget_2/budget_used_w] [get_bd_pins axi_rt_master_logic_0/device_budget_used_w_2]
  connect_bd_net -net axi_rt_master_logic_0_device_incr_r_0 [get_bd_pins axi_rt_device_budget_0/incr_r] [get_bd_pins axi_rt_master_logic_0/device_incr_r_0]
  connect_bd_net -net axi_rt_master_logic_0_device_incr_r_1 [get_bd_pins axi_rt_device_budget_1/incr_r] [get_bd_pins axi_rt_master_logic_0/device_incr_r_1]
  connect_bd_net -net axi_rt_master_logic_0_device_incr_r_2 [get_bd_pins axi_rt_device_budget_2/incr_r] [get_bd_pins axi_rt_master_logic_0/device_incr_r_2]
  connect_bd_net -net axi_rt_master_logic_0_device_incr_w_0 [get_bd_pins axi_rt_device_budget_0/incr_w] [get_bd_pins axi_rt_master_logic_0/device_incr_w_0]
  connect_bd_net -net axi_rt_master_logic_0_device_incr_w_1 [get_bd_pins axi_rt_device_budget_1/incr_w] [get_bd_pins axi_rt_master_logic_0/device_incr_w_1]
  connect_bd_net -net axi_rt_master_logic_0_device_incr_w_2 [get_bd_pins axi_rt_device_budget_2/incr_w] [get_bd_pins axi_rt_master_logic_0/device_incr_w_2]
  connect_bd_net -net clock_1 [get_bd_ports clock] [get_bd_pins axi_gran_burst_split_0/clk] [get_bd_pins axi_gran_burst_split_1/clk] [get_bd_pins axi_gran_burst_split_2/clk] [get_bd_pins axi_isolate_wrapper_0/clk] [get_bd_pins axi_isolate_wrapper_1/clk] [get_bd_pins axi_isolate_wrapper_2/clk] [get_bd_pins axi_rt_device_budget_0/clock] [get_bd_pins axi_rt_device_budget_1/clock] [get_bd_pins axi_rt_device_budget_2/clock] [get_bd_pins axi_rt_master_logic_0/clock] [get_bd_pins axi_vip_0/aclk] [get_bd_pins axi_vip_1/aclk] [get_bd_pins axi_vip_2/aclk] [get_bd_pins axi_vip_3/aclk] [get_bd_pins constant_configurator_0/clock] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk] [get_bd_pins smartconnect_2/aclk] [get_bd_pins smartconnect_3/aclk]
  connect_bd_net -net constant_configurator_0_downstream_p [get_bd_pins axi_rt_master_logic_0/downstream_p] [get_bd_pins constant_configurator_0/downstream_p]
  connect_bd_net -net constant_configurator_0_downstream_q [get_bd_pins axi_rt_master_logic_0/downstream_q] [get_bd_pins constant_configurator_0/downstream_q]
  connect_bd_net -net enable_1_0_1 [get_bd_pins axi_rt_device_budget_1/enable] [get_bd_pins axi_rt_master_logic_0/enable_1] [get_bd_pins constant_configurator_0/enable_1]
  connect_bd_net -net enable_2_0_1 [get_bd_pins axi_rt_device_budget_2/enable] [get_bd_pins axi_rt_master_logic_0/enable_2] [get_bd_pins constant_configurator_0/enable_2]
  connect_bd_net -net len_limit_0_1 [get_bd_pins axi_gran_burst_split_0/len_limit] [get_bd_pins axi_gran_burst_split_1/len_limit] [get_bd_pins axi_gran_burst_split_2/len_limit] [get_bd_pins constant_configurator_0/len_limit]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_0/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_0/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_1/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_1/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_2/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_2/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_0/m_axi_rt_0] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_1/m_axi_rt_0] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_2/m_axi_rt_0] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_gran_burst_split_0/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_vip_2/Master_AXI] [get_bd_addr_segs axi_gran_burst_split_1/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_vip_3/Master_AXI] [get_bd_addr_segs axi_gran_burst_split_2/s_axi_rt_0/reg0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


