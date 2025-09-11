
################################################################
# This is a generated script based on design: tbd_multidev
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
# source tbd_multidev_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axi_gran_burst_splitter_wrapper, axi_gran_burst_splitter_wrapper, axi_gran_burst_splitter_wrapper, axi_isolate_wrapper, axi_isolate_wrapper, axi_isolate_wrapper, axi_rt_master_logic_wrapper

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
set design_name tbd_multidev

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
delgranchio.it:axi_rt:axi_rt_device_budget:1.0\
xilinx.com:ip:axi_traffic_gen:3.0\
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
  set M00_AXI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M00_AXI_0


  # Create ports
  set budget_r_0 [ create_bd_port -dir I -from 15 -to 0 budget_r_0 ]
  set budget_r_1 [ create_bd_port -dir I -from 15 -to 0 budget_r_1 ]
  set budget_r_2 [ create_bd_port -dir I -from 15 -to 0 budget_r_2 ]
  set budget_w_0 [ create_bd_port -dir I -from 15 -to 0 budget_w_0 ]
  set budget_w_1 [ create_bd_port -dir I -from 15 -to 0 budget_w_1 ]
  set budget_w_2 [ create_bd_port -dir I -from 15 -to 0 budget_w_2 ]
  set clock [ create_bd_port -dir I -type clk -freq_hz 100000000 clock ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {resetn} \
 ] $clock
  set downstream_p [ create_bd_port -dir I -from 15 -to 0 downstream_p ]
  set downstream_q [ create_bd_port -dir I -from 15 -to 0 downstream_q ]
  set enable_0 [ create_bd_port -dir I enable_0 ]
  set enable_1 [ create_bd_port -dir I enable_1 ]
  set enable_2 [ create_bd_port -dir I enable_2 ]
  set len_limit [ create_bd_port -dir I -from 7 -to 0 len_limit ]
  set resetn [ create_bd_port -dir I -type rst resetn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $resetn
  set traffic_start [ create_bd_port -dir I traffic_start ]
  set traffic_stop [ create_bd_port -dir I traffic_stop ]

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
  
  # Create instance: axi_traffic_gen_0, and set properties
  set axi_traffic_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_0 ]
  set_property -dict [list \
    CONFIG.ATG_HLT_CH_SELECT {Write_Only} \
    CONFIG.ATG_OPTIONS {High Level Traffic} \
    CONFIG.C_ATG_REPEAT_TYPE {Repetitive} \
    CONFIG.C_ATG_STATIC_HLTP_INCR {true} \
    CONFIG.DATA_ITG_GAP {0} \
    CONFIG.DATA_READ_SHARE {50} \
    CONFIG.DATA_SIZE_AVG {128} \
    CONFIG.DATA_TRANS_GAP {Fixed} \
    CONFIG.DATA_TRANS_TYPE {Read_Write} \
    CONFIG.MASTER_AXI_WIDTH {128} \
    CONFIG.MASTER_HIGH_ADDRESS {0x00007FFF} \
    CONFIG.PCIE_LANES {2} \
    CONFIG.PCIE_LANE_RATE {5} \
    CONFIG.PCIE_LOAD {80} \
    CONFIG.TRAFFIC_PROFILE {Data} \
  ] $axi_traffic_gen_0


  # Create instance: axi_traffic_gen_1, and set properties
  set axi_traffic_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_1 ]
  set_property -dict [list \
    CONFIG.ATG_HLT_CH_SELECT {Write_Only} \
    CONFIG.ATG_OPTIONS {High Level Traffic} \
    CONFIG.C_ATG_REPEAT_TYPE {Repetitive} \
    CONFIG.C_ATG_STATIC_HLTP_INCR {true} \
    CONFIG.DATA_ITG_GAP {0} \
    CONFIG.DATA_SIZE_AVG {128} \
    CONFIG.DATA_TRANS_GAP {Fixed} \
    CONFIG.DATA_TRANS_SEED {2} \
    CONFIG.MASTER_AXI_WIDTH {128} \
    CONFIG.MASTER_HIGH_ADDRESS {0x00007FFF} \
    CONFIG.PCIE_LANES {2} \
    CONFIG.PCIE_LANE_RATE {5} \
    CONFIG.PCIE_LOAD {80} \
    CONFIG.TRAFFIC_PROFILE {Data} \
  ] $axi_traffic_gen_1


  # Create instance: axi_traffic_gen_2, and set properties
  set axi_traffic_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_2 ]
  set_property -dict [list \
    CONFIG.ATG_HLT_CH_SELECT {Write_Only} \
    CONFIG.ATG_OPTIONS {High Level Traffic} \
    CONFIG.C_ATG_REPEAT_TYPE {Repetitive} \
    CONFIG.C_ATG_STATIC_HLTP_INCR {true} \
    CONFIG.DATA_ITG_GAP {0} \
    CONFIG.DATA_SIZE_AVG {128} \
    CONFIG.DATA_TRANS_GAP {Fixed} \
    CONFIG.DATA_TRANS_SEED {3} \
    CONFIG.MASTER_AXI_WIDTH {128} \
    CONFIG.MASTER_HIGH_ADDRESS {0x00007FFF} \
    CONFIG.PCIE_LANES {2} \
    CONFIG.PCIE_LANE_RATE {5} \
    CONFIG.PCIE_LOAD {80} \
    CONFIG.TRAFFIC_PROFILE {Data} \
  ] $axi_traffic_gen_2


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {3} \
  ] $smartconnect_0


  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins axi_gran_burst_split_2/m_axi_rt_0] [get_bd_intf_pins axi_isolate_wrapper_2/s_axi_rt_0]
