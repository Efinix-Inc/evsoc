
# Efinity Interface Designer SDC
# Version: 2023.1.150.3.11
# Date: 2023-08-16 13:29

# Copyright (C) 2017 - 2023 Efinix Inc. All rights reserved.

# Device: T120F324
# Project: edge_vision_soc
# Timing Model: C4 (final)

# PLL Constraints
#################
create_clock -period 2.5000 ddr_clk
create_clock -period 10.0000 axi_clk
create_clock -period 10.0000 soc_clk
create_clock -period 14.2857 dma_clk
create_clock -period 26.9360 tx_slowclk
create_clock -waveform {1.9240 5.7720} -period 7.6960 tx_fastclk
create_clock -period 13.3333 mipi_pclk
create_clock -period 10.0000 mipi_cal_clk
create_clock -period 100 [get_ports {jtag_inst1_TCK}]

set_clock_groups -exclusive -group {dma_clk} -group {axi_clk} -group {soc_clk} -group {tx_slowclk} -group {mipi_pclk} -group {jtag_inst1_TCK}

# GPIO Constraints
####################
set_output_delay -clock soc_clk -max -4.700 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock soc_clk -min -2.739 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock soc_clk -max -4.700 [get_ports {system_spi_0_io_ss}]
set_output_delay -clock soc_clk -min -2.739 [get_ports {system_spi_0_io_ss}]
set_input_delay -clock soc_clk -max 6.168 [get_ports {system_spi_0_io_data_0_read}]
set_input_delay -clock soc_clk -min 3.084 [get_ports {system_spi_0_io_data_0_read}]
set_output_delay -clock soc_clk -max -4.700 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock soc_clk -min -2.739 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock soc_clk -max -4.707 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_output_delay -clock soc_clk -min -2.742 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_input_delay -clock soc_clk -max 6.168 [get_ports {system_spi_0_io_data_1_read}]
set_input_delay -clock soc_clk -min 3.084 [get_ports {system_spi_0_io_data_1_read}]
set_output_delay -clock soc_clk -max -4.700 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock soc_clk -min -2.739 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock soc_clk -max -4.707 [get_ports {system_spi_0_io_data_1_writeEnable}]
set_output_delay -clock soc_clk -min -2.742 [get_ports {system_spi_0_io_data_1_writeEnable}]

