# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: /home/INTRA/eydire/workspace/project/ip_repo/zedboard_audio/constraints/zed_audio.xdc

# Block Designs: bd/week1/week1.bd
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1 || ORIG_REF_NAME==week1}]

# IP: bd/week1/ip/week1_processing_system7_0_0/week1_processing_system7_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_processing_system7_0_0 || ORIG_REF_NAME==week1_processing_system7_0_0}]

# IP: bd/week1/ip/week1_zed_audio_0_0/week1_zed_audio_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_zed_audio_0_0 || ORIG_REF_NAME==week1_zed_audio_0_0}]

# IP: bd/week1/ip/week1_audio_to_AXI_0_1/week1_audio_to_AXI_0_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_audio_to_AXI_0_1 || ORIG_REF_NAME==week1_audio_to_AXI_0_1}]

# IP: bd/week1/ip/week1_processing_system7_0_axi_periph_0/week1_processing_system7_0_axi_periph_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_processing_system7_0_axi_periph_0 || ORIG_REF_NAME==week1_processing_system7_0_axi_periph_0}]

# IP: bd/week1/ip/week1_rst_processing_system7_0_100M_0/week1_rst_processing_system7_0_100M_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_rst_processing_system7_0_100M_0 || ORIG_REF_NAME==week1_rst_processing_system7_0_100M_0}]

# IP: bd/week1/ip/week1_AXI_to_audio_0_0/week1_AXI_to_audio_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_AXI_to_audio_0_0 || ORIG_REF_NAME==week1_AXI_to_audio_0_0}]

# IP: bd/week1/ip/week1_xlconstant_0_1/week1_xlconstant_0_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_xlconstant_0_1 || ORIG_REF_NAME==week1_xlconstant_0_1}]

# IP: bd/week1/ip/week1_xbar_0/week1_xbar_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_xbar_0 || ORIG_REF_NAME==week1_xbar_0}]

# IP: bd/week1/ip/week1_AXI_to_audio_0_1/week1_AXI_to_audio_0_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_AXI_to_audio_0_1 || ORIG_REF_NAME==week1_AXI_to_audio_0_1}]

# IP: bd/week1/ip/week1_audio_mixer_0_0/week1_audio_mixer_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_audio_mixer_0_0 || ORIG_REF_NAME==week1_audio_mixer_0_0}]

# IP: bd/week1/ip/week1_FILTER_IIR_0_0/week1_FILTER_IIR_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_FILTER_IIR_0_0 || ORIG_REF_NAME==week1_FILTER_IIR_0_0}]

# IP: bd/week1/ip/week1_Volume_Pregain_0_0/week1_Volume_Pregain_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_Volume_Pregain_0_0 || ORIG_REF_NAME==week1_Volume_Pregain_0_0}]

# IP: bd/week1/ip/week1_FILTER_IIR_0_1/week1_FILTER_IIR_0_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_FILTER_IIR_0_1 || ORIG_REF_NAME==week1_FILTER_IIR_0_1}]

# IP: bd/week1/ip/week1_Volume_Pregain_0_1/week1_Volume_Pregain_0_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_Volume_Pregain_0_1 || ORIG_REF_NAME==week1_Volume_Pregain_0_1}]

# IP: bd/week1/ip/week1_auto_pc_0/week1_auto_pc_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_auto_pc_0 || ORIG_REF_NAME==week1_auto_pc_0}]

# XDC: bd/week1/ip/week1_processing_system7_0_0/week1_processing_system7_0_0.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==week1_processing_system7_0_0 || ORIG_REF_NAME==week1_processing_system7_0_0}] {/inst }]/inst ]]

# XDC: bd/week1/ip/week1_rst_processing_system7_0_100M_0/week1_rst_processing_system7_0_100M_0_board.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_rst_processing_system7_0_100M_0 || ORIG_REF_NAME==week1_rst_processing_system7_0_100M_0}]

# XDC: bd/week1/ip/week1_rst_processing_system7_0_100M_0/week1_rst_processing_system7_0_100M_0.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==week1_rst_processing_system7_0_100M_0 || ORIG_REF_NAME==week1_rst_processing_system7_0_100M_0}]

# XDC: bd/week1/ip/week1_rst_processing_system7_0_100M_0/week1_rst_processing_system7_0_100M_0_ooc.xdc

# XDC: bd/week1/ip/week1_xbar_0/week1_xbar_0_ooc.xdc

# XDC: bd/week1/ip/week1_auto_pc_0/week1_auto_pc_0_ooc.xdc

# XDC: bd/week1/week1_ooc.xdc
