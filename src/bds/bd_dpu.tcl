
################################################################
# This is a generated script based on design: bd_dpu
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
# source bd_dpu_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xck26-sfvc784-2LV-c
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd_dpu

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
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:zynq_ultra_ps_e:3.4\
xilinx.com:ip:dpuczdx8g:4.1\
xilinx.com:ip:clk_wiz:6.0\
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

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: hier_dpu_irq
proc create_hier_cell_hier_dpu_irq { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_dpu_irq() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 1 -to 0 -type intr INTR
  create_bd_pin -dir I -from 0 -to 0 In0
  create_bd_pin -dir I -from 0 -to 0 In1

  # Create instance: dpu_concat_irq_inner, and set properties
  set dpu_concat_irq_inner [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 dpu_concat_irq_inner ]
  set_property CONFIG.NUM_PORTS {2} $dpu_concat_irq_inner


  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins In0] [get_bd_pins dpu_concat_irq_inner/In0]
  connect_bd_net -net In1_1 [get_bd_pins In1] [get_bd_pins dpu_concat_irq_inner/In1]
  connect_bd_net -net dpu_concat_irq_inner_dout [get_bd_pins INTR] [get_bd_pins dpu_concat_irq_inner/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_dpu_ghp
proc create_hier_cell_hier_dpu_ghp { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_dpu_ghp() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 DPU0_M_AXI_DATA0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 DPU0_M_AXI_DATA1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 DPU0_M_AXI_INSTR

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 DPU1_M_AXI_DATA0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 DPU1_M_AXI_DATA1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 DPU1_M_AXI_INSTR

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_HP0_FPD

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_HP1_FPD

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_HP2_FPD

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_HP3_FPD

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_LPD


  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -type clk GHP_CLK_I
  create_bd_pin -dir O -type clk GHP_CLK_O
  create_bd_pin -dir I -type rst GHP_RSTn
  create_bd_pin -dir I -type rst RSTn_INTC
  create_bd_pin -dir I -type rst RSTn_PERI

  # Create instance: dpu_intc_M_AXI_HP0_FPD, and set properties
  set dpu_intc_M_AXI_HP0_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 dpu_intc_M_AXI_HP0_FPD ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $dpu_intc_M_AXI_HP0_FPD


  # Create instance: dpu_intc_M_AXI_HP1_FPD, and set properties
  set dpu_intc_M_AXI_HP1_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 dpu_intc_M_AXI_HP1_FPD ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $dpu_intc_M_AXI_HP1_FPD


  # Create instance: dpu_intc_M_AXI_HP2_FPD, and set properties
  set dpu_intc_M_AXI_HP2_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 dpu_intc_M_AXI_HP2_FPD ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $dpu_intc_M_AXI_HP2_FPD


  # Create instance: dpu_intc_M_AXI_HP3_FPD, and set properties
  set dpu_intc_M_AXI_HP3_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 dpu_intc_M_AXI_HP3_FPD ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $dpu_intc_M_AXI_HP3_FPD


  # Create instance: dpu_intc_M_AXI_LPD, and set properties
  set dpu_intc_M_AXI_LPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 dpu_intc_M_AXI_LPD ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
  ] $dpu_intc_M_AXI_LPD


  # Create interface connections
  connect_bd_intf_net -intf_net DPU0_M_AXI_DATA0_1 [get_bd_intf_pins DPU0_M_AXI_DATA0] [get_bd_intf_pins dpu_intc_M_AXI_HP0_FPD/S00_AXI]
  connect_bd_intf_net -intf_net DPU0_M_AXI_DATA1_1 [get_bd_intf_pins DPU0_M_AXI_DATA1] [get_bd_intf_pins dpu_intc_M_AXI_HP1_FPD/S00_AXI]
  connect_bd_intf_net -intf_net DPU0_M_AXI_INSTR_1 [get_bd_intf_pins DPU0_M_AXI_INSTR] [get_bd_intf_pins dpu_intc_M_AXI_LPD/S00_AXI]
  connect_bd_intf_net -intf_net DPU1_M_AXI_DATA0_1 [get_bd_intf_pins DPU1_M_AXI_DATA0] [get_bd_intf_pins dpu_intc_M_AXI_HP2_FPD/S00_AXI]
  connect_bd_intf_net -intf_net DPU1_M_AXI_DATA1_1 [get_bd_intf_pins DPU1_M_AXI_DATA1] [get_bd_intf_pins dpu_intc_M_AXI_HP3_FPD/S00_AXI]
  connect_bd_intf_net -intf_net DPU1_M_AXI_INSTR_1 [get_bd_intf_pins DPU1_M_AXI_INSTR] [get_bd_intf_pins dpu_intc_M_AXI_LPD/S01_AXI]
  connect_bd_intf_net -intf_net dpu_intc_M_AXI_HP0_FPD_M00_AXI [get_bd_intf_pins M_AXI_HP0_FPD] [get_bd_intf_pins dpu_intc_M_AXI_HP0_FPD/M00_AXI]
  connect_bd_intf_net -intf_net dpu_intc_M_AXI_HP1_FPD_M00_AXI [get_bd_intf_pins M_AXI_HP1_FPD] [get_bd_intf_pins dpu_intc_M_AXI_HP1_FPD/M00_AXI]
  connect_bd_intf_net -intf_net dpu_intc_M_AXI_HP2_FPD_M00_AXI [get_bd_intf_pins M_AXI_HP2_FPD] [get_bd_intf_pins dpu_intc_M_AXI_HP2_FPD/M00_AXI]
  connect_bd_intf_net -intf_net dpu_intc_M_AXI_HP3_FPD_M00_AXI [get_bd_intf_pins M_AXI_HP3_FPD] [get_bd_intf_pins dpu_intc_M_AXI_HP3_FPD/M00_AXI]
  connect_bd_intf_net -intf_net dpu_intc_M_AXI_LPD_M00_AXI [get_bd_intf_pins M_AXI_LPD] [get_bd_intf_pins dpu_intc_M_AXI_LPD/M00_AXI]

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins dpu_intc_M_AXI_HP0_FPD/ACLK] [get_bd_pins dpu_intc_M_AXI_HP0_FPD/S00_ACLK] [get_bd_pins dpu_intc_M_AXI_HP1_FPD/ACLK] [get_bd_pins dpu_intc_M_AXI_HP1_FPD/S00_ACLK] [get_bd_pins dpu_intc_M_AXI_HP2_FPD/ACLK] [get_bd_pins dpu_intc_M_AXI_HP2_FPD/S00_ACLK] [get_bd_pins dpu_intc_M_AXI_HP3_FPD/ACLK] [get_bd_pins dpu_intc_M_AXI_HP3_FPD/S00_ACLK] [get_bd_pins dpu_intc_M_AXI_LPD/ACLK] [get_bd_pins dpu_intc_M_AXI_LPD/S00_ACLK] [get_bd_pins dpu_intc_M_AXI_LPD/S01_ACLK]
  connect_bd_net -net GHP_CLK_I_1 [get_bd_pins GHP_CLK_I] [get_bd_pins GHP_CLK_O] [get_bd_pins dpu_intc_M_AXI_HP0_FPD/M00_ACLK] [get_bd_pins dpu_intc_M_AXI_HP1_FPD/M00_ACLK] [get_bd_pins dpu_intc_M_AXI_HP2_FPD/M00_ACLK] [get_bd_pins dpu_intc_M_AXI_HP3_FPD/M00_ACLK] [get_bd_pins dpu_intc_M_AXI_LPD/M00_ACLK]
  connect_bd_net -net GHP_RSTn_1 [get_bd_pins GHP_RSTn] [get_bd_pins dpu_intc_M_AXI_HP0_FPD/M00_ARESETN] [get_bd_pins dpu_intc_M_AXI_HP1_FPD/M00_ARESETN] [get_bd_pins dpu_intc_M_AXI_HP2_FPD/M00_ARESETN] [get_bd_pins dpu_intc_M_AXI_HP3_FPD/M00_ARESETN] [get_bd_pins dpu_intc_M_AXI_LPD/M00_ARESETN]
  connect_bd_net -net RSTn_INTC_1 [get_bd_pins RSTn_INTC] [get_bd_pins dpu_intc_M_AXI_HP0_FPD/ARESETN] [get_bd_pins dpu_intc_M_AXI_HP1_FPD/ARESETN] [get_bd_pins dpu_intc_M_AXI_HP2_FPD/ARESETN] [get_bd_pins dpu_intc_M_AXI_HP3_FPD/ARESETN] [get_bd_pins dpu_intc_M_AXI_LPD/ARESETN]
  connect_bd_net -net RSTn_PERI_1 [get_bd_pins RSTn_PERI] [get_bd_pins dpu_intc_M_AXI_HP0_FPD/S00_ARESETN] [get_bd_pins dpu_intc_M_AXI_HP1_FPD/S00_ARESETN] [get_bd_pins dpu_intc_M_AXI_HP2_FPD/S00_ARESETN] [get_bd_pins dpu_intc_M_AXI_HP3_FPD/S00_ARESETN] [get_bd_pins dpu_intc_M_AXI_LPD/S00_ARESETN] [get_bd_pins dpu_intc_M_AXI_LPD/S01_ARESETN]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_dpu_clk
