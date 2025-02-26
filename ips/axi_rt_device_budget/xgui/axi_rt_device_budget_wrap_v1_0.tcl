# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AxiAddrWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AxiDataWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AxiIdWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BudgetWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NumPorts" -parent ${Page_0}


}

proc update_PARAM_VALUE.AxiAddrWidth { PARAM_VALUE.AxiAddrWidth } {
	# Procedure called to update AxiAddrWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AxiAddrWidth { PARAM_VALUE.AxiAddrWidth } {
	# Procedure called to validate AxiAddrWidth
	return true
}

proc update_PARAM_VALUE.AxiDataWidth { PARAM_VALUE.AxiDataWidth } {
	# Procedure called to update AxiDataWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AxiDataWidth { PARAM_VALUE.AxiDataWidth } {
	# Procedure called to validate AxiDataWidth
	return true
}

proc update_PARAM_VALUE.AxiIdWidth { PARAM_VALUE.AxiIdWidth } {
	# Procedure called to update AxiIdWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AxiIdWidth { PARAM_VALUE.AxiIdWidth } {
	# Procedure called to validate AxiIdWidth
	return true
}

proc update_PARAM_VALUE.BudgetWidth { PARAM_VALUE.BudgetWidth } {
	# Procedure called to update BudgetWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BudgetWidth { PARAM_VALUE.BudgetWidth } {
	# Procedure called to validate BudgetWidth
	return true
}

proc update_PARAM_VALUE.NumPorts { PARAM_VALUE.NumPorts } {
	# Procedure called to update NumPorts when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NumPorts { PARAM_VALUE.NumPorts } {
	# Procedure called to validate NumPorts
	return true
}


proc update_MODELPARAM_VALUE.NumPorts { MODELPARAM_VALUE.NumPorts PARAM_VALUE.NumPorts } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NumPorts}] ${MODELPARAM_VALUE.NumPorts}
}

proc update_MODELPARAM_VALUE.BudgetWidth { MODELPARAM_VALUE.BudgetWidth PARAM_VALUE.BudgetWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BudgetWidth}] ${MODELPARAM_VALUE.BudgetWidth}
}

proc update_MODELPARAM_VALUE.AxiAddrWidth { MODELPARAM_VALUE.AxiAddrWidth PARAM_VALUE.AxiAddrWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AxiAddrWidth}] ${MODELPARAM_VALUE.AxiAddrWidth}
}

proc update_MODELPARAM_VALUE.AxiDataWidth { MODELPARAM_VALUE.AxiDataWidth PARAM_VALUE.AxiDataWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AxiDataWidth}] ${MODELPARAM_VALUE.AxiDataWidth}
}

proc update_MODELPARAM_VALUE.AxiIdWidth { MODELPARAM_VALUE.AxiIdWidth PARAM_VALUE.AxiIdWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AxiIdWidth}] ${MODELPARAM_VALUE.AxiIdWidth}
}