# LVDS Tx Constraints
####################
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_1a_DATA[6] lvds_1a_DATA[5] lvds_1a_DATA[4] lvds_1a_DATA[3] lvds_1a_DATA[2] lvds_1a_DATA[1] lvds_1a_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.735 [get_ports {lvds_1a_DATA[6] lvds_1a_DATA[5] lvds_1a_DATA[4] lvds_1a_DATA[3] lvds_1a_DATA[2] lvds_1a_DATA[1] lvds_1a_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_1b_DATA[6] lvds_1b_DATA[5] lvds_1b_DATA[4] lvds_1b_DATA[3] lvds_1b_DATA[2] lvds_1b_DATA[1] lvds_1b_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.735 [get_ports {lvds_1b_DATA[6] lvds_1b_DATA[5] lvds_1b_DATA[4] lvds_1b_DATA[3] lvds_1b_DATA[2] lvds_1b_DATA[1] lvds_1b_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_1c_DATA[6] lvds_1c_DATA[5] lvds_1c_DATA[4] lvds_1c_DATA[3] lvds_1c_DATA[2] lvds_1c_DATA[1] lvds_1c_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.735 [get_ports {lvds_1c_DATA[6] lvds_1c_DATA[5] lvds_1c_DATA[4] lvds_1c_DATA[3] lvds_1c_DATA[2] lvds_1c_DATA[1] lvds_1c_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_1d_DATA[6] lvds_1d_DATA[5] lvds_1d_DATA[4] lvds_1d_DATA[3] lvds_1d_DATA[2] lvds_1d_DATA[1] lvds_1d_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.735 [get_ports {lvds_1d_DATA[6] lvds_1d_DATA[5] lvds_1d_DATA[4] lvds_1d_DATA[3] lvds_1d_DATA[2] lvds_1d_DATA[1] lvds_1d_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_2a_DATA[6] lvds_2a_DATA[5] lvds_2a_DATA[4] lvds_2a_DATA[3] lvds_2a_DATA[2] lvds_2a_DATA[1] lvds_2a_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.735 [get_ports {lvds_2a_DATA[6] lvds_2a_DATA[5] lvds_2a_DATA[4] lvds_2a_DATA[3] lvds_2a_DATA[2] lvds_2a_DATA[1] lvds_2a_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_2b_DATA[6] lvds_2b_DATA[5] lvds_2b_DATA[4] lvds_2b_DATA[3] lvds_2b_DATA[2] lvds_2b_DATA[1] lvds_2b_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.735 [get_ports {lvds_2b_DATA[6] lvds_2b_DATA[5] lvds_2b_DATA[4] lvds_2b_DATA[3] lvds_2b_DATA[2] lvds_2b_DATA[1] lvds_2b_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_2c_DATA[6] lvds_2c_DATA[5] lvds_2c_DATA[4] lvds_2c_DATA[3] lvds_2c_DATA[2] lvds_2c_DATA[1] lvds_2c_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.735 [get_ports {lvds_2c_DATA[6] lvds_2c_DATA[5] lvds_2c_DATA[4] lvds_2c_DATA[3] lvds_2c_DATA[2] lvds_2c_DATA[1] lvds_2c_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_2d_DATA[6] lvds_2d_DATA[5] lvds_2d_DATA[4] lvds_2d_DATA[3] lvds_2d_DATA[2] lvds_2d_DATA[1] lvds_2d_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.735 [get_ports {lvds_2d_DATA[6] lvds_2d_DATA[5] lvds_2d_DATA[4] lvds_2d_DATA[3] lvds_2d_DATA[2] lvds_2d_DATA[1] lvds_2d_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_clk[6] lvds_clk[5] lvds_clk[4] lvds_clk[3] lvds_clk[2] lvds_clk[1] lvds_clk[0]}]
set_output_delay -clock tx_slowclk -min -2.735 [get_ports {lvds_clk[6] lvds_clk[5] lvds_clk[4] lvds_clk[3] lvds_clk[2] lvds_clk[1] lvds_clk[0]}]

# MIPI RX Constraints
#####################################
set_output_delay -clock mipi_pclk -max -4.746 [get_ports {mipi_inst1_VC_ENA[3] mipi_inst1_VC_ENA[2] mipi_inst1_VC_ENA[1] mipi_inst1_VC_ENA[0]}]
set_output_delay -clock mipi_pclk -min -2.723 [get_ports {mipi_inst1_VC_ENA[3] mipi_inst1_VC_ENA[2] mipi_inst1_VC_ENA[1] mipi_inst1_VC_ENA[0]}]
set_output_delay -clock mipi_pclk -max -5.197 [get_ports {mipi_inst1_CLEAR}]
set_output_delay -clock mipi_pclk -min -2.811 [get_ports {mipi_inst1_CLEAR}]
set_input_delay -clock mipi_pclk -max 6.394 [get_ports {mipi_inst1_VSYNC[3] mipi_inst1_VSYNC[2] mipi_inst1_VSYNC[1] mipi_inst1_VSYNC[0]}]
set_input_delay -clock mipi_pclk -min 3.197 [get_ports {mipi_inst1_VSYNC[3] mipi_inst1_VSYNC[2] mipi_inst1_VSYNC[1] mipi_inst1_VSYNC[0]}]
set_input_delay -clock mipi_pclk -max 6.388 [get_ports {mipi_inst1_HSYNC[3] mipi_inst1_HSYNC[2] mipi_inst1_HSYNC[1] mipi_inst1_HSYNC[0]}]
set_input_delay -clock mipi_pclk -min 3.194 [get_ports {mipi_inst1_HSYNC[3] mipi_inst1_HSYNC[2] mipi_inst1_HSYNC[1] mipi_inst1_HSYNC[0]}]
set_input_delay -clock mipi_pclk -max 6.242 [get_ports {mipi_inst1_VALID}]
set_input_delay -clock mipi_pclk -min 3.121 [get_ports {mipi_inst1_VALID}]
set_input_delay -clock mipi_pclk -max 6.312 [get_ports {mipi_inst1_CNT[3] mipi_inst1_CNT[2] mipi_inst1_CNT[1] mipi_inst1_CNT[0]}]
set_input_delay -clock mipi_pclk -min 3.156 [get_ports {mipi_inst1_CNT[3] mipi_inst1_CNT[2] mipi_inst1_CNT[1] mipi_inst1_CNT[0]}]
set_input_delay -clock mipi_pclk -max 6.340 [get_ports {mipi_inst1_DATA[*]}]
set_input_delay -clock mipi_pclk -min 3.170 [get_ports {mipi_inst1_DATA[*]}]
set_input_delay -clock mipi_pclk -max 6.257 [get_ports {mipi_inst1_ERR[*]}]
set_input_delay -clock mipi_pclk -min 3.128 [get_ports {mipi_inst1_ERR[*]}]
set_input_delay -clock mipi_pclk -max 6.255 [get_ports {mipi_inst1_ULPS_CLK}]
set_input_delay -clock mipi_pclk -min 3.127 [get_ports {mipi_inst1_ULPS_CLK}]
set_input_delay -clock mipi_pclk -max 6.264 [get_ports {mipi_inst1_ULPS[3] mipi_inst1_ULPS[2] mipi_inst1_ULPS[1] mipi_inst1_ULPS[0]}]
set_input_delay -clock mipi_pclk -min 3.132 [get_ports {mipi_inst1_ULPS[3] mipi_inst1_ULPS[2] mipi_inst1_ULPS[1] mipi_inst1_ULPS[0]}]

# JTAG Constraints
####################
# create_clock -period <USER_PERIOD> [get_ports {jtag_inst1_TCK}]
set_output_delay -clock jtag_inst1_TCK -max 0.111 [get_ports {jtag_inst1_TDO}]
set_output_delay -clock jtag_inst1_TCK -min -0.053 [get_ports {jtag_inst1_TDO}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_RESET}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_RESET}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.231 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.116 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_UPDATE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_UPDATE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.321 [get_ports {jtag_inst1_SHIFT}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.161 [get_ports {jtag_inst1_SHIFT}]
# JTAG Constraints (extra... not used by current Efinity debug tools)
# create_clock -period <USER_PERIOD> [get_ports {jtag_inst1_DRCK}]
# set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_RUNTEST}]
# set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_RUNTEST}]
# Create separate clock groups for JTAG clocks. Remove DRCK clock from the list below if it is not defined.
# set_clock_groups -asynchronous -group {jtag_inst1_TCK jtag_inst1_DRCK}

# DDR Constraints
#####################
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_addr[*]}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_arw_payload_addr[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_burst[1] io_ddrB_arw_payload_burst[0]}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_arw_payload_burst[1] io_ddrB_arw_payload_burst[0]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_id[*]}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_arw_payload_id[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_len[*]}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_arw_payload_len[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_lock[1] io_ddrB_arw_payload_lock[0]}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_arw_payload_lock[1] io_ddrB_arw_payload_lock[0]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_size[2] io_ddrB_arw_payload_size[1] io_ddrB_arw_payload_size[0]}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_arw_payload_size[2] io_ddrB_arw_payload_size[1] io_ddrB_arw_payload_size[0]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_write}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_arw_payload_write}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_valid}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_arw_valid}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_b_ready}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_b_ready}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_r_ready}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_r_ready}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_payload_data[*]}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_w_payload_data[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_payload_id[*]}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_w_payload_id[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_payload_last}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_w_payload_last}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_payload_strb[*]}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_w_payload_strb[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_valid}]
set_output_delay -clock dma_clk -min -3.055 [get_ports {io_ddrB_w_valid}]
set_input_delay -clock dma_clk -max 8.310 [get_ports {io_ddrB_arw_ready}]
set_input_delay -clock dma_clk -min 4.155 [get_ports {io_ddrB_arw_ready}]
set_input_delay -clock dma_clk -max 8.310 [get_ports {io_ddrB_b_payload_id[*]}]
set_input_delay -clock dma_clk -min 4.155 [get_ports {io_ddrB_b_payload_id[*]}]
set_input_delay -clock dma_clk -max 8.310 [get_ports {io_ddrB_b_valid}]
set_input_delay -clock dma_clk -min 4.155 [get_ports {io_ddrB_b_valid}]
set_input_delay -clock dma_clk -max 8.310 [get_ports {io_ddrB_r_payload_data[*]}]
set_input_delay -clock dma_clk -min 4.155 [get_ports {io_ddrB_r_payload_data[*]}]
set_input_delay -clock dma_clk -max 8.310 [get_ports {io_ddrB_r_payload_id[*]}]
set_input_delay -clock dma_clk -min 4.155 [get_ports {io_ddrB_r_payload_id[*]}]
set_input_delay -clock dma_clk -max 8.310 [get_ports {io_ddrB_r_payload_last}]
set_input_delay -clock dma_clk -min 4.155 [get_ports {io_ddrB_r_payload_last}]
set_input_delay -clock dma_clk -max 8.310 [get_ports {io_ddrB_r_payload_resp[1] io_ddrB_r_payload_resp[0]}]
set_input_delay -clock dma_clk -min 4.155 [get_ports {io_ddrB_r_payload_resp[1] io_ddrB_r_payload_resp[0]}]
set_input_delay -clock dma_clk -max 8.310 [get_ports {io_ddrB_r_valid}]
set_input_delay -clock dma_clk -min 4.155 [get_ports {io_ddrB_r_valid}]
set_input_delay -clock dma_clk -max 8.310 [get_ports {io_ddrB_w_ready}]
set_input_delay -clock dma_clk -min 4.155 [get_ports {io_ddrB_w_ready}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_addr[*]}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_arw_payload_addr[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_burst[1] io_ddrA_arw_payload_burst[0]}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_arw_payload_burst[1] io_ddrA_arw_payload_burst[0]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_id[*]}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_arw_payload_id[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_len[*]}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_arw_payload_len[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_lock[1] io_ddrA_arw_payload_lock[0]}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_arw_payload_lock[1] io_ddrA_arw_payload_lock[0]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_size[2] io_ddrA_arw_payload_size[1] io_ddrA_arw_payload_size[0]}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_arw_payload_size[2] io_ddrA_arw_payload_size[1] io_ddrA_arw_payload_size[0]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_write}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_arw_payload_write}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_valid}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_arw_valid}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_b_ready}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_b_ready}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_r_ready}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_r_ready}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_payload_data[*]}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_w_payload_data[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_payload_id[*]}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_w_payload_id[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_payload_last}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_w_payload_last}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_payload_strb[*]}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_w_payload_strb[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_valid}]
set_output_delay -clock axi_clk -min -3.055 [get_ports {io_ddrA_w_valid}]
set_input_delay -clock axi_clk -max 8.310 [get_ports {io_ddrA_arw_ready}]
set_input_delay -clock axi_clk -min 4.155 [get_ports {io_ddrA_arw_ready}]
set_input_delay -clock axi_clk -max 8.310 [get_ports {io_ddrA_b_payload_id[*]}]
set_input_delay -clock axi_clk -min 4.155 [get_ports {io_ddrA_b_payload_id[*]}]
set_input_delay -clock axi_clk -max 8.310 [get_ports {io_ddrA_b_valid}]
set_input_delay -clock axi_clk -min 4.155 [get_ports {io_ddrA_b_valid}]
set_input_delay -clock axi_clk -max 8.310 [get_ports {io_ddrA_r_payload_data[*]}]
set_input_delay -clock axi_clk -min 4.155 [get_ports {io_ddrA_r_payload_data[*]}]
set_input_delay -clock axi_clk -max 8.310 [get_ports {io_ddrA_r_payload_id[*]}]
set_input_delay -clock axi_clk -min 4.155 [get_ports {io_ddrA_r_payload_id[*]}]
set_input_delay -clock axi_clk -max 8.310 [get_ports {io_ddrA_r_payload_last}]
set_input_delay -clock axi_clk -min 4.155 [get_ports {io_ddrA_r_payload_last}]
set_input_delay -clock axi_clk -max 8.310 [get_ports {io_ddrA_r_payload_resp[1] io_ddrA_r_payload_resp[0]}]
set_input_delay -clock axi_clk -min 4.155 [get_ports {io_ddrA_r_payload_resp[1] io_ddrA_r_payload_resp[0]}]
set_input_delay -clock axi_clk -max 8.310 [get_ports {io_ddrA_r_valid}]
set_input_delay -clock axi_clk -min 4.155 [get_ports {io_ddrA_r_valid}]
set_input_delay -clock axi_clk -max 8.310 [get_ports {io_ddrA_w_ready}]
set_input_delay -clock axi_clk -min 4.155 [get_ports {io_ddrA_w_ready}]