proc create_hier_cell_hier_dpu_clk { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_dpu_clk() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -type clk DPU_CLK
  create_bd_pin -dir O -type clk DSP_CLK
  create_bd_pin -dir O -type clk DSP_CLK1
  create_bd_pin -dir O -type data LOCKED
  create_bd_pin -dir I -type rst RSTn
  create_bd_pin -dir O -from 0 -to 0 -type rst RSTn_DSP
  create_bd_pin -dir O -from 0 -to 0 -type rst RSTn_INTC
  create_bd_pin -dir O -from 0 -to 0 -type rst RSTn_PERI
  create_bd_pin -dir I -type ce clk_dsp1_ce
  create_bd_pin -dir I -type ce clk_dsp_ce

  # Create instance: dpu_clk_wiz, and set properties
  set dpu_clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 dpu_clk_wiz ]
  set_property -dict [list \
    CONFIG.CLKOUT1_DRIVES {Buffer_with_CE} \
    CONFIG.CLKOUT1_MATCHED_ROUTING {true} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {550} \
    CONFIG.CLKOUT2_DRIVES {Buffer_with_CE} \
    CONFIG.CLKOUT2_MATCHED_ROUTING {true} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {550} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_MATCHED_ROUTING {true} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {275} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.CLK_OUT1_PORT {clk_dsp} \
    CONFIG.CLK_OUT2_PORT {clk_dsp1} \
    CONFIG.CLK_OUT3_PORT {clk_dpu} \
    CONFIG.PRIMITIVE {Auto} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_RESET {true} \
  ] $dpu_clk_wiz


  # Create instance: rst_gen_clk, and set properties
  set rst_gen_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_gen_clk ]

  # Create instance: rst_gen_clk_dsp, and set properties
  set rst_gen_clk_dsp [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_gen_clk_dsp ]

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins dpu_clk_wiz/clk_in1]
  connect_bd_net -net RSTn_1 [get_bd_pins RSTn] [get_bd_pins dpu_clk_wiz/resetn] [get_bd_pins rst_gen_clk/ext_reset_in] [get_bd_pins rst_gen_clk_dsp/ext_reset_in]
  connect_bd_net -net clk_dsp1_ce_1 [get_bd_pins clk_dsp1_ce] [get_bd_pins dpu_clk_wiz/clk_dsp1_ce]
  connect_bd_net -net clk_dsp_ce_1 [get_bd_pins clk_dsp_ce] [get_bd_pins dpu_clk_wiz/clk_dsp_ce]
  connect_bd_net -net dpu_clk_wiz_clk_dpu [get_bd_pins DPU_CLK] [get_bd_pins dpu_clk_wiz/clk_dpu] [get_bd_pins rst_gen_clk/slowest_sync_clk]
  connect_bd_net -net dpu_clk_wiz_clk_dsp [get_bd_pins DSP_CLK] [get_bd_pins dpu_clk_wiz/clk_dsp] [get_bd_pins rst_gen_clk_dsp/slowest_sync_clk]
  connect_bd_net -net dpu_clk_wiz_clk_dsp1 [get_bd_pins DSP_CLK1] [get_bd_pins dpu_clk_wiz/clk_dsp1]
  connect_bd_net -net dpu_clk_wiz_locked [get_bd_pins LOCKED] [get_bd_pins dpu_clk_wiz/locked] [get_bd_pins rst_gen_clk/dcm_locked] [get_bd_pins rst_gen_clk_dsp/dcm_locked]
  connect_bd_net -net rst_gen_clk_dsp_peripheral_aresetn [get_bd_pins RSTn_DSP] [get_bd_pins rst_gen_clk_dsp/peripheral_aresetn]
  connect_bd_net -net rst_gen_clk_interconnect_aresetn [get_bd_pins RSTn_INTC] [get_bd_pins rst_gen_clk/interconnect_aresetn]
  connect_bd_net -net rst_gen_clk_peripheral_aresetn [get_bd_pins RSTn_PERI] [get_bd_pins rst_gen_clk/peripheral_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_dpu
proc create_hier_cell_hier_dpu { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_dpu() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_HP0_FPD

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_HP1_FPD

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_HP2_FPD

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_HP3_FPD

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_LPD

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -type clk GHP_CLK_I
  create_bd_pin -dir O -type clk GHP_CLK_O
  create_bd_pin -dir I -type rst GHP_RSTn
  create_bd_pin -dir O -from 1 -to 0 -type intr INTR
  create_bd_pin -dir I -type rst RSTn
  create_bd_pin -dir I -type clk S_AXI_CLK
  create_bd_pin -dir I -type rst S_AXI_RSTn

  # Create instance: DPUCZDX8G, and set properties
  set DPUCZDX8G [ create_bd_cell -type ip -vlnv xilinx.com:ip:dpuczdx8g:4.1 DPUCZDX8G ]
  set_property -dict [list \
    CONFIG.ALU_LEAKYRELU {0} \
    CONFIG.ALU_PARALLEL_USER {4} \
    CONFIG.ARCH {512} \
    CONFIG.ARCH_IMG_BKGRP {2} \
    CONFIG.CLK_GATING_ENA {1} \
    CONFIG.CONV_DSP_ACCU_ENA {1} \
    CONFIG.CONV_DSP_CASC_MAX {4} \
    CONFIG.CONV_RELU_ADDON {3} \
    CONFIG.CONV_WR_PARALLEL {1} \
    CONFIG.LOAD_AUGM {1} \
    CONFIG.SAVE_ARGMAX_ENA {1} \
    CONFIG.SFM_ENA {0} \
    CONFIG.S_AXI_CLK_INDEPENDENT {1} \
    CONFIG.TIMESTAMP_ENA {1} \
    CONFIG.TIME_DAY {14} \
    CONFIG.TIME_HOUR {16} \
    CONFIG.TIME_MONTH {3} \
    CONFIG.TIME_QUARTER {0} \
    CONFIG.TIME_YEAR {25} \
    CONFIG.URAM_N_USER {50} \
    CONFIG.VER_DPU_NUM {2} \
  ] $DPUCZDX8G


  # Create instance: hier_dpu_clk
  create_hier_cell_hier_dpu_clk $hier_obj hier_dpu_clk

  # Create instance: hier_dpu_ghp
  create_hier_cell_hier_dpu_ghp $hier_obj hier_dpu_ghp

  # Create instance: hier_dpu_irq
  create_hier_cell_hier_dpu_irq $hier_obj hier_dpu_irq

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI_HP0_FPD] [get_bd_intf_pins hier_dpu_ghp/M_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXI_HP1_FPD] [get_bd_intf_pins hier_dpu_ghp/M_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXI_HP2_FPD] [get_bd_intf_pins hier_dpu_ghp/M_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M_AXI_HP3_FPD] [get_bd_intf_pins hier_dpu_ghp/M_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M_AXI_LPD] [get_bd_intf_pins hier_dpu_ghp/M_AXI_LPD]
  connect_bd_intf_net -intf_net DPUCZDX8G_DPU0_M_AXI_DATA0 [get_bd_intf_pins DPUCZDX8G/DPU0_M_AXI_DATA0] [get_bd_intf_pins hier_dpu_ghp/DPU0_M_AXI_DATA0]
  connect_bd_intf_net -intf_net DPUCZDX8G_DPU0_M_AXI_DATA1 [get_bd_intf_pins DPUCZDX8G/DPU0_M_AXI_DATA1] [get_bd_intf_pins hier_dpu_ghp/DPU0_M_AXI_DATA1]
  connect_bd_intf_net -intf_net DPUCZDX8G_DPU0_M_AXI_INSTR [get_bd_intf_pins DPUCZDX8G/DPU0_M_AXI_INSTR] [get_bd_intf_pins hier_dpu_ghp/DPU0_M_AXI_INSTR]
  connect_bd_intf_net -intf_net DPUCZDX8G_DPU1_M_AXI_DATA0 [get_bd_intf_pins DPUCZDX8G/DPU1_M_AXI_DATA0] [get_bd_intf_pins hier_dpu_ghp/DPU1_M_AXI_DATA0]
  connect_bd_intf_net -intf_net DPUCZDX8G_DPU1_M_AXI_DATA1 [get_bd_intf_pins DPUCZDX8G/DPU1_M_AXI_DATA1] [get_bd_intf_pins hier_dpu_ghp/DPU1_M_AXI_DATA1]
  connect_bd_intf_net -intf_net DPUCZDX8G_DPU1_M_AXI_INSTR [get_bd_intf_pins DPUCZDX8G/DPU1_M_AXI_INSTR] [get_bd_intf_pins hier_dpu_ghp/DPU1_M_AXI_INSTR]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins DPUCZDX8G/S_AXI]

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins hier_dpu_clk/CLK]
  connect_bd_net -net DPUCZDX8G_dpu0_interrupt [get_bd_pins DPUCZDX8G/dpu0_interrupt] [get_bd_pins hier_dpu_irq/In0]
  connect_bd_net -net DPUCZDX8G_dpu1_2x_clk_ce [get_bd_pins DPUCZDX8G/dpu1_2x_clk_ce] [get_bd_pins hier_dpu_clk/clk_dsp1_ce]
  connect_bd_net -net DPUCZDX8G_dpu1_interrupt [get_bd_pins DPUCZDX8G/dpu1_interrupt] [get_bd_pins hier_dpu_irq/In1]
  connect_bd_net -net DPUCZDX8G_dpu_2x_clk_ce [get_bd_pins DPUCZDX8G/dpu_2x_clk_ce] [get_bd_pins hier_dpu_clk/clk_dsp_ce]
  connect_bd_net -net GHP_CLK_I_1 [get_bd_pins GHP_CLK_I] [get_bd_pins hier_dpu_ghp/GHP_CLK_I]
  connect_bd_net -net GHP_RSTn_1 [get_bd_pins GHP_RSTn] [get_bd_pins hier_dpu_ghp/GHP_RSTn]
  connect_bd_net -net RSTn_1 [get_bd_pins RSTn] [get_bd_pins hier_dpu_clk/RSTn]
  connect_bd_net -net S_AXI_CLK_1 [get_bd_pins S_AXI_CLK] [get_bd_pins DPUCZDX8G/s_axi_aclk]
  connect_bd_net -net S_AXI_RSTn_1 [get_bd_pins S_AXI_RSTn] [get_bd_pins DPUCZDX8G/s_axi_aresetn]
  connect_bd_net -net hier_dpu_clk_DPU_CLK [get_bd_pins DPUCZDX8G/m_axi_dpu_aclk] [get_bd_pins hier_dpu_clk/DPU_CLK] [get_bd_pins hier_dpu_ghp/CLK]
  connect_bd_net -net hier_dpu_clk_DSP_CLK [get_bd_pins DPUCZDX8G/dpu_2x_clk] [get_bd_pins hier_dpu_clk/DSP_CLK]
  connect_bd_net -net hier_dpu_clk_DSP_CLK1 [get_bd_pins DPUCZDX8G/dpu1_2x_clk] [get_bd_pins hier_dpu_clk/DSP_CLK1]
  connect_bd_net -net hier_dpu_clk_RSTn_DSP [get_bd_pins DPUCZDX8G/dpu_2x_resetn] [get_bd_pins hier_dpu_clk/RSTn_DSP]
  connect_bd_net -net hier_dpu_clk_RSTn_INTC [get_bd_pins hier_dpu_clk/RSTn_INTC] [get_bd_pins hier_dpu_ghp/RSTn_INTC]
  connect_bd_net -net hier_dpu_clk_RSTn_PERI [get_bd_pins DPUCZDX8G/m_axi_dpu_aresetn] [get_bd_pins hier_dpu_clk/RSTn_PERI] [get_bd_pins hier_dpu_ghp/RSTn_PERI]
  connect_bd_net -net hier_dpu_ghp_GHP_CLK_O [get_bd_pins GHP_CLK_O] [get_bd_pins hier_dpu_ghp/GHP_CLK_O]
  connect_bd_net -net hier_dpu_irq_INTR [get_bd_pins INTR] [get_bd_pins hier_dpu_irq/INTR]

  # Restore current instance
  current_bd_instance $oldCurInst
}


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

  # Create instance: dpu_concat_irq, and set properties
  set dpu_concat_irq [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 dpu_concat_irq ]
  set_property CONFIG.NUM_PORTS {1} $dpu_concat_irq


  # Create instance: hier_dpu
  create_hier_cell_hier_dpu [current_bd_instance .] hier_dpu

  # Create instance: rst_gen_ghp, and set properties
  set rst_gen_ghp [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_gen_ghp ]

  # Create instance: rst_gen_reg, and set properties
  set rst_gen_reg [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_gen_reg ]

  # Create instance: zynq_ultra_ps_e, and set properties
  set zynq_ultra_ps_e [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.4 zynq_ultra_ps_e ]
  set_property -dict [list \
    CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
    CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
    CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
    CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {1} \
    CONFIG.PSU_MIO_13_POLARITY {Default} \
    CONFIG.PSU_MIO_22_POLARITY {Default} \
    CONFIG.PSU_MIO_23_POLARITY {Default} \
    CONFIG.PSU_MIO_26_POLARITY {Default} \
    CONFIG.PSU_MIO_31_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_31_POLARITY {Default} \
    CONFIG.PSU_MIO_38_POLARITY {Default} \
    CONFIG.PSU_MIO_43_POLARITY {Default} \
    CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad\
SPI Flash#Quad SPI Flash#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#UART 1#UART 1#GPIO0 MIO#GPIO0 MIO#CAN 1#CAN 1#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#GPIO1 MIO#PMU GPO 0#PMU GPO 1#PMU GPO 2#PMU GPO\
3#PMU GPO 4#PMU GPO 5#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem\
3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
    CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#txd#rxd#gpio0[22]#gpio0[23]#phy_tx#phy_rx#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#gpio1[31]#gpo[0]#gpo[1]#gpo[2]#gpo[3]#gpo[4]#gpo[5]#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#gpio1[43]#sdio1_wp#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out}\
\
    CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
    CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
    CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.560059} \
    CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
    CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__CAN1__PERIPHERAL__IO {MIO 24 .. 25} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1333.200073} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1334} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.280029} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {666.600037} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.997503} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.467943} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.970032} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {666.600037} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {499.950043} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.280029} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.950043} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.995003} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.950043} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.850098} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.987511} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.950043} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.481262} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {269.973022} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {274} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {124.987511} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.481262} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.998001} \
    CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
    CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
    CONFIG.PSU__DDRC__BG_ADDR_COUNT {2} \
    CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
    CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
    CONFIG.PSU__DDRC__CL {15} \
    CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
    CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
    CONFIG.PSU__DDRC__CWL {14} \
    CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
    CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
    CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
    CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
    CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
    CONFIG.PSU__DDRC__DRAM_WIDTH {8 Bits} \
    CONFIG.PSU__DDRC__ECC {Disabled} \
    CONFIG.PSU__DDRC__FGRM {1X} \
    CONFIG.PSU__DDRC__LP_ASR {manual normal} \
    CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
    CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
    CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
    CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
    CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
    CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
    CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
    CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
    CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
    CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
    CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
    CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
    CONFIG.PSU__DDRC__T_FAW {30.0} \
    CONFIG.PSU__DDRC__T_RAS_MIN {33} \
    CONFIG.PSU__DDRC__T_RC {47.06} \
    CONFIG.PSU__DDRC__T_RCD {15} \
    CONFIG.PSU__DDRC__T_RP {15} \
    CONFIG.PSU__DDRC__VREF {1} \
    CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
    CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
    CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
    CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
    CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
    CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
    CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DLL__ISUSED {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
    CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
    CONFIG.PSU__DP__REF_CLK_FREQ {27} \
    CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk3} \
    CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
    CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
    CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
    CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
    CONFIG.PSU__ENET3__PTP__ENABLE {0} \
    CONFIG.PSU__ENET3__TSU__ENABLE {0} \
    CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
    CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__FPGA_PL0_ENABLE {1} \
    CONFIG.PSU__FPGA_PL1_ENABLE {1} \
    CONFIG.PSU__FPGA_PL2_ENABLE {0} \
    CONFIG.PSU__FPGA_PL3_ENABLE {0} \
    CONFIG.PSU__GEM3_COHERENCY {0} \
    CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__GEM__TSU__ENABLE {0} \
    CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
    CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
    CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO_EMIO__WIDTH {[94:0]} \
    CONFIG.PSU__GT__LINK_SPEED {HBR} \
    CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
    CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
    CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
    CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
    CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
    CONFIG.PSU__NUM_FABRIC_RESETS {1} \
    CONFIG.PSU__PCIE__CLASS_CODE_BASE {0x06} \
    CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {} \
    CONFIG.PSU__PCIE__CLASS_CODE_SUB {0x04} \
    CONFIG.PSU__PCIE__DEVICE_ID {0xD021} \
    CONFIG.PSU__PCIE__MSIX_CAPABILITY {0} \
    CONFIG.PSU__PCIE__MSI_CAPABILITY {0} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {1} \
    CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {0} \
    CONFIG.PSU__PL_CLK0_BUF {TRUE} \
    CONFIG.PSU__PL_CLK1_BUF {TRUE} \
    CONFIG.PSU__PMU_COHERENCY {0} \
    CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
    CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
    CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
    CONFIG.PSU__PMU__GPI0__ENABLE {0} \
    CONFIG.PSU__PMU__GPI1__ENABLE {0} \
    CONFIG.PSU__PMU__GPI2__ENABLE {0} \
    CONFIG.PSU__PMU__GPI3__ENABLE {0} \
    CONFIG.PSU__PMU__GPI4__ENABLE {0} \
    CONFIG.PSU__PMU__GPI5__ENABLE {0} \
    CONFIG.PSU__PMU__GPO0__ENABLE {1} \
    CONFIG.PSU__PMU__GPO0__IO {MIO 32} \
    CONFIG.PSU__PMU__GPO1__ENABLE {1} \
    CONFIG.PSU__PMU__GPO1__IO {MIO 33} \
    CONFIG.PSU__PMU__GPO2__ENABLE {1} \
    CONFIG.PSU__PMU__GPO2__IO {MIO 34} \
    CONFIG.PSU__PMU__GPO2__POLARITY {high} \
    CONFIG.PSU__PMU__GPO3__ENABLE {1} \
    CONFIG.PSU__PMU__GPO3__IO {MIO 35} \
    CONFIG.PSU__PMU__GPO3__POLARITY {low} \
    CONFIG.PSU__PMU__GPO4__ENABLE {1} \
    CONFIG.PSU__PMU__GPO4__IO {MIO 36} \
    CONFIG.PSU__PMU__GPO4__POLARITY {low} \
    CONFIG.PSU__PMU__GPO5__ENABLE {1} \
    CONFIG.PSU__PMU__GPO5__IO {MIO 37} \
    CONFIG.PSU__PMU__GPO5__POLARITY {low} \
    CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
    CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;1|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1}\
