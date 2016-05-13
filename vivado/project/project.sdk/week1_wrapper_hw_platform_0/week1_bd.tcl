
################################################################
# This is a generated script based on design: week1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source week1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name week1

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

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set AC_ADR0 [ create_bd_port -dir O AC_ADR0 ]
  set AC_ADR1 [ create_bd_port -dir O AC_ADR1 ]
  set AC_GPIO0 [ create_bd_port -dir O AC_GPIO0 ]
  set AC_GPIO1 [ create_bd_port -dir I AC_GPIO1 ]
  set AC_GPIO2 [ create_bd_port -dir I AC_GPIO2 ]
  set AC_GPIO3 [ create_bd_port -dir I AC_GPIO3 ]
  set AC_MCLK [ create_bd_port -dir O AC_MCLK ]
  set AC_SCK [ create_bd_port -dir O AC_SCK ]
  set AC_SDA [ create_bd_port -dir IO AC_SDA ]

  # Create instance: AXI_to_audio_0, and set properties
  set AXI_to_audio_0 [ create_bd_cell -type ip -vlnv user.org:user:AXI_to_audio:1.0 AXI_to_audio_0 ]

  # Create instance: AXI_to_audio_1, and set properties
  set AXI_to_audio_1 [ create_bd_cell -type ip -vlnv user.org:user:AXI_to_audio:1.0 AXI_to_audio_1 ]

  # Create instance: FILTER_IIR_0, and set properties
  set FILTER_IIR_0 [ create_bd_cell -type ip -vlnv tsotnep:userLibrary:FILTER_IIR:1.0 FILTER_IIR_0 ]

  # Create instance: FILTER_IIR_1, and set properties
  set FILTER_IIR_1 [ create_bd_cell -type ip -vlnv tsotnep:userLibrary:FILTER_IIR:1.0 FILTER_IIR_1 ]

  # Create instance: Volume_Pregain_0, and set properties
  set Volume_Pregain_0 [ create_bd_cell -type ip -vlnv tsotnep:userLibrary:Volume_Pregain:1.0 Volume_Pregain_0 ]

  # Create instance: Volume_Pregain_1, and set properties
  set Volume_Pregain_1 [ create_bd_cell -type ip -vlnv tsotnep:userLibrary:Volume_Pregain:1.0 Volume_Pregain_1 ]

  # Create instance: audio_mixer_0, and set properties
  set audio_mixer_0 [ create_bd_cell -type ip -vlnv tsotnep:userLibrary:audio_mixer:1.0 audio_mixer_0 ]

  # Create instance: audio_to_AXI_0, and set properties
  set audio_to_AXI_0 [ create_bd_cell -type ip -vlnv user.org:user:audio_to_AXI:1.0 audio_to_AXI_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.preset {ZedBoard}  ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {7}  ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: zed_audio_0, and set properties
  set zed_audio_0 [ create_bd_cell -type ip -vlnv user.org:user:zed_audio:1.0 zed_audio_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins audio_to_AXI_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins AXI_to_audio_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins AXI_to_audio_1/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins FILTER_IIR_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins Volume_Pregain_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins FILTER_IIR_1/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins Volume_Pregain_1/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M06_AXI]

  # Create port connections
  connect_bd_net -net AC_GPIO1_1 [get_bd_ports AC_GPIO1] [get_bd_pins zed_audio_0/AC_GPIO1]
  connect_bd_net -net AC_GPIO2_1 [get_bd_ports AC_GPIO2] [get_bd_pins zed_audio_0/AC_GPIO2]
  connect_bd_net -net AC_GPIO3_1 [get_bd_ports AC_GPIO3] [get_bd_pins zed_audio_0/AC_GPIO3]
  connect_bd_net -net AXI_to_audio_0_audio_out_l [get_bd_pins AXI_to_audio_0/audio_out_l] [get_bd_pins Volume_Pregain_0/IN_SIG_L]
  connect_bd_net -net AXI_to_audio_0_audio_out_r [get_bd_pins AXI_to_audio_0/audio_out_r] [get_bd_pins Volume_Pregain_0/IN_SIG_R]
  connect_bd_net -net AXI_to_audio_0_audio_out_valid [get_bd_pins AXI_to_audio_0/audio_out_valid] [get_bd_pins zed_audio_0/hphone_l_valid] [get_bd_pins zed_audio_0/hphone_r_valid_dummy]
  connect_bd_net -net AXI_to_audio_1_audio_out_l [get_bd_pins AXI_to_audio_1/audio_out_l] [get_bd_pins Volume_Pregain_1/IN_SIG_L]
  connect_bd_net -net AXI_to_audio_1_audio_out_r [get_bd_pins AXI_to_audio_1/audio_out_r] [get_bd_pins Volume_Pregain_1/IN_SIG_R]
  connect_bd_net -net FILTER_IIR_0_AUDIO_OUT_L [get_bd_pins FILTER_IIR_0/AUDIO_OUT_L] [get_bd_pins audio_mixer_0/audio_channel_a_left_in]
  connect_bd_net -net FILTER_IIR_0_AUDIO_OUT_R [get_bd_pins FILTER_IIR_0/AUDIO_OUT_R] [get_bd_pins audio_mixer_0/audio_channel_a_right_in]
  connect_bd_net -net FILTER_IIR_1_AUDIO_OUT_L [get_bd_pins FILTER_IIR_1/AUDIO_OUT_L] [get_bd_pins audio_mixer_0/audio_channel_b_left_in]
  connect_bd_net -net FILTER_IIR_1_AUDIO_OUT_R [get_bd_pins FILTER_IIR_1/AUDIO_OUT_R] [get_bd_pins audio_mixer_0/audio_channel_b_right_in]
  connect_bd_net -net Net [get_bd_ports AC_SDA] [get_bd_pins zed_audio_0/AC_SDA]
  connect_bd_net -net Volume_Pregain_0_OUT_RDY [get_bd_pins FILTER_IIR_0/SAMPLE_TRIG] [get_bd_pins Volume_Pregain_0/OUT_RDY]
  connect_bd_net -net Volume_Pregain_0_OUT_VOLCTRL_L [get_bd_pins FILTER_IIR_0/AUDIO_IN_L] [get_bd_pins Volume_Pregain_0/OUT_VOLCTRL_L]
  connect_bd_net -net Volume_Pregain_0_OUT_VOLCTRL_R [get_bd_pins FILTER_IIR_0/AUDIO_IN_R] [get_bd_pins Volume_Pregain_0/OUT_VOLCTRL_R]
  connect_bd_net -net Volume_Pregain_1_OUT_RDY [get_bd_pins FILTER_IIR_1/SAMPLE_TRIG] [get_bd_pins Volume_Pregain_1/OUT_RDY]
  connect_bd_net -net Volume_Pregain_1_OUT_VOLCTRL_L [get_bd_pins FILTER_IIR_1/AUDIO_IN_L] [get_bd_pins Volume_Pregain_1/OUT_VOLCTRL_L]
  connect_bd_net -net Volume_Pregain_1_OUT_VOLCTRL_R [get_bd_pins FILTER_IIR_1/AUDIO_IN_R] [get_bd_pins Volume_Pregain_1/OUT_VOLCTRL_R]
  connect_bd_net -net audio_mixer_0_audio_mixed_a_b_left_out [get_bd_pins audio_mixer_0/audio_mixed_a_b_left_out] [get_bd_pins zed_audio_0/hphone_l]
  connect_bd_net -net audio_mixer_0_audio_mixed_a_b_right_out [get_bd_pins audio_mixer_0/audio_mixed_a_b_right_out] [get_bd_pins zed_audio_0/hphone_r]
  connect_bd_net -net audio_to_AXI_0_audio_out_valid_irq [get_bd_pins audio_to_AXI_0/audio_out_valid_irq] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins AXI_to_audio_0/s00_axi_aclk] [get_bd_pins AXI_to_audio_1/s00_axi_aclk] [get_bd_pins FILTER_IIR_0/s00_axi_aclk] [get_bd_pins FILTER_IIR_1/s00_axi_aclk] [get_bd_pins Volume_Pregain_0/s00_axi_aclk] [get_bd_pins Volume_Pregain_1/s00_axi_aclk] [get_bd_pins audio_to_AXI_0/s00_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk] [get_bd_pins zed_audio_0/clk_100]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins AXI_to_audio_0/s00_axi_aresetn] [get_bd_pins AXI_to_audio_1/s00_axi_aresetn] [get_bd_pins FILTER_IIR_0/s00_axi_aresetn] [get_bd_pins FILTER_IIR_1/s00_axi_aresetn] [get_bd_pins Volume_Pregain_0/s00_axi_aresetn] [get_bd_pins Volume_Pregain_1/s00_axi_aresetn] [get_bd_pins audio_to_AXI_0/s00_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins AXI_to_audio_0/audio_in_valid_irq] [get_bd_pins AXI_to_audio_1/audio_in_valid_irq] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net zed_audio_0_AC_ADR0 [get_bd_ports AC_ADR0] [get_bd_pins zed_audio_0/AC_ADR0]
  connect_bd_net -net zed_audio_0_AC_ADR1 [get_bd_ports AC_ADR1] [get_bd_pins zed_audio_0/AC_ADR1]
  connect_bd_net -net zed_audio_0_AC_GPIO0 [get_bd_ports AC_GPIO0] [get_bd_pins zed_audio_0/AC_GPIO0]
  connect_bd_net -net zed_audio_0_AC_MCLK [get_bd_ports AC_MCLK] [get_bd_pins zed_audio_0/AC_MCLK]
  connect_bd_net -net zed_audio_0_AC_SCK [get_bd_ports AC_SCK] [get_bd_pins zed_audio_0/AC_SCK]
  connect_bd_net -net zed_audio_0_line_in_l [get_bd_pins audio_to_AXI_0/audio_in_l] [get_bd_pins zed_audio_0/line_in_l]
  connect_bd_net -net zed_audio_0_line_in_r [get_bd_pins audio_to_AXI_0/audio_in_r] [get_bd_pins zed_audio_0/line_in_r]
  connect_bd_net -net zed_audio_0_new_sample [get_bd_pins audio_to_AXI_0/audio_in_valid] [get_bd_pins zed_audio_0/new_sample]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AXI_to_audio_0/S00_AXI/S00_AXI_reg] SEG_AXI_to_audio_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AXI_to_audio_1/S00_AXI/S00_AXI_reg] SEG_AXI_to_audio_1_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs FILTER_IIR_0/S00_AXI/S00_AXI_reg] SEG_FILTER_IIR_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs FILTER_IIR_1/S00_AXI/S00_AXI_reg] SEG_FILTER_IIR_1_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs Volume_Pregain_0/S00_AXI/S00_AXI_reg] SEG_Volume_Pregain_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs Volume_Pregain_1/S00_AXI/S00_AXI_reg] SEG_Volume_Pregain_1_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs audio_to_AXI_0/S00_AXI/S00_AXI_reg] SEG_audio_to_AXI_0_S00_AXI_reg
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


