
# Efinity Interface Designer SDC
# Version: 2019.3.272.9.1
# Date: 2020-05-26 15:27

# Copyright (C) 2017 - 2019 Efinix Inc. All rights reserved.

# Device: T120F324
# Project: RiscV_wFrameBuffer_top
# Timing Model: C4 (preliminary)
#               NOTE: The timing data is not final

set_clock_groups -group {dma_clk} -group {axi_clk}
set_clock_groups -group {dma_clk} -group {soc_clk}
set_clock_groups -group {dma_clk} -group {tx_slowclk}
set_clock_groups -group {dma_clk} -group {mipi_pclk}

set_clock_groups -group {soc_clk} -group {tx_slowclk}
set_clock_groups -group {soc_clk} -group {mipi_pclk}
set_clock_groups -group {soc_clk} -group {axi_clk} -group {jtag_inst1_TCK}

# PLL Constraints
#################
create_clock -period 2.50 ddr_clk
create_clock -period 10.00 axi_clk
create_clock -period 10.00 soc_clk
create_clock -period 26.94 tx_slowclk
create_clock -waveform {1.92 5.78} -period 7.70 tx_fastclk
create_clock -period 13.33 mipi_pclk
create_clock -period 10.00 mipi_cal_clk
create_clock -period 11.765 dma_clk

# GPIO Constraints
####################
set_output_delay -clock soc_clk -max -4.700 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock soc_clk -min -2.571 [get_ports {system_spi_0_io_sclk_write}]
set_output_delay -clock soc_clk -max -4.700 [get_ports {system_spi_0_io_ss}]
set_output_delay -clock soc_clk -min -2.571 [get_ports {system_spi_0_io_ss}]
set_input_delay -clock soc_clk -max 6.168 [get_ports {system_spi_0_io_data_0_read}]
set_input_delay -clock soc_clk -min 3.084 [get_ports {system_spi_0_io_data_0_read}]
set_output_delay -clock soc_clk -max -4.700 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock soc_clk -min -2.571 [get_ports {system_spi_0_io_data_0_write}]
set_output_delay -clock soc_clk -max -4.707 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_output_delay -clock soc_clk -min -2.567 [get_ports {system_spi_0_io_data_0_writeEnable}]
set_input_delay -clock soc_clk -max 6.168 [get_ports {system_spi_0_io_data_1_read}]
set_input_delay -clock soc_clk -min 3.084 [get_ports {system_spi_0_io_data_1_read}]
set_output_delay -clock soc_clk -max -4.700 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock soc_clk -min -2.571 [get_ports {system_spi_0_io_data_1_write}]
set_output_delay -clock soc_clk -max -4.707 [get_ports {system_spi_0_io_data_1_writeEnable}]
set_output_delay -clock soc_clk -min -2.567 [get_ports {system_spi_0_io_data_1_writeEnable}]

# LVDS TX GPIO Constraints
############################
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {master_rstn}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {master_rstn}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {offchip_rstn}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {offchip_rstn}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {system_uart_0_io_rxd}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {system_uart_0_io_rxd}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {cam_rstn}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {cam_rstn}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {hdmi_rstn}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {hdmi_rstn}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {user_led2}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {user_led2}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {user_led3}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {user_led3}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {system_uart_0_io_txd}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {system_uart_0_io_txd}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {mipi_i2c_0_io_scl_read}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {mipi_i2c_0_io_scl_read}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {mipi_i2c_0_io_scl_write}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {mipi_i2c_0_io_scl_write}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {mipi_i2c_0_io_scl_writeEnable}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {mipi_i2c_0_io_scl_writeEnable}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {mipi_i2c_0_io_sda_read}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {mipi_i2c_0_io_sda_read}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {mipi_i2c_0_io_sda_write}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {mipi_i2c_0_io_sda_write}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {mipi_i2c_0_io_sda_writeEnable}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {mipi_i2c_0_io_sda_writeEnable}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {hdmi_i2c_1_io_scl_read}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {hdmi_i2c_1_io_scl_read}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {hdmi_i2c_1_io_scl_write}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {hdmi_i2c_1_io_scl_write}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {hdmi_i2c_1_io_scl_writeEnable}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {hdmi_i2c_1_io_scl_writeEnable}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {hdmi_i2c_1_io_sda_read}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {hdmi_i2c_1_io_sda_read}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {hdmi_i2c_1_io_sda_write}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {hdmi_i2c_1_io_sda_write}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {hdmi_i2c_1_io_sda_writeEnable}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {hdmi_i2c_1_io_sda_writeEnable}]

# LVDS Rx Constraints
####################