\
    CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display\
Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;1|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1}\
\
    CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.330} \
    CONFIG.PSU__QSPI_COHERENCY {0} \
    CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
    CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
    CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
    CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
    CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
    CONFIG.PSU__SATA__LANE0__ENABLE {0} \
    CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
    CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
    CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk1} \
    CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
    CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
    CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
    CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
    CONFIG.PSU__SAXIGP6__DATA_WIDTH {32} \
    CONFIG.PSU__SD1_COHERENCY {0} \
    CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__SD1__CLK_100_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_200_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_50_DDR_ITAP_DLY {0x3D} \
    CONFIG.PSU__SD1__CLK_50_DDR_OTAP_DLY {0x4} \
    CONFIG.PSU__SD1__CLK_50_SDR_ITAP_DLY {0x15} \
    CONFIG.PSU__SD1__CLK_50_SDR_OTAP_DLY {0x5} \
    CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
    CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
    CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
    CONFIG.PSU__SD1__GRP_WP__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_WP__IO {MIO 44} \
    CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
    CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
    CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
    CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
    CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
    CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
    CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
    CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__UART0__BAUD_RATE {115200} \
    CONFIG.PSU__UART0__MODEM__ENABLE {0} \
    CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
    CONFIG.PSU__UART1__BAUD_RATE {115200} \
    CONFIG.PSU__UART1__MODEM__ENABLE {0} \
    CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 20 .. 21} \
    CONFIG.PSU__USB0_COHERENCY {0} \
    CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
    CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
    CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
    CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
    CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
    CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
    CONFIG.PSU__USE__FABRIC__RST {1} \
    CONFIG.PSU__USE__IRQ0 {1} \
    CONFIG.PSU__USE__IRQ1 {1} \
    CONFIG.PSU__USE__M_AXI_GP2 {1} \
    CONFIG.PSU__USE__S_AXI_GP2 {1} \
    CONFIG.PSU__USE__S_AXI_GP3 {1} \
    CONFIG.PSU__USE__S_AXI_GP4 {1} \
    CONFIG.PSU__USE__S_AXI_GP5 {1} \
    CONFIG.PSU__USE__S_AXI_GP6 {1} \
  ] $zynq_ultra_ps_e


  # Create interface connections
  connect_bd_intf_net -intf_net hier_dpu_M_AXI_HP0_FPD [get_bd_intf_pins hier_dpu/M_AXI_HP0_FPD] [get_bd_intf_pins zynq_ultra_ps_e/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net hier_dpu_M_AXI_HP1_FPD [get_bd_intf_pins hier_dpu/M_AXI_HP1_FPD] [get_bd_intf_pins zynq_ultra_ps_e/S_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net hier_dpu_M_AXI_HP2_FPD [get_bd_intf_pins hier_dpu/M_AXI_HP2_FPD] [get_bd_intf_pins zynq_ultra_ps_e/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net hier_dpu_M_AXI_HP3_FPD [get_bd_intf_pins hier_dpu/M_AXI_HP3_FPD] [get_bd_intf_pins zynq_ultra_ps_e/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net hier_dpu_M_AXI_LPD [get_bd_intf_pins hier_dpu/M_AXI_LPD] [get_bd_intf_pins zynq_ultra_ps_e/S_AXI_LPD]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_M_AXI_HPM0_LPD [get_bd_intf_pins hier_dpu/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e/M_AXI_HPM0_LPD]

  # Create port connections
  connect_bd_net -net dpu_concat_irq_dout [get_bd_pins dpu_concat_irq/dout] [get_bd_pins zynq_ultra_ps_e/pl_ps_irq0]
  connect_bd_net -net hier_dpu_GHP_CLK_O [get_bd_pins hier_dpu/GHP_CLK_O] [get_bd_pins zynq_ultra_ps_e/saxi_lpd_aclk] [get_bd_pins zynq_ultra_ps_e/saxihp0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e/saxihp1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e/saxihp2_fpd_aclk] [get_bd_pins zynq_ultra_ps_e/saxihp3_fpd_aclk]
  connect_bd_net -net hier_dpu_INTR [get_bd_pins dpu_concat_irq/In0] [get_bd_pins hier_dpu/INTR]
  connect_bd_net -net rst_gen_ghp_peripheral_aresetn [get_bd_pins hier_dpu/GHP_RSTn] [get_bd_pins rst_gen_ghp/peripheral_aresetn]
  connect_bd_net -net rst_gen_reg_peripheral_aresetn [get_bd_pins hier_dpu/RSTn] [get_bd_pins hier_dpu/S_AXI_RSTn] [get_bd_pins rst_gen_reg/peripheral_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_pl_clk0 [get_bd_pins hier_dpu/CLK] [get_bd_pins hier_dpu/S_AXI_CLK] [get_bd_pins rst_gen_reg/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e/pl_clk0]
  connect_bd_net -net zynq_ultra_ps_e_pl_clk1 [get_bd_pins hier_dpu/GHP_CLK_I] [get_bd_pins rst_gen_ghp/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e/pl_clk1]
  connect_bd_net -net zynq_ultra_ps_e_pl_resetn0 [get_bd_pins rst_gen_ghp/ext_reset_in] [get_bd_pins rst_gen_reg/ext_reset_in] [get_bd_pins zynq_ultra_ps_e/pl_resetn0]

  # Create address segments
  assign_bd_address -offset 0x8F000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e/Data] [get_bd_addr_segs hier_dpu/DPUCZDX8G/S_AXI/reg0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_DATA0] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP2/HP0_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_DATA0] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_DATA0] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP2/HP0_LPS_OCM] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_DATA0] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_DATA1] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP3/HP1_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_DATA1] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP3/HP1_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_DATA1] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP3/HP1_LPS_OCM] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_DATA1] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP3/HP1_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_INSTR] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP6/LPD_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_INSTR] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP6/LPD_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_INSTR] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP6/LPD_LPS_OCM] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU0_M_AXI_INSTR] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP6/LPD_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_DATA0] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP4/HP2_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_DATA0] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP4/HP2_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_DATA0] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP4/HP2_LPS_OCM] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_DATA0] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP4/HP2_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_DATA1] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP5/HP3_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_DATA1] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP5/HP3_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_DATA1] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP5/HP3_LPS_OCM] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_DATA1] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP5/HP3_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_INSTR] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP6/LPD_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_INSTR] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP6/LPD_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_INSTR] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP6/LPD_LPS_OCM] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces hier_dpu/DPUCZDX8G/DPU1_M_AXI_INSTR] [get_bd_addr_segs zynq_ultra_ps_e/SAXIGP6/LPD_QSPI] -force


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


