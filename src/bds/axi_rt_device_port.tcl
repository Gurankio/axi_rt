
################################################################
# This is a generated script based on design: axi_rt_device_port
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
# source axi_rt_device_port_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axi_gran_burst_splitter_wrapper, axi_gran_burst_splitter_wrapper, axi_gran_burst_splitter_wrapper, axi_isolate_wrapper, axi_isolate_wrapper, axi_isolate_wrapper, axi_write_buffer_wrapper, axi_write_buffer_wrapper, axi_write_buffer_wrapper

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
set design_name axi_rt_device_port

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
axi_gran_burst_splitter_wrapper\
axi_gran_burst_splitter_wrapper\
axi_isolate_wrapper\
axi_isolate_wrapper\
axi_isolate_wrapper\
axi_write_buffer_wrapper\
axi_write_buffer_wrapper\
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
  set m_axi_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $m_axi_0

  set m_axi_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $m_axi_1

  set m_axi_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_2 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $m_axi_2

  set s_axi_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {1} \
   CONFIG.AWUSER_WIDTH {1} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {2} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $s_axi_0

  set s_axi_1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {1} \
   CONFIG.AWUSER_WIDTH {1} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {2} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $s_axi_1

  set s_axi_2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_2 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {1} \
   CONFIG.AWUSER_WIDTH {1} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {2} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $s_axi_2


  # Create ports
  set aresetn [ create_bd_port -dir I -type rst aresetn ]
  set budget_used_r [ create_bd_port -dir O budget_used_r ]
  set budget_used_w [ create_bd_port -dir O budget_used_w ]
  set clock [ create_bd_port -dir I -type clk clock ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axi_0:m_axi_1:m_axi_2:s_axi_0:s_axi_2:s_axi_1} \
 ] $clock
  set enable [ create_bd_port -dir I enable ]
  set incr [ create_bd_port -dir I incr ]
  set isolated_0 [ create_bd_port -dir O isolated_0 ]
  set isolated_1 [ create_bd_port -dir O isolated_1 ]
  set isolated_2 [ create_bd_port -dir O isolated_2 ]
  set len_limit_0 [ create_bd_port -dir I -from 7 -to 0 len_limit_0 ]
  set len_limit_1 [ create_bd_port -dir I -from 7 -to 0 len_limit_1 ]
  set len_limit_2 [ create_bd_port -dir I -from 7 -to 0 len_limit_2 ]
  set load [ create_bd_port -dir I load ]
  set num_aw_stored_0 [ create_bd_port -dir O -from 4 -to 0 num_aw_stored_0 ]
  set num_aw_stored_1 [ create_bd_port -dir O -from 4 -to 0 num_aw_stored_1 ]
  set num_aw_stored_2 [ create_bd_port -dir O -from 4 -to 0 num_aw_stored_2 ]
  set num_w_stored_0 [ create_bd_port -dir O -from 4 -to 0 num_w_stored_0 ]
  set num_w_stored_1 [ create_bd_port -dir O -from 4 -to 0 num_w_stored_1 ]
  set num_w_stored_2 [ create_bd_port -dir O -from 4 -to 0 num_w_stored_2 ]
  set r_budget [ create_bd_port -dir I -from 15 -to 0 r_budget ]
  set r_budget_spent [ create_bd_port -dir O r_budget_spent ]
  set w_budget [ create_bd_port -dir I -from 15 -to 0 w_budget ]
  set w_budget_spent [ create_bd_port -dir O w_budget_spent ]

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
    CONFIG.AddrWidth {0x00000028} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000001} \
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
    CONFIG.AddrWidth {0x00000028} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000001} \
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
    CONFIG.AddrWidth {0x00000028} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000001} \
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
    CONFIG.AddrWidth {0x00000028} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000001} \
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
    CONFIG.AddrWidth {0x00000028} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000001} \
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
    CONFIG.AddrWidth {0x00000028} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000001} \
  ] $axi_isolate_wrapper_2


  # Create instance: axi_rt_device_budget_0, and set properties
  set axi_rt_device_budget_0 [ create_bd_cell -type ip -vlnv delgranchio.it:axi_rt:axi_rt_device_budget:1.0 axi_rt_device_budget_0 ]
  set_property -dict [list \
    CONFIG.AxiAddrWidth {40} \
    CONFIG.AxiDataWidth {128} \
    CONFIG.AxiIdWidth {2} \
    CONFIG.BudgetWidth {16} \
    CONFIG.NumPorts {3} \
  ] $axi_rt_device_budget_0


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
    CONFIG.AddrWidth {0x00000028} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000001} \
  ] $axi_write_buffer_wra_0


  # Create instance: axi_write_buffer_wra_1, and set properties
  set block_name axi_write_buffer_wrapper
  set block_cell_name axi_write_buffer_wra_1
  if { [catch {set axi_write_buffer_wra_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_write_buffer_wra_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.AddrWidth {0x00000028} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000001} \
  ] $axi_write_buffer_wra_1


  # Create instance: axi_write_buffer_wra_2, and set properties
  set block_name axi_write_buffer_wrapper
  set block_cell_name axi_write_buffer_wra_2
  if { [catch {set axi_write_buffer_wra_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_write_buffer_wra_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.AddrWidth {0x00000028} \
    CONFIG.DataWidth {0x00000080} \
    CONFIG.IdWidth {0x00000002} \
    CONFIG.UserWidth {0x00000001} \
  ] $axi_write_buffer_wra_2


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_gran_burst_split_0_m_axi_rt_0 [get_bd_intf_pins axi_gran_burst_split_0/m_axi_rt_0] [get_bd_intf_pins axi_write_buffer_wra_0/s_axi_rt_0]
  connect_bd_intf_net -intf_net axi_gran_burst_split_1_m_axi_rt_0 [get_bd_intf_pins axi_gran_burst_split_1/m_axi_rt_0] [get_bd_intf_pins axi_write_buffer_wra_1/s_axi_rt_0]
  connect_bd_intf_net -intf_net axi_gran_burst_split_2_m_axi_rt_0 [get_bd_intf_pins axi_gran_burst_split_2/m_axi_rt_0] [get_bd_intf_pins axi_write_buffer_wra_2/s_axi_rt_0]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_0_m_axi_rt_0 [get_bd_intf_ports m_axi_0] [get_bd_intf_pins axi_isolate_wrapper_0/m_axi_rt_0]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_1_m_axi_rt_0 [get_bd_intf_ports m_axi_1] [get_bd_intf_pins axi_isolate_wrapper_1/m_axi_rt_0]
  connect_bd_intf_net -intf_net axi_isolate_wrapper_2_m_axi_rt_0 [get_bd_intf_ports m_axi_2] [get_bd_intf_pins axi_isolate_wrapper_2/m_axi_rt_0]
  connect_bd_intf_net -intf_net axi_write_buffer_wra_0_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_0/s_axi_rt_0] [get_bd_intf_pins axi_write_buffer_wra_0/m_axi_rt_0]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_write_buffer_wra_0_m_axi_rt_0] [get_bd_intf_pins axi_rt_device_budget_0/axi_0] [get_bd_intf_pins axi_write_buffer_wra_0/m_axi_rt_0]
  connect_bd_intf_net -intf_net axi_write_buffer_wra_1_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_1/s_axi_rt_0] [get_bd_intf_pins axi_write_buffer_wra_1/m_axi_rt_0]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_write_buffer_wra_1_m_axi_rt_0] [get_bd_intf_pins axi_rt_device_budget_0/axi_1] [get_bd_intf_pins axi_write_buffer_wra_1/m_axi_rt_0]
  connect_bd_intf_net -intf_net axi_write_buffer_wra_2_m_axi_rt_0 [get_bd_intf_pins axi_isolate_wrapper_2/s_axi_rt_0] [get_bd_intf_pins axi_write_buffer_wra_2/m_axi_rt_0]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_write_buffer_wra_2_m_axi_rt_0] [get_bd_intf_pins axi_rt_device_budget_0/axi_2] [get_bd_intf_pins axi_write_buffer_wra_2/m_axi_rt_0]
  connect_bd_intf_net -intf_net s_axi_rt_0_0_1 [get_bd_intf_ports s_axi_0] [get_bd_intf_pins axi_gran_burst_split_0/s_axi_rt_0]
  connect_bd_intf_net -intf_net s_axi_rt_0_1_1 [get_bd_intf_ports s_axi_2] [get_bd_intf_pins axi_gran_burst_split_2/s_axi_rt_0]
  connect_bd_intf_net -intf_net s_axi_rt_0_2_1 [get_bd_intf_ports s_axi_1] [get_bd_intf_pins axi_gran_burst_split_1/s_axi_rt_0]

  # Create port connections
  connect_bd_net -net axi_isolate_wrapper_0_isolated [get_bd_ports isolated_0] [get_bd_pins axi_isolate_wrapper_0/isolated]
  connect_bd_net -net axi_isolate_wrapper_1_isolated [get_bd_ports isolated_1] [get_bd_pins axi_isolate_wrapper_1/isolated]
  connect_bd_net -net axi_isolate_wrapper_2_isolated [get_bd_ports isolated_2] [get_bd_pins axi_isolate_wrapper_2/isolated]
  connect_bd_net -net axi_rt_device_budget_0_budget_used_r [get_bd_ports budget_used_r] [get_bd_pins axi_rt_device_budget_0/budget_used_r]
  connect_bd_net -net axi_rt_device_budget_0_budget_used_w [get_bd_ports budget_used_w] [get_bd_pins axi_rt_device_budget_0/budget_used_w]
  connect_bd_net -net axi_rt_device_budget_0_r_budget_spent [get_bd_ports r_budget_spent] [get_bd_pins axi_rt_device_budget_0/budget_spent_r] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net axi_rt_device_budget_0_w_budget_spent [get_bd_ports w_budget_spent] [get_bd_pins axi_rt_device_budget_0/budget_spent_w] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net axi_write_buffer_wra_0_num_aw_stored [get_bd_ports num_aw_stored_0] [get_bd_pins axi_write_buffer_wra_0/num_aw_stored]
  connect_bd_net -net axi_write_buffer_wra_0_num_w_stored [get_bd_ports num_w_stored_0] [get_bd_pins axi_write_buffer_wra_0/num_w_stored]
  connect_bd_net -net axi_write_buffer_wra_1_num_aw_stored [get_bd_ports num_aw_stored_1] [get_bd_pins axi_write_buffer_wra_1/num_aw_stored]
  connect_bd_net -net axi_write_buffer_wra_1_num_w_stored [get_bd_ports num_w_stored_1] [get_bd_pins axi_write_buffer_wra_1/num_w_stored]
  connect_bd_net -net axi_write_buffer_wra_2_num_aw_stored [get_bd_ports num_aw_stored_2] [get_bd_pins axi_write_buffer_wra_2/num_aw_stored]
  connect_bd_net -net axi_write_buffer_wra_2_num_w_stored [get_bd_ports num_w_stored_2] [get_bd_pins axi_write_buffer_wra_2/num_w_stored]
  connect_bd_net -net clk_0_1 [get_bd_ports clock] [get_bd_pins axi_gran_burst_split_0/clk] [get_bd_pins axi_gran_burst_split_1/clk] [get_bd_pins axi_gran_burst_split_2/clk] [get_bd_pins axi_isolate_wrapper_0/clk] [get_bd_pins axi_isolate_wrapper_1/clk] [get_bd_pins axi_isolate_wrapper_2/clk] [get_bd_pins axi_rt_device_budget_0/clock] [get_bd_pins axi_write_buffer_wra_0/clk] [get_bd_pins axi_write_buffer_wra_1/clk] [get_bd_pins axi_write_buffer_wra_2/clk]
  connect_bd_net -net enable_0_1 [get_bd_ports enable] [get_bd_pins axi_rt_device_budget_0/enable]
  connect_bd_net -net incr_0_1 [get_bd_ports incr]
  connect_bd_net -net len_limit_0_1 [get_bd_ports len_limit_0] [get_bd_pins axi_gran_burst_split_0/len_limit]
  connect_bd_net -net len_limit_1_1 [get_bd_ports len_limit_1] [get_bd_pins axi_gran_burst_split_1/len_limit]
  connect_bd_net -net len_limit_2_1 [get_bd_ports len_limit_2] [get_bd_pins axi_gran_burst_split_2/len_limit]
  connect_bd_net -net load_0_1 [get_bd_ports load]
  connect_bd_net -net r_budget_0_1 [get_bd_ports r_budget]
  connect_bd_net -net resetn_0_1 [get_bd_ports aresetn] [get_bd_pins axi_gran_burst_split_0/resetn] [get_bd_pins axi_gran_burst_split_1/resetn] [get_bd_pins axi_gran_burst_split_2/resetn] [get_bd_pins axi_isolate_wrapper_0/resetn] [get_bd_pins axi_isolate_wrapper_1/resetn] [get_bd_pins axi_isolate_wrapper_2/resetn] [get_bd_pins axi_rt_device_budget_0/aresetn] [get_bd_pins axi_write_buffer_wra_0/resetn] [get_bd_pins axi_write_buffer_wra_1/resetn] [get_bd_pins axi_write_buffer_wra_2/resetn]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins axi_isolate_wrapper_0/isolate] [get_bd_pins axi_isolate_wrapper_1/isolate] [get_bd_pins axi_isolate_wrapper_2/isolate] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net w_budget_0_1 [get_bd_ports w_budget]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_0/m_axi_rt_0] [get_bd_addr_segs axi_write_buffer_wra_0/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_1/m_axi_rt_0] [get_bd_addr_segs axi_write_buffer_wra_1/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces axi_gran_burst_split_2/m_axi_rt_0] [get_bd_addr_segs axi_write_buffer_wra_2/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_0/m_axi_rt_0] [get_bd_addr_segs m_axi_0/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_1/m_axi_rt_0] [get_bd_addr_segs m_axi_1/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_isolate_wrapper_2/m_axi_rt_0] [get_bd_addr_segs m_axi_2/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces axi_write_buffer_wra_0/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_0/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces axi_write_buffer_wra_1/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_1/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces axi_write_buffer_wra_2/m_axi_rt_0] [get_bd_addr_segs axi_isolate_wrapper_2/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces s_axi_0] [get_bd_addr_segs axi_gran_burst_split_0/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces s_axi_1] [get_bd_addr_segs axi_gran_burst_split_1/s_axi_rt_0/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces s_axi_2] [get_bd_addr_segs axi_gran_burst_split_2/s_axi_rt_0/reg0] -force


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