connect_bd_intf_net -intf_net [get_bd_intf_nets Conn] [get_bd_intf_pins axi_gran_burst_split_2/m_axi_rt_0] [get_bd_intf_pins axi_rt_device_budget_2/axi_0]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_0_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_0/m_axi_rt_0] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_1_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_1/m_axi_rt_0] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_2_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_2/m_axi_rt_0] [get_bd_intf_pins smartconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins axi_gran_burst_split_0/s_axi_rt_0] [get_bd_intf_pins axi_traffic_gen_0/M_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_1_M_AXI [get_bd_intf_pins axi_gran_burst_split_1/s_axi_rt_0] [get_bd_intf_pins axi_traffic_gen_1/M_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_2_M_AXI [get_bd_intf_pins axi_gran_burst_split_2/s_axi_rt_0] [get_bd_intf_pins axi_traffic_gen_2/M_AXI]
  connect_bd_intf_net -intf_net axi_write_buffer_wra_0_m_axi_rt_0 [get_bd_intf_pins axi_gran_burst_split_0/m_axi_rt_0] [get_bd_intf_pins axi_isolate_wrapper_0/s_axi_rt_0]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_write_buffer_wra_0_m_axi_rt_0] [get_bd_intf_pins axi_gran_burst_split_0/m_axi_rt_0] [get_bd_intf_pins axi_rt_device_budget_0/axi_0]
  connect_bd_intf_net -intf_net axi_write_buffer_wra_1_m_axi_rt_0 [get_bd_intf_pins axi_gran_burst_split_1/m_axi_rt_0] [get_bd_intf_pins axi_isolate_wrapper_1/s_axi_rt_0]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_write_buffer_wra_1_m_axi_rt_0] [get_bd_intf_pins axi_gran_burst_split_1/m_axi_rt_0] [get_bd_intf_pins axi_rt_device_budget_1/axi_0]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_ports M00_AXI_0] [get_bd_intf_pins smartconnect_0/M00_AXI]

  # Create port connections
  connect_bd_net -net Net [get_bd_ports enable_0] [get_bd_pins axi_rt_device_budget_0/enable] [get_bd_pins axi_rt_master_logic_0/enable_0]
  connect_bd_net -net Net1 [get_bd_ports budget_w_0] [get_bd_pins axi_rt_device_budget_0/budget_w] [get_bd_pins axi_rt_master_logic_0/budget_w_0]
  connect_bd_net -net Net2 [get_bd_ports traffic_start] [get_bd_pins axi_traffic_gen_0/core_ext_start] [get_bd_pins axi_traffic_gen_1/core_ext_start] [get_bd_pins axi_traffic_gen_2/core_ext_start]
  connect_bd_net -net Net3 [get_bd_ports traffic_stop] [get_bd_pins axi_traffic_gen_0/core_ext_stop] [get_bd_pins axi_traffic_gen_1/core_ext_stop] [get_bd_pins axi_traffic_gen_2/core_ext_stop]
  connect_bd_net -net Net4 [get_bd_ports budget_r_0] [get_bd_pins axi_rt_device_budget_0/budget_r] [get_bd_pins axi_rt_master_logic_0/budget_r_0]
  connect_bd_net -net Net5 [get_bd_ports budget_w_1] [get_bd_pins axi_rt_device_budget_1/budget_w] [get_bd_pins axi_rt_master_logic_0/budget_w_1]
  connect_bd_net -net Net6 [get_bd_ports budget_r_1] [get_bd_pins axi_rt_device_budget_1/budget_r] [get_bd_pins axi_rt_master_logic_0/budget_r_1]
  connect_bd_net -net Net9 [get_bd_ports budget_w_2] [get_bd_pins axi_rt_device_budget_2/budget_w] [get_bd_pins axi_rt_master_logic_0/budget_w_2]
  connect_bd_net -net Net10 [get_bd_ports budget_r_2] [get_bd_pins axi_rt_device_budget_2/budget_r] [get_bd_pins axi_rt_master_logic_0/budget_r_2]
  connect_bd_net -net aresetn_1 [get_bd_ports resetn] [get_bd_pins axi_gran_burst_split_0/resetn] [get_bd_pins axi_gran_burst_split_1/resetn] [get_bd_pins axi_gran_burst_split_2/resetn] [get_bd_pins axi_isolate_wrapper_0/resetn] [get_bd_pins axi_isolate_wrapper_1/resetn] [get_bd_pins axi_isolate_wrapper_2/resetn] [get_bd_pins axi_rt_device_budget_0/aresetn] [get_bd_pins axi_rt_device_budget_1/aresetn] [get_bd_pins axi_rt_device_budget_2/aresetn] [get_bd_pins axi_rt_master_logic_0/resetn] [get_bd_pins axi_traffic_gen_0/s_axi_aresetn] [get_bd_pins axi_traffic_gen_1/s_axi_aresetn] [get_bd_pins axi_traffic_gen_2/s_axi_aresetn] [get_bd_pins smartconnect_0/aresetn]
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
  connect_bd_net -net clock_1 [get_bd_ports clock] [get_bd_pins axi_gran_burst_split_0/clk] [get_bd_pins axi_gran_burst_split_1/clk] [get_bd_pins axi_gran_burst_split_2/clk] [get_bd_pins axi_isolate_wrapper_0/clk] [get_bd_pins axi_isolate_wrapper_1/clk] [get_bd_pins axi_isolate_wrapper_2/clk] [get_bd_pins axi_rt_device_budget_0/clock] [get_bd_pins axi_rt_device_budget_1/clock] [get_bd_pins axi_rt_device_budget_2/clock] [get_bd_pins axi_rt_master_logic_0/clock] [get_bd_pins axi_traffic_gen_0/s_axi_aclk] [get_bd_pins axi_traffic_gen_1/s_axi_aclk] [get_bd_pins axi_traffic_gen_2/s_axi_aclk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net downstream_p_0_1 [get_bd_ports downstream_p] [get_bd_pins axi_rt_master_logic_0/downstream_p]
  connect_bd_net -net downstream_q_0_1 [get_bd_ports downstream_q] [get_bd_pins axi_rt_master_logic_0/downstream_q]
  connect_bd_net -net enable_1_0_1 [get_bd_ports enable_1] [get_bd_pins axi_rt_device_budget_1/enable] [get_bd_pins axi_rt_master_logic_0/enable_1]
  connect_bd_net -net enable_2_0_1 [get_bd_ports enable_2] [get_bd_pins axi_rt_device_budget_2/enable] [get_bd_pins axi_rt_master_logic_0/enable_2]
  connect_bd_net -net len_limit_0_1 [get_bd_ports len_limit] [get_bd_pins axi_gran_burst_split_0/len_limit] [get_bd_pins axi_gran_burst_split_1/len_limit] [get_bd_pins axi_gran_burst_split_2/len_limit]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_0/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_0/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_1/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_1/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_2/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_2/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_0/m_axi_rt_0] [get_bd_addr_segs M00_AXI_0/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_1/m_axi_rt_0] [get_bd_addr_segs M00_AXI_0/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_2/m_axi_rt_0] [get_bd_addr_segs M00_AXI_0/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_0/Data] [get_bd_addr_segs axi_gran_burst_split_0/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_1/Data] [get_bd_addr_segs axi_gran_burst_split_1/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_2/Data] [get_bd_addr_segs axi_gran_burst_split_2/s_axi_rt_0/reg0] -force


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


