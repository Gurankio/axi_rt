
################################################################
# This is a generated script based on design: bd_axi_rt
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
# source bd_axi_rt_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axi_gran_burst_splitter_wrapper, axi_isolate_wrapper, axi_rt_logic_wrapper, axi_write_buffer_wrapper

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xck26-sfvc784-2LV-c
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd_axi_rt

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
xilinx.com:ip:axi_bram_ctrl:4.1\
delgranchio.it:axi_lat_monitor:axi_lat_monitor_v2:2.0\
xilinx.com:ip:axi_traffic_gen:3.0\
xilinx.com:ip:axi_vip:1.1\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:util_vector_logic:2.0\
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
axi_isolate_wrapper\
axi_rt_logic_wrapper\
axi_write_buffer_wrapper\
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
  set clk [ create_bd_port -dir I clk ]
  set imtu_abort [ create_bd_port -dir I imtu_abort ]
  set imtu_enable [ create_bd_port -dir I imtu_enable ]
  set isolated [ create_bd_port -dir O -from 0 -to 0 isolated ]
  set r_budget [ create_bd_port -dir I -from 15 -to 0 r_budget ]
  set r_budget_left [ create_bd_port -dir O -from 15 -to 0 r_budget_left ]
  set r_budget_spent [ create_bd_port -dir O r_budget_spent ]
  set r_period [ create_bd_port -dir I -from 15 -to 0 r_period ]
  set r_period_left [ create_bd_port -dir O -from 15 -to 0 r_period_left ]
  set resetn [ create_bd_port -dir I resetn ]
  set splitter_len_limit [ create_bd_port -dir I -from 7 -to 0 splitter_len_limit ]
  set traffic_start [ create_bd_port -dir I traffic_start ]
  set traffic_stop [ create_bd_port -dir I traffic_stop ]
  set w_budget [ create_bd_port -dir I -from 15 -to 0 w_budget ]
  set w_budget_left [ create_bd_port -dir O -from 15 -to 0 w_budget_left ]
  set w_budget_spent [ create_bd_port -dir O w_budget_spent ]
  set w_period [ create_bd_port -dir I -from 15 -to 0 w_period ]
  set w_period_left [ create_bd_port -dir O -from 15 -to 0 w_period_left ]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $axi_bram_ctrl_0


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
    CONFIG.IdWidth {0x00000001} \
    CONFIG.MaxReadTxns {0x00000040} \
    CONFIG.MaxWriteTxns {0x00000040} \
    CONFIG.UserWidth {0x00000008} \
  ] $axi_gran_burst_split_0


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
    CONFIG.AtopSupport {"0"} \
    CONFIG.IdWidth {0x00000001} \
    CONFIG.UserWidth {0x00000008} \
  ] $axi_isolate_wrapper_1


  # Create instance: axi_lat_monitor_0, and set properties
  set axi_lat_monitor_0 [ create_bd_cell -type ip -vlnv delgranchio.it:axi_lat_monitor:axi_lat_monitor_v2:2.0 axi_lat_monitor_0 ]

  # Create instance: axi_rt_logic_wrapper_0, and set properties
  set block_name axi_rt_logic_wrapper
  set block_cell_name axi_rt_logic_wrapper_0
  if { [catch {set axi_rt_logic_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_rt_logic_wrapper_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_traffic_gen_0, and set properties
  set axi_traffic_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_0 ]
  set_property -dict [list \
    CONFIG.ATG_HLT_CH_SELECT {Write_Only} \
    CONFIG.ATG_HLT_STATIC_LENGTH {64} \
    CONFIG.ATG_OPTIONS {High Level Traffic} \
    CONFIG.C_ATG_REPEAT_TYPE {Repetitive} \
    CONFIG.C_ATG_STATIC_HLTP_INCR {false} \
    CONFIG.C_EXTENDED_ADDRESS_WIDTH_HLT {48} \
    CONFIG.DATA_SIZE_AVG {16} \
    CONFIG.DATA_SIZE_MAX {32} \
    CONFIG.DATA_SIZE_MIN {4} \
    CONFIG.DATA_TRAFFIC_PATTERN {Random} \
    CONFIG.DATA_TRANS_GAP {Fixed} \
    CONFIG.DATA_TRANS_SEED {1} \
    CONFIG.DATA_TRANS_TYPE {Write_Only} \
    CONFIG.DATA_WRITE_SHARE {100} \
    CONFIG.ETHERNET_LOAD {100} \
    CONFIG.MASTER_AXI_WIDTH {64} \
    CONFIG.PCIE_LANES {4} \
    CONFIG.PCIE_LANE_RATE {2.5} \
    CONFIG.TRAFFIC_PROFILE {Data} \
    CONFIG.VIDEO_FORMAT {6} \
    CONFIG.VIDEO_FRAME_RATE {75} \
    CONFIG.VIDEO_PIXEL_BITS {12} \
  ] $axi_traffic_gen_0


  # Create instance: axi_vip_1, and set properties
  set axi_vip_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1 ]

  # Create instance: axi_vip_2, and set properties
  set axi_vip_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_2 ]

  # Create instance: axi_vip_3, and set properties
  set axi_vip_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_3 ]

  # Create instance: axi_vip_4, and set properties
  set axi_vip_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_4 ]
  set_property CONFIG.INTERFACE_MODE {PASS_THROUGH} $axi_vip_4


  # Create instance: axi_write_buffer_wra_0, and set properties
  set block_name axi_write_buffer_wrapper
  set block_cell_name axi_write_buffer_wra_0
  if { [catch {set axi_write_buffer_wra_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_write_buffer_wra_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.IdWidth {0x00000001} \
    CONFIG.UserWidth {0x00000008} \
  ] $axi_write_buffer_wra_0


  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [list \
    CONFIG.PRIM_type_to_Implement {BRAM} \
    CONFIG.Write_Width_A {64} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $blk_mem_gen_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_1


  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_gran_burst_split_0_m_axi_rt_0 [get_bd_intf_pins axi_gran_burst_split_0/m_axi_rt_0] [get_bd_intf_pins axi_vip_2/S_AXI]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_1_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_1/m_axi_rt_0] [get_bd_intf_pins axi_vip_4/S_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins axi_traffic_gen_0/M_AXI] [get_bd_intf_pins axi_vip_1/S_AXI]
  connect_bd_intf_net -intf_net axi_vip_1_M_AXI [get_bd_intf_pins axi_gran_burst_split_0/s_axi_rt_0] [get_bd_intf_pins axi_vip_1/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_2_M_AXI [get_bd_intf_pins axi_vip_2/M_AXI] [get_bd_intf_pins axi_write_buffer_wra_0/s_axi_rt_0]
  connect_bd_intf_net -intf_net axi_vip_3_M_AXI [get_bd_intf_pins axi_isolate_wrapper_1/s_axi_rt_0] [get_bd_intf_pins axi_vip_3/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_vip_3_M_AXI] [get_bd_intf_pins axi_lat_monitor_0/axi] [get_bd_intf_pins axi_vip_3/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_4_M_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_vip_4/M_AXI]
  connect_bd_intf_net -intf_net axi_write_buffer_wra_0_m_axi_rt_0 [get_bd_intf_pins axi_vip_3/S_AXI] [get_bd_intf_pins axi_write_buffer_wra_0/m_axi_rt_0]

  # Create port connections
  connect_bd_net -net Net [get_bd_ports clk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_gran_burst_split_0/clk] [get_bd_pins axi_isolate_wrapper_1/clk] [get_bd_pins axi_lat_monitor_0/axi_aclk] [get_bd_pins axi_rt_logic_wrapper_0/clk] [get_bd_pins axi_traffic_gen_0/s_axi_aclk] [get_bd_pins axi_vip_1/aclk] [get_bd_pins axi_vip_2/aclk] [get_bd_pins axi_vip_3/aclk] [get_bd_pins axi_vip_4/aclk] [get_bd_pins axi_write_buffer_wra_0/clk]
  connect_bd_net -net Net1 [get_bd_ports resetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_gran_burst_split_0/resetn] [get_bd_pins axi_isolate_wrapper_1/resetn] [get_bd_pins axi_lat_monitor_0/axi_aresetn] [get_bd_pins axi_rt_logic_wrapper_0/resetn] [get_bd_pins axi_traffic_gen_0/s_axi_aresetn] [get_bd_pins axi_vip_1/aresetn] [get_bd_pins axi_vip_2/aresetn] [get_bd_pins axi_vip_3/aresetn] [get_bd_pins axi_vip_4/aresetn] [get_bd_pins axi_write_buffer_wra_0/resetn]
  connect_bd_net -net axi_isolate_wrapper_1_isolated [get_bd_ports isolated] [get_bd_pins axi_isolate_wrapper_1/isolated]
  connect_bd_net -net axi_rt_logic_wrapper_0_r_budget_left [get_bd_ports r_budget_left] [get_bd_pins axi_rt_logic_wrapper_0/r_budget_left]
  connect_bd_net -net axi_rt_logic_wrapper_0_r_budget_spent [get_bd_ports r_budget_spent] [get_bd_pins axi_rt_logic_wrapper_0/r_budget_spent] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net axi_rt_logic_wrapper_0_r_period_left [get_bd_ports r_period_left] [get_bd_pins axi_rt_logic_wrapper_0/r_period_left]
  connect_bd_net -net axi_rt_logic_wrapper_0_w_budget_left [get_bd_ports w_budget_left] [get_bd_pins axi_rt_logic_wrapper_0/w_budget_left]
  connect_bd_net -net axi_rt_logic_wrapper_0_w_budget_spent [get_bd_ports w_budget_spent] [get_bd_pins axi_rt_logic_wrapper_0/w_budget_spent] [get_bd_pins util_vector_logic_1/Op2]
  connect_bd_net -net axi_rt_logic_wrapper_0_w_period_left [get_bd_ports w_period_left] [get_bd_pins axi_rt_logic_wrapper_0/w_period_left]
  connect_bd_net -net axi_vip_3_s_axi_arready [get_bd_pins axi_rt_logic_wrapper_0/axi_ar_ready] [get_bd_pins axi_vip_3/s_axi_arready] [get_bd_pins axi_write_buffer_wra_0/m_axi_rt_0_arready]
  connect_bd_net -net axi_vip_3_s_axi_awready [get_bd_pins axi_rt_logic_wrapper_0/axi_aw_ready] [get_bd_pins axi_vip_3/s_axi_awready] [get_bd_pins axi_write_buffer_wra_0/m_axi_rt_0_awready]
  connect_bd_net -net axi_write_buffer_wra_0_m_axi_rt_0_arlen [get_bd_pins axi_rt_logic_wrapper_0/axi_ar_len] [get_bd_pins axi_vip_3/s_axi_arlen] [get_bd_pins axi_write_buffer_wra_0/m_axi_rt_0_arlen]
  connect_bd_net -net axi_write_buffer_wra_0_m_axi_rt_0_arsize [get_bd_pins axi_rt_logic_wrapper_0/axi_ar_size] [get_bd_pins axi_vip_3/s_axi_arsize] [get_bd_pins axi_write_buffer_wra_0/m_axi_rt_0_arsize]
  connect_bd_net -net axi_write_buffer_wra_0_m_axi_rt_0_arvalid [get_bd_pins axi_rt_logic_wrapper_0/axi_ar_valid] [get_bd_pins axi_vip_3/s_axi_arvalid] [get_bd_pins axi_write_buffer_wra_0/m_axi_rt_0_arvalid]
  connect_bd_net -net axi_write_buffer_wra_0_m_axi_rt_0_awlen [get_bd_pins axi_rt_logic_wrapper_0/axi_aw_len] [get_bd_pins axi_vip_3/s_axi_awlen] [get_bd_pins axi_write_buffer_wra_0/m_axi_rt_0_awlen]
  connect_bd_net -net axi_write_buffer_wra_0_m_axi_rt_0_awsize [get_bd_pins axi_rt_logic_wrapper_0/axi_aw_size] [get_bd_pins axi_vip_3/s_axi_awsize] [get_bd_pins axi_write_buffer_wra_0/m_axi_rt_0_awsize]
  connect_bd_net -net axi_write_buffer_wra_0_m_axi_rt_0_awvalid [get_bd_pins axi_rt_logic_wrapper_0/axi_aw_valid] [get_bd_pins axi_vip_3/s_axi_awvalid] [get_bd_pins axi_write_buffer_wra_0/m_axi_rt_0_awvalid]
  connect_bd_net -net core_ext_start_0_1 [get_bd_ports traffic_start] [get_bd_pins axi_traffic_gen_0/core_ext_start]
  connect_bd_net -net core_ext_stop_0_1 [get_bd_ports traffic_stop] [get_bd_pins axi_traffic_gen_0/core_ext_stop]
  connect_bd_net -net imtu_abort_0_1 [get_bd_ports imtu_abort] [get_bd_pins axi_rt_logic_wrapper_0/imtu_abort]
  connect_bd_net -net imtu_enable_0_1 [get_bd_ports imtu_enable] [get_bd_pins axi_rt_logic_wrapper_0/imtu_enable]
  connect_bd_net -net len_limit_1 [get_bd_ports splitter_len_limit] [get_bd_pins axi_gran_burst_split_0/len_limit]
  connect_bd_net -net r_budget_0_1 [get_bd_ports r_budget] [get_bd_pins axi_rt_logic_wrapper_0/r_budget]
  connect_bd_net -net r_period_0_1 [get_bd_ports r_period] [get_bd_pins axi_rt_logic_wrapper_0/r_period]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins axi_isolate_wrapper_1/isolate] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net w_budget_0_1 [get_bd_ports w_budget] [get_bd_pins axi_rt_logic_wrapper_0/w_budget]
  connect_bd_net -net w_period_0_1 [get_bd_ports w_period] [get_bd_pins axi_rt_logic_wrapper_0/w_period]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x0001000000000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_0/m_axi_rt_0] [get_bd_addr_segs axi_write_buffer_wra_0/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_1/m_axi_rt_0] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x0001000000000000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_0/Data] [get_bd_addr_segs axi_gran_burst_split_0/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x0001000000000000 -target_address_space [get_bd_addr_spaces axi_write_buffer_wra_0/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_1/s_axi_rt_0/reg0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

