
################################################################
# This is a generated script based on design: powerPCItoSDRAM
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
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source powerPCItoSDRAM_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# chip_select_splitter, data_splitter, mpc106fsm, mx9_sdramfsm, powerpcfsm

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a100ticsg324-1L
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name powerPCItoSDRAM

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
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

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

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
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
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set CLK_0 [ create_bd_port -dir I -type clk CLK_0 ]

  # Create instance: chip_select_splitter_0, and set properties
  set block_name chip_select_splitter
  set block_cell_name chip_select_splitter_0
  if { [catch {set chip_select_splitter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $chip_select_splitter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: data_splitter_0, and set properties
  set block_name data_splitter
  set block_cell_name data_splitter_0
  if { [catch {set data_splitter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_splitter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: mpc106fsm_0, and set properties
  set block_name mpc106fsm
  set block_cell_name mpc106fsm_0
  if { [catch {set mpc106fsm_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mpc106fsm_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: mx9_sdramfsm_0, and set properties
  set block_name mx9_sdramfsm
  set block_cell_name mx9_sdramfsm_0
  if { [catch {set mx9_sdramfsm_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mx9_sdramfsm_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: powerpcfsm_0, and set properties
  set block_name powerpcfsm
  set block_cell_name powerpcfsm_0
  if { [catch {set powerpcfsm_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $powerpcfsm_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net CLK_0_1 [get_bd_ports CLK_0] [get_bd_pins mpc106fsm_0/CLK] [get_bd_pins mx9_sdramfsm_0/CLK] [get_bd_pins powerpcfsm_0/CLK]
  connect_bd_net -net Net [get_bd_pins mpc106fsm_0/TT] [get_bd_pins powerpcfsm_0/TT]
  connect_bd_net -net chip_select_splitter_0_b [get_bd_pins chip_select_splitter_0/b] [get_bd_pins mx9_sdramfsm_0/CS]
  connect_bd_net -net data_splitter_0_d_out [get_bd_pins data_splitter_0/d_out] [get_bd_pins mx9_sdramfsm_0/DQ]
  connect_bd_net -net mpc106fsm_0_AACK [get_bd_pins mpc106fsm_0/AACK] [get_bd_pins powerpcfsm_0/AACK]
  connect_bd_net -net mpc106fsm_0_ARTRY [get_bd_pins mpc106fsm_0/ARTRY] [get_bd_pins powerpcfsm_0/ARTRY]
  connect_bd_net -net mpc106fsm_0_BG0 [get_bd_pins mpc106fsm_0/BG0] [get_bd_pins powerpcfsm_0/BG]
  connect_bd_net -net mpc106fsm_0_CS [get_bd_pins chip_select_splitter_0/a] [get_bd_pins mpc106fsm_0/CS]
  connect_bd_net -net mpc106fsm_0_DBG0 [get_bd_pins mpc106fsm_0/DBG0] [get_bd_pins powerpcfsm_0/DBG]
  connect_bd_net -net mpc106fsm_0_SDCAS [get_bd_pins mpc106fsm_0/SDCAS] [get_bd_pins mx9_sdramfsm_0/CAS]
  connect_bd_net -net mpc106fsm_0_SDMA [get_bd_pins mpc106fsm_0/SDMA] [get_bd_pins mx9_sdramfsm_0/A]
  connect_bd_net -net mpc106fsm_0_SDRAS [get_bd_pins mpc106fsm_0/SDRAS] [get_bd_pins mx9_sdramfsm_0/RAS]
  connect_bd_net -net mpc106fsm_0_TA [get_bd_pins mpc106fsm_0/TA] [get_bd_pins powerpcfsm_0/TA]
  connect_bd_net -net mpc106fsm_0_WE [get_bd_pins mpc106fsm_0/WE] [get_bd_pins mx9_sdramfsm_0/WE]
  connect_bd_net -net powerpcfsm_0_A [get_bd_pins mpc106fsm_0/A] [get_bd_pins powerpcfsm_0/A]
  connect_bd_net -net powerpcfsm_0_BR [get_bd_pins mpc106fsm_0/BR0] [get_bd_pins powerpcfsm_0/BR]
  connect_bd_net -net powerpcfsm_0_DH [get_bd_pins data_splitter_0/d_in] [get_bd_pins mpc106fsm_0/DH] [get_bd_pins powerpcfsm_0/DH]
  connect_bd_net -net powerpcfsm_0_DL [get_bd_pins mpc106fsm_0/DL] [get_bd_pins powerpcfsm_0/DL]
  connect_bd_net -net powerpcfsm_0_TBST [get_bd_pins mpc106fsm_0/TBST] [get_bd_pins powerpcfsm_0/TBST]
  connect_bd_net -net powerpcfsm_0_TS [get_bd_pins mpc106fsm_0/TS] [get_bd_pins powerpcfsm_0/TS]
  connect_bd_net -net powerpcfsm_0_TSIZ [get_bd_pins mpc106fsm_0/TSIZ] [get_bd_pins powerpcfsm_0/TSIZ]
  connect_bd_net -net powerpcfsm_0_WT [get_bd_pins mpc106fsm_0/WT] [get_bd_pins powerpcfsm_0/WT]

  # Create address segments


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