# LVDS Tx Constraints
####################
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_1a_DATA[6] lvds_1a_DATA[5] lvds_1a_DATA[4] lvds_1a_DATA[3] lvds_1a_DATA[2] lvds_1a_DATA[1] lvds_1a_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.575 [get_ports {lvds_1a_DATA[6] lvds_1a_DATA[5] lvds_1a_DATA[4] lvds_1a_DATA[3] lvds_1a_DATA[2] lvds_1a_DATA[1] lvds_1a_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_1b_DATA[6] lvds_1b_DATA[5] lvds_1b_DATA[4] lvds_1b_DATA[3] lvds_1b_DATA[2] lvds_1b_DATA[1] lvds_1b_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.575 [get_ports {lvds_1b_DATA[6] lvds_1b_DATA[5] lvds_1b_DATA[4] lvds_1b_DATA[3] lvds_1b_DATA[2] lvds_1b_DATA[1] lvds_1b_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_1c_DATA[6] lvds_1c_DATA[5] lvds_1c_DATA[4] lvds_1c_DATA[3] lvds_1c_DATA[2] lvds_1c_DATA[1] lvds_1c_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.575 [get_ports {lvds_1c_DATA[6] lvds_1c_DATA[5] lvds_1c_DATA[4] lvds_1c_DATA[3] lvds_1c_DATA[2] lvds_1c_DATA[1] lvds_1c_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_1d_DATA[6] lvds_1d_DATA[5] lvds_1d_DATA[4] lvds_1d_DATA[3] lvds_1d_DATA[2] lvds_1d_DATA[1] lvds_1d_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.575 [get_ports {lvds_1d_DATA[6] lvds_1d_DATA[5] lvds_1d_DATA[4] lvds_1d_DATA[3] lvds_1d_DATA[2] lvds_1d_DATA[1] lvds_1d_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_2a_DATA[6] lvds_2a_DATA[5] lvds_2a_DATA[4] lvds_2a_DATA[3] lvds_2a_DATA[2] lvds_2a_DATA[1] lvds_2a_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.575 [get_ports {lvds_2a_DATA[6] lvds_2a_DATA[5] lvds_2a_DATA[4] lvds_2a_DATA[3] lvds_2a_DATA[2] lvds_2a_DATA[1] lvds_2a_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_2b_DATA[6] lvds_2b_DATA[5] lvds_2b_DATA[4] lvds_2b_DATA[3] lvds_2b_DATA[2] lvds_2b_DATA[1] lvds_2b_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.575 [get_ports {lvds_2b_DATA[6] lvds_2b_DATA[5] lvds_2b_DATA[4] lvds_2b_DATA[3] lvds_2b_DATA[2] lvds_2b_DATA[1] lvds_2b_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_2c_DATA[6] lvds_2c_DATA[5] lvds_2c_DATA[4] lvds_2c_DATA[3] lvds_2c_DATA[2] lvds_2c_DATA[1] lvds_2c_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.575 [get_ports {lvds_2c_DATA[6] lvds_2c_DATA[5] lvds_2c_DATA[4] lvds_2c_DATA[3] lvds_2c_DATA[2] lvds_2c_DATA[1] lvds_2c_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_2d_DATA[6] lvds_2d_DATA[5] lvds_2d_DATA[4] lvds_2d_DATA[3] lvds_2d_DATA[2] lvds_2d_DATA[1] lvds_2d_DATA[0]}]
set_output_delay -clock tx_slowclk -min -2.575 [get_ports {lvds_2d_DATA[6] lvds_2d_DATA[5] lvds_2d_DATA[4] lvds_2d_DATA[3] lvds_2d_DATA[2] lvds_2d_DATA[1] lvds_2d_DATA[0]}]
set_output_delay -clock tx_slowclk -max -5.230 [get_ports {lvds_clk[6] lvds_clk[5] lvds_clk[4] lvds_clk[3] lvds_clk[2] lvds_clk[1] lvds_clk[0]}]
set_output_delay -clock tx_slowclk -min -2.575 [get_ports {lvds_clk[6] lvds_clk[5] lvds_clk[4] lvds_clk[3] lvds_clk[2] lvds_clk[1] lvds_clk[0]}]

# MIPI RX Constraints
#####################################
set_output_delay -clock mipi_pclk -max -4.746 [get_ports {mipi_inst1_VC_ENA[3] mipi_inst1_VC_ENA[2] mipi_inst1_VC_ENA[1] mipi_inst1_VC_ENA[0]}]
set_output_delay -clock mipi_pclk -min -2.587 [get_ports {mipi_inst1_VC_ENA[3] mipi_inst1_VC_ENA[2] mipi_inst1_VC_ENA[1] mipi_inst1_VC_ENA[0]}]
set_output_delay -clock mipi_pclk -max -5.197 [get_ports {mipi_inst1_CLEAR}]
set_output_delay -clock mipi_pclk -min -2.498 [get_ports {mipi_inst1_CLEAR}]
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
# create_clock -period <USER_PERIOD> [get_ports {jtag_inst1_DRCK}]
set_output_delay -clock jtag_inst1_TCK -max 0.111 [get_ports {jtag_inst1_TDO}]
set_output_delay -clock jtag_inst1_TCK -min 0.053 [get_ports {jtag_inst1_TDO}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_RESET}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_RESET}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_RUNTEST}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_RUNTEST}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.231 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.116 [get_ports {jtag_inst1_SEL}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.267 [get_ports {jtag_inst1_UPDATE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.134 [get_ports {jtag_inst1_UPDATE}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -max 0.321 [get_ports {jtag_inst1_SHIFT}]
set_input_delay -clock_fall -clock jtag_inst1_TCK -min 0.161 [get_ports {jtag_inst1_SHIFT}]
# create_clock -period <USER_PERIOD> [get_ports {jtag_inst2_TCK}]
# create_clock -period <USER_PERIOD> [get_ports {jtag_inst2_DRCK}]
set_output_delay -clock jtag_inst2_TCK -max 0.111 [get_ports {jtag_inst2_TDO}]
set_output_delay -clock jtag_inst2_TCK -min 0.053 [get_ports {jtag_inst2_TDO}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -max 0.267 [get_ports {jtag_inst2_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -min 0.134 [get_ports {jtag_inst2_CAPTURE}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -max 0.267 [get_ports {jtag_inst2_RESET}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -min 0.134 [get_ports {jtag_inst2_RESET}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -max 0.267 [get_ports {jtag_inst2_RUNTEST}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -min 0.134 [get_ports {jtag_inst2_RUNTEST}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -max 0.231 [get_ports {jtag_inst2_SEL}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -min 0.116 [get_ports {jtag_inst2_SEL}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -max 0.267 [get_ports {jtag_inst2_UPDATE}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -min 0.134 [get_ports {jtag_inst2_UPDATE}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -max 0.321 [get_ports {jtag_inst2_SHIFT}]
set_input_delay -clock_fall -clock jtag_inst2_TCK -min 0.161 [get_ports {jtag_inst2_SHIFT}]

# DDR Constraints
#####################
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_addr[*]}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_arw_payload_addr[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_burst[1] io_ddrB_arw_payload_burst[0]}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_arw_payload_burst[1] io_ddrB_arw_payload_burst[0]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_id[*]}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_arw_payload_id[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_len[*]}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_arw_payload_len[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_lock[1] io_ddrB_arw_payload_lock[0]}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_arw_payload_lock[1] io_ddrB_arw_payload_lock[0]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_size[2] io_ddrB_arw_payload_size[1] io_ddrB_arw_payload_size[0]}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_arw_payload_size[2] io_ddrB_arw_payload_size[1] io_ddrB_arw_payload_size[0]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_payload_write}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_arw_payload_write}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_arw_valid}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_arw_valid}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_b_ready}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_b_ready}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_r_ready}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_r_ready}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_payload_data[*]}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_w_payload_data[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_payload_id[*]}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_w_payload_id[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_payload_last}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_w_payload_last}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_payload_strb[*]}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_w_payload_strb[*]}]
set_output_delay -clock dma_clk -max -2.810 [get_ports {io_ddrB_w_valid}]
set_output_delay -clock dma_clk -min -2.155 [get_ports {io_ddrB_w_valid}]
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
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_arw_payload_addr[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_burst[1] io_ddrA_arw_payload_burst[0]}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_arw_payload_burst[1] io_ddrA_arw_payload_burst[0]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_id[*]}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_arw_payload_id[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_len[*]}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_arw_payload_len[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_lock[1] io_ddrA_arw_payload_lock[0]}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_arw_payload_lock[1] io_ddrA_arw_payload_lock[0]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_size[2] io_ddrA_arw_payload_size[1] io_ddrA_arw_payload_size[0]}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_arw_payload_size[2] io_ddrA_arw_payload_size[1] io_ddrA_arw_payload_size[0]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_payload_write}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_arw_payload_write}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_arw_valid}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_arw_valid}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_b_ready}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_b_ready}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_r_ready}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_r_ready}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_payload_data[*]}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_w_payload_data[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_payload_id[*]}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_w_payload_id[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_payload_last}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_w_payload_last}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_payload_strb[*]}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_w_payload_strb[*]}]
set_output_delay -clock axi_clk -max -2.810 [get_ports {io_ddrA_w_valid}]
set_output_delay -clock axi_clk -min -2.155 [get_ports {io_ddrA_w_valid}]
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

# False Path
#################
#set_false_path -setup -hold -from u_risc_v/io_systemReset* 
#set_false_path -setup -hold -from u_risc_v/io_memoryReset*