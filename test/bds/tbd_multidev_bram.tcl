
################################################################
# This is a generated script based on design: tbd_multidev_bram
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
# source tbd_multidev_bram_script.tcl


# The design that will be created by this Tcl script contains the following 
# block design container source references:
# tbd_multidev

# Please add the sources before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xck26-sfvc784-2LV-c
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name tbd_multidev_bram

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
xilinx.com:ip:blk_mem_gen:8.4\
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
# CHECK Block Design Container Sources
##################################################################
set bCheckSources 1
set list_bdc_active "tbd_multidev"

array set map_bdc_missing {}
set map_bdc_missing(ACTIVE) ""
set map_bdc_missing(BDC) ""

if { $bCheckSources == 1 } {
   set list_check_srcs "\ 
tbd_multidev \
"

   common::send_gid_msg -ssname BD::TCL -id 2056 -severity "INFO" "Checking if the following sources for block design container exist in the project: $list_check_srcs .\n\n"

   foreach src $list_check_srcs {
      if { [can_resolve_reference $src] == 0 } {
         if { [lsearch $list_bdc_active $src] != -1 } {
            set map_bdc_missing(ACTIVE) "$map_bdc_missing(ACTIVE) $src"
         } else {
            set map_bdc_missing(BDC) "$map_bdc_missing(BDC) $src"
         }
      }
   }

   if { [llength $map_bdc_missing(ACTIVE)] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2057 -severity "ERROR" "The following source(s) of Active variants are not found in the project: $map_bdc_missing(ACTIVE)" }
      common::send_gid_msg -ssname BD::TCL -id 2060 -severity "INFO" "Please add source files for the missing source(s) above."
      set bCheckIPsPassed 0
   }
   if { [llength $map_bdc_missing(BDC)] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2059 -severity "WARNING" "The following source(s) of variants are not found in the project: $map_bdc_missing(BDC)" }
      common::send_gid_msg -ssname BD::TCL -id 2060 -severity "INFO" "Please add source files for the missing source(s) above."
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
  set aresetn [ create_bd_port -dir I -type rst aresetn ]
  set budget_r_0 [ create_bd_port -dir I -from 15 -to 0 budget_r_0 ]
  set budget_r_1 [ create_bd_port -dir I -from 15 -to 0 budget_r_1 ]
  set budget_r_2 [ create_bd_port -dir I -from 15 -to 0 budget_r_2 ]
  set budget_w_0 [ create_bd_port -dir I -from 15 -to 0 budget_w_0 ]
  set budget_w_1 [ create_bd_port -dir I -from 15 -to 0 budget_w_1 ]
  set budget_w_2 [ create_bd_port -dir I -from 15 -to 0 budget_w_2 ]
  set clock [ create_bd_port -dir I -type clk -freq_hz 100000000 clock ]
  set_property -dict [ list \
   CONFIG.CLK_DOMAIN {tbd_multidev_inst_1_clock} \
 ] $clock
  set downstream_p [ create_bd_port -dir I -from 15 -to 0 downstream_p ]
  set downstream_q [ create_bd_port -dir I -from 15 -to 0 downstream_q ]
  set enable_0 [ create_bd_port -dir I enable_0 ]
  set enable_1 [ create_bd_port -dir I enable_1 ]
  set enable_2 [ create_bd_port -dir I enable_2 ]
  set len_limit [ create_bd_port -dir I -from 7 -to 0 len_limit ]
  set traffic_start [ create_bd_port -dir I traffic_start ]
  set traffic_stop [ create_bd_port -dir I traffic_stop ]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property CONFIG.DATA_WIDTH {128} $axi_bram_ctrl_0


  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [list \
    CONFIG.Assume_Synchronous_Clk {false} \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
  ] $blk_mem_gen_0


  # Create instance: tbd_multidev_0, and set properties
  set tbd_multidev_0 [ create_bd_cell -type container -reference tbd_multidev tbd_multidev_0 ]
  set_property -dict [list \
    CONFIG.ACTIVE_SIM_BD {tbd_multidev.bd} \
    CONFIG.ACTIVE_SYNTH_BD {tbd_multidev.bd} \
    CONFIG.ENABLE_DFX {0} \
    CONFIG.LIST_SIM_BD {tbd_multidev.bd} \
    CONFIG.LIST_SYNTH_BD {tbd_multidev.bd} \
    CONFIG.LOCK_PROPAGATE {0} \
  ] $tbd_multidev_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net tbd_multidev_0_M00_AXI_0 [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins tbd_multidev_0/M00_AXI_0]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_ports aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
  connect_bd_net -net budget_r_0_0_1 [get_bd_ports budget_r_0] [get_bd_pins tbd_multidev_0/budget_r_0]
  connect_bd_net -net budget_r_1_0_1 [get_bd_ports budget_r_1] [get_bd_pins tbd_multidev_0/budget_r_1]
  connect_bd_net -net budget_r_2_0_1 [get_bd_ports budget_r_2] [get_bd_pins tbd_multidev_0/budget_r_2]
  connect_bd_net -net budget_w_0_0_1 [get_bd_ports budget_w_0] [get_bd_pins tbd_multidev_0/budget_w_0]
  connect_bd_net -net budget_w_1_0_1 [get_bd_ports budget_w_1] [get_bd_pins tbd_multidev_0/budget_w_1]
  connect_bd_net -net budget_w_2_0_1 [get_bd_ports budget_w_2] [get_bd_pins tbd_multidev_0/budget_w_2]
  connect_bd_net -net clock_1 [get_bd_ports clock] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins tbd_multidev_0/clock]
  connect_bd_net -net downstream_p_0_1 [get_bd_ports downstream_p] [get_bd_pins tbd_multidev_0/downstream_p]
  connect_bd_net -net downstream_q_0_1 [get_bd_ports downstream_q] [get_bd_pins tbd_multidev_0/downstream_q]
  connect_bd_net -net enable_0_0_1 [get_bd_ports enable_0] [get_bd_pins tbd_multidev_0/enable_0]
  connect_bd_net -net enable_1_0_1 [get_bd_ports enable_1] [get_bd_pins tbd_multidev_0/enable_1]
  connect_bd_net -net enable_2_0_1 [get_bd_ports enable_2] [get_bd_pins tbd_multidev_0/enable_2]
  connect_bd_net -net len_limit_0_1 [get_bd_ports len_limit] [get_bd_pins tbd_multidev_0/len_limit]
  connect_bd_net -net traffic_start_0_1 [get_bd_ports traffic_start] [get_bd_pins tbd_multidev_0/traffic_start]
  connect_bd_net -net traffic_stop_0_1 [get_bd_ports traffic_stop] [get_bd_pins tbd_multidev_0/traffic_stop]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces tbd_multidev_0/axi_isolate_wrapper_0/m_axi_rt_0] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces tbd_multidev_0/axi_isolate_wrapper_1/m_axi_rt_0] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces tbd_multidev_0/axi_isolate_wrapper_2/m_axi_rt_0] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force


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


