///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021 github-efx
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////

// Generator : SpinalHDL v1.4.3    git head : 20a4261df2693e53e5a2e0efbb78d19d9a8ea2bc
// Component : dma_socRuby

module dma_socRuby (
  input      [13:0]   ctrl_PADDR,
  input      [0:0]    ctrl_PSEL,
  input               ctrl_PENABLE,
  output              ctrl_PREADY,
  input               ctrl_PWRITE,
  input      [31:0]   ctrl_PWDATA,
  output     [31:0]   ctrl_PRDATA,
  output              ctrl_PSLVERROR,
  output     [3:0]    ctrl_interrupts,
  output              read_arvalid,
  input               read_arready,
  output     [31:0]   read_araddr,
  output     [3:0]    read_arregion,
  output     [7:0]    read_arlen,
  output     [2:0]    read_arsize,
  output     [1:0]    read_arburst,
  output     [0:0]    read_arlock,
  output     [3:0]    read_arcache,
  output     [3:0]    read_arqos,
  output     [2:0]    read_arprot,
  input               read_rvalid,
  output              read_rready,
  input      [127:0]  read_rdata,
  input      [1:0]    read_rresp,
  input               read_rlast,
  output              write_awvalid,
  input               write_awready,
  output     [31:0]   write_awaddr,
  output     [3:0]    write_awregion,
  output     [7:0]    write_awlen,
  output     [2:0]    write_awsize,
  output     [1:0]    write_awburst,
  output     [0:0]    write_awlock,
  output     [3:0]    write_awcache,
  output     [3:0]    write_awqos,
  output     [2:0]    write_awprot,
  output              write_wvalid,
  input               write_wready,
  output     [127:0]  write_wdata,
  output     [15:0]   write_wstrb,
  output              write_wlast,
  input               write_bvalid,
  output              write_bready,
  input      [1:0]    write_bresp,
  input               dat64_i_ch0_tvalid,
  output              dat64_i_ch0_tready,
  input      [63:0]   dat64_i_ch0_tdata,
  input      [7:0]    dat64_i_ch0_tkeep,
  input      [3:0]    dat64_i_ch0_tdest,
  input               dat64_i_ch0_tlast,
  input               dat32_i_ch2_tvalid,
  output              dat32_i_ch2_tready,
  input      [31:0]   dat32_i_ch2_tdata,
  input      [3:0]    dat32_i_ch2_tkeep,
  input      [3:0]    dat32_i_ch2_tdest,
  input               dat32_i_ch2_tlast,
  output              dat64_o_ch1_tvalid,
  input               dat64_o_ch1_tready,
  output     [63:0]   dat64_o_ch1_tdata,
  output     [7:0]    dat64_o_ch1_tkeep,
  output     [3:0]    dat64_o_ch1_tdest,
  output              dat64_o_ch1_tlast,
  output              dat32_o_ch3_tvalid,
  input               dat32_o_ch3_tready,
  output     [31:0]   dat32_o_ch3_tdata,
  output     [3:0]    dat32_o_ch3_tkeep,
  output     [3:0]    dat32_o_ch3_tdest,
  output              dat32_o_ch3_tlast,
  input               clk,
  input               reset,
  input               ctrl_clk,
  input               ctrl_reset,
  input               dat64_i_ch0_clk,
  input               dat64_i_ch0_reset,
  input               dat32_i_ch2_clk,
  input               dat32_i_ch2_reset,
  input               dat64_o_ch1_clk,
  input               dat64_o_ch1_reset,
  input               dat32_o_ch3_clk,
  input               dat32_o_ch3_reset
);
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  wire                _zz_6;
  wire                _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                core_io_sgRead_cmd_valid;
  wire                core_io_sgRead_cmd_payload_last;
  wire       [0:0]    core_io_sgRead_cmd_payload_fragment_opcode;
  wire       [31:0]   core_io_sgRead_cmd_payload_fragment_address;
  wire       [4:0]    core_io_sgRead_cmd_payload_fragment_length;
  wire       [1:0]    core_io_sgRead_cmd_payload_fragment_context;
  wire                core_io_sgRead_rsp_ready;
  wire                core_io_sgWrite_cmd_valid;
  wire                core_io_sgWrite_cmd_payload_last;
  wire       [0:0]    core_io_sgWrite_cmd_payload_fragment_opcode;
  wire       [31:0]   core_io_sgWrite_cmd_payload_fragment_address;
  wire       [1:0]    core_io_sgWrite_cmd_payload_fragment_length;
  wire       [127:0]  core_io_sgWrite_cmd_payload_fragment_data;
  wire       [15:0]   core_io_sgWrite_cmd_payload_fragment_mask;
  wire       [1:0]    core_io_sgWrite_cmd_payload_fragment_context;
  wire                core_io_sgWrite_rsp_ready;
  wire                core_io_read_cmd_valid;
  wire                core_io_read_cmd_payload_last;
  wire       [0:0]    core_io_read_cmd_payload_fragment_source;
  wire       [0:0]    core_io_read_cmd_payload_fragment_opcode;
  wire       [31:0]   core_io_read_cmd_payload_fragment_address;
  wire       [11:0]   core_io_read_cmd_payload_fragment_length;
  wire       [21:0]   core_io_read_cmd_payload_fragment_context;
  wire                core_io_read_rsp_ready;
  wire                core_io_write_cmd_valid;
  wire                core_io_write_cmd_payload_last;
  wire       [0:0]    core_io_write_cmd_payload_fragment_source;
  wire       [0:0]    core_io_write_cmd_payload_fragment_opcode;
  wire       [31:0]   core_io_write_cmd_payload_fragment_address;
  wire       [11:0]   core_io_write_cmd_payload_fragment_length;
  wire       [127:0]  core_io_write_cmd_payload_fragment_data;
  wire       [15:0]   core_io_write_cmd_payload_fragment_mask;
  wire       [13:0]   core_io_write_cmd_payload_fragment_context;
  wire                core_io_write_rsp_ready;
  wire                core_io_outputs_0_valid;
  wire       [127:0]  core_io_outputs_0_payload_data;
  wire       [15:0]   core_io_outputs_0_payload_mask;
  wire       [3:0]    core_io_outputs_0_payload_sink;
  wire                core_io_outputs_0_payload_last;
  wire                core_io_outputs_1_valid;
  wire       [127:0]  core_io_outputs_1_payload_data;
  wire       [15:0]   core_io_outputs_1_payload_mask;
  wire       [3:0]    core_io_outputs_1_payload_sink;
  wire                core_io_outputs_1_payload_last;
  wire                core_io_inputs_0_ready;
  wire                core_io_inputs_1_ready;
  wire       [3:0]    core_io_interrupts;
  wire                core_io_ctrl_PREADY;
  wire       [31:0]   core_io_ctrl_PRDATA;
  wire                core_io_ctrl_PSLVERROR;
  wire                withCtrlCc_apbCc_io_input_PREADY;
  wire       [31:0]   withCtrlCc_apbCc_io_input_PRDATA;
  wire                withCtrlCc_apbCc_io_input_PSLVERROR;
  wire       [13:0]   withCtrlCc_apbCc_io_output_PADDR;
  wire       [0:0]    withCtrlCc_apbCc_io_output_PSEL;
  wire                withCtrlCc_apbCc_io_output_PENABLE;
  wire                withCtrlCc_apbCc_io_output_PWRITE;
  wire       [31:0]   withCtrlCc_apbCc_io_output_PWDATA;
  wire       [3:0]    core_io_interrupts_buffercc_io_dataOut;
  wire                interconnect_read_aggregated_arbiter_io_inputs_0_cmd_ready;
  wire                interconnect_read_aggregated_arbiter_io_inputs_0_rsp_valid;
  wire                interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_last;
  wire       [0:0]    interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_opcode;
  wire       [127:0]  interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_data;
  wire       [1:0]    interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_context;
  wire                interconnect_read_aggregated_arbiter_io_inputs_1_cmd_ready;
  wire                interconnect_read_aggregated_arbiter_io_inputs_1_rsp_valid;
  wire                interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_last;
  wire       [0:0]    interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode;
  wire       [127:0]  interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_data;
  wire       [21:0]   interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context;
  wire                interconnect_read_aggregated_arbiter_io_output_cmd_valid;
  wire                interconnect_read_aggregated_arbiter_io_output_cmd_payload_last;
  wire       [1:0]    interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_address;
  wire       [11:0]   interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_length;
  wire       [21:0]   interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_context;
  wire                interconnect_read_aggregated_arbiter_io_output_rsp_ready;
  wire                interconnect_write_aggregated_arbiter_io_inputs_0_cmd_ready;
  wire                interconnect_write_aggregated_arbiter_io_inputs_0_rsp_valid;
  wire                interconnect_write_aggregated_arbiter_io_inputs_0_rsp_payload_last;
  wire       [0:0]    interconnect_write_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_opcode;
  wire       [1:0]    interconnect_write_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_context;
  wire                interconnect_write_aggregated_arbiter_io_inputs_1_cmd_ready;
  wire                interconnect_write_aggregated_arbiter_io_inputs_1_rsp_valid;
  wire                interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_last;
  wire       [0:0]    interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source;
  wire       [0:0]    interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode;
  wire       [13:0]   interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context;
  wire                interconnect_write_aggregated_arbiter_io_output_cmd_valid;
  wire                interconnect_write_aggregated_arbiter_io_output_cmd_payload_last;
  wire       [1:0]    interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_source;
  wire       [0:0]    interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_address;
  wire       [11:0]   interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_length;
  wire       [127:0]  interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_data;
  wire       [15:0]   interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_mask;
  wire       [13:0]   interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_context;
  wire                interconnect_write_aggregated_arbiter_io_output_rsp_ready;
  wire                readLogic_sourceRemover_io_input_cmd_ready;
  wire                readLogic_sourceRemover_io_input_rsp_valid;
  wire                readLogic_sourceRemover_io_input_rsp_payload_last;
  wire       [1:0]    readLogic_sourceRemover_io_input_rsp_payload_fragment_source;
  wire       [0:0]    readLogic_sourceRemover_io_input_rsp_payload_fragment_opcode;
  wire       [127:0]  readLogic_sourceRemover_io_input_rsp_payload_fragment_data;
  wire       [21:0]   readLogic_sourceRemover_io_input_rsp_payload_fragment_context;
  wire                readLogic_sourceRemover_io_output_cmd_valid;
  wire                readLogic_sourceRemover_io_output_cmd_payload_last;
  wire       [0:0]    readLogic_sourceRemover_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   readLogic_sourceRemover_io_output_cmd_payload_fragment_address;
  wire       [11:0]   readLogic_sourceRemover_io_output_cmd_payload_fragment_length;
  wire       [23:0]   readLogic_sourceRemover_io_output_cmd_payload_fragment_context;
  wire                readLogic_sourceRemover_io_output_rsp_ready;
  wire                readLogic_bridge_io_input_cmd_ready;
  wire                readLogic_bridge_io_input_rsp_valid;
  wire                readLogic_bridge_io_input_rsp_payload_last;
  wire       [0:0]    readLogic_bridge_io_input_rsp_payload_fragment_opcode;
  wire       [127:0]  readLogic_bridge_io_input_rsp_payload_fragment_data;
  wire       [23:0]   readLogic_bridge_io_input_rsp_payload_fragment_context;
  wire                readLogic_bridge_io_output_ar_valid;
  wire       [31:0]   readLogic_bridge_io_output_ar_payload_addr;
  wire       [7:0]    readLogic_bridge_io_output_ar_payload_len;
  wire       [2:0]    readLogic_bridge_io_output_ar_payload_size;
  wire       [3:0]    readLogic_bridge_io_output_ar_payload_cache;
  wire       [2:0]    readLogic_bridge_io_output_ar_payload_prot;
  wire                readLogic_bridge_io_output_r_ready;
  wire                readLogic_beforeQueue_fifo_io_push_ready;
  wire                readLogic_beforeQueue_fifo_io_pop_valid;
  wire       [127:0]  readLogic_beforeQueue_fifo_io_pop_payload_data;
  wire       [1:0]    readLogic_beforeQueue_fifo_io_pop_payload_resp;
  wire                readLogic_beforeQueue_fifo_io_pop_payload_last;
  wire       [8:0]    readLogic_beforeQueue_fifo_io_occupancy;
  wire       [8:0]    readLogic_beforeQueue_fifo_io_availability;
  wire                writeLogic_sourceRemover_io_input_cmd_ready;
  wire                writeLogic_sourceRemover_io_input_rsp_valid;
  wire                writeLogic_sourceRemover_io_input_rsp_payload_last;
  wire       [1:0]    writeLogic_sourceRemover_io_input_rsp_payload_fragment_source;
  wire       [0:0]    writeLogic_sourceRemover_io_input_rsp_payload_fragment_opcode;
  wire       [13:0]   writeLogic_sourceRemover_io_input_rsp_payload_fragment_context;
  wire                writeLogic_sourceRemover_io_output_cmd_valid;
  wire                writeLogic_sourceRemover_io_output_cmd_payload_last;
  wire       [0:0]    writeLogic_sourceRemover_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   writeLogic_sourceRemover_io_output_cmd_payload_fragment_address;
  wire       [11:0]   writeLogic_sourceRemover_io_output_cmd_payload_fragment_length;
  wire       [127:0]  writeLogic_sourceRemover_io_output_cmd_payload_fragment_data;
  wire       [15:0]   writeLogic_sourceRemover_io_output_cmd_payload_fragment_mask;
  wire       [15:0]   writeLogic_sourceRemover_io_output_cmd_payload_fragment_context;
  wire                writeLogic_sourceRemover_io_output_rsp_ready;
  wire                writeLogic_retainer_io_input_cmd_ready;
  wire                writeLogic_retainer_io_input_rsp_valid;
  wire                writeLogic_retainer_io_input_rsp_payload_last;
  wire       [0:0]    writeLogic_retainer_io_input_rsp_payload_fragment_opcode;
  wire       [15:0]   writeLogic_retainer_io_input_rsp_payload_fragment_context;
  wire                writeLogic_retainer_io_output_cmd_valid;
  wire                writeLogic_retainer_io_output_cmd_payload_last;
  wire       [0:0]    writeLogic_retainer_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   writeLogic_retainer_io_output_cmd_payload_fragment_address;
  wire       [11:0]   writeLogic_retainer_io_output_cmd_payload_fragment_length;
  wire       [127:0]  writeLogic_retainer_io_output_cmd_payload_fragment_data;
  wire       [15:0]   writeLogic_retainer_io_output_cmd_payload_fragment_mask;
  wire       [15:0]   writeLogic_retainer_io_output_cmd_payload_fragment_context;
  wire                writeLogic_retainer_io_output_rsp_ready;
  wire                writeLogic_bridge_io_input_cmd_ready;
  wire                writeLogic_bridge_io_input_rsp_valid;
  wire                writeLogic_bridge_io_input_rsp_payload_last;
  wire       [0:0]    writeLogic_bridge_io_input_rsp_payload_fragment_opcode;
  wire       [15:0]   writeLogic_bridge_io_input_rsp_payload_fragment_context;
  wire                writeLogic_bridge_io_output_aw_valid;
  wire       [31:0]   writeLogic_bridge_io_output_aw_payload_addr;
  wire       [7:0]    writeLogic_bridge_io_output_aw_payload_len;
  wire       [2:0]    writeLogic_bridge_io_output_aw_payload_size;
  wire       [3:0]    writeLogic_bridge_io_output_aw_payload_cache;
  wire       [2:0]    writeLogic_bridge_io_output_aw_payload_prot;
  wire                writeLogic_bridge_io_output_w_valid;
  wire       [127:0]  writeLogic_bridge_io_output_w_payload_data;
  wire       [15:0]   writeLogic_bridge_io_output_w_payload_strb;
  wire                writeLogic_bridge_io_output_w_payload_last;
  wire                writeLogic_bridge_io_output_b_ready;
  wire                inputsAdapter_0_upsizer_logic_io_input_ready;
  wire                inputsAdapter_0_upsizer_logic_io_output_valid;
  wire       [127:0]  inputsAdapter_0_upsizer_logic_io_output_payload_data;
  wire       [15:0]   inputsAdapter_0_upsizer_logic_io_output_payload_mask;
  wire       [3:0]    inputsAdapter_0_upsizer_logic_io_output_payload_sink;
  wire                inputsAdapter_0_upsizer_logic_io_output_payload_last;
  wire                inputsAdapter_0_crossclock_fifo_io_push_ready;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_valid;
  wire       [127:0]  inputsAdapter_0_crossclock_fifo_io_pop_payload_data;
  wire       [15:0]   inputsAdapter_0_crossclock_fifo_io_pop_payload_mask;
  wire       [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_payload_sink;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_payload_last;
  wire       [4:0]    inputsAdapter_0_crossclock_fifo_io_pushOccupancy;
  wire       [4:0]    inputsAdapter_0_crossclock_fifo_io_popOccupancy;
  wire                inputsAdapter_1_upsizer_logic_io_input_ready;
  wire                inputsAdapter_1_upsizer_logic_io_output_valid;
  wire       [127:0]  inputsAdapter_1_upsizer_logic_io_output_payload_data;
  wire       [15:0]   inputsAdapter_1_upsizer_logic_io_output_payload_mask;
  wire       [3:0]    inputsAdapter_1_upsizer_logic_io_output_payload_sink;
  wire                inputsAdapter_1_upsizer_logic_io_output_payload_last;
  wire                inputsAdapter_1_crossclock_fifo_io_push_ready;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_valid;
  wire       [127:0]  inputsAdapter_1_crossclock_fifo_io_pop_payload_data;
  wire       [15:0]   inputsAdapter_1_crossclock_fifo_io_pop_payload_mask;
  wire       [3:0]    inputsAdapter_1_crossclock_fifo_io_pop_payload_sink;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_payload_last;
  wire       [4:0]    inputsAdapter_1_crossclock_fifo_io_pushOccupancy;
  wire       [4:0]    inputsAdapter_1_crossclock_fifo_io_popOccupancy;
  wire                outputsAdapter_0_crossclock_fifo_io_push_ready;
  wire                outputsAdapter_0_crossclock_fifo_io_pop_valid;
  wire       [127:0]  outputsAdapter_0_crossclock_fifo_io_pop_payload_data;
  wire       [15:0]   outputsAdapter_0_crossclock_fifo_io_pop_payload_mask;
  wire       [3:0]    outputsAdapter_0_crossclock_fifo_io_pop_payload_sink;
  wire                outputsAdapter_0_crossclock_fifo_io_pop_payload_last;
  wire       [4:0]    outputsAdapter_0_crossclock_fifo_io_pushOccupancy;
  wire       [4:0]    outputsAdapter_0_crossclock_fifo_io_popOccupancy;
  wire                outputsAdapter_0_sparseDownsizer_logic_io_input_ready;
  wire                outputsAdapter_0_sparseDownsizer_logic_io_output_valid;
  wire       [63:0]   outputsAdapter_0_sparseDownsizer_logic_io_output_payload_data;
  wire       [7:0]    outputsAdapter_0_sparseDownsizer_logic_io_output_payload_mask;
  wire       [3:0]    outputsAdapter_0_sparseDownsizer_logic_io_output_payload_sink;
  wire                outputsAdapter_0_sparseDownsizer_logic_io_output_payload_last;
  wire                outputsAdapter_1_crossclock_fifo_io_push_ready;
  wire                outputsAdapter_1_crossclock_fifo_io_pop_valid;
  wire       [127:0]  outputsAdapter_1_crossclock_fifo_io_pop_payload_data;
  wire       [15:0]   outputsAdapter_1_crossclock_fifo_io_pop_payload_mask;
  wire       [3:0]    outputsAdapter_1_crossclock_fifo_io_pop_payload_sink;
  wire                outputsAdapter_1_crossclock_fifo_io_pop_payload_last;
  wire       [4:0]    outputsAdapter_1_crossclock_fifo_io_pushOccupancy;
  wire       [4:0]    outputsAdapter_1_crossclock_fifo_io_popOccupancy;
  wire                outputsAdapter_1_sparseDownsizer_logic_io_input_ready;
  wire                outputsAdapter_1_sparseDownsizer_logic_io_output_valid;
  wire       [31:0]   outputsAdapter_1_sparseDownsizer_logic_io_output_payload_data;
  wire       [3:0]    outputsAdapter_1_sparseDownsizer_logic_io_output_payload_mask;
  wire       [3:0]    outputsAdapter_1_sparseDownsizer_logic_io_output_payload_sink;
  wire                outputsAdapter_1_sparseDownsizer_logic_io_output_payload_last;
  wire                _zz_10;
  wire                _zz_11;
  wire                _zz_12;
  wire                _zz_13;
  wire                _zz_14;
  wire                _zz_15;
  wire                _zz_16;
  wire                _zz_17;
  wire                _zz_18;
  wire                _zz_19;
  wire                _zz_20;
  wire                _zz_21;
  wire                core_io_write_cmd_s2mPipe_valid;
  wire                core_io_write_cmd_s2mPipe_ready;
  wire                core_io_write_cmd_s2mPipe_payload_last;
  wire       [0:0]    core_io_write_cmd_s2mPipe_payload_fragment_source;
  wire       [0:0]    core_io_write_cmd_s2mPipe_payload_fragment_opcode;
  wire       [31:0]   core_io_write_cmd_s2mPipe_payload_fragment_address;
  wire       [11:0]   core_io_write_cmd_s2mPipe_payload_fragment_length;
  wire       [127:0]  core_io_write_cmd_s2mPipe_payload_fragment_data;
  wire       [15:0]   core_io_write_cmd_s2mPipe_payload_fragment_mask;
  wire       [13:0]   core_io_write_cmd_s2mPipe_payload_fragment_context;
  reg                 core_io_write_cmd_s2mPipe_rValid;
  reg                 core_io_write_cmd_s2mPipe_rData_last;
  reg        [0:0]    core_io_write_cmd_s2mPipe_rData_fragment_source;
  reg        [0:0]    core_io_write_cmd_s2mPipe_rData_fragment_opcode;
  reg        [31:0]   core_io_write_cmd_s2mPipe_rData_fragment_address;
  reg        [11:0]   core_io_write_cmd_s2mPipe_rData_fragment_length;
  reg        [127:0]  core_io_write_cmd_s2mPipe_rData_fragment_data;
  reg        [15:0]   core_io_write_cmd_s2mPipe_rData_fragment_mask;
  reg        [13:0]   core_io_write_cmd_s2mPipe_rData_fragment_context;
  wire                core_io_write_cmd_s2mPipe_m2sPipe_valid;
  wire                core_io_write_cmd_s2mPipe_m2sPipe_ready;
  wire                core_io_write_cmd_s2mPipe_m2sPipe_payload_last;
  wire       [0:0]    core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_source;
  wire       [0:0]    core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_opcode;
  wire       [31:0]   core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_address;
  wire       [11:0]   core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_length;
  wire       [127:0]  core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_data;
  wire       [15:0]   core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_mask;
  wire       [13:0]   core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_context;
  reg                 core_io_write_cmd_s2mPipe_m2sPipe_rValid;
  reg                 core_io_write_cmd_s2mPipe_m2sPipe_rData_last;
  reg        [0:0]    core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_source;
  reg        [0:0]    core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_opcode;
  reg        [31:0]   core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_address;
  reg        [11:0]   core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_length;
  reg        [127:0]  core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_data;
  reg        [15:0]   core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_mask;
  reg        [13:0]   core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_context;
  wire                interconnect_read_aggregated_cmd_valid;
  wire                interconnect_read_aggregated_cmd_ready;
  wire                interconnect_read_aggregated_cmd_payload_last;
  wire       [1:0]    interconnect_read_aggregated_cmd_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_cmd_payload_fragment_opcode;
  wire       [31:0]   interconnect_read_aggregated_cmd_payload_fragment_address;
  wire       [11:0]   interconnect_read_aggregated_cmd_payload_fragment_length;
  wire       [21:0]   interconnect_read_aggregated_cmd_payload_fragment_context;
  wire                interconnect_read_aggregated_rsp_valid;
  wire                interconnect_read_aggregated_rsp_ready;
  wire                interconnect_read_aggregated_rsp_payload_last;
  wire       [1:0]    interconnect_read_aggregated_rsp_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_rsp_payload_fragment_opcode;
  wire       [127:0]  interconnect_read_aggregated_rsp_payload_fragment_data;
  wire       [21:0]   interconnect_read_aggregated_rsp_payload_fragment_context;
  wire                interconnect_write_aggregated_cmd_valid;
  wire                interconnect_write_aggregated_cmd_ready;
  wire                interconnect_write_aggregated_cmd_payload_last;
  wire       [1:0]    interconnect_write_aggregated_cmd_payload_fragment_source;
  wire       [0:0]    interconnect_write_aggregated_cmd_payload_fragment_opcode;
  wire       [31:0]   interconnect_write_aggregated_cmd_payload_fragment_address;
  wire       [11:0]   interconnect_write_aggregated_cmd_payload_fragment_length;
  wire       [127:0]  interconnect_write_aggregated_cmd_payload_fragment_data;
  wire       [15:0]   interconnect_write_aggregated_cmd_payload_fragment_mask;
  wire       [13:0]   interconnect_write_aggregated_cmd_payload_fragment_context;
  wire                interconnect_write_aggregated_rsp_valid;
  wire                interconnect_write_aggregated_rsp_ready;
  wire                interconnect_write_aggregated_rsp_payload_last;
  wire       [1:0]    interconnect_write_aggregated_rsp_payload_fragment_source;
  wire       [0:0]    interconnect_write_aggregated_rsp_payload_fragment_opcode;
  wire       [13:0]   interconnect_write_aggregated_rsp_payload_fragment_context;
  wire                readLogic_resized_cmd_valid;
  wire                readLogic_resized_cmd_ready;
  wire                readLogic_resized_cmd_payload_last;
  wire       [1:0]    readLogic_resized_cmd_payload_fragment_source;
  wire       [0:0]    readLogic_resized_cmd_payload_fragment_opcode;
  wire       [31:0]   readLogic_resized_cmd_payload_fragment_address;
  wire       [11:0]   readLogic_resized_cmd_payload_fragment_length;
  wire       [21:0]   readLogic_resized_cmd_payload_fragment_context;
  wire                readLogic_resized_rsp_valid;
  wire                readLogic_resized_rsp_ready;
  wire                readLogic_resized_rsp_payload_last;
  wire       [1:0]    readLogic_resized_rsp_payload_fragment_source;
  wire       [0:0]    readLogic_resized_rsp_payload_fragment_opcode;
  wire       [127:0]  readLogic_resized_rsp_payload_fragment_data;
  wire       [21:0]   readLogic_resized_rsp_payload_fragment_context;
  wire                interconnect_read_aggregated_cmd_halfPipe_valid;
  wire                interconnect_read_aggregated_cmd_halfPipe_ready;
  wire                interconnect_read_aggregated_cmd_halfPipe_payload_last;
  wire       [1:0]    interconnect_read_aggregated_cmd_halfPipe_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_cmd_halfPipe_payload_fragment_opcode;
  wire       [31:0]   interconnect_read_aggregated_cmd_halfPipe_payload_fragment_address;
  wire       [11:0]   interconnect_read_aggregated_cmd_halfPipe_payload_fragment_length;
  wire       [21:0]   interconnect_read_aggregated_cmd_halfPipe_payload_fragment_context;
  reg                 interconnect_read_aggregated_cmd_halfPipe_regs_valid;
  reg                 interconnect_read_aggregated_cmd_halfPipe_regs_ready;
  reg                 interconnect_read_aggregated_cmd_halfPipe_regs_payload_last;
  reg        [1:0]    interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_source;
  reg        [0:0]    interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_opcode;
  reg        [31:0]   interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_address;
  reg        [11:0]   interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_length;
  reg        [21:0]   interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_context;
  wire                readLogic_adapter_ar_valid;
  wire                readLogic_adapter_ar_ready;
  wire       [31:0]   readLogic_adapter_ar_payload_addr;
  wire       [3:0]    readLogic_adapter_ar_payload_region;
  wire       [7:0]    readLogic_adapter_ar_payload_len;
  wire       [2:0]    readLogic_adapter_ar_payload_size;
  wire       [1:0]    readLogic_adapter_ar_payload_burst;
  wire       [0:0]    readLogic_adapter_ar_payload_lock;
  wire       [3:0]    readLogic_adapter_ar_payload_cache;
  wire       [3:0]    readLogic_adapter_ar_payload_qos;
  wire       [2:0]    readLogic_adapter_ar_payload_prot;
  wire                readLogic_adapter_r_valid;
  wire                readLogic_adapter_r_ready;
  wire       [127:0]  readLogic_adapter_r_payload_data;
  wire       [1:0]    readLogic_adapter_r_payload_resp;
  wire                readLogic_adapter_r_payload_last;
  wire       [3:0]    _zz_1;
  wire                readLogic_adapter_ar_halfPipe_valid;
  wire                readLogic_adapter_ar_halfPipe_ready;
  wire       [31:0]   readLogic_adapter_ar_halfPipe_payload_addr;
  wire       [3:0]    readLogic_adapter_ar_halfPipe_payload_region;
  wire       [7:0]    readLogic_adapter_ar_halfPipe_payload_len;
  wire       [2:0]    readLogic_adapter_ar_halfPipe_payload_size;
  wire       [1:0]    readLogic_adapter_ar_halfPipe_payload_burst;
  wire       [0:0]    readLogic_adapter_ar_halfPipe_payload_lock;
  wire       [3:0]    readLogic_adapter_ar_halfPipe_payload_cache;
  wire       [3:0]    readLogic_adapter_ar_halfPipe_payload_qos;
  wire       [2:0]    readLogic_adapter_ar_halfPipe_payload_prot;
  reg                 readLogic_adapter_ar_halfPipe_regs_valid;
  reg                 readLogic_adapter_ar_halfPipe_regs_ready;
  reg        [31:0]   readLogic_adapter_ar_halfPipe_regs_payload_addr;
  reg        [3:0]    readLogic_adapter_ar_halfPipe_regs_payload_region;
  reg        [7:0]    readLogic_adapter_ar_halfPipe_regs_payload_len;
  reg        [2:0]    readLogic_adapter_ar_halfPipe_regs_payload_size;
  reg        [1:0]    readLogic_adapter_ar_halfPipe_regs_payload_burst;
  reg        [0:0]    readLogic_adapter_ar_halfPipe_regs_payload_lock;
  reg        [3:0]    readLogic_adapter_ar_halfPipe_regs_payload_cache;
  reg        [3:0]    readLogic_adapter_ar_halfPipe_regs_payload_qos;
  reg        [2:0]    readLogic_adapter_ar_halfPipe_regs_payload_prot;
  wire                read_r_s2mPipe_valid;
  wire                read_r_s2mPipe_ready;
  wire       [127:0]  read_r_s2mPipe_payload_data;
  wire       [1:0]    read_r_s2mPipe_payload_resp;
  wire                read_r_s2mPipe_payload_last;
  reg                 read_r_s2mPipe_rValid;
  reg        [127:0]  read_r_s2mPipe_rData_data;
  reg        [1:0]    read_r_s2mPipe_rData_resp;
  reg                 read_r_s2mPipe_rData_last;
  wire                readLogic_beforeQueue_valid;
  wire                readLogic_beforeQueue_ready;
  wire       [127:0]  readLogic_beforeQueue_payload_data;
  wire       [1:0]    readLogic_beforeQueue_payload_resp;
  wire                readLogic_beforeQueue_payload_last;
  reg                 read_r_s2mPipe_m2sPipe_rValid;
  reg        [127:0]  read_r_s2mPipe_m2sPipe_rData_data;
  reg        [1:0]    read_r_s2mPipe_m2sPipe_rData_resp;
  reg                 read_r_s2mPipe_m2sPipe_rData_last;
  wire                readLogic_beforeQueue_fifo_io_pop_s2mPipe_valid;
  wire                readLogic_beforeQueue_fifo_io_pop_s2mPipe_ready;
  wire       [127:0]  readLogic_beforeQueue_fifo_io_pop_s2mPipe_payload_data;
  wire       [1:0]    readLogic_beforeQueue_fifo_io_pop_s2mPipe_payload_resp;
  wire                readLogic_beforeQueue_fifo_io_pop_s2mPipe_payload_last;
  reg                 readLogic_beforeQueue_fifo_io_pop_s2mPipe_rValid;
  reg        [127:0]  readLogic_beforeQueue_fifo_io_pop_s2mPipe_rData_data;
  reg        [1:0]    readLogic_beforeQueue_fifo_io_pop_s2mPipe_rData_resp;
  reg                 readLogic_beforeQueue_fifo_io_pop_s2mPipe_rData_last;
  wire                readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_valid;
  wire                readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_ready;
  wire       [127:0]  readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_payload_data;
  wire       [1:0]    readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_payload_resp;
  wire                readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_payload_last;
  reg                 readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rValid;
  reg        [127:0]  readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rData_data;
  reg        [1:0]    readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rData_resp;
  reg                 readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rData_last;
  wire                writeLogic_resized_cmd_valid;
  wire                writeLogic_resized_cmd_ready;
  wire                writeLogic_resized_cmd_payload_last;
  wire       [1:0]    writeLogic_resized_cmd_payload_fragment_source;
  wire       [0:0]    writeLogic_resized_cmd_payload_fragment_opcode;
  wire       [31:0]   writeLogic_resized_cmd_payload_fragment_address;
  wire       [11:0]   writeLogic_resized_cmd_payload_fragment_length;
  wire       [127:0]  writeLogic_resized_cmd_payload_fragment_data;
  wire       [15:0]   writeLogic_resized_cmd_payload_fragment_mask;
  wire       [13:0]   writeLogic_resized_cmd_payload_fragment_context;
  wire                writeLogic_resized_rsp_valid;
  wire                writeLogic_resized_rsp_ready;
  wire                writeLogic_resized_rsp_payload_last;
  wire       [1:0]    writeLogic_resized_rsp_payload_fragment_source;
  wire       [0:0]    writeLogic_resized_rsp_payload_fragment_opcode;
  wire       [13:0]   writeLogic_resized_rsp_payload_fragment_context;
  wire                interconnect_write_aggregated_cmd_m2sPipe_valid;
  wire                interconnect_write_aggregated_cmd_m2sPipe_ready;
  wire                interconnect_write_aggregated_cmd_m2sPipe_payload_last;
  wire       [1:0]    interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_source;
  wire       [0:0]    interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_opcode;
  wire       [31:0]   interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_address;
  wire       [11:0]   interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_length;
  wire       [127:0]  interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_data;
  wire       [15:0]   interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_mask;
  wire       [13:0]   interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_context;
  reg                 interconnect_write_aggregated_cmd_m2sPipe_rValid;
  reg                 interconnect_write_aggregated_cmd_m2sPipe_rData_last;
  reg        [1:0]    interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_source;
  reg        [0:0]    interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_opcode;
  reg        [31:0]   interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_address;
  reg        [11:0]   interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_length;
  reg        [127:0]  interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_data;
  reg        [15:0]   interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_mask;
  reg        [13:0]   interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_context;
  wire                writeLogic_adapter_aw_valid;
  wire                writeLogic_adapter_aw_ready;
  wire       [31:0]   writeLogic_adapter_aw_payload_addr;
  wire       [3:0]    writeLogic_adapter_aw_payload_region;
  wire       [7:0]    writeLogic_adapter_aw_payload_len;
  wire       [2:0]    writeLogic_adapter_aw_payload_size;
  wire       [1:0]    writeLogic_adapter_aw_payload_burst;
  wire       [0:0]    writeLogic_adapter_aw_payload_lock;
  wire       [3:0]    writeLogic_adapter_aw_payload_cache;
  wire       [3:0]    writeLogic_adapter_aw_payload_qos;
  wire       [2:0]    writeLogic_adapter_aw_payload_prot;
  wire                writeLogic_adapter_w_valid;
  wire                writeLogic_adapter_w_ready;
  wire       [127:0]  writeLogic_adapter_w_payload_data;
  wire       [15:0]   writeLogic_adapter_w_payload_strb;
  wire                writeLogic_adapter_w_payload_last;
  wire                writeLogic_adapter_b_valid;
  wire                writeLogic_adapter_b_ready;
  wire       [1:0]    writeLogic_adapter_b_payload_resp;
  wire       [3:0]    _zz_2;
  wire                writeLogic_adapter_aw_halfPipe_valid;
  wire                writeLogic_adapter_aw_halfPipe_ready;
  wire       [31:0]   writeLogic_adapter_aw_halfPipe_payload_addr;
  wire       [3:0]    writeLogic_adapter_aw_halfPipe_payload_region;
  wire       [7:0]    writeLogic_adapter_aw_halfPipe_payload_len;
  wire       [2:0]    writeLogic_adapter_aw_halfPipe_payload_size;
  wire       [1:0]    writeLogic_adapter_aw_halfPipe_payload_burst;
  wire       [0:0]    writeLogic_adapter_aw_halfPipe_payload_lock;
  wire       [3:0]    writeLogic_adapter_aw_halfPipe_payload_cache;
  wire       [3:0]    writeLogic_adapter_aw_halfPipe_payload_qos;
  wire       [2:0]    writeLogic_adapter_aw_halfPipe_payload_prot;
  reg                 writeLogic_adapter_aw_halfPipe_regs_valid;
  reg                 writeLogic_adapter_aw_halfPipe_regs_ready;
  reg        [31:0]   writeLogic_adapter_aw_halfPipe_regs_payload_addr;
  reg        [3:0]    writeLogic_adapter_aw_halfPipe_regs_payload_region;
  reg        [7:0]    writeLogic_adapter_aw_halfPipe_regs_payload_len;
  reg        [2:0]    writeLogic_adapter_aw_halfPipe_regs_payload_size;
  reg        [1:0]    writeLogic_adapter_aw_halfPipe_regs_payload_burst;
  reg        [0:0]    writeLogic_adapter_aw_halfPipe_regs_payload_lock;
  reg        [3:0]    writeLogic_adapter_aw_halfPipe_regs_payload_cache;
  reg        [3:0]    writeLogic_adapter_aw_halfPipe_regs_payload_qos;
  reg        [2:0]    writeLogic_adapter_aw_halfPipe_regs_payload_prot;
  wire                writeLogic_adapter_w_s2mPipe_valid;
  wire                writeLogic_adapter_w_s2mPipe_ready;
  wire       [127:0]  writeLogic_adapter_w_s2mPipe_payload_data;
  wire       [15:0]   writeLogic_adapter_w_s2mPipe_payload_strb;
  wire                writeLogic_adapter_w_s2mPipe_payload_last;
  reg                 writeLogic_adapter_w_s2mPipe_rValid;
  reg        [127:0]  writeLogic_adapter_w_s2mPipe_rData_data;
  reg        [15:0]   writeLogic_adapter_w_s2mPipe_rData_strb;
  reg                 writeLogic_adapter_w_s2mPipe_rData_last;
  wire                writeLogic_adapter_w_s2mPipe_m2sPipe_valid;
  wire                writeLogic_adapter_w_s2mPipe_m2sPipe_ready;
  wire       [127:0]  writeLogic_adapter_w_s2mPipe_m2sPipe_payload_data;
  wire       [15:0]   writeLogic_adapter_w_s2mPipe_m2sPipe_payload_strb;
  wire                writeLogic_adapter_w_s2mPipe_m2sPipe_payload_last;
  reg                 writeLogic_adapter_w_s2mPipe_m2sPipe_rValid;
  reg        [127:0]  writeLogic_adapter_w_s2mPipe_m2sPipe_rData_data;
  reg        [15:0]   writeLogic_adapter_w_s2mPipe_m2sPipe_rData_strb;
  reg                 writeLogic_adapter_w_s2mPipe_m2sPipe_rData_last;
  wire                write_b_halfPipe_valid;
  wire                write_b_halfPipe_ready;
  wire       [1:0]    write_b_halfPipe_payload_resp;
  reg                 write_b_halfPipe_regs_valid;
  reg                 write_b_halfPipe_regs_ready;
  reg        [1:0]    write_b_halfPipe_regs_payload_resp;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_valid;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready;
  wire       [127:0]  inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_data;
  wire       [15:0]   inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_mask;
  wire       [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_sink;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_last;
  reg                 inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid;
  reg        [127:0]  inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_data;
  reg        [15:0]   inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_mask;
  reg        [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_sink;
  reg                 inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_last;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_ready;
  wire       [127:0]  inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_data;
  wire       [15:0]   inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_mask;
  wire       [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_sink;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_last;
  reg                 inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid;
  reg        [127:0]  inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_data;
  reg        [15:0]   inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_mask;
  reg        [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_sink;
  reg                 inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_last;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_valid;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_ready;
  wire       [127:0]  inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_data;
  wire       [15:0]   inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_mask;
  wire       [3:0]    inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_sink;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_last;
  reg                 inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid;
  reg        [127:0]  inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_data;
  reg        [15:0]   inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_mask;
  reg        [3:0]    inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_sink;
  reg                 inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_last;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_ready;
  wire       [127:0]  inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_data;
  wire       [15:0]   inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_mask;
  wire       [3:0]    inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_sink;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_last;
  reg                 inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid;
  reg        [127:0]  inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_data;
  reg        [15:0]   inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_mask;
  reg        [3:0]    inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_sink;
  reg                 inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_last;
  wire                core_io_outputs_0_s2mPipe_valid;
  wire                core_io_outputs_0_s2mPipe_ready;
  wire       [127:0]  core_io_outputs_0_s2mPipe_payload_data;
  wire       [15:0]   core_io_outputs_0_s2mPipe_payload_mask;
  wire       [3:0]    core_io_outputs_0_s2mPipe_payload_sink;
  wire                core_io_outputs_0_s2mPipe_payload_last;
  reg                 core_io_outputs_0_s2mPipe_rValid;
  reg        [127:0]  core_io_outputs_0_s2mPipe_rData_data;
  reg        [15:0]   core_io_outputs_0_s2mPipe_rData_mask;
  reg        [3:0]    core_io_outputs_0_s2mPipe_rData_sink;
  reg                 core_io_outputs_0_s2mPipe_rData_last;
  wire                outputsAdapter_0_ptr_valid;
  wire                outputsAdapter_0_ptr_ready;
  wire       [127:0]  outputsAdapter_0_ptr_payload_data;
  wire       [15:0]   outputsAdapter_0_ptr_payload_mask;
  wire       [3:0]    outputsAdapter_0_ptr_payload_sink;
  wire                outputsAdapter_0_ptr_payload_last;
  reg                 core_io_outputs_0_s2mPipe_m2sPipe_rValid;
  reg        [127:0]  core_io_outputs_0_s2mPipe_m2sPipe_rData_data;
  reg        [15:0]   core_io_outputs_0_s2mPipe_m2sPipe_rData_mask;
  reg        [3:0]    core_io_outputs_0_s2mPipe_m2sPipe_rData_sink;
  reg                 core_io_outputs_0_s2mPipe_m2sPipe_rData_last;
  wire                core_io_outputs_1_s2mPipe_valid;
  wire                core_io_outputs_1_s2mPipe_ready;
  wire       [127:0]  core_io_outputs_1_s2mPipe_payload_data;
  wire       [15:0]   core_io_outputs_1_s2mPipe_payload_mask;
  wire       [3:0]    core_io_outputs_1_s2mPipe_payload_sink;
  wire                core_io_outputs_1_s2mPipe_payload_last;
  reg                 core_io_outputs_1_s2mPipe_rValid;
  reg        [127:0]  core_io_outputs_1_s2mPipe_rData_data;
  reg        [15:0]   core_io_outputs_1_s2mPipe_rData_mask;
  reg        [3:0]    core_io_outputs_1_s2mPipe_rData_sink;
  reg                 core_io_outputs_1_s2mPipe_rData_last;
  wire                outputsAdapter_1_ptr_valid;
  wire                outputsAdapter_1_ptr_ready;
  wire       [127:0]  outputsAdapter_1_ptr_payload_data;
  wire       [15:0]   outputsAdapter_1_ptr_payload_mask;
  wire       [3:0]    outputsAdapter_1_ptr_payload_sink;
  wire                outputsAdapter_1_ptr_payload_last;
  reg                 core_io_outputs_1_s2mPipe_m2sPipe_rValid;
  reg        [127:0]  core_io_outputs_1_s2mPipe_m2sPipe_rData_data;
  reg        [15:0]   core_io_outputs_1_s2mPipe_m2sPipe_rData_mask;
  reg        [3:0]    core_io_outputs_1_s2mPipe_m2sPipe_rData_sink;
  reg                 core_io_outputs_1_s2mPipe_m2sPipe_rData_last;

  assign _zz_10 = (_zz_3 && (! core_io_write_cmd_s2mPipe_ready));
  assign _zz_11 = (! interconnect_read_aggregated_cmd_halfPipe_regs_valid);
  assign _zz_12 = (! readLogic_adapter_ar_halfPipe_regs_valid);
  assign _zz_13 = (read_rready && (! read_r_s2mPipe_ready));
  assign _zz_14 = (_zz_6 && (! readLogic_beforeQueue_fifo_io_pop_s2mPipe_ready));
  assign _zz_15 = (! writeLogic_adapter_aw_halfPipe_regs_valid);
  assign _zz_16 = (writeLogic_adapter_w_ready && (! writeLogic_adapter_w_s2mPipe_ready));
  assign _zz_17 = (! write_b_halfPipe_regs_valid);
  assign _zz_18 = (_zz_8 && (! inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready));
  assign _zz_19 = (_zz_9 && (! inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_ready));
  assign _zz_20 = (_zz_4 && (! core_io_outputs_0_s2mPipe_ready));
  assign _zz_21 = (_zz_5 && (! core_io_outputs_1_s2mPipe_ready));
  dma_socRuby_Core core (
    .io_sgRead_cmd_valid                        (core_io_sgRead_cmd_valid                                                              ), //o
    .io_sgRead_cmd_ready                        (interconnect_read_aggregated_arbiter_io_inputs_0_cmd_ready                            ), //i
    .io_sgRead_cmd_payload_last                 (core_io_sgRead_cmd_payload_last                                                       ), //o
    .io_sgRead_cmd_payload_fragment_opcode      (core_io_sgRead_cmd_payload_fragment_opcode                                            ), //o
    .io_sgRead_cmd_payload_fragment_address     (core_io_sgRead_cmd_payload_fragment_address[31:0]                                     ), //o
    .io_sgRead_cmd_payload_fragment_length      (core_io_sgRead_cmd_payload_fragment_length[4:0]                                       ), //o
    .io_sgRead_cmd_payload_fragment_context     (core_io_sgRead_cmd_payload_fragment_context[1:0]                                      ), //o
    .io_sgRead_rsp_valid                        (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_valid                            ), //i
    .io_sgRead_rsp_ready                        (core_io_sgRead_rsp_ready                                                              ), //o
    .io_sgRead_rsp_payload_last                 (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_last                     ), //i
    .io_sgRead_rsp_payload_fragment_opcode      (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_opcode          ), //i
    .io_sgRead_rsp_payload_fragment_data        (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_data[127:0]     ), //i
    .io_sgRead_rsp_payload_fragment_context     (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_context[1:0]    ), //i
    .io_sgWrite_cmd_valid                       (core_io_sgWrite_cmd_valid                                                             ), //o
    .io_sgWrite_cmd_ready                       (interconnect_write_aggregated_arbiter_io_inputs_0_cmd_ready                           ), //i
    .io_sgWrite_cmd_payload_last                (core_io_sgWrite_cmd_payload_last                                                      ), //o
    .io_sgWrite_cmd_payload_fragment_opcode     (core_io_sgWrite_cmd_payload_fragment_opcode                                           ), //o
    .io_sgWrite_cmd_payload_fragment_address    (core_io_sgWrite_cmd_payload_fragment_address[31:0]                                    ), //o
    .io_sgWrite_cmd_payload_fragment_length     (core_io_sgWrite_cmd_payload_fragment_length[1:0]                                      ), //o
    .io_sgWrite_cmd_payload_fragment_data       (core_io_sgWrite_cmd_payload_fragment_data[127:0]                                      ), //o
    .io_sgWrite_cmd_payload_fragment_mask       (core_io_sgWrite_cmd_payload_fragment_mask[15:0]                                       ), //o
    .io_sgWrite_cmd_payload_fragment_context    (core_io_sgWrite_cmd_payload_fragment_context[1:0]                                     ), //o
    .io_sgWrite_rsp_valid                       (interconnect_write_aggregated_arbiter_io_inputs_0_rsp_valid                           ), //i
    .io_sgWrite_rsp_ready                       (core_io_sgWrite_rsp_ready                                                             ), //o
    .io_sgWrite_rsp_payload_last                (interconnect_write_aggregated_arbiter_io_inputs_0_rsp_payload_last                    ), //i
    .io_sgWrite_rsp_payload_fragment_opcode     (interconnect_write_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_opcode         ), //i
    .io_sgWrite_rsp_payload_fragment_context    (interconnect_write_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_context[1:0]   ), //i
    .io_read_cmd_valid                          (core_io_read_cmd_valid                                                                ), //o
    .io_read_cmd_ready                          (interconnect_read_aggregated_arbiter_io_inputs_1_cmd_ready                            ), //i
    .io_read_cmd_payload_last                   (core_io_read_cmd_payload_last                                                         ), //o
    .io_read_cmd_payload_fragment_source        (core_io_read_cmd_payload_fragment_source                                              ), //o
    .io_read_cmd_payload_fragment_opcode        (core_io_read_cmd_payload_fragment_opcode                                              ), //o
    .io_read_cmd_payload_fragment_address       (core_io_read_cmd_payload_fragment_address[31:0]                                       ), //o
    .io_read_cmd_payload_fragment_length        (core_io_read_cmd_payload_fragment_length[11:0]                                        ), //o
    .io_read_cmd_payload_fragment_context       (core_io_read_cmd_payload_fragment_context[21:0]                                       ), //o
    .io_read_rsp_valid                          (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_valid                            ), //i
    .io_read_rsp_ready                          (core_io_read_rsp_ready                                                                ), //o
    .io_read_rsp_payload_last                   (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_last                     ), //i
    .io_read_rsp_payload_fragment_source        (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source          ), //i
    .io_read_rsp_payload_fragment_opcode        (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode          ), //i
    .io_read_rsp_payload_fragment_data          (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_data[127:0]     ), //i
    .io_read_rsp_payload_fragment_context       (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context[21:0]   ), //i
    .io_write_cmd_valid                         (core_io_write_cmd_valid                                                               ), //o
    .io_write_cmd_ready                         (_zz_3                                                                                 ), //i
    .io_write_cmd_payload_last                  (core_io_write_cmd_payload_last                                                        ), //o
    .io_write_cmd_payload_fragment_source       (core_io_write_cmd_payload_fragment_source                                             ), //o
    .io_write_cmd_payload_fragment_opcode       (core_io_write_cmd_payload_fragment_opcode                                             ), //o
    .io_write_cmd_payload_fragment_address      (core_io_write_cmd_payload_fragment_address[31:0]                                      ), //o
    .io_write_cmd_payload_fragment_length       (core_io_write_cmd_payload_fragment_length[11:0]                                       ), //o
    .io_write_cmd_payload_fragment_data         (core_io_write_cmd_payload_fragment_data[127:0]                                        ), //o
    .io_write_cmd_payload_fragment_mask         (core_io_write_cmd_payload_fragment_mask[15:0]                                         ), //o
    .io_write_cmd_payload_fragment_context      (core_io_write_cmd_payload_fragment_context[13:0]                                      ), //o
    .io_write_rsp_valid                         (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_valid                           ), //i
    .io_write_rsp_ready                         (core_io_write_rsp_ready                                                               ), //o
    .io_write_rsp_payload_last                  (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_last                    ), //i
    .io_write_rsp_payload_fragment_source       (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source         ), //i
    .io_write_rsp_payload_fragment_opcode       (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode         ), //i
    .io_write_rsp_payload_fragment_context      (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context[13:0]  ), //i
    .io_outputs_0_valid                         (core_io_outputs_0_valid                                                               ), //o
    .io_outputs_0_ready                         (_zz_4                                                                                 ), //i
    .io_outputs_0_payload_data                  (core_io_outputs_0_payload_data[127:0]                                                 ), //o
    .io_outputs_0_payload_mask                  (core_io_outputs_0_payload_mask[15:0]                                                  ), //o
    .io_outputs_0_payload_sink                  (core_io_outputs_0_payload_sink[3:0]                                                   ), //o
    .io_outputs_0_payload_last                  (core_io_outputs_0_payload_last                                                        ), //o
    .io_outputs_1_valid                         (core_io_outputs_1_valid                                                               ), //o
    .io_outputs_1_ready                         (_zz_5                                                                                 ), //i
    .io_outputs_1_payload_data                  (core_io_outputs_1_payload_data[127:0]                                                 ), //o
    .io_outputs_1_payload_mask                  (core_io_outputs_1_payload_mask[15:0]                                                  ), //o
    .io_outputs_1_payload_sink                  (core_io_outputs_1_payload_sink[3:0]                                                   ), //o
    .io_outputs_1_payload_last                  (core_io_outputs_1_payload_last                                                        ), //o
    .io_inputs_0_valid                          (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid                          ), //i
    .io_inputs_0_ready                          (core_io_inputs_0_ready                                                                ), //o
    .io_inputs_0_payload_data                   (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_data[127:0]            ), //i
    .io_inputs_0_payload_mask                   (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_mask[15:0]             ), //i
    .io_inputs_0_payload_sink                   (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_sink[3:0]              ), //i
    .io_inputs_0_payload_last                   (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_last                   ), //i
    .io_inputs_1_valid                          (inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid                          ), //i
    .io_inputs_1_ready                          (core_io_inputs_1_ready                                                                ), //o
    .io_inputs_1_payload_data                   (inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_data[127:0]            ), //i
    .io_inputs_1_payload_mask                   (inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_mask[15:0]             ), //i
    .io_inputs_1_payload_sink                   (inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_sink[3:0]              ), //i
    .io_inputs_1_payload_last                   (inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_last                   ), //i
    .io_interrupts                              (core_io_interrupts[3:0]                                                               ), //o
    .io_ctrl_PADDR                              (withCtrlCc_apbCc_io_output_PADDR[13:0]                                                ), //i
    .io_ctrl_PSEL                               (withCtrlCc_apbCc_io_output_PSEL                                                       ), //i
    .io_ctrl_PENABLE                            (withCtrlCc_apbCc_io_output_PENABLE                                                    ), //i
    .io_ctrl_PREADY                             (core_io_ctrl_PREADY                                                                   ), //o
    .io_ctrl_PWRITE                             (withCtrlCc_apbCc_io_output_PWRITE                                                     ), //i
    .io_ctrl_PWDATA                             (withCtrlCc_apbCc_io_output_PWDATA[31:0]                                               ), //i
    .io_ctrl_PRDATA                             (core_io_ctrl_PRDATA[31:0]                                                             ), //o
    .io_ctrl_PSLVERROR                          (core_io_ctrl_PSLVERROR                                                                ), //o
    .clk                                        (clk                                                                                   ), //i
    .reset                                      (reset                                                                                 )  //i
  );
  dma_socRuby_Apb3CC withCtrlCc_apbCc (
    .io_input_PADDR         (ctrl_PADDR[13:0]                         ), //i
    .io_input_PSEL          (ctrl_PSEL                                ), //i
    .io_input_PENABLE       (ctrl_PENABLE                             ), //i
    .io_input_PREADY        (withCtrlCc_apbCc_io_input_PREADY         ), //o
    .io_input_PWRITE        (ctrl_PWRITE                              ), //i
    .io_input_PWDATA        (ctrl_PWDATA[31:0]                        ), //i
    .io_input_PRDATA        (withCtrlCc_apbCc_io_input_PRDATA[31:0]   ), //o
    .io_input_PSLVERROR     (withCtrlCc_apbCc_io_input_PSLVERROR      ), //o
    .io_output_PADDR        (withCtrlCc_apbCc_io_output_PADDR[13:0]   ), //o
    .io_output_PSEL         (withCtrlCc_apbCc_io_output_PSEL          ), //o
    .io_output_PENABLE      (withCtrlCc_apbCc_io_output_PENABLE       ), //o
    .io_output_PREADY       (core_io_ctrl_PREADY                      ), //i
    .io_output_PWRITE       (withCtrlCc_apbCc_io_output_PWRITE        ), //o
    .io_output_PWDATA       (withCtrlCc_apbCc_io_output_PWDATA[31:0]  ), //o
    .io_output_PRDATA       (core_io_ctrl_PRDATA[31:0]                ), //i
    .io_output_PSLVERROR    (core_io_ctrl_PSLVERROR                   ), //i
    .ctrl_clk               (ctrl_clk                                 ), //i
    .ctrl_reset             (ctrl_reset                               ), //i
    .clk                    (clk                                      ), //i
    .reset                  (reset                                    )  //i
  );
  dma_socRuby_BufferCC_11 core_io_interrupts_buffercc (
    .io_dataIn     (core_io_interrupts[3:0]                      ), //i
    .io_dataOut    (core_io_interrupts_buffercc_io_dataOut[3:0]  ), //o
    .ctrl_clk      (ctrl_clk                                     ), //i
    .ctrl_reset    (ctrl_reset                                   )  //i
  );
  dma_socRuby_BmbArbiter interconnect_read_aggregated_arbiter (
    .io_inputs_0_cmd_valid                       (core_io_sgRead_cmd_valid                                                             ), //i
    .io_inputs_0_cmd_ready                       (interconnect_read_aggregated_arbiter_io_inputs_0_cmd_ready                           ), //o
    .io_inputs_0_cmd_payload_last                (core_io_sgRead_cmd_payload_last                                                      ), //i
    .io_inputs_0_cmd_payload_fragment_opcode     (core_io_sgRead_cmd_payload_fragment_opcode                                           ), //i
    .io_inputs_0_cmd_payload_fragment_address    (core_io_sgRead_cmd_payload_fragment_address[31:0]                                    ), //i
    .io_inputs_0_cmd_payload_fragment_length     (core_io_sgRead_cmd_payload_fragment_length[4:0]                                      ), //i
    .io_inputs_0_cmd_payload_fragment_context    (core_io_sgRead_cmd_payload_fragment_context[1:0]                                     ), //i
    .io_inputs_0_rsp_valid                       (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_valid                           ), //o
    .io_inputs_0_rsp_ready                       (core_io_sgRead_rsp_ready                                                             ), //i
    .io_inputs_0_rsp_payload_last                (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_last                    ), //o
    .io_inputs_0_rsp_payload_fragment_opcode     (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_opcode         ), //o
    .io_inputs_0_rsp_payload_fragment_data       (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_data[127:0]    ), //o
    .io_inputs_0_rsp_payload_fragment_context    (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_context[1:0]   ), //o
    .io_inputs_1_cmd_valid                       (core_io_read_cmd_valid                                                               ), //i
    .io_inputs_1_cmd_ready                       (interconnect_read_aggregated_arbiter_io_inputs_1_cmd_ready                           ), //o
    .io_inputs_1_cmd_payload_last                (core_io_read_cmd_payload_last                                                        ), //i
    .io_inputs_1_cmd_payload_fragment_source     (core_io_read_cmd_payload_fragment_source                                             ), //i
    .io_inputs_1_cmd_payload_fragment_opcode     (core_io_read_cmd_payload_fragment_opcode                                             ), //i
    .io_inputs_1_cmd_payload_fragment_address    (core_io_read_cmd_payload_fragment_address[31:0]                                      ), //i
    .io_inputs_1_cmd_payload_fragment_length     (core_io_read_cmd_payload_fragment_length[11:0]                                       ), //i
    .io_inputs_1_cmd_payload_fragment_context    (core_io_read_cmd_payload_fragment_context[21:0]                                      ), //i
    .io_inputs_1_rsp_valid                       (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_valid                           ), //o
    .io_inputs_1_rsp_ready                       (core_io_read_rsp_ready                                                               ), //i
    .io_inputs_1_rsp_payload_last                (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_last                    ), //o
    .io_inputs_1_rsp_payload_fragment_source     (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source         ), //o
    .io_inputs_1_rsp_payload_fragment_opcode     (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode         ), //o
    .io_inputs_1_rsp_payload_fragment_data       (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_data[127:0]    ), //o
    .io_inputs_1_rsp_payload_fragment_context    (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context[21:0]  ), //o
    .io_output_cmd_valid                         (interconnect_read_aggregated_arbiter_io_output_cmd_valid                             ), //o
    .io_output_cmd_ready                         (interconnect_read_aggregated_cmd_ready                                               ), //i
    .io_output_cmd_payload_last                  (interconnect_read_aggregated_arbiter_io_output_cmd_payload_last                      ), //o
    .io_output_cmd_payload_fragment_source       (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_source[1:0]      ), //o
    .io_output_cmd_payload_fragment_opcode       (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_opcode           ), //o
    .io_output_cmd_payload_fragment_address      (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_address[31:0]    ), //o
    .io_output_cmd_payload_fragment_length       (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_length[11:0]     ), //o
    .io_output_cmd_payload_fragment_context      (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_context[21:0]    ), //o
    .io_output_rsp_valid                         (interconnect_read_aggregated_rsp_valid                                               ), //i
    .io_output_rsp_ready                         (interconnect_read_aggregated_arbiter_io_output_rsp_ready                             ), //o
    .io_output_rsp_payload_last                  (interconnect_read_aggregated_rsp_payload_last                                        ), //i
    .io_output_rsp_payload_fragment_source       (interconnect_read_aggregated_rsp_payload_fragment_source[1:0]                        ), //i
    .io_output_rsp_payload_fragment_opcode       (interconnect_read_aggregated_rsp_payload_fragment_opcode                             ), //i
    .io_output_rsp_payload_fragment_data         (interconnect_read_aggregated_rsp_payload_fragment_data[127:0]                        ), //i
    .io_output_rsp_payload_fragment_context      (interconnect_read_aggregated_rsp_payload_fragment_context[21:0]                      ), //i
    .clk                                         (clk                                                                                  ), //i
    .reset                                       (reset                                                                                )  //i
  );
  dma_socRuby_BmbArbiter_1 interconnect_write_aggregated_arbiter (
    .io_inputs_0_cmd_valid                       (core_io_sgWrite_cmd_valid                                                             ), //i
    .io_inputs_0_cmd_ready                       (interconnect_write_aggregated_arbiter_io_inputs_0_cmd_ready                           ), //o
    .io_inputs_0_cmd_payload_last                (core_io_sgWrite_cmd_payload_last                                                      ), //i
    .io_inputs_0_cmd_payload_fragment_opcode     (core_io_sgWrite_cmd_payload_fragment_opcode                                           ), //i
    .io_inputs_0_cmd_payload_fragment_address    (core_io_sgWrite_cmd_payload_fragment_address[31:0]                                    ), //i
    .io_inputs_0_cmd_payload_fragment_length     (core_io_sgWrite_cmd_payload_fragment_length[1:0]                                      ), //i
    .io_inputs_0_cmd_payload_fragment_data       (core_io_sgWrite_cmd_payload_fragment_data[127:0]                                      ), //i
    .io_inputs_0_cmd_payload_fragment_mask       (core_io_sgWrite_cmd_payload_fragment_mask[15:0]                                       ), //i
    .io_inputs_0_cmd_payload_fragment_context    (core_io_sgWrite_cmd_payload_fragment_context[1:0]                                     ), //i
    .io_inputs_0_rsp_valid                       (interconnect_write_aggregated_arbiter_io_inputs_0_rsp_valid                           ), //o
    .io_inputs_0_rsp_ready                       (core_io_sgWrite_rsp_ready                                                             ), //i
    .io_inputs_0_rsp_payload_last                (interconnect_write_aggregated_arbiter_io_inputs_0_rsp_payload_last                    ), //o
    .io_inputs_0_rsp_payload_fragment_opcode     (interconnect_write_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_opcode         ), //o
    .io_inputs_0_rsp_payload_fragment_context    (interconnect_write_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_context[1:0]   ), //o
    .io_inputs_1_cmd_valid                       (core_io_write_cmd_s2mPipe_m2sPipe_valid                                               ), //i
    .io_inputs_1_cmd_ready                       (interconnect_write_aggregated_arbiter_io_inputs_1_cmd_ready                           ), //o
    .io_inputs_1_cmd_payload_last                (core_io_write_cmd_s2mPipe_m2sPipe_payload_last                                        ), //i
    .io_inputs_1_cmd_payload_fragment_source     (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_source                             ), //i
    .io_inputs_1_cmd_payload_fragment_opcode     (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_opcode                             ), //i
    .io_inputs_1_cmd_payload_fragment_address    (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_address[31:0]                      ), //i
    .io_inputs_1_cmd_payload_fragment_length     (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_length[11:0]                       ), //i
    .io_inputs_1_cmd_payload_fragment_data       (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_data[127:0]                        ), //i
    .io_inputs_1_cmd_payload_fragment_mask       (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_mask[15:0]                         ), //i
    .io_inputs_1_cmd_payload_fragment_context    (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_context[13:0]                      ), //i
    .io_inputs_1_rsp_valid                       (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_valid                           ), //o
    .io_inputs_1_rsp_ready                       (core_io_write_rsp_ready                                                               ), //i
    .io_inputs_1_rsp_payload_last                (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_last                    ), //o
    .io_inputs_1_rsp_payload_fragment_source     (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source         ), //o
    .io_inputs_1_rsp_payload_fragment_opcode     (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode         ), //o
    .io_inputs_1_rsp_payload_fragment_context    (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context[13:0]  ), //o
    .io_output_cmd_valid                         (interconnect_write_aggregated_arbiter_io_output_cmd_valid                             ), //o
    .io_output_cmd_ready                         (interconnect_write_aggregated_cmd_ready                                               ), //i
    .io_output_cmd_payload_last                  (interconnect_write_aggregated_arbiter_io_output_cmd_payload_last                      ), //o
    .io_output_cmd_payload_fragment_source       (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_source[1:0]      ), //o
    .io_output_cmd_payload_fragment_opcode       (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_opcode           ), //o
    .io_output_cmd_payload_fragment_address      (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_address[31:0]    ), //o
    .io_output_cmd_payload_fragment_length       (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_length[11:0]     ), //o
    .io_output_cmd_payload_fragment_data         (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_data[127:0]      ), //o
    .io_output_cmd_payload_fragment_mask         (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_mask[15:0]       ), //o
    .io_output_cmd_payload_fragment_context      (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_context[13:0]    ), //o
    .io_output_rsp_valid                         (interconnect_write_aggregated_rsp_valid                                               ), //i
    .io_output_rsp_ready                         (interconnect_write_aggregated_arbiter_io_output_rsp_ready                             ), //o
    .io_output_rsp_payload_last                  (interconnect_write_aggregated_rsp_payload_last                                        ), //i
    .io_output_rsp_payload_fragment_source       (interconnect_write_aggregated_rsp_payload_fragment_source[1:0]                        ), //i
    .io_output_rsp_payload_fragment_opcode       (interconnect_write_aggregated_rsp_payload_fragment_opcode                             ), //i
    .io_output_rsp_payload_fragment_context      (interconnect_write_aggregated_rsp_payload_fragment_context[13:0]                      ), //i
    .clk                                         (clk                                                                                   ), //i
    .reset                                       (reset                                                                                 )  //i
  );
  dma_socRuby_BmbSourceRemover readLogic_sourceRemover (
    .io_input_cmd_valid                        (readLogic_resized_cmd_valid                                           ), //i
    .io_input_cmd_ready                        (readLogic_sourceRemover_io_input_cmd_ready                            ), //o
    .io_input_cmd_payload_last                 (readLogic_resized_cmd_payload_last                                    ), //i
    .io_input_cmd_payload_fragment_source      (readLogic_resized_cmd_payload_fragment_source[1:0]                    ), //i
    .io_input_cmd_payload_fragment_opcode      (readLogic_resized_cmd_payload_fragment_opcode                         ), //i
    .io_input_cmd_payload_fragment_address     (readLogic_resized_cmd_payload_fragment_address[31:0]                  ), //i
    .io_input_cmd_payload_fragment_length      (readLogic_resized_cmd_payload_fragment_length[11:0]                   ), //i
    .io_input_cmd_payload_fragment_context     (readLogic_resized_cmd_payload_fragment_context[21:0]                  ), //i
    .io_input_rsp_valid                        (readLogic_sourceRemover_io_input_rsp_valid                            ), //o
    .io_input_rsp_ready                        (readLogic_resized_rsp_ready                                           ), //i
    .io_input_rsp_payload_last                 (readLogic_sourceRemover_io_input_rsp_payload_last                     ), //o
    .io_input_rsp_payload_fragment_source      (readLogic_sourceRemover_io_input_rsp_payload_fragment_source[1:0]     ), //o
    .io_input_rsp_payload_fragment_opcode      (readLogic_sourceRemover_io_input_rsp_payload_fragment_opcode          ), //o
    .io_input_rsp_payload_fragment_data        (readLogic_sourceRemover_io_input_rsp_payload_fragment_data[127:0]     ), //o
    .io_input_rsp_payload_fragment_context     (readLogic_sourceRemover_io_input_rsp_payload_fragment_context[21:0]   ), //o
    .io_output_cmd_valid                       (readLogic_sourceRemover_io_output_cmd_valid                           ), //o
    .io_output_cmd_ready                       (readLogic_bridge_io_input_cmd_ready                                   ), //i
    .io_output_cmd_payload_last                (readLogic_sourceRemover_io_output_cmd_payload_last                    ), //o
    .io_output_cmd_payload_fragment_opcode     (readLogic_sourceRemover_io_output_cmd_payload_fragment_opcode         ), //o
    .io_output_cmd_payload_fragment_address    (readLogic_sourceRemover_io_output_cmd_payload_fragment_address[31:0]  ), //o
    .io_output_cmd_payload_fragment_length     (readLogic_sourceRemover_io_output_cmd_payload_fragment_length[11:0]   ), //o
    .io_output_cmd_payload_fragment_context    (readLogic_sourceRemover_io_output_cmd_payload_fragment_context[23:0]  ), //o
    .io_output_rsp_valid                       (readLogic_bridge_io_input_rsp_valid                                   ), //i
    .io_output_rsp_ready                       (readLogic_sourceRemover_io_output_rsp_ready                           ), //o
    .io_output_rsp_payload_last                (readLogic_bridge_io_input_rsp_payload_last                            ), //i
    .io_output_rsp_payload_fragment_opcode     (readLogic_bridge_io_input_rsp_payload_fragment_opcode                 ), //i
    .io_output_rsp_payload_fragment_data       (readLogic_bridge_io_input_rsp_payload_fragment_data[127:0]            ), //i
    .io_output_rsp_payload_fragment_context    (readLogic_bridge_io_input_rsp_payload_fragment_context[23:0]          )  //i
  );
  dma_socRuby_BmbToAxi4ReadOnlyBridge readLogic_bridge (
    .io_input_cmd_valid                       (readLogic_sourceRemover_io_output_cmd_valid                           ), //i
    .io_input_cmd_ready                       (readLogic_bridge_io_input_cmd_ready                                   ), //o
    .io_input_cmd_payload_last                (readLogic_sourceRemover_io_output_cmd_payload_last                    ), //i
    .io_input_cmd_payload_fragment_opcode     (readLogic_sourceRemover_io_output_cmd_payload_fragment_opcode         ), //i
    .io_input_cmd_payload_fragment_address    (readLogic_sourceRemover_io_output_cmd_payload_fragment_address[31:0]  ), //i
    .io_input_cmd_payload_fragment_length     (readLogic_sourceRemover_io_output_cmd_payload_fragment_length[11:0]   ), //i
    .io_input_cmd_payload_fragment_context    (readLogic_sourceRemover_io_output_cmd_payload_fragment_context[23:0]  ), //i
    .io_input_rsp_valid                       (readLogic_bridge_io_input_rsp_valid                                   ), //o
    .io_input_rsp_ready                       (readLogic_sourceRemover_io_output_rsp_ready                           ), //i
    .io_input_rsp_payload_last                (readLogic_bridge_io_input_rsp_payload_last                            ), //o
    .io_input_rsp_payload_fragment_opcode     (readLogic_bridge_io_input_rsp_payload_fragment_opcode                 ), //o
    .io_input_rsp_payload_fragment_data       (readLogic_bridge_io_input_rsp_payload_fragment_data[127:0]            ), //o
    .io_input_rsp_payload_fragment_context    (readLogic_bridge_io_input_rsp_payload_fragment_context[23:0]          ), //o
    .io_output_ar_valid                       (readLogic_bridge_io_output_ar_valid                                   ), //o
    .io_output_ar_ready                       (readLogic_adapter_ar_ready                                            ), //i
    .io_output_ar_payload_addr                (readLogic_bridge_io_output_ar_payload_addr[31:0]                      ), //o
    .io_output_ar_payload_len                 (readLogic_bridge_io_output_ar_payload_len[7:0]                        ), //o
    .io_output_ar_payload_size                (readLogic_bridge_io_output_ar_payload_size[2:0]                       ), //o
    .io_output_ar_payload_cache               (readLogic_bridge_io_output_ar_payload_cache[3:0]                      ), //o
    .io_output_ar_payload_prot                (readLogic_bridge_io_output_ar_payload_prot[2:0]                       ), //o
    .io_output_r_valid                        (readLogic_adapter_r_valid                                             ), //i
    .io_output_r_ready                        (readLogic_bridge_io_output_r_ready                                    ), //o
    .io_output_r_payload_data                 (readLogic_adapter_r_payload_data[127:0]                               ), //i
    .io_output_r_payload_resp                 (readLogic_adapter_r_payload_resp[1:0]                                 ), //i
    .io_output_r_payload_last                 (readLogic_adapter_r_payload_last                                      ), //i
    .clk                                      (clk                                                                   ), //i
    .reset                                    (reset                                                                 )  //i
  );
  dma_socRuby_StreamFifo_3 readLogic_beforeQueue_fifo (
    .io_push_valid           (readLogic_beforeQueue_valid                            ), //i
    .io_push_ready           (readLogic_beforeQueue_fifo_io_push_ready               ), //o
    .io_push_payload_data    (readLogic_beforeQueue_payload_data[127:0]              ), //i
    .io_push_payload_resp    (readLogic_beforeQueue_payload_resp[1:0]                ), //i
    .io_push_payload_last    (readLogic_beforeQueue_payload_last                     ), //i
    .io_pop_valid            (readLogic_beforeQueue_fifo_io_pop_valid                ), //o
    .io_pop_ready            (_zz_6                                                  ), //i
    .io_pop_payload_data     (readLogic_beforeQueue_fifo_io_pop_payload_data[127:0]  ), //o
    .io_pop_payload_resp     (readLogic_beforeQueue_fifo_io_pop_payload_resp[1:0]    ), //o
    .io_pop_payload_last     (readLogic_beforeQueue_fifo_io_pop_payload_last         ), //o
    .io_flush                (_zz_7                                                  ), //i
    .io_occupancy            (readLogic_beforeQueue_fifo_io_occupancy[8:0]           ), //o
    .io_availability         (readLogic_beforeQueue_fifo_io_availability[8:0]        ), //o
    .clk                     (clk                                                    ), //i
    .reset                   (reset                                                  )  //i
  );
  dma_socRuby_BmbSourceRemover_1 writeLogic_sourceRemover (
    .io_input_cmd_valid                        (writeLogic_resized_cmd_valid                                           ), //i
    .io_input_cmd_ready                        (writeLogic_sourceRemover_io_input_cmd_ready                            ), //o
    .io_input_cmd_payload_last                 (writeLogic_resized_cmd_payload_last                                    ), //i
    .io_input_cmd_payload_fragment_source      (writeLogic_resized_cmd_payload_fragment_source[1:0]                    ), //i
    .io_input_cmd_payload_fragment_opcode      (writeLogic_resized_cmd_payload_fragment_opcode                         ), //i
    .io_input_cmd_payload_fragment_address     (writeLogic_resized_cmd_payload_fragment_address[31:0]                  ), //i
    .io_input_cmd_payload_fragment_length      (writeLogic_resized_cmd_payload_fragment_length[11:0]                   ), //i
    .io_input_cmd_payload_fragment_data        (writeLogic_resized_cmd_payload_fragment_data[127:0]                    ), //i
    .io_input_cmd_payload_fragment_mask        (writeLogic_resized_cmd_payload_fragment_mask[15:0]                     ), //i
    .io_input_cmd_payload_fragment_context     (writeLogic_resized_cmd_payload_fragment_context[13:0]                  ), //i
    .io_input_rsp_valid                        (writeLogic_sourceRemover_io_input_rsp_valid                            ), //o
    .io_input_rsp_ready                        (writeLogic_resized_rsp_ready                                           ), //i
    .io_input_rsp_payload_last                 (writeLogic_sourceRemover_io_input_rsp_payload_last                     ), //o
    .io_input_rsp_payload_fragment_source      (writeLogic_sourceRemover_io_input_rsp_payload_fragment_source[1:0]     ), //o
    .io_input_rsp_payload_fragment_opcode      (writeLogic_sourceRemover_io_input_rsp_payload_fragment_opcode          ), //o
    .io_input_rsp_payload_fragment_context     (writeLogic_sourceRemover_io_input_rsp_payload_fragment_context[13:0]   ), //o
    .io_output_cmd_valid                       (writeLogic_sourceRemover_io_output_cmd_valid                           ), //o
    .io_output_cmd_ready                       (writeLogic_retainer_io_input_cmd_ready                                 ), //i
    .io_output_cmd_payload_last                (writeLogic_sourceRemover_io_output_cmd_payload_last                    ), //o
    .io_output_cmd_payload_fragment_opcode     (writeLogic_sourceRemover_io_output_cmd_payload_fragment_opcode         ), //o
    .io_output_cmd_payload_fragment_address    (writeLogic_sourceRemover_io_output_cmd_payload_fragment_address[31:0]  ), //o
    .io_output_cmd_payload_fragment_length     (writeLogic_sourceRemover_io_output_cmd_payload_fragment_length[11:0]   ), //o
    .io_output_cmd_payload_fragment_data       (writeLogic_sourceRemover_io_output_cmd_payload_fragment_data[127:0]    ), //o
    .io_output_cmd_payload_fragment_mask       (writeLogic_sourceRemover_io_output_cmd_payload_fragment_mask[15:0]     ), //o
    .io_output_cmd_payload_fragment_context    (writeLogic_sourceRemover_io_output_cmd_payload_fragment_context[15:0]  ), //o
    .io_output_rsp_valid                       (writeLogic_retainer_io_input_rsp_valid                                 ), //i
    .io_output_rsp_ready                       (writeLogic_sourceRemover_io_output_rsp_ready                           ), //o
    .io_output_rsp_payload_last                (writeLogic_retainer_io_input_rsp_payload_last                          ), //i
    .io_output_rsp_payload_fragment_opcode     (writeLogic_retainer_io_input_rsp_payload_fragment_opcode               ), //i
    .io_output_rsp_payload_fragment_context    (writeLogic_retainer_io_input_rsp_payload_fragment_context[15:0]        )  //i
  );
  dma_socRuby_BmbWriteRetainer writeLogic_retainer (
    .io_input_cmd_valid                        (writeLogic_sourceRemover_io_output_cmd_valid                           ), //i
    .io_input_cmd_ready                        (writeLogic_retainer_io_input_cmd_ready                                 ), //o
    .io_input_cmd_payload_last                 (writeLogic_sourceRemover_io_output_cmd_payload_last                    ), //i
    .io_input_cmd_payload_fragment_opcode      (writeLogic_sourceRemover_io_output_cmd_payload_fragment_opcode         ), //i
    .io_input_cmd_payload_fragment_address     (writeLogic_sourceRemover_io_output_cmd_payload_fragment_address[31:0]  ), //i
    .io_input_cmd_payload_fragment_length      (writeLogic_sourceRemover_io_output_cmd_payload_fragment_length[11:0]   ), //i
    .io_input_cmd_payload_fragment_data        (writeLogic_sourceRemover_io_output_cmd_payload_fragment_data[127:0]    ), //i
    .io_input_cmd_payload_fragment_mask        (writeLogic_sourceRemover_io_output_cmd_payload_fragment_mask[15:0]     ), //i
    .io_input_cmd_payload_fragment_context     (writeLogic_sourceRemover_io_output_cmd_payload_fragment_context[15:0]  ), //i
    .io_input_rsp_valid                        (writeLogic_retainer_io_input_rsp_valid                                 ), //o
    .io_input_rsp_ready                        (writeLogic_sourceRemover_io_output_rsp_ready                           ), //i
    .io_input_rsp_payload_last                 (writeLogic_retainer_io_input_rsp_payload_last                          ), //o
    .io_input_rsp_payload_fragment_opcode      (writeLogic_retainer_io_input_rsp_payload_fragment_opcode               ), //o
    .io_input_rsp_payload_fragment_context     (writeLogic_retainer_io_input_rsp_payload_fragment_context[15:0]        ), //o
    .io_output_cmd_valid                       (writeLogic_retainer_io_output_cmd_valid                                ), //o
    .io_output_cmd_ready                       (writeLogic_bridge_io_input_cmd_ready                                   ), //i
    .io_output_cmd_payload_last                (writeLogic_retainer_io_output_cmd_payload_last                         ), //o
    .io_output_cmd_payload_fragment_opcode     (writeLogic_retainer_io_output_cmd_payload_fragment_opcode              ), //o
    .io_output_cmd_payload_fragment_address    (writeLogic_retainer_io_output_cmd_payload_fragment_address[31:0]       ), //o
    .io_output_cmd_payload_fragment_length     (writeLogic_retainer_io_output_cmd_payload_fragment_length[11:0]        ), //o
    .io_output_cmd_payload_fragment_data       (writeLogic_retainer_io_output_cmd_payload_fragment_data[127:0]         ), //o
    .io_output_cmd_payload_fragment_mask       (writeLogic_retainer_io_output_cmd_payload_fragment_mask[15:0]          ), //o
    .io_output_cmd_payload_fragment_context    (writeLogic_retainer_io_output_cmd_payload_fragment_context[15:0]       ), //o
    .io_output_rsp_valid                       (writeLogic_bridge_io_input_rsp_valid                                   ), //i
    .io_output_rsp_ready                       (writeLogic_retainer_io_output_rsp_ready                                ), //o
    .io_output_rsp_payload_last                (writeLogic_bridge_io_input_rsp_payload_last                            ), //i
    .io_output_rsp_payload_fragment_opcode     (writeLogic_bridge_io_input_rsp_payload_fragment_opcode                 ), //i
    .io_output_rsp_payload_fragment_context    (writeLogic_bridge_io_input_rsp_payload_fragment_context[15:0]          ), //i
    .clk                                       (clk                                                                    ), //i
    .reset                                     (reset                                                                  )  //i
  );
  dma_socRuby_BmbToAxi4WriteOnlyBridge writeLogic_bridge (
    .io_input_cmd_valid                       (writeLogic_retainer_io_output_cmd_valid                           ), //i
    .io_input_cmd_ready                       (writeLogic_bridge_io_input_cmd_ready                              ), //o
    .io_input_cmd_payload_last                (writeLogic_retainer_io_output_cmd_payload_last                    ), //i
    .io_input_cmd_payload_fragment_opcode     (writeLogic_retainer_io_output_cmd_payload_fragment_opcode         ), //i
    .io_input_cmd_payload_fragment_address    (writeLogic_retainer_io_output_cmd_payload_fragment_address[31:0]  ), //i
    .io_input_cmd_payload_fragment_length     (writeLogic_retainer_io_output_cmd_payload_fragment_length[11:0]   ), //i
    .io_input_cmd_payload_fragment_data       (writeLogic_retainer_io_output_cmd_payload_fragment_data[127:0]    ), //i
    .io_input_cmd_payload_fragment_mask       (writeLogic_retainer_io_output_cmd_payload_fragment_mask[15:0]     ), //i
    .io_input_cmd_payload_fragment_context    (writeLogic_retainer_io_output_cmd_payload_fragment_context[15:0]  ), //i
    .io_input_rsp_valid                       (writeLogic_bridge_io_input_rsp_valid                              ), //o
    .io_input_rsp_ready                       (writeLogic_retainer_io_output_rsp_ready                           ), //i
    .io_input_rsp_payload_last                (writeLogic_bridge_io_input_rsp_payload_last                       ), //o
    .io_input_rsp_payload_fragment_opcode     (writeLogic_bridge_io_input_rsp_payload_fragment_opcode            ), //o
    .io_input_rsp_payload_fragment_context    (writeLogic_bridge_io_input_rsp_payload_fragment_context[15:0]     ), //o
    .io_output_aw_valid                       (writeLogic_bridge_io_output_aw_valid                              ), //o
    .io_output_aw_ready                       (writeLogic_adapter_aw_ready                                       ), //i
    .io_output_aw_payload_addr                (writeLogic_bridge_io_output_aw_payload_addr[31:0]                 ), //o
    .io_output_aw_payload_len                 (writeLogic_bridge_io_output_aw_payload_len[7:0]                   ), //o
    .io_output_aw_payload_size                (writeLogic_bridge_io_output_aw_payload_size[2:0]                  ), //o
    .io_output_aw_payload_cache               (writeLogic_bridge_io_output_aw_payload_cache[3:0]                 ), //o
    .io_output_aw_payload_prot                (writeLogic_bridge_io_output_aw_payload_prot[2:0]                  ), //o
    .io_output_w_valid                        (writeLogic_bridge_io_output_w_valid                               ), //o
    .io_output_w_ready                        (writeLogic_adapter_w_ready                                        ), //i
    .io_output_w_payload_data                 (writeLogic_bridge_io_output_w_payload_data[127:0]                 ), //o
    .io_output_w_payload_strb                 (writeLogic_bridge_io_output_w_payload_strb[15:0]                  ), //o
    .io_output_w_payload_last                 (writeLogic_bridge_io_output_w_payload_last                        ), //o
    .io_output_b_valid                        (writeLogic_adapter_b_valid                                        ), //i
    .io_output_b_ready                        (writeLogic_bridge_io_output_b_ready                               ), //o
    .io_output_b_payload_resp                 (writeLogic_adapter_b_payload_resp[1:0]                            ), //i
    .clk                                      (clk                                                               ), //i
    .reset                                    (reset                                                             )  //i
  );
  dma_socRuby_BsbUpSizerDense inputsAdapter_0_upsizer_logic (
    .io_input_valid            (dat64_i_ch0_tvalid                                           ), //i
    .io_input_ready            (inputsAdapter_0_upsizer_logic_io_input_ready                 ), //o
    .io_input_payload_data     (dat64_i_ch0_tdata[63:0]                                      ), //i
    .io_input_payload_mask     (dat64_i_ch0_tkeep[7:0]                                       ), //i
    .io_input_payload_sink     (dat64_i_ch0_tdest[3:0]                                       ), //i
    .io_input_payload_last     (dat64_i_ch0_tlast                                            ), //i
    .io_output_valid           (inputsAdapter_0_upsizer_logic_io_output_valid                ), //o
    .io_output_ready           (inputsAdapter_0_crossclock_fifo_io_push_ready                ), //i
    .io_output_payload_data    (inputsAdapter_0_upsizer_logic_io_output_payload_data[127:0]  ), //o
    .io_output_payload_mask    (inputsAdapter_0_upsizer_logic_io_output_payload_mask[15:0]   ), //o
    .io_output_payload_sink    (inputsAdapter_0_upsizer_logic_io_output_payload_sink[3:0]    ), //o
    .io_output_payload_last    (inputsAdapter_0_upsizer_logic_io_output_payload_last         ), //o
    .dat64_i_ch0_clk           (dat64_i_ch0_clk                                              ), //i
    .dat64_i_ch0_reset         (dat64_i_ch0_reset                                            )  //i
  );
  dma_socRuby_StreamFifoCC inputsAdapter_0_crossclock_fifo (
    .io_push_valid           (inputsAdapter_0_upsizer_logic_io_output_valid                ), //i
    .io_push_ready           (inputsAdapter_0_crossclock_fifo_io_push_ready                ), //o
    .io_push_payload_data    (inputsAdapter_0_upsizer_logic_io_output_payload_data[127:0]  ), //i
    .io_push_payload_mask    (inputsAdapter_0_upsizer_logic_io_output_payload_mask[15:0]   ), //i
    .io_push_payload_sink    (inputsAdapter_0_upsizer_logic_io_output_payload_sink[3:0]    ), //i
    .io_push_payload_last    (inputsAdapter_0_upsizer_logic_io_output_payload_last         ), //i
    .io_pop_valid            (inputsAdapter_0_crossclock_fifo_io_pop_valid                 ), //o
    .io_pop_ready            (_zz_8                                                        ), //i
    .io_pop_payload_data     (inputsAdapter_0_crossclock_fifo_io_pop_payload_data[127:0]   ), //o
    .io_pop_payload_mask     (inputsAdapter_0_crossclock_fifo_io_pop_payload_mask[15:0]    ), //o
    .io_pop_payload_sink     (inputsAdapter_0_crossclock_fifo_io_pop_payload_sink[3:0]     ), //o
    .io_pop_payload_last     (inputsAdapter_0_crossclock_fifo_io_pop_payload_last          ), //o
    .io_pushOccupancy        (inputsAdapter_0_crossclock_fifo_io_pushOccupancy[4:0]        ), //o
    .io_popOccupancy         (inputsAdapter_0_crossclock_fifo_io_popOccupancy[4:0]         ), //o
    .dat64_i_ch0_clk         (dat64_i_ch0_clk                                              ), //i
    .dat64_i_ch0_reset       (dat64_i_ch0_reset                                            ), //i
    .clk                     (clk                                                          ), //i
    .reset                   (reset                                                        )  //i
  );
  dma_socRuby_BsbUpSizerDense_1 inputsAdapter_1_upsizer_logic (
    .io_input_valid            (dat32_i_ch2_tvalid                                           ), //i
    .io_input_ready            (inputsAdapter_1_upsizer_logic_io_input_ready                 ), //o
    .io_input_payload_data     (dat32_i_ch2_tdata[31:0]                                      ), //i
    .io_input_payload_mask     (dat32_i_ch2_tkeep[3:0]                                       ), //i
    .io_input_payload_sink     (dat32_i_ch2_tdest[3:0]                                       ), //i
    .io_input_payload_last     (dat32_i_ch2_tlast                                            ), //i
    .io_output_valid           (inputsAdapter_1_upsizer_logic_io_output_valid                ), //o
    .io_output_ready           (inputsAdapter_1_crossclock_fifo_io_push_ready                ), //i
    .io_output_payload_data    (inputsAdapter_1_upsizer_logic_io_output_payload_data[127:0]  ), //o
    .io_output_payload_mask    (inputsAdapter_1_upsizer_logic_io_output_payload_mask[15:0]   ), //o
    .io_output_payload_sink    (inputsAdapter_1_upsizer_logic_io_output_payload_sink[3:0]    ), //o
    .io_output_payload_last    (inputsAdapter_1_upsizer_logic_io_output_payload_last         ), //o
    .dat32_i_ch2_clk           (dat32_i_ch2_clk                                              ), //i
    .dat32_i_ch2_reset         (dat32_i_ch2_reset                                            )  //i
  );
  dma_socRuby_StreamFifoCC_1 inputsAdapter_1_crossclock_fifo (
    .io_push_valid           (inputsAdapter_1_upsizer_logic_io_output_valid                ), //i
    .io_push_ready           (inputsAdapter_1_crossclock_fifo_io_push_ready                ), //o
    .io_push_payload_data    (inputsAdapter_1_upsizer_logic_io_output_payload_data[127:0]  ), //i
    .io_push_payload_mask    (inputsAdapter_1_upsizer_logic_io_output_payload_mask[15:0]   ), //i
    .io_push_payload_sink    (inputsAdapter_1_upsizer_logic_io_output_payload_sink[3:0]    ), //i
    .io_push_payload_last    (inputsAdapter_1_upsizer_logic_io_output_payload_last         ), //i
    .io_pop_valid            (inputsAdapter_1_crossclock_fifo_io_pop_valid                 ), //o
    .io_pop_ready            (_zz_9                                                        ), //i
    .io_pop_payload_data     (inputsAdapter_1_crossclock_fifo_io_pop_payload_data[127:0]   ), //o
    .io_pop_payload_mask     (inputsAdapter_1_crossclock_fifo_io_pop_payload_mask[15:0]    ), //o
    .io_pop_payload_sink     (inputsAdapter_1_crossclock_fifo_io_pop_payload_sink[3:0]     ), //o
    .io_pop_payload_last     (inputsAdapter_1_crossclock_fifo_io_pop_payload_last          ), //o
    .io_pushOccupancy        (inputsAdapter_1_crossclock_fifo_io_pushOccupancy[4:0]        ), //o
    .io_popOccupancy         (inputsAdapter_1_crossclock_fifo_io_popOccupancy[4:0]         ), //o
    .dat32_i_ch2_clk         (dat32_i_ch2_clk                                              ), //i
    .dat32_i_ch2_reset       (dat32_i_ch2_reset                                            ), //i
    .clk                     (clk                                                          ), //i
    .reset                   (reset                                                        )  //i
  );
  dma_socRuby_StreamFifoCC_2 outputsAdapter_0_crossclock_fifo (
    .io_push_valid           (outputsAdapter_0_ptr_valid                                   ), //i
    .io_push_ready           (outputsAdapter_0_crossclock_fifo_io_push_ready               ), //o
    .io_push_payload_data    (outputsAdapter_0_ptr_payload_data[127:0]                     ), //i
    .io_push_payload_mask    (outputsAdapter_0_ptr_payload_mask[15:0]                      ), //i
    .io_push_payload_sink    (outputsAdapter_0_ptr_payload_sink[3:0]                       ), //i
    .io_push_payload_last    (outputsAdapter_0_ptr_payload_last                            ), //i
    .io_pop_valid            (outputsAdapter_0_crossclock_fifo_io_pop_valid                ), //o
    .io_pop_ready            (outputsAdapter_0_sparseDownsizer_logic_io_input_ready        ), //i
    .io_pop_payload_data     (outputsAdapter_0_crossclock_fifo_io_pop_payload_data[127:0]  ), //o
    .io_pop_payload_mask     (outputsAdapter_0_crossclock_fifo_io_pop_payload_mask[15:0]   ), //o
    .io_pop_payload_sink     (outputsAdapter_0_crossclock_fifo_io_pop_payload_sink[3:0]    ), //o
    .io_pop_payload_last     (outputsAdapter_0_crossclock_fifo_io_pop_payload_last         ), //o
    .io_pushOccupancy        (outputsAdapter_0_crossclock_fifo_io_pushOccupancy[4:0]       ), //o
    .io_popOccupancy         (outputsAdapter_0_crossclock_fifo_io_popOccupancy[4:0]        ), //o
    .clk                     (clk                                                          ), //i
    .reset                   (reset                                                        ), //i
    .dat64_o_ch1_clk         (dat64_o_ch1_clk                                              ), //i
    .dat64_o_ch1_reset       (dat64_o_ch1_reset                                            )  //i
  );
  dma_socRuby_BsbDownSizerSparse outputsAdapter_0_sparseDownsizer_logic (
    .io_input_valid            (outputsAdapter_0_crossclock_fifo_io_pop_valid                        ), //i
    .io_input_ready            (outputsAdapter_0_sparseDownsizer_logic_io_input_ready                ), //o
    .io_input_payload_data     (outputsAdapter_0_crossclock_fifo_io_pop_payload_data[127:0]          ), //i
    .io_input_payload_mask     (outputsAdapter_0_crossclock_fifo_io_pop_payload_mask[15:0]           ), //i
    .io_input_payload_sink     (outputsAdapter_0_crossclock_fifo_io_pop_payload_sink[3:0]            ), //i
    .io_input_payload_last     (outputsAdapter_0_crossclock_fifo_io_pop_payload_last                 ), //i
    .io_output_valid           (outputsAdapter_0_sparseDownsizer_logic_io_output_valid               ), //o
    .io_output_ready           (dat64_o_ch1_tready                                                   ), //i
    .io_output_payload_data    (outputsAdapter_0_sparseDownsizer_logic_io_output_payload_data[63:0]  ), //o
    .io_output_payload_mask    (outputsAdapter_0_sparseDownsizer_logic_io_output_payload_mask[7:0]   ), //o
    .io_output_payload_sink    (outputsAdapter_0_sparseDownsizer_logic_io_output_payload_sink[3:0]   ), //o
    .io_output_payload_last    (outputsAdapter_0_sparseDownsizer_logic_io_output_payload_last        ), //o
    .dat64_o_ch1_clk           (dat64_o_ch1_clk                                                      ), //i
    .dat64_o_ch1_reset         (dat64_o_ch1_reset                                                    )  //i
  );
  dma_socRuby_StreamFifoCC_3 outputsAdapter_1_crossclock_fifo (
    .io_push_valid           (outputsAdapter_1_ptr_valid                                   ), //i
    .io_push_ready           (outputsAdapter_1_crossclock_fifo_io_push_ready               ), //o
    .io_push_payload_data    (outputsAdapter_1_ptr_payload_data[127:0]                     ), //i
    .io_push_payload_mask    (outputsAdapter_1_ptr_payload_mask[15:0]                      ), //i
    .io_push_payload_sink    (outputsAdapter_1_ptr_payload_sink[3:0]                       ), //i
    .io_push_payload_last    (outputsAdapter_1_ptr_payload_last                            ), //i
    .io_pop_valid            (outputsAdapter_1_crossclock_fifo_io_pop_valid                ), //o
    .io_pop_ready            (outputsAdapter_1_sparseDownsizer_logic_io_input_ready        ), //i
    .io_pop_payload_data     (outputsAdapter_1_crossclock_fifo_io_pop_payload_data[127:0]  ), //o
    .io_pop_payload_mask     (outputsAdapter_1_crossclock_fifo_io_pop_payload_mask[15:0]   ), //o
    .io_pop_payload_sink     (outputsAdapter_1_crossclock_fifo_io_pop_payload_sink[3:0]    ), //o
    .io_pop_payload_last     (outputsAdapter_1_crossclock_fifo_io_pop_payload_last         ), //o
    .io_pushOccupancy        (outputsAdapter_1_crossclock_fifo_io_pushOccupancy[4:0]       ), //o
    .io_popOccupancy         (outputsAdapter_1_crossclock_fifo_io_popOccupancy[4:0]        ), //o
    .clk                     (clk                                                          ), //i
    .reset                   (reset                                                        ), //i
    .dat32_o_ch3_clk         (dat32_o_ch3_clk                                              ), //i
    .dat32_o_ch3_reset       (dat32_o_ch3_reset                                            )  //i
  );
  dma_socRuby_BsbDownSizerSparse_1 outputsAdapter_1_sparseDownsizer_logic (
    .io_input_valid            (outputsAdapter_1_crossclock_fifo_io_pop_valid                        ), //i
    .io_input_ready            (outputsAdapter_1_sparseDownsizer_logic_io_input_ready                ), //o
    .io_input_payload_data     (outputsAdapter_1_crossclock_fifo_io_pop_payload_data[127:0]          ), //i
    .io_input_payload_mask     (outputsAdapter_1_crossclock_fifo_io_pop_payload_mask[15:0]           ), //i
    .io_input_payload_sink     (outputsAdapter_1_crossclock_fifo_io_pop_payload_sink[3:0]            ), //i
    .io_input_payload_last     (outputsAdapter_1_crossclock_fifo_io_pop_payload_last                 ), //i
    .io_output_valid           (outputsAdapter_1_sparseDownsizer_logic_io_output_valid               ), //o
    .io_output_ready           (dat32_o_ch3_tready                                                   ), //i
    .io_output_payload_data    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_data[31:0]  ), //o
    .io_output_payload_mask    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_mask[3:0]   ), //o
    .io_output_payload_sink    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_sink[3:0]   ), //o
    .io_output_payload_last    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_last        ), //o
    .dat32_o_ch3_clk           (dat32_o_ch3_clk                                                      ), //i
    .dat32_o_ch3_reset         (dat32_o_ch3_reset                                                    )  //i
  );
  assign ctrl_PREADY = withCtrlCc_apbCc_io_input_PREADY;
  assign ctrl_PRDATA = withCtrlCc_apbCc_io_input_PRDATA;
  assign ctrl_PSLVERROR = withCtrlCc_apbCc_io_input_PSLVERROR;
  assign ctrl_interrupts = core_io_interrupts_buffercc_io_dataOut;
  assign core_io_write_cmd_s2mPipe_valid = (core_io_write_cmd_valid || core_io_write_cmd_s2mPipe_rValid);
  assign _zz_3 = (! core_io_write_cmd_s2mPipe_rValid);
  assign core_io_write_cmd_s2mPipe_payload_last = (core_io_write_cmd_s2mPipe_rValid ? core_io_write_cmd_s2mPipe_rData_last : core_io_write_cmd_payload_last);
  assign core_io_write_cmd_s2mPipe_payload_fragment_source = (core_io_write_cmd_s2mPipe_rValid ? core_io_write_cmd_s2mPipe_rData_fragment_source : core_io_write_cmd_payload_fragment_source);
  assign core_io_write_cmd_s2mPipe_payload_fragment_opcode = (core_io_write_cmd_s2mPipe_rValid ? core_io_write_cmd_s2mPipe_rData_fragment_opcode : core_io_write_cmd_payload_fragment_opcode);
  assign core_io_write_cmd_s2mPipe_payload_fragment_address = (core_io_write_cmd_s2mPipe_rValid ? core_io_write_cmd_s2mPipe_rData_fragment_address : core_io_write_cmd_payload_fragment_address);
  assign core_io_write_cmd_s2mPipe_payload_fragment_length = (core_io_write_cmd_s2mPipe_rValid ? core_io_write_cmd_s2mPipe_rData_fragment_length : core_io_write_cmd_payload_fragment_length);
  assign core_io_write_cmd_s2mPipe_payload_fragment_data = (core_io_write_cmd_s2mPipe_rValid ? core_io_write_cmd_s2mPipe_rData_fragment_data : core_io_write_cmd_payload_fragment_data);
  assign core_io_write_cmd_s2mPipe_payload_fragment_mask = (core_io_write_cmd_s2mPipe_rValid ? core_io_write_cmd_s2mPipe_rData_fragment_mask : core_io_write_cmd_payload_fragment_mask);
  assign core_io_write_cmd_s2mPipe_payload_fragment_context = (core_io_write_cmd_s2mPipe_rValid ? core_io_write_cmd_s2mPipe_rData_fragment_context : core_io_write_cmd_payload_fragment_context);
  assign core_io_write_cmd_s2mPipe_ready = ((1'b1 && (! core_io_write_cmd_s2mPipe_m2sPipe_valid)) || core_io_write_cmd_s2mPipe_m2sPipe_ready);
  assign core_io_write_cmd_s2mPipe_m2sPipe_valid = core_io_write_cmd_s2mPipe_m2sPipe_rValid;
  assign core_io_write_cmd_s2mPipe_m2sPipe_payload_last = core_io_write_cmd_s2mPipe_m2sPipe_rData_last;
  assign core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_source = core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_source;
  assign core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_opcode = core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_opcode;
  assign core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_address = core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_address;
  assign core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_length = core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_length;
  assign core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_data = core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_data;
  assign core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_mask = core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_mask;
  assign core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_context = core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_context;
  assign core_io_write_cmd_s2mPipe_m2sPipe_ready = interconnect_write_aggregated_arbiter_io_inputs_1_cmd_ready;
  assign interconnect_read_aggregated_cmd_valid = interconnect_read_aggregated_arbiter_io_output_cmd_valid;
  assign interconnect_read_aggregated_rsp_ready = interconnect_read_aggregated_arbiter_io_output_rsp_ready;
  assign interconnect_read_aggregated_cmd_payload_last = interconnect_read_aggregated_arbiter_io_output_cmd_payload_last;
  assign interconnect_read_aggregated_cmd_payload_fragment_source = interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_source;
  assign interconnect_read_aggregated_cmd_payload_fragment_opcode = interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_opcode;
  assign interconnect_read_aggregated_cmd_payload_fragment_address = interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_address;
  assign interconnect_read_aggregated_cmd_payload_fragment_length = interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_length;
  assign interconnect_read_aggregated_cmd_payload_fragment_context = interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_context;
  assign interconnect_write_aggregated_cmd_valid = interconnect_write_aggregated_arbiter_io_output_cmd_valid;
  assign interconnect_write_aggregated_rsp_ready = interconnect_write_aggregated_arbiter_io_output_rsp_ready;
  assign interconnect_write_aggregated_cmd_payload_last = interconnect_write_aggregated_arbiter_io_output_cmd_payload_last;
  assign interconnect_write_aggregated_cmd_payload_fragment_source = interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_source;
  assign interconnect_write_aggregated_cmd_payload_fragment_opcode = interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_opcode;
  assign interconnect_write_aggregated_cmd_payload_fragment_address = interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_address;
  assign interconnect_write_aggregated_cmd_payload_fragment_length = interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_length;
  assign interconnect_write_aggregated_cmd_payload_fragment_data = interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_data;
  assign interconnect_write_aggregated_cmd_payload_fragment_mask = interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_mask;
  assign interconnect_write_aggregated_cmd_payload_fragment_context = interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_context;
  assign interconnect_read_aggregated_cmd_halfPipe_valid = interconnect_read_aggregated_cmd_halfPipe_regs_valid;
  assign interconnect_read_aggregated_cmd_halfPipe_payload_last = interconnect_read_aggregated_cmd_halfPipe_regs_payload_last;
  assign interconnect_read_aggregated_cmd_halfPipe_payload_fragment_source = interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_source;
  assign interconnect_read_aggregated_cmd_halfPipe_payload_fragment_opcode = interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_opcode;
  assign interconnect_read_aggregated_cmd_halfPipe_payload_fragment_address = interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_address;
  assign interconnect_read_aggregated_cmd_halfPipe_payload_fragment_length = interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_length;
  assign interconnect_read_aggregated_cmd_halfPipe_payload_fragment_context = interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_context;
  assign interconnect_read_aggregated_cmd_ready = interconnect_read_aggregated_cmd_halfPipe_regs_ready;
  assign interconnect_read_aggregated_cmd_halfPipe_ready = readLogic_resized_cmd_ready;
  assign readLogic_resized_cmd_valid = interconnect_read_aggregated_cmd_halfPipe_valid;
  assign readLogic_resized_cmd_payload_last = interconnect_read_aggregated_cmd_halfPipe_payload_last;
  assign readLogic_resized_cmd_payload_fragment_source = interconnect_read_aggregated_cmd_halfPipe_payload_fragment_source;
  assign readLogic_resized_cmd_payload_fragment_opcode = interconnect_read_aggregated_cmd_halfPipe_payload_fragment_opcode;
  assign readLogic_resized_cmd_payload_fragment_address = interconnect_read_aggregated_cmd_halfPipe_payload_fragment_address;
  assign readLogic_resized_cmd_payload_fragment_length = interconnect_read_aggregated_cmd_halfPipe_payload_fragment_length;
  assign readLogic_resized_cmd_payload_fragment_context = interconnect_read_aggregated_cmd_halfPipe_payload_fragment_context;
  assign interconnect_read_aggregated_rsp_valid = readLogic_resized_rsp_valid;
  assign readLogic_resized_rsp_ready = interconnect_read_aggregated_rsp_ready;
  assign interconnect_read_aggregated_rsp_payload_last = readLogic_resized_rsp_payload_last;
  assign interconnect_read_aggregated_rsp_payload_fragment_source = readLogic_resized_rsp_payload_fragment_source;
  assign interconnect_read_aggregated_rsp_payload_fragment_opcode = readLogic_resized_rsp_payload_fragment_opcode;
  assign interconnect_read_aggregated_rsp_payload_fragment_data = readLogic_resized_rsp_payload_fragment_data;
  assign interconnect_read_aggregated_rsp_payload_fragment_context = readLogic_resized_rsp_payload_fragment_context;
  assign readLogic_resized_cmd_ready = readLogic_sourceRemover_io_input_cmd_ready;
  assign readLogic_resized_rsp_valid = readLogic_sourceRemover_io_input_rsp_valid;
  assign readLogic_resized_rsp_payload_last = readLogic_sourceRemover_io_input_rsp_payload_last;
  assign readLogic_resized_rsp_payload_fragment_source = readLogic_sourceRemover_io_input_rsp_payload_fragment_source;
  assign readLogic_resized_rsp_payload_fragment_opcode = readLogic_sourceRemover_io_input_rsp_payload_fragment_opcode;
  assign readLogic_resized_rsp_payload_fragment_data = readLogic_sourceRemover_io_input_rsp_payload_fragment_data;
  assign readLogic_resized_rsp_payload_fragment_context = readLogic_sourceRemover_io_input_rsp_payload_fragment_context;
  assign readLogic_adapter_ar_valid = readLogic_bridge_io_output_ar_valid;
  assign readLogic_adapter_ar_payload_addr = readLogic_bridge_io_output_ar_payload_addr;
  assign _zz_1[3 : 0] = 4'b0000;
  assign readLogic_adapter_ar_payload_region = _zz_1;
  assign readLogic_adapter_ar_payload_len = readLogic_bridge_io_output_ar_payload_len;
  assign readLogic_adapter_ar_payload_size = readLogic_bridge_io_output_ar_payload_size;
  assign readLogic_adapter_ar_payload_burst = 2'b01;
  assign readLogic_adapter_ar_payload_lock = 1'b0;
  assign readLogic_adapter_ar_payload_cache = readLogic_bridge_io_output_ar_payload_cache;
  assign readLogic_adapter_ar_payload_qos = 4'b0000;
  assign readLogic_adapter_ar_payload_prot = readLogic_bridge_io_output_ar_payload_prot;
  assign readLogic_adapter_r_ready = readLogic_bridge_io_output_r_ready;
  assign readLogic_adapter_ar_halfPipe_valid = readLogic_adapter_ar_halfPipe_regs_valid;
  assign readLogic_adapter_ar_halfPipe_payload_addr = readLogic_adapter_ar_halfPipe_regs_payload_addr;
  assign readLogic_adapter_ar_halfPipe_payload_region = readLogic_adapter_ar_halfPipe_regs_payload_region;
  assign readLogic_adapter_ar_halfPipe_payload_len = readLogic_adapter_ar_halfPipe_regs_payload_len;
  assign readLogic_adapter_ar_halfPipe_payload_size = readLogic_adapter_ar_halfPipe_regs_payload_size;
  assign readLogic_adapter_ar_halfPipe_payload_burst = readLogic_adapter_ar_halfPipe_regs_payload_burst;
  assign readLogic_adapter_ar_halfPipe_payload_lock = readLogic_adapter_ar_halfPipe_regs_payload_lock;
  assign readLogic_adapter_ar_halfPipe_payload_cache = readLogic_adapter_ar_halfPipe_regs_payload_cache;
  assign readLogic_adapter_ar_halfPipe_payload_qos = readLogic_adapter_ar_halfPipe_regs_payload_qos;
  assign readLogic_adapter_ar_halfPipe_payload_prot = readLogic_adapter_ar_halfPipe_regs_payload_prot;
  assign readLogic_adapter_ar_ready = readLogic_adapter_ar_halfPipe_regs_ready;
  assign read_arvalid = readLogic_adapter_ar_halfPipe_valid;
  assign readLogic_adapter_ar_halfPipe_ready = read_arready;
  assign read_araddr = readLogic_adapter_ar_halfPipe_payload_addr;
  assign read_arregion = readLogic_adapter_ar_halfPipe_payload_region;
  assign read_arlen = readLogic_adapter_ar_halfPipe_payload_len;
  assign read_arsize = readLogic_adapter_ar_halfPipe_payload_size;
  assign read_arburst = readLogic_adapter_ar_halfPipe_payload_burst;
  assign read_arlock = readLogic_adapter_ar_halfPipe_payload_lock;
  assign read_arcache = readLogic_adapter_ar_halfPipe_payload_cache;
  assign read_arqos = readLogic_adapter_ar_halfPipe_payload_qos;
  assign read_arprot = readLogic_adapter_ar_halfPipe_payload_prot;
  assign read_r_s2mPipe_valid = (read_rvalid || read_r_s2mPipe_rValid);
  assign read_rready = (! read_r_s2mPipe_rValid);
  assign read_r_s2mPipe_payload_data = (read_r_s2mPipe_rValid ? read_r_s2mPipe_rData_data : read_rdata);
  assign read_r_s2mPipe_payload_resp = (read_r_s2mPipe_rValid ? read_r_s2mPipe_rData_resp : read_rresp);
  assign read_r_s2mPipe_payload_last = (read_r_s2mPipe_rValid ? read_r_s2mPipe_rData_last : read_rlast);
  assign read_r_s2mPipe_ready = ((1'b1 && (! readLogic_beforeQueue_valid)) || readLogic_beforeQueue_ready);
  assign readLogic_beforeQueue_valid = read_r_s2mPipe_m2sPipe_rValid;
  assign readLogic_beforeQueue_payload_data = read_r_s2mPipe_m2sPipe_rData_data;
  assign readLogic_beforeQueue_payload_resp = read_r_s2mPipe_m2sPipe_rData_resp;
  assign readLogic_beforeQueue_payload_last = read_r_s2mPipe_m2sPipe_rData_last;
  assign readLogic_beforeQueue_ready = readLogic_beforeQueue_fifo_io_push_ready;
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_valid = (readLogic_beforeQueue_fifo_io_pop_valid || readLogic_beforeQueue_fifo_io_pop_s2mPipe_rValid);
  assign _zz_6 = (! readLogic_beforeQueue_fifo_io_pop_s2mPipe_rValid);
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_payload_data = (readLogic_beforeQueue_fifo_io_pop_s2mPipe_rValid ? readLogic_beforeQueue_fifo_io_pop_s2mPipe_rData_data : readLogic_beforeQueue_fifo_io_pop_payload_data);
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_payload_resp = (readLogic_beforeQueue_fifo_io_pop_s2mPipe_rValid ? readLogic_beforeQueue_fifo_io_pop_s2mPipe_rData_resp : readLogic_beforeQueue_fifo_io_pop_payload_resp);
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_payload_last = (readLogic_beforeQueue_fifo_io_pop_s2mPipe_rValid ? readLogic_beforeQueue_fifo_io_pop_s2mPipe_rData_last : readLogic_beforeQueue_fifo_io_pop_payload_last);
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_ready = ((1'b1 && (! readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_valid)) || readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_ready);
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_valid = readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rValid;
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_payload_data = readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rData_data;
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_payload_resp = readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rData_resp;
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_payload_last = readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rData_last;
  assign readLogic_adapter_r_valid = readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_valid;
  assign readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_ready = readLogic_adapter_r_ready;
  assign readLogic_adapter_r_payload_data = readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_payload_data;
  assign readLogic_adapter_r_payload_resp = readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_payload_resp;
  assign readLogic_adapter_r_payload_last = readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_payload_last;
  assign interconnect_write_aggregated_cmd_ready = ((1'b1 && (! interconnect_write_aggregated_cmd_m2sPipe_valid)) || interconnect_write_aggregated_cmd_m2sPipe_ready);
  assign interconnect_write_aggregated_cmd_m2sPipe_valid = interconnect_write_aggregated_cmd_m2sPipe_rValid;
  assign interconnect_write_aggregated_cmd_m2sPipe_payload_last = interconnect_write_aggregated_cmd_m2sPipe_rData_last;
  assign interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_source = interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_source;
  assign interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_opcode = interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_opcode;
  assign interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_address = interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_address;
  assign interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_length = interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_length;
  assign interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_data = interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_data;
  assign interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_mask = interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_mask;
  assign interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_context = interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_context;
  assign interconnect_write_aggregated_cmd_m2sPipe_ready = writeLogic_resized_cmd_ready;
  assign writeLogic_resized_cmd_valid = interconnect_write_aggregated_cmd_m2sPipe_valid;
  assign writeLogic_resized_cmd_payload_last = interconnect_write_aggregated_cmd_m2sPipe_payload_last;
  assign writeLogic_resized_cmd_payload_fragment_source = interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_source;
  assign writeLogic_resized_cmd_payload_fragment_opcode = interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_opcode;
  assign writeLogic_resized_cmd_payload_fragment_address = interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_address;
  assign writeLogic_resized_cmd_payload_fragment_length = interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_length;
  assign writeLogic_resized_cmd_payload_fragment_data = interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_data;
  assign writeLogic_resized_cmd_payload_fragment_mask = interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_mask;
  assign writeLogic_resized_cmd_payload_fragment_context = interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_context;
  assign interconnect_write_aggregated_rsp_valid = writeLogic_resized_rsp_valid;
  assign writeLogic_resized_rsp_ready = interconnect_write_aggregated_rsp_ready;
  assign interconnect_write_aggregated_rsp_payload_last = writeLogic_resized_rsp_payload_last;
  assign interconnect_write_aggregated_rsp_payload_fragment_source = writeLogic_resized_rsp_payload_fragment_source;
  assign interconnect_write_aggregated_rsp_payload_fragment_opcode = writeLogic_resized_rsp_payload_fragment_opcode;
  assign interconnect_write_aggregated_rsp_payload_fragment_context = writeLogic_resized_rsp_payload_fragment_context;
  assign writeLogic_resized_cmd_ready = writeLogic_sourceRemover_io_input_cmd_ready;
  assign writeLogic_resized_rsp_valid = writeLogic_sourceRemover_io_input_rsp_valid;
  assign writeLogic_resized_rsp_payload_last = writeLogic_sourceRemover_io_input_rsp_payload_last;
  assign writeLogic_resized_rsp_payload_fragment_source = writeLogic_sourceRemover_io_input_rsp_payload_fragment_source;
  assign writeLogic_resized_rsp_payload_fragment_opcode = writeLogic_sourceRemover_io_input_rsp_payload_fragment_opcode;
  assign writeLogic_resized_rsp_payload_fragment_context = writeLogic_sourceRemover_io_input_rsp_payload_fragment_context;
  assign writeLogic_adapter_aw_valid = writeLogic_bridge_io_output_aw_valid;
  assign writeLogic_adapter_aw_payload_addr = writeLogic_bridge_io_output_aw_payload_addr;
  assign _zz_2[3 : 0] = 4'b0000;
  assign writeLogic_adapter_aw_payload_region = _zz_2;
  assign writeLogic_adapter_aw_payload_len = writeLogic_bridge_io_output_aw_payload_len;
  assign writeLogic_adapter_aw_payload_size = writeLogic_bridge_io_output_aw_payload_size;
  assign writeLogic_adapter_aw_payload_burst = 2'b01;
  assign writeLogic_adapter_aw_payload_lock = 1'b0;
  assign writeLogic_adapter_aw_payload_cache = writeLogic_bridge_io_output_aw_payload_cache;
  assign writeLogic_adapter_aw_payload_qos = 4'b0000;
  assign writeLogic_adapter_aw_payload_prot = writeLogic_bridge_io_output_aw_payload_prot;
  assign writeLogic_adapter_w_valid = writeLogic_bridge_io_output_w_valid;
  assign writeLogic_adapter_w_payload_data = writeLogic_bridge_io_output_w_payload_data;
  assign writeLogic_adapter_w_payload_strb = writeLogic_bridge_io_output_w_payload_strb;
  assign writeLogic_adapter_w_payload_last = writeLogic_bridge_io_output_w_payload_last;
  assign writeLogic_adapter_b_ready = writeLogic_bridge_io_output_b_ready;
  assign writeLogic_adapter_aw_halfPipe_valid = writeLogic_adapter_aw_halfPipe_regs_valid;
  assign writeLogic_adapter_aw_halfPipe_payload_addr = writeLogic_adapter_aw_halfPipe_regs_payload_addr;
  assign writeLogic_adapter_aw_halfPipe_payload_region = writeLogic_adapter_aw_halfPipe_regs_payload_region;
  assign writeLogic_adapter_aw_halfPipe_payload_len = writeLogic_adapter_aw_halfPipe_regs_payload_len;
  assign writeLogic_adapter_aw_halfPipe_payload_size = writeLogic_adapter_aw_halfPipe_regs_payload_size;
  assign writeLogic_adapter_aw_halfPipe_payload_burst = writeLogic_adapter_aw_halfPipe_regs_payload_burst;
  assign writeLogic_adapter_aw_halfPipe_payload_lock = writeLogic_adapter_aw_halfPipe_regs_payload_lock;
  assign writeLogic_adapter_aw_halfPipe_payload_cache = writeLogic_adapter_aw_halfPipe_regs_payload_cache;
  assign writeLogic_adapter_aw_halfPipe_payload_qos = writeLogic_adapter_aw_halfPipe_regs_payload_qos;
  assign writeLogic_adapter_aw_halfPipe_payload_prot = writeLogic_adapter_aw_halfPipe_regs_payload_prot;
  assign writeLogic_adapter_aw_ready = writeLogic_adapter_aw_halfPipe_regs_ready;
  assign write_awvalid = writeLogic_adapter_aw_halfPipe_valid;
  assign writeLogic_adapter_aw_halfPipe_ready = write_awready;
  assign write_awaddr = writeLogic_adapter_aw_halfPipe_payload_addr;
  assign write_awregion = writeLogic_adapter_aw_halfPipe_payload_region;
  assign write_awlen = writeLogic_adapter_aw_halfPipe_payload_len;
  assign write_awsize = writeLogic_adapter_aw_halfPipe_payload_size;
  assign write_awburst = writeLogic_adapter_aw_halfPipe_payload_burst;
  assign write_awlock = writeLogic_adapter_aw_halfPipe_payload_lock;
  assign write_awcache = writeLogic_adapter_aw_halfPipe_payload_cache;
  assign write_awqos = writeLogic_adapter_aw_halfPipe_payload_qos;
  assign write_awprot = writeLogic_adapter_aw_halfPipe_payload_prot;
  assign writeLogic_adapter_w_s2mPipe_valid = (writeLogic_adapter_w_valid || writeLogic_adapter_w_s2mPipe_rValid);
  assign writeLogic_adapter_w_ready = (! writeLogic_adapter_w_s2mPipe_rValid);
  assign writeLogic_adapter_w_s2mPipe_payload_data = (writeLogic_adapter_w_s2mPipe_rValid ? writeLogic_adapter_w_s2mPipe_rData_data : writeLogic_adapter_w_payload_data);
  assign writeLogic_adapter_w_s2mPipe_payload_strb = (writeLogic_adapter_w_s2mPipe_rValid ? writeLogic_adapter_w_s2mPipe_rData_strb : writeLogic_adapter_w_payload_strb);
  assign writeLogic_adapter_w_s2mPipe_payload_last = (writeLogic_adapter_w_s2mPipe_rValid ? writeLogic_adapter_w_s2mPipe_rData_last : writeLogic_adapter_w_payload_last);
  assign writeLogic_adapter_w_s2mPipe_ready = ((1'b1 && (! writeLogic_adapter_w_s2mPipe_m2sPipe_valid)) || writeLogic_adapter_w_s2mPipe_m2sPipe_ready);
  assign writeLogic_adapter_w_s2mPipe_m2sPipe_valid = writeLogic_adapter_w_s2mPipe_m2sPipe_rValid;
  assign writeLogic_adapter_w_s2mPipe_m2sPipe_payload_data = writeLogic_adapter_w_s2mPipe_m2sPipe_rData_data;
  assign writeLogic_adapter_w_s2mPipe_m2sPipe_payload_strb = writeLogic_adapter_w_s2mPipe_m2sPipe_rData_strb;
  assign writeLogic_adapter_w_s2mPipe_m2sPipe_payload_last = writeLogic_adapter_w_s2mPipe_m2sPipe_rData_last;
  assign write_wvalid = writeLogic_adapter_w_s2mPipe_m2sPipe_valid;
  assign writeLogic_adapter_w_s2mPipe_m2sPipe_ready = write_wready;
  assign write_wdata = writeLogic_adapter_w_s2mPipe_m2sPipe_payload_data;
  assign write_wstrb = writeLogic_adapter_w_s2mPipe_m2sPipe_payload_strb;
  assign write_wlast = writeLogic_adapter_w_s2mPipe_m2sPipe_payload_last;
  assign write_b_halfPipe_valid = write_b_halfPipe_regs_valid;
  assign write_b_halfPipe_payload_resp = write_b_halfPipe_regs_payload_resp;
  assign write_bready = write_b_halfPipe_regs_ready;
  assign writeLogic_adapter_b_valid = write_b_halfPipe_valid;
  assign write_b_halfPipe_ready = writeLogic_adapter_b_ready;
  assign writeLogic_adapter_b_payload_resp = write_b_halfPipe_payload_resp;
  assign dat64_i_ch0_tready = inputsAdapter_0_upsizer_logic_io_input_ready;
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_valid = (inputsAdapter_0_crossclock_fifo_io_pop_valid || inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid);
  assign _zz_8 = (! inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid);
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_data = (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid ? inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_data : inputsAdapter_0_crossclock_fifo_io_pop_payload_data);
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_mask = (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid ? inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_mask : inputsAdapter_0_crossclock_fifo_io_pop_payload_mask);
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_sink = (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid ? inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_sink : inputsAdapter_0_crossclock_fifo_io_pop_payload_sink);
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_last = (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid ? inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_last : inputsAdapter_0_crossclock_fifo_io_pop_payload_last);
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready = ((1'b1 && (! inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid)) || inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_ready);
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid = inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid;
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_data = inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_data;
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_mask = inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_mask;
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_sink = inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_sink;
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_last = inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_last;
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_ready = core_io_inputs_0_ready;
  assign dat32_i_ch2_tready = inputsAdapter_1_upsizer_logic_io_input_ready;
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_valid = (inputsAdapter_1_crossclock_fifo_io_pop_valid || inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid);
  assign _zz_9 = (! inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid);
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_data = (inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid ? inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_data : inputsAdapter_1_crossclock_fifo_io_pop_payload_data);
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_mask = (inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid ? inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_mask : inputsAdapter_1_crossclock_fifo_io_pop_payload_mask);
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_sink = (inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid ? inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_sink : inputsAdapter_1_crossclock_fifo_io_pop_payload_sink);
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_last = (inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid ? inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_last : inputsAdapter_1_crossclock_fifo_io_pop_payload_last);
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_ready = ((1'b1 && (! inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid)) || inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_ready);
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid = inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid;
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_data = inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_data;
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_mask = inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_mask;
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_sink = inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_sink;
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_last = inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_last;
  assign inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_ready = core_io_inputs_1_ready;
  assign core_io_outputs_0_s2mPipe_valid = (core_io_outputs_0_valid || core_io_outputs_0_s2mPipe_rValid);
  assign _zz_4 = (! core_io_outputs_0_s2mPipe_rValid);
  assign core_io_outputs_0_s2mPipe_payload_data = (core_io_outputs_0_s2mPipe_rValid ? core_io_outputs_0_s2mPipe_rData_data : core_io_outputs_0_payload_data);
  assign core_io_outputs_0_s2mPipe_payload_mask = (core_io_outputs_0_s2mPipe_rValid ? core_io_outputs_0_s2mPipe_rData_mask : core_io_outputs_0_payload_mask);
  assign core_io_outputs_0_s2mPipe_payload_sink = (core_io_outputs_0_s2mPipe_rValid ? core_io_outputs_0_s2mPipe_rData_sink : core_io_outputs_0_payload_sink);
  assign core_io_outputs_0_s2mPipe_payload_last = (core_io_outputs_0_s2mPipe_rValid ? core_io_outputs_0_s2mPipe_rData_last : core_io_outputs_0_payload_last);
  assign core_io_outputs_0_s2mPipe_ready = ((1'b1 && (! outputsAdapter_0_ptr_valid)) || outputsAdapter_0_ptr_ready);
  assign outputsAdapter_0_ptr_valid = core_io_outputs_0_s2mPipe_m2sPipe_rValid;
  assign outputsAdapter_0_ptr_payload_data = core_io_outputs_0_s2mPipe_m2sPipe_rData_data;
  assign outputsAdapter_0_ptr_payload_mask = core_io_outputs_0_s2mPipe_m2sPipe_rData_mask;
  assign outputsAdapter_0_ptr_payload_sink = core_io_outputs_0_s2mPipe_m2sPipe_rData_sink;
  assign outputsAdapter_0_ptr_payload_last = core_io_outputs_0_s2mPipe_m2sPipe_rData_last;
  assign outputsAdapter_0_ptr_ready = outputsAdapter_0_crossclock_fifo_io_push_ready;
  assign dat64_o_ch1_tvalid = outputsAdapter_0_sparseDownsizer_logic_io_output_valid;
  assign dat64_o_ch1_tdata = outputsAdapter_0_sparseDownsizer_logic_io_output_payload_data;
  assign dat64_o_ch1_tkeep = outputsAdapter_0_sparseDownsizer_logic_io_output_payload_mask;
  assign dat64_o_ch1_tdest = outputsAdapter_0_sparseDownsizer_logic_io_output_payload_sink;
  assign dat64_o_ch1_tlast = outputsAdapter_0_sparseDownsizer_logic_io_output_payload_last;
  assign core_io_outputs_1_s2mPipe_valid = (core_io_outputs_1_valid || core_io_outputs_1_s2mPipe_rValid);
  assign _zz_5 = (! core_io_outputs_1_s2mPipe_rValid);
  assign core_io_outputs_1_s2mPipe_payload_data = (core_io_outputs_1_s2mPipe_rValid ? core_io_outputs_1_s2mPipe_rData_data : core_io_outputs_1_payload_data);
  assign core_io_outputs_1_s2mPipe_payload_mask = (core_io_outputs_1_s2mPipe_rValid ? core_io_outputs_1_s2mPipe_rData_mask : core_io_outputs_1_payload_mask);
  assign core_io_outputs_1_s2mPipe_payload_sink = (core_io_outputs_1_s2mPipe_rValid ? core_io_outputs_1_s2mPipe_rData_sink : core_io_outputs_1_payload_sink);
  assign core_io_outputs_1_s2mPipe_payload_last = (core_io_outputs_1_s2mPipe_rValid ? core_io_outputs_1_s2mPipe_rData_last : core_io_outputs_1_payload_last);
  assign core_io_outputs_1_s2mPipe_ready = ((1'b1 && (! outputsAdapter_1_ptr_valid)) || outputsAdapter_1_ptr_ready);
  assign outputsAdapter_1_ptr_valid = core_io_outputs_1_s2mPipe_m2sPipe_rValid;
  assign outputsAdapter_1_ptr_payload_data = core_io_outputs_1_s2mPipe_m2sPipe_rData_data;
  assign outputsAdapter_1_ptr_payload_mask = core_io_outputs_1_s2mPipe_m2sPipe_rData_mask;
  assign outputsAdapter_1_ptr_payload_sink = core_io_outputs_1_s2mPipe_m2sPipe_rData_sink;
  assign outputsAdapter_1_ptr_payload_last = core_io_outputs_1_s2mPipe_m2sPipe_rData_last;
  assign outputsAdapter_1_ptr_ready = outputsAdapter_1_crossclock_fifo_io_push_ready;
  assign dat32_o_ch3_tvalid = outputsAdapter_1_sparseDownsizer_logic_io_output_valid;
  assign dat32_o_ch3_tdata = outputsAdapter_1_sparseDownsizer_logic_io_output_payload_data;
  assign dat32_o_ch3_tkeep = outputsAdapter_1_sparseDownsizer_logic_io_output_payload_mask;
  assign dat32_o_ch3_tdest = outputsAdapter_1_sparseDownsizer_logic_io_output_payload_sink;
  assign dat32_o_ch3_tlast = outputsAdapter_1_sparseDownsizer_logic_io_output_payload_last;
  assign _zz_7 = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      core_io_write_cmd_s2mPipe_rValid <= 1'b0;
      core_io_write_cmd_s2mPipe_m2sPipe_rValid <= 1'b0;
      interconnect_read_aggregated_cmd_halfPipe_regs_valid <= 1'b0;
      interconnect_read_aggregated_cmd_halfPipe_regs_ready <= 1'b1;
      readLogic_adapter_ar_halfPipe_regs_valid <= 1'b0;
      readLogic_adapter_ar_halfPipe_regs_ready <= 1'b1;
      read_r_s2mPipe_rValid <= 1'b0;
      read_r_s2mPipe_m2sPipe_rValid <= 1'b0;
      readLogic_beforeQueue_fifo_io_pop_s2mPipe_rValid <= 1'b0;
      readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rValid <= 1'b0;
      interconnect_write_aggregated_cmd_m2sPipe_rValid <= 1'b0;
      writeLogic_adapter_aw_halfPipe_regs_valid <= 1'b0;
      writeLogic_adapter_aw_halfPipe_regs_ready <= 1'b1;
      writeLogic_adapter_w_s2mPipe_rValid <= 1'b0;
      writeLogic_adapter_w_s2mPipe_m2sPipe_rValid <= 1'b0;
      write_b_halfPipe_regs_valid <= 1'b0;
      write_b_halfPipe_regs_ready <= 1'b1;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid <= 1'b0;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid <= 1'b0;
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid <= 1'b0;
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid <= 1'b0;
      core_io_outputs_0_s2mPipe_rValid <= 1'b0;
      core_io_outputs_0_s2mPipe_m2sPipe_rValid <= 1'b0;
      core_io_outputs_1_s2mPipe_rValid <= 1'b0;
      core_io_outputs_1_s2mPipe_m2sPipe_rValid <= 1'b0;
    end else begin
      if(core_io_write_cmd_s2mPipe_ready)begin
        core_io_write_cmd_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_10)begin
        core_io_write_cmd_s2mPipe_rValid <= core_io_write_cmd_valid;
      end
      if(core_io_write_cmd_s2mPipe_ready)begin
        core_io_write_cmd_s2mPipe_m2sPipe_rValid <= core_io_write_cmd_s2mPipe_valid;
      end
      if(_zz_11)begin
        interconnect_read_aggregated_cmd_halfPipe_regs_valid <= interconnect_read_aggregated_cmd_valid;
        interconnect_read_aggregated_cmd_halfPipe_regs_ready <= (! interconnect_read_aggregated_cmd_valid);
      end else begin
        interconnect_read_aggregated_cmd_halfPipe_regs_valid <= (! interconnect_read_aggregated_cmd_halfPipe_ready);
        interconnect_read_aggregated_cmd_halfPipe_regs_ready <= interconnect_read_aggregated_cmd_halfPipe_ready;
      end
      if(_zz_12)begin
        readLogic_adapter_ar_halfPipe_regs_valid <= readLogic_adapter_ar_valid;
        readLogic_adapter_ar_halfPipe_regs_ready <= (! readLogic_adapter_ar_valid);
      end else begin
        readLogic_adapter_ar_halfPipe_regs_valid <= (! readLogic_adapter_ar_halfPipe_ready);
        readLogic_adapter_ar_halfPipe_regs_ready <= readLogic_adapter_ar_halfPipe_ready;
      end
      if(read_r_s2mPipe_ready)begin
        read_r_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_13)begin
        read_r_s2mPipe_rValid <= read_rvalid;
      end
      if(read_r_s2mPipe_ready)begin
        read_r_s2mPipe_m2sPipe_rValid <= read_r_s2mPipe_valid;
      end
      if(readLogic_beforeQueue_fifo_io_pop_s2mPipe_ready)begin
        readLogic_beforeQueue_fifo_io_pop_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_14)begin
        readLogic_beforeQueue_fifo_io_pop_s2mPipe_rValid <= readLogic_beforeQueue_fifo_io_pop_valid;
      end
      if(readLogic_beforeQueue_fifo_io_pop_s2mPipe_ready)begin
        readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rValid <= readLogic_beforeQueue_fifo_io_pop_s2mPipe_valid;
      end
      if(interconnect_write_aggregated_cmd_ready)begin
        interconnect_write_aggregated_cmd_m2sPipe_rValid <= interconnect_write_aggregated_cmd_valid;
      end
      if(_zz_15)begin
        writeLogic_adapter_aw_halfPipe_regs_valid <= writeLogic_adapter_aw_valid;
        writeLogic_adapter_aw_halfPipe_regs_ready <= (! writeLogic_adapter_aw_valid);
      end else begin
        writeLogic_adapter_aw_halfPipe_regs_valid <= (! writeLogic_adapter_aw_halfPipe_ready);
        writeLogic_adapter_aw_halfPipe_regs_ready <= writeLogic_adapter_aw_halfPipe_ready;
      end
      if(writeLogic_adapter_w_s2mPipe_ready)begin
        writeLogic_adapter_w_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_16)begin
        writeLogic_adapter_w_s2mPipe_rValid <= writeLogic_adapter_w_valid;
      end
      if(writeLogic_adapter_w_s2mPipe_ready)begin
        writeLogic_adapter_w_s2mPipe_m2sPipe_rValid <= writeLogic_adapter_w_s2mPipe_valid;
      end
      if(_zz_17)begin
        write_b_halfPipe_regs_valid <= write_bvalid;
        write_b_halfPipe_regs_ready <= (! write_bvalid);
      end else begin
        write_b_halfPipe_regs_valid <= (! write_b_halfPipe_ready);
        write_b_halfPipe_regs_ready <= write_b_halfPipe_ready;
      end
      if(inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready)begin
        inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_18)begin
        inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid <= inputsAdapter_0_crossclock_fifo_io_pop_valid;
      end
      if(inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready)begin
        inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid <= inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_valid;
      end
      if(inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_ready)begin
        inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_19)begin
        inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rValid <= inputsAdapter_1_crossclock_fifo_io_pop_valid;
      end
      if(inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_ready)begin
        inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid <= inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_valid;
      end
      if(core_io_outputs_0_s2mPipe_ready)begin
        core_io_outputs_0_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_20)begin
        core_io_outputs_0_s2mPipe_rValid <= core_io_outputs_0_valid;
      end
      if(core_io_outputs_0_s2mPipe_ready)begin
        core_io_outputs_0_s2mPipe_m2sPipe_rValid <= core_io_outputs_0_s2mPipe_valid;
      end
      if(core_io_outputs_1_s2mPipe_ready)begin
        core_io_outputs_1_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_21)begin
        core_io_outputs_1_s2mPipe_rValid <= core_io_outputs_1_valid;
      end
      if(core_io_outputs_1_s2mPipe_ready)begin
        core_io_outputs_1_s2mPipe_m2sPipe_rValid <= core_io_outputs_1_s2mPipe_valid;
      end
    end
  end

  always @ (posedge clk) begin
    if(_zz_10)begin
      core_io_write_cmd_s2mPipe_rData_last <= core_io_write_cmd_payload_last;
      core_io_write_cmd_s2mPipe_rData_fragment_source <= core_io_write_cmd_payload_fragment_source;
      core_io_write_cmd_s2mPipe_rData_fragment_opcode <= core_io_write_cmd_payload_fragment_opcode;
      core_io_write_cmd_s2mPipe_rData_fragment_address <= core_io_write_cmd_payload_fragment_address;
      core_io_write_cmd_s2mPipe_rData_fragment_length <= core_io_write_cmd_payload_fragment_length;
      core_io_write_cmd_s2mPipe_rData_fragment_data <= core_io_write_cmd_payload_fragment_data;
      core_io_write_cmd_s2mPipe_rData_fragment_mask <= core_io_write_cmd_payload_fragment_mask;
      core_io_write_cmd_s2mPipe_rData_fragment_context <= core_io_write_cmd_payload_fragment_context;
    end
    if(core_io_write_cmd_s2mPipe_ready)begin
      core_io_write_cmd_s2mPipe_m2sPipe_rData_last <= core_io_write_cmd_s2mPipe_payload_last;
      core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_source <= core_io_write_cmd_s2mPipe_payload_fragment_source;
      core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_opcode <= core_io_write_cmd_s2mPipe_payload_fragment_opcode;
      core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_address <= core_io_write_cmd_s2mPipe_payload_fragment_address;
      core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_length <= core_io_write_cmd_s2mPipe_payload_fragment_length;
      core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_data <= core_io_write_cmd_s2mPipe_payload_fragment_data;
      core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_mask <= core_io_write_cmd_s2mPipe_payload_fragment_mask;
      core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_context <= core_io_write_cmd_s2mPipe_payload_fragment_context;
    end
    if(_zz_11)begin
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_last <= interconnect_read_aggregated_cmd_payload_last;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_source <= interconnect_read_aggregated_cmd_payload_fragment_source;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_opcode <= interconnect_read_aggregated_cmd_payload_fragment_opcode;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_address <= interconnect_read_aggregated_cmd_payload_fragment_address;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_length <= interconnect_read_aggregated_cmd_payload_fragment_length;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_context <= interconnect_read_aggregated_cmd_payload_fragment_context;
    end
    if(_zz_12)begin
      readLogic_adapter_ar_halfPipe_regs_payload_addr <= readLogic_adapter_ar_payload_addr;
      readLogic_adapter_ar_halfPipe_regs_payload_region <= readLogic_adapter_ar_payload_region;
      readLogic_adapter_ar_halfPipe_regs_payload_len <= readLogic_adapter_ar_payload_len;
      readLogic_adapter_ar_halfPipe_regs_payload_size <= readLogic_adapter_ar_payload_size;
      readLogic_adapter_ar_halfPipe_regs_payload_burst <= readLogic_adapter_ar_payload_burst;
      readLogic_adapter_ar_halfPipe_regs_payload_lock <= readLogic_adapter_ar_payload_lock;
      readLogic_adapter_ar_halfPipe_regs_payload_cache <= readLogic_adapter_ar_payload_cache;
      readLogic_adapter_ar_halfPipe_regs_payload_qos <= readLogic_adapter_ar_payload_qos;
      readLogic_adapter_ar_halfPipe_regs_payload_prot <= readLogic_adapter_ar_payload_prot;
    end
    if(_zz_13)begin
      read_r_s2mPipe_rData_data <= read_rdata;
      read_r_s2mPipe_rData_resp <= read_rresp;
      read_r_s2mPipe_rData_last <= read_rlast;
    end
    if(read_r_s2mPipe_ready)begin
      read_r_s2mPipe_m2sPipe_rData_data <= read_r_s2mPipe_payload_data;
      read_r_s2mPipe_m2sPipe_rData_resp <= read_r_s2mPipe_payload_resp;
      read_r_s2mPipe_m2sPipe_rData_last <= read_r_s2mPipe_payload_last;
    end
    if(_zz_14)begin
      readLogic_beforeQueue_fifo_io_pop_s2mPipe_rData_data <= readLogic_beforeQueue_fifo_io_pop_payload_data;
      readLogic_beforeQueue_fifo_io_pop_s2mPipe_rData_resp <= readLogic_beforeQueue_fifo_io_pop_payload_resp;
      readLogic_beforeQueue_fifo_io_pop_s2mPipe_rData_last <= readLogic_beforeQueue_fifo_io_pop_payload_last;
    end
    if(readLogic_beforeQueue_fifo_io_pop_s2mPipe_ready)begin
      readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rData_data <= readLogic_beforeQueue_fifo_io_pop_s2mPipe_payload_data;
      readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rData_resp <= readLogic_beforeQueue_fifo_io_pop_s2mPipe_payload_resp;
      readLogic_beforeQueue_fifo_io_pop_s2mPipe_m2sPipe_rData_last <= readLogic_beforeQueue_fifo_io_pop_s2mPipe_payload_last;
    end
    if(interconnect_write_aggregated_cmd_ready)begin
      interconnect_write_aggregated_cmd_m2sPipe_rData_last <= interconnect_write_aggregated_cmd_payload_last;
      interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_source <= interconnect_write_aggregated_cmd_payload_fragment_source;
      interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_opcode <= interconnect_write_aggregated_cmd_payload_fragment_opcode;
      interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_address <= interconnect_write_aggregated_cmd_payload_fragment_address;
      interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_length <= interconnect_write_aggregated_cmd_payload_fragment_length;
      interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_data <= interconnect_write_aggregated_cmd_payload_fragment_data;
      interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_mask <= interconnect_write_aggregated_cmd_payload_fragment_mask;
      interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_context <= interconnect_write_aggregated_cmd_payload_fragment_context;
    end
    if(_zz_15)begin
      writeLogic_adapter_aw_halfPipe_regs_payload_addr <= writeLogic_adapter_aw_payload_addr;
      writeLogic_adapter_aw_halfPipe_regs_payload_region <= writeLogic_adapter_aw_payload_region;
      writeLogic_adapter_aw_halfPipe_regs_payload_len <= writeLogic_adapter_aw_payload_len;
      writeLogic_adapter_aw_halfPipe_regs_payload_size <= writeLogic_adapter_aw_payload_size;
      writeLogic_adapter_aw_halfPipe_regs_payload_burst <= writeLogic_adapter_aw_payload_burst;
      writeLogic_adapter_aw_halfPipe_regs_payload_lock <= writeLogic_adapter_aw_payload_lock;
      writeLogic_adapter_aw_halfPipe_regs_payload_cache <= writeLogic_adapter_aw_payload_cache;
      writeLogic_adapter_aw_halfPipe_regs_payload_qos <= writeLogic_adapter_aw_payload_qos;
      writeLogic_adapter_aw_halfPipe_regs_payload_prot <= writeLogic_adapter_aw_payload_prot;
    end
    if(_zz_16)begin
      writeLogic_adapter_w_s2mPipe_rData_data <= writeLogic_adapter_w_payload_data;
      writeLogic_adapter_w_s2mPipe_rData_strb <= writeLogic_adapter_w_payload_strb;
      writeLogic_adapter_w_s2mPipe_rData_last <= writeLogic_adapter_w_payload_last;
    end
    if(writeLogic_adapter_w_s2mPipe_ready)begin
      writeLogic_adapter_w_s2mPipe_m2sPipe_rData_data <= writeLogic_adapter_w_s2mPipe_payload_data;
      writeLogic_adapter_w_s2mPipe_m2sPipe_rData_strb <= writeLogic_adapter_w_s2mPipe_payload_strb;
      writeLogic_adapter_w_s2mPipe_m2sPipe_rData_last <= writeLogic_adapter_w_s2mPipe_payload_last;
    end
    if(_zz_17)begin
      write_b_halfPipe_regs_payload_resp <= write_bresp;
    end
    if(_zz_18)begin
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_data <= inputsAdapter_0_crossclock_fifo_io_pop_payload_data;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_mask <= inputsAdapter_0_crossclock_fifo_io_pop_payload_mask;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_sink <= inputsAdapter_0_crossclock_fifo_io_pop_payload_sink;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_last <= inputsAdapter_0_crossclock_fifo_io_pop_payload_last;
    end
    if(inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready)begin
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_data <= inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_data;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_mask <= inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_mask;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_sink <= inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_sink;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_last <= inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_last;
    end
    if(_zz_19)begin
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_data <= inputsAdapter_1_crossclock_fifo_io_pop_payload_data;
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_mask <= inputsAdapter_1_crossclock_fifo_io_pop_payload_mask;
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_sink <= inputsAdapter_1_crossclock_fifo_io_pop_payload_sink;
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_rData_last <= inputsAdapter_1_crossclock_fifo_io_pop_payload_last;
    end
    if(inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_ready)begin
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_data <= inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_data;
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_mask <= inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_mask;
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_sink <= inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_sink;
      inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_last <= inputsAdapter_1_crossclock_fifo_io_pop_s2mPipe_payload_last;
    end
    if(_zz_20)begin
      core_io_outputs_0_s2mPipe_rData_data <= core_io_outputs_0_payload_data;
      core_io_outputs_0_s2mPipe_rData_mask <= core_io_outputs_0_payload_mask;
      core_io_outputs_0_s2mPipe_rData_sink <= core_io_outputs_0_payload_sink;
      core_io_outputs_0_s2mPipe_rData_last <= core_io_outputs_0_payload_last;
    end
    if(core_io_outputs_0_s2mPipe_ready)begin
      core_io_outputs_0_s2mPipe_m2sPipe_rData_data <= core_io_outputs_0_s2mPipe_payload_data;
      core_io_outputs_0_s2mPipe_m2sPipe_rData_mask <= core_io_outputs_0_s2mPipe_payload_mask;
      core_io_outputs_0_s2mPipe_m2sPipe_rData_sink <= core_io_outputs_0_s2mPipe_payload_sink;
      core_io_outputs_0_s2mPipe_m2sPipe_rData_last <= core_io_outputs_0_s2mPipe_payload_last;
    end
    if(_zz_21)begin
      core_io_outputs_1_s2mPipe_rData_data <= core_io_outputs_1_payload_data;
      core_io_outputs_1_s2mPipe_rData_mask <= core_io_outputs_1_payload_mask;
      core_io_outputs_1_s2mPipe_rData_sink <= core_io_outputs_1_payload_sink;
      core_io_outputs_1_s2mPipe_rData_last <= core_io_outputs_1_payload_last;
    end
    if(core_io_outputs_1_s2mPipe_ready)begin
      core_io_outputs_1_s2mPipe_m2sPipe_rData_data <= core_io_outputs_1_s2mPipe_payload_data;
      core_io_outputs_1_s2mPipe_m2sPipe_rData_mask <= core_io_outputs_1_s2mPipe_payload_mask;
      core_io_outputs_1_s2mPipe_m2sPipe_rData_sink <= core_io_outputs_1_s2mPipe_payload_sink;
      core_io_outputs_1_s2mPipe_m2sPipe_rData_last <= core_io_outputs_1_s2mPipe_payload_last;
    end
  end


endmodule

module dma_socRuby_BsbDownSizerSparse_1 (
  input               io_input_valid,
  output              io_input_ready,
  input      [127:0]  io_input_payload_data,
  input      [15:0]   io_input_payload_mask,
  input      [3:0]    io_input_payload_sink,
  input               io_input_payload_last,
  output              io_output_valid,
  input               io_output_ready,
  output     [31:0]   io_output_payload_data,
  output     [3:0]    io_output_payload_mask,
  output     [3:0]    io_output_payload_sink,
  output              io_output_payload_last,
  input               dat32_o_ch3_clk,
  input               dat32_o_ch3_reset
);
  reg        [31:0]   _zz_1;
  reg        [3:0]    _zz_2;
  reg        [1:0]    counter;
  wire                end_1;

  always @(*) begin
    case(counter)
      2'b00 : begin
        _zz_1 = io_input_payload_data[31 : 0];
        _zz_2 = io_input_payload_mask[3 : 0];
      end
      2'b01 : begin
        _zz_1 = io_input_payload_data[63 : 32];
        _zz_2 = io_input_payload_mask[7 : 4];
      end
      2'b10 : begin
        _zz_1 = io_input_payload_data[95 : 64];
        _zz_2 = io_input_payload_mask[11 : 8];
      end
      default : begin
        _zz_1 = io_input_payload_data[127 : 96];
        _zz_2 = io_input_payload_mask[15 : 12];
      end
    endcase
  end

  assign end_1 = (counter == 2'b11);
  assign io_input_ready = (io_output_ready && end_1);
  assign io_output_valid = io_input_valid;
  assign io_output_payload_data = _zz_1;
  assign io_output_payload_mask = _zz_2;
  assign io_output_payload_sink = io_input_payload_sink;
  assign io_output_payload_last = (io_input_payload_last && end_1);
  always @ (posedge dat32_o_ch3_clk) begin
    if(dat32_o_ch3_reset) begin
      counter <= 2'b00;
    end else begin
      if((io_output_valid && io_output_ready))begin
        counter <= (counter + 2'b01);
      end
    end
  end


endmodule

module dma_socRuby_StreamFifoCC_3 (
  input               io_push_valid,
  output              io_push_ready,
  input      [127:0]  io_push_payload_data,
  input      [15:0]   io_push_payload_mask,
  input      [3:0]    io_push_payload_sink,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [127:0]  io_pop_payload_data,
  output     [15:0]   io_pop_payload_mask,
  output     [3:0]    io_pop_payload_sink,
  output              io_pop_payload_last,
  output     [4:0]    io_pushOccupancy,
  output     [4:0]    io_popOccupancy,
  input               clk,
  input               reset,
  input               dat32_o_ch3_clk,
  input               dat32_o_ch3_reset
);
  reg        [148:0]  _zz_12;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire                _zz_13;
  wire       [4:0]    _zz_14;
  wire       [3:0]    _zz_15;
  wire       [4:0]    _zz_16;
  wire       [3:0]    _zz_17;
  wire       [0:0]    _zz_18;
  wire       [148:0]  _zz_19;
  wire                _zz_20;
  reg                 _zz_1;
  wire       [4:0]    popToPushGray;
  wire       [4:0]    pushToPopGray;
  reg        [4:0]    pushCC_pushPtr;
  wire       [4:0]    pushCC_pushPtrPlus;
  reg        [4:0]    pushCC_pushPtrGray;
  wire       [4:0]    pushCC_popPtrGray;
  wire                pushCC_full;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  reg        [4:0]    popCC_popPtr;
  wire       [4:0]    popCC_popPtrPlus;
  reg        [4:0]    popCC_popPtrGray;
  wire       [4:0]    popCC_pushPtrGray;
  wire                popCC_empty;
  wire       [4:0]    _zz_6;
  wire       [148:0]  _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  reg [148:0] ram [0:15];

  assign _zz_13 = (io_push_valid && io_push_ready);
  assign _zz_14 = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_15 = pushCC_pushPtr[3:0];
  assign _zz_16 = (popCC_popPtrPlus >>> 1'b1);
  assign _zz_17 = _zz_6[3:0];
  assign _zz_18 = _zz_7[148 : 148];
  assign _zz_19 = {io_push_payload_last,{io_push_payload_sink,{io_push_payload_mask,io_push_payload_data}}};
  assign _zz_20 = 1'b1;
  always @ (posedge clk) begin
    if(_zz_1) begin
      ram[_zz_15] <= _zz_19;
    end
  end

  always @ (posedge dat32_o_ch3_clk) begin
    if(_zz_20) begin
      _zz_12 <= ram[_zz_17];
    end
  end

  dma_socRuby_BufferCC_4 popToPushGray_buffercc (
    .io_dataIn     (popToPushGray[4:0]                      ), //i
    .io_dataOut    (popToPushGray_buffercc_io_dataOut[4:0]  ), //o
    .clk           (clk                                     ), //i
    .reset         (reset                                   )  //i
  );
  dma_socRuby_BufferCC_10 pushToPopGray_buffercc (
    .io_dataIn            (pushToPopGray[4:0]                      ), //i
    .io_dataOut           (pushToPopGray_buffercc_io_dataOut[4:0]  ), //o
    .dat32_o_ch3_clk      (dat32_o_ch3_clk                         ), //i
    .dat32_o_ch3_reset    (dat32_o_ch3_reset                       )  //i
  );
  always @ (*) begin
    _zz_1 = 1'b0;
    if(_zz_13)begin
      _zz_1 = 1'b1;
    end
  end

  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 5'h01);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[4 : 3] == (~ pushCC_popPtrGray[4 : 3])) && (pushCC_pushPtrGray[2 : 0] == pushCC_popPtrGray[2 : 0]));
  assign io_push_ready = (! pushCC_full);
  assign _zz_2 = (pushCC_popPtrGray[1] ^ _zz_3);
  assign _zz_3 = (pushCC_popPtrGray[2] ^ _zz_4);
  assign _zz_4 = (pushCC_popPtrGray[3] ^ _zz_5);
  assign _zz_5 = pushCC_popPtrGray[4];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_5,{_zz_4,{_zz_3,{_zz_2,(pushCC_popPtrGray[0] ^ _zz_2)}}}});
  assign popCC_popPtrPlus = (popCC_popPtr + 5'h01);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign io_pop_valid = (! popCC_empty);
  assign _zz_6 = ((io_pop_valid && io_pop_ready) ? popCC_popPtrPlus : popCC_popPtr);
  assign _zz_7 = _zz_12;
  assign io_pop_payload_data = _zz_7[127 : 0];
  assign io_pop_payload_mask = _zz_7[143 : 128];
  assign io_pop_payload_sink = _zz_7[147 : 144];
  assign io_pop_payload_last = _zz_18[0];
  assign _zz_8 = (popCC_pushPtrGray[1] ^ _zz_9);
  assign _zz_9 = (popCC_pushPtrGray[2] ^ _zz_10);
  assign _zz_10 = (popCC_pushPtrGray[3] ^ _zz_11);
  assign _zz_11 = popCC_pushPtrGray[4];
  assign io_popOccupancy = ({_zz_11,{_zz_10,{_zz_9,{_zz_8,(popCC_pushPtrGray[0] ^ _zz_8)}}}} - popCC_popPtr);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_popPtrGray;
  always @ (posedge clk) begin
    if(reset) begin
      pushCC_pushPtr <= 5'h0;
      pushCC_pushPtrGray <= 5'h0;
    end else begin
      if((io_push_valid && io_push_ready))begin
        pushCC_pushPtrGray <= (_zz_14 ^ pushCC_pushPtrPlus);
      end
      if(_zz_13)begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @ (posedge dat32_o_ch3_clk) begin
    if(dat32_o_ch3_reset) begin
      popCC_popPtr <= 5'h0;
      popCC_popPtrGray <= 5'h0;
    end else begin
      if((io_pop_valid && io_pop_ready))begin
        popCC_popPtrGray <= (_zz_16 ^ popCC_popPtrPlus);
      end
      if((io_pop_valid && io_pop_ready))begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
    end
  end


endmodule

module dma_socRuby_BsbDownSizerSparse (
  input               io_input_valid,
  output              io_input_ready,
  input      [127:0]  io_input_payload_data,
  input      [15:0]   io_input_payload_mask,
  input      [3:0]    io_input_payload_sink,
  input               io_input_payload_last,
  output              io_output_valid,
  input               io_output_ready,
  output     [63:0]   io_output_payload_data,
  output     [7:0]    io_output_payload_mask,
  output     [3:0]    io_output_payload_sink,
  output              io_output_payload_last,
  input               dat64_o_ch1_clk,
  input               dat64_o_ch1_reset
);
  reg        [63:0]   _zz_1;
  reg        [7:0]    _zz_2;
  reg        [0:0]    counter;
  wire                end_1;

  always @(*) begin
    case(counter)
      1'b0 : begin
        _zz_1 = io_input_payload_data[63 : 0];
        _zz_2 = io_input_payload_mask[7 : 0];
      end
      default : begin
        _zz_1 = io_input_payload_data[127 : 64];
        _zz_2 = io_input_payload_mask[15 : 8];
      end
    endcase
  end

  assign end_1 = (counter == 1'b1);
  assign io_input_ready = (io_output_ready && end_1);
  assign io_output_valid = io_input_valid;
  assign io_output_payload_data = _zz_1;
  assign io_output_payload_mask = _zz_2;
  assign io_output_payload_sink = io_input_payload_sink;
  assign io_output_payload_last = (io_input_payload_last && end_1);
  always @ (posedge dat64_o_ch1_clk) begin
    if(dat64_o_ch1_reset) begin
      counter <= 1'b0;
    end else begin
      if((io_output_valid && io_output_ready))begin
        counter <= (counter + 1'b1);
      end
    end
  end


endmodule

module dma_socRuby_StreamFifoCC_2 (
  input               io_push_valid,
  output              io_push_ready,
  input      [127:0]  io_push_payload_data,
  input      [15:0]   io_push_payload_mask,
  input      [3:0]    io_push_payload_sink,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [127:0]  io_pop_payload_data,
  output     [15:0]   io_pop_payload_mask,
  output     [3:0]    io_pop_payload_sink,
  output              io_pop_payload_last,
  output     [4:0]    io_pushOccupancy,
  output     [4:0]    io_popOccupancy,
  input               clk,
  input               reset,
  input               dat64_o_ch1_clk,
  input               dat64_o_ch1_reset
);
  reg        [148:0]  _zz_12;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire                _zz_13;
  wire       [4:0]    _zz_14;
  wire       [3:0]    _zz_15;
  wire       [4:0]    _zz_16;
  wire       [3:0]    _zz_17;
  wire       [0:0]    _zz_18;
  wire       [148:0]  _zz_19;
  wire                _zz_20;
  reg                 _zz_1;
  wire       [4:0]    popToPushGray;
  wire       [4:0]    pushToPopGray;
  reg        [4:0]    pushCC_pushPtr;
  wire       [4:0]    pushCC_pushPtrPlus;
  reg        [4:0]    pushCC_pushPtrGray;
  wire       [4:0]    pushCC_popPtrGray;
  wire                pushCC_full;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  reg        [4:0]    popCC_popPtr;
  wire       [4:0]    popCC_popPtrPlus;
  reg        [4:0]    popCC_popPtrGray;
  wire       [4:0]    popCC_pushPtrGray;
  wire                popCC_empty;
  wire       [4:0]    _zz_6;
  wire       [148:0]  _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  reg [148:0] ram [0:15];

  assign _zz_13 = (io_push_valid && io_push_ready);
  assign _zz_14 = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_15 = pushCC_pushPtr[3:0];
  assign _zz_16 = (popCC_popPtrPlus >>> 1'b1);
  assign _zz_17 = _zz_6[3:0];
  assign _zz_18 = _zz_7[148 : 148];
  assign _zz_19 = {io_push_payload_last,{io_push_payload_sink,{io_push_payload_mask,io_push_payload_data}}};
  assign _zz_20 = 1'b1;
  always @ (posedge clk) begin
    if(_zz_1) begin
      ram[_zz_15] <= _zz_19;
    end
  end

  always @ (posedge dat64_o_ch1_clk) begin
    if(_zz_20) begin
      _zz_12 <= ram[_zz_17];
    end
  end

  dma_socRuby_BufferCC_4 popToPushGray_buffercc (
    .io_dataIn     (popToPushGray[4:0]                      ), //i
    .io_dataOut    (popToPushGray_buffercc_io_dataOut[4:0]  ), //o
    .clk           (clk                                     ), //i
    .reset         (reset                                   )  //i
  );
  dma_socRuby_BufferCC_8 pushToPopGray_buffercc (
    .io_dataIn            (pushToPopGray[4:0]                      ), //i
    .io_dataOut           (pushToPopGray_buffercc_io_dataOut[4:0]  ), //o
    .dat64_o_ch1_clk      (dat64_o_ch1_clk                         ), //i
    .dat64_o_ch1_reset    (dat64_o_ch1_reset                       )  //i
  );
  always @ (*) begin
    _zz_1 = 1'b0;
    if(_zz_13)begin
      _zz_1 = 1'b1;
    end
  end

  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 5'h01);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[4 : 3] == (~ pushCC_popPtrGray[4 : 3])) && (pushCC_pushPtrGray[2 : 0] == pushCC_popPtrGray[2 : 0]));
  assign io_push_ready = (! pushCC_full);
  assign _zz_2 = (pushCC_popPtrGray[1] ^ _zz_3);
  assign _zz_3 = (pushCC_popPtrGray[2] ^ _zz_4);
  assign _zz_4 = (pushCC_popPtrGray[3] ^ _zz_5);
  assign _zz_5 = pushCC_popPtrGray[4];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_5,{_zz_4,{_zz_3,{_zz_2,(pushCC_popPtrGray[0] ^ _zz_2)}}}});
  assign popCC_popPtrPlus = (popCC_popPtr + 5'h01);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign io_pop_valid = (! popCC_empty);
  assign _zz_6 = ((io_pop_valid && io_pop_ready) ? popCC_popPtrPlus : popCC_popPtr);
  assign _zz_7 = _zz_12;
  assign io_pop_payload_data = _zz_7[127 : 0];
  assign io_pop_payload_mask = _zz_7[143 : 128];
  assign io_pop_payload_sink = _zz_7[147 : 144];
  assign io_pop_payload_last = _zz_18[0];
  assign _zz_8 = (popCC_pushPtrGray[1] ^ _zz_9);
  assign _zz_9 = (popCC_pushPtrGray[2] ^ _zz_10);
  assign _zz_10 = (popCC_pushPtrGray[3] ^ _zz_11);
  assign _zz_11 = popCC_pushPtrGray[4];
  assign io_popOccupancy = ({_zz_11,{_zz_10,{_zz_9,{_zz_8,(popCC_pushPtrGray[0] ^ _zz_8)}}}} - popCC_popPtr);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_popPtrGray;
  always @ (posedge clk) begin
    if(reset) begin
      pushCC_pushPtr <= 5'h0;
      pushCC_pushPtrGray <= 5'h0;
    end else begin
      if((io_push_valid && io_push_ready))begin
        pushCC_pushPtrGray <= (_zz_14 ^ pushCC_pushPtrPlus);
      end
      if(_zz_13)begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @ (posedge dat64_o_ch1_clk) begin
    if(dat64_o_ch1_reset) begin
      popCC_popPtr <= 5'h0;
      popCC_popPtrGray <= 5'h0;
    end else begin
      if((io_pop_valid && io_pop_ready))begin
        popCC_popPtrGray <= (_zz_16 ^ popCC_popPtrPlus);
      end
      if((io_pop_valid && io_pop_ready))begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
    end
  end


endmodule

module dma_socRuby_StreamFifoCC_1 (
  input               io_push_valid,
  output              io_push_ready,
  input      [127:0]  io_push_payload_data,
  input      [15:0]   io_push_payload_mask,
  input      [3:0]    io_push_payload_sink,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [127:0]  io_pop_payload_data,
  output     [15:0]   io_pop_payload_mask,
  output     [3:0]    io_pop_payload_sink,
  output              io_pop_payload_last,
  output     [4:0]    io_pushOccupancy,
  output     [4:0]    io_popOccupancy,
  input               dat32_i_ch2_clk,
  input               dat32_i_ch2_reset,
  input               clk,
  input               reset
);
  reg        [148:0]  _zz_12;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire                _zz_13;
  wire       [4:0]    _zz_14;
  wire       [3:0]    _zz_15;
  wire       [4:0]    _zz_16;
  wire       [3:0]    _zz_17;
  wire       [0:0]    _zz_18;
  wire       [148:0]  _zz_19;
  wire                _zz_20;
  reg                 _zz_1;
  wire       [4:0]    popToPushGray;
  wire       [4:0]    pushToPopGray;
  reg        [4:0]    pushCC_pushPtr;
  wire       [4:0]    pushCC_pushPtrPlus;
  reg        [4:0]    pushCC_pushPtrGray;
  wire       [4:0]    pushCC_popPtrGray;
  wire                pushCC_full;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  reg        [4:0]    popCC_popPtr;
  wire       [4:0]    popCC_popPtrPlus;
  reg        [4:0]    popCC_popPtrGray;
  wire       [4:0]    popCC_pushPtrGray;
  wire                popCC_empty;
  wire       [4:0]    _zz_6;
  wire       [148:0]  _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  reg [148:0] ram [0:15];

  assign _zz_13 = (io_push_valid && io_push_ready);
  assign _zz_14 = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_15 = pushCC_pushPtr[3:0];
  assign _zz_16 = (popCC_popPtrPlus >>> 1'b1);
  assign _zz_17 = _zz_6[3:0];
  assign _zz_18 = _zz_7[148 : 148];
  assign _zz_19 = {io_push_payload_last,{io_push_payload_sink,{io_push_payload_mask,io_push_payload_data}}};
  assign _zz_20 = 1'b1;
  always @ (posedge dat32_i_ch2_clk) begin
    if(_zz_1) begin
      ram[_zz_15] <= _zz_19;
    end
  end

  always @ (posedge clk) begin
    if(_zz_20) begin
      _zz_12 <= ram[_zz_17];
    end
  end

  dma_socRuby_BufferCC_5 popToPushGray_buffercc (
    .io_dataIn            (popToPushGray[4:0]                      ), //i
    .io_dataOut           (popToPushGray_buffercc_io_dataOut[4:0]  ), //o
    .dat32_i_ch2_clk      (dat32_i_ch2_clk                         ), //i
    .dat32_i_ch2_reset    (dat32_i_ch2_reset                       )  //i
  );
  dma_socRuby_BufferCC_4 pushToPopGray_buffercc (
    .io_dataIn     (pushToPopGray[4:0]                      ), //i
    .io_dataOut    (pushToPopGray_buffercc_io_dataOut[4:0]  ), //o
    .clk           (clk                                     ), //i
    .reset         (reset                                   )  //i
  );
  always @ (*) begin
    _zz_1 = 1'b0;
    if(_zz_13)begin
      _zz_1 = 1'b1;
    end
  end

  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 5'h01);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[4 : 3] == (~ pushCC_popPtrGray[4 : 3])) && (pushCC_pushPtrGray[2 : 0] == pushCC_popPtrGray[2 : 0]));
  assign io_push_ready = (! pushCC_full);
  assign _zz_2 = (pushCC_popPtrGray[1] ^ _zz_3);
  assign _zz_3 = (pushCC_popPtrGray[2] ^ _zz_4);
  assign _zz_4 = (pushCC_popPtrGray[3] ^ _zz_5);
  assign _zz_5 = pushCC_popPtrGray[4];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_5,{_zz_4,{_zz_3,{_zz_2,(pushCC_popPtrGray[0] ^ _zz_2)}}}});
  assign popCC_popPtrPlus = (popCC_popPtr + 5'h01);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign io_pop_valid = (! popCC_empty);
  assign _zz_6 = ((io_pop_valid && io_pop_ready) ? popCC_popPtrPlus : popCC_popPtr);
  assign _zz_7 = _zz_12;
  assign io_pop_payload_data = _zz_7[127 : 0];
  assign io_pop_payload_mask = _zz_7[143 : 128];
  assign io_pop_payload_sink = _zz_7[147 : 144];
  assign io_pop_payload_last = _zz_18[0];
  assign _zz_8 = (popCC_pushPtrGray[1] ^ _zz_9);
  assign _zz_9 = (popCC_pushPtrGray[2] ^ _zz_10);
  assign _zz_10 = (popCC_pushPtrGray[3] ^ _zz_11);
  assign _zz_11 = popCC_pushPtrGray[4];
  assign io_popOccupancy = ({_zz_11,{_zz_10,{_zz_9,{_zz_8,(popCC_pushPtrGray[0] ^ _zz_8)}}}} - popCC_popPtr);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_popPtrGray;
  always @ (posedge dat32_i_ch2_clk) begin
    if(dat32_i_ch2_reset) begin
      pushCC_pushPtr <= 5'h0;
      pushCC_pushPtrGray <= 5'h0;
    end else begin
      if((io_push_valid && io_push_ready))begin
        pushCC_pushPtrGray <= (_zz_14 ^ pushCC_pushPtrPlus);
      end
      if(_zz_13)begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      popCC_popPtr <= 5'h0;
      popCC_popPtrGray <= 5'h0;
    end else begin
      if((io_pop_valid && io_pop_ready))begin
        popCC_popPtrGray <= (_zz_16 ^ popCC_popPtrPlus);
      end
      if((io_pop_valid && io_pop_ready))begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
    end
  end


endmodule

module dma_socRuby_BsbUpSizerDense_1 (
  input               io_input_valid,
  output              io_input_ready,
  input      [31:0]   io_input_payload_data,
  input      [3:0]    io_input_payload_mask,
  input      [3:0]    io_input_payload_sink,
  input               io_input_payload_last,
  output              io_output_valid,
  input               io_output_ready,
  output     [127:0]  io_output_payload_data,
  output     [15:0]   io_output_payload_mask,
  output     [3:0]    io_output_payload_sink,
  output              io_output_payload_last,
  input               dat32_i_ch2_clk,
  input               dat32_i_ch2_reset
);
  wire                _zz_3;
  reg                 valid;
  reg        [1:0]    counter;
  reg        [127:0]  buffer_data;
  reg        [15:0]   buffer_mask;
  reg        [3:0]    buffer_sink;
  reg                 buffer_last;
  wire                full;
  wire                canAggregate;
  wire                onOutput;
  wire       [1:0]    counterSample;
  wire       [3:0]    _zz_1;
  wire       [3:0]    _zz_2;

  assign _zz_3 = (io_input_valid && io_input_ready);
  assign full = ((counter == 2'b00) || buffer_last);
  assign canAggregate = ((((valid && (! buffer_last)) && (! full)) && 1'b1) && (buffer_sink == io_input_payload_sink));
  assign counterSample = (canAggregate ? counter : 2'b00);
  assign _zz_1 = ({3'd0,1'b1} <<< counterSample);
  assign _zz_2 = ({3'd0,1'b1} <<< counterSample);
  assign io_output_valid = (valid && ((valid && full) || (io_input_valid && (! canAggregate))));
  assign io_output_payload_data = buffer_data;
  assign io_output_payload_mask = buffer_mask;
  assign io_output_payload_sink = buffer_sink;
  assign io_output_payload_last = buffer_last;
  assign io_input_ready = (((! valid) || canAggregate) || io_output_ready);
  always @ (posedge dat32_i_ch2_clk) begin
    if(dat32_i_ch2_reset) begin
      valid <= 1'b0;
      counter <= 2'b00;
      buffer_last <= 1'b0;
      buffer_mask <= 16'h0;
    end else begin
      if((io_output_valid && io_output_ready))begin
        valid <= 1'b0;
        buffer_mask <= 16'h0;
      end
      if(_zz_3)begin
        valid <= 1'b1;
        if(_zz_2[0])begin
          buffer_mask[3 : 0] <= io_input_payload_mask;
        end
        if(_zz_2[1])begin
          buffer_mask[7 : 4] <= io_input_payload_mask;
        end
        if(_zz_2[2])begin
          buffer_mask[11 : 8] <= io_input_payload_mask;
        end
        if(_zz_2[3])begin
          buffer_mask[15 : 12] <= io_input_payload_mask;
        end
        buffer_last <= io_input_payload_last;
        counter <= (counterSample + 2'b01);
      end
    end
  end

  always @ (posedge dat32_i_ch2_clk) begin
    if(_zz_3)begin
      buffer_sink <= io_input_payload_sink;
      if(_zz_1[0])begin
        buffer_data[31 : 0] <= io_input_payload_data;
      end
      if(_zz_1[1])begin
        buffer_data[63 : 32] <= io_input_payload_data;
      end
      if(_zz_1[2])begin
        buffer_data[95 : 64] <= io_input_payload_data;
      end
      if(_zz_1[3])begin
        buffer_data[127 : 96] <= io_input_payload_data;
      end
    end
  end


endmodule

module dma_socRuby_StreamFifoCC (
  input               io_push_valid,
  output              io_push_ready,
  input      [127:0]  io_push_payload_data,
  input      [15:0]   io_push_payload_mask,
  input      [3:0]    io_push_payload_sink,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [127:0]  io_pop_payload_data,
  output     [15:0]   io_pop_payload_mask,
  output     [3:0]    io_pop_payload_sink,
  output              io_pop_payload_last,
  output     [4:0]    io_pushOccupancy,
  output     [4:0]    io_popOccupancy,
  input               dat64_i_ch0_clk,
  input               dat64_i_ch0_reset,
  input               clk,
  input               reset
);
  reg        [148:0]  _zz_12;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire                _zz_13;
  wire       [4:0]    _zz_14;
  wire       [3:0]    _zz_15;
  wire       [4:0]    _zz_16;
  wire       [3:0]    _zz_17;
  wire       [0:0]    _zz_18;
  wire       [148:0]  _zz_19;
  wire                _zz_20;
  reg                 _zz_1;
  wire       [4:0]    popToPushGray;
  wire       [4:0]    pushToPopGray;
  reg        [4:0]    pushCC_pushPtr;
  wire       [4:0]    pushCC_pushPtrPlus;
  reg        [4:0]    pushCC_pushPtrGray;
  wire       [4:0]    pushCC_popPtrGray;
  wire                pushCC_full;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  reg        [4:0]    popCC_popPtr;
  wire       [4:0]    popCC_popPtrPlus;
  reg        [4:0]    popCC_popPtrGray;
  wire       [4:0]    popCC_pushPtrGray;
  wire                popCC_empty;
  wire       [4:0]    _zz_6;
  wire       [148:0]  _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  reg [148:0] ram [0:15];

  assign _zz_13 = (io_push_valid && io_push_ready);
  assign _zz_14 = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_15 = pushCC_pushPtr[3:0];
  assign _zz_16 = (popCC_popPtrPlus >>> 1'b1);
  assign _zz_17 = _zz_6[3:0];
  assign _zz_18 = _zz_7[148 : 148];
  assign _zz_19 = {io_push_payload_last,{io_push_payload_sink,{io_push_payload_mask,io_push_payload_data}}};
  assign _zz_20 = 1'b1;
  always @ (posedge dat64_i_ch0_clk) begin
    if(_zz_1) begin
      ram[_zz_15] <= _zz_19;
    end
  end

  always @ (posedge clk) begin
    if(_zz_20) begin
      _zz_12 <= ram[_zz_17];
    end
  end

  dma_socRuby_BufferCC_3 popToPushGray_buffercc (
    .io_dataIn            (popToPushGray[4:0]                      ), //i
    .io_dataOut           (popToPushGray_buffercc_io_dataOut[4:0]  ), //o
    .dat64_i_ch0_clk      (dat64_i_ch0_clk                         ), //i
    .dat64_i_ch0_reset    (dat64_i_ch0_reset                       )  //i
  );
  dma_socRuby_BufferCC_4 pushToPopGray_buffercc (
    .io_dataIn     (pushToPopGray[4:0]                      ), //i
    .io_dataOut    (pushToPopGray_buffercc_io_dataOut[4:0]  ), //o
    .clk           (clk                                     ), //i
    .reset         (reset                                   )  //i
  );
  always @ (*) begin
    _zz_1 = 1'b0;
    if(_zz_13)begin
      _zz_1 = 1'b1;
    end
  end

  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 5'h01);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[4 : 3] == (~ pushCC_popPtrGray[4 : 3])) && (pushCC_pushPtrGray[2 : 0] == pushCC_popPtrGray[2 : 0]));
  assign io_push_ready = (! pushCC_full);
  assign _zz_2 = (pushCC_popPtrGray[1] ^ _zz_3);
  assign _zz_3 = (pushCC_popPtrGray[2] ^ _zz_4);
  assign _zz_4 = (pushCC_popPtrGray[3] ^ _zz_5);
  assign _zz_5 = pushCC_popPtrGray[4];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_5,{_zz_4,{_zz_3,{_zz_2,(pushCC_popPtrGray[0] ^ _zz_2)}}}});
  assign popCC_popPtrPlus = (popCC_popPtr + 5'h01);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign io_pop_valid = (! popCC_empty);
  assign _zz_6 = ((io_pop_valid && io_pop_ready) ? popCC_popPtrPlus : popCC_popPtr);
  assign _zz_7 = _zz_12;
  assign io_pop_payload_data = _zz_7[127 : 0];
  assign io_pop_payload_mask = _zz_7[143 : 128];
  assign io_pop_payload_sink = _zz_7[147 : 144];
  assign io_pop_payload_last = _zz_18[0];
  assign _zz_8 = (popCC_pushPtrGray[1] ^ _zz_9);
  assign _zz_9 = (popCC_pushPtrGray[2] ^ _zz_10);
  assign _zz_10 = (popCC_pushPtrGray[3] ^ _zz_11);
  assign _zz_11 = popCC_pushPtrGray[4];
  assign io_popOccupancy = ({_zz_11,{_zz_10,{_zz_9,{_zz_8,(popCC_pushPtrGray[0] ^ _zz_8)}}}} - popCC_popPtr);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_popPtrGray;
  always @ (posedge dat64_i_ch0_clk) begin
    if(dat64_i_ch0_reset) begin
      pushCC_pushPtr <= 5'h0;
      pushCC_pushPtrGray <= 5'h0;
    end else begin
      if((io_push_valid && io_push_ready))begin
        pushCC_pushPtrGray <= (_zz_14 ^ pushCC_pushPtrPlus);
      end
      if(_zz_13)begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      popCC_popPtr <= 5'h0;
      popCC_popPtrGray <= 5'h0;
    end else begin
      if((io_pop_valid && io_pop_ready))begin
        popCC_popPtrGray <= (_zz_16 ^ popCC_popPtrPlus);
      end
      if((io_pop_valid && io_pop_ready))begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
    end
  end


endmodule

module dma_socRuby_BsbUpSizerDense (
  input               io_input_valid,
  output              io_input_ready,
  input      [63:0]   io_input_payload_data,
  input      [7:0]    io_input_payload_mask,
  input      [3:0]    io_input_payload_sink,
  input               io_input_payload_last,
  output              io_output_valid,
  input               io_output_ready,
  output     [127:0]  io_output_payload_data,
  output     [15:0]   io_output_payload_mask,
  output     [3:0]    io_output_payload_sink,
  output              io_output_payload_last,
  input               dat64_i_ch0_clk,
  input               dat64_i_ch0_reset
);
  wire                _zz_3;
  reg                 valid;
  reg        [0:0]    counter;
  reg        [127:0]  buffer_data;
  reg        [15:0]   buffer_mask;
  reg        [3:0]    buffer_sink;
  reg                 buffer_last;
  wire                full;
  wire                canAggregate;
  wire                onOutput;
  wire       [0:0]    counterSample;
  wire       [1:0]    _zz_1;
  wire       [1:0]    _zz_2;

  assign _zz_3 = (io_input_valid && io_input_ready);
  assign full = ((counter == 1'b0) || buffer_last);
  assign canAggregate = ((((valid && (! buffer_last)) && (! full)) && 1'b1) && (buffer_sink == io_input_payload_sink));
  assign counterSample = (canAggregate ? counter : 1'b0);
  assign _zz_1 = ({1'd0,1'b1} <<< counterSample);
  assign _zz_2 = ({1'd0,1'b1} <<< counterSample);
  assign io_output_valid = (valid && ((valid && full) || (io_input_valid && (! canAggregate))));
  assign io_output_payload_data = buffer_data;
  assign io_output_payload_mask = buffer_mask;
  assign io_output_payload_sink = buffer_sink;
  assign io_output_payload_last = buffer_last;
  assign io_input_ready = (((! valid) || canAggregate) || io_output_ready);
  always @ (posedge dat64_i_ch0_clk) begin
    if(dat64_i_ch0_reset) begin
      valid <= 1'b0;
      counter <= 1'b0;
      buffer_last <= 1'b0;
      buffer_mask <= 16'h0;
    end else begin
      if((io_output_valid && io_output_ready))begin
        valid <= 1'b0;
        buffer_mask <= 16'h0;
      end
      if(_zz_3)begin
        valid <= 1'b1;
        if(_zz_2[0])begin
          buffer_mask[7 : 0] <= io_input_payload_mask;
        end
        if(_zz_2[1])begin
          buffer_mask[15 : 8] <= io_input_payload_mask;
        end
        buffer_last <= io_input_payload_last;
        counter <= (counterSample + 1'b1);
      end
    end
  end

  always @ (posedge dat64_i_ch0_clk) begin
    if(_zz_3)begin
      buffer_sink <= io_input_payload_sink;
      if(_zz_1[0])begin
        buffer_data[63 : 0] <= io_input_payload_data;
      end
      if(_zz_1[1])begin
        buffer_data[127 : 64] <= io_input_payload_data;
      end
    end
  end


endmodule

module dma_socRuby_BmbToAxi4WriteOnlyBridge (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [11:0]   io_input_cmd_payload_fragment_length,
  input      [127:0]  io_input_cmd_payload_fragment_data,
  input      [15:0]   io_input_cmd_payload_fragment_mask,
  input      [15:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [15:0]   io_input_rsp_payload_fragment_context,
  output              io_output_aw_valid,
  input               io_output_aw_ready,
  output     [31:0]   io_output_aw_payload_addr,
  output     [7:0]    io_output_aw_payload_len,
  output     [2:0]    io_output_aw_payload_size,
  output     [3:0]    io_output_aw_payload_cache,
  output     [2:0]    io_output_aw_payload_prot,
  output              io_output_w_valid,
  input               io_output_w_ready,
  output     [127:0]  io_output_w_payload_data,
  output     [15:0]   io_output_w_payload_strb,
  output              io_output_w_payload_last,
  input               io_output_b_valid,
  output              io_output_b_ready,
  input      [1:0]    io_output_b_payload_resp,
  input               clk,
  input               reset
);
  wire                _zz_1;
  reg        [0:0]    _zz_2;
  reg                 _zz_3;
  wire                contextRemover_io_input_cmd_ready;
  wire                contextRemover_io_input_rsp_valid;
  wire                contextRemover_io_input_rsp_payload_last;
  wire       [0:0]    contextRemover_io_input_rsp_payload_fragment_opcode;
  wire       [15:0]   contextRemover_io_input_rsp_payload_fragment_context;
  wire                contextRemover_io_output_cmd_valid;
  wire                contextRemover_io_output_cmd_payload_last;
  wire       [0:0]    contextRemover_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   contextRemover_io_output_cmd_payload_fragment_address;
  wire       [11:0]   contextRemover_io_output_cmd_payload_fragment_length;
  wire       [127:0]  contextRemover_io_output_cmd_payload_fragment_data;
  wire       [15:0]   contextRemover_io_output_cmd_payload_fragment_mask;
  wire                contextRemover_io_output_rsp_ready;
  wire                contextRemover_io_output_cmd_fork_io_input_ready;
  wire                contextRemover_io_output_cmd_fork_io_outputs_0_valid;
  wire                contextRemover_io_output_cmd_fork_io_outputs_0_payload_last;
  wire       [0:0]    contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_opcode;
  wire       [31:0]   contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_address;
  wire       [11:0]   contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_length;
  wire       [127:0]  contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_data;
  wire       [15:0]   contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_mask;
  wire                contextRemover_io_output_cmd_fork_io_outputs_1_valid;
  wire                contextRemover_io_output_cmd_fork_io_outputs_1_payload_last;
  wire       [0:0]    contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_opcode;
  wire       [31:0]   contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_address;
  wire       [11:0]   contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_length;
  wire       [127:0]  contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_data;
  wire       [15:0]   contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_mask;
  wire                _zz_4;
  wire       [8:0]    _zz_5;
  wire       [12:0]   _zz_6;
  wire       [3:0]    _zz_7;
  wire       [12:0]   _zz_8;
  reg                 contextRemover_io_output_cmd_payload_first;
  reg                 cmdStage_valid;
  wire                cmdStage_ready;
  wire                cmdStage_payload_last;
  wire       [0:0]    cmdStage_payload_fragment_opcode;
  wire       [31:0]   cmdStage_payload_fragment_address;
  wire       [11:0]   cmdStage_payload_fragment_length;
  wire       [127:0]  cmdStage_payload_fragment_data;
  wire       [15:0]   cmdStage_payload_fragment_mask;

  assign _zz_4 = (! contextRemover_io_output_cmd_payload_first);
  assign _zz_5 = _zz_6[12 : 4];
  assign _zz_6 = ({1'b0,cmdStage_payload_fragment_length} + _zz_8);
  assign _zz_7 = cmdStage_payload_fragment_address[3 : 0];
  assign _zz_8 = {9'd0, _zz_7};
  dma_socRuby_BmbContextRemover_1 contextRemover (
    .io_input_cmd_valid                        (io_input_cmd_valid                                           ), //i
    .io_input_cmd_ready                        (contextRemover_io_input_cmd_ready                            ), //o
    .io_input_cmd_payload_last                 (io_input_cmd_payload_last                                    ), //i
    .io_input_cmd_payload_fragment_opcode      (io_input_cmd_payload_fragment_opcode                         ), //i
    .io_input_cmd_payload_fragment_address     (io_input_cmd_payload_fragment_address[31:0]                  ), //i
    .io_input_cmd_payload_fragment_length      (io_input_cmd_payload_fragment_length[11:0]                   ), //i
    .io_input_cmd_payload_fragment_data        (io_input_cmd_payload_fragment_data[127:0]                    ), //i
    .io_input_cmd_payload_fragment_mask        (io_input_cmd_payload_fragment_mask[15:0]                     ), //i
    .io_input_cmd_payload_fragment_context     (io_input_cmd_payload_fragment_context[15:0]                  ), //i
    .io_input_rsp_valid                        (contextRemover_io_input_rsp_valid                            ), //o
    .io_input_rsp_ready                        (io_input_rsp_ready                                           ), //i
    .io_input_rsp_payload_last                 (contextRemover_io_input_rsp_payload_last                     ), //o
    .io_input_rsp_payload_fragment_opcode      (contextRemover_io_input_rsp_payload_fragment_opcode          ), //o
    .io_input_rsp_payload_fragment_context     (contextRemover_io_input_rsp_payload_fragment_context[15:0]   ), //o
    .io_output_cmd_valid                       (contextRemover_io_output_cmd_valid                           ), //o
    .io_output_cmd_ready                       (contextRemover_io_output_cmd_fork_io_input_ready             ), //i
    .io_output_cmd_payload_last                (contextRemover_io_output_cmd_payload_last                    ), //o
    .io_output_cmd_payload_fragment_opcode     (contextRemover_io_output_cmd_payload_fragment_opcode         ), //o
    .io_output_cmd_payload_fragment_address    (contextRemover_io_output_cmd_payload_fragment_address[31:0]  ), //o
    .io_output_cmd_payload_fragment_length     (contextRemover_io_output_cmd_payload_fragment_length[11:0]   ), //o
    .io_output_cmd_payload_fragment_data       (contextRemover_io_output_cmd_payload_fragment_data[127:0]    ), //o
    .io_output_cmd_payload_fragment_mask       (contextRemover_io_output_cmd_payload_fragment_mask[15:0]     ), //o
    .io_output_rsp_valid                       (io_output_b_valid                                            ), //i
    .io_output_rsp_ready                       (contextRemover_io_output_rsp_ready                           ), //o
    .io_output_rsp_payload_last                (_zz_1                                                        ), //i
    .io_output_rsp_payload_fragment_opcode     (_zz_2                                                        ), //i
    .clk                                       (clk                                                          ), //i
    .reset                                     (reset                                                        )  //i
  );
  dma_socRuby_StreamFork_2 contextRemover_io_output_cmd_fork (
    .io_input_valid                           (contextRemover_io_output_cmd_valid                                             ), //i
    .io_input_ready                           (contextRemover_io_output_cmd_fork_io_input_ready                               ), //o
    .io_input_payload_last                    (contextRemover_io_output_cmd_payload_last                                      ), //i
    .io_input_payload_fragment_opcode         (contextRemover_io_output_cmd_payload_fragment_opcode                           ), //i
    .io_input_payload_fragment_address        (contextRemover_io_output_cmd_payload_fragment_address[31:0]                    ), //i
    .io_input_payload_fragment_length         (contextRemover_io_output_cmd_payload_fragment_length[11:0]                     ), //i
    .io_input_payload_fragment_data           (contextRemover_io_output_cmd_payload_fragment_data[127:0]                      ), //i
    .io_input_payload_fragment_mask           (contextRemover_io_output_cmd_payload_fragment_mask[15:0]                       ), //i
    .io_outputs_0_valid                       (contextRemover_io_output_cmd_fork_io_outputs_0_valid                           ), //o
    .io_outputs_0_ready                       (_zz_3                                                                          ), //i
    .io_outputs_0_payload_last                (contextRemover_io_output_cmd_fork_io_outputs_0_payload_last                    ), //o
    .io_outputs_0_payload_fragment_opcode     (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_opcode         ), //o
    .io_outputs_0_payload_fragment_address    (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_address[31:0]  ), //o
    .io_outputs_0_payload_fragment_length     (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_length[11:0]   ), //o
    .io_outputs_0_payload_fragment_data       (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_data[127:0]    ), //o
    .io_outputs_0_payload_fragment_mask       (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_mask[15:0]     ), //o
    .io_outputs_1_valid                       (contextRemover_io_output_cmd_fork_io_outputs_1_valid                           ), //o
    .io_outputs_1_ready                       (io_output_w_ready                                                              ), //i
    .io_outputs_1_payload_last                (contextRemover_io_output_cmd_fork_io_outputs_1_payload_last                    ), //o
    .io_outputs_1_payload_fragment_opcode     (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_opcode         ), //o
    .io_outputs_1_payload_fragment_address    (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_address[31:0]  ), //o
    .io_outputs_1_payload_fragment_length     (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_length[11:0]   ), //o
    .io_outputs_1_payload_fragment_data       (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_data[127:0]    ), //o
    .io_outputs_1_payload_fragment_mask       (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_mask[15:0]     ), //o
    .clk                                      (clk                                                                            ), //i
    .reset                                    (reset                                                                          )  //i
  );
  assign io_input_cmd_ready = contextRemover_io_input_cmd_ready;
  assign io_input_rsp_valid = contextRemover_io_input_rsp_valid;
  assign io_input_rsp_payload_last = contextRemover_io_input_rsp_payload_last;
  assign io_input_rsp_payload_fragment_opcode = contextRemover_io_input_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_context = contextRemover_io_input_rsp_payload_fragment_context;
  always @ (*) begin
    cmdStage_valid = contextRemover_io_output_cmd_fork_io_outputs_0_valid;
    if(_zz_4)begin
      cmdStage_valid = 1'b0;
    end
  end

  always @ (*) begin
    _zz_3 = cmdStage_ready;
    if(_zz_4)begin
      _zz_3 = 1'b1;
    end
  end

  assign cmdStage_payload_last = contextRemover_io_output_cmd_fork_io_outputs_0_payload_last;
  assign cmdStage_payload_fragment_opcode = contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_opcode;
  assign cmdStage_payload_fragment_address = contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_address;
  assign cmdStage_payload_fragment_length = contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_length;
  assign cmdStage_payload_fragment_data = contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_data;
  assign cmdStage_payload_fragment_mask = contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_mask;
  assign io_output_aw_valid = cmdStage_valid;
  assign cmdStage_ready = io_output_aw_ready;
  assign io_output_aw_payload_addr = cmdStage_payload_fragment_address;
  assign io_output_aw_payload_len = _zz_5[7:0];
  assign io_output_aw_payload_size = 3'b100;
  assign io_output_aw_payload_prot = 3'b010;
  assign io_output_aw_payload_cache = 4'b1111;
  assign io_output_w_valid = contextRemover_io_output_cmd_fork_io_outputs_1_valid;
  assign io_output_w_payload_data = contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_data;
  assign io_output_w_payload_strb = contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_mask;
  assign io_output_w_payload_last = contextRemover_io_output_cmd_fork_io_outputs_1_payload_last;
  assign io_output_b_ready = contextRemover_io_output_rsp_ready;
  assign _zz_1 = 1'b1;
  always @ (*) begin
    if((io_output_b_payload_resp == 2'b00))begin
      _zz_2 = 1'b0;
    end else begin
      _zz_2 = 1'b1;
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      contextRemover_io_output_cmd_payload_first <= 1'b1;
    end else begin
      if((contextRemover_io_output_cmd_valid && contextRemover_io_output_cmd_fork_io_input_ready))begin
        contextRemover_io_output_cmd_payload_first <= contextRemover_io_output_cmd_payload_last;
      end
    end
  end


endmodule

module dma_socRuby_BmbWriteRetainer (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [11:0]   io_input_cmd_payload_fragment_length,
  input      [127:0]  io_input_cmd_payload_fragment_data,
  input      [15:0]   io_input_cmd_payload_fragment_mask,
  input      [15:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [15:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [11:0]   io_output_cmd_payload_fragment_length,
  output     [127:0]  io_output_cmd_payload_fragment_data,
  output     [15:0]   io_output_cmd_payload_fragment_mask,
  output     [15:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [15:0]   io_output_rsp_payload_fragment_context,
  input               clk,
  input               reset
);
  wire                _zz_2;
  wire                _zz_3;
  wire                io_input_cmd_fifo_io_push_ready;
  wire                io_input_cmd_fifo_io_pop_valid;
  wire                io_input_cmd_fifo_io_pop_payload_last;
  wire       [0:0]    io_input_cmd_fifo_io_pop_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fifo_io_pop_payload_fragment_address;
  wire       [11:0]   io_input_cmd_fifo_io_pop_payload_fragment_length;
  wire       [127:0]  io_input_cmd_fifo_io_pop_payload_fragment_data;
  wire       [15:0]   io_input_cmd_fifo_io_pop_payload_fragment_mask;
  wire       [15:0]   io_input_cmd_fifo_io_pop_payload_fragment_context;
  wire       [8:0]    io_input_cmd_fifo_io_occupancy;
  wire       [8:0]    io_input_cmd_fifo_io_availability;
  wire                cmdBuffer_valid;
  wire                cmdBuffer_ready;
  wire                cmdBuffer_payload_last;
  wire       [0:0]    cmdBuffer_payload_fragment_opcode;
  wire       [31:0]   cmdBuffer_payload_fragment_address;
  wire       [11:0]   cmdBuffer_payload_fragment_length;
  wire       [127:0]  cmdBuffer_payload_fragment_data;
  wire       [15:0]   cmdBuffer_payload_fragment_mask;
  wire       [15:0]   cmdBuffer_payload_fragment_context;
  reg                 io_input_cmd_fifo_io_pop_m2sPipe_rValid;
  reg                 io_input_cmd_fifo_io_pop_m2sPipe_rData_last;
  reg        [0:0]    io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_opcode;
  reg        [31:0]   io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_address;
  reg        [11:0]   io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_length;
  reg        [127:0]  io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_data;
  reg        [15:0]   io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_mask;
  reg        [15:0]   io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_context;
  reg                 tocken_incrementIt;
  reg                 tocken_decrementIt;
  wire       [7:0]    tocken_valueNext;
  reg        [7:0]    tocken_value;
  wire                tocken_willOverflowIfInc;
  wire                tocken_willOverflow;
  reg        [7:0]    tocken_finalIncrement;
  reg                 cmdBuffer_payload_first;
  wire                halt;
  wire                _zz_1;

  dma_socRuby_StreamFifo_2 io_input_cmd_fifo (
    .io_push_valid                       (io_input_cmd_valid                                       ), //i
    .io_push_ready                       (io_input_cmd_fifo_io_push_ready                          ), //o
    .io_push_payload_last                (io_input_cmd_payload_last                                ), //i
    .io_push_payload_fragment_opcode     (io_input_cmd_payload_fragment_opcode                     ), //i
    .io_push_payload_fragment_address    (io_input_cmd_payload_fragment_address[31:0]              ), //i
    .io_push_payload_fragment_length     (io_input_cmd_payload_fragment_length[11:0]               ), //i
    .io_push_payload_fragment_data       (io_input_cmd_payload_fragment_data[127:0]                ), //i
    .io_push_payload_fragment_mask       (io_input_cmd_payload_fragment_mask[15:0]                 ), //i
    .io_push_payload_fragment_context    (io_input_cmd_payload_fragment_context[15:0]              ), //i
    .io_pop_valid                        (io_input_cmd_fifo_io_pop_valid                           ), //o
    .io_pop_ready                        (_zz_2                                                    ), //i
    .io_pop_payload_last                 (io_input_cmd_fifo_io_pop_payload_last                    ), //o
    .io_pop_payload_fragment_opcode      (io_input_cmd_fifo_io_pop_payload_fragment_opcode         ), //o
    .io_pop_payload_fragment_address     (io_input_cmd_fifo_io_pop_payload_fragment_address[31:0]  ), //o
    .io_pop_payload_fragment_length      (io_input_cmd_fifo_io_pop_payload_fragment_length[11:0]   ), //o
    .io_pop_payload_fragment_data        (io_input_cmd_fifo_io_pop_payload_fragment_data[127:0]    ), //o
    .io_pop_payload_fragment_mask        (io_input_cmd_fifo_io_pop_payload_fragment_mask[15:0]     ), //o
    .io_pop_payload_fragment_context     (io_input_cmd_fifo_io_pop_payload_fragment_context[15:0]  ), //o
    .io_flush                            (_zz_3                                                    ), //i
    .io_occupancy                        (io_input_cmd_fifo_io_occupancy[8:0]                      ), //o
    .io_availability                     (io_input_cmd_fifo_io_availability[8:0]                   ), //o
    .clk                                 (clk                                                      ), //i
    .reset                               (reset                                                    )  //i
  );
  assign io_input_cmd_ready = io_input_cmd_fifo_io_push_ready;
  assign _zz_2 = ((1'b1 && (! cmdBuffer_valid)) || cmdBuffer_ready);
  assign cmdBuffer_valid = io_input_cmd_fifo_io_pop_m2sPipe_rValid;
  assign cmdBuffer_payload_last = io_input_cmd_fifo_io_pop_m2sPipe_rData_last;
  assign cmdBuffer_payload_fragment_opcode = io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_opcode;
  assign cmdBuffer_payload_fragment_address = io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_address;
  assign cmdBuffer_payload_fragment_length = io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_length;
  assign cmdBuffer_payload_fragment_data = io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_data;
  assign cmdBuffer_payload_fragment_mask = io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_mask;
  assign cmdBuffer_payload_fragment_context = io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_context;
  always @ (*) begin
    tocken_incrementIt = 1'b0;
    if(((io_input_cmd_valid && io_input_cmd_ready) && io_input_cmd_payload_last))begin
      tocken_incrementIt = 1'b1;
    end
  end

  always @ (*) begin
    tocken_decrementIt = 1'b0;
    if(((cmdBuffer_valid && cmdBuffer_ready) && cmdBuffer_payload_last))begin
      tocken_decrementIt = 1'b1;
    end
  end

  assign tocken_willOverflowIfInc = ((tocken_value == 8'hff) && (! tocken_decrementIt));
  assign tocken_willOverflow = (tocken_willOverflowIfInc && tocken_incrementIt);
  always @ (*) begin
    if((tocken_incrementIt && (! tocken_decrementIt)))begin
      tocken_finalIncrement = 8'h01;
    end else begin
      if(((! tocken_incrementIt) && tocken_decrementIt))begin
        tocken_finalIncrement = 8'hff;
      end else begin
        tocken_finalIncrement = 8'h0;
      end
    end
  end

  assign tocken_valueNext = (tocken_value + tocken_finalIncrement);
  assign halt = (cmdBuffer_payload_first && (tocken_value == 8'h0));
  assign _zz_1 = (! halt);
  assign cmdBuffer_ready = (io_output_cmd_ready && _zz_1);
  assign io_output_cmd_valid = (cmdBuffer_valid && _zz_1);
  assign io_output_cmd_payload_last = cmdBuffer_payload_last;
  assign io_output_cmd_payload_fragment_opcode = cmdBuffer_payload_fragment_opcode;
  assign io_output_cmd_payload_fragment_address = cmdBuffer_payload_fragment_address;
  assign io_output_cmd_payload_fragment_length = cmdBuffer_payload_fragment_length;
  assign io_output_cmd_payload_fragment_data = cmdBuffer_payload_fragment_data;
  assign io_output_cmd_payload_fragment_mask = cmdBuffer_payload_fragment_mask;
  assign io_output_cmd_payload_fragment_context = cmdBuffer_payload_fragment_context;
  assign io_input_rsp_valid = io_output_rsp_valid;
  assign io_output_rsp_ready = io_input_rsp_ready;
  assign io_input_rsp_payload_last = io_output_rsp_payload_last;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_context = io_output_rsp_payload_fragment_context;
  assign _zz_3 = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      io_input_cmd_fifo_io_pop_m2sPipe_rValid <= 1'b0;
      tocken_value <= 8'h0;
      cmdBuffer_payload_first <= 1'b1;
    end else begin
      if(_zz_2)begin
        io_input_cmd_fifo_io_pop_m2sPipe_rValid <= io_input_cmd_fifo_io_pop_valid;
      end
      tocken_value <= tocken_valueNext;
      if((cmdBuffer_valid && cmdBuffer_ready))begin
        cmdBuffer_payload_first <= cmdBuffer_payload_last;
      end
    end
  end

  always @ (posedge clk) begin
    if(_zz_2)begin
      io_input_cmd_fifo_io_pop_m2sPipe_rData_last <= io_input_cmd_fifo_io_pop_payload_last;
      io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_opcode <= io_input_cmd_fifo_io_pop_payload_fragment_opcode;
      io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_address <= io_input_cmd_fifo_io_pop_payload_fragment_address;
      io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_length <= io_input_cmd_fifo_io_pop_payload_fragment_length;
      io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_data <= io_input_cmd_fifo_io_pop_payload_fragment_data;
      io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_mask <= io_input_cmd_fifo_io_pop_payload_fragment_mask;
      io_input_cmd_fifo_io_pop_m2sPipe_rData_fragment_context <= io_input_cmd_fifo_io_pop_payload_fragment_context;
    end
  end


endmodule

module dma_socRuby_BmbSourceRemover_1 (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [1:0]    io_input_cmd_payload_fragment_source,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [11:0]   io_input_cmd_payload_fragment_length,
  input      [127:0]  io_input_cmd_payload_fragment_data,
  input      [15:0]   io_input_cmd_payload_fragment_mask,
  input      [13:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [1:0]    io_input_rsp_payload_fragment_source,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [13:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [11:0]   io_output_cmd_payload_fragment_length,
  output     [127:0]  io_output_cmd_payload_fragment_data,
  output     [15:0]   io_output_cmd_payload_fragment_mask,
  output     [15:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [15:0]   io_output_rsp_payload_fragment_context
);
  wire       [1:0]    cmdContext_source;
  wire       [13:0]   cmdContext_context;
  wire       [1:0]    rspContext_source;
  wire       [13:0]   rspContext_context;
  wire       [15:0]   _zz_1;

  assign cmdContext_source = io_input_cmd_payload_fragment_source;
  assign cmdContext_context = io_input_cmd_payload_fragment_context;
  assign io_output_cmd_valid = io_input_cmd_valid;
  assign io_input_cmd_ready = io_output_cmd_ready;
  assign io_output_cmd_payload_last = io_input_cmd_payload_last;
  assign io_output_cmd_payload_fragment_opcode = io_input_cmd_payload_fragment_opcode;
  assign io_output_cmd_payload_fragment_address = io_input_cmd_payload_fragment_address;
  assign io_output_cmd_payload_fragment_length = io_input_cmd_payload_fragment_length;
  assign io_output_cmd_payload_fragment_data = io_input_cmd_payload_fragment_data;
  assign io_output_cmd_payload_fragment_mask = io_input_cmd_payload_fragment_mask;
  assign io_output_cmd_payload_fragment_context = {cmdContext_context,cmdContext_source};
  assign _zz_1 = io_output_rsp_payload_fragment_context;
  assign rspContext_source = _zz_1[1 : 0];
  assign rspContext_context = _zz_1[15 : 2];
  assign io_input_rsp_valid = io_output_rsp_valid;
  assign io_output_rsp_ready = io_input_rsp_ready;
  assign io_input_rsp_payload_last = io_output_rsp_payload_last;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_source = rspContext_source;
  assign io_input_rsp_payload_fragment_context = rspContext_context;

endmodule

module dma_socRuby_StreamFifo_3 (
  input               io_push_valid,
  output              io_push_ready,
  input      [127:0]  io_push_payload_data,
  input      [1:0]    io_push_payload_resp,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [127:0]  io_pop_payload_data,
  output     [1:0]    io_pop_payload_resp,
  output              io_pop_payload_last,
  input               io_flush,
  output     [8:0]    io_occupancy,
  output     [8:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [130:0]  _zz_4;
  wire       [0:0]    _zz_5;
  wire       [7:0]    _zz_6;
  wire       [0:0]    _zz_7;
  wire       [7:0]    _zz_8;
  wire       [0:0]    _zz_9;
  wire       [7:0]    _zz_10;
  wire                _zz_11;
  wire       [130:0]  _zz_12;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [7:0]    logic_pushPtr_valueNext;
  reg        [7:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [7:0]    logic_popPtr_valueNext;
  reg        [7:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [130:0]  _zz_3;
  wire       [7:0]    logic_ptrDif;
  reg [130:0] logic_ram [0:255];

  assign _zz_5 = logic_pushPtr_willIncrement;
  assign _zz_6 = {7'd0, _zz_5};
  assign _zz_7 = logic_popPtr_willIncrement;
  assign _zz_8 = {7'd0, _zz_7};
  assign _zz_9 = _zz_3[130 : 130];
  assign _zz_10 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_11 = 1'b1;
  assign _zz_12 = {io_push_payload_last,{io_push_payload_resp,io_push_payload_data}};
  always @ (posedge clk) begin
    if(_zz_11) begin
      _zz_4 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_12;
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(logic_pushing)begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing)begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 8'hff);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_6);
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 8'h0;
    end
  end

  always @ (*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping)begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 8'hff);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_8);
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 8'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign _zz_3 = _zz_4;
  assign io_pop_payload_data = _zz_3[127 : 0];
  assign io_pop_payload_resp = _zz_3[129 : 128];
  assign io_pop_payload_last = _zz_9[0];
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_10};
  always @ (posedge clk) begin
    if(reset) begin
      logic_pushPtr_value <= 8'h0;
      logic_popPtr_value <= 8'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_2 <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_2 <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if((logic_pushing != logic_popping))begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush)begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module dma_socRuby_BmbToAxi4ReadOnlyBridge (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [11:0]   io_input_cmd_payload_fragment_length,
  input      [23:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [127:0]  io_input_rsp_payload_fragment_data,
  output     [23:0]   io_input_rsp_payload_fragment_context,
  output              io_output_ar_valid,
  input               io_output_ar_ready,
  output     [31:0]   io_output_ar_payload_addr,
  output     [7:0]    io_output_ar_payload_len,
  output     [2:0]    io_output_ar_payload_size,
  output     [3:0]    io_output_ar_payload_cache,
  output     [2:0]    io_output_ar_payload_prot,
  input               io_output_r_valid,
  output              io_output_r_ready,
  input      [127:0]  io_output_r_payload_data,
  input      [1:0]    io_output_r_payload_resp,
  input               io_output_r_payload_last,
  input               clk,
  input               reset
);
  reg        [0:0]    _zz_1;
  wire                contextRemover_io_input_cmd_ready;
  wire                contextRemover_io_input_rsp_valid;
  wire                contextRemover_io_input_rsp_payload_last;
  wire       [0:0]    contextRemover_io_input_rsp_payload_fragment_opcode;
  wire       [127:0]  contextRemover_io_input_rsp_payload_fragment_data;
  wire       [23:0]   contextRemover_io_input_rsp_payload_fragment_context;
  wire                contextRemover_io_output_cmd_valid;
  wire                contextRemover_io_output_cmd_payload_last;
  wire       [0:0]    contextRemover_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   contextRemover_io_output_cmd_payload_fragment_address;
  wire       [11:0]   contextRemover_io_output_cmd_payload_fragment_length;
  wire                contextRemover_io_output_rsp_ready;
  wire       [8:0]    _zz_2;
  wire       [12:0]   _zz_3;
  wire       [3:0]    _zz_4;
  wire       [12:0]   _zz_5;

  assign _zz_2 = _zz_3[12 : 4];
  assign _zz_3 = ({1'b0,contextRemover_io_output_cmd_payload_fragment_length} + _zz_5);
  assign _zz_4 = contextRemover_io_output_cmd_payload_fragment_address[3 : 0];
  assign _zz_5 = {9'd0, _zz_4};
  dma_socRuby_BmbContextRemover contextRemover (
    .io_input_cmd_valid                        (io_input_cmd_valid                                           ), //i
    .io_input_cmd_ready                        (contextRemover_io_input_cmd_ready                            ), //o
    .io_input_cmd_payload_last                 (io_input_cmd_payload_last                                    ), //i
    .io_input_cmd_payload_fragment_opcode      (io_input_cmd_payload_fragment_opcode                         ), //i
    .io_input_cmd_payload_fragment_address     (io_input_cmd_payload_fragment_address[31:0]                  ), //i
    .io_input_cmd_payload_fragment_length      (io_input_cmd_payload_fragment_length[11:0]                   ), //i
    .io_input_cmd_payload_fragment_context     (io_input_cmd_payload_fragment_context[23:0]                  ), //i
    .io_input_rsp_valid                        (contextRemover_io_input_rsp_valid                            ), //o
    .io_input_rsp_ready                        (io_input_rsp_ready                                           ), //i
    .io_input_rsp_payload_last                 (contextRemover_io_input_rsp_payload_last                     ), //o
    .io_input_rsp_payload_fragment_opcode      (contextRemover_io_input_rsp_payload_fragment_opcode          ), //o
    .io_input_rsp_payload_fragment_data        (contextRemover_io_input_rsp_payload_fragment_data[127:0]     ), //o
    .io_input_rsp_payload_fragment_context     (contextRemover_io_input_rsp_payload_fragment_context[23:0]   ), //o
    .io_output_cmd_valid                       (contextRemover_io_output_cmd_valid                           ), //o
    .io_output_cmd_ready                       (io_output_ar_ready                                           ), //i
    .io_output_cmd_payload_last                (contextRemover_io_output_cmd_payload_last                    ), //o
    .io_output_cmd_payload_fragment_opcode     (contextRemover_io_output_cmd_payload_fragment_opcode         ), //o
    .io_output_cmd_payload_fragment_address    (contextRemover_io_output_cmd_payload_fragment_address[31:0]  ), //o
    .io_output_cmd_payload_fragment_length     (contextRemover_io_output_cmd_payload_fragment_length[11:0]   ), //o
    .io_output_rsp_valid                       (io_output_r_valid                                            ), //i
    .io_output_rsp_ready                       (contextRemover_io_output_rsp_ready                           ), //o
    .io_output_rsp_payload_last                (io_output_r_payload_last                                     ), //i
    .io_output_rsp_payload_fragment_opcode     (_zz_1                                                        ), //i
    .io_output_rsp_payload_fragment_data       (io_output_r_payload_data[127:0]                              ), //i
    .clk                                       (clk                                                          ), //i
    .reset                                     (reset                                                        )  //i
  );
  assign io_input_cmd_ready = contextRemover_io_input_cmd_ready;
  assign io_input_rsp_valid = contextRemover_io_input_rsp_valid;
  assign io_input_rsp_payload_last = contextRemover_io_input_rsp_payload_last;
  assign io_input_rsp_payload_fragment_opcode = contextRemover_io_input_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_data = contextRemover_io_input_rsp_payload_fragment_data;
  assign io_input_rsp_payload_fragment_context = contextRemover_io_input_rsp_payload_fragment_context;
  assign io_output_ar_valid = contextRemover_io_output_cmd_valid;
  assign io_output_ar_payload_addr = contextRemover_io_output_cmd_payload_fragment_address;
  assign io_output_ar_payload_len = _zz_2[7:0];
  assign io_output_ar_payload_size = 3'b100;
  assign io_output_ar_payload_prot = 3'b010;
  assign io_output_ar_payload_cache = 4'b1111;
  assign io_output_r_ready = contextRemover_io_output_rsp_ready;
  always @ (*) begin
    if((io_output_r_payload_resp == 2'b00))begin
      _zz_1 = 1'b0;
    end else begin
      _zz_1 = 1'b1;
    end
  end


endmodule

module dma_socRuby_BmbSourceRemover (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [1:0]    io_input_cmd_payload_fragment_source,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [11:0]   io_input_cmd_payload_fragment_length,
  input      [21:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [1:0]    io_input_rsp_payload_fragment_source,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [127:0]  io_input_rsp_payload_fragment_data,
  output     [21:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [11:0]   io_output_cmd_payload_fragment_length,
  output     [23:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [127:0]  io_output_rsp_payload_fragment_data,
  input      [23:0]   io_output_rsp_payload_fragment_context
);
  wire       [1:0]    cmdContext_source;
  wire       [21:0]   cmdContext_context;
  wire       [1:0]    rspContext_source;
  wire       [21:0]   rspContext_context;
  wire       [23:0]   _zz_1;

  assign cmdContext_source = io_input_cmd_payload_fragment_source;
  assign cmdContext_context = io_input_cmd_payload_fragment_context;
  assign io_output_cmd_valid = io_input_cmd_valid;
  assign io_input_cmd_ready = io_output_cmd_ready;
  assign io_output_cmd_payload_last = io_input_cmd_payload_last;
  assign io_output_cmd_payload_fragment_opcode = io_input_cmd_payload_fragment_opcode;
  assign io_output_cmd_payload_fragment_address = io_input_cmd_payload_fragment_address;
  assign io_output_cmd_payload_fragment_length = io_input_cmd_payload_fragment_length;
  assign io_output_cmd_payload_fragment_context = {cmdContext_context,cmdContext_source};
  assign _zz_1 = io_output_rsp_payload_fragment_context;
  assign rspContext_source = _zz_1[1 : 0];
  assign rspContext_context = _zz_1[23 : 2];
  assign io_input_rsp_valid = io_output_rsp_valid;
  assign io_output_rsp_ready = io_input_rsp_ready;
  assign io_input_rsp_payload_last = io_output_rsp_payload_last;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_data = io_output_rsp_payload_fragment_data;
  assign io_input_rsp_payload_fragment_source = rspContext_source;
  assign io_input_rsp_payload_fragment_context = rspContext_context;

endmodule

module dma_socRuby_BmbArbiter_1 (
  input               io_inputs_0_cmd_valid,
  output              io_inputs_0_cmd_ready,
  input               io_inputs_0_cmd_payload_last,
  input      [0:0]    io_inputs_0_cmd_payload_fragment_opcode,
  input      [31:0]   io_inputs_0_cmd_payload_fragment_address,
  input      [1:0]    io_inputs_0_cmd_payload_fragment_length,
  input      [127:0]  io_inputs_0_cmd_payload_fragment_data,
  input      [15:0]   io_inputs_0_cmd_payload_fragment_mask,
  input      [1:0]    io_inputs_0_cmd_payload_fragment_context,
  output              io_inputs_0_rsp_valid,
  input               io_inputs_0_rsp_ready,
  output              io_inputs_0_rsp_payload_last,
  output     [0:0]    io_inputs_0_rsp_payload_fragment_opcode,
  output     [1:0]    io_inputs_0_rsp_payload_fragment_context,
  input               io_inputs_1_cmd_valid,
  output              io_inputs_1_cmd_ready,
  input               io_inputs_1_cmd_payload_last,
  input      [0:0]    io_inputs_1_cmd_payload_fragment_source,
  input      [0:0]    io_inputs_1_cmd_payload_fragment_opcode,
  input      [31:0]   io_inputs_1_cmd_payload_fragment_address,
  input      [11:0]   io_inputs_1_cmd_payload_fragment_length,
  input      [127:0]  io_inputs_1_cmd_payload_fragment_data,
  input      [15:0]   io_inputs_1_cmd_payload_fragment_mask,
  input      [13:0]   io_inputs_1_cmd_payload_fragment_context,
  output              io_inputs_1_rsp_valid,
  input               io_inputs_1_rsp_ready,
  output              io_inputs_1_rsp_payload_last,
  output     [0:0]    io_inputs_1_rsp_payload_fragment_source,
  output     [0:0]    io_inputs_1_rsp_payload_fragment_opcode,
  output     [13:0]   io_inputs_1_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [1:0]    io_output_cmd_payload_fragment_source,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [11:0]   io_output_cmd_payload_fragment_length,
  output     [127:0]  io_output_cmd_payload_fragment_data,
  output     [15:0]   io_output_cmd_payload_fragment_mask,
  output     [13:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [1:0]    io_output_rsp_payload_fragment_source,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [13:0]   io_output_rsp_payload_fragment_context,
  input               clk,
  input               reset
);
  wire       [1:0]    _zz_1;
  wire       [11:0]   _zz_2;
  wire       [13:0]   _zz_3;
  wire       [1:0]    _zz_4;
  reg                 _zz_5;
  wire                memory_arbiter_io_inputs_0_ready;
  wire                memory_arbiter_io_inputs_1_ready;
  wire                memory_arbiter_io_output_valid;
  wire                memory_arbiter_io_output_payload_last;
  wire       [1:0]    memory_arbiter_io_output_payload_fragment_source;
  wire       [0:0]    memory_arbiter_io_output_payload_fragment_opcode;
  wire       [31:0]   memory_arbiter_io_output_payload_fragment_address;
  wire       [11:0]   memory_arbiter_io_output_payload_fragment_length;
  wire       [127:0]  memory_arbiter_io_output_payload_fragment_data;
  wire       [15:0]   memory_arbiter_io_output_payload_fragment_mask;
  wire       [13:0]   memory_arbiter_io_output_payload_fragment_context;
  wire       [0:0]    memory_arbiter_io_chosen;
  wire       [1:0]    memory_arbiter_io_chosenOH;
  wire       [2:0]    _zz_6;
  wire       [0:0]    memory_rspSel;

  assign _zz_6 = {memory_arbiter_io_output_payload_fragment_source,memory_arbiter_io_chosen};
  dma_socRuby_StreamArbiter_1 memory_arbiter (
    .io_inputs_0_valid                       (io_inputs_0_cmd_valid                                    ), //i
    .io_inputs_0_ready                       (memory_arbiter_io_inputs_0_ready                         ), //o
    .io_inputs_0_payload_last                (io_inputs_0_cmd_payload_last                             ), //i
    .io_inputs_0_payload_fragment_source     (_zz_1[1:0]                                               ), //i
    .io_inputs_0_payload_fragment_opcode     (io_inputs_0_cmd_payload_fragment_opcode                  ), //i
    .io_inputs_0_payload_fragment_address    (io_inputs_0_cmd_payload_fragment_address[31:0]           ), //i
    .io_inputs_0_payload_fragment_length     (_zz_2[11:0]                                              ), //i
    .io_inputs_0_payload_fragment_data       (io_inputs_0_cmd_payload_fragment_data[127:0]             ), //i
    .io_inputs_0_payload_fragment_mask       (io_inputs_0_cmd_payload_fragment_mask[15:0]              ), //i
    .io_inputs_0_payload_fragment_context    (_zz_3[13:0]                                              ), //i
    .io_inputs_1_valid                       (io_inputs_1_cmd_valid                                    ), //i
    .io_inputs_1_ready                       (memory_arbiter_io_inputs_1_ready                         ), //o
    .io_inputs_1_payload_last                (io_inputs_1_cmd_payload_last                             ), //i
    .io_inputs_1_payload_fragment_source     (_zz_4[1:0]                                               ), //i
    .io_inputs_1_payload_fragment_opcode     (io_inputs_1_cmd_payload_fragment_opcode                  ), //i
    .io_inputs_1_payload_fragment_address    (io_inputs_1_cmd_payload_fragment_address[31:0]           ), //i
    .io_inputs_1_payload_fragment_length     (io_inputs_1_cmd_payload_fragment_length[11:0]            ), //i
    .io_inputs_1_payload_fragment_data       (io_inputs_1_cmd_payload_fragment_data[127:0]             ), //i
    .io_inputs_1_payload_fragment_mask       (io_inputs_1_cmd_payload_fragment_mask[15:0]              ), //i
    .io_inputs_1_payload_fragment_context    (io_inputs_1_cmd_payload_fragment_context[13:0]           ), //i
    .io_output_valid                         (memory_arbiter_io_output_valid                           ), //o
    .io_output_ready                         (io_output_cmd_ready                                      ), //i
    .io_output_payload_last                  (memory_arbiter_io_output_payload_last                    ), //o
    .io_output_payload_fragment_source       (memory_arbiter_io_output_payload_fragment_source[1:0]    ), //o
    .io_output_payload_fragment_opcode       (memory_arbiter_io_output_payload_fragment_opcode         ), //o
    .io_output_payload_fragment_address      (memory_arbiter_io_output_payload_fragment_address[31:0]  ), //o
    .io_output_payload_fragment_length       (memory_arbiter_io_output_payload_fragment_length[11:0]   ), //o
    .io_output_payload_fragment_data         (memory_arbiter_io_output_payload_fragment_data[127:0]    ), //o
    .io_output_payload_fragment_mask         (memory_arbiter_io_output_payload_fragment_mask[15:0]     ), //o
    .io_output_payload_fragment_context      (memory_arbiter_io_output_payload_fragment_context[13:0]  ), //o
    .io_chosen                               (memory_arbiter_io_chosen                                 ), //o
    .io_chosenOH                             (memory_arbiter_io_chosenOH[1:0]                          ), //o
    .clk                                     (clk                                                      ), //i
    .reset                                   (reset                                                    )  //i
  );
  always @(*) begin
    case(memory_rspSel)
      1'b0 : begin
        _zz_5 = io_inputs_0_rsp_ready;
      end
      default : begin
        _zz_5 = io_inputs_1_rsp_ready;
      end
    endcase
  end

  assign io_inputs_0_cmd_ready = memory_arbiter_io_inputs_0_ready;
  assign _zz_1 = 2'b00;
  assign _zz_2 = {10'd0, io_inputs_0_cmd_payload_fragment_length};
  assign _zz_3 = {12'd0, io_inputs_0_cmd_payload_fragment_context};
  assign io_inputs_1_cmd_ready = memory_arbiter_io_inputs_1_ready;
  assign _zz_4 = {1'd0, io_inputs_1_cmd_payload_fragment_source};
  assign io_output_cmd_valid = memory_arbiter_io_output_valid;
  assign io_output_cmd_payload_last = memory_arbiter_io_output_payload_last;
  assign io_output_cmd_payload_fragment_opcode = memory_arbiter_io_output_payload_fragment_opcode;
  assign io_output_cmd_payload_fragment_address = memory_arbiter_io_output_payload_fragment_address;
  assign io_output_cmd_payload_fragment_length = memory_arbiter_io_output_payload_fragment_length;
  assign io_output_cmd_payload_fragment_data = memory_arbiter_io_output_payload_fragment_data;
  assign io_output_cmd_payload_fragment_mask = memory_arbiter_io_output_payload_fragment_mask;
  assign io_output_cmd_payload_fragment_context = memory_arbiter_io_output_payload_fragment_context;
  assign io_output_cmd_payload_fragment_source = _zz_6[1:0];
  assign memory_rspSel = io_output_rsp_payload_fragment_source[0 : 0];
  assign io_inputs_0_rsp_valid = (io_output_rsp_valid && (memory_rspSel == 1'b0));
  assign io_inputs_0_rsp_payload_last = io_output_rsp_payload_last;
  assign io_inputs_0_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_inputs_0_rsp_payload_fragment_context = io_output_rsp_payload_fragment_context[1:0];
  assign io_inputs_1_rsp_valid = (io_output_rsp_valid && (memory_rspSel == 1'b1));
  assign io_inputs_1_rsp_payload_last = io_output_rsp_payload_last;
  assign io_inputs_1_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_inputs_1_rsp_payload_fragment_context = io_output_rsp_payload_fragment_context;
  assign io_inputs_1_rsp_payload_fragment_source = (io_output_rsp_payload_fragment_source >>> 1);
  assign io_output_rsp_ready = _zz_5;

endmodule

module dma_socRuby_BmbArbiter (
  input               io_inputs_0_cmd_valid,
  output              io_inputs_0_cmd_ready,
  input               io_inputs_0_cmd_payload_last,
  input      [0:0]    io_inputs_0_cmd_payload_fragment_opcode,
  input      [31:0]   io_inputs_0_cmd_payload_fragment_address,
  input      [4:0]    io_inputs_0_cmd_payload_fragment_length,
  input      [1:0]    io_inputs_0_cmd_payload_fragment_context,
  output              io_inputs_0_rsp_valid,
  input               io_inputs_0_rsp_ready,
  output              io_inputs_0_rsp_payload_last,
  output     [0:0]    io_inputs_0_rsp_payload_fragment_opcode,
  output     [127:0]  io_inputs_0_rsp_payload_fragment_data,
  output     [1:0]    io_inputs_0_rsp_payload_fragment_context,
  input               io_inputs_1_cmd_valid,
  output              io_inputs_1_cmd_ready,
  input               io_inputs_1_cmd_payload_last,
  input      [0:0]    io_inputs_1_cmd_payload_fragment_source,
  input      [0:0]    io_inputs_1_cmd_payload_fragment_opcode,
  input      [31:0]   io_inputs_1_cmd_payload_fragment_address,
  input      [11:0]   io_inputs_1_cmd_payload_fragment_length,
  input      [21:0]   io_inputs_1_cmd_payload_fragment_context,
  output              io_inputs_1_rsp_valid,
  input               io_inputs_1_rsp_ready,
  output              io_inputs_1_rsp_payload_last,
  output     [0:0]    io_inputs_1_rsp_payload_fragment_source,
  output     [0:0]    io_inputs_1_rsp_payload_fragment_opcode,
  output     [127:0]  io_inputs_1_rsp_payload_fragment_data,
  output     [21:0]   io_inputs_1_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [1:0]    io_output_cmd_payload_fragment_source,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [11:0]   io_output_cmd_payload_fragment_length,
  output     [21:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [1:0]    io_output_rsp_payload_fragment_source,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [127:0]  io_output_rsp_payload_fragment_data,
  input      [21:0]   io_output_rsp_payload_fragment_context,
  input               clk,
  input               reset
);
  wire       [1:0]    _zz_1;
  wire       [11:0]   _zz_2;
  wire       [21:0]   _zz_3;
  wire       [1:0]    _zz_4;
  reg                 _zz_5;
  wire                memory_arbiter_io_inputs_0_ready;
  wire                memory_arbiter_io_inputs_1_ready;
  wire                memory_arbiter_io_output_valid;
  wire                memory_arbiter_io_output_payload_last;
  wire       [1:0]    memory_arbiter_io_output_payload_fragment_source;
  wire       [0:0]    memory_arbiter_io_output_payload_fragment_opcode;
  wire       [31:0]   memory_arbiter_io_output_payload_fragment_address;
  wire       [11:0]   memory_arbiter_io_output_payload_fragment_length;
  wire       [21:0]   memory_arbiter_io_output_payload_fragment_context;
  wire       [0:0]    memory_arbiter_io_chosen;
  wire       [1:0]    memory_arbiter_io_chosenOH;
  wire       [2:0]    _zz_6;
  wire       [0:0]    memory_rspSel;

  assign _zz_6 = {memory_arbiter_io_output_payload_fragment_source,memory_arbiter_io_chosen};
  dma_socRuby_StreamArbiter memory_arbiter (
    .io_inputs_0_valid                       (io_inputs_0_cmd_valid                                    ), //i
    .io_inputs_0_ready                       (memory_arbiter_io_inputs_0_ready                         ), //o
    .io_inputs_0_payload_last                (io_inputs_0_cmd_payload_last                             ), //i
    .io_inputs_0_payload_fragment_source     (_zz_1[1:0]                                               ), //i
    .io_inputs_0_payload_fragment_opcode     (io_inputs_0_cmd_payload_fragment_opcode                  ), //i
    .io_inputs_0_payload_fragment_address    (io_inputs_0_cmd_payload_fragment_address[31:0]           ), //i
    .io_inputs_0_payload_fragment_length     (_zz_2[11:0]                                              ), //i
    .io_inputs_0_payload_fragment_context    (_zz_3[21:0]                                              ), //i
    .io_inputs_1_valid                       (io_inputs_1_cmd_valid                                    ), //i
    .io_inputs_1_ready                       (memory_arbiter_io_inputs_1_ready                         ), //o
    .io_inputs_1_payload_last                (io_inputs_1_cmd_payload_last                             ), //i
    .io_inputs_1_payload_fragment_source     (_zz_4[1:0]                                               ), //i
    .io_inputs_1_payload_fragment_opcode     (io_inputs_1_cmd_payload_fragment_opcode                  ), //i
    .io_inputs_1_payload_fragment_address    (io_inputs_1_cmd_payload_fragment_address[31:0]           ), //i
    .io_inputs_1_payload_fragment_length     (io_inputs_1_cmd_payload_fragment_length[11:0]            ), //i
    .io_inputs_1_payload_fragment_context    (io_inputs_1_cmd_payload_fragment_context[21:0]           ), //i
    .io_output_valid                         (memory_arbiter_io_output_valid                           ), //o
    .io_output_ready                         (io_output_cmd_ready                                      ), //i
    .io_output_payload_last                  (memory_arbiter_io_output_payload_last                    ), //o
    .io_output_payload_fragment_source       (memory_arbiter_io_output_payload_fragment_source[1:0]    ), //o
    .io_output_payload_fragment_opcode       (memory_arbiter_io_output_payload_fragment_opcode         ), //o
    .io_output_payload_fragment_address      (memory_arbiter_io_output_payload_fragment_address[31:0]  ), //o
    .io_output_payload_fragment_length       (memory_arbiter_io_output_payload_fragment_length[11:0]   ), //o
    .io_output_payload_fragment_context      (memory_arbiter_io_output_payload_fragment_context[21:0]  ), //o
    .io_chosen                               (memory_arbiter_io_chosen                                 ), //o
    .io_chosenOH                             (memory_arbiter_io_chosenOH[1:0]                          ), //o
    .clk                                     (clk                                                      ), //i
    .reset                                   (reset                                                    )  //i
  );
  always @(*) begin
    case(memory_rspSel)
      1'b0 : begin
        _zz_5 = io_inputs_0_rsp_ready;
      end
      default : begin
        _zz_5 = io_inputs_1_rsp_ready;
      end
    endcase
  end

  assign io_inputs_0_cmd_ready = memory_arbiter_io_inputs_0_ready;
  assign _zz_1 = 2'b00;
  assign _zz_2 = {7'd0, io_inputs_0_cmd_payload_fragment_length};
  assign _zz_3 = {20'd0, io_inputs_0_cmd_payload_fragment_context};
  assign io_inputs_1_cmd_ready = memory_arbiter_io_inputs_1_ready;
  assign _zz_4 = {1'd0, io_inputs_1_cmd_payload_fragment_source};
  assign io_output_cmd_valid = memory_arbiter_io_output_valid;
  assign io_output_cmd_payload_last = memory_arbiter_io_output_payload_last;
  assign io_output_cmd_payload_fragment_opcode = memory_arbiter_io_output_payload_fragment_opcode;
  assign io_output_cmd_payload_fragment_address = memory_arbiter_io_output_payload_fragment_address;
  assign io_output_cmd_payload_fragment_length = memory_arbiter_io_output_payload_fragment_length;
  assign io_output_cmd_payload_fragment_context = memory_arbiter_io_output_payload_fragment_context;
  assign io_output_cmd_payload_fragment_source = _zz_6[1:0];
  assign memory_rspSel = io_output_rsp_payload_fragment_source[0 : 0];
  assign io_inputs_0_rsp_valid = (io_output_rsp_valid && (memory_rspSel == 1'b0));
  assign io_inputs_0_rsp_payload_last = io_output_rsp_payload_last;
  assign io_inputs_0_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_inputs_0_rsp_payload_fragment_data = io_output_rsp_payload_fragment_data;
  assign io_inputs_0_rsp_payload_fragment_context = io_output_rsp_payload_fragment_context[1:0];
  assign io_inputs_1_rsp_valid = (io_output_rsp_valid && (memory_rspSel == 1'b1));
  assign io_inputs_1_rsp_payload_last = io_output_rsp_payload_last;
  assign io_inputs_1_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_inputs_1_rsp_payload_fragment_data = io_output_rsp_payload_fragment_data;
  assign io_inputs_1_rsp_payload_fragment_context = io_output_rsp_payload_fragment_context;
  assign io_inputs_1_rsp_payload_fragment_source = (io_output_rsp_payload_fragment_source >>> 1);
  assign io_output_rsp_ready = _zz_5;

endmodule

module dma_socRuby_BufferCC_11 (
  input      [3:0]    io_dataIn,
  output     [3:0]    io_dataOut,
  input               ctrl_clk,
  input               ctrl_reset
);
  (* async_reg *) reg        [3:0]    buffers_0;
  (* async_reg *) reg        [3:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge ctrl_clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module dma_socRuby_Apb3CC (
  input      [13:0]   io_input_PADDR,
  input      [0:0]    io_input_PSEL,
  input               io_input_PENABLE,
  output              io_input_PREADY,
  input               io_input_PWRITE,
  input      [31:0]   io_input_PWDATA,
  output     [31:0]   io_input_PRDATA,
  output              io_input_PSLVERROR,
  output     [13:0]   io_output_PADDR,
  output reg [0:0]    io_output_PSEL,
  output reg          io_output_PENABLE,
  input               io_output_PREADY,
  output              io_output_PWRITE,
  output     [31:0]   io_output_PWDATA,
  input      [31:0]   io_output_PRDATA,
  input               io_output_PSLVERROR,
  input               ctrl_clk,
  input               ctrl_reset,
  input               clk,
  input               reset
);
  reg                 _zz_1;
  wire                streamCCByToggle_io_input_ready;
  wire                streamCCByToggle_io_output_valid;
  wire       [13:0]   streamCCByToggle_io_output_payload_PADDR;
  wire                streamCCByToggle_io_output_payload_PWRITE;
  wire       [31:0]   streamCCByToggle_io_output_payload_PWDATA;
  wire                flowCCByToggle_io_output_valid;
  wire       [31:0]   flowCCByToggle_io_output_payload_PRDATA;
  wire                flowCCByToggle_io_output_payload_PSLVERROR;
  wire                _zz_2;
  wire                inputLogic_inputCmd_valid;
  wire                inputLogic_inputCmd_ready;
  wire       [13:0]   inputLogic_inputCmd_payload_PADDR;
  wire                inputLogic_inputCmd_payload_PWRITE;
  wire       [31:0]   inputLogic_inputCmd_payload_PWDATA;
  wire                inputLogic_inputRsp_valid;
  wire       [31:0]   inputLogic_inputRsp_payload_PRDATA;
  wire                inputLogic_inputRsp_payload_PSLVERROR;
  reg                 inputLogic_state;
  reg                 outputLogic_state;
  wire                outputLogic_outputRsp_valid;
  wire       [31:0]   outputLogic_outputRsp_payload_PRDATA;
  wire                outputLogic_outputRsp_payload_PSLVERROR;

  assign _zz_2 = (! outputLogic_state);
  dma_socRuby_StreamCCByToggle streamCCByToggle (
    .io_input_valid              (inputLogic_inputCmd_valid                        ), //i
    .io_input_ready              (streamCCByToggle_io_input_ready                  ), //o
    .io_input_payload_PADDR      (inputLogic_inputCmd_payload_PADDR[13:0]          ), //i
    .io_input_payload_PWRITE     (inputLogic_inputCmd_payload_PWRITE               ), //i
    .io_input_payload_PWDATA     (inputLogic_inputCmd_payload_PWDATA[31:0]         ), //i
    .io_output_valid             (streamCCByToggle_io_output_valid                 ), //o
    .io_output_ready             (_zz_1                                            ), //i
    .io_output_payload_PADDR     (streamCCByToggle_io_output_payload_PADDR[13:0]   ), //o
    .io_output_payload_PWRITE    (streamCCByToggle_io_output_payload_PWRITE        ), //o
    .io_output_payload_PWDATA    (streamCCByToggle_io_output_payload_PWDATA[31:0]  ), //o
    .ctrl_clk                    (ctrl_clk                                         ), //i
    .ctrl_reset                  (ctrl_reset                                       ), //i
    .clk                         (clk                                              ), //i
    .reset                       (reset                                            )  //i
  );
  dma_socRuby_FlowCCByToggle flowCCByToggle (
    .io_input_valid                 (outputLogic_outputRsp_valid                    ), //i
    .io_input_payload_PRDATA        (outputLogic_outputRsp_payload_PRDATA[31:0]     ), //i
    .io_input_payload_PSLVERROR     (outputLogic_outputRsp_payload_PSLVERROR        ), //i
    .io_output_valid                (flowCCByToggle_io_output_valid                 ), //o
    .io_output_payload_PRDATA       (flowCCByToggle_io_output_payload_PRDATA[31:0]  ), //o
    .io_output_payload_PSLVERROR    (flowCCByToggle_io_output_payload_PSLVERROR     ), //o
    .clk                            (clk                                            ), //i
    .reset                          (reset                                          ), //i
    .ctrl_clk                       (ctrl_clk                                       ), //i
    .ctrl_reset                     (ctrl_reset                                     )  //i
  );
  assign inputLogic_inputCmd_valid = ((io_input_PSEL[0] && io_input_PENABLE) && (! inputLogic_state));
  assign inputLogic_inputCmd_payload_PADDR = io_input_PADDR;
  assign inputLogic_inputCmd_payload_PWRITE = io_input_PWRITE;
  assign inputLogic_inputCmd_payload_PWDATA = io_input_PWDATA;
  assign io_input_PREADY = inputLogic_inputRsp_valid;
  assign io_input_PRDATA = inputLogic_inputRsp_payload_PRDATA;
  assign io_input_PSLVERROR = inputLogic_inputRsp_payload_PSLVERROR;
  assign inputLogic_inputCmd_ready = streamCCByToggle_io_input_ready;
  always @ (*) begin
    io_output_PENABLE = 1'b0;
    if(streamCCByToggle_io_output_valid)begin
      if(_zz_2)begin
        io_output_PENABLE = 1'b0;
      end else begin
        io_output_PENABLE = 1'b1;
      end
    end
  end

  always @ (*) begin
    io_output_PSEL = 1'b0;
    if(streamCCByToggle_io_output_valid)begin
      io_output_PSEL = 1'b1;
    end
  end

  assign io_output_PADDR = streamCCByToggle_io_output_payload_PADDR;
  assign io_output_PWDATA = streamCCByToggle_io_output_payload_PWDATA;
  assign io_output_PWRITE = streamCCByToggle_io_output_payload_PWRITE;
  always @ (*) begin
    _zz_1 = 1'b0;
    if(streamCCByToggle_io_output_valid)begin
      if(! _zz_2) begin
        if(io_output_PREADY)begin
          _zz_1 = 1'b1;
        end
      end
    end
  end

  assign outputLogic_outputRsp_valid = (streamCCByToggle_io_output_valid && _zz_1);
  assign outputLogic_outputRsp_payload_PRDATA = io_output_PRDATA;
  assign outputLogic_outputRsp_payload_PSLVERROR = io_output_PSLVERROR;
  assign inputLogic_inputRsp_valid = flowCCByToggle_io_output_valid;
  assign inputLogic_inputRsp_payload_PRDATA = flowCCByToggle_io_output_payload_PRDATA;
  assign inputLogic_inputRsp_payload_PSLVERROR = flowCCByToggle_io_output_payload_PSLVERROR;
  always @ (posedge ctrl_clk) begin
    if(ctrl_reset) begin
      inputLogic_state <= 1'b0;
    end else begin
      if((inputLogic_inputCmd_valid && inputLogic_inputCmd_ready))begin
        inputLogic_state <= 1'b1;
      end
      if(inputLogic_inputRsp_valid)begin
        inputLogic_state <= 1'b0;
      end
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      outputLogic_state <= 1'b0;
    end else begin
      if(streamCCByToggle_io_output_valid)begin
        if(_zz_2)begin
          outputLogic_state <= 1'b1;
        end else begin
          if(io_output_PREADY)begin
            outputLogic_state <= 1'b0;
          end
        end
      end
    end
  end


endmodule

module dma_socRuby_Core (
  output              io_sgRead_cmd_valid,
  input               io_sgRead_cmd_ready,
  output              io_sgRead_cmd_payload_last,
  output     [0:0]    io_sgRead_cmd_payload_fragment_opcode,
  output     [31:0]   io_sgRead_cmd_payload_fragment_address,
  output     [4:0]    io_sgRead_cmd_payload_fragment_length,
  output     [1:0]    io_sgRead_cmd_payload_fragment_context,
  input               io_sgRead_rsp_valid,
  output              io_sgRead_rsp_ready,
  input               io_sgRead_rsp_payload_last,
  input      [0:0]    io_sgRead_rsp_payload_fragment_opcode,
  input      [127:0]  io_sgRead_rsp_payload_fragment_data,
  input      [1:0]    io_sgRead_rsp_payload_fragment_context,
  output              io_sgWrite_cmd_valid,
  input               io_sgWrite_cmd_ready,
  output              io_sgWrite_cmd_payload_last,
  output     [0:0]    io_sgWrite_cmd_payload_fragment_opcode,
  output     [31:0]   io_sgWrite_cmd_payload_fragment_address,
  output     [1:0]    io_sgWrite_cmd_payload_fragment_length,
  output reg [127:0]  io_sgWrite_cmd_payload_fragment_data,
  output reg [15:0]   io_sgWrite_cmd_payload_fragment_mask,
  output     [1:0]    io_sgWrite_cmd_payload_fragment_context,
  input               io_sgWrite_rsp_valid,
  output              io_sgWrite_rsp_ready,
  input               io_sgWrite_rsp_payload_last,
  input      [0:0]    io_sgWrite_rsp_payload_fragment_opcode,
  input      [1:0]    io_sgWrite_rsp_payload_fragment_context,
  output reg          io_read_cmd_valid,
  input               io_read_cmd_ready,
  output              io_read_cmd_payload_last,
  output     [0:0]    io_read_cmd_payload_fragment_source,
  output     [0:0]    io_read_cmd_payload_fragment_opcode,
  output     [31:0]   io_read_cmd_payload_fragment_address,
  output     [11:0]   io_read_cmd_payload_fragment_length,
  output     [21:0]   io_read_cmd_payload_fragment_context,
  input               io_read_rsp_valid,
  output              io_read_rsp_ready,
  input               io_read_rsp_payload_last,
  input      [0:0]    io_read_rsp_payload_fragment_source,
  input      [0:0]    io_read_rsp_payload_fragment_opcode,
  input      [127:0]  io_read_rsp_payload_fragment_data,
  input      [21:0]   io_read_rsp_payload_fragment_context,
  output              io_write_cmd_valid,
  input               io_write_cmd_ready,
  output              io_write_cmd_payload_last,
  output     [0:0]    io_write_cmd_payload_fragment_source,
  output     [0:0]    io_write_cmd_payload_fragment_opcode,
  output     [31:0]   io_write_cmd_payload_fragment_address,
  output     [11:0]   io_write_cmd_payload_fragment_length,
  output     [127:0]  io_write_cmd_payload_fragment_data,
  output     [15:0]   io_write_cmd_payload_fragment_mask,
  output     [13:0]   io_write_cmd_payload_fragment_context,
  input               io_write_rsp_valid,
  output              io_write_rsp_ready,
  input               io_write_rsp_payload_last,
  input      [0:0]    io_write_rsp_payload_fragment_source,
  input      [0:0]    io_write_rsp_payload_fragment_opcode,
  input      [13:0]   io_write_rsp_payload_fragment_context,
  output              io_outputs_0_valid,
  input               io_outputs_0_ready,
  output     [127:0]  io_outputs_0_payload_data,
  output     [15:0]   io_outputs_0_payload_mask,
  output     [3:0]    io_outputs_0_payload_sink,
  output              io_outputs_0_payload_last,
  output              io_outputs_1_valid,
  input               io_outputs_1_ready,
  output     [127:0]  io_outputs_1_payload_data,
  output     [15:0]   io_outputs_1_payload_mask,
  output     [3:0]    io_outputs_1_payload_sink,
  output              io_outputs_1_payload_last,
  input               io_inputs_0_valid,
  output reg          io_inputs_0_ready,
  input      [127:0]  io_inputs_0_payload_data,
  input      [15:0]   io_inputs_0_payload_mask,
  input      [3:0]    io_inputs_0_payload_sink,
  input               io_inputs_0_payload_last,
  input               io_inputs_1_valid,
  output reg          io_inputs_1_ready,
  input      [127:0]  io_inputs_1_payload_data,
  input      [15:0]   io_inputs_1_payload_mask,
  input      [3:0]    io_inputs_1_payload_sink,
  input               io_inputs_1_payload_last,
  output reg [3:0]    io_interrupts,
  input      [13:0]   io_ctrl_PADDR,
  input      [0:0]    io_ctrl_PSEL,
  input               io_ctrl_PENABLE,
  output              io_ctrl_PREADY,
  input               io_ctrl_PWRITE,
  input      [31:0]   io_ctrl_PWDATA,
  output reg [31:0]   io_ctrl_PRDATA,
  output              io_ctrl_PSLVERROR,
  input               clk,
  input               reset
);
  wire       [8:0]    _zz_120;
  wire       [7:0]    _zz_121;
  wire       [8:0]    _zz_122;
  wire       [7:0]    _zz_123;
  wire       [8:0]    _zz_124;
  reg        [15:0]   _zz_125;
  wire       [7:0]    _zz_126;
  wire                _zz_127;
  wire       [8:0]    _zz_128;
  wire       [2:0]    _zz_129;
  wire                _zz_130;
  wire       [8:0]    _zz_131;
  wire       [2:0]    _zz_132;
  wire       [8:0]    _zz_133;
  wire       [10:0]   _zz_134;
  wire                _zz_135;
  wire       [15:0]   _zz_136;
  wire                _zz_137;
  wire                _zz_138;
  wire       [3:0]    _zz_139;
  reg        [4:0]    _zz_140;
  reg        [4:0]    _zz_141;
  reg        [4:0]    _zz_142;
  reg        [4:0]    _zz_143;
  reg        [4:0]    _zz_144;
  reg        [4:0]    _zz_145;
  reg        [4:0]    _zz_146;
  reg        [4:0]    _zz_147;
  reg        [4:0]    _zz_148;
  reg        [4:0]    _zz_149;
  reg        [4:0]    _zz_150;
  reg        [4:0]    _zz_151;
  reg        [1:0]    _zz_152;
  reg                 _zz_153;
  reg        [31:0]   _zz_154;
  reg        [25:0]   _zz_155;
  reg        [11:0]   _zz_156;
  reg        [9:0]    _zz_157;
  reg        [1:0]    _zz_158;
  reg                 _zz_159;
  reg        [31:0]   _zz_160;
  reg        [9:0]    _zz_161;
  reg        [9:0]    _zz_162;
  reg        [11:0]   _zz_163;
  reg        [13:0]   _zz_164;
  reg                 _zz_165;
  reg                 _zz_166;
  reg        [26:0]   _zz_167;
  reg        [9:0]    _zz_168;
  reg        [3:0]    _zz_169;
  reg                 _zz_170;
  reg                 _zz_171;
  reg        [31:0]   _zz_172;
  reg        [31:0]   _zz_173;
  reg                 _zz_174;
  wire                memory_core_io_writes_0_cmd_ready;
  wire                memory_core_io_writes_0_rsp_valid;
  wire       [7:0]    memory_core_io_writes_0_rsp_payload_context;
  wire                memory_core_io_writes_1_cmd_ready;
  wire                memory_core_io_writes_1_rsp_valid;
  wire       [7:0]    memory_core_io_writes_1_rsp_payload_context;
  wire                memory_core_io_writes_2_cmd_ready;
  wire                memory_core_io_writes_2_rsp_valid;
  wire       [7:0]    memory_core_io_writes_2_rsp_payload_context;
  wire                memory_core_io_reads_0_cmd_ready;
  wire                memory_core_io_reads_0_rsp_valid;
  wire       [127:0]  memory_core_io_reads_0_rsp_payload_data;
  wire       [15:0]   memory_core_io_reads_0_rsp_payload_mask;
  wire       [2:0]    memory_core_io_reads_0_rsp_payload_context;
  wire                memory_core_io_reads_1_cmd_ready;
  wire                memory_core_io_reads_1_rsp_valid;
  wire       [127:0]  memory_core_io_reads_1_rsp_payload_data;
  wire       [15:0]   memory_core_io_reads_1_rsp_payload_mask;
  wire       [2:0]    memory_core_io_reads_1_rsp_payload_context;
  wire                memory_core_io_reads_2_cmd_ready;
  wire                memory_core_io_reads_2_rsp_valid;
  wire       [127:0]  memory_core_io_reads_2_rsp_payload_data;
  wire       [15:0]   memory_core_io_reads_2_rsp_payload_mask;
  wire       [10:0]   memory_core_io_reads_2_rsp_payload_context;
  wire                b2m_fsm_aggregate_engine_io_input_ready;
  wire       [127:0]  b2m_fsm_aggregate_engine_io_output_data;
  wire       [15:0]   b2m_fsm_aggregate_engine_io_output_mask;
  wire                b2m_fsm_aggregate_engine_io_output_consumed;
  wire       [3:0]    b2m_fsm_aggregate_engine_io_output_usedUntil;
  wire                _zz_175;
  wire                _zz_176;
  wire                _zz_177;
  wire                _zz_178;
  wire                _zz_179;
  wire                _zz_180;
  wire                _zz_181;
  wire                _zz_182;
  wire                _zz_183;
  wire                _zz_184;
  wire                _zz_185;
  wire                _zz_186;
  wire                _zz_187;
  wire                _zz_188;
  wire                _zz_189;
  wire                _zz_190;
  wire                _zz_191;
  wire                _zz_192;
  wire                _zz_193;
  wire                _zz_194;
  wire                _zz_195;
  wire                _zz_196;
  wire                _zz_197;
  wire                _zz_198;
  wire                _zz_199;
  wire                _zz_200;
  wire                _zz_201;
  wire                _zz_202;
  wire                _zz_203;
  wire                _zz_204;
  wire                _zz_205;
  wire                _zz_206;
  wire                _zz_207;
  wire                _zz_208;
  wire                _zz_209;
  wire                _zz_210;
  wire                _zz_211;
  wire                _zz_212;
  wire                _zz_213;
  wire                _zz_214;
  wire       [26:0]   _zz_215;
  wire       [26:0]   _zz_216;
  wire       [13:0]   _zz_217;
  wire       [13:0]   _zz_218;
  wire       [13:0]   _zz_219;
  wire       [8:0]    _zz_220;
  wire       [9:0]    _zz_221;
  wire       [3:0]    _zz_222;
  wire       [0:0]    _zz_223;
  wire       [3:0]    _zz_224;
  wire       [0:0]    _zz_225;
  wire       [3:0]    _zz_226;
  wire       [26:0]   _zz_227;
  wire       [31:0]   _zz_228;
  wire       [31:0]   _zz_229;
  wire       [9:0]    _zz_230;
  wire       [13:0]   _zz_231;
  wire       [3:0]    _zz_232;
  wire       [0:0]    _zz_233;
  wire       [3:0]    _zz_234;
  wire       [0:0]    _zz_235;
  wire       [3:0]    _zz_236;
  wire       [7:0]    _zz_237;
  wire       [9:0]    _zz_238;
  wire       [25:0]   _zz_239;
  wire       [31:0]   _zz_240;
  wire       [31:0]   _zz_241;
  wire       [9:0]    _zz_242;
  wire       [26:0]   _zz_243;
  wire       [26:0]   _zz_244;
  wire       [13:0]   _zz_245;
  wire       [13:0]   _zz_246;
  wire       [13:0]   _zz_247;
  wire       [8:0]    _zz_248;
  wire       [9:0]    _zz_249;
  wire       [3:0]    _zz_250;
  wire       [0:0]    _zz_251;
  wire       [3:0]    _zz_252;
  wire       [0:0]    _zz_253;
  wire       [3:0]    _zz_254;
  wire       [26:0]   _zz_255;
  wire       [31:0]   _zz_256;
  wire       [31:0]   _zz_257;
  wire       [9:0]    _zz_258;
  wire       [13:0]   _zz_259;
  wire       [3:0]    _zz_260;
  wire       [0:0]    _zz_261;
  wire       [3:0]    _zz_262;
  wire       [0:0]    _zz_263;
  wire       [3:0]    _zz_264;
  wire       [7:0]    _zz_265;
  wire       [9:0]    _zz_266;
  wire       [25:0]   _zz_267;
  wire       [31:0]   _zz_268;
  wire       [31:0]   _zz_269;
  wire       [9:0]    _zz_270;
  wire       [4:0]    _zz_271;
  wire       [4:0]    _zz_272;
  wire       [4:0]    _zz_273;
  wire       [4:0]    _zz_274;
  wire       [0:0]    _zz_275;
  wire       [2:0]    _zz_276;
  wire       [0:0]    _zz_277;
  wire       [0:0]    _zz_278;
  wire       [4:0]    _zz_279;
  wire       [4:0]    _zz_280;
  wire       [4:0]    _zz_281;
  wire       [4:0]    _zz_282;
  wire       [0:0]    _zz_283;
  wire       [2:0]    _zz_284;
  wire       [0:0]    _zz_285;
  wire       [0:0]    _zz_286;
  wire       [0:0]    _zz_287;
  wire       [0:0]    _zz_288;
  wire       [0:0]    _zz_289;
  wire       [0:0]    _zz_290;
  wire       [3:0]    _zz_291;
  wire       [1:0]    _zz_292;
  wire       [3:0]    _zz_293;
  wire       [25:0]   _zz_294;
  wire       [25:0]   _zz_295;
  wire       [25:0]   _zz_296;
  wire       [25:0]   _zz_297;
  wire       [31:0]   _zz_298;
  wire       [31:0]   _zz_299;
  wire       [31:0]   _zz_300;
  wire       [31:0]   _zz_301;
  wire       [25:0]   _zz_302;
  wire       [25:0]   _zz_303;
  wire       [12:0]   _zz_304;
  wire       [11:0]   _zz_305;
  wire       [3:0]    _zz_306;
  wire       [11:0]   _zz_307;
  wire       [1:0]    _zz_308;
  wire       [12:0]   _zz_309;
  wire       [0:0]    _zz_310;
  wire       [0:0]    _zz_311;
  wire       [0:0]    _zz_312;
  wire       [3:0]    _zz_313;
  wire       [1:0]    _zz_314;
  wire       [3:0]    _zz_315;
  wire       [31:0]   _zz_316;
  wire       [12:0]   _zz_317;
  wire       [26:0]   _zz_318;
  wire       [25:0]   _zz_319;
  wire       [25:0]   _zz_320;
  wire       [11:0]   _zz_321;
  wire       [25:0]   _zz_322;
  wire       [25:0]   _zz_323;
  wire       [25:0]   _zz_324;
  wire       [13:0]   _zz_325;
  wire       [13:0]   _zz_326;
  wire       [11:0]   _zz_327;
  wire       [3:0]    _zz_328;
  wire       [11:0]   _zz_329;
  wire       [9:0]    _zz_330;
  wire       [0:0]    _zz_331;
  wire       [3:0]    _zz_332;
  wire       [0:0]    _zz_333;
  wire       [3:0]    _zz_334;
  wire       [0:0]    _zz_335;
  wire       [0:0]    _zz_336;
  wire       [0:0]    _zz_337;
  wire       [0:0]    _zz_338;
  wire       [0:0]    _zz_339;
  wire       [0:0]    _zz_340;
  wire       [0:0]    _zz_341;
  wire       [0:0]    _zz_342;
  wire       [0:0]    _zz_343;
  wire       [0:0]    _zz_344;
  wire       [0:0]    _zz_345;
  wire       [0:0]    _zz_346;
  wire       [0:0]    _zz_347;
  wire       [0:0]    _zz_348;
  wire       [0:0]    _zz_349;
  wire       [0:0]    _zz_350;
  wire       [0:0]    _zz_351;
  wire       [0:0]    _zz_352;
  wire       [0:0]    _zz_353;
  wire       [0:0]    _zz_354;
  wire       [0:0]    _zz_355;
  wire       [0:0]    _zz_356;
  wire       [0:0]    _zz_357;
  wire       [0:0]    _zz_358;
  wire       [0:0]    _zz_359;
  wire       [0:0]    _zz_360;
  wire       [0:0]    _zz_361;
  wire       [0:0]    _zz_362;
  wire       [0:0]    _zz_363;
  wire       [0:0]    _zz_364;
  wire       [0:0]    _zz_365;
  wire       [0:0]    _zz_366;
  wire       [0:0]    _zz_367;
  wire       [0:0]    _zz_368;
  wire       [0:0]    _zz_369;
  wire       [0:0]    _zz_370;
  wire       [0:0]    _zz_371;
  wire       [0:0]    _zz_372;
  wire       [0:0]    _zz_373;
  wire       [0:0]    _zz_374;
  wire       [0:0]    _zz_375;
  wire       [0:0]    _zz_376;
  wire       [0:0]    _zz_377;
  wire       [0:0]    _zz_378;
  wire       [0:0]    _zz_379;
  wire       [0:0]    _zz_380;
  wire       [0:0]    _zz_381;
  wire       [0:0]    _zz_382;
  wire       [0:0]    _zz_383;
  wire       [0:0]    _zz_384;
  wire       [0:0]    _zz_385;
  wire       [0:0]    _zz_386;
  wire       [0:0]    _zz_387;
  wire       [0:0]    _zz_388;
  wire       [0:0]    _zz_389;
  wire       [0:0]    _zz_390;
  wire       [0:0]    _zz_391;
  wire       [0:0]    _zz_392;
  wire       [0:0]    _zz_393;
  wire       [0:0]    _zz_394;
  wire       [0:0]    _zz_395;
  wire       [0:0]    _zz_396;
  wire       [0:0]    _zz_397;
  wire       [0:0]    _zz_398;
  wire       [0:0]    _zz_399;
  wire       [0:0]    _zz_400;
  wire       [0:0]    _zz_401;
  wire       [0:0]    _zz_402;
  wire       [0:0]    _zz_403;
  wire       [31:0]   _zz_404;
  wire       [31:0]   _zz_405;
  wire       [0:0]    _zz_406;
  wire       [0:0]    _zz_407;
  wire       [0:0]    _zz_408;
  wire       [0:0]    _zz_409;
  wire       [0:0]    _zz_410;
  wire       [0:0]    _zz_411;
  wire       [0:0]    _zz_412;
  wire       [31:0]   _zz_413;
  wire       [31:0]   _zz_414;
  wire       [0:0]    _zz_415;
  wire       [0:0]    _zz_416;
  wire       [0:0]    _zz_417;
  wire       [0:0]    _zz_418;
  wire       [0:0]    _zz_419;
  wire       [0:0]    _zz_420;
  wire       [0:0]    _zz_421;
  wire       [0:0]    _zz_422;
  wire       [0:0]    _zz_423;
  wire       [0:0]    _zz_424;
  wire       [0:0]    _zz_425;
  wire       [31:0]   _zz_426;
  wire       [31:0]   _zz_427;
  wire       [0:0]    _zz_428;
  wire       [0:0]    _zz_429;
  wire       [0:0]    _zz_430;
  wire       [0:0]    _zz_431;
  wire       [0:0]    _zz_432;
  wire       [0:0]    _zz_433;
  wire       [0:0]    _zz_434;
  wire       [31:0]   _zz_435;
  wire       [31:0]   _zz_436;
  wire       [0:0]    _zz_437;
  wire       [0:0]    _zz_438;
  wire       [0:0]    _zz_439;
  wire       [0:0]    _zz_440;
  wire       [0:0]    _zz_441;
  wire       [0:0]    _zz_442;
  wire       [0:0]    _zz_443;
  wire       [0:0]    _zz_444;
  wire       [0:0]    _zz_445;
  wire       [9:0]    _zz_446;
  wire       [4:0]    _zz_447;
  wire       [13:0]   _zz_448;
  wire       [0:0]    _zz_449;
  wire       [9:0]    _zz_450;
  wire       [0:0]    _zz_451;
  wire       [9:0]    _zz_452;
  wire       [4:0]    _zz_453;
  wire       [13:0]   _zz_454;
  wire       [4:0]    _zz_455;
  wire       [0:0]    _zz_456;
  wire       [9:0]    _zz_457;
  wire       [0:0]    _zz_458;
  wire       [9:0]    _zz_459;
  wire       [4:0]    _zz_460;
  wire       [13:0]   _zz_461;
  wire       [0:0]    _zz_462;
  wire       [9:0]    _zz_463;
  wire       [0:0]    _zz_464;
  wire       [9:0]    _zz_465;
  wire       [4:0]    _zz_466;
  wire       [13:0]   _zz_467;
  wire       [4:0]    _zz_468;
  wire       [0:0]    _zz_469;
  wire       [9:0]    _zz_470;
  wire       [2:0]    _zz_471;
  wire       [2:0]    _zz_472;
  wire       [2:0]    _zz_473;
  wire       [2:0]    _zz_474;
  wire       [2:0]    _zz_475;
  wire       [2:0]    _zz_476;
  wire       [2:0]    _zz_477;
  wire       [2:0]    _zz_478;
  wire       [2:0]    _zz_479;
  wire       [2:0]    _zz_480;
  wire       [1:0]    _zz_481;
  wire       [1:0]    _zz_482;
  wire       [1:0]    _zz_483;
  wire       [1:0]    _zz_484;
  wire       [1:0]    _zz_485;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  reg                 channels_0_channelStart;
  reg                 channels_0_channelStop;
  reg                 channels_0_channelCompletion;
  reg                 channels_0_channelValid;
  reg                 channels_0_descriptorStart;
  reg                 channels_0_descriptorCompletion;
  reg                 channels_0_descriptorValid;
  reg        [25:0]   channels_0_bytes;
  reg        [1:0]    channels_0_priority;
  reg        [1:0]    channels_0_weight;
  reg                 channels_0_selfRestart;
  reg                 channels_0_readyToStop;
  reg        [26:0]   channels_0_bytesProbe_value;
  reg                 channels_0_bytesProbe_incr_valid;
  reg        [11:0]   channels_0_bytesProbe_incr_payload;
  reg                 channels_0_ctrl_kick;
  reg                 channels_0_ll_sgStart;
  reg                 channels_0_ll_valid;
  reg                 channels_0_ll_head;
  reg                 channels_0_ll_justASync;
  reg                 channels_0_ll_waitDone;
  reg                 channels_0_ll_readDone;
  reg                 channels_0_ll_writeDone;
  reg                 channels_0_ll_gotDescriptorStall;
  reg                 channels_0_ll_packet;
  reg                 channels_0_ll_requireSync;
  reg        [31:0]   channels_0_ll_ptr;
  reg        [31:0]   channels_0_ll_ptrNext;
  wire                channels_0_ll_requestLl;
  reg                 channels_0_ll_descriptorUpdated;
  wire       [9:0]    channels_0_fifo_base;
  wire       [9:0]    channels_0_fifo_words;
  reg        [9:0]    channels_0_fifo_push_available;
  wire       [9:0]    channels_0_fifo_push_availableDecr;
  reg        [9:0]    channels_0_fifo_push_ptr;
  wire       [9:0]    channels_0_fifo_push_ptrWithBase;
  wire       [9:0]    channels_0_fifo_push_ptrIncr_value;
  reg        [9:0]    channels_0_fifo_pop_ptr;
  wire       [13:0]   channels_0_fifo_pop_bytes;
  wire       [9:0]    channels_0_fifo_pop_ptrWithBase;
  wire       [13:0]   channels_0_fifo_pop_bytesIncr_value;
  wire       [13:0]   channels_0_fifo_pop_bytesDecr_value;
  wire                channels_0_fifo_pop_empty;
  wire       [9:0]    channels_0_fifo_pop_ptrIncr_value;
  reg        [13:0]   channels_0_fifo_pop_withOverride_backup;
  wire       [13:0]   channels_0_fifo_pop_withOverride_backupNext;
  reg                 channels_0_fifo_pop_withOverride_load;
  reg                 channels_0_fifo_pop_withOverride_unload;
  reg        [13:0]   channels_0_fifo_pop_withOverride_exposed;
  reg                 channels_0_fifo_pop_withOverride_valid;
  wire                channels_0_fifo_empty;
  reg                 channels_0_push_memory;
  reg                 channels_0_push_s2b_completionOnLast;
  reg                 channels_0_push_s2b_packetEvent;
  reg                 channels_0_push_s2b_packetLock;
  reg                 channels_0_push_s2b_waitFirst;
  reg                 channels_0_pop_memory;
  wire       [11:0]   channels_0_pop_b2m_bytePerBurst;
  reg                 channels_0_pop_b2m_fire;
  reg                 channels_0_pop_b2m_waitFinalRsp;
  reg                 channels_0_pop_b2m_flush;
  reg                 channels_0_pop_b2m_packetSync;
  reg                 channels_0_pop_b2m_packet;
  reg                 channels_0_pop_b2m_memRsp;
  reg        [3:0]    channels_0_pop_b2m_memPending;
  reg        [31:0]   channels_0_pop_b2m_address;
  reg        [26:0]   channels_0_pop_b2m_bytesLeft;
  wire                channels_0_pop_b2m_request;
  reg        [3:0]    channels_0_pop_b2m_bytesToSkip;
  reg        [13:0]   channels_0_pop_b2m_decrBytes;
  reg                 channels_0_pop_b2m_memPendingInc;
  wire                channels_0_readyForChannelCompletion;
  reg                 _zz_1;
  wire                channels_0_s2b_full;
  reg        [9:0]    channels_0_fifo_pop_ptrIncr_value_regNext;
  reg                 channels_0_interrupts_completion_enable;
  reg                 channels_0_interrupts_completion_valid;
  reg                 channels_0_interrupts_onChannelCompletion_enable;
  reg                 channels_0_interrupts_onChannelCompletion_valid;
  reg                 channels_0_interrupts_onLinkedListUpdate_enable;
  reg                 channels_0_interrupts_onLinkedListUpdate_valid;
  reg                 channels_0_interrupts_s2mPacket_enable;
  reg                 channels_0_interrupts_s2mPacket_valid;
  reg                 channels_1_channelStart;
  reg                 channels_1_channelStop;
  reg                 channels_1_channelCompletion;
  reg                 channels_1_channelValid;
  reg                 channels_1_descriptorStart;
  reg                 channels_1_descriptorCompletion;
  reg                 channels_1_descriptorValid;
  reg        [25:0]   channels_1_bytes;
  reg        [1:0]    channels_1_priority;
  reg        [1:0]    channels_1_weight;
  reg                 channels_1_selfRestart;
  reg                 channels_1_readyToStop;
  reg                 channels_1_ctrl_kick;
  reg                 channels_1_ll_sgStart;
  reg                 channels_1_ll_valid;
  reg                 channels_1_ll_head;
  reg                 channels_1_ll_justASync;
  reg                 channels_1_ll_waitDone;
  reg                 channels_1_ll_readDone;
  reg                 channels_1_ll_writeDone;
  reg                 channels_1_ll_gotDescriptorStall;
  reg                 channels_1_ll_packet;
  reg                 channels_1_ll_requireSync;
  reg        [31:0]   channels_1_ll_ptr;
  reg        [31:0]   channels_1_ll_ptrNext;
  wire                channels_1_ll_requestLl;
  reg                 channels_1_ll_descriptorUpdated;
  wire       [9:0]    channels_1_fifo_base;
  wire       [9:0]    channels_1_fifo_words;
  reg        [9:0]    channels_1_fifo_push_available;
  reg        [9:0]    channels_1_fifo_push_availableDecr;
  reg        [9:0]    channels_1_fifo_push_ptr;
  wire       [9:0]    channels_1_fifo_push_ptrWithBase;
  wire       [9:0]    channels_1_fifo_push_ptrIncr_value;
  reg        [9:0]    channels_1_fifo_pop_ptr;
  wire       [13:0]   channels_1_fifo_pop_bytes;
  wire       [9:0]    channels_1_fifo_pop_ptrWithBase;
  wire       [13:0]   channels_1_fifo_pop_bytesIncr_value;
  wire       [13:0]   channels_1_fifo_pop_bytesDecr_value;
  wire                channels_1_fifo_pop_empty;
  wire       [9:0]    channels_1_fifo_pop_ptrIncr_value;
  reg        [13:0]   channels_1_fifo_pop_withoutOverride_exposed;
  wire                channels_1_fifo_empty;
  reg                 channels_1_push_memory;
  reg        [31:0]   channels_1_push_m2b_address;
  wire       [11:0]   channels_1_push_m2b_bytePerBurst;
  reg                 channels_1_push_m2b_loadDone;
  reg        [25:0]   channels_1_push_m2b_bytesLeft;
  reg        [3:0]    channels_1_push_m2b_memPending;
  reg                 channels_1_push_m2b_memPendingIncr;
  reg                 channels_1_push_m2b_memPendingDecr;
  reg                 channels_1_push_m2b_loadRequest;
  reg                 channels_1_pop_memory;
  reg                 channels_1_pop_b2s_last;
  reg        [0:0]    channels_1_pop_b2s_portId;
  reg        [3:0]    channels_1_pop_b2s_sinkId;
  reg                 channels_1_pop_b2s_veryLastTrigger;
  reg                 channels_1_pop_b2s_veryLastValid;
  reg        [9:0]    channels_1_pop_b2s_veryLastPtr;
  reg                 channels_1_pop_b2s_veryLastEndPacket;
  reg                 channels_1_readyForChannelCompletion;
  reg                 _zz_2;
  wire                channels_1_s2b_full;
  reg        [9:0]    channels_1_fifo_pop_ptrIncr_value_regNext;
  reg                 channels_1_interrupts_completion_enable;
  reg                 channels_1_interrupts_completion_valid;
  reg                 channels_1_interrupts_onChannelCompletion_enable;
  reg                 channels_1_interrupts_onChannelCompletion_valid;
  reg                 channels_1_interrupts_onLinkedListUpdate_enable;
  reg                 channels_1_interrupts_onLinkedListUpdate_valid;
  reg                 channels_2_channelStart;
  reg                 channels_2_channelStop;
  reg                 channels_2_channelCompletion;
  reg                 channels_2_channelValid;
  reg                 channels_2_descriptorStart;
  reg                 channels_2_descriptorCompletion;
  reg                 channels_2_descriptorValid;
  reg        [25:0]   channels_2_bytes;
  reg        [1:0]    channels_2_priority;
  reg        [1:0]    channels_2_weight;
  reg                 channels_2_selfRestart;
  reg                 channels_2_readyToStop;
  reg        [26:0]   channels_2_bytesProbe_value;
  reg                 channels_2_bytesProbe_incr_valid;
  reg        [11:0]   channels_2_bytesProbe_incr_payload;
  reg                 channels_2_ctrl_kick;
  reg                 channels_2_ll_sgStart;
  reg                 channels_2_ll_valid;
  reg                 channels_2_ll_head;
  reg                 channels_2_ll_justASync;
  reg                 channels_2_ll_waitDone;
  reg                 channels_2_ll_readDone;
  reg                 channels_2_ll_writeDone;
  reg                 channels_2_ll_gotDescriptorStall;
  reg                 channels_2_ll_packet;
  reg                 channels_2_ll_requireSync;
  reg        [31:0]   channels_2_ll_ptr;
  reg        [31:0]   channels_2_ll_ptrNext;
  wire                channels_2_ll_requestLl;
  reg                 channels_2_ll_descriptorUpdated;
  wire       [9:0]    channels_2_fifo_base;
  wire       [9:0]    channels_2_fifo_words;
  reg        [9:0]    channels_2_fifo_push_available;
  wire       [9:0]    channels_2_fifo_push_availableDecr;
  reg        [9:0]    channels_2_fifo_push_ptr;
  wire       [9:0]    channels_2_fifo_push_ptrWithBase;
  wire       [9:0]    channels_2_fifo_push_ptrIncr_value;
  reg        [9:0]    channels_2_fifo_pop_ptr;
  wire       [13:0]   channels_2_fifo_pop_bytes;
  wire       [9:0]    channels_2_fifo_pop_ptrWithBase;
  wire       [13:0]   channels_2_fifo_pop_bytesIncr_value;
  wire       [13:0]   channels_2_fifo_pop_bytesDecr_value;
  wire                channels_2_fifo_pop_empty;
  wire       [9:0]    channels_2_fifo_pop_ptrIncr_value;
  reg        [13:0]   channels_2_fifo_pop_withOverride_backup;
  wire       [13:0]   channels_2_fifo_pop_withOverride_backupNext;
  reg                 channels_2_fifo_pop_withOverride_load;
  reg                 channels_2_fifo_pop_withOverride_unload;
  reg        [13:0]   channels_2_fifo_pop_withOverride_exposed;
  reg                 channels_2_fifo_pop_withOverride_valid;
  wire                channels_2_fifo_empty;
  reg                 channels_2_push_memory;
  reg                 channels_2_push_s2b_completionOnLast;
  reg                 channels_2_push_s2b_packetEvent;
  reg                 channels_2_push_s2b_packetLock;
  reg                 channels_2_push_s2b_waitFirst;
  reg                 channels_2_pop_memory;
  wire       [11:0]   channels_2_pop_b2m_bytePerBurst;
  reg                 channels_2_pop_b2m_fire;
  reg                 channels_2_pop_b2m_waitFinalRsp;
  reg                 channels_2_pop_b2m_flush;
  reg                 channels_2_pop_b2m_packetSync;
  reg                 channels_2_pop_b2m_packet;
  reg                 channels_2_pop_b2m_memRsp;
  reg        [3:0]    channels_2_pop_b2m_memPending;
  reg        [31:0]   channels_2_pop_b2m_address;
  reg        [26:0]   channels_2_pop_b2m_bytesLeft;
  wire                channels_2_pop_b2m_request;
  reg        [3:0]    channels_2_pop_b2m_bytesToSkip;
  reg        [13:0]   channels_2_pop_b2m_decrBytes;
  reg                 channels_2_pop_b2m_memPendingInc;
  wire                channels_2_readyForChannelCompletion;
  reg                 _zz_3;
  wire                channels_2_s2b_full;
  reg        [9:0]    channels_2_fifo_pop_ptrIncr_value_regNext;
  reg                 channels_2_interrupts_completion_enable;
  reg                 channels_2_interrupts_completion_valid;
  reg                 channels_2_interrupts_onChannelCompletion_enable;
  reg                 channels_2_interrupts_onChannelCompletion_valid;
  reg                 channels_2_interrupts_onLinkedListUpdate_enable;
  reg                 channels_2_interrupts_onLinkedListUpdate_valid;
  reg                 channels_2_interrupts_s2mPacket_enable;
  reg                 channels_2_interrupts_s2mPacket_valid;
  reg                 channels_3_channelStart;
  reg                 channels_3_channelStop;
  reg                 channels_3_channelCompletion;
  reg                 channels_3_channelValid;
  reg                 channels_3_descriptorStart;
  reg                 channels_3_descriptorCompletion;
  reg                 channels_3_descriptorValid;
  reg        [25:0]   channels_3_bytes;
  reg        [1:0]    channels_3_priority;
  reg        [1:0]    channels_3_weight;
  reg                 channels_3_selfRestart;
  reg                 channels_3_readyToStop;
  reg                 channels_3_ctrl_kick;
  reg                 channels_3_ll_sgStart;
  reg                 channels_3_ll_valid;
  reg                 channels_3_ll_head;
  reg                 channels_3_ll_justASync;
  reg                 channels_3_ll_waitDone;
  reg                 channels_3_ll_readDone;
  reg                 channels_3_ll_writeDone;
  reg                 channels_3_ll_gotDescriptorStall;
  reg                 channels_3_ll_packet;
  reg                 channels_3_ll_requireSync;
  reg        [31:0]   channels_3_ll_ptr;
  reg        [31:0]   channels_3_ll_ptrNext;
  wire                channels_3_ll_requestLl;
  reg                 channels_3_ll_descriptorUpdated;
  wire       [9:0]    channels_3_fifo_base;
  wire       [9:0]    channels_3_fifo_words;
  reg        [9:0]    channels_3_fifo_push_available;
  reg        [9:0]    channels_3_fifo_push_availableDecr;
  reg        [9:0]    channels_3_fifo_push_ptr;
  wire       [9:0]    channels_3_fifo_push_ptrWithBase;
  wire       [9:0]    channels_3_fifo_push_ptrIncr_value;
  reg        [9:0]    channels_3_fifo_pop_ptr;
  wire       [13:0]   channels_3_fifo_pop_bytes;
  wire       [9:0]    channels_3_fifo_pop_ptrWithBase;
  wire       [13:0]   channels_3_fifo_pop_bytesIncr_value;
  wire       [13:0]   channels_3_fifo_pop_bytesDecr_value;
  wire                channels_3_fifo_pop_empty;
  wire       [9:0]    channels_3_fifo_pop_ptrIncr_value;
  reg        [13:0]   channels_3_fifo_pop_withoutOverride_exposed;
  wire                channels_3_fifo_empty;
  reg                 channels_3_push_memory;
  reg        [31:0]   channels_3_push_m2b_address;
  wire       [11:0]   channels_3_push_m2b_bytePerBurst;
  reg                 channels_3_push_m2b_loadDone;
  reg        [25:0]   channels_3_push_m2b_bytesLeft;
  reg        [3:0]    channels_3_push_m2b_memPending;
  reg                 channels_3_push_m2b_memPendingIncr;
  reg                 channels_3_push_m2b_memPendingDecr;
  reg                 channels_3_push_m2b_loadRequest;
  reg                 channels_3_pop_memory;
  reg                 channels_3_pop_b2s_last;
  reg        [0:0]    channels_3_pop_b2s_portId;
  reg        [3:0]    channels_3_pop_b2s_sinkId;
  reg                 channels_3_pop_b2s_veryLastTrigger;
  reg                 channels_3_pop_b2s_veryLastValid;
  reg        [9:0]    channels_3_pop_b2s_veryLastPtr;
  reg                 channels_3_pop_b2s_veryLastEndPacket;
  reg                 channels_3_readyForChannelCompletion;
  reg                 _zz_4;
  wire                channels_3_s2b_full;
  reg        [9:0]    channels_3_fifo_pop_ptrIncr_value_regNext;
  reg                 channels_3_interrupts_completion_enable;
  reg                 channels_3_interrupts_completion_valid;
  reg                 channels_3_interrupts_onChannelCompletion_enable;
  reg                 channels_3_interrupts_onChannelCompletion_valid;
  reg                 channels_3_interrupts_onLinkedListUpdate_enable;
  reg                 channels_3_interrupts_onLinkedListUpdate_valid;
  reg                 io_inputs_0_payload_last_regNextWhen;
  reg                 io_inputs_0_payload_last_regNextWhen_1;
  reg                 io_inputs_0_payload_last_regNextWhen_2;
  reg                 io_inputs_0_payload_last_regNextWhen_3;
  reg                 io_inputs_0_payload_last_regNextWhen_4;
  reg                 io_inputs_0_payload_last_regNextWhen_5;
  reg                 io_inputs_0_payload_last_regNextWhen_6;
  reg                 io_inputs_0_payload_last_regNextWhen_7;
  reg                 io_inputs_0_payload_last_regNextWhen_8;
  reg                 io_inputs_0_payload_last_regNextWhen_9;
  reg                 io_inputs_0_payload_last_regNextWhen_10;
  reg                 io_inputs_0_payload_last_regNextWhen_11;
  reg                 io_inputs_0_payload_last_regNextWhen_12;
  reg                 io_inputs_0_payload_last_regNextWhen_13;
  reg                 io_inputs_0_payload_last_regNextWhen_14;
  reg                 io_inputs_0_payload_last_regNextWhen_15;
  reg        [15:0]   s2b_0_cmd_firsts;
  wire                s2b_0_cmd_first;
  wire       [0:0]    s2b_0_cmd_channelsOh;
  wire                s2b_0_cmd_noHit;
  wire       [0:0]    s2b_0_cmd_channelsFull;
  reg                 io_inputs_0_thrown_valid;
  wire                io_inputs_0_thrown_ready;
  wire       [127:0]  io_inputs_0_thrown_payload_data;
  wire       [15:0]   io_inputs_0_thrown_payload_mask;
  wire       [3:0]    io_inputs_0_thrown_payload_sink;
  wire                io_inputs_0_thrown_payload_last;
  wire                _zz_5;
  wire                s2b_0_cmd_sinkHalted_valid;
  wire                s2b_0_cmd_sinkHalted_ready;
  wire       [127:0]  s2b_0_cmd_sinkHalted_payload_data;
  wire       [15:0]   s2b_0_cmd_sinkHalted_payload_mask;
  wire       [3:0]    s2b_0_cmd_sinkHalted_payload_sink;
  wire                s2b_0_cmd_sinkHalted_payload_last;
  wire       [4:0]    _zz_6;
  wire       [4:0]    _zz_7;
  wire       [4:0]    _zz_8;
  wire       [4:0]    _zz_9;
  wire       [4:0]    _zz_10;
  wire       [4:0]    _zz_11;
  wire       [4:0]    _zz_12;
  wire       [4:0]    _zz_13;
  wire       [4:0]    s2b_0_cmd_byteCount;
  wire       [0:0]    s2b_0_cmd_context_channel;
  wire       [4:0]    s2b_0_cmd_context_bytes;
  wire                s2b_0_cmd_context_flush;
  wire                s2b_0_cmd_context_packet;
  wire                _zz_14;
  wire       [0:0]    s2b_0_rsp_context_channel;
  wire       [4:0]    s2b_0_rsp_context_bytes;
  wire                s2b_0_rsp_context_flush;
  wire                s2b_0_rsp_context_packet;
  wire       [7:0]    _zz_15;
  wire                _zz_16;
  reg                 io_inputs_1_payload_last_regNextWhen;
  reg                 io_inputs_1_payload_last_regNextWhen_1;
  reg                 io_inputs_1_payload_last_regNextWhen_2;
  reg                 io_inputs_1_payload_last_regNextWhen_3;
  reg                 io_inputs_1_payload_last_regNextWhen_4;
  reg                 io_inputs_1_payload_last_regNextWhen_5;
  reg                 io_inputs_1_payload_last_regNextWhen_6;
  reg                 io_inputs_1_payload_last_regNextWhen_7;
  reg                 io_inputs_1_payload_last_regNextWhen_8;
  reg                 io_inputs_1_payload_last_regNextWhen_9;
  reg                 io_inputs_1_payload_last_regNextWhen_10;
  reg                 io_inputs_1_payload_last_regNextWhen_11;
  reg                 io_inputs_1_payload_last_regNextWhen_12;
  reg                 io_inputs_1_payload_last_regNextWhen_13;
  reg                 io_inputs_1_payload_last_regNextWhen_14;
  reg                 io_inputs_1_payload_last_regNextWhen_15;
  reg        [15:0]   s2b_1_cmd_firsts;
  wire                s2b_1_cmd_first;
  wire       [0:0]    s2b_1_cmd_channelsOh;
  wire                s2b_1_cmd_noHit;
  wire       [0:0]    s2b_1_cmd_channelsFull;
  reg                 io_inputs_1_thrown_valid;
  wire                io_inputs_1_thrown_ready;
  wire       [127:0]  io_inputs_1_thrown_payload_data;
  wire       [15:0]   io_inputs_1_thrown_payload_mask;
  wire       [3:0]    io_inputs_1_thrown_payload_sink;
  wire                io_inputs_1_thrown_payload_last;
  wire                _zz_17;
  wire                s2b_1_cmd_sinkHalted_valid;
  wire                s2b_1_cmd_sinkHalted_ready;
  wire       [127:0]  s2b_1_cmd_sinkHalted_payload_data;
  wire       [15:0]   s2b_1_cmd_sinkHalted_payload_mask;
  wire       [3:0]    s2b_1_cmd_sinkHalted_payload_sink;
  wire                s2b_1_cmd_sinkHalted_payload_last;
  wire       [4:0]    _zz_18;
  wire       [4:0]    _zz_19;
  wire       [4:0]    _zz_20;
  wire       [4:0]    _zz_21;
  wire       [4:0]    _zz_22;
  wire       [4:0]    _zz_23;
  wire       [4:0]    _zz_24;
  wire       [4:0]    _zz_25;
  wire       [4:0]    s2b_1_cmd_byteCount;
  wire       [0:0]    s2b_1_cmd_context_channel;
  wire       [4:0]    s2b_1_cmd_context_bytes;
  wire                s2b_1_cmd_context_flush;
  wire                s2b_1_cmd_context_packet;
  wire                _zz_26;
  wire       [0:0]    s2b_1_rsp_context_channel;
  wire       [4:0]    s2b_1_rsp_context_bytes;
  wire                s2b_1_rsp_context_flush;
  wire                s2b_1_rsp_context_packet;
  wire       [7:0]    _zz_27;
  wire                _zz_28;
  wire       [0:0]    b2s_0_cmd_channelsOh;
  wire       [0:0]    b2s_0_cmd_context_channel;
  wire                b2s_0_cmd_context_veryLast;
  wire                b2s_0_cmd_context_endPacket;
  wire       [9:0]    b2s_0_cmd_veryLastPtr;
  wire       [9:0]    b2s_0_cmd_address;
  wire       [0:0]    b2s_0_rsp_context_channel;
  wire                b2s_0_rsp_context_veryLast;
  wire                b2s_0_rsp_context_endPacket;
  wire       [2:0]    _zz_29;
  wire       [0:0]    b2s_1_cmd_channelsOh;
  wire       [0:0]    b2s_1_cmd_context_channel;
  wire                b2s_1_cmd_context_veryLast;
  wire                b2s_1_cmd_context_endPacket;
  wire       [9:0]    b2s_1_cmd_veryLastPtr;
  wire       [9:0]    b2s_1_cmd_address;
  wire       [0:0]    b2s_1_rsp_context_channel;
  wire                b2s_1_rsp_context_veryLast;
  wire                b2s_1_rsp_context_endPacket;
  wire       [2:0]    _zz_30;
  reg                 m2b_cmd_s0_valid;
  reg        [0:0]    m2b_cmd_s0_chosen;
  wire       [1:0]    _zz_31;
  wire       [1:0]    _zz_32;
  wire       [1:0]    _zz_33;
  reg        [1:0]    m2b_cmd_s0_priority_masked;
  reg        [1:0]    m2b_cmd_s0_priority_roundRobins_0;
  reg        [1:0]    m2b_cmd_s0_priority_roundRobins_1;
  reg        [1:0]    m2b_cmd_s0_priority_roundRobins_2;
  reg        [1:0]    m2b_cmd_s0_priority_roundRobins_3;
  reg        [1:0]    m2b_cmd_s0_priority_counter;
  wire       [1:0]    _zz_34;
  wire       [3:0]    _zz_35;
  wire       [3:0]    _zz_36;
  wire       [1:0]    m2b_cmd_s0_priority_chosenOh;
  wire                _zz_37;
  wire       [0:0]    m2b_cmd_s0_priority_chosen;
  wire                m2b_cmd_s0_priority_weightLast;
  wire       [1:0]    m2b_cmd_s0_priority_contextNext;
  wire       [31:0]   m2b_cmd_s0_address;
  wire       [25:0]   m2b_cmd_s0_bytesLeft;
  wire       [11:0]   m2b_cmd_s0_readAddressBurstRange;
  wire       [11:0]   m2b_cmd_s0_lengthHead;
  wire       [11:0]   m2b_cmd_s0_length;
  wire                m2b_cmd_s0_lastBurst;
  reg                 m2b_cmd_s1_valid;
  reg        [31:0]   m2b_cmd_s1_address;
  reg        [11:0]   m2b_cmd_s1_length;
  reg                 m2b_cmd_s1_lastBurst;
  reg        [25:0]   m2b_cmd_s1_bytesLeft;
  wire       [0:0]    m2b_cmd_s1_context_channel;
  wire       [3:0]    m2b_cmd_s1_context_start;
  wire       [3:0]    m2b_cmd_s1_context_stop;
  wire       [11:0]   m2b_cmd_s1_context_length;
  wire                m2b_cmd_s1_context_last;
  wire       [31:0]   m2b_cmd_s1_addressNext;
  wire       [25:0]   m2b_cmd_s1_byteLeftNext;
  wire       [8:0]    m2b_cmd_s1_fifoPushDecr;
  wire       [0:0]    m2b_rsp_context_channel;
  wire       [3:0]    m2b_rsp_context_start;
  wire       [3:0]    m2b_rsp_context_stop;
  wire       [11:0]   m2b_rsp_context_length;
  wire                m2b_rsp_context_last;
  wire       [21:0]   _zz_38;
  wire                m2b_rsp_veryLast;
  reg                 m2b_rsp_first;
  wire                m2b_rsp_writeContext_last;
  wire                m2b_rsp_writeContext_lastOfBurst;
  wire       [0:0]    m2b_rsp_writeContext_channel;
  wire       [4:0]    m2b_rsp_writeContext_loadByteInNextBeat;
  wire                m2b_writeRsp_context_last;
  wire                m2b_writeRsp_context_lastOfBurst;
  wire       [0:0]    m2b_writeRsp_context_channel;
  wire       [4:0]    m2b_writeRsp_context_loadByteInNextBeat;
  wire       [7:0]    _zz_39;
  wire                _zz_40;
  wire                _zz_41;
  reg                 b2m_fsm_sel_valid;
  reg                 b2m_fsm_sel_ready;
  reg        [0:0]    b2m_fsm_sel_channel;
  reg        [11:0]   b2m_fsm_sel_bytePerBurst;
  reg        [11:0]   b2m_fsm_sel_bytesInBurst;
  reg        [13:0]   b2m_fsm_sel_bytesInFifo;
  reg        [31:0]   b2m_fsm_sel_address;
  reg        [9:0]    b2m_fsm_sel_ptr;
  reg        [9:0]    b2m_fsm_sel_ptrMask;
  reg                 b2m_fsm_sel_flush;
  reg                 b2m_fsm_sel_packet;
  reg        [25:0]   b2m_fsm_sel_bytesLeft;
  reg                 b2m_fsm_arbiter_logic_valid;
  reg        [0:0]    b2m_fsm_arbiter_logic_chosen;
  wire       [1:0]    _zz_42;
  wire       [1:0]    _zz_43;
  wire       [1:0]    _zz_44;
  reg        [1:0]    b2m_fsm_arbiter_logic_priority_masked;
  reg        [1:0]    b2m_fsm_arbiter_logic_priority_roundRobins_0;
  reg        [1:0]    b2m_fsm_arbiter_logic_priority_roundRobins_1;
  reg        [1:0]    b2m_fsm_arbiter_logic_priority_roundRobins_2;
  reg        [1:0]    b2m_fsm_arbiter_logic_priority_roundRobins_3;
  reg        [1:0]    b2m_fsm_arbiter_logic_priority_counter;
  wire       [1:0]    _zz_45;
  wire       [3:0]    _zz_46;
  wire       [3:0]    _zz_47;
  wire       [1:0]    b2m_fsm_arbiter_logic_priority_chosenOh;
  wire                _zz_48;
  wire       [0:0]    b2m_fsm_arbiter_logic_priority_chosen;
  wire                b2m_fsm_arbiter_logic_priority_weightLast;
  wire       [1:0]    b2m_fsm_arbiter_logic_priority_contextNext;
  wire       [1:0]    _zz_49;
  wire       [11:0]   b2m_fsm_bytesInBurstP1;
  wire       [31:0]   b2m_fsm_addressNext;
  wire       [26:0]   b2m_fsm_bytesLeftNext;
  wire                b2m_fsm_isFinalCmd;
  reg        [7:0]    b2m_fsm_beatCounter;
  reg                 b2m_fsm_sel_valid_regNext;
  wire                b2m_fsm_s0;
  reg                 b2m_fsm_s1;
  reg                 b2m_fsm_s2;
  wire       [13:0]   _zz_50;
  wire       [25:0]   _zz_51;
  wire       [11:0]   _zz_52;
  wire                b2m_fsm_fifoCompletion;
  reg                 b2m_fsm_toggle;
  wire       [9:0]    b2m_fsm_fetch_context_ptr;
  wire                b2m_fsm_fetch_context_toggle;
  wire       [9:0]    b2m_fsm_aggregate_context_ptr;
  wire                b2m_fsm_aggregate_context_toggle;
  wire       [10:0]   _zz_53;
  wire                memory_core_io_reads_2_rsp_s2mPipe_valid;
  reg                 memory_core_io_reads_2_rsp_s2mPipe_ready;
  wire       [127:0]  memory_core_io_reads_2_rsp_s2mPipe_payload_data;
  wire       [15:0]   memory_core_io_reads_2_rsp_s2mPipe_payload_mask;
  wire       [10:0]   memory_core_io_reads_2_rsp_s2mPipe_payload_context;
  reg                 memory_core_io_reads_2_rsp_s2mPipe_rValid;
  reg        [127:0]  memory_core_io_reads_2_rsp_s2mPipe_rData_data;
  reg        [15:0]   memory_core_io_reads_2_rsp_s2mPipe_rData_mask;
  reg        [10:0]   memory_core_io_reads_2_rsp_s2mPipe_rData_context;
  reg                 b2m_fsm_aggregate_memoryPort_valid;
  wire                b2m_fsm_aggregate_memoryPort_ready;
  wire       [127:0]  b2m_fsm_aggregate_memoryPort_payload_data;
  wire       [15:0]   b2m_fsm_aggregate_memoryPort_payload_mask;
  wire       [10:0]   b2m_fsm_aggregate_memoryPort_payload_context;
  reg                 b2m_fsm_aggregate_first;
  wire       [3:0]    b2m_fsm_aggregate_bytesToSkip;
  reg        [15:0]   b2m_fsm_aggregate_bytesToSkipMask;
  reg                 _zz_54;
  wire       [3:0]    b2m_fsm_cmd_maskFirstTrigger;
  wire       [3:0]    b2m_fsm_cmd_maskLastTriggerComb;
  reg        [3:0]    b2m_fsm_cmd_maskLastTriggerReg;
  reg        [15:0]   _zz_55;
  reg        [15:0]   b2m_fsm_cmd_maskLast;
  reg        [15:0]   b2m_fsm_cmd_maskFirst;
  wire                b2m_fsm_cmd_enoughAggregation;
  reg                 io_write_cmd_payload_first;
  wire                b2m_fsm_cmd_doPtrIncr;
  wire       [0:0]    b2m_fsm_cmd_context_channel;
  wire       [11:0]   b2m_fsm_cmd_context_length;
  wire                b2m_fsm_cmd_context_doPacketSync;
  wire       [1:0]    _zz_56;
  wire       [3:0]    _zz_57;
  wire       [0:0]    b2m_rsp_context_channel;
  wire       [11:0]   b2m_rsp_context_length;
  wire                b2m_rsp_context_doPacketSync;
  wire       [13:0]   _zz_58;
  wire       [1:0]    _zz_59;
  wire       [3:0]    _zz_60;
  wire       [3:0]    _zz_61;
  wire                _zz_62;
  wire                _zz_63;
  wire                _zz_64;
  reg        [3:0]    _zz_65;
  wire                _zz_66;
  wire                _zz_67;
  wire                _zz_68;
  wire                ll_arbiter_head;
  reg        [3:0]    _zz_69;
  wire                _zz_70;
  wire                _zz_71;
  wire                _zz_72;
  wire                ll_arbiter_isJustASink;
  reg                 ll_cmd_valid;
  reg                 ll_cmd_oh_0;
  reg                 ll_cmd_oh_1;
  reg                 ll_cmd_oh_2;
  reg                 ll_cmd_oh_3;
  reg        [3:0]    _zz_73;
  wire                _zz_74;
  wire                _zz_75;
  wire                _zz_76;
  reg        [31:0]   ll_cmd_ptr;
  reg        [3:0]    _zz_77;
  wire                _zz_78;
  wire                _zz_79;
  wire                _zz_80;
  reg        [31:0]   ll_cmd_ptrNext;
  reg        [1:0]    _zz_81;
  reg        [26:0]   ll_cmd_bytesDone;
  reg        [3:0]    _zz_82;
  wire                _zz_83;
  wire                _zz_84;
  wire                _zz_85;
  reg                 ll_cmd_endOfPacket;
  reg                 ll_cmd_isJustASink;
  reg                 ll_cmd_readFired;
  reg                 ll_cmd_writeFired;
  wire       [1:0]    ll_cmd_context_channel;
  wire                _zz_86;
  wire                _zz_87;
  wire       [3:0]    ll_cmd_writeMaskSplit_0;
  wire       [3:0]    ll_cmd_writeMaskSplit_1;
  wire       [3:0]    ll_cmd_writeMaskSplit_2;
  wire       [3:0]    ll_cmd_writeMaskSplit_3;
  wire       [31:0]   ll_cmd_writeDataSplit_0;
  wire       [31:0]   ll_cmd_writeDataSplit_1;
  wire       [31:0]   ll_cmd_writeDataSplit_2;
  wire       [31:0]   ll_cmd_writeDataSplit_3;
  wire       [1:0]    ll_readRsp_context_channel;
  reg        [3:0]    _zz_88;
  wire                ll_readRsp_oh_0;
  wire                ll_readRsp_oh_1;
  wire                ll_readRsp_oh_2;
  wire                ll_readRsp_oh_3;
  reg        [0:0]    ll_readRsp_beatCounter;
  reg                 ll_readRsp_completed;
  wire       [1:0]    ll_writeRsp_context_channel;
  reg        [3:0]    _zz_89;
  wire                ll_writeRsp_oh_0;
  wire                ll_writeRsp_oh_1;
  wire                ll_writeRsp_oh_2;
  wire                ll_writeRsp_oh_3;
  reg                 _zz_90;
  reg                 _zz_91;
  reg                 _zz_92;
  reg                 _zz_93;
  reg                 _zz_94;
  reg                 _zz_95;
  reg                 _zz_96;
  reg                 _zz_97;
  reg                 _zz_98;
  reg                 _zz_99;
  reg                 _zz_100;
  reg                 _zz_101;
  reg                 _zz_102;
  reg                 _zz_103;
  reg                 _zz_104;
  reg                 _zz_105;
  reg                 _zz_106;
  reg                 _zz_107;
  reg                 _zz_108;
  reg                 _zz_109;
  reg                 _zz_110;
  reg                 _zz_111;
  reg                 _zz_112;
  reg                 _zz_113;
  reg                 _zz_114;
  reg                 _zz_115;
  reg                 _zz_116;
  reg                 _zz_117;
  reg                 _zz_118;
  reg                 _zz_119;
  function [15:0] zz_io_sgWrite_cmd_payload_fragment_mask(input dummy);
    begin
      zz_io_sgWrite_cmd_payload_fragment_mask[7 : 4] = 4'b0000;
      zz_io_sgWrite_cmd_payload_fragment_mask[11 : 8] = 4'b0000;
      zz_io_sgWrite_cmd_payload_fragment_mask[15 : 12] = 4'b0000;
      zz_io_sgWrite_cmd_payload_fragment_mask[3 : 0] = 4'b1111;
    end
  endfunction
  wire [15:0] _zz_486;

  assign _zz_175 = (((channels_0_ll_valid && channels_0_ll_waitDone) && channels_0_ll_writeDone) && channels_0_ll_readDone);
  assign _zz_176 = (! channels_0_ll_justASync);
  assign _zz_177 = (! channels_0_ll_gotDescriptorStall);
  assign _zz_178 = (! channels_0_descriptorValid);
  assign _zz_179 = (channels_0_selfRestart && (! channels_0_ctrl_kick));
  assign _zz_180 = (channels_0_descriptorValid && (! channels_0_push_memory));
  assign _zz_181 = (io_write_rsp_valid && io_write_rsp_ready);
  assign _zz_182 = (b2m_rsp_context_channel == 1'b0);
  assign _zz_183 = ((! b2m_fsm_sel_valid) && b2m_fsm_arbiter_logic_valid);
  assign _zz_184 = ((channels_0_pop_b2m_memPending == 4'b0000) && (channels_0_fifo_pop_bytes == 14'h0));
  assign _zz_185 = (! b2m_fsm_arbiter_logic_valid);
  assign _zz_186 = (b2m_fsm_sel_channel == 1'b0);
  assign _zz_187 = (((channels_1_ll_valid && channels_1_ll_waitDone) && channels_1_ll_writeDone) && channels_1_ll_readDone);
  assign _zz_188 = (! channels_1_ll_justASync);
  assign _zz_189 = (! channels_1_ll_gotDescriptorStall);
  assign _zz_190 = (! channels_1_descriptorValid);
  assign _zz_191 = (channels_1_selfRestart && (! channels_1_ctrl_kick));
  assign _zz_192 = (1'b0 == m2b_cmd_s0_chosen);
  assign _zz_193 = (! m2b_cmd_s0_valid);
  assign _zz_194 = ((io_read_rsp_valid && io_read_rsp_ready) && m2b_rsp_veryLast);
  assign _zz_195 = (((channels_2_ll_valid && channels_2_ll_waitDone) && channels_2_ll_writeDone) && channels_2_ll_readDone);
  assign _zz_196 = (! channels_2_ll_justASync);
  assign _zz_197 = (! channels_2_ll_gotDescriptorStall);
  assign _zz_198 = (! channels_2_descriptorValid);
  assign _zz_199 = (channels_2_selfRestart && (! channels_2_ctrl_kick));
  assign _zz_200 = (channels_2_descriptorValid && (! channels_2_push_memory));
  assign _zz_201 = (b2m_rsp_context_channel == 1'b1);
  assign _zz_202 = ((channels_2_pop_b2m_memPending == 4'b0000) && (channels_2_fifo_pop_bytes == 14'h0));
  assign _zz_203 = (b2m_fsm_sel_channel == 1'b1);
  assign _zz_204 = (((channels_3_ll_valid && channels_3_ll_waitDone) && channels_3_ll_writeDone) && channels_3_ll_readDone);
  assign _zz_205 = (! channels_3_ll_justASync);
  assign _zz_206 = (! channels_3_ll_gotDescriptorStall);
  assign _zz_207 = (! channels_3_descriptorValid);
  assign _zz_208 = (channels_3_selfRestart && (! channels_3_ctrl_kick));
  assign _zz_209 = (1'b1 == m2b_cmd_s0_chosen);
  assign _zz_210 = ((io_write_cmd_valid && io_write_cmd_ready) && io_write_cmd_payload_last);
  assign _zz_211 = (b2m_fsm_aggregate_context_toggle != b2m_fsm_toggle);
  assign _zz_212 = (_zz_135 && (! memory_core_io_reads_2_rsp_s2mPipe_ready));
  assign _zz_213 = (! ll_cmd_valid);
  assign _zz_214 = (io_sgRead_rsp_valid && io_sgRead_rsp_ready);
  assign _zz_215 = (channels_0_bytesProbe_value + _zz_216);
  assign _zz_216 = {15'd0, channels_0_bytesProbe_incr_payload};
  assign _zz_217 = (channels_0_fifo_pop_withOverride_backup + channels_0_fifo_pop_bytesIncr_value);
  assign _zz_218 = (channels_0_fifo_pop_withOverride_exposed - channels_0_fifo_pop_bytesDecr_value);
  assign _zz_219 = {2'd0, channels_0_pop_b2m_bytePerBurst};
  assign _zz_220 = (channels_0_fifo_words >>> 1);
  assign _zz_221 = {1'd0, _zz_220};
  assign _zz_222 = (channels_0_pop_b2m_memPending + _zz_224);
  assign _zz_223 = channels_0_pop_b2m_memPendingInc;
  assign _zz_224 = {3'd0, _zz_223};
  assign _zz_225 = channels_0_pop_b2m_memRsp;
  assign _zz_226 = {3'd0, _zz_225};
  assign _zz_227 = {13'd0, channels_0_fifo_pop_bytes};
  assign _zz_228 = (channels_0_pop_b2m_address - _zz_229);
  assign _zz_229 = {6'd0, channels_0_bytes};
  assign _zz_230 = (channels_0_fifo_push_available + channels_0_fifo_pop_ptrIncr_value_regNext);
  assign _zz_231 = (channels_1_fifo_pop_withoutOverride_exposed + channels_1_fifo_pop_bytesIncr_value);
  assign _zz_232 = (channels_1_push_m2b_memPending + _zz_234);
  assign _zz_233 = channels_1_push_m2b_memPendingIncr;
  assign _zz_234 = {3'd0, _zz_233};
  assign _zz_235 = channels_1_push_m2b_memPendingDecr;
  assign _zz_236 = {3'd0, _zz_235};
  assign _zz_237 = (channels_1_push_m2b_bytePerBurst >>> 4);
  assign _zz_238 = {2'd0, _zz_237};
  assign _zz_239 = {14'd0, channels_1_push_m2b_bytePerBurst};
  assign _zz_240 = (channels_1_push_m2b_address - _zz_241);
  assign _zz_241 = {6'd0, channels_1_bytes};
  assign _zz_242 = (channels_1_fifo_push_available + channels_1_fifo_pop_ptrIncr_value_regNext);
  assign _zz_243 = (channels_2_bytesProbe_value + _zz_244);
  assign _zz_244 = {15'd0, channels_2_bytesProbe_incr_payload};
  assign _zz_245 = (channels_2_fifo_pop_withOverride_backup + channels_2_fifo_pop_bytesIncr_value);
  assign _zz_246 = (channels_2_fifo_pop_withOverride_exposed - channels_2_fifo_pop_bytesDecr_value);
  assign _zz_247 = {2'd0, channels_2_pop_b2m_bytePerBurst};
  assign _zz_248 = (channels_2_fifo_words >>> 1);
  assign _zz_249 = {1'd0, _zz_248};
  assign _zz_250 = (channels_2_pop_b2m_memPending + _zz_252);
  assign _zz_251 = channels_2_pop_b2m_memPendingInc;
  assign _zz_252 = {3'd0, _zz_251};
  assign _zz_253 = channels_2_pop_b2m_memRsp;
  assign _zz_254 = {3'd0, _zz_253};
  assign _zz_255 = {13'd0, channels_2_fifo_pop_bytes};
  assign _zz_256 = (channels_2_pop_b2m_address - _zz_257);
  assign _zz_257 = {6'd0, channels_2_bytes};
  assign _zz_258 = (channels_2_fifo_push_available + channels_2_fifo_pop_ptrIncr_value_regNext);
  assign _zz_259 = (channels_3_fifo_pop_withoutOverride_exposed + channels_3_fifo_pop_bytesIncr_value);
  assign _zz_260 = (channels_3_push_m2b_memPending + _zz_262);
  assign _zz_261 = channels_3_push_m2b_memPendingIncr;
  assign _zz_262 = {3'd0, _zz_261};
  assign _zz_263 = channels_3_push_m2b_memPendingDecr;
  assign _zz_264 = {3'd0, _zz_263};
  assign _zz_265 = (channels_3_push_m2b_bytePerBurst >>> 4);
  assign _zz_266 = {2'd0, _zz_265};
  assign _zz_267 = {14'd0, channels_3_push_m2b_bytePerBurst};
  assign _zz_268 = (channels_3_push_m2b_address - _zz_269);
  assign _zz_269 = {6'd0, channels_3_bytes};
  assign _zz_270 = (channels_3_fifo_push_available + channels_3_fifo_pop_ptrIncr_value_regNext);
  assign _zz_271 = (_zz_272 + _zz_273);
  assign _zz_272 = (_zz_140 + _zz_141);
  assign _zz_273 = (_zz_142 + _zz_143);
  assign _zz_274 = (_zz_144 + _zz_145);
  assign _zz_275 = s2b_0_cmd_sinkHalted_payload_mask[15];
  assign _zz_276 = {2'd0, _zz_275};
  assign _zz_277 = _zz_15[6 : 6];
  assign _zz_278 = _zz_15[7 : 7];
  assign _zz_279 = (_zz_280 + _zz_281);
  assign _zz_280 = (_zz_146 + _zz_147);
  assign _zz_281 = (_zz_148 + _zz_149);
  assign _zz_282 = (_zz_150 + _zz_151);
  assign _zz_283 = s2b_1_cmd_sinkHalted_payload_mask[15];
  assign _zz_284 = {2'd0, _zz_283};
  assign _zz_285 = _zz_27[6 : 6];
  assign _zz_286 = _zz_27[7 : 7];
  assign _zz_287 = _zz_29[1 : 1];
  assign _zz_288 = _zz_29[2 : 2];
  assign _zz_289 = _zz_30[1 : 1];
  assign _zz_290 = _zz_30[2 : 2];
  assign _zz_291 = (_zz_35 - _zz_293);
  assign _zz_292 = _zz_152;
  assign _zz_293 = {2'd0, _zz_292};
  assign _zz_294 = ((_zz_295 < m2b_cmd_s0_bytesLeft) ? _zz_296 : m2b_cmd_s0_bytesLeft);
  assign _zz_295 = {14'd0, m2b_cmd_s0_lengthHead};
  assign _zz_296 = {14'd0, m2b_cmd_s0_lengthHead};
  assign _zz_297 = {14'd0, m2b_cmd_s0_length};
  assign _zz_298 = (m2b_cmd_s1_address + _zz_299);
  assign _zz_299 = {20'd0, m2b_cmd_s1_length};
  assign _zz_300 = (m2b_cmd_s1_address + _zz_301);
  assign _zz_301 = {20'd0, m2b_cmd_s1_length};
  assign _zz_302 = (m2b_cmd_s1_bytesLeft - _zz_303);
  assign _zz_303 = {14'd0, m2b_cmd_s1_length};
  assign _zz_304 = ({1'b0,(_zz_305 | 12'h00f)} + _zz_309);
  assign _zz_305 = (_zz_307 + io_read_cmd_payload_fragment_length);
  assign _zz_306 = m2b_cmd_s1_address[3 : 0];
  assign _zz_307 = {8'd0, _zz_306};
  assign _zz_308 = {1'b0,1'b1};
  assign _zz_309 = {11'd0, _zz_308};
  assign _zz_310 = _zz_38[21 : 21];
  assign _zz_311 = _zz_39[0 : 0];
  assign _zz_312 = _zz_39[1 : 1];
  assign _zz_313 = (_zz_46 - _zz_315);
  assign _zz_314 = _zz_158;
  assign _zz_315 = {2'd0, _zz_314};
  assign _zz_316 = {20'd0, b2m_fsm_bytesInBurstP1};
  assign _zz_317 = {1'b0,b2m_fsm_bytesInBurstP1};
  assign _zz_318 = {14'd0, _zz_317};
  assign _zz_319 = {12'd0, _zz_50};
  assign _zz_320 = {12'd0, _zz_50};
  assign _zz_321 = b2m_fsm_sel_address[11:0];
  assign _zz_322 = ((_zz_51 < _zz_323) ? _zz_51 : _zz_324);
  assign _zz_323 = {14'd0, _zz_52};
  assign _zz_324 = {14'd0, _zz_52};
  assign _zz_325 = {2'd0, b2m_fsm_sel_bytesInBurst};
  assign _zz_326 = (b2m_fsm_sel_bytesInFifo - 14'h0001);
  assign _zz_327 = (_zz_329 + b2m_fsm_sel_bytesInBurst);
  assign _zz_328 = b2m_fsm_sel_address[3 : 0];
  assign _zz_329 = {8'd0, _zz_328};
  assign _zz_330 = (b2m_fsm_sel_ptr + 10'h001);
  assign _zz_331 = _zz_53[10 : 10];
  assign _zz_332 = b2m_fsm_sel_bytesInBurst[3:0];
  assign _zz_333 = _zz_58[13 : 13];
  assign _zz_334 = (_zz_60 - 4'b0001);
  assign _zz_335 = io_sgRead_rsp_payload_fragment_data[62 : 62];
  assign _zz_336 = io_sgRead_rsp_payload_fragment_data[62 : 62];
  assign _zz_337 = io_sgRead_rsp_payload_fragment_data[31 : 31];
  assign _zz_338 = io_sgRead_rsp_payload_fragment_data[31 : 31];
  assign _zz_339 = io_sgRead_rsp_payload_fragment_data[31 : 31];
  assign _zz_340 = io_sgRead_rsp_payload_fragment_data[31 : 31];
  assign _zz_341 = io_ctrl_PWDATA[0 : 0];
  assign _zz_342 = 1'b1;
  assign _zz_343 = io_ctrl_PWDATA[0 : 0];
  assign _zz_344 = 1'b1;
  assign _zz_345 = io_ctrl_PWDATA[4 : 4];
  assign _zz_346 = 1'b1;
  assign _zz_347 = io_ctrl_PWDATA[4 : 4];
  assign _zz_348 = 1'b1;
  assign _zz_349 = io_ctrl_PWDATA[0 : 0];
  assign _zz_350 = 1'b0;
  assign _zz_351 = io_ctrl_PWDATA[2 : 2];
  assign _zz_352 = 1'b0;
  assign _zz_353 = io_ctrl_PWDATA[3 : 3];
  assign _zz_354 = 1'b0;
  assign _zz_355 = io_ctrl_PWDATA[4 : 4];
  assign _zz_356 = 1'b0;
  assign _zz_357 = io_ctrl_PWDATA[0 : 0];
  assign _zz_358 = 1'b1;
  assign _zz_359 = io_ctrl_PWDATA[0 : 0];
  assign _zz_360 = 1'b1;
  assign _zz_361 = io_ctrl_PWDATA[4 : 4];
  assign _zz_362 = 1'b1;
  assign _zz_363 = io_ctrl_PWDATA[4 : 4];
  assign _zz_364 = 1'b1;
  assign _zz_365 = io_ctrl_PWDATA[0 : 0];
  assign _zz_366 = 1'b0;
  assign _zz_367 = io_ctrl_PWDATA[2 : 2];
  assign _zz_368 = 1'b0;
  assign _zz_369 = io_ctrl_PWDATA[3 : 3];
  assign _zz_370 = 1'b0;
  assign _zz_371 = io_ctrl_PWDATA[0 : 0];
  assign _zz_372 = 1'b1;
  assign _zz_373 = io_ctrl_PWDATA[0 : 0];
  assign _zz_374 = 1'b1;
  assign _zz_375 = io_ctrl_PWDATA[4 : 4];
  assign _zz_376 = 1'b1;
  assign _zz_377 = io_ctrl_PWDATA[4 : 4];
  assign _zz_378 = 1'b1;
  assign _zz_379 = io_ctrl_PWDATA[0 : 0];
  assign _zz_380 = 1'b0;
  assign _zz_381 = io_ctrl_PWDATA[2 : 2];
  assign _zz_382 = 1'b0;
  assign _zz_383 = io_ctrl_PWDATA[3 : 3];
  assign _zz_384 = 1'b0;
  assign _zz_385 = io_ctrl_PWDATA[4 : 4];
  assign _zz_386 = 1'b0;
  assign _zz_387 = io_ctrl_PWDATA[0 : 0];
  assign _zz_388 = 1'b1;
  assign _zz_389 = io_ctrl_PWDATA[0 : 0];
  assign _zz_390 = 1'b1;
  assign _zz_391 = io_ctrl_PWDATA[4 : 4];
  assign _zz_392 = 1'b1;
  assign _zz_393 = io_ctrl_PWDATA[4 : 4];
  assign _zz_394 = 1'b1;
  assign _zz_395 = io_ctrl_PWDATA[0 : 0];
  assign _zz_396 = 1'b0;
  assign _zz_397 = io_ctrl_PWDATA[2 : 2];
  assign _zz_398 = 1'b0;
  assign _zz_399 = io_ctrl_PWDATA[3 : 3];
  assign _zz_400 = 1'b0;
  assign _zz_401 = io_ctrl_PWDATA[12 : 12];
  assign _zz_402 = io_ctrl_PWDATA[13 : 13];
  assign _zz_403 = io_ctrl_PWDATA[14 : 14];
  assign _zz_404 = io_ctrl_PWDATA[31 : 0];
  assign _zz_405 = _zz_404;
  assign _zz_406 = io_ctrl_PWDATA[12 : 12];
  assign _zz_407 = io_ctrl_PWDATA[2 : 2];
  assign _zz_408 = io_ctrl_PWDATA[1 : 1];
  assign _zz_409 = io_ctrl_PWDATA[0 : 0];
  assign _zz_410 = io_ctrl_PWDATA[2 : 2];
  assign _zz_411 = io_ctrl_PWDATA[3 : 3];
  assign _zz_412 = io_ctrl_PWDATA[4 : 4];
  assign _zz_413 = io_ctrl_PWDATA[31 : 0];
  assign _zz_414 = _zz_413;
  assign _zz_415 = io_ctrl_PWDATA[12 : 12];
  assign _zz_416 = io_ctrl_PWDATA[12 : 12];
  assign _zz_417 = io_ctrl_PWDATA[13 : 13];
  assign _zz_418 = io_ctrl_PWDATA[2 : 2];
  assign _zz_419 = io_ctrl_PWDATA[1 : 1];
  assign _zz_420 = io_ctrl_PWDATA[0 : 0];
  assign _zz_421 = io_ctrl_PWDATA[2 : 2];
  assign _zz_422 = io_ctrl_PWDATA[3 : 3];
  assign _zz_423 = io_ctrl_PWDATA[12 : 12];
  assign _zz_424 = io_ctrl_PWDATA[13 : 13];
  assign _zz_425 = io_ctrl_PWDATA[14 : 14];
  assign _zz_426 = io_ctrl_PWDATA[31 : 0];
  assign _zz_427 = _zz_426;
  assign _zz_428 = io_ctrl_PWDATA[12 : 12];
  assign _zz_429 = io_ctrl_PWDATA[2 : 2];
  assign _zz_430 = io_ctrl_PWDATA[1 : 1];
  assign _zz_431 = io_ctrl_PWDATA[0 : 0];
  assign _zz_432 = io_ctrl_PWDATA[2 : 2];
  assign _zz_433 = io_ctrl_PWDATA[3 : 3];
  assign _zz_434 = io_ctrl_PWDATA[4 : 4];
  assign _zz_435 = io_ctrl_PWDATA[31 : 0];
  assign _zz_436 = _zz_435;
  assign _zz_437 = io_ctrl_PWDATA[12 : 12];
  assign _zz_438 = io_ctrl_PWDATA[12 : 12];
  assign _zz_439 = io_ctrl_PWDATA[13 : 13];
  assign _zz_440 = io_ctrl_PWDATA[2 : 2];
  assign _zz_441 = io_ctrl_PWDATA[1 : 1];
  assign _zz_442 = io_ctrl_PWDATA[0 : 0];
  assign _zz_443 = io_ctrl_PWDATA[2 : 2];
  assign _zz_444 = io_ctrl_PWDATA[3 : 3];
  assign _zz_445 = ((_zz_14 && (s2b_0_cmd_sinkHalted_payload_mask != 16'h0)) ? 1'b1 : 1'b0);
  assign _zz_446 = {9'd0, _zz_445};
  assign _zz_447 = (_zz_16 ? s2b_0_rsp_context_bytes : 5'h0);
  assign _zz_448 = {9'd0, _zz_447};
  assign _zz_449 = ((b2m_fsm_cmd_doPtrIncr && (b2m_fsm_sel_channel == 1'b0)) ? 1'b1 : 1'b0);
  assign _zz_450 = {9'd0, _zz_449};
  assign _zz_451 = (((io_read_rsp_valid && memory_core_io_writes_2_cmd_ready) && (m2b_rsp_context_channel == 1'b0)) ? 1'b1 : 1'b0);
  assign _zz_452 = {9'd0, _zz_451};
  assign _zz_453 = (_zz_40 ? _zz_455 : 5'h0);
  assign _zz_454 = {9'd0, _zz_453};
  assign _zz_455 = (m2b_writeRsp_context_loadByteInNextBeat + 5'h01);
  assign _zz_456 = ((b2s_0_cmd_channelsOh[0] && memory_core_io_reads_0_cmd_ready) ? 1'b1 : 1'b0);
  assign _zz_457 = {9'd0, _zz_456};
  assign _zz_458 = ((_zz_26 && (s2b_1_cmd_sinkHalted_payload_mask != 16'h0)) ? 1'b1 : 1'b0);
  assign _zz_459 = {9'd0, _zz_458};
  assign _zz_460 = (_zz_28 ? s2b_1_rsp_context_bytes : 5'h0);
  assign _zz_461 = {9'd0, _zz_460};
  assign _zz_462 = ((b2m_fsm_cmd_doPtrIncr && (b2m_fsm_sel_channel == 1'b1)) ? 1'b1 : 1'b0);
  assign _zz_463 = {9'd0, _zz_462};
  assign _zz_464 = (((io_read_rsp_valid && memory_core_io_writes_2_cmd_ready) && (m2b_rsp_context_channel == 1'b1)) ? 1'b1 : 1'b0);
  assign _zz_465 = {9'd0, _zz_464};
  assign _zz_466 = (_zz_41 ? _zz_468 : 5'h0);
  assign _zz_467 = {9'd0, _zz_466};
  assign _zz_468 = (m2b_writeRsp_context_loadByteInNextBeat + 5'h01);
  assign _zz_469 = ((b2s_1_cmd_channelsOh[0] && memory_core_io_reads_1_cmd_ready) ? 1'b1 : 1'b0);
  assign _zz_470 = {9'd0, _zz_469};
  assign _zz_471 = {s2b_0_cmd_sinkHalted_payload_mask[2],{s2b_0_cmd_sinkHalted_payload_mask[1],s2b_0_cmd_sinkHalted_payload_mask[0]}};
  assign _zz_472 = {s2b_0_cmd_sinkHalted_payload_mask[5],{s2b_0_cmd_sinkHalted_payload_mask[4],s2b_0_cmd_sinkHalted_payload_mask[3]}};
  assign _zz_473 = {s2b_0_cmd_sinkHalted_payload_mask[8],{s2b_0_cmd_sinkHalted_payload_mask[7],s2b_0_cmd_sinkHalted_payload_mask[6]}};
  assign _zz_474 = {s2b_0_cmd_sinkHalted_payload_mask[11],{s2b_0_cmd_sinkHalted_payload_mask[10],s2b_0_cmd_sinkHalted_payload_mask[9]}};
  assign _zz_475 = {s2b_0_cmd_sinkHalted_payload_mask[14],{s2b_0_cmd_sinkHalted_payload_mask[13],s2b_0_cmd_sinkHalted_payload_mask[12]}};
  assign _zz_476 = {s2b_1_cmd_sinkHalted_payload_mask[2],{s2b_1_cmd_sinkHalted_payload_mask[1],s2b_1_cmd_sinkHalted_payload_mask[0]}};
  assign _zz_477 = {s2b_1_cmd_sinkHalted_payload_mask[5],{s2b_1_cmd_sinkHalted_payload_mask[4],s2b_1_cmd_sinkHalted_payload_mask[3]}};
  assign _zz_478 = {s2b_1_cmd_sinkHalted_payload_mask[8],{s2b_1_cmd_sinkHalted_payload_mask[7],s2b_1_cmd_sinkHalted_payload_mask[6]}};
  assign _zz_479 = {s2b_1_cmd_sinkHalted_payload_mask[11],{s2b_1_cmd_sinkHalted_payload_mask[10],s2b_1_cmd_sinkHalted_payload_mask[9]}};
  assign _zz_480 = {s2b_1_cmd_sinkHalted_payload_mask[14],{s2b_1_cmd_sinkHalted_payload_mask[13],s2b_1_cmd_sinkHalted_payload_mask[12]}};
  assign _zz_481 = {_zz_68,_zz_67};
  assign _zz_482 = {_zz_72,_zz_71};
  assign _zz_483 = {_zz_76,_zz_75};
  assign _zz_484 = {_zz_80,_zz_79};
  assign _zz_485 = {_zz_85,_zz_84};
  dma_socRuby_DmaMemoryCore memory_core (
    .io_writes_0_cmd_valid               (s2b_0_cmd_sinkHalted_valid                        ), //i
    .io_writes_0_cmd_ready               (memory_core_io_writes_0_cmd_ready                 ), //o
    .io_writes_0_cmd_payload_address     (_zz_120[8:0]                                      ), //i
    .io_writes_0_cmd_payload_data        (s2b_0_cmd_sinkHalted_payload_data[127:0]          ), //i
    .io_writes_0_cmd_payload_mask        (s2b_0_cmd_sinkHalted_payload_mask[15:0]           ), //i
    .io_writes_0_cmd_payload_priority    (channels_0_priority[1:0]                          ), //i
    .io_writes_0_cmd_payload_context     (_zz_121[7:0]                                      ), //i
    .io_writes_0_rsp_valid               (memory_core_io_writes_0_rsp_valid                 ), //o
    .io_writes_0_rsp_payload_context     (memory_core_io_writes_0_rsp_payload_context[7:0]  ), //o
    .io_writes_1_cmd_valid               (s2b_1_cmd_sinkHalted_valid                        ), //i
    .io_writes_1_cmd_ready               (memory_core_io_writes_1_cmd_ready                 ), //o
    .io_writes_1_cmd_payload_address     (_zz_122[8:0]                                      ), //i
    .io_writes_1_cmd_payload_data        (s2b_1_cmd_sinkHalted_payload_data[127:0]          ), //i
    .io_writes_1_cmd_payload_mask        (s2b_1_cmd_sinkHalted_payload_mask[15:0]           ), //i
    .io_writes_1_cmd_payload_priority    (channels_2_priority[1:0]                          ), //i
    .io_writes_1_cmd_payload_context     (_zz_123[7:0]                                      ), //i
    .io_writes_1_rsp_valid               (memory_core_io_writes_1_rsp_valid                 ), //o
    .io_writes_1_rsp_payload_context     (memory_core_io_writes_1_rsp_payload_context[7:0]  ), //o
    .io_writes_2_cmd_valid               (io_read_rsp_valid                                 ), //i
    .io_writes_2_cmd_ready               (memory_core_io_writes_2_cmd_ready                 ), //o
    .io_writes_2_cmd_payload_address     (_zz_124[8:0]                                      ), //i
    .io_writes_2_cmd_payload_data        (io_read_rsp_payload_fragment_data[127:0]          ), //i
    .io_writes_2_cmd_payload_mask        (_zz_125[15:0]                                     ), //i
    .io_writes_2_cmd_payload_context     (_zz_126[7:0]                                      ), //i
    .io_writes_2_rsp_valid               (memory_core_io_writes_2_rsp_valid                 ), //o
    .io_writes_2_rsp_payload_context     (memory_core_io_writes_2_rsp_payload_context[7:0]  ), //o
    .io_reads_0_cmd_valid                (_zz_127                                           ), //i
    .io_reads_0_cmd_ready                (memory_core_io_reads_0_cmd_ready                  ), //o
    .io_reads_0_cmd_payload_address      (_zz_128[8:0]                                      ), //i
    .io_reads_0_cmd_payload_priority     (channels_1_priority[1:0]                          ), //i
    .io_reads_0_cmd_payload_context      (_zz_129[2:0]                                      ), //i
    .io_reads_0_rsp_valid                (memory_core_io_reads_0_rsp_valid                  ), //o
    .io_reads_0_rsp_ready                (io_outputs_0_ready                                ), //i
    .io_reads_0_rsp_payload_data         (memory_core_io_reads_0_rsp_payload_data[127:0]    ), //o
    .io_reads_0_rsp_payload_mask         (memory_core_io_reads_0_rsp_payload_mask[15:0]     ), //o
    .io_reads_0_rsp_payload_context      (memory_core_io_reads_0_rsp_payload_context[2:0]   ), //o
    .io_reads_1_cmd_valid                (_zz_130                                           ), //i
    .io_reads_1_cmd_ready                (memory_core_io_reads_1_cmd_ready                  ), //o
    .io_reads_1_cmd_payload_address      (_zz_131[8:0]                                      ), //i
    .io_reads_1_cmd_payload_priority     (channels_3_priority[1:0]                          ), //i
    .io_reads_1_cmd_payload_context      (_zz_132[2:0]                                      ), //i
    .io_reads_1_rsp_valid                (memory_core_io_reads_1_rsp_valid                  ), //o
    .io_reads_1_rsp_ready                (io_outputs_1_ready                                ), //i
    .io_reads_1_rsp_payload_data         (memory_core_io_reads_1_rsp_payload_data[127:0]    ), //o
    .io_reads_1_rsp_payload_mask         (memory_core_io_reads_1_rsp_payload_mask[15:0]     ), //o
    .io_reads_1_rsp_payload_context      (memory_core_io_reads_1_rsp_payload_context[2:0]   ), //o
    .io_reads_2_cmd_valid                (b2m_fsm_sel_valid                                 ), //i
    .io_reads_2_cmd_ready                (memory_core_io_reads_2_cmd_ready                  ), //o
    .io_reads_2_cmd_payload_address      (_zz_133[8:0]                                      ), //i
    .io_reads_2_cmd_payload_context      (_zz_134[10:0]                                     ), //i
    .io_reads_2_rsp_valid                (memory_core_io_reads_2_rsp_valid                  ), //o
    .io_reads_2_rsp_ready                (_zz_135                                           ), //i
    .io_reads_2_rsp_payload_data         (memory_core_io_reads_2_rsp_payload_data[127:0]    ), //o
    .io_reads_2_rsp_payload_mask         (memory_core_io_reads_2_rsp_payload_mask[15:0]     ), //o
    .io_reads_2_rsp_payload_context      (memory_core_io_reads_2_rsp_payload_context[10:0]  ), //o
    .clk                                 (clk                                               ), //i
    .reset                               (reset                                             )  //i
  );
  dma_socRuby_Aggregator b2m_fsm_aggregate_engine (
    .io_input_valid            (b2m_fsm_aggregate_memoryPort_valid                 ), //i
    .io_input_ready            (b2m_fsm_aggregate_engine_io_input_ready            ), //o
    .io_input_payload_data     (b2m_fsm_aggregate_memoryPort_payload_data[127:0]   ), //i
    .io_input_payload_mask     (_zz_136[15:0]                                      ), //i
    .io_output_data            (b2m_fsm_aggregate_engine_io_output_data[127:0]     ), //o
    .io_output_mask            (b2m_fsm_aggregate_engine_io_output_mask[15:0]      ), //o
    .io_output_enough          (b2m_fsm_cmd_enoughAggregation                      ), //i
    .io_output_consume         (_zz_137                                            ), //i
    .io_output_consumed        (b2m_fsm_aggregate_engine_io_output_consumed        ), //o
    .io_output_lastByteUsed    (b2m_fsm_cmd_maskLastTriggerReg[3:0]                ), //i
    .io_output_usedUntil       (b2m_fsm_aggregate_engine_io_output_usedUntil[3:0]  ), //o
    .io_flush                  (_zz_138                                            ), //i
    .io_offset                 (_zz_139[3:0]                                       ), //i
    .io_burstLength            (b2m_fsm_sel_bytesInBurst[11:0]                     ), //i
    .clk                       (clk                                                ), //i
    .reset                     (reset                                              )  //i
  );
  always @(*) begin
    case(_zz_471)
      3'b000 : begin
        _zz_140 = _zz_6;
      end
      3'b001 : begin
        _zz_140 = _zz_7;
      end
      3'b010 : begin
        _zz_140 = _zz_8;
      end
      3'b011 : begin
        _zz_140 = _zz_9;
      end
      3'b100 : begin
        _zz_140 = _zz_10;
      end
      3'b101 : begin
        _zz_140 = _zz_11;
      end
      3'b110 : begin
        _zz_140 = _zz_12;
      end
      default : begin
        _zz_140 = _zz_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_472)
      3'b000 : begin
        _zz_141 = _zz_6;
      end
      3'b001 : begin
        _zz_141 = _zz_7;
      end
      3'b010 : begin
        _zz_141 = _zz_8;
      end
      3'b011 : begin
        _zz_141 = _zz_9;
      end
      3'b100 : begin
        _zz_141 = _zz_10;
      end
      3'b101 : begin
        _zz_141 = _zz_11;
      end
      3'b110 : begin
        _zz_141 = _zz_12;
      end
      default : begin
        _zz_141 = _zz_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_473)
      3'b000 : begin
        _zz_142 = _zz_6;
      end
      3'b001 : begin
        _zz_142 = _zz_7;
      end
      3'b010 : begin
        _zz_142 = _zz_8;
      end
      3'b011 : begin
        _zz_142 = _zz_9;
      end
      3'b100 : begin
        _zz_142 = _zz_10;
      end
      3'b101 : begin
        _zz_142 = _zz_11;
      end
      3'b110 : begin
        _zz_142 = _zz_12;
      end
      default : begin
        _zz_142 = _zz_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_474)
      3'b000 : begin
        _zz_143 = _zz_6;
      end
      3'b001 : begin
        _zz_143 = _zz_7;
      end
      3'b010 : begin
        _zz_143 = _zz_8;
      end
      3'b011 : begin
        _zz_143 = _zz_9;
      end
      3'b100 : begin
        _zz_143 = _zz_10;
      end
      3'b101 : begin
        _zz_143 = _zz_11;
      end
      3'b110 : begin
        _zz_143 = _zz_12;
      end
      default : begin
        _zz_143 = _zz_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_475)
      3'b000 : begin
        _zz_144 = _zz_6;
      end
      3'b001 : begin
        _zz_144 = _zz_7;
      end
      3'b010 : begin
        _zz_144 = _zz_8;
      end
      3'b011 : begin
        _zz_144 = _zz_9;
      end
      3'b100 : begin
        _zz_144 = _zz_10;
      end
      3'b101 : begin
        _zz_144 = _zz_11;
      end
      3'b110 : begin
        _zz_144 = _zz_12;
      end
      default : begin
        _zz_144 = _zz_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_276)
      3'b000 : begin
        _zz_145 = _zz_6;
      end
      3'b001 : begin
        _zz_145 = _zz_7;
      end
      3'b010 : begin
        _zz_145 = _zz_8;
      end
      3'b011 : begin
        _zz_145 = _zz_9;
      end
      3'b100 : begin
        _zz_145 = _zz_10;
      end
      3'b101 : begin
        _zz_145 = _zz_11;
      end
      3'b110 : begin
        _zz_145 = _zz_12;
      end
      default : begin
        _zz_145 = _zz_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_476)
      3'b000 : begin
        _zz_146 = _zz_18;
      end
      3'b001 : begin
        _zz_146 = _zz_19;
      end
      3'b010 : begin
        _zz_146 = _zz_20;
      end
      3'b011 : begin
        _zz_146 = _zz_21;
      end
      3'b100 : begin
        _zz_146 = _zz_22;
      end
      3'b101 : begin
        _zz_146 = _zz_23;
      end
      3'b110 : begin
        _zz_146 = _zz_24;
      end
      default : begin
        _zz_146 = _zz_25;
      end
    endcase
  end

  always @(*) begin
    case(_zz_477)
      3'b000 : begin
        _zz_147 = _zz_18;
      end
      3'b001 : begin
        _zz_147 = _zz_19;
      end
      3'b010 : begin
        _zz_147 = _zz_20;
      end
      3'b011 : begin
        _zz_147 = _zz_21;
      end
      3'b100 : begin
        _zz_147 = _zz_22;
      end
      3'b101 : begin
        _zz_147 = _zz_23;
      end
      3'b110 : begin
        _zz_147 = _zz_24;
      end
      default : begin
        _zz_147 = _zz_25;
      end
    endcase
  end

  always @(*) begin
    case(_zz_478)
      3'b000 : begin
        _zz_148 = _zz_18;
      end
      3'b001 : begin
        _zz_148 = _zz_19;
      end
      3'b010 : begin
        _zz_148 = _zz_20;
      end
      3'b011 : begin
        _zz_148 = _zz_21;
      end
      3'b100 : begin
        _zz_148 = _zz_22;
      end
      3'b101 : begin
        _zz_148 = _zz_23;
      end
      3'b110 : begin
        _zz_148 = _zz_24;
      end
      default : begin
        _zz_148 = _zz_25;
      end
    endcase
  end

  always @(*) begin
    case(_zz_479)
      3'b000 : begin
        _zz_149 = _zz_18;
      end
      3'b001 : begin
        _zz_149 = _zz_19;
      end
      3'b010 : begin
        _zz_149 = _zz_20;
      end
      3'b011 : begin
        _zz_149 = _zz_21;
      end
      3'b100 : begin
        _zz_149 = _zz_22;
      end
      3'b101 : begin
        _zz_149 = _zz_23;
      end
      3'b110 : begin
        _zz_149 = _zz_24;
      end
      default : begin
        _zz_149 = _zz_25;
      end
    endcase
  end

  always @(*) begin
    case(_zz_480)
      3'b000 : begin
        _zz_150 = _zz_18;
      end
      3'b001 : begin
        _zz_150 = _zz_19;
      end
      3'b010 : begin
        _zz_150 = _zz_20;
      end
      3'b011 : begin
        _zz_150 = _zz_21;
      end
      3'b100 : begin
        _zz_150 = _zz_22;
      end
      3'b101 : begin
        _zz_150 = _zz_23;
      end
      3'b110 : begin
        _zz_150 = _zz_24;
      end
      default : begin
        _zz_150 = _zz_25;
      end
    endcase
  end

  always @(*) begin
    case(_zz_284)
      3'b000 : begin
        _zz_151 = _zz_18;
      end
      3'b001 : begin
        _zz_151 = _zz_19;
      end
      3'b010 : begin
        _zz_151 = _zz_20;
      end
      3'b011 : begin
        _zz_151 = _zz_21;
      end
      3'b100 : begin
        _zz_151 = _zz_22;
      end
      3'b101 : begin
        _zz_151 = _zz_23;
      end
      3'b110 : begin
        _zz_151 = _zz_24;
      end
      default : begin
        _zz_151 = _zz_25;
      end
    endcase
  end

  always @(*) begin
    case(_zz_33)
      2'b00 : begin
        _zz_152 = m2b_cmd_s0_priority_roundRobins_0;
      end
      2'b01 : begin
        _zz_152 = m2b_cmd_s0_priority_roundRobins_1;
      end
      2'b10 : begin
        _zz_152 = m2b_cmd_s0_priority_roundRobins_2;
      end
      default : begin
        _zz_152 = m2b_cmd_s0_priority_roundRobins_3;
      end
    endcase
  end

  always @(*) begin
    case(m2b_cmd_s0_priority_chosen)
      1'b0 : begin
        _zz_153 = (channels_1_weight == m2b_cmd_s0_priority_counter);
      end
      default : begin
        _zz_153 = (channels_3_weight == m2b_cmd_s0_priority_counter);
      end
    endcase
  end

  always @(*) begin
    case(m2b_cmd_s0_chosen)
      1'b0 : begin
        _zz_154 = channels_1_push_m2b_address;
        _zz_155 = channels_1_push_m2b_bytesLeft;
        _zz_156 = channels_1_push_m2b_bytePerBurst;
      end
      default : begin
        _zz_154 = channels_3_push_m2b_address;
        _zz_155 = channels_3_push_m2b_bytesLeft;
        _zz_156 = channels_3_push_m2b_bytePerBurst;
      end
    endcase
  end

  always @(*) begin
    case(m2b_rsp_context_channel)
      1'b0 : begin
        _zz_157 = channels_1_fifo_push_ptrWithBase;
      end
      default : begin
        _zz_157 = channels_3_fifo_push_ptrWithBase;
      end
    endcase
  end

  always @(*) begin
    case(_zz_44)
      2'b00 : begin
        _zz_158 = b2m_fsm_arbiter_logic_priority_roundRobins_0;
      end
      2'b01 : begin
        _zz_158 = b2m_fsm_arbiter_logic_priority_roundRobins_1;
      end
      2'b10 : begin
        _zz_158 = b2m_fsm_arbiter_logic_priority_roundRobins_2;
      end
      default : begin
        _zz_158 = b2m_fsm_arbiter_logic_priority_roundRobins_3;
      end
    endcase
  end

  always @(*) begin
    case(b2m_fsm_arbiter_logic_priority_chosen)
      1'b0 : begin
        _zz_159 = (channels_0_weight == b2m_fsm_arbiter_logic_priority_counter);
      end
      default : begin
        _zz_159 = (channels_2_weight == b2m_fsm_arbiter_logic_priority_counter);
      end
    endcase
  end

  always @(*) begin
    case(b2m_fsm_arbiter_logic_chosen)
      1'b0 : begin
        _zz_160 = channels_0_pop_b2m_address;
        _zz_161 = channels_0_fifo_pop_ptrWithBase;
        _zz_162 = channels_0_fifo_words;
        _zz_163 = channels_0_pop_b2m_bytePerBurst;
        _zz_164 = channels_0_fifo_pop_bytes;
        _zz_165 = channels_0_pop_b2m_flush;
        _zz_166 = channels_0_pop_b2m_packet;
        _zz_167 = channels_0_pop_b2m_bytesLeft;
      end
      default : begin
        _zz_160 = channels_2_pop_b2m_address;
        _zz_161 = channels_2_fifo_pop_ptrWithBase;
        _zz_162 = channels_2_fifo_words;
        _zz_163 = channels_2_pop_b2m_bytePerBurst;
        _zz_164 = channels_2_fifo_pop_bytes;
        _zz_165 = channels_2_pop_b2m_flush;
        _zz_166 = channels_2_pop_b2m_packet;
        _zz_167 = channels_2_pop_b2m_bytesLeft;
      end
    endcase
  end

  always @(*) begin
    case(b2m_fsm_sel_channel)
      1'b0 : begin
        _zz_168 = channels_0_fifo_pop_ptr;
        _zz_169 = channels_0_pop_b2m_bytesToSkip;
      end
      default : begin
        _zz_168 = channels_2_fifo_pop_ptr;
        _zz_169 = channels_2_pop_b2m_bytesToSkip;
      end
    endcase
  end

  always @(*) begin
    case(_zz_481)
      2'b00 : begin
        _zz_170 = channels_0_ll_head;
      end
      2'b01 : begin
        _zz_170 = channels_1_ll_head;
      end
      2'b10 : begin
        _zz_170 = channels_2_ll_head;
      end
      default : begin
        _zz_170 = channels_3_ll_head;
      end
    endcase
  end

  always @(*) begin
    case(_zz_482)
      2'b00 : begin
        _zz_171 = channels_0_descriptorValid;
      end
      2'b01 : begin
        _zz_171 = channels_1_descriptorValid;
      end
      2'b10 : begin
        _zz_171 = channels_2_descriptorValid;
      end
      default : begin
        _zz_171 = channels_3_descriptorValid;
      end
    endcase
  end

  always @(*) begin
    case(_zz_483)
      2'b00 : begin
        _zz_172 = channels_0_ll_ptr;
      end
      2'b01 : begin
        _zz_172 = channels_1_ll_ptr;
      end
      2'b10 : begin
        _zz_172 = channels_2_ll_ptr;
      end
      default : begin
        _zz_172 = channels_3_ll_ptr;
      end
    endcase
  end

  always @(*) begin
    case(_zz_484)
      2'b00 : begin
        _zz_173 = channels_0_ll_ptrNext;
      end
      2'b01 : begin
        _zz_173 = channels_1_ll_ptrNext;
      end
      2'b10 : begin
        _zz_173 = channels_2_ll_ptrNext;
      end
      default : begin
        _zz_173 = channels_3_ll_ptrNext;
      end
    endcase
  end

  always @(*) begin
    case(_zz_485)
      2'b00 : begin
        _zz_174 = channels_0_ll_packet;
      end
      2'b01 : begin
        _zz_174 = channels_1_ll_packet;
      end
      2'b10 : begin
        _zz_174 = channels_2_ll_packet;
      end
      default : begin
        _zz_174 = channels_3_ll_packet;
      end
    endcase
  end

  assign io_ctrl_PREADY = 1'b1;
  always @ (*) begin
    io_ctrl_PRDATA = 32'h0;
    case(io_ctrl_PADDR)
      14'h002c : begin
        io_ctrl_PRDATA[0 : 0] = channels_0_channelValid;
      end
      14'h0070 : begin
        io_ctrl_PRDATA[31 : 0] = channels_0_ll_ptr;
      end
      14'h0054 : begin
        io_ctrl_PRDATA[0 : 0] = channels_0_interrupts_completion_valid;
        io_ctrl_PRDATA[2 : 2] = channels_0_interrupts_onChannelCompletion_valid;
        io_ctrl_PRDATA[3 : 3] = channels_0_interrupts_onLinkedListUpdate_valid;
        io_ctrl_PRDATA[4 : 4] = channels_0_interrupts_s2mPacket_valid;
      end
      14'h00ac : begin
        io_ctrl_PRDATA[0 : 0] = channels_1_channelValid;
      end
      14'h00f0 : begin
        io_ctrl_PRDATA[31 : 0] = channels_1_ll_ptr;
      end
      14'h00d4 : begin
        io_ctrl_PRDATA[0 : 0] = channels_1_interrupts_completion_valid;
        io_ctrl_PRDATA[2 : 2] = channels_1_interrupts_onChannelCompletion_valid;
        io_ctrl_PRDATA[3 : 3] = channels_1_interrupts_onLinkedListUpdate_valid;
      end
      14'h012c : begin
        io_ctrl_PRDATA[0 : 0] = channels_2_channelValid;
      end
      14'h0170 : begin
        io_ctrl_PRDATA[31 : 0] = channels_2_ll_ptr;
      end
      14'h0154 : begin
        io_ctrl_PRDATA[0 : 0] = channels_2_interrupts_completion_valid;
        io_ctrl_PRDATA[2 : 2] = channels_2_interrupts_onChannelCompletion_valid;
        io_ctrl_PRDATA[3 : 3] = channels_2_interrupts_onLinkedListUpdate_valid;
        io_ctrl_PRDATA[4 : 4] = channels_2_interrupts_s2mPacket_valid;
      end
      14'h01ac : begin
        io_ctrl_PRDATA[0 : 0] = channels_3_channelValid;
      end
      14'h01f0 : begin
        io_ctrl_PRDATA[31 : 0] = channels_3_ll_ptr;
      end
      14'h01d4 : begin
        io_ctrl_PRDATA[0 : 0] = channels_3_interrupts_completion_valid;
        io_ctrl_PRDATA[2 : 2] = channels_3_interrupts_onChannelCompletion_valid;
        io_ctrl_PRDATA[3 : 3] = channels_3_interrupts_onLinkedListUpdate_valid;
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_PSLVERROR = 1'b0;
  assign ctrl_askWrite = ((io_ctrl_PSEL[0] && io_ctrl_PENABLE) && io_ctrl_PWRITE);
  assign ctrl_askRead = ((io_ctrl_PSEL[0] && io_ctrl_PENABLE) && (! io_ctrl_PWRITE));
  assign ctrl_doWrite = (((io_ctrl_PSEL[0] && io_ctrl_PENABLE) && io_ctrl_PREADY) && io_ctrl_PWRITE);
  assign ctrl_doRead = (((io_ctrl_PSEL[0] && io_ctrl_PENABLE) && io_ctrl_PREADY) && (! io_ctrl_PWRITE));
  always @ (*) begin
    channels_0_channelStart = 1'b0;
    if(_zz_90)begin
      if(_zz_341[0])begin
        channels_0_channelStart = _zz_342[0];
      end
    end
    if(_zz_92)begin
      if(_zz_345[0])begin
        channels_0_channelStart = _zz_346[0];
      end
    end
  end

  always @ (*) begin
    channels_0_channelCompletion = 1'b0;
    if(channels_0_channelValid)begin
      if(channels_0_channelStop)begin
        if(channels_0_readyToStop)begin
          channels_0_channelCompletion = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_0_descriptorStart = 1'b0;
    if(channels_0_ctrl_kick)begin
      channels_0_descriptorStart = 1'b1;
    end
    if(_zz_175)begin
      if(_zz_176)begin
        if(_zz_177)begin
          channels_0_descriptorStart = 1'b1;
        end
      end
    end
    if(channels_0_channelValid)begin
      if(! channels_0_channelStop) begin
        if(_zz_178)begin
          if(_zz_179)begin
            channels_0_descriptorStart = 1'b1;
          end
        end
      end
    end
  end

  always @ (*) begin
    channels_0_descriptorCompletion = 1'b0;
    if(channels_0_pop_b2m_packetSync)begin
      if(_zz_180)begin
        if(channels_0_push_s2b_completionOnLast)begin
          channels_0_descriptorCompletion = 1'b1;
        end
      end
    end
    if(((channels_0_descriptorValid && (channels_0_pop_b2m_memPending == 4'b0000)) && channels_0_pop_b2m_waitFinalRsp))begin
      channels_0_descriptorCompletion = 1'b1;
    end
    if(channels_0_channelValid)begin
      if(channels_0_channelStop)begin
        if(channels_0_readyToStop)begin
          channels_0_descriptorCompletion = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_0_readyToStop = 1'b1;
    if(channels_0_ll_waitDone)begin
      channels_0_readyToStop = 1'b0;
    end
    if((channels_0_pop_b2m_memPending != 4'b0000))begin
      channels_0_readyToStop = 1'b0;
    end
  end

  always @ (*) begin
    channels_0_bytesProbe_incr_valid = 1'b0;
    if(_zz_181)begin
      if(_zz_182)begin
        channels_0_bytesProbe_incr_valid = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_0_bytesProbe_incr_payload = 12'h0;
    if(_zz_181)begin
      if(_zz_182)begin
        channels_0_bytesProbe_incr_payload = b2m_rsp_context_length;
      end
    end
  end

  always @ (*) begin
    channels_0_ll_sgStart = 1'b0;
    if(_zz_93)begin
      if(_zz_347[0])begin
        channels_0_ll_sgStart = _zz_348[0];
      end
    end
  end

  assign channels_0_ll_requestLl = ((((channels_0_channelValid && channels_0_ll_valid) && (! channels_0_channelStop)) && (! channels_0_ll_waitDone)) && ((! channels_0_descriptorValid) || channels_0_ll_requireSync));
  always @ (*) begin
    channels_0_ll_descriptorUpdated = 1'b0;
    if(_zz_175)begin
      if((! channels_0_ll_head))begin
        channels_0_ll_descriptorUpdated = 1'b1;
      end
    end
  end

  assign channels_0_fifo_base = 10'h0;
  assign channels_0_fifo_words = 10'h07f;
  assign channels_0_fifo_push_availableDecr = 10'h0;
  assign channels_0_fifo_push_ptrWithBase = ((channels_0_fifo_base & (~ channels_0_fifo_words)) | (channels_0_fifo_push_ptr & channels_0_fifo_words));
  assign channels_0_fifo_pop_ptrWithBase = ((channels_0_fifo_base & (~ channels_0_fifo_words)) | (channels_0_fifo_pop_ptr & channels_0_fifo_words));
  assign channels_0_fifo_pop_empty = (channels_0_fifo_pop_ptr == channels_0_fifo_push_ptr);
  assign channels_0_fifo_pop_withOverride_backupNext = (_zz_217 - channels_0_fifo_pop_bytesDecr_value);
  always @ (*) begin
    channels_0_fifo_pop_withOverride_load = 1'b0;
    if((channels_0_push_s2b_packetEvent && channels_0_push_s2b_completionOnLast))begin
      channels_0_fifo_pop_withOverride_load = 1'b1;
    end
  end

  always @ (*) begin
    channels_0_fifo_pop_withOverride_unload = 1'b0;
    if(channels_0_pop_b2m_packetSync)begin
      channels_0_fifo_pop_withOverride_unload = 1'b1;
    end
  end

  assign channels_0_fifo_pop_bytes = channels_0_fifo_pop_withOverride_exposed;
  assign channels_0_fifo_empty = (channels_0_fifo_push_ptr == channels_0_fifo_pop_ptr);
  always @ (*) begin
    channels_0_push_s2b_packetEvent = 1'b0;
    if((_zz_16 && s2b_0_rsp_context_packet))begin
      channels_0_push_s2b_packetEvent = 1'b1;
    end
  end

  assign channels_0_pop_b2m_bytePerBurst = 12'h1ff;
  always @ (*) begin
    channels_0_pop_b2m_fire = 1'b0;
    if(_zz_183)begin
      if(_zz_49[0])begin
        channels_0_pop_b2m_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_0_pop_b2m_packetSync = 1'b0;
    if(_zz_184)begin
      if(channels_0_pop_b2m_packet)begin
        channels_0_pop_b2m_packetSync = 1'b1;
      end
    end
    if(_zz_181)begin
      if(_zz_182)begin
        if(b2m_rsp_context_doPacketSync)begin
          channels_0_pop_b2m_packetSync = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_0_pop_b2m_memRsp = 1'b0;
    if(_zz_181)begin
      if(_zz_59[0])begin
        channels_0_pop_b2m_memRsp = 1'b1;
      end
    end
  end

  assign channels_0_pop_b2m_request = ((((((channels_0_descriptorValid && (! channels_0_channelStop)) && (! channels_0_pop_b2m_waitFinalRsp)) && channels_0_pop_memory) && ((_zz_219 < channels_0_fifo_pop_bytes) || ((channels_0_fifo_push_available < _zz_221) || channels_0_pop_b2m_flush))) && (channels_0_fifo_pop_bytes != 14'h0)) && (channels_0_pop_b2m_memPending != 4'b1111));
  always @ (*) begin
    channels_0_pop_b2m_memPendingInc = 1'b0;
    if(_zz_185)begin
      if((channels_0_pop_b2m_request && b2m_fsm_arbiter_logic_priority_chosenOh[0]))begin
        channels_0_pop_b2m_memPendingInc = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_0_pop_b2m_decrBytes = 14'h0;
    if(b2m_fsm_s1)begin
      if(_zz_186)begin
        channels_0_pop_b2m_decrBytes = {2'd0, b2m_fsm_bytesInBurstP1};
      end
    end
  end

  assign channels_0_readyForChannelCompletion = 1'b1;
  always @ (*) begin
    _zz_1 = 1'b1;
    if(_zz_179)begin
      _zz_1 = 1'b0;
    end
    if(channels_0_ctrl_kick)begin
      _zz_1 = 1'b0;
    end
    if(channels_0_ll_valid)begin
      _zz_1 = 1'b0;
    end
  end

  assign channels_0_s2b_full = (channels_0_fifo_push_available < 10'h002);
  always @ (*) begin
    channels_1_channelStart = 1'b0;
    if(_zz_98)begin
      if(_zz_357[0])begin
        channels_1_channelStart = _zz_358[0];
      end
    end
    if(_zz_100)begin
      if(_zz_361[0])begin
        channels_1_channelStart = _zz_362[0];
      end
    end
  end

  always @ (*) begin
    channels_1_channelCompletion = 1'b0;
    if(channels_1_channelValid)begin
      if(channels_1_channelStop)begin
        if(channels_1_readyToStop)begin
          channels_1_channelCompletion = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_1_descriptorStart = 1'b0;
    if(channels_1_ctrl_kick)begin
      channels_1_descriptorStart = 1'b1;
    end
    if(_zz_187)begin
      if(_zz_188)begin
        if(_zz_189)begin
          channels_1_descriptorStart = 1'b1;
        end
      end
    end
    if(channels_1_channelValid)begin
      if(! channels_1_channelStop) begin
        if(_zz_190)begin
          if(_zz_191)begin
            channels_1_descriptorStart = 1'b1;
          end
        end
      end
    end
  end

  always @ (*) begin
    channels_1_descriptorCompletion = 1'b0;
    if(((((channels_1_descriptorValid && (! channels_1_pop_memory)) && channels_1_push_memory) && channels_1_push_m2b_loadDone) && (channels_1_push_m2b_memPending == 4'b0000)))begin
      channels_1_descriptorCompletion = 1'b1;
    end
    if(channels_1_channelValid)begin
      if(channels_1_channelStop)begin
        if(channels_1_readyToStop)begin
          channels_1_descriptorCompletion = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_1_readyToStop = 1'b1;
    if(channels_1_ll_waitDone)begin
      channels_1_readyToStop = 1'b0;
    end
    if((channels_1_push_m2b_memPending != 4'b0000))begin
      channels_1_readyToStop = 1'b0;
    end
  end

  always @ (*) begin
    channels_1_ll_sgStart = 1'b0;
    if(_zz_101)begin
      if(_zz_363[0])begin
        channels_1_ll_sgStart = _zz_364[0];
      end
    end
  end

  assign channels_1_ll_requestLl = ((((channels_1_channelValid && channels_1_ll_valid) && (! channels_1_channelStop)) && (! channels_1_ll_waitDone)) && ((! channels_1_descriptorValid) || channels_1_ll_requireSync));
  always @ (*) begin
    channels_1_ll_descriptorUpdated = 1'b0;
    if(_zz_187)begin
      if((! channels_1_ll_head))begin
        channels_1_ll_descriptorUpdated = 1'b1;
      end
    end
  end

  assign channels_1_fifo_base = 10'h080;
  assign channels_1_fifo_words = 10'h07f;
  always @ (*) begin
    channels_1_fifo_push_availableDecr = 10'h0;
    if(m2b_cmd_s1_valid)begin
      if(io_read_cmd_ready)begin
        if(_zz_192)begin
          channels_1_fifo_push_availableDecr = {1'd0, m2b_cmd_s1_fifoPushDecr};
        end
      end
    end
  end

  assign channels_1_fifo_push_ptrWithBase = ((channels_1_fifo_base & (~ channels_1_fifo_words)) | (channels_1_fifo_push_ptr & channels_1_fifo_words));
  assign channels_1_fifo_pop_ptrWithBase = ((channels_1_fifo_base & (~ channels_1_fifo_words)) | (channels_1_fifo_pop_ptr & channels_1_fifo_words));
  assign channels_1_fifo_pop_empty = (channels_1_fifo_pop_ptr == channels_1_fifo_push_ptr);
  assign channels_1_fifo_pop_bytes = channels_1_fifo_pop_withoutOverride_exposed;
  assign channels_1_fifo_empty = (channels_1_fifo_push_ptr == channels_1_fifo_pop_ptr);
  assign channels_1_push_m2b_bytePerBurst = 12'h1ff;
  always @ (*) begin
    channels_1_push_m2b_memPendingIncr = 1'b0;
    if(_zz_193)begin
      if((channels_1_push_m2b_loadRequest && m2b_cmd_s0_priority_chosenOh[0]))begin
        channels_1_push_m2b_memPendingIncr = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_1_push_m2b_memPendingDecr = 1'b0;
    if((_zz_40 && m2b_writeRsp_context_lastOfBurst))begin
      channels_1_push_m2b_memPendingDecr = 1'b1;
    end
  end

  always @ (*) begin
    channels_1_push_m2b_loadRequest = (((((channels_1_descriptorValid && (! channels_1_channelStop)) && (! channels_1_push_m2b_loadDone)) && channels_1_push_memory) && (_zz_238 < channels_1_fifo_push_available)) && (channels_1_push_m2b_memPending != 4'b1111));
    if((((! channels_1_pop_memory) && channels_1_pop_b2s_veryLastValid) && (channels_1_push_m2b_bytesLeft <= _zz_239)))begin
      channels_1_push_m2b_loadRequest = 1'b0;
    end
  end

  always @ (*) begin
    channels_1_pop_b2s_veryLastTrigger = 1'b0;
    if(_zz_194)begin
      if((m2b_rsp_context_channel == 1'b0))begin
        channels_1_pop_b2s_veryLastTrigger = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_1_readyForChannelCompletion = 1'b1;
    if(((! channels_1_pop_memory) && (! channels_1_fifo_pop_empty)))begin
      channels_1_readyForChannelCompletion = 1'b0;
    end
  end

  always @ (*) begin
    _zz_2 = 1'b1;
    if(_zz_191)begin
      _zz_2 = 1'b0;
    end
    if(channels_1_ctrl_kick)begin
      _zz_2 = 1'b0;
    end
    if(channels_1_ll_valid)begin
      _zz_2 = 1'b0;
    end
  end

  assign channels_1_s2b_full = (channels_1_fifo_push_available < 10'h002);
  always @ (*) begin
    channels_2_channelStart = 1'b0;
    if(_zz_105)begin
      if(_zz_371[0])begin
        channels_2_channelStart = _zz_372[0];
      end
    end
    if(_zz_107)begin
      if(_zz_375[0])begin
        channels_2_channelStart = _zz_376[0];
      end
    end
  end

  always @ (*) begin
    channels_2_channelCompletion = 1'b0;
    if(channels_2_channelValid)begin
      if(channels_2_channelStop)begin
        if(channels_2_readyToStop)begin
          channels_2_channelCompletion = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_2_descriptorStart = 1'b0;
    if(channels_2_ctrl_kick)begin
      channels_2_descriptorStart = 1'b1;
    end
    if(_zz_195)begin
      if(_zz_196)begin
        if(_zz_197)begin
          channels_2_descriptorStart = 1'b1;
        end
      end
    end
    if(channels_2_channelValid)begin
      if(! channels_2_channelStop) begin
        if(_zz_198)begin
          if(_zz_199)begin
            channels_2_descriptorStart = 1'b1;
          end
        end
      end
    end
  end

  always @ (*) begin
    channels_2_descriptorCompletion = 1'b0;
    if(channels_2_pop_b2m_packetSync)begin
      if(_zz_200)begin
        if(channels_2_push_s2b_completionOnLast)begin
          channels_2_descriptorCompletion = 1'b1;
        end
      end
    end
    if(((channels_2_descriptorValid && (channels_2_pop_b2m_memPending == 4'b0000)) && channels_2_pop_b2m_waitFinalRsp))begin
      channels_2_descriptorCompletion = 1'b1;
    end
    if(channels_2_channelValid)begin
      if(channels_2_channelStop)begin
        if(channels_2_readyToStop)begin
          channels_2_descriptorCompletion = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_2_readyToStop = 1'b1;
    if(channels_2_ll_waitDone)begin
      channels_2_readyToStop = 1'b0;
    end
    if((channels_2_pop_b2m_memPending != 4'b0000))begin
      channels_2_readyToStop = 1'b0;
    end
  end

  always @ (*) begin
    channels_2_bytesProbe_incr_valid = 1'b0;
    if(_zz_181)begin
      if(_zz_201)begin
        channels_2_bytesProbe_incr_valid = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_2_bytesProbe_incr_payload = 12'h0;
    if(_zz_181)begin
      if(_zz_201)begin
        channels_2_bytesProbe_incr_payload = b2m_rsp_context_length;
      end
    end
  end

  always @ (*) begin
    channels_2_ll_sgStart = 1'b0;
    if(_zz_108)begin
      if(_zz_377[0])begin
        channels_2_ll_sgStart = _zz_378[0];
      end
    end
  end

  assign channels_2_ll_requestLl = ((((channels_2_channelValid && channels_2_ll_valid) && (! channels_2_channelStop)) && (! channels_2_ll_waitDone)) && ((! channels_2_descriptorValid) || channels_2_ll_requireSync));
  always @ (*) begin
    channels_2_ll_descriptorUpdated = 1'b0;
    if(_zz_195)begin
      if((! channels_2_ll_head))begin
        channels_2_ll_descriptorUpdated = 1'b1;
      end
    end
  end

  assign channels_2_fifo_base = 10'h100;
  assign channels_2_fifo_words = 10'h07f;
  assign channels_2_fifo_push_availableDecr = 10'h0;
  assign channels_2_fifo_push_ptrWithBase = ((channels_2_fifo_base & (~ channels_2_fifo_words)) | (channels_2_fifo_push_ptr & channels_2_fifo_words));
  assign channels_2_fifo_pop_ptrWithBase = ((channels_2_fifo_base & (~ channels_2_fifo_words)) | (channels_2_fifo_pop_ptr & channels_2_fifo_words));
  assign channels_2_fifo_pop_empty = (channels_2_fifo_pop_ptr == channels_2_fifo_push_ptr);
  assign channels_2_fifo_pop_withOverride_backupNext = (_zz_245 - channels_2_fifo_pop_bytesDecr_value);
  always @ (*) begin
    channels_2_fifo_pop_withOverride_load = 1'b0;
    if((channels_2_push_s2b_packetEvent && channels_2_push_s2b_completionOnLast))begin
      channels_2_fifo_pop_withOverride_load = 1'b1;
    end
  end

  always @ (*) begin
    channels_2_fifo_pop_withOverride_unload = 1'b0;
    if(channels_2_pop_b2m_packetSync)begin
      channels_2_fifo_pop_withOverride_unload = 1'b1;
    end
  end

  assign channels_2_fifo_pop_bytes = channels_2_fifo_pop_withOverride_exposed;
  assign channels_2_fifo_empty = (channels_2_fifo_push_ptr == channels_2_fifo_pop_ptr);
  always @ (*) begin
    channels_2_push_s2b_packetEvent = 1'b0;
    if((_zz_28 && s2b_1_rsp_context_packet))begin
      channels_2_push_s2b_packetEvent = 1'b1;
    end
  end

  assign channels_2_pop_b2m_bytePerBurst = 12'h1ff;
  always @ (*) begin
    channels_2_pop_b2m_fire = 1'b0;
    if(_zz_183)begin
      if(_zz_49[1])begin
        channels_2_pop_b2m_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_2_pop_b2m_packetSync = 1'b0;
    if(_zz_202)begin
      if(channels_2_pop_b2m_packet)begin
        channels_2_pop_b2m_packetSync = 1'b1;
      end
    end
    if(_zz_181)begin
      if(_zz_201)begin
        if(b2m_rsp_context_doPacketSync)begin
          channels_2_pop_b2m_packetSync = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_2_pop_b2m_memRsp = 1'b0;
    if(_zz_181)begin
      if(_zz_59[1])begin
        channels_2_pop_b2m_memRsp = 1'b1;
      end
    end
  end

  assign channels_2_pop_b2m_request = ((((((channels_2_descriptorValid && (! channels_2_channelStop)) && (! channels_2_pop_b2m_waitFinalRsp)) && channels_2_pop_memory) && ((_zz_247 < channels_2_fifo_pop_bytes) || ((channels_2_fifo_push_available < _zz_249) || channels_2_pop_b2m_flush))) && (channels_2_fifo_pop_bytes != 14'h0)) && (channels_2_pop_b2m_memPending != 4'b1111));
  always @ (*) begin
    channels_2_pop_b2m_memPendingInc = 1'b0;
    if(_zz_185)begin
      if((channels_2_pop_b2m_request && b2m_fsm_arbiter_logic_priority_chosenOh[1]))begin
        channels_2_pop_b2m_memPendingInc = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_2_pop_b2m_decrBytes = 14'h0;
    if(b2m_fsm_s1)begin
      if(_zz_203)begin
        channels_2_pop_b2m_decrBytes = {2'd0, b2m_fsm_bytesInBurstP1};
      end
    end
  end

  assign channels_2_readyForChannelCompletion = 1'b1;
  always @ (*) begin
    _zz_3 = 1'b1;
    if(_zz_199)begin
      _zz_3 = 1'b0;
    end
    if(channels_2_ctrl_kick)begin
      _zz_3 = 1'b0;
    end
    if(channels_2_ll_valid)begin
      _zz_3 = 1'b0;
    end
  end

  assign channels_2_s2b_full = (channels_2_fifo_push_available < 10'h002);
  always @ (*) begin
    channels_3_channelStart = 1'b0;
    if(_zz_113)begin
      if(_zz_387[0])begin
        channels_3_channelStart = _zz_388[0];
      end
    end
    if(_zz_115)begin
      if(_zz_391[0])begin
        channels_3_channelStart = _zz_392[0];
      end
    end
  end

  always @ (*) begin
    channels_3_channelCompletion = 1'b0;
    if(channels_3_channelValid)begin
      if(channels_3_channelStop)begin
        if(channels_3_readyToStop)begin
          channels_3_channelCompletion = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_3_descriptorStart = 1'b0;
    if(channels_3_ctrl_kick)begin
      channels_3_descriptorStart = 1'b1;
    end
    if(_zz_204)begin
      if(_zz_205)begin
        if(_zz_206)begin
          channels_3_descriptorStart = 1'b1;
        end
      end
    end
    if(channels_3_channelValid)begin
      if(! channels_3_channelStop) begin
        if(_zz_207)begin
          if(_zz_208)begin
            channels_3_descriptorStart = 1'b1;
          end
        end
      end
    end
  end

  always @ (*) begin
    channels_3_descriptorCompletion = 1'b0;
    if(((((channels_3_descriptorValid && (! channels_3_pop_memory)) && channels_3_push_memory) && channels_3_push_m2b_loadDone) && (channels_3_push_m2b_memPending == 4'b0000)))begin
      channels_3_descriptorCompletion = 1'b1;
    end
    if(channels_3_channelValid)begin
      if(channels_3_channelStop)begin
        if(channels_3_readyToStop)begin
          channels_3_descriptorCompletion = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_3_readyToStop = 1'b1;
    if(channels_3_ll_waitDone)begin
      channels_3_readyToStop = 1'b0;
    end
    if((channels_3_push_m2b_memPending != 4'b0000))begin
      channels_3_readyToStop = 1'b0;
    end
  end

  always @ (*) begin
    channels_3_ll_sgStart = 1'b0;
    if(_zz_116)begin
      if(_zz_393[0])begin
        channels_3_ll_sgStart = _zz_394[0];
      end
    end
  end

  assign channels_3_ll_requestLl = ((((channels_3_channelValid && channels_3_ll_valid) && (! channels_3_channelStop)) && (! channels_3_ll_waitDone)) && ((! channels_3_descriptorValid) || channels_3_ll_requireSync));
  always @ (*) begin
    channels_3_ll_descriptorUpdated = 1'b0;
    if(_zz_204)begin
      if((! channels_3_ll_head))begin
        channels_3_ll_descriptorUpdated = 1'b1;
      end
    end
  end

  assign channels_3_fifo_base = 10'h180;
  assign channels_3_fifo_words = 10'h07f;
  always @ (*) begin
    channels_3_fifo_push_availableDecr = 10'h0;
    if(m2b_cmd_s1_valid)begin
      if(io_read_cmd_ready)begin
        if(_zz_209)begin
          channels_3_fifo_push_availableDecr = {1'd0, m2b_cmd_s1_fifoPushDecr};
        end
      end
    end
  end

  assign channels_3_fifo_push_ptrWithBase = ((channels_3_fifo_base & (~ channels_3_fifo_words)) | (channels_3_fifo_push_ptr & channels_3_fifo_words));
  assign channels_3_fifo_pop_ptrWithBase = ((channels_3_fifo_base & (~ channels_3_fifo_words)) | (channels_3_fifo_pop_ptr & channels_3_fifo_words));
  assign channels_3_fifo_pop_empty = (channels_3_fifo_pop_ptr == channels_3_fifo_push_ptr);
  assign channels_3_fifo_pop_bytes = channels_3_fifo_pop_withoutOverride_exposed;
  assign channels_3_fifo_empty = (channels_3_fifo_push_ptr == channels_3_fifo_pop_ptr);
  assign channels_3_push_m2b_bytePerBurst = 12'h0ff;
  always @ (*) begin
    channels_3_push_m2b_memPendingIncr = 1'b0;
    if(_zz_193)begin
      if((channels_3_push_m2b_loadRequest && m2b_cmd_s0_priority_chosenOh[1]))begin
        channels_3_push_m2b_memPendingIncr = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_3_push_m2b_memPendingDecr = 1'b0;
    if((_zz_41 && m2b_writeRsp_context_lastOfBurst))begin
      channels_3_push_m2b_memPendingDecr = 1'b1;
    end
  end

  always @ (*) begin
    channels_3_push_m2b_loadRequest = (((((channels_3_descriptorValid && (! channels_3_channelStop)) && (! channels_3_push_m2b_loadDone)) && channels_3_push_memory) && (_zz_266 < channels_3_fifo_push_available)) && (channels_3_push_m2b_memPending != 4'b1111));
    if((((! channels_3_pop_memory) && channels_3_pop_b2s_veryLastValid) && (channels_3_push_m2b_bytesLeft <= _zz_267)))begin
      channels_3_push_m2b_loadRequest = 1'b0;
    end
  end

  always @ (*) begin
    channels_3_pop_b2s_veryLastTrigger = 1'b0;
    if(_zz_194)begin
      if((m2b_rsp_context_channel == 1'b1))begin
        channels_3_pop_b2s_veryLastTrigger = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_3_readyForChannelCompletion = 1'b1;
    if(((! channels_3_pop_memory) && (! channels_3_fifo_pop_empty)))begin
      channels_3_readyForChannelCompletion = 1'b0;
    end
  end

  always @ (*) begin
    _zz_4 = 1'b1;
    if(_zz_208)begin
      _zz_4 = 1'b0;
    end
    if(channels_3_ctrl_kick)begin
      _zz_4 = 1'b0;
    end
    if(channels_3_ll_valid)begin
      _zz_4 = 1'b0;
    end
  end

  assign channels_3_s2b_full = (channels_3_fifo_push_available < 10'h002);
  always @ (*) begin
    s2b_0_cmd_firsts[0] = io_inputs_0_payload_last_regNextWhen;
    s2b_0_cmd_firsts[1] = io_inputs_0_payload_last_regNextWhen_1;
    s2b_0_cmd_firsts[2] = io_inputs_0_payload_last_regNextWhen_2;
    s2b_0_cmd_firsts[3] = io_inputs_0_payload_last_regNextWhen_3;
    s2b_0_cmd_firsts[4] = io_inputs_0_payload_last_regNextWhen_4;
    s2b_0_cmd_firsts[5] = io_inputs_0_payload_last_regNextWhen_5;
    s2b_0_cmd_firsts[6] = io_inputs_0_payload_last_regNextWhen_6;
    s2b_0_cmd_firsts[7] = io_inputs_0_payload_last_regNextWhen_7;
    s2b_0_cmd_firsts[8] = io_inputs_0_payload_last_regNextWhen_8;
    s2b_0_cmd_firsts[9] = io_inputs_0_payload_last_regNextWhen_9;
    s2b_0_cmd_firsts[10] = io_inputs_0_payload_last_regNextWhen_10;
    s2b_0_cmd_firsts[11] = io_inputs_0_payload_last_regNextWhen_11;
    s2b_0_cmd_firsts[12] = io_inputs_0_payload_last_regNextWhen_12;
    s2b_0_cmd_firsts[13] = io_inputs_0_payload_last_regNextWhen_13;
    s2b_0_cmd_firsts[14] = io_inputs_0_payload_last_regNextWhen_14;
    s2b_0_cmd_firsts[15] = io_inputs_0_payload_last_regNextWhen_15;
  end

  assign s2b_0_cmd_first = s2b_0_cmd_firsts[io_inputs_0_payload_sink];
  assign s2b_0_cmd_channelsOh[0] = ((((channels_0_channelValid && (s2b_0_cmd_first || (! channels_0_push_s2b_waitFirst))) && (! channels_0_push_memory)) && 1'b1) && (io_inputs_0_payload_sink == 4'b0000));
  assign s2b_0_cmd_noHit = (! (s2b_0_cmd_channelsOh != 1'b0));
  assign s2b_0_cmd_channelsFull[0] = (channels_0_s2b_full || (channels_0_push_s2b_packetLock && io_inputs_0_payload_last));
  always @ (*) begin
    io_inputs_0_thrown_valid = io_inputs_0_valid;
    if(s2b_0_cmd_noHit)begin
      io_inputs_0_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_inputs_0_ready = io_inputs_0_thrown_ready;
    if(s2b_0_cmd_noHit)begin
      io_inputs_0_ready = 1'b1;
    end
  end

  assign io_inputs_0_thrown_payload_data = io_inputs_0_payload_data;
  assign io_inputs_0_thrown_payload_mask = io_inputs_0_payload_mask;
  assign io_inputs_0_thrown_payload_sink = io_inputs_0_payload_sink;
  assign io_inputs_0_thrown_payload_last = io_inputs_0_payload_last;
  assign _zz_5 = (! ((s2b_0_cmd_channelsOh & s2b_0_cmd_channelsFull) != 1'b0));
  assign s2b_0_cmd_sinkHalted_valid = (io_inputs_0_thrown_valid && _zz_5);
  assign io_inputs_0_thrown_ready = (s2b_0_cmd_sinkHalted_ready && _zz_5);
  assign s2b_0_cmd_sinkHalted_payload_data = io_inputs_0_thrown_payload_data;
  assign s2b_0_cmd_sinkHalted_payload_mask = io_inputs_0_thrown_payload_mask;
  assign s2b_0_cmd_sinkHalted_payload_sink = io_inputs_0_thrown_payload_sink;
  assign s2b_0_cmd_sinkHalted_payload_last = io_inputs_0_thrown_payload_last;
  assign _zz_6 = 5'h0;
  assign _zz_7 = 5'h01;
  assign _zz_8 = 5'h01;
  assign _zz_9 = 5'h02;
  assign _zz_10 = 5'h01;
  assign _zz_11 = 5'h02;
  assign _zz_12 = 5'h02;
  assign _zz_13 = 5'h03;
  assign s2b_0_cmd_byteCount = (_zz_271 + _zz_274);
  assign s2b_0_cmd_context_channel = s2b_0_cmd_channelsOh;
  assign s2b_0_cmd_context_bytes = s2b_0_cmd_byteCount;
  assign s2b_0_cmd_context_flush = io_inputs_0_payload_last;
  assign s2b_0_cmd_context_packet = io_inputs_0_payload_last;
  assign s2b_0_cmd_sinkHalted_ready = memory_core_io_writes_0_cmd_ready;
  assign _zz_120 = channels_0_fifo_push_ptrWithBase[8:0];
  assign _zz_121 = {s2b_0_cmd_context_packet,{s2b_0_cmd_context_flush,{s2b_0_cmd_context_bytes,s2b_0_cmd_context_channel}}};
  assign _zz_14 = (s2b_0_cmd_channelsOh[0] && (s2b_0_cmd_sinkHalted_valid && memory_core_io_writes_0_cmd_ready));
  assign _zz_15 = memory_core_io_writes_0_rsp_payload_context;
  assign s2b_0_rsp_context_channel = _zz_15[0 : 0];
  assign s2b_0_rsp_context_bytes = _zz_15[5 : 1];
  assign s2b_0_rsp_context_flush = _zz_277[0];
  assign s2b_0_rsp_context_packet = _zz_278[0];
  assign _zz_16 = (memory_core_io_writes_0_rsp_valid && s2b_0_rsp_context_channel[0]);
  always @ (*) begin
    s2b_1_cmd_firsts[0] = io_inputs_1_payload_last_regNextWhen;
    s2b_1_cmd_firsts[1] = io_inputs_1_payload_last_regNextWhen_1;
    s2b_1_cmd_firsts[2] = io_inputs_1_payload_last_regNextWhen_2;
    s2b_1_cmd_firsts[3] = io_inputs_1_payload_last_regNextWhen_3;
    s2b_1_cmd_firsts[4] = io_inputs_1_payload_last_regNextWhen_4;
    s2b_1_cmd_firsts[5] = io_inputs_1_payload_last_regNextWhen_5;
    s2b_1_cmd_firsts[6] = io_inputs_1_payload_last_regNextWhen_6;
    s2b_1_cmd_firsts[7] = io_inputs_1_payload_last_regNextWhen_7;
    s2b_1_cmd_firsts[8] = io_inputs_1_payload_last_regNextWhen_8;
    s2b_1_cmd_firsts[9] = io_inputs_1_payload_last_regNextWhen_9;
    s2b_1_cmd_firsts[10] = io_inputs_1_payload_last_regNextWhen_10;
    s2b_1_cmd_firsts[11] = io_inputs_1_payload_last_regNextWhen_11;
    s2b_1_cmd_firsts[12] = io_inputs_1_payload_last_regNextWhen_12;
    s2b_1_cmd_firsts[13] = io_inputs_1_payload_last_regNextWhen_13;
    s2b_1_cmd_firsts[14] = io_inputs_1_payload_last_regNextWhen_14;
    s2b_1_cmd_firsts[15] = io_inputs_1_payload_last_regNextWhen_15;
  end

  assign s2b_1_cmd_first = s2b_1_cmd_firsts[io_inputs_1_payload_sink];
  assign s2b_1_cmd_channelsOh[0] = ((((channels_2_channelValid && (s2b_1_cmd_first || (! channels_2_push_s2b_waitFirst))) && (! channels_2_push_memory)) && 1'b1) && (io_inputs_1_payload_sink == 4'b0000));
  assign s2b_1_cmd_noHit = (! (s2b_1_cmd_channelsOh != 1'b0));
  assign s2b_1_cmd_channelsFull[0] = (channels_2_s2b_full || (channels_2_push_s2b_packetLock && io_inputs_1_payload_last));
  always @ (*) begin
    io_inputs_1_thrown_valid = io_inputs_1_valid;
    if(s2b_1_cmd_noHit)begin
      io_inputs_1_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_inputs_1_ready = io_inputs_1_thrown_ready;
    if(s2b_1_cmd_noHit)begin
      io_inputs_1_ready = 1'b1;
    end
  end

  assign io_inputs_1_thrown_payload_data = io_inputs_1_payload_data;
  assign io_inputs_1_thrown_payload_mask = io_inputs_1_payload_mask;
  assign io_inputs_1_thrown_payload_sink = io_inputs_1_payload_sink;
  assign io_inputs_1_thrown_payload_last = io_inputs_1_payload_last;
  assign _zz_17 = (! ((s2b_1_cmd_channelsOh & s2b_1_cmd_channelsFull) != 1'b0));
  assign s2b_1_cmd_sinkHalted_valid = (io_inputs_1_thrown_valid && _zz_17);
  assign io_inputs_1_thrown_ready = (s2b_1_cmd_sinkHalted_ready && _zz_17);
  assign s2b_1_cmd_sinkHalted_payload_data = io_inputs_1_thrown_payload_data;
  assign s2b_1_cmd_sinkHalted_payload_mask = io_inputs_1_thrown_payload_mask;
  assign s2b_1_cmd_sinkHalted_payload_sink = io_inputs_1_thrown_payload_sink;
  assign s2b_1_cmd_sinkHalted_payload_last = io_inputs_1_thrown_payload_last;
  assign _zz_18 = 5'h0;
  assign _zz_19 = 5'h01;
  assign _zz_20 = 5'h01;
  assign _zz_21 = 5'h02;
  assign _zz_22 = 5'h01;
  assign _zz_23 = 5'h02;
  assign _zz_24 = 5'h02;
  assign _zz_25 = 5'h03;
  assign s2b_1_cmd_byteCount = (_zz_279 + _zz_282);
  assign s2b_1_cmd_context_channel = s2b_1_cmd_channelsOh;
  assign s2b_1_cmd_context_bytes = s2b_1_cmd_byteCount;
  assign s2b_1_cmd_context_flush = io_inputs_1_payload_last;
  assign s2b_1_cmd_context_packet = io_inputs_1_payload_last;
  assign s2b_1_cmd_sinkHalted_ready = memory_core_io_writes_1_cmd_ready;
  assign _zz_122 = channels_2_fifo_push_ptrWithBase[8:0];
  assign _zz_123 = {s2b_1_cmd_context_packet,{s2b_1_cmd_context_flush,{s2b_1_cmd_context_bytes,s2b_1_cmd_context_channel}}};
  assign _zz_26 = (s2b_1_cmd_channelsOh[0] && (s2b_1_cmd_sinkHalted_valid && memory_core_io_writes_1_cmd_ready));
  assign _zz_27 = memory_core_io_writes_1_rsp_payload_context;
  assign s2b_1_rsp_context_channel = _zz_27[0 : 0];
  assign s2b_1_rsp_context_bytes = _zz_27[5 : 1];
  assign s2b_1_rsp_context_flush = _zz_285[0];
  assign s2b_1_rsp_context_packet = _zz_286[0];
  assign _zz_28 = (memory_core_io_writes_1_rsp_valid && s2b_1_rsp_context_channel[0]);
  assign b2s_0_cmd_channelsOh = (((channels_1_channelValid && (! channels_1_pop_memory)) && (channels_1_pop_b2s_portId == 1'b0)) && (! channels_1_fifo_pop_empty));
  assign b2s_0_cmd_veryLastPtr = channels_1_pop_b2s_veryLastPtr;
  assign b2s_0_cmd_address = channels_1_fifo_pop_ptrWithBase;
  assign b2s_0_cmd_context_channel = b2s_0_cmd_channelsOh;
  assign b2s_0_cmd_context_veryLast = ((channels_1_pop_b2s_veryLastValid && (b2s_0_cmd_address[9 : 0] == b2s_0_cmd_veryLastPtr[9 : 0])) && 1'b1);
  assign b2s_0_cmd_context_endPacket = channels_1_pop_b2s_veryLastEndPacket;
  assign _zz_127 = (b2s_0_cmd_channelsOh != 1'b0);
  assign _zz_128 = b2s_0_cmd_address[8:0];
  assign _zz_129 = {b2s_0_cmd_context_endPacket,{b2s_0_cmd_context_veryLast,b2s_0_cmd_context_channel}};
  assign _zz_29 = memory_core_io_reads_0_rsp_payload_context;
  assign b2s_0_rsp_context_channel = _zz_29[0 : 0];
  assign b2s_0_rsp_context_veryLast = _zz_287[0];
  assign b2s_0_rsp_context_endPacket = _zz_288[0];
  assign io_outputs_0_valid = memory_core_io_reads_0_rsp_valid;
  assign io_outputs_0_payload_data = memory_core_io_reads_0_rsp_payload_data;
  assign io_outputs_0_payload_mask = memory_core_io_reads_0_rsp_payload_mask;
  assign io_outputs_0_payload_sink = channels_1_pop_b2s_sinkId;
  assign io_outputs_0_payload_last = (b2s_0_rsp_context_veryLast && b2s_0_rsp_context_endPacket);
  assign b2s_1_cmd_channelsOh = (((channels_3_channelValid && (! channels_3_pop_memory)) && (channels_3_pop_b2s_portId == 1'b0)) && (! channels_3_fifo_pop_empty));
  assign b2s_1_cmd_veryLastPtr = channels_3_pop_b2s_veryLastPtr;
  assign b2s_1_cmd_address = channels_3_fifo_pop_ptrWithBase;
  assign b2s_1_cmd_context_channel = b2s_1_cmd_channelsOh;
  assign b2s_1_cmd_context_veryLast = ((channels_3_pop_b2s_veryLastValid && (b2s_1_cmd_address[9 : 0] == b2s_1_cmd_veryLastPtr[9 : 0])) && 1'b1);
  assign b2s_1_cmd_context_endPacket = channels_3_pop_b2s_veryLastEndPacket;
  assign _zz_130 = (b2s_1_cmd_channelsOh != 1'b0);
  assign _zz_131 = b2s_1_cmd_address[8:0];
  assign _zz_132 = {b2s_1_cmd_context_endPacket,{b2s_1_cmd_context_veryLast,b2s_1_cmd_context_channel}};
  assign _zz_30 = memory_core_io_reads_1_rsp_payload_context;
  assign b2s_1_rsp_context_channel = _zz_30[0 : 0];
  assign b2s_1_rsp_context_veryLast = _zz_289[0];
  assign b2s_1_rsp_context_endPacket = _zz_290[0];
  assign io_outputs_1_valid = memory_core_io_reads_1_rsp_valid;
  assign io_outputs_1_payload_data = memory_core_io_reads_1_rsp_payload_data;
  assign io_outputs_1_payload_mask = memory_core_io_reads_1_rsp_payload_mask;
  assign io_outputs_1_payload_sink = channels_3_pop_b2s_sinkId;
  assign io_outputs_1_payload_last = (b2s_1_rsp_context_veryLast && b2s_1_rsp_context_endPacket);
  assign _zz_31 = channels_1_priority;
  assign _zz_32 = channels_3_priority;
  assign _zz_33 = (((! channels_3_push_m2b_loadRequest) || (channels_1_push_m2b_loadRequest && (_zz_32 < _zz_31))) ? _zz_31 : _zz_32);
  always @ (*) begin
    m2b_cmd_s0_priority_masked[0] = (channels_1_push_m2b_loadRequest && (channels_1_priority == _zz_33));
    m2b_cmd_s0_priority_masked[1] = (channels_3_push_m2b_loadRequest && (channels_3_priority == _zz_33));
  end

  assign _zz_34 = m2b_cmd_s0_priority_masked;
  assign _zz_35 = {_zz_34,_zz_34};
  assign _zz_36 = (_zz_35 & (~ _zz_291));
  assign m2b_cmd_s0_priority_chosenOh = (_zz_36[3 : 2] | _zz_36[1 : 0]);
  assign _zz_37 = m2b_cmd_s0_priority_chosenOh[1];
  assign m2b_cmd_s0_priority_chosen = _zz_37;
  assign m2b_cmd_s0_priority_weightLast = _zz_153;
  assign m2b_cmd_s0_priority_contextNext = (m2b_cmd_s0_priority_weightLast ? {m2b_cmd_s0_priority_chosenOh[0 : 0],m2b_cmd_s0_priority_chosenOh[1 : 1]} : m2b_cmd_s0_priority_chosenOh);
  assign m2b_cmd_s0_address = _zz_154;
  assign m2b_cmd_s0_bytesLeft = _zz_155;
  assign m2b_cmd_s0_readAddressBurstRange = m2b_cmd_s0_address[11 : 0];
  assign m2b_cmd_s0_lengthHead = ((~ m2b_cmd_s0_readAddressBurstRange) & _zz_156);
  assign m2b_cmd_s0_length = _zz_294[11:0];
  assign m2b_cmd_s0_lastBurst = (m2b_cmd_s0_bytesLeft == _zz_297);
  assign m2b_cmd_s1_context_channel = m2b_cmd_s0_chosen;
  assign m2b_cmd_s1_context_start = m2b_cmd_s1_address[3:0];
  assign m2b_cmd_s1_context_stop = _zz_298[3:0];
  assign m2b_cmd_s1_context_last = m2b_cmd_s1_lastBurst;
  assign m2b_cmd_s1_context_length = m2b_cmd_s1_length;
  always @ (*) begin
    io_read_cmd_valid = 1'b0;
    if(m2b_cmd_s1_valid)begin
      io_read_cmd_valid = 1'b1;
    end
  end

  assign io_read_cmd_payload_last = 1'b1;
  assign io_read_cmd_payload_fragment_source = m2b_cmd_s0_chosen;
  assign io_read_cmd_payload_fragment_opcode = 1'b0;
  assign io_read_cmd_payload_fragment_address = m2b_cmd_s1_address;
  assign io_read_cmd_payload_fragment_length = m2b_cmd_s1_length;
  assign io_read_cmd_payload_fragment_context = {m2b_cmd_s1_context_last,{m2b_cmd_s1_context_length,{m2b_cmd_s1_context_stop,{m2b_cmd_s1_context_start,m2b_cmd_s1_context_channel}}}};
  assign m2b_cmd_s1_addressNext = (_zz_300 + 32'h00000001);
  assign m2b_cmd_s1_byteLeftNext = (_zz_302 - 26'h0000001);
  assign m2b_cmd_s1_fifoPushDecr = (_zz_304 >>> 4);
  assign _zz_38 = io_read_rsp_payload_fragment_context;
  assign m2b_rsp_context_channel = _zz_38[0 : 0];
  assign m2b_rsp_context_start = _zz_38[4 : 1];
  assign m2b_rsp_context_stop = _zz_38[8 : 5];
  assign m2b_rsp_context_length = _zz_38[20 : 9];
  assign m2b_rsp_context_last = _zz_310[0];
  assign m2b_rsp_veryLast = (m2b_rsp_context_last && io_read_rsp_payload_last);
  always @ (*) begin
    _zz_125[0] = ((! (m2b_rsp_first && (4'b0000 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b0000))));
    _zz_125[1] = ((! (m2b_rsp_first && (4'b0001 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b0001))));
    _zz_125[2] = ((! (m2b_rsp_first && (4'b0010 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b0010))));
    _zz_125[3] = ((! (m2b_rsp_first && (4'b0011 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b0011))));
    _zz_125[4] = ((! (m2b_rsp_first && (4'b0100 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b0100))));
    _zz_125[5] = ((! (m2b_rsp_first && (4'b0101 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b0101))));
    _zz_125[6] = ((! (m2b_rsp_first && (4'b0110 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b0110))));
    _zz_125[7] = ((! (m2b_rsp_first && (4'b0111 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b0111))));
    _zz_125[8] = ((! (m2b_rsp_first && (4'b1000 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b1000))));
    _zz_125[9] = ((! (m2b_rsp_first && (4'b1001 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b1001))));
    _zz_125[10] = ((! (m2b_rsp_first && (4'b1010 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b1010))));
    _zz_125[11] = ((! (m2b_rsp_first && (4'b1011 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b1011))));
    _zz_125[12] = ((! (m2b_rsp_first && (4'b1100 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b1100))));
    _zz_125[13] = ((! (m2b_rsp_first && (4'b1101 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b1101))));
    _zz_125[14] = ((! (m2b_rsp_first && (4'b1110 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b1110))));
    _zz_125[15] = ((! (m2b_rsp_first && (4'b1111 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 4'b1111))));
  end

  assign m2b_rsp_writeContext_last = m2b_rsp_veryLast;
  assign m2b_rsp_writeContext_lastOfBurst = io_read_rsp_payload_last;
  assign m2b_rsp_writeContext_channel = m2b_rsp_context_channel;
  assign m2b_rsp_writeContext_loadByteInNextBeat = ({1'b0,(io_read_rsp_payload_last ? m2b_rsp_context_stop : 4'b1111)} - {1'b0,(m2b_rsp_first ? m2b_rsp_context_start : 4'b0000)});
  assign _zz_124 = _zz_157[8:0];
  assign io_read_rsp_ready = memory_core_io_writes_2_cmd_ready;
  assign _zz_126 = {m2b_rsp_writeContext_loadByteInNextBeat,{m2b_rsp_writeContext_channel,{m2b_rsp_writeContext_lastOfBurst,m2b_rsp_writeContext_last}}};
  assign _zz_39 = memory_core_io_writes_2_rsp_payload_context;
  assign m2b_writeRsp_context_last = _zz_311[0];
  assign m2b_writeRsp_context_lastOfBurst = _zz_312[0];
  assign m2b_writeRsp_context_channel = _zz_39[2 : 2];
  assign m2b_writeRsp_context_loadByteInNextBeat = _zz_39[7 : 3];
  assign _zz_40 = (memory_core_io_writes_2_rsp_valid && (m2b_writeRsp_context_channel == 1'b0));
  assign _zz_41 = (memory_core_io_writes_2_rsp_valid && (m2b_writeRsp_context_channel == 1'b1));
  assign _zz_42 = channels_0_priority;
  assign _zz_43 = channels_2_priority;
  assign _zz_44 = (((! channels_2_pop_b2m_request) || (channels_0_pop_b2m_request && (_zz_43 < _zz_42))) ? _zz_42 : _zz_43);
  always @ (*) begin
    b2m_fsm_arbiter_logic_priority_masked[0] = (channels_0_pop_b2m_request && (channels_0_priority == _zz_44));
    b2m_fsm_arbiter_logic_priority_masked[1] = (channels_2_pop_b2m_request && (channels_2_priority == _zz_44));
  end

  assign _zz_45 = b2m_fsm_arbiter_logic_priority_masked;
  assign _zz_46 = {_zz_45,_zz_45};
  assign _zz_47 = (_zz_46 & (~ _zz_313));
  assign b2m_fsm_arbiter_logic_priority_chosenOh = (_zz_47[3 : 2] | _zz_47[1 : 0]);
  assign _zz_48 = b2m_fsm_arbiter_logic_priority_chosenOh[1];
  assign b2m_fsm_arbiter_logic_priority_chosen = _zz_48;
  assign b2m_fsm_arbiter_logic_priority_weightLast = _zz_159;
  assign b2m_fsm_arbiter_logic_priority_contextNext = (b2m_fsm_arbiter_logic_priority_weightLast ? {b2m_fsm_arbiter_logic_priority_chosenOh[0 : 0],b2m_fsm_arbiter_logic_priority_chosenOh[1 : 1]} : b2m_fsm_arbiter_logic_priority_chosenOh);
  assign _zz_49 = ({1'd0,1'b1} <<< b2m_fsm_arbiter_logic_chosen);
  assign b2m_fsm_bytesInBurstP1 = (b2m_fsm_sel_bytesInBurst + 12'h001);
  assign b2m_fsm_addressNext = (b2m_fsm_sel_address + _zz_316);
  assign b2m_fsm_bytesLeftNext = ({1'b0,b2m_fsm_sel_bytesLeft} - _zz_318);
  assign b2m_fsm_isFinalCmd = b2m_fsm_bytesLeftNext[26];
  assign b2m_fsm_s0 = (b2m_fsm_sel_valid && (! b2m_fsm_sel_valid_regNext));
  assign _zz_50 = (b2m_fsm_sel_bytesInFifo - 14'h0001);
  assign _zz_51 = ((_zz_319 < b2m_fsm_sel_bytesLeft) ? _zz_320 : b2m_fsm_sel_bytesLeft);
  assign _zz_52 = (b2m_fsm_sel_bytePerBurst - (_zz_321 & b2m_fsm_sel_bytePerBurst));
  assign b2m_fsm_fifoCompletion = (_zz_325 == _zz_326);
  always @ (*) begin
    b2m_fsm_sel_ready = 1'b0;
    if(_zz_210)begin
      b2m_fsm_sel_ready = 1'b1;
    end
  end

  assign b2m_fsm_fetch_context_ptr = _zz_168;
  assign b2m_fsm_fetch_context_toggle = b2m_fsm_toggle;
  assign _zz_133 = b2m_fsm_sel_ptr[8:0];
  assign _zz_134 = {b2m_fsm_fetch_context_toggle,b2m_fsm_fetch_context_ptr};
  assign _zz_53 = memory_core_io_reads_2_rsp_payload_context;
  assign b2m_fsm_aggregate_context_ptr = _zz_53[9 : 0];
  assign b2m_fsm_aggregate_context_toggle = _zz_331[0];
  assign memory_core_io_reads_2_rsp_s2mPipe_valid = (memory_core_io_reads_2_rsp_valid || memory_core_io_reads_2_rsp_s2mPipe_rValid);
  assign _zz_135 = (! memory_core_io_reads_2_rsp_s2mPipe_rValid);
  assign memory_core_io_reads_2_rsp_s2mPipe_payload_data = (memory_core_io_reads_2_rsp_s2mPipe_rValid ? memory_core_io_reads_2_rsp_s2mPipe_rData_data : memory_core_io_reads_2_rsp_payload_data);
  assign memory_core_io_reads_2_rsp_s2mPipe_payload_mask = (memory_core_io_reads_2_rsp_s2mPipe_rValid ? memory_core_io_reads_2_rsp_s2mPipe_rData_mask : memory_core_io_reads_2_rsp_payload_mask);
  assign memory_core_io_reads_2_rsp_s2mPipe_payload_context = (memory_core_io_reads_2_rsp_s2mPipe_rValid ? memory_core_io_reads_2_rsp_s2mPipe_rData_context : memory_core_io_reads_2_rsp_payload_context);
  always @ (*) begin
    b2m_fsm_aggregate_memoryPort_valid = memory_core_io_reads_2_rsp_s2mPipe_valid;
    if(_zz_211)begin
      b2m_fsm_aggregate_memoryPort_valid = 1'b0;
    end
  end

  always @ (*) begin
    memory_core_io_reads_2_rsp_s2mPipe_ready = b2m_fsm_aggregate_memoryPort_ready;
    if(_zz_211)begin
      memory_core_io_reads_2_rsp_s2mPipe_ready = 1'b1;
    end
  end

  assign b2m_fsm_aggregate_memoryPort_payload_data = memory_core_io_reads_2_rsp_s2mPipe_payload_data;
  assign b2m_fsm_aggregate_memoryPort_payload_mask = memory_core_io_reads_2_rsp_s2mPipe_payload_mask;
  assign b2m_fsm_aggregate_memoryPort_payload_context = memory_core_io_reads_2_rsp_s2mPipe_payload_context;
  assign b2m_fsm_aggregate_bytesToSkip = _zz_169;
  always @ (*) begin
    b2m_fsm_aggregate_bytesToSkipMask[0] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b0000));
    b2m_fsm_aggregate_bytesToSkipMask[1] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b0001));
    b2m_fsm_aggregate_bytesToSkipMask[2] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b0010));
    b2m_fsm_aggregate_bytesToSkipMask[3] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b0011));
    b2m_fsm_aggregate_bytesToSkipMask[4] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b0100));
    b2m_fsm_aggregate_bytesToSkipMask[5] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b0101));
    b2m_fsm_aggregate_bytesToSkipMask[6] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b0110));
    b2m_fsm_aggregate_bytesToSkipMask[7] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b0111));
    b2m_fsm_aggregate_bytesToSkipMask[8] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b1000));
    b2m_fsm_aggregate_bytesToSkipMask[9] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b1001));
    b2m_fsm_aggregate_bytesToSkipMask[10] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b1010));
    b2m_fsm_aggregate_bytesToSkipMask[11] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b1011));
    b2m_fsm_aggregate_bytesToSkipMask[12] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b1100));
    b2m_fsm_aggregate_bytesToSkipMask[13] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b1101));
    b2m_fsm_aggregate_bytesToSkipMask[14] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b1110));
    b2m_fsm_aggregate_bytesToSkipMask[15] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 4'b1111));
  end

  assign b2m_fsm_aggregate_memoryPort_ready = b2m_fsm_aggregate_engine_io_input_ready;
  assign _zz_136 = (b2m_fsm_aggregate_memoryPort_payload_mask & b2m_fsm_aggregate_bytesToSkipMask);
  assign _zz_139 = b2m_fsm_sel_address[3:0];
  assign _zz_138 = (! _zz_54);
  assign b2m_fsm_cmd_maskFirstTrigger = b2m_fsm_sel_address[3:0];
  assign b2m_fsm_cmd_maskLastTriggerComb = (b2m_fsm_cmd_maskFirstTrigger + _zz_332);
  always @ (*) begin
    _zz_55[0] = (4'b0000 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[1] = (4'b0001 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[2] = (4'b0010 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[3] = (4'b0011 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[4] = (4'b0100 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[5] = (4'b0101 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[6] = (4'b0110 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[7] = (4'b0111 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[8] = (4'b1000 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[9] = (4'b1001 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[10] = (4'b1010 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[11] = (4'b1011 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[12] = (4'b1100 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[13] = (4'b1101 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[14] = (4'b1110 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_55[15] = (4'b1111 <= b2m_fsm_cmd_maskLastTriggerComb);
  end

  always @ (*) begin
    b2m_fsm_cmd_maskFirst[0] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b0000);
    b2m_fsm_cmd_maskFirst[1] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b0001);
    b2m_fsm_cmd_maskFirst[2] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b0010);
    b2m_fsm_cmd_maskFirst[3] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b0011);
    b2m_fsm_cmd_maskFirst[4] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b0100);
    b2m_fsm_cmd_maskFirst[5] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b0101);
    b2m_fsm_cmd_maskFirst[6] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b0110);
    b2m_fsm_cmd_maskFirst[7] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b0111);
    b2m_fsm_cmd_maskFirst[8] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b1000);
    b2m_fsm_cmd_maskFirst[9] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b1001);
    b2m_fsm_cmd_maskFirst[10] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b1010);
    b2m_fsm_cmd_maskFirst[11] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b1011);
    b2m_fsm_cmd_maskFirst[12] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b1100);
    b2m_fsm_cmd_maskFirst[13] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b1101);
    b2m_fsm_cmd_maskFirst[14] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b1110);
    b2m_fsm_cmd_maskFirst[15] = (b2m_fsm_cmd_maskFirstTrigger <= 4'b1111);
  end

  assign b2m_fsm_cmd_enoughAggregation = (((b2m_fsm_s2 && b2m_fsm_sel_valid) && (! _zz_138)) && (io_write_cmd_payload_last ? ((b2m_fsm_aggregate_engine_io_output_mask & b2m_fsm_cmd_maskLast) == b2m_fsm_cmd_maskLast) : (b2m_fsm_aggregate_engine_io_output_mask == 16'hffff)));
  assign _zz_137 = (io_write_cmd_valid && io_write_cmd_ready);
  assign io_write_cmd_valid = b2m_fsm_cmd_enoughAggregation;
  assign io_write_cmd_payload_last = (b2m_fsm_beatCounter == 8'h0);
  assign io_write_cmd_payload_fragment_address = b2m_fsm_sel_address;
  assign io_write_cmd_payload_fragment_opcode = 1'b1;
  assign io_write_cmd_payload_fragment_data = b2m_fsm_aggregate_engine_io_output_data;
  assign io_write_cmd_payload_fragment_mask = (~ ((io_write_cmd_payload_first ? (~ b2m_fsm_cmd_maskFirst) : 16'h0) | (io_write_cmd_payload_last ? (~ b2m_fsm_cmd_maskLast) : 16'h0)));
  assign io_write_cmd_payload_fragment_length = b2m_fsm_sel_bytesInBurst;
  assign io_write_cmd_payload_fragment_source = b2m_fsm_sel_channel;
  assign b2m_fsm_cmd_doPtrIncr = (b2m_fsm_sel_valid && (b2m_fsm_aggregate_engine_io_output_consumed || (((io_write_cmd_valid && io_write_cmd_ready) && io_write_cmd_payload_last) && (b2m_fsm_aggregate_engine_io_output_usedUntil == 4'b1111))));
  assign b2m_fsm_cmd_context_channel = b2m_fsm_sel_channel;
  assign b2m_fsm_cmd_context_length = b2m_fsm_sel_bytesInBurst;
  assign b2m_fsm_cmd_context_doPacketSync = (b2m_fsm_sel_packet && b2m_fsm_fifoCompletion);
  assign io_write_cmd_payload_fragment_context = {b2m_fsm_cmd_context_doPacketSync,{b2m_fsm_cmd_context_length,b2m_fsm_cmd_context_channel}};
  assign _zz_56 = ({1'd0,1'b1} <<< b2m_fsm_sel_channel);
  assign _zz_57 = (b2m_fsm_aggregate_engine_io_output_usedUntil + 4'b0001);
  assign io_write_rsp_ready = 1'b1;
  assign _zz_58 = io_write_rsp_payload_fragment_context;
  assign b2m_rsp_context_channel = _zz_58[0 : 0];
  assign b2m_rsp_context_length = _zz_58[12 : 1];
  assign b2m_rsp_context_doPacketSync = _zz_333[0];
  assign _zz_59 = ({1'd0,1'b1} <<< b2m_rsp_context_channel);
  assign _zz_60 = {channels_3_ll_requestLl,{channels_2_ll_requestLl,{channels_1_ll_requestLl,channels_0_ll_requestLl}}};
  assign _zz_61 = (_zz_60 & (~ _zz_334));
  assign _zz_62 = _zz_61[1];
  assign _zz_63 = _zz_61[2];
  assign _zz_64 = _zz_61[3];
  always @ (*) begin
    _zz_65[0] = channels_0_ll_requestLl;
    _zz_65[1] = _zz_62;
    _zz_65[2] = _zz_63;
    _zz_65[3] = _zz_64;
  end

  assign _zz_66 = _zz_65[3];
  assign _zz_67 = (_zz_65[1] || _zz_66);
  assign _zz_68 = (_zz_65[2] || _zz_66);
  assign ll_arbiter_head = _zz_170;
  always @ (*) begin
    _zz_69[0] = channels_0_ll_requestLl;
    _zz_69[1] = _zz_62;
    _zz_69[2] = _zz_63;
    _zz_69[3] = _zz_64;
  end

  assign _zz_70 = _zz_69[3];
  assign _zz_71 = (_zz_69[1] || _zz_70);
  assign _zz_72 = (_zz_69[2] || _zz_70);
  assign ll_arbiter_isJustASink = _zz_171;
  always @ (*) begin
    _zz_73[0] = channels_0_ll_requestLl;
    _zz_73[1] = _zz_62;
    _zz_73[2] = _zz_63;
    _zz_73[3] = _zz_64;
  end

  assign _zz_74 = _zz_73[3];
  assign _zz_75 = (_zz_73[1] || _zz_74);
  assign _zz_76 = (_zz_73[2] || _zz_74);
  always @ (*) begin
    _zz_77[0] = channels_0_ll_requestLl;
    _zz_77[1] = _zz_62;
    _zz_77[2] = _zz_63;
    _zz_77[3] = _zz_64;
  end

  assign _zz_78 = _zz_77[3];
  assign _zz_79 = (_zz_77[1] || _zz_78);
  assign _zz_80 = (_zz_77[2] || _zz_78);
  always @ (*) begin
    _zz_81[0] = channels_0_ll_requestLl;
    _zz_81[1] = _zz_63;
  end

  always @ (*) begin
    _zz_82[0] = channels_0_ll_requestLl;
    _zz_82[1] = _zz_62;
    _zz_82[2] = _zz_63;
    _zz_82[3] = _zz_64;
  end

  assign _zz_83 = _zz_82[3];
  assign _zz_84 = (_zz_82[1] || _zz_83);
  assign _zz_85 = (_zz_82[2] || _zz_83);
  assign _zz_86 = (ll_cmd_oh_1 || ll_cmd_oh_3);
  assign _zz_87 = (ll_cmd_oh_2 || ll_cmd_oh_3);
  assign ll_cmd_context_channel = {_zz_87,_zz_86};
  assign io_sgRead_cmd_valid = (ll_cmd_valid && (! ll_cmd_readFired));
  assign io_sgRead_cmd_payload_last = 1'b1;
  assign io_sgRead_cmd_payload_fragment_address = {ll_cmd_ptrNext[31 : 5],5'h0};
  assign io_sgRead_cmd_payload_fragment_length = 5'h1f;
  assign io_sgRead_cmd_payload_fragment_opcode = 1'b0;
  assign io_sgRead_cmd_payload_fragment_context = ll_cmd_context_channel;
  assign io_sgWrite_cmd_valid = (ll_cmd_valid && (! ll_cmd_writeFired));
  assign io_sgWrite_cmd_payload_last = 1'b1;
  assign io_sgWrite_cmd_payload_fragment_address = {ll_cmd_ptr[31 : 5],5'h0};
  assign io_sgWrite_cmd_payload_fragment_length = 2'b11;
  assign io_sgWrite_cmd_payload_fragment_opcode = 1'b1;
  assign io_sgWrite_cmd_payload_fragment_context = ll_cmd_context_channel;
  assign ll_cmd_writeMaskSplit_0 = io_sgWrite_cmd_payload_fragment_mask[3 : 0];
  assign ll_cmd_writeMaskSplit_1 = io_sgWrite_cmd_payload_fragment_mask[7 : 4];
  assign ll_cmd_writeMaskSplit_2 = io_sgWrite_cmd_payload_fragment_mask[11 : 8];
  assign ll_cmd_writeMaskSplit_3 = io_sgWrite_cmd_payload_fragment_mask[15 : 12];
  assign ll_cmd_writeDataSplit_0 = io_sgWrite_cmd_payload_fragment_data[31 : 0];
  assign ll_cmd_writeDataSplit_1 = io_sgWrite_cmd_payload_fragment_data[63 : 32];
  assign ll_cmd_writeDataSplit_2 = io_sgWrite_cmd_payload_fragment_data[95 : 64];
  assign ll_cmd_writeDataSplit_3 = io_sgWrite_cmd_payload_fragment_data[127 : 96];
  assign _zz_486 = zz_io_sgWrite_cmd_payload_fragment_mask(1'b0);
  always @ (*) io_sgWrite_cmd_payload_fragment_mask = _zz_486;
  always @ (*) begin
    io_sgWrite_cmd_payload_fragment_data[63 : 32] = 32'h0;
    io_sgWrite_cmd_payload_fragment_data[95 : 64] = 32'h0;
    io_sgWrite_cmd_payload_fragment_data[127 : 96] = 32'h0;
    io_sgWrite_cmd_payload_fragment_data[31 : 0] = 32'h0;
    io_sgWrite_cmd_payload_fragment_data[26 : 0] = ll_cmd_bytesDone;
    io_sgWrite_cmd_payload_fragment_data[30] = ll_cmd_endOfPacket;
    io_sgWrite_cmd_payload_fragment_data[31] = (! ll_cmd_isJustASink);
  end

  assign ll_readRsp_context_channel = io_sgRead_rsp_payload_fragment_context[1 : 0];
  always @ (*) begin
    _zz_88[0] = (ll_readRsp_context_channel == 2'b00);
    _zz_88[1] = (ll_readRsp_context_channel == 2'b01);
    _zz_88[2] = (ll_readRsp_context_channel == 2'b10);
    _zz_88[3] = (ll_readRsp_context_channel == 2'b11);
  end

  assign ll_readRsp_oh_0 = _zz_88[0];
  assign ll_readRsp_oh_1 = _zz_88[1];
  assign ll_readRsp_oh_2 = _zz_88[2];
  assign ll_readRsp_oh_3 = _zz_88[3];
  assign io_sgRead_rsp_ready = 1'b1;
  assign ll_writeRsp_context_channel = io_sgWrite_rsp_payload_fragment_context[1 : 0];
  always @ (*) begin
    _zz_89[0] = (ll_writeRsp_context_channel == 2'b00);
    _zz_89[1] = (ll_writeRsp_context_channel == 2'b01);
    _zz_89[2] = (ll_writeRsp_context_channel == 2'b10);
    _zz_89[3] = (ll_writeRsp_context_channel == 2'b11);
  end

  assign ll_writeRsp_oh_0 = _zz_89[0];
  assign ll_writeRsp_oh_1 = _zz_89[1];
  assign ll_writeRsp_oh_2 = _zz_89[2];
  assign ll_writeRsp_oh_3 = _zz_89[3];
  assign io_sgWrite_rsp_ready = 1'b1;
  always @ (*) begin
    io_interrupts = 4'b0000;
    if(channels_0_interrupts_completion_valid)begin
      io_interrupts[0] = 1'b1;
    end
    if(channels_0_interrupts_onChannelCompletion_valid)begin
      io_interrupts[0] = 1'b1;
    end
    if(channels_0_interrupts_onLinkedListUpdate_valid)begin
      io_interrupts[0] = 1'b1;
    end
    if(channels_0_interrupts_s2mPacket_valid)begin
      io_interrupts[0] = 1'b1;
    end
    if(channels_1_interrupts_completion_valid)begin
      io_interrupts[1] = 1'b1;
    end
    if(channels_1_interrupts_onChannelCompletion_valid)begin
      io_interrupts[1] = 1'b1;
    end
    if(channels_1_interrupts_onLinkedListUpdate_valid)begin
      io_interrupts[1] = 1'b1;
    end
    if(channels_2_interrupts_completion_valid)begin
      io_interrupts[2] = 1'b1;
    end
    if(channels_2_interrupts_onChannelCompletion_valid)begin
      io_interrupts[2] = 1'b1;
    end
    if(channels_2_interrupts_onLinkedListUpdate_valid)begin
      io_interrupts[2] = 1'b1;
    end
    if(channels_2_interrupts_s2mPacket_valid)begin
      io_interrupts[2] = 1'b1;
    end
    if(channels_3_interrupts_completion_valid)begin
      io_interrupts[3] = 1'b1;
    end
    if(channels_3_interrupts_onChannelCompletion_valid)begin
      io_interrupts[3] = 1'b1;
    end
    if(channels_3_interrupts_onLinkedListUpdate_valid)begin
      io_interrupts[3] = 1'b1;
    end
  end

  always @ (*) begin
    _zz_90 = 1'b0;
    case(io_ctrl_PADDR)
      14'h002c : begin
        if(ctrl_doWrite)begin
          _zz_90 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_91 = 1'b0;
    case(io_ctrl_PADDR)
      14'h002c : begin
        if(ctrl_doWrite)begin
          _zz_91 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_92 = 1'b0;
    case(io_ctrl_PADDR)
      14'h002c : begin
        if(ctrl_doWrite)begin
          _zz_92 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_93 = 1'b0;
    case(io_ctrl_PADDR)
      14'h002c : begin
        if(ctrl_doWrite)begin
          _zz_93 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_94 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0054 : begin
        if(ctrl_doWrite)begin
          _zz_94 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_95 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0054 : begin
        if(ctrl_doWrite)begin
          _zz_95 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_96 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0054 : begin
        if(ctrl_doWrite)begin
          _zz_96 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_97 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0054 : begin
        if(ctrl_doWrite)begin
          _zz_97 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_98 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00ac : begin
        if(ctrl_doWrite)begin
          _zz_98 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_99 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00ac : begin
        if(ctrl_doWrite)begin
          _zz_99 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_100 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00ac : begin
        if(ctrl_doWrite)begin
          _zz_100 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_101 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00ac : begin
        if(ctrl_doWrite)begin
          _zz_101 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_102 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00d4 : begin
        if(ctrl_doWrite)begin
          _zz_102 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_103 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00d4 : begin
        if(ctrl_doWrite)begin
          _zz_103 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_104 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00d4 : begin
        if(ctrl_doWrite)begin
          _zz_104 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_105 = 1'b0;
    case(io_ctrl_PADDR)
      14'h012c : begin
        if(ctrl_doWrite)begin
          _zz_105 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_106 = 1'b0;
    case(io_ctrl_PADDR)
      14'h012c : begin
        if(ctrl_doWrite)begin
          _zz_106 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_107 = 1'b0;
    case(io_ctrl_PADDR)
      14'h012c : begin
        if(ctrl_doWrite)begin
          _zz_107 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_108 = 1'b0;
    case(io_ctrl_PADDR)
      14'h012c : begin
        if(ctrl_doWrite)begin
          _zz_108 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_109 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0154 : begin
        if(ctrl_doWrite)begin
          _zz_109 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_110 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0154 : begin
        if(ctrl_doWrite)begin
          _zz_110 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_111 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0154 : begin
        if(ctrl_doWrite)begin
          _zz_111 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_112 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0154 : begin
        if(ctrl_doWrite)begin
          _zz_112 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_113 = 1'b0;
    case(io_ctrl_PADDR)
      14'h01ac : begin
        if(ctrl_doWrite)begin
          _zz_113 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_114 = 1'b0;
    case(io_ctrl_PADDR)
      14'h01ac : begin
        if(ctrl_doWrite)begin
          _zz_114 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_115 = 1'b0;
    case(io_ctrl_PADDR)
      14'h01ac : begin
        if(ctrl_doWrite)begin
          _zz_115 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_116 = 1'b0;
    case(io_ctrl_PADDR)
      14'h01ac : begin
        if(ctrl_doWrite)begin
          _zz_116 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_117 = 1'b0;
    case(io_ctrl_PADDR)
      14'h01d4 : begin
        if(ctrl_doWrite)begin
          _zz_117 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_118 = 1'b0;
    case(io_ctrl_PADDR)
      14'h01d4 : begin
        if(ctrl_doWrite)begin
          _zz_118 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_119 = 1'b0;
    case(io_ctrl_PADDR)
      14'h01d4 : begin
        if(ctrl_doWrite)begin
          _zz_119 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign channels_0_fifo_push_ptrIncr_value = _zz_446;
  assign channels_0_fifo_pop_bytesIncr_value = _zz_448;
  assign channels_0_fifo_pop_bytesDecr_value = channels_0_pop_b2m_decrBytes;
  assign channels_0_fifo_pop_ptrIncr_value = _zz_450;
  assign channels_1_fifo_push_ptrIncr_value = _zz_452;
  assign channels_1_fifo_pop_bytesIncr_value = _zz_454;
  assign channels_1_fifo_pop_bytesDecr_value = 14'h0;
  assign channels_1_fifo_pop_ptrIncr_value = _zz_457;
  assign channels_2_fifo_push_ptrIncr_value = _zz_459;
  assign channels_2_fifo_pop_bytesIncr_value = _zz_461;
  assign channels_2_fifo_pop_bytesDecr_value = channels_2_pop_b2m_decrBytes;
  assign channels_2_fifo_pop_ptrIncr_value = _zz_463;
  assign channels_3_fifo_push_ptrIncr_value = _zz_465;
  assign channels_3_fifo_pop_bytesIncr_value = _zz_467;
  assign channels_3_fifo_pop_bytesDecr_value = 14'h0;
  assign channels_3_fifo_pop_ptrIncr_value = _zz_470;
  always @ (posedge clk) begin
    if(reset) begin
      channels_0_channelValid <= 1'b0;
      channels_0_descriptorValid <= 1'b0;
      channels_0_priority <= 2'b00;
      channels_0_weight <= 2'b00;
      channels_0_ctrl_kick <= 1'b0;
      channels_0_ll_valid <= 1'b0;
      channels_0_pop_b2m_memPending <= 4'b0000;
      channels_0_interrupts_completion_enable <= 1'b0;
      channels_0_interrupts_completion_valid <= 1'b0;
      channels_0_interrupts_onChannelCompletion_enable <= 1'b0;
      channels_0_interrupts_onChannelCompletion_valid <= 1'b0;
      channels_0_interrupts_onLinkedListUpdate_enable <= 1'b0;
      channels_0_interrupts_onLinkedListUpdate_valid <= 1'b0;
      channels_0_interrupts_s2mPacket_enable <= 1'b0;
      channels_0_interrupts_s2mPacket_valid <= 1'b0;
      channels_1_channelValid <= 1'b0;
      channels_1_descriptorValid <= 1'b0;
      channels_1_priority <= 2'b00;
      channels_1_weight <= 2'b00;
      channels_1_ctrl_kick <= 1'b0;
      channels_1_ll_valid <= 1'b0;
      channels_1_push_m2b_loadDone <= 1'b1;
      channels_1_push_m2b_memPending <= 4'b0000;
      channels_1_interrupts_completion_enable <= 1'b0;
      channels_1_interrupts_completion_valid <= 1'b0;
      channels_1_interrupts_onChannelCompletion_enable <= 1'b0;
      channels_1_interrupts_onChannelCompletion_valid <= 1'b0;
      channels_1_interrupts_onLinkedListUpdate_enable <= 1'b0;
      channels_1_interrupts_onLinkedListUpdate_valid <= 1'b0;
      channels_2_channelValid <= 1'b0;
      channels_2_descriptorValid <= 1'b0;
      channels_2_priority <= 2'b00;
      channels_2_weight <= 2'b00;
      channels_2_ctrl_kick <= 1'b0;
      channels_2_ll_valid <= 1'b0;
      channels_2_pop_b2m_memPending <= 4'b0000;
      channels_2_interrupts_completion_enable <= 1'b0;
      channels_2_interrupts_completion_valid <= 1'b0;
      channels_2_interrupts_onChannelCompletion_enable <= 1'b0;
      channels_2_interrupts_onChannelCompletion_valid <= 1'b0;
      channels_2_interrupts_onLinkedListUpdate_enable <= 1'b0;
      channels_2_interrupts_onLinkedListUpdate_valid <= 1'b0;
      channels_2_interrupts_s2mPacket_enable <= 1'b0;
      channels_2_interrupts_s2mPacket_valid <= 1'b0;
      channels_3_channelValid <= 1'b0;
      channels_3_descriptorValid <= 1'b0;
      channels_3_priority <= 2'b00;
      channels_3_weight <= 2'b00;
      channels_3_ctrl_kick <= 1'b0;
      channels_3_ll_valid <= 1'b0;
      channels_3_push_m2b_loadDone <= 1'b1;
      channels_3_push_m2b_memPending <= 4'b0000;
      channels_3_interrupts_completion_enable <= 1'b0;
      channels_3_interrupts_completion_valid <= 1'b0;
      channels_3_interrupts_onChannelCompletion_enable <= 1'b0;
      channels_3_interrupts_onChannelCompletion_valid <= 1'b0;
      channels_3_interrupts_onLinkedListUpdate_enable <= 1'b0;
      channels_3_interrupts_onLinkedListUpdate_valid <= 1'b0;
      io_inputs_0_payload_last_regNextWhen <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_1 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_2 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_3 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_4 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_5 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_6 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_7 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_8 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_9 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_10 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_11 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_12 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_13 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_14 <= 1'b1;
      io_inputs_0_payload_last_regNextWhen_15 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_1 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_2 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_3 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_4 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_5 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_6 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_7 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_8 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_9 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_10 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_11 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_12 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_13 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_14 <= 1'b1;
      io_inputs_1_payload_last_regNextWhen_15 <= 1'b1;
      m2b_cmd_s0_valid <= 1'b0;
      m2b_cmd_s0_priority_roundRobins_0 <= 2'b01;
      m2b_cmd_s0_priority_roundRobins_1 <= 2'b01;
      m2b_cmd_s0_priority_roundRobins_2 <= 2'b01;
      m2b_cmd_s0_priority_roundRobins_3 <= 2'b01;
      m2b_cmd_s0_priority_counter <= 2'b00;
      m2b_cmd_s1_valid <= 1'b0;
      m2b_rsp_first <= 1'b1;
      b2m_fsm_sel_valid <= 1'b0;
      b2m_fsm_arbiter_logic_valid <= 1'b0;
      b2m_fsm_arbiter_logic_priority_roundRobins_0 <= 2'b01;
      b2m_fsm_arbiter_logic_priority_roundRobins_1 <= 2'b01;
      b2m_fsm_arbiter_logic_priority_roundRobins_2 <= 2'b01;
      b2m_fsm_arbiter_logic_priority_roundRobins_3 <= 2'b01;
      b2m_fsm_arbiter_logic_priority_counter <= 2'b00;
      b2m_fsm_sel_valid_regNext <= 1'b0;
      b2m_fsm_s1 <= 1'b0;
      b2m_fsm_s2 <= 1'b0;
      b2m_fsm_toggle <= 1'b0;
      memory_core_io_reads_2_rsp_s2mPipe_rValid <= 1'b0;
      _zz_54 <= 1'b0;
      io_write_cmd_payload_first <= 1'b1;
      ll_cmd_valid <= 1'b0;
      ll_readRsp_beatCounter <= 1'b0;
    end else begin
      if(channels_0_channelStart)begin
        channels_0_channelValid <= 1'b1;
      end
      if(channels_0_channelCompletion)begin
        channels_0_channelValid <= 1'b0;
      end
      if(channels_0_descriptorStart)begin
        channels_0_descriptorValid <= 1'b1;
      end
      if(channels_0_descriptorCompletion)begin
        channels_0_descriptorValid <= 1'b0;
      end
      channels_0_ctrl_kick <= 1'b0;
      if(channels_0_channelCompletion)begin
        channels_0_ctrl_kick <= 1'b0;
      end
      if(_zz_175)begin
        if(_zz_176)begin
          if(! _zz_177) begin
            channels_0_ll_valid <= 1'b0;
          end
        end
      end
      if(channels_0_ll_sgStart)begin
        channels_0_ll_valid <= 1'b1;
      end
      if(channels_0_channelCompletion)begin
        channels_0_ll_valid <= 1'b0;
      end
      channels_0_pop_b2m_memPending <= (_zz_222 - _zz_226);
      if((channels_0_descriptorValid && channels_0_descriptorCompletion))begin
        channels_0_interrupts_completion_valid <= 1'b1;
      end
      if((! channels_0_interrupts_completion_enable))begin
        channels_0_interrupts_completion_valid <= 1'b0;
      end
      if((channels_0_channelValid && channels_0_channelCompletion))begin
        channels_0_interrupts_onChannelCompletion_valid <= 1'b1;
      end
      if((! channels_0_interrupts_onChannelCompletion_enable))begin
        channels_0_interrupts_onChannelCompletion_valid <= 1'b0;
      end
      if(channels_0_ll_descriptorUpdated)begin
        channels_0_interrupts_onLinkedListUpdate_valid <= 1'b1;
      end
      if((! channels_0_interrupts_onLinkedListUpdate_enable))begin
        channels_0_interrupts_onLinkedListUpdate_valid <= 1'b0;
      end
      if(channels_0_pop_b2m_packetSync)begin
        channels_0_interrupts_s2mPacket_valid <= 1'b1;
      end
      if((! channels_0_interrupts_s2mPacket_enable))begin
        channels_0_interrupts_s2mPacket_valid <= 1'b0;
      end
      if(channels_1_channelStart)begin
        channels_1_channelValid <= 1'b1;
      end
      if(channels_1_channelCompletion)begin
        channels_1_channelValid <= 1'b0;
      end
      if(channels_1_descriptorStart)begin
        channels_1_descriptorValid <= 1'b1;
      end
      if(channels_1_descriptorCompletion)begin
        channels_1_descriptorValid <= 1'b0;
      end
      channels_1_ctrl_kick <= 1'b0;
      if(channels_1_channelCompletion)begin
        channels_1_ctrl_kick <= 1'b0;
      end
      if(_zz_187)begin
        if(_zz_188)begin
          if(! _zz_189) begin
            channels_1_ll_valid <= 1'b0;
          end
        end
      end
      if(channels_1_ll_sgStart)begin
        channels_1_ll_valid <= 1'b1;
      end
      if(channels_1_channelCompletion)begin
        channels_1_ll_valid <= 1'b0;
      end
      channels_1_push_m2b_memPending <= (_zz_232 - _zz_236);
      if(channels_1_descriptorStart)begin
        channels_1_push_m2b_loadDone <= 1'b0;
      end
      if((channels_1_descriptorValid && channels_1_descriptorCompletion))begin
        channels_1_interrupts_completion_valid <= 1'b1;
      end
      if((! channels_1_interrupts_completion_enable))begin
        channels_1_interrupts_completion_valid <= 1'b0;
      end
      if((channels_1_channelValid && channels_1_channelCompletion))begin
        channels_1_interrupts_onChannelCompletion_valid <= 1'b1;
      end
      if((! channels_1_interrupts_onChannelCompletion_enable))begin
        channels_1_interrupts_onChannelCompletion_valid <= 1'b0;
      end
      if(channels_1_ll_descriptorUpdated)begin
        channels_1_interrupts_onLinkedListUpdate_valid <= 1'b1;
      end
      if((! channels_1_interrupts_onLinkedListUpdate_enable))begin
        channels_1_interrupts_onLinkedListUpdate_valid <= 1'b0;
      end
      if(channels_2_channelStart)begin
        channels_2_channelValid <= 1'b1;
      end
      if(channels_2_channelCompletion)begin
        channels_2_channelValid <= 1'b0;
      end
      if(channels_2_descriptorStart)begin
        channels_2_descriptorValid <= 1'b1;
      end
      if(channels_2_descriptorCompletion)begin
        channels_2_descriptorValid <= 1'b0;
      end
      channels_2_ctrl_kick <= 1'b0;
      if(channels_2_channelCompletion)begin
        channels_2_ctrl_kick <= 1'b0;
      end
      if(_zz_195)begin
        if(_zz_196)begin
          if(! _zz_197) begin
            channels_2_ll_valid <= 1'b0;
          end
        end
      end
      if(channels_2_ll_sgStart)begin
        channels_2_ll_valid <= 1'b1;
      end
      if(channels_2_channelCompletion)begin
        channels_2_ll_valid <= 1'b0;
      end
      channels_2_pop_b2m_memPending <= (_zz_250 - _zz_254);
      if((channels_2_descriptorValid && channels_2_descriptorCompletion))begin
        channels_2_interrupts_completion_valid <= 1'b1;
      end
      if((! channels_2_interrupts_completion_enable))begin
        channels_2_interrupts_completion_valid <= 1'b0;
      end
      if((channels_2_channelValid && channels_2_channelCompletion))begin
        channels_2_interrupts_onChannelCompletion_valid <= 1'b1;
      end
      if((! channels_2_interrupts_onChannelCompletion_enable))begin
        channels_2_interrupts_onChannelCompletion_valid <= 1'b0;
      end
      if(channels_2_ll_descriptorUpdated)begin
        channels_2_interrupts_onLinkedListUpdate_valid <= 1'b1;
      end
      if((! channels_2_interrupts_onLinkedListUpdate_enable))begin
        channels_2_interrupts_onLinkedListUpdate_valid <= 1'b0;
      end
      if(channels_2_pop_b2m_packetSync)begin
        channels_2_interrupts_s2mPacket_valid <= 1'b1;
      end
      if((! channels_2_interrupts_s2mPacket_enable))begin
        channels_2_interrupts_s2mPacket_valid <= 1'b0;
      end
      if(channels_3_channelStart)begin
        channels_3_channelValid <= 1'b1;
      end
      if(channels_3_channelCompletion)begin
        channels_3_channelValid <= 1'b0;
      end
      if(channels_3_descriptorStart)begin
        channels_3_descriptorValid <= 1'b1;
      end
      if(channels_3_descriptorCompletion)begin
        channels_3_descriptorValid <= 1'b0;
      end
      channels_3_ctrl_kick <= 1'b0;
      if(channels_3_channelCompletion)begin
        channels_3_ctrl_kick <= 1'b0;
      end
      if(_zz_204)begin
        if(_zz_205)begin
          if(! _zz_206) begin
            channels_3_ll_valid <= 1'b0;
          end
        end
      end
      if(channels_3_ll_sgStart)begin
        channels_3_ll_valid <= 1'b1;
      end
      if(channels_3_channelCompletion)begin
        channels_3_ll_valid <= 1'b0;
      end
      channels_3_push_m2b_memPending <= (_zz_260 - _zz_264);
      if(channels_3_descriptorStart)begin
        channels_3_push_m2b_loadDone <= 1'b0;
      end
      if((channels_3_descriptorValid && channels_3_descriptorCompletion))begin
        channels_3_interrupts_completion_valid <= 1'b1;
      end
      if((! channels_3_interrupts_completion_enable))begin
        channels_3_interrupts_completion_valid <= 1'b0;
      end
      if((channels_3_channelValid && channels_3_channelCompletion))begin
        channels_3_interrupts_onChannelCompletion_valid <= 1'b1;
      end
      if((! channels_3_interrupts_onChannelCompletion_enable))begin
        channels_3_interrupts_onChannelCompletion_valid <= 1'b0;
      end
      if(channels_3_ll_descriptorUpdated)begin
        channels_3_interrupts_onLinkedListUpdate_valid <= 1'b1;
      end
      if((! channels_3_interrupts_onLinkedListUpdate_enable))begin
        channels_3_interrupts_onLinkedListUpdate_valid <= 1'b0;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b0000)))begin
        io_inputs_0_payload_last_regNextWhen <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b0001)))begin
        io_inputs_0_payload_last_regNextWhen_1 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b0010)))begin
        io_inputs_0_payload_last_regNextWhen_2 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b0011)))begin
        io_inputs_0_payload_last_regNextWhen_3 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b0100)))begin
        io_inputs_0_payload_last_regNextWhen_4 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b0101)))begin
        io_inputs_0_payload_last_regNextWhen_5 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b0110)))begin
        io_inputs_0_payload_last_regNextWhen_6 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b0111)))begin
        io_inputs_0_payload_last_regNextWhen_7 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b1000)))begin
        io_inputs_0_payload_last_regNextWhen_8 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b1001)))begin
        io_inputs_0_payload_last_regNextWhen_9 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b1010)))begin
        io_inputs_0_payload_last_regNextWhen_10 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b1011)))begin
        io_inputs_0_payload_last_regNextWhen_11 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b1100)))begin
        io_inputs_0_payload_last_regNextWhen_12 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b1101)))begin
        io_inputs_0_payload_last_regNextWhen_13 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b1110)))begin
        io_inputs_0_payload_last_regNextWhen_14 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_0_valid && io_inputs_0_ready) && (io_inputs_0_payload_sink == 4'b1111)))begin
        io_inputs_0_payload_last_regNextWhen_15 <= io_inputs_0_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b0000)))begin
        io_inputs_1_payload_last_regNextWhen <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b0001)))begin
        io_inputs_1_payload_last_regNextWhen_1 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b0010)))begin
        io_inputs_1_payload_last_regNextWhen_2 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b0011)))begin
        io_inputs_1_payload_last_regNextWhen_3 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b0100)))begin
        io_inputs_1_payload_last_regNextWhen_4 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b0101)))begin
        io_inputs_1_payload_last_regNextWhen_5 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b0110)))begin
        io_inputs_1_payload_last_regNextWhen_6 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b0111)))begin
        io_inputs_1_payload_last_regNextWhen_7 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b1000)))begin
        io_inputs_1_payload_last_regNextWhen_8 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b1001)))begin
        io_inputs_1_payload_last_regNextWhen_9 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b1010)))begin
        io_inputs_1_payload_last_regNextWhen_10 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b1011)))begin
        io_inputs_1_payload_last_regNextWhen_11 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b1100)))begin
        io_inputs_1_payload_last_regNextWhen_12 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b1101)))begin
        io_inputs_1_payload_last_regNextWhen_13 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b1110)))begin
        io_inputs_1_payload_last_regNextWhen_14 <= io_inputs_1_payload_last;
      end
      if(((io_inputs_1_valid && io_inputs_1_ready) && (io_inputs_1_payload_sink == 4'b1111)))begin
        io_inputs_1_payload_last_regNextWhen_15 <= io_inputs_1_payload_last;
      end
      if(_zz_193)begin
        if(({channels_3_push_m2b_loadRequest,channels_1_push_m2b_loadRequest} != 2'b00))begin
          m2b_cmd_s0_valid <= 1'b1;
          if((2'b00 == _zz_33))begin
            m2b_cmd_s0_priority_roundRobins_0 <= m2b_cmd_s0_priority_contextNext;
          end
          if((2'b01 == _zz_33))begin
            m2b_cmd_s0_priority_roundRobins_1 <= m2b_cmd_s0_priority_contextNext;
          end
          if((2'b10 == _zz_33))begin
            m2b_cmd_s0_priority_roundRobins_2 <= m2b_cmd_s0_priority_contextNext;
          end
          if((2'b11 == _zz_33))begin
            m2b_cmd_s0_priority_roundRobins_3 <= m2b_cmd_s0_priority_contextNext;
          end
          m2b_cmd_s0_priority_counter <= (m2b_cmd_s0_priority_counter + 2'b01);
          if(m2b_cmd_s0_priority_weightLast)begin
            m2b_cmd_s0_priority_counter <= 2'b00;
          end
        end
      end
      if(m2b_cmd_s0_valid)begin
        m2b_cmd_s1_valid <= 1'b1;
      end
      if(m2b_cmd_s1_valid)begin
        if(io_read_cmd_ready)begin
          m2b_cmd_s0_valid <= 1'b0;
          m2b_cmd_s1_valid <= 1'b0;
          if(_zz_192)begin
            if(m2b_cmd_s1_lastBurst)begin
              channels_1_push_m2b_loadDone <= 1'b1;
            end
          end
          if(_zz_209)begin
            if(m2b_cmd_s1_lastBurst)begin
              channels_3_push_m2b_loadDone <= 1'b1;
            end
          end
        end
      end
      if((io_read_rsp_valid && io_read_rsp_ready))begin
        m2b_rsp_first <= io_read_rsp_payload_last;
      end
      if(_zz_185)begin
        if(({channels_2_pop_b2m_request,channels_0_pop_b2m_request} != 2'b00))begin
          b2m_fsm_arbiter_logic_valid <= 1'b1;
          if((2'b00 == _zz_44))begin
            b2m_fsm_arbiter_logic_priority_roundRobins_0 <= b2m_fsm_arbiter_logic_priority_contextNext;
          end
          if((2'b01 == _zz_44))begin
            b2m_fsm_arbiter_logic_priority_roundRobins_1 <= b2m_fsm_arbiter_logic_priority_contextNext;
          end
          if((2'b10 == _zz_44))begin
            b2m_fsm_arbiter_logic_priority_roundRobins_2 <= b2m_fsm_arbiter_logic_priority_contextNext;
          end
          if((2'b11 == _zz_44))begin
            b2m_fsm_arbiter_logic_priority_roundRobins_3 <= b2m_fsm_arbiter_logic_priority_contextNext;
          end
          b2m_fsm_arbiter_logic_priority_counter <= (b2m_fsm_arbiter_logic_priority_counter + 2'b01);
          if(b2m_fsm_arbiter_logic_priority_weightLast)begin
            b2m_fsm_arbiter_logic_priority_counter <= 2'b00;
          end
        end
      end
      if(b2m_fsm_sel_ready)begin
        b2m_fsm_sel_valid <= 1'b0;
        if(b2m_fsm_sel_valid)begin
          b2m_fsm_arbiter_logic_valid <= 1'b0;
        end
      end
      if(_zz_183)begin
        b2m_fsm_sel_valid <= 1'b1;
      end
      b2m_fsm_sel_valid_regNext <= b2m_fsm_sel_valid;
      b2m_fsm_s1 <= b2m_fsm_s0;
      if(b2m_fsm_s1)begin
        b2m_fsm_s2 <= 1'b1;
      end
      if((! b2m_fsm_sel_valid))begin
        b2m_fsm_s2 <= 1'b0;
      end
      b2m_fsm_toggle <= (b2m_fsm_toggle ^ (b2m_fsm_sel_valid && b2m_fsm_sel_ready));
      if(memory_core_io_reads_2_rsp_s2mPipe_ready)begin
        memory_core_io_reads_2_rsp_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_212)begin
        memory_core_io_reads_2_rsp_s2mPipe_rValid <= memory_core_io_reads_2_rsp_valid;
      end
      _zz_54 <= (b2m_fsm_sel_valid && (! b2m_fsm_sel_ready));
      if((io_write_cmd_valid && io_write_cmd_ready))begin
        io_write_cmd_payload_first <= io_write_cmd_payload_last;
      end
      if(_zz_213)begin
        if(({_zz_64,{_zz_63,{_zz_62,channels_0_ll_requestLl}}} != 4'b0000))begin
          ll_cmd_valid <= 1'b1;
        end
      end else begin
        if((ll_cmd_writeFired && ll_cmd_readFired))begin
          ll_cmd_valid <= 1'b0;
        end
      end
      if(_zz_214)begin
        ll_readRsp_beatCounter <= (ll_readRsp_beatCounter + 1'b1);
      end
      if(_zz_91)begin
        if(_zz_343[0])begin
          channels_0_ctrl_kick <= _zz_344[0];
        end
      end
      if(_zz_94)begin
        if(_zz_349[0])begin
          channels_0_interrupts_completion_valid <= _zz_350[0];
        end
      end
      if(_zz_95)begin
        if(_zz_351[0])begin
          channels_0_interrupts_onChannelCompletion_valid <= _zz_352[0];
        end
      end
      if(_zz_96)begin
        if(_zz_353[0])begin
          channels_0_interrupts_onLinkedListUpdate_valid <= _zz_354[0];
        end
      end
      if(_zz_97)begin
        if(_zz_355[0])begin
          channels_0_interrupts_s2mPacket_valid <= _zz_356[0];
        end
      end
      if(_zz_99)begin
        if(_zz_359[0])begin
          channels_1_ctrl_kick <= _zz_360[0];
        end
      end
      if(_zz_102)begin
        if(_zz_365[0])begin
          channels_1_interrupts_completion_valid <= _zz_366[0];
        end
      end
      if(_zz_103)begin
        if(_zz_367[0])begin
          channels_1_interrupts_onChannelCompletion_valid <= _zz_368[0];
        end
      end
      if(_zz_104)begin
        if(_zz_369[0])begin
          channels_1_interrupts_onLinkedListUpdate_valid <= _zz_370[0];
        end
      end
      if(_zz_106)begin
        if(_zz_373[0])begin
          channels_2_ctrl_kick <= _zz_374[0];
        end
      end
      if(_zz_109)begin
        if(_zz_379[0])begin
          channels_2_interrupts_completion_valid <= _zz_380[0];
        end
      end
      if(_zz_110)begin
        if(_zz_381[0])begin
          channels_2_interrupts_onChannelCompletion_valid <= _zz_382[0];
        end
      end
      if(_zz_111)begin
        if(_zz_383[0])begin
          channels_2_interrupts_onLinkedListUpdate_valid <= _zz_384[0];
        end
      end
      if(_zz_112)begin
        if(_zz_385[0])begin
          channels_2_interrupts_s2mPacket_valid <= _zz_386[0];
        end
      end
      if(_zz_114)begin
        if(_zz_389[0])begin
          channels_3_ctrl_kick <= _zz_390[0];
        end
      end
      if(_zz_117)begin
        if(_zz_395[0])begin
          channels_3_interrupts_completion_valid <= _zz_396[0];
        end
      end
      if(_zz_118)begin
        if(_zz_397[0])begin
          channels_3_interrupts_onChannelCompletion_valid <= _zz_398[0];
        end
      end
      if(_zz_119)begin
        if(_zz_399[0])begin
          channels_3_interrupts_onLinkedListUpdate_valid <= _zz_400[0];
        end
      end
      case(io_ctrl_PADDR)
        14'h0044 : begin
          if(ctrl_doWrite)begin
            channels_0_priority <= io_ctrl_PWDATA[1 : 0];
            channels_0_weight <= io_ctrl_PWDATA[9 : 8];
          end
        end
        14'h0050 : begin
          if(ctrl_doWrite)begin
            channels_0_interrupts_completion_enable <= _zz_409[0];
            channels_0_interrupts_onChannelCompletion_enable <= _zz_410[0];
            channels_0_interrupts_onLinkedListUpdate_enable <= _zz_411[0];
            channels_0_interrupts_s2mPacket_enable <= _zz_412[0];
          end
        end
        14'h00c4 : begin
          if(ctrl_doWrite)begin
            channels_1_priority <= io_ctrl_PWDATA[1 : 0];
            channels_1_weight <= io_ctrl_PWDATA[9 : 8];
          end
        end
        14'h00d0 : begin
          if(ctrl_doWrite)begin
            channels_1_interrupts_completion_enable <= _zz_420[0];
            channels_1_interrupts_onChannelCompletion_enable <= _zz_421[0];
            channels_1_interrupts_onLinkedListUpdate_enable <= _zz_422[0];
          end
        end
        14'h0144 : begin
          if(ctrl_doWrite)begin
            channels_2_priority <= io_ctrl_PWDATA[1 : 0];
            channels_2_weight <= io_ctrl_PWDATA[9 : 8];
          end
        end
        14'h0150 : begin
          if(ctrl_doWrite)begin
            channels_2_interrupts_completion_enable <= _zz_431[0];
            channels_2_interrupts_onChannelCompletion_enable <= _zz_432[0];
            channels_2_interrupts_onLinkedListUpdate_enable <= _zz_433[0];
            channels_2_interrupts_s2mPacket_enable <= _zz_434[0];
          end
        end
        14'h01c4 : begin
          if(ctrl_doWrite)begin
            channels_3_priority <= io_ctrl_PWDATA[1 : 0];
            channels_3_weight <= io_ctrl_PWDATA[9 : 8];
          end
        end
        14'h01d0 : begin
          if(ctrl_doWrite)begin
            channels_3_interrupts_completion_enable <= _zz_442[0];
            channels_3_interrupts_onChannelCompletion_enable <= _zz_443[0];
            channels_3_interrupts_onLinkedListUpdate_enable <= _zz_444[0];
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    if(channels_0_bytesProbe_incr_valid)begin
      channels_0_bytesProbe_value <= (_zz_215 + 27'h0000001);
    end
    if(channels_0_descriptorStart)begin
      channels_0_ll_packet <= 1'b0;
    end
    if(channels_0_descriptorStart)begin
      channels_0_ll_requireSync <= 1'b0;
    end
    if(_zz_175)begin
      channels_0_ll_waitDone <= 1'b0;
      if(_zz_176)begin
        channels_0_ll_head <= 1'b0;
      end
    end
    if(channels_0_channelStart)begin
      channels_0_ll_waitDone <= 1'b0;
      channels_0_ll_head <= 1'b1;
    end
    channels_0_fifo_push_ptr <= (channels_0_fifo_push_ptr + channels_0_fifo_push_ptrIncr_value);
    if(channels_0_channelStart)begin
      channels_0_fifo_push_ptr <= 10'h0;
    end
    channels_0_fifo_pop_ptr <= (channels_0_fifo_pop_ptr + channels_0_fifo_pop_ptrIncr_value);
    channels_0_fifo_pop_withOverride_backup <= channels_0_fifo_pop_withOverride_backupNext;
    if((channels_0_channelStart || channels_0_fifo_pop_withOverride_unload))begin
      channels_0_fifo_pop_withOverride_valid <= 1'b0;
    end
    if(channels_0_fifo_pop_withOverride_load)begin
      channels_0_fifo_pop_withOverride_valid <= 1'b1;
    end
    channels_0_fifo_pop_withOverride_exposed <= ((! channels_0_fifo_pop_withOverride_valid) ? channels_0_fifo_pop_withOverride_backupNext : _zz_218);
    if(channels_0_channelStart)begin
      channels_0_fifo_pop_withOverride_backup <= 14'h0;
      channels_0_fifo_pop_withOverride_valid <= 1'b0;
    end
    if(channels_0_channelStart)begin
      channels_0_push_s2b_packetLock <= 1'b0;
    end
    if(channels_0_pop_b2m_fire)begin
      channels_0_pop_b2m_flush <= 1'b0;
    end
    if((channels_0_channelStart || channels_0_pop_b2m_fire))begin
      channels_0_pop_b2m_packet <= 1'b0;
    end
    if((channels_0_pop_b2m_bytesLeft < _zz_227))begin
      channels_0_pop_b2m_flush <= 1'b1;
    end
    if(_zz_184)begin
      channels_0_pop_b2m_flush <= 1'b0;
      channels_0_pop_b2m_packet <= 1'b0;
    end
    if(channels_0_pop_b2m_packetSync)begin
      channels_0_push_s2b_packetLock <= 1'b0;
      if(_zz_180)begin
        if(! channels_0_push_s2b_completionOnLast) begin
          if((! channels_0_pop_b2m_waitFinalRsp))begin
            channels_0_ll_requireSync <= 1'b1;
          end
        end
        channels_0_ll_packet <= 1'b1;
      end
    end
    if(channels_0_channelStart)begin
      channels_0_pop_b2m_bytesToSkip <= 4'b0000;
      channels_0_pop_b2m_flush <= 1'b0;
    end
    if(channels_0_descriptorStart)begin
      channels_0_pop_b2m_bytesLeft <= {1'd0, channels_0_bytes};
      channels_0_pop_b2m_waitFinalRsp <= 1'b0;
    end
    if(channels_0_channelValid)begin
      if(! channels_0_channelStop) begin
        if(_zz_178)begin
          if(_zz_179)begin
            channels_0_pop_b2m_address <= (_zz_228 - 32'h00000001);
          end
          if((_zz_1 && channels_0_readyForChannelCompletion))begin
            channels_0_channelStop <= 1'b1;
          end
        end
      end
    end
    channels_0_fifo_pop_ptrIncr_value_regNext <= channels_0_fifo_pop_ptrIncr_value;
    channels_0_fifo_push_available <= (_zz_230 - (channels_0_push_memory ? channels_0_fifo_push_availableDecr : channels_0_fifo_push_ptrIncr_value));
    if(channels_0_channelStart)begin
      channels_0_fifo_push_ptr <= 10'h0;
      channels_0_fifo_push_available <= (channels_0_fifo_words + 10'h001);
      channels_0_fifo_pop_ptr <= 10'h0;
    end
    if((channels_0_channelStart || channels_0_descriptorStart))begin
      channels_0_bytesProbe_value <= 27'h0;
    end
    if(channels_1_descriptorStart)begin
      channels_1_ll_packet <= 1'b0;
    end
    if(channels_1_descriptorStart)begin
      channels_1_ll_requireSync <= 1'b0;
    end
    if(_zz_187)begin
      channels_1_ll_waitDone <= 1'b0;
      if(_zz_188)begin
        channels_1_ll_head <= 1'b0;
      end
    end
    if(channels_1_channelStart)begin
      channels_1_ll_waitDone <= 1'b0;
      channels_1_ll_head <= 1'b1;
    end
    channels_1_fifo_push_ptr <= (channels_1_fifo_push_ptr + channels_1_fifo_push_ptrIncr_value);
    if(channels_1_channelStart)begin
      channels_1_fifo_push_ptr <= 10'h0;
    end
    channels_1_fifo_pop_ptr <= (channels_1_fifo_pop_ptr + channels_1_fifo_pop_ptrIncr_value);
    channels_1_fifo_pop_withoutOverride_exposed <= (_zz_231 - channels_1_fifo_pop_bytesDecr_value);
    if(channels_1_channelStart)begin
      channels_1_fifo_pop_withoutOverride_exposed <= 14'h0;
    end
    if(channels_1_descriptorStart)begin
      channels_1_push_m2b_bytesLeft <= channels_1_bytes;
    end
    if(channels_1_pop_b2s_veryLastTrigger)begin
      channels_1_pop_b2s_veryLastValid <= 1'b1;
    end
    if(channels_1_pop_b2s_veryLastTrigger)begin
      channels_1_pop_b2s_veryLastPtr <= channels_1_fifo_push_ptrWithBase;
      channels_1_pop_b2s_veryLastEndPacket <= channels_1_pop_b2s_last;
    end
    if(channels_1_channelStart)begin
      channels_1_pop_b2s_veryLastValid <= 1'b0;
    end
    if(channels_1_channelValid)begin
      if(! channels_1_channelStop) begin
        if(_zz_190)begin
          if(_zz_191)begin
            channels_1_push_m2b_address <= (_zz_240 - 32'h00000001);
          end
          if((_zz_2 && channels_1_readyForChannelCompletion))begin
            channels_1_channelStop <= 1'b1;
          end
        end
      end
    end
    channels_1_fifo_pop_ptrIncr_value_regNext <= channels_1_fifo_pop_ptrIncr_value;
    channels_1_fifo_push_available <= (_zz_242 - (channels_1_push_memory ? channels_1_fifo_push_availableDecr : channels_1_fifo_push_ptrIncr_value));
    if(channels_1_channelStart)begin
      channels_1_fifo_push_ptr <= 10'h0;
      channels_1_fifo_push_available <= (channels_1_fifo_words + 10'h001);
      channels_1_fifo_pop_ptr <= 10'h0;
    end
    if(channels_2_bytesProbe_incr_valid)begin
      channels_2_bytesProbe_value <= (_zz_243 + 27'h0000001);
    end
    if(channels_2_descriptorStart)begin
      channels_2_ll_packet <= 1'b0;
    end
    if(channels_2_descriptorStart)begin
      channels_2_ll_requireSync <= 1'b0;
    end
    if(_zz_195)begin
      channels_2_ll_waitDone <= 1'b0;
      if(_zz_196)begin
        channels_2_ll_head <= 1'b0;
      end
    end
    if(channels_2_channelStart)begin
      channels_2_ll_waitDone <= 1'b0;
      channels_2_ll_head <= 1'b1;
    end
    channels_2_fifo_push_ptr <= (channels_2_fifo_push_ptr + channels_2_fifo_push_ptrIncr_value);
    if(channels_2_channelStart)begin
      channels_2_fifo_push_ptr <= 10'h0;
    end
    channels_2_fifo_pop_ptr <= (channels_2_fifo_pop_ptr + channels_2_fifo_pop_ptrIncr_value);
    channels_2_fifo_pop_withOverride_backup <= channels_2_fifo_pop_withOverride_backupNext;
    if((channels_2_channelStart || channels_2_fifo_pop_withOverride_unload))begin
      channels_2_fifo_pop_withOverride_valid <= 1'b0;
    end
    if(channels_2_fifo_pop_withOverride_load)begin
      channels_2_fifo_pop_withOverride_valid <= 1'b1;
    end
    channels_2_fifo_pop_withOverride_exposed <= ((! channels_2_fifo_pop_withOverride_valid) ? channels_2_fifo_pop_withOverride_backupNext : _zz_246);
    if(channels_2_channelStart)begin
      channels_2_fifo_pop_withOverride_backup <= 14'h0;
      channels_2_fifo_pop_withOverride_valid <= 1'b0;
    end
    if(channels_2_channelStart)begin
      channels_2_push_s2b_packetLock <= 1'b0;
    end
    if(channels_2_pop_b2m_fire)begin
      channels_2_pop_b2m_flush <= 1'b0;
    end
    if((channels_2_channelStart || channels_2_pop_b2m_fire))begin
      channels_2_pop_b2m_packet <= 1'b0;
    end
    if((channels_2_pop_b2m_bytesLeft < _zz_255))begin
      channels_2_pop_b2m_flush <= 1'b1;
    end
    if(_zz_202)begin
      channels_2_pop_b2m_flush <= 1'b0;
      channels_2_pop_b2m_packet <= 1'b0;
    end
    if(channels_2_pop_b2m_packetSync)begin
      channels_2_push_s2b_packetLock <= 1'b0;
      if(_zz_200)begin
        if(! channels_2_push_s2b_completionOnLast) begin
          if((! channels_2_pop_b2m_waitFinalRsp))begin
            channels_2_ll_requireSync <= 1'b1;
          end
        end
        channels_2_ll_packet <= 1'b1;
      end
    end
    if(channels_2_channelStart)begin
      channels_2_pop_b2m_bytesToSkip <= 4'b0000;
      channels_2_pop_b2m_flush <= 1'b0;
    end
    if(channels_2_descriptorStart)begin
      channels_2_pop_b2m_bytesLeft <= {1'd0, channels_2_bytes};
      channels_2_pop_b2m_waitFinalRsp <= 1'b0;
    end
    if(channels_2_channelValid)begin
      if(! channels_2_channelStop) begin
        if(_zz_198)begin
          if(_zz_199)begin
            channels_2_pop_b2m_address <= (_zz_256 - 32'h00000001);
          end
          if((_zz_3 && channels_2_readyForChannelCompletion))begin
            channels_2_channelStop <= 1'b1;
          end
        end
      end
    end
    channels_2_fifo_pop_ptrIncr_value_regNext <= channels_2_fifo_pop_ptrIncr_value;
    channels_2_fifo_push_available <= (_zz_258 - (channels_2_push_memory ? channels_2_fifo_push_availableDecr : channels_2_fifo_push_ptrIncr_value));
    if(channels_2_channelStart)begin
      channels_2_fifo_push_ptr <= 10'h0;
      channels_2_fifo_push_available <= (channels_2_fifo_words + 10'h001);
      channels_2_fifo_pop_ptr <= 10'h0;
    end
    if((channels_2_channelStart || channels_2_descriptorStart))begin
      channels_2_bytesProbe_value <= 27'h0;
    end
    if(channels_3_descriptorStart)begin
      channels_3_ll_packet <= 1'b0;
    end
    if(channels_3_descriptorStart)begin
      channels_3_ll_requireSync <= 1'b0;
    end
    if(_zz_204)begin
      channels_3_ll_waitDone <= 1'b0;
      if(_zz_205)begin
        channels_3_ll_head <= 1'b0;
      end
    end
    if(channels_3_channelStart)begin
      channels_3_ll_waitDone <= 1'b0;
      channels_3_ll_head <= 1'b1;
    end
    channels_3_fifo_push_ptr <= (channels_3_fifo_push_ptr + channels_3_fifo_push_ptrIncr_value);
    if(channels_3_channelStart)begin
      channels_3_fifo_push_ptr <= 10'h0;
    end
    channels_3_fifo_pop_ptr <= (channels_3_fifo_pop_ptr + channels_3_fifo_pop_ptrIncr_value);
    channels_3_fifo_pop_withoutOverride_exposed <= (_zz_259 - channels_3_fifo_pop_bytesDecr_value);
    if(channels_3_channelStart)begin
      channels_3_fifo_pop_withoutOverride_exposed <= 14'h0;
    end
    if(channels_3_descriptorStart)begin
      channels_3_push_m2b_bytesLeft <= channels_3_bytes;
    end
    if(channels_3_pop_b2s_veryLastTrigger)begin
      channels_3_pop_b2s_veryLastValid <= 1'b1;
    end
    if(channels_3_pop_b2s_veryLastTrigger)begin
      channels_3_pop_b2s_veryLastPtr <= channels_3_fifo_push_ptrWithBase;
      channels_3_pop_b2s_veryLastEndPacket <= channels_3_pop_b2s_last;
    end
    if(channels_3_channelStart)begin
      channels_3_pop_b2s_veryLastValid <= 1'b0;
    end
    if(channels_3_channelValid)begin
      if(! channels_3_channelStop) begin
        if(_zz_207)begin
          if(_zz_208)begin
            channels_3_push_m2b_address <= (_zz_268 - 32'h00000001);
          end
          if((_zz_4 && channels_3_readyForChannelCompletion))begin
            channels_3_channelStop <= 1'b1;
          end
        end
      end
    end
    channels_3_fifo_pop_ptrIncr_value_regNext <= channels_3_fifo_pop_ptrIncr_value;
    channels_3_fifo_push_available <= (_zz_270 - (channels_3_push_memory ? channels_3_fifo_push_availableDecr : channels_3_fifo_push_ptrIncr_value));
    if(channels_3_channelStart)begin
      channels_3_fifo_push_ptr <= 10'h0;
      channels_3_fifo_push_available <= (channels_3_fifo_words + 10'h001);
      channels_3_fifo_pop_ptr <= 10'h0;
    end
    if(_zz_14)begin
      channels_0_push_s2b_waitFirst <= 1'b0;
      if(io_inputs_0_payload_last)begin
        channels_0_push_s2b_packetLock <= 1'b1;
      end
    end
    if((_zz_16 && s2b_0_rsp_context_flush))begin
      channels_0_pop_b2m_flush <= 1'b1;
    end
    if((_zz_16 && s2b_0_rsp_context_packet))begin
      channels_0_pop_b2m_packet <= 1'b1;
    end
    if(_zz_26)begin
      channels_2_push_s2b_waitFirst <= 1'b0;
      if(io_inputs_1_payload_last)begin
        channels_2_push_s2b_packetLock <= 1'b1;
      end
    end
    if((_zz_28 && s2b_1_rsp_context_flush))begin
      channels_2_pop_b2m_flush <= 1'b1;
    end
    if((_zz_28 && s2b_1_rsp_context_packet))begin
      channels_2_pop_b2m_packet <= 1'b1;
    end
    if(((io_outputs_0_valid && io_outputs_0_ready) && b2s_0_rsp_context_veryLast))begin
      if(b2s_0_rsp_context_channel[0])begin
        channels_1_pop_b2s_veryLastValid <= 1'b0;
      end
    end
    if(((io_outputs_1_valid && io_outputs_1_ready) && b2s_1_rsp_context_veryLast))begin
      if(b2s_1_rsp_context_channel[0])begin
        channels_3_pop_b2s_veryLastValid <= 1'b0;
      end
    end
    if(_zz_193)begin
      m2b_cmd_s0_chosen <= m2b_cmd_s0_priority_chosen;
    end
    m2b_cmd_s1_address <= m2b_cmd_s0_address;
    m2b_cmd_s1_length <= m2b_cmd_s0_length;
    m2b_cmd_s1_lastBurst <= m2b_cmd_s0_lastBurst;
    m2b_cmd_s1_bytesLeft <= m2b_cmd_s0_bytesLeft;
    if(m2b_cmd_s1_valid)begin
      if(io_read_cmd_ready)begin
        if(_zz_192)begin
          channels_1_push_m2b_address <= m2b_cmd_s1_addressNext;
          channels_1_push_m2b_bytesLeft <= m2b_cmd_s1_byteLeftNext;
        end
        if(_zz_209)begin
          channels_3_push_m2b_address <= m2b_cmd_s1_addressNext;
          channels_3_push_m2b_bytesLeft <= m2b_cmd_s1_byteLeftNext;
        end
      end
    end
    if(_zz_185)begin
      b2m_fsm_arbiter_logic_chosen <= b2m_fsm_arbiter_logic_priority_chosen;
    end
    if(_zz_183)begin
      b2m_fsm_sel_channel <= b2m_fsm_arbiter_logic_chosen;
      b2m_fsm_sel_address <= _zz_160;
      b2m_fsm_sel_ptr <= _zz_161;
      b2m_fsm_sel_ptrMask <= _zz_162;
      b2m_fsm_sel_bytePerBurst <= _zz_163;
      b2m_fsm_sel_bytesInFifo <= _zz_164;
      b2m_fsm_sel_flush <= _zz_165;
      b2m_fsm_sel_packet <= _zz_166;
      b2m_fsm_sel_bytesLeft <= _zz_167[25:0];
    end
    if(b2m_fsm_s0)begin
      b2m_fsm_sel_bytesInBurst <= _zz_322[11:0];
    end
    if(b2m_fsm_s1)begin
      b2m_fsm_beatCounter <= (_zz_327 >>> 4);
      if(_zz_186)begin
        channels_0_pop_b2m_address <= b2m_fsm_addressNext;
        channels_0_pop_b2m_bytesLeft <= b2m_fsm_bytesLeftNext;
        if(b2m_fsm_isFinalCmd)begin
          channels_0_pop_b2m_waitFinalRsp <= 1'b1;
        end
        if((! b2m_fsm_fifoCompletion))begin
          if(b2m_fsm_sel_flush)begin
            channels_0_pop_b2m_flush <= 1'b1;
          end
          if(b2m_fsm_sel_packet)begin
            channels_0_pop_b2m_packet <= 1'b1;
          end
        end
      end
      if(_zz_203)begin
        channels_2_pop_b2m_address <= b2m_fsm_addressNext;
        channels_2_pop_b2m_bytesLeft <= b2m_fsm_bytesLeftNext;
        if(b2m_fsm_isFinalCmd)begin
          channels_2_pop_b2m_waitFinalRsp <= 1'b1;
        end
        if((! b2m_fsm_fifoCompletion))begin
          if(b2m_fsm_sel_flush)begin
            channels_2_pop_b2m_flush <= 1'b1;
          end
          if(b2m_fsm_sel_packet)begin
            channels_2_pop_b2m_packet <= 1'b1;
          end
        end
      end
    end
    if((b2m_fsm_sel_valid && memory_core_io_reads_2_cmd_ready))begin
      b2m_fsm_sel_ptr <= ((b2m_fsm_sel_ptr & (~ b2m_fsm_sel_ptrMask)) | (_zz_330 & b2m_fsm_sel_ptrMask));
    end
    if(_zz_212)begin
      memory_core_io_reads_2_rsp_s2mPipe_rData_data <= memory_core_io_reads_2_rsp_payload_data;
      memory_core_io_reads_2_rsp_s2mPipe_rData_mask <= memory_core_io_reads_2_rsp_payload_mask;
      memory_core_io_reads_2_rsp_s2mPipe_rData_context <= memory_core_io_reads_2_rsp_payload_context;
    end
    if((b2m_fsm_aggregate_memoryPort_valid && b2m_fsm_aggregate_memoryPort_ready))begin
      b2m_fsm_aggregate_first <= 1'b0;
    end
    if((! (b2m_fsm_sel_valid && (! b2m_fsm_sel_ready))))begin
      b2m_fsm_aggregate_first <= 1'b1;
    end
    b2m_fsm_cmd_maskLastTriggerReg <= b2m_fsm_cmd_maskLastTriggerComb;
    b2m_fsm_cmd_maskLast <= _zz_55;
    if((io_write_cmd_valid && io_write_cmd_ready))begin
      b2m_fsm_beatCounter <= (b2m_fsm_beatCounter - 8'h01);
    end
    if(_zz_210)begin
      if(_zz_56[0])begin
        channels_0_pop_b2m_bytesToSkip <= _zz_57;
      end
      if(_zz_56[1])begin
        channels_2_pop_b2m_bytesToSkip <= _zz_57;
      end
    end
    if((! ll_cmd_valid))begin
      ll_cmd_oh_0 <= channels_0_ll_requestLl;
      ll_cmd_oh_1 <= _zz_62;
      ll_cmd_oh_2 <= _zz_63;
      ll_cmd_oh_3 <= _zz_64;
    end
    if((! ll_cmd_valid))begin
      ll_cmd_ptr <= _zz_172;
    end
    if((! ll_cmd_valid))begin
      ll_cmd_ptrNext <= _zz_173;
    end
    if((! ll_cmd_valid))begin
      ll_cmd_bytesDone <= (_zz_81[0] ? channels_0_bytesProbe_value : channels_2_bytesProbe_value);
    end
    if((! ll_cmd_valid))begin
      ll_cmd_endOfPacket <= _zz_174;
    end
    if((! ll_cmd_valid))begin
      ll_cmd_isJustASink <= ll_arbiter_isJustASink;
    end
    if(_zz_213)begin
      ll_cmd_oh_0 <= channels_0_ll_requestLl;
      ll_cmd_oh_1 <= _zz_62;
      ll_cmd_oh_2 <= _zz_63;
      ll_cmd_oh_3 <= _zz_64;
      if(channels_0_ll_requestLl)begin
        channels_0_ll_waitDone <= 1'b1;
        channels_0_ll_writeDone <= ll_arbiter_head;
        channels_0_ll_justASync <= ll_arbiter_isJustASink;
        channels_0_ll_packet <= 1'b0;
        channels_0_ll_requireSync <= 1'b0;
        if((! ll_arbiter_isJustASink))begin
          channels_0_ll_ptr <= channels_0_ll_ptrNext;
        end
        channels_0_ll_readDone <= ll_arbiter_isJustASink;
      end
      if(_zz_62)begin
        channels_1_ll_waitDone <= 1'b1;
        channels_1_ll_writeDone <= ll_arbiter_head;
        channels_1_ll_justASync <= ll_arbiter_isJustASink;
        channels_1_ll_packet <= 1'b0;
        channels_1_ll_requireSync <= 1'b0;
        if((! ll_arbiter_isJustASink))begin
          channels_1_ll_ptr <= channels_1_ll_ptrNext;
        end
        channels_1_ll_readDone <= ll_arbiter_isJustASink;
      end
      if(_zz_63)begin
        channels_2_ll_waitDone <= 1'b1;
        channels_2_ll_writeDone <= ll_arbiter_head;
        channels_2_ll_justASync <= ll_arbiter_isJustASink;
        channels_2_ll_packet <= 1'b0;
        channels_2_ll_requireSync <= 1'b0;
        if((! ll_arbiter_isJustASink))begin
          channels_2_ll_ptr <= channels_2_ll_ptrNext;
        end
        channels_2_ll_readDone <= ll_arbiter_isJustASink;
      end
      if(_zz_64)begin
        channels_3_ll_waitDone <= 1'b1;
        channels_3_ll_writeDone <= ll_arbiter_head;
        channels_3_ll_justASync <= ll_arbiter_isJustASink;
        channels_3_ll_packet <= 1'b0;
        channels_3_ll_requireSync <= 1'b0;
        if((! ll_arbiter_isJustASink))begin
          channels_3_ll_ptr <= channels_3_ll_ptrNext;
        end
        channels_3_ll_readDone <= ll_arbiter_isJustASink;
      end
      ll_cmd_readFired <= ll_arbiter_isJustASink;
      ll_cmd_writeFired <= ll_arbiter_head;
    end
    if((io_sgRead_cmd_valid && io_sgRead_cmd_ready))begin
      ll_cmd_readFired <= 1'b1;
    end
    if((io_sgWrite_cmd_valid && io_sgWrite_cmd_ready))begin
      ll_cmd_writeFired <= 1'b1;
    end
    if(_zz_214)begin
      if((1'b0 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_1)begin
          channels_1_push_m2b_address <= io_sgRead_rsp_payload_fragment_data[95 : 64];
        end
        if(ll_readRsp_oh_3)begin
          channels_3_push_m2b_address <= io_sgRead_rsp_payload_fragment_data[95 : 64];
        end
      end
      if((1'b1 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_0)begin
          channels_0_pop_b2m_address <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
        if(ll_readRsp_oh_2)begin
          channels_2_pop_b2m_address <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
      end
      if((1'b1 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_0)begin
          channels_0_ll_ptrNext <= io_sgRead_rsp_payload_fragment_data[95 : 64];
        end
        if(ll_readRsp_oh_1)begin
          channels_1_ll_ptrNext <= io_sgRead_rsp_payload_fragment_data[95 : 64];
        end
        if(ll_readRsp_oh_2)begin
          channels_2_ll_ptrNext <= io_sgRead_rsp_payload_fragment_data[95 : 64];
        end
        if(ll_readRsp_oh_3)begin
          channels_3_ll_ptrNext <= io_sgRead_rsp_payload_fragment_data[95 : 64];
        end
      end
      if((1'b0 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_0)begin
          channels_0_bytes <= io_sgRead_rsp_payload_fragment_data[57 : 32];
        end
        if(ll_readRsp_oh_1)begin
          channels_1_bytes <= io_sgRead_rsp_payload_fragment_data[57 : 32];
        end
        if(ll_readRsp_oh_2)begin
          channels_2_bytes <= io_sgRead_rsp_payload_fragment_data[57 : 32];
        end
        if(ll_readRsp_oh_3)begin
          channels_3_bytes <= io_sgRead_rsp_payload_fragment_data[57 : 32];
        end
      end
      if((1'b0 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_1)begin
          channels_1_pop_b2s_last <= _zz_335[0];
        end
        if(ll_readRsp_oh_3)begin
          channels_3_pop_b2s_last <= _zz_336[0];
        end
      end
      if((1'b0 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_0)begin
          channels_0_ll_gotDescriptorStall <= _zz_337[0];
        end
        if(ll_readRsp_oh_1)begin
          channels_1_ll_gotDescriptorStall <= _zz_338[0];
        end
        if(ll_readRsp_oh_2)begin
          channels_2_ll_gotDescriptorStall <= _zz_339[0];
        end
        if(ll_readRsp_oh_3)begin
          channels_3_ll_gotDescriptorStall <= _zz_340[0];
        end
      end
      if(io_sgRead_rsp_payload_last)begin
        if(ll_readRsp_oh_0)begin
          channels_0_ll_readDone <= 1'b1;
        end
        if(ll_readRsp_oh_1)begin
          channels_1_ll_readDone <= 1'b1;
        end
        if(ll_readRsp_oh_2)begin
          channels_2_ll_readDone <= 1'b1;
        end
        if(ll_readRsp_oh_3)begin
          channels_3_ll_readDone <= 1'b1;
        end
      end
    end
    if((io_sgWrite_rsp_valid && io_sgWrite_rsp_ready))begin
      if(ll_writeRsp_oh_0)begin
        channels_0_ll_writeDone <= 1'b1;
      end
      if(ll_writeRsp_oh_1)begin
        channels_1_ll_writeDone <= 1'b1;
      end
      if(ll_writeRsp_oh_2)begin
        channels_2_ll_writeDone <= 1'b1;
      end
      if(ll_writeRsp_oh_3)begin
        channels_3_ll_writeDone <= 1'b1;
      end
    end
    case(io_ctrl_PADDR)
      14'h000c : begin
        if(ctrl_doWrite)begin
          channels_0_push_memory <= _zz_401[0];
          channels_0_push_s2b_completionOnLast <= _zz_402[0];
          channels_0_push_s2b_waitFirst <= _zz_403[0];
        end
      end
      14'h0010 : begin
        if(ctrl_doWrite)begin
          channels_0_pop_b2m_address[31 : 0] <= _zz_405;
        end
      end
      14'h001c : begin
        if(ctrl_doWrite)begin
          channels_0_pop_memory <= _zz_406[0];
        end
      end
      14'h002c : begin
        if(ctrl_doWrite)begin
          channels_0_channelStop <= _zz_407[0];
          channels_0_selfRestart <= _zz_408[0];
        end
      end
      14'h0020 : begin
        if(ctrl_doWrite)begin
          channels_0_bytes <= io_ctrl_PWDATA[25 : 0];
        end
      end
      14'h0070 : begin
        if(ctrl_doWrite)begin
          channels_0_ll_ptrNext <= io_ctrl_PWDATA[31 : 0];
        end
      end
      14'h0080 : begin
        if(ctrl_doWrite)begin
          channels_1_push_m2b_address[31 : 0] <= _zz_414;
        end
      end
      14'h008c : begin
        if(ctrl_doWrite)begin
          channels_1_push_memory <= _zz_415[0];
        end
      end
      14'h0098 : begin
        if(ctrl_doWrite)begin
          channels_1_pop_b2s_portId <= io_ctrl_PWDATA[0 : 0];
          channels_1_pop_b2s_sinkId <= io_ctrl_PWDATA[19 : 16];
        end
      end
      14'h009c : begin
        if(ctrl_doWrite)begin
          channels_1_pop_memory <= _zz_416[0];
          channels_1_pop_b2s_last <= _zz_417[0];
        end
      end
      14'h00ac : begin
        if(ctrl_doWrite)begin
          channels_1_channelStop <= _zz_418[0];
          channels_1_selfRestart <= _zz_419[0];
        end
      end
      14'h00a0 : begin
        if(ctrl_doWrite)begin
          channels_1_bytes <= io_ctrl_PWDATA[25 : 0];
        end
      end
      14'h00f0 : begin
        if(ctrl_doWrite)begin
          channels_1_ll_ptrNext <= io_ctrl_PWDATA[31 : 0];
        end
      end
      14'h010c : begin
        if(ctrl_doWrite)begin
          channels_2_push_memory <= _zz_423[0];
          channels_2_push_s2b_completionOnLast <= _zz_424[0];
          channels_2_push_s2b_waitFirst <= _zz_425[0];
        end
      end
      14'h0110 : begin
        if(ctrl_doWrite)begin
          channels_2_pop_b2m_address[31 : 0] <= _zz_427;
        end
      end
      14'h011c : begin
        if(ctrl_doWrite)begin
          channels_2_pop_memory <= _zz_428[0];
        end
      end
      14'h012c : begin
        if(ctrl_doWrite)begin
          channels_2_channelStop <= _zz_429[0];
          channels_2_selfRestart <= _zz_430[0];
        end
      end
      14'h0120 : begin
        if(ctrl_doWrite)begin
          channels_2_bytes <= io_ctrl_PWDATA[25 : 0];
        end
      end
      14'h0170 : begin
        if(ctrl_doWrite)begin
          channels_2_ll_ptrNext <= io_ctrl_PWDATA[31 : 0];
        end
      end
      14'h0180 : begin
        if(ctrl_doWrite)begin
          channels_3_push_m2b_address[31 : 0] <= _zz_436;
        end
      end
      14'h018c : begin
        if(ctrl_doWrite)begin
          channels_3_push_memory <= _zz_437[0];
        end
      end
      14'h0198 : begin
        if(ctrl_doWrite)begin
          channels_3_pop_b2s_portId <= io_ctrl_PWDATA[0 : 0];
          channels_3_pop_b2s_sinkId <= io_ctrl_PWDATA[19 : 16];
        end
      end
      14'h019c : begin
        if(ctrl_doWrite)begin
          channels_3_pop_memory <= _zz_438[0];
          channels_3_pop_b2s_last <= _zz_439[0];
        end
      end
      14'h01ac : begin
        if(ctrl_doWrite)begin
          channels_3_channelStop <= _zz_440[0];
          channels_3_selfRestart <= _zz_441[0];
        end
      end
      14'h01a0 : begin
        if(ctrl_doWrite)begin
          channels_3_bytes <= io_ctrl_PWDATA[25 : 0];
        end
      end
      14'h01f0 : begin
        if(ctrl_doWrite)begin
          channels_3_ll_ptrNext <= io_ctrl_PWDATA[31 : 0];
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module dma_socRuby_BufferCC_10 (
  input      [4:0]    io_dataIn,
  output     [4:0]    io_dataOut,
  input               dat32_o_ch3_clk,
  input               dat32_o_ch3_reset
);
  (* async_reg *) reg        [4:0]    buffers_0;
  (* async_reg *) reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge dat32_o_ch3_clk) begin
    if(dat32_o_ch3_reset) begin
      buffers_0 <= 5'h0;
      buffers_1 <= 5'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

//dma_socRuby_BufferCC_4 replaced by dma_socRuby_BufferCC_4

module dma_socRuby_BufferCC_8 (
  input      [4:0]    io_dataIn,
  output     [4:0]    io_dataOut,
  input               dat64_o_ch1_clk,
  input               dat64_o_ch1_reset
);
  (* async_reg *) reg        [4:0]    buffers_0;
  (* async_reg *) reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge dat64_o_ch1_clk) begin
    if(dat64_o_ch1_reset) begin
      buffers_0 <= 5'h0;
      buffers_1 <= 5'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

//dma_socRuby_BufferCC_4 replaced by dma_socRuby_BufferCC_4

//dma_socRuby_BufferCC_4 replaced by dma_socRuby_BufferCC_4

module dma_socRuby_BufferCC_5 (
  input      [4:0]    io_dataIn,
  output     [4:0]    io_dataOut,
  input               dat32_i_ch2_clk,
  input               dat32_i_ch2_reset
);
  (* async_reg *) reg        [4:0]    buffers_0;
  (* async_reg *) reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge dat32_i_ch2_clk) begin
    if(dat32_i_ch2_reset) begin
      buffers_0 <= 5'h0;
      buffers_1 <= 5'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module dma_socRuby_BufferCC_4 (
  input      [4:0]    io_dataIn,
  output     [4:0]    io_dataOut,
  input               clk,
  input               reset
);
  (* async_reg *) reg        [4:0]    buffers_0;
  (* async_reg *) reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge clk) begin
    if(reset) begin
      buffers_0 <= 5'h0;
      buffers_1 <= 5'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module dma_socRuby_BufferCC_3 (
  input      [4:0]    io_dataIn,
  output     [4:0]    io_dataOut,
  input               dat64_i_ch0_clk,
  input               dat64_i_ch0_reset
);
  (* async_reg *) reg        [4:0]    buffers_0;
  (* async_reg *) reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge dat64_i_ch0_clk) begin
    if(dat64_i_ch0_reset) begin
      buffers_0 <= 5'h0;
      buffers_1 <= 5'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module dma_socRuby_StreamFork_2 (
  input               io_input_valid,
  output reg          io_input_ready,
  input               io_input_payload_last,
  input      [0:0]    io_input_payload_fragment_opcode,
  input      [31:0]   io_input_payload_fragment_address,
  input      [11:0]   io_input_payload_fragment_length,
  input      [127:0]  io_input_payload_fragment_data,
  input      [15:0]   io_input_payload_fragment_mask,
  output              io_outputs_0_valid,
  input               io_outputs_0_ready,
  output              io_outputs_0_payload_last,
  output     [0:0]    io_outputs_0_payload_fragment_opcode,
  output     [31:0]   io_outputs_0_payload_fragment_address,
  output     [11:0]   io_outputs_0_payload_fragment_length,
  output     [127:0]  io_outputs_0_payload_fragment_data,
  output     [15:0]   io_outputs_0_payload_fragment_mask,
  output              io_outputs_1_valid,
  input               io_outputs_1_ready,
  output              io_outputs_1_payload_last,
  output     [0:0]    io_outputs_1_payload_fragment_opcode,
  output     [31:0]   io_outputs_1_payload_fragment_address,
  output     [11:0]   io_outputs_1_payload_fragment_length,
  output     [127:0]  io_outputs_1_payload_fragment_data,
  output     [15:0]   io_outputs_1_payload_fragment_mask,
  input               clk,
  input               reset
);
  reg                 _zz_1;
  reg                 _zz_2;

  always @ (*) begin
    io_input_ready = 1'b1;
    if(((! io_outputs_0_ready) && _zz_1))begin
      io_input_ready = 1'b0;
    end
    if(((! io_outputs_1_ready) && _zz_2))begin
      io_input_ready = 1'b0;
    end
  end

  assign io_outputs_0_valid = (io_input_valid && _zz_1);
  assign io_outputs_0_payload_last = io_input_payload_last;
  assign io_outputs_0_payload_fragment_opcode = io_input_payload_fragment_opcode;
  assign io_outputs_0_payload_fragment_address = io_input_payload_fragment_address;
  assign io_outputs_0_payload_fragment_length = io_input_payload_fragment_length;
  assign io_outputs_0_payload_fragment_data = io_input_payload_fragment_data;
  assign io_outputs_0_payload_fragment_mask = io_input_payload_fragment_mask;
  assign io_outputs_1_valid = (io_input_valid && _zz_2);
  assign io_outputs_1_payload_last = io_input_payload_last;
  assign io_outputs_1_payload_fragment_opcode = io_input_payload_fragment_opcode;
  assign io_outputs_1_payload_fragment_address = io_input_payload_fragment_address;
  assign io_outputs_1_payload_fragment_length = io_input_payload_fragment_length;
  assign io_outputs_1_payload_fragment_data = io_input_payload_fragment_data;
  assign io_outputs_1_payload_fragment_mask = io_input_payload_fragment_mask;
  always @ (posedge clk) begin
    if(reset) begin
      _zz_1 <= 1'b1;
      _zz_2 <= 1'b1;
    end else begin
      if((io_outputs_0_valid && io_outputs_0_ready))begin
        _zz_1 <= 1'b0;
      end
      if((io_outputs_1_valid && io_outputs_1_ready))begin
        _zz_2 <= 1'b0;
      end
      if(io_input_ready)begin
        _zz_1 <= 1'b1;
        _zz_2 <= 1'b1;
      end
    end
  end


endmodule

module dma_socRuby_BmbContextRemover_1 (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [11:0]   io_input_cmd_payload_fragment_length,
  input      [127:0]  io_input_cmd_payload_fragment_data,
  input      [15:0]   io_input_cmd_payload_fragment_mask,
  input      [15:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [15:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [11:0]   io_output_cmd_payload_fragment_length,
  output     [127:0]  io_output_cmd_payload_fragment_data,
  output     [15:0]   io_output_cmd_payload_fragment_mask,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input               clk,
  input               reset
);
  reg                 _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                io_input_cmd_fork_io_input_ready;
  wire                io_input_cmd_fork_io_outputs_0_valid;
  wire                io_input_cmd_fork_io_outputs_0_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_0_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_address;
  wire       [11:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_length;
  wire       [127:0]  io_input_cmd_fork_io_outputs_0_payload_fragment_data;
  wire       [15:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_mask;
  wire       [15:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_1_valid;
  wire                io_input_cmd_fork_io_outputs_1_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_1_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_address;
  wire       [11:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_length;
  wire       [127:0]  io_input_cmd_fork_io_outputs_1_payload_fragment_data;
  wire       [15:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_mask;
  wire       [15:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid;
  wire       [15:0]   io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload;
  wire       [2:0]    io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_occupancy;
  wire       [2:0]    io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_availability;
  wire                _zz_5;
  reg                 io_input_cmd_fork_io_outputs_0_payload_first;
  reg                 io_input_cmd_fork_io_outputs_0_thrown_valid;
  wire                io_input_cmd_fork_io_outputs_0_thrown_ready;
  wire                io_input_cmd_fork_io_outputs_0_thrown_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_address;
  wire       [11:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_length;
  wire       [127:0]  io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_data;
  wire       [15:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_mask;
  wire       [15:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_valid;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_ready;
  wire       [15:0]   io_input_cmd_fork_io_outputs_0_thrown_translated_payload;
  wire                _zz_1;

  assign _zz_5 = (! io_input_cmd_fork_io_outputs_0_payload_first);
  dma_socRuby_StreamFork_1 io_input_cmd_fork (
    .io_input_valid                           (io_input_cmd_valid                                             ), //i
    .io_input_ready                           (io_input_cmd_fork_io_input_ready                               ), //o
    .io_input_payload_last                    (io_input_cmd_payload_last                                      ), //i
    .io_input_payload_fragment_opcode         (io_input_cmd_payload_fragment_opcode                           ), //i
    .io_input_payload_fragment_address        (io_input_cmd_payload_fragment_address[31:0]                    ), //i
    .io_input_payload_fragment_length         (io_input_cmd_payload_fragment_length[11:0]                     ), //i
    .io_input_payload_fragment_data           (io_input_cmd_payload_fragment_data[127:0]                      ), //i
    .io_input_payload_fragment_mask           (io_input_cmd_payload_fragment_mask[15:0]                       ), //i
    .io_input_payload_fragment_context        (io_input_cmd_payload_fragment_context[15:0]                    ), //i
    .io_outputs_0_valid                       (io_input_cmd_fork_io_outputs_0_valid                           ), //o
    .io_outputs_0_ready                       (_zz_2                                                          ), //i
    .io_outputs_0_payload_last                (io_input_cmd_fork_io_outputs_0_payload_last                    ), //o
    .io_outputs_0_payload_fragment_opcode     (io_input_cmd_fork_io_outputs_0_payload_fragment_opcode         ), //o
    .io_outputs_0_payload_fragment_address    (io_input_cmd_fork_io_outputs_0_payload_fragment_address[31:0]  ), //o
    .io_outputs_0_payload_fragment_length     (io_input_cmd_fork_io_outputs_0_payload_fragment_length[11:0]   ), //o
    .io_outputs_0_payload_fragment_data       (io_input_cmd_fork_io_outputs_0_payload_fragment_data[127:0]    ), //o
    .io_outputs_0_payload_fragment_mask       (io_input_cmd_fork_io_outputs_0_payload_fragment_mask[15:0]     ), //o
    .io_outputs_0_payload_fragment_context    (io_input_cmd_fork_io_outputs_0_payload_fragment_context[15:0]  ), //o
    .io_outputs_1_valid                       (io_input_cmd_fork_io_outputs_1_valid                           ), //o
    .io_outputs_1_ready                       (io_output_cmd_ready                                            ), //i
    .io_outputs_1_payload_last                (io_input_cmd_fork_io_outputs_1_payload_last                    ), //o
    .io_outputs_1_payload_fragment_opcode     (io_input_cmd_fork_io_outputs_1_payload_fragment_opcode         ), //o
    .io_outputs_1_payload_fragment_address    (io_input_cmd_fork_io_outputs_1_payload_fragment_address[31:0]  ), //o
    .io_outputs_1_payload_fragment_length     (io_input_cmd_fork_io_outputs_1_payload_fragment_length[11:0]   ), //o
    .io_outputs_1_payload_fragment_data       (io_input_cmd_fork_io_outputs_1_payload_fragment_data[127:0]    ), //o
    .io_outputs_1_payload_fragment_mask       (io_input_cmd_fork_io_outputs_1_payload_fragment_mask[15:0]     ), //o
    .io_outputs_1_payload_fragment_context    (io_input_cmd_fork_io_outputs_1_payload_fragment_context[15:0]  ), //o
    .clk                                      (clk                                                            ), //i
    .reset                                    (reset                                                          )  //i
  );
  dma_socRuby_StreamFifo_1 io_input_cmd_fork_io_outputs_0_thrown_translated_fifo (
    .io_push_valid      (io_input_cmd_fork_io_outputs_0_thrown_translated_valid                      ), //i
    .io_push_ready      (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready         ), //o
    .io_push_payload    (io_input_cmd_fork_io_outputs_0_thrown_translated_payload[15:0]              ), //i
    .io_pop_valid       (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid          ), //o
    .io_pop_ready       (_zz_3                                                                       ), //i
    .io_pop_payload     (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload[15:0]  ), //o
    .io_flush           (_zz_4                                                                       ), //i
    .io_occupancy       (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_occupancy[2:0]     ), //o
    .io_availability    (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_availability[2:0]  ), //o
    .clk                (clk                                                                         ), //i
    .reset              (reset                                                                       )  //i
  );
  assign io_input_cmd_ready = io_input_cmd_fork_io_input_ready;
  assign io_output_cmd_valid = io_input_cmd_fork_io_outputs_1_valid;
  assign io_output_cmd_payload_last = io_input_cmd_fork_io_outputs_1_payload_last;
  assign io_output_cmd_payload_fragment_opcode = io_input_cmd_fork_io_outputs_1_payload_fragment_opcode;
  assign io_output_cmd_payload_fragment_address = io_input_cmd_fork_io_outputs_1_payload_fragment_address;
  assign io_output_cmd_payload_fragment_length = io_input_cmd_fork_io_outputs_1_payload_fragment_length;
  assign io_output_cmd_payload_fragment_data = io_input_cmd_fork_io_outputs_1_payload_fragment_data;
  assign io_output_cmd_payload_fragment_mask = io_input_cmd_fork_io_outputs_1_payload_fragment_mask;
  always @ (*) begin
    io_input_cmd_fork_io_outputs_0_thrown_valid = io_input_cmd_fork_io_outputs_0_valid;
    if(_zz_5)begin
      io_input_cmd_fork_io_outputs_0_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    _zz_2 = io_input_cmd_fork_io_outputs_0_thrown_ready;
    if(_zz_5)begin
      _zz_2 = 1'b1;
    end
  end

  assign io_input_cmd_fork_io_outputs_0_thrown_payload_last = io_input_cmd_fork_io_outputs_0_payload_last;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_opcode = io_input_cmd_fork_io_outputs_0_payload_fragment_opcode;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_address = io_input_cmd_fork_io_outputs_0_payload_fragment_address;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_length = io_input_cmd_fork_io_outputs_0_payload_fragment_length;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_data = io_input_cmd_fork_io_outputs_0_payload_fragment_data;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_mask = io_input_cmd_fork_io_outputs_0_payload_fragment_mask;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_context = io_input_cmd_fork_io_outputs_0_payload_fragment_context;
  assign io_input_cmd_fork_io_outputs_0_thrown_translated_valid = io_input_cmd_fork_io_outputs_0_thrown_valid;
  assign io_input_cmd_fork_io_outputs_0_thrown_ready = io_input_cmd_fork_io_outputs_0_thrown_translated_ready;
  assign io_input_cmd_fork_io_outputs_0_thrown_translated_payload = io_input_cmd_fork_io_outputs_0_payload_fragment_context;
  assign io_input_cmd_fork_io_outputs_0_thrown_translated_ready = io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready;
  assign _zz_3 = ((io_output_rsp_valid && io_output_rsp_payload_last) && io_input_rsp_ready);
  assign _zz_1 = (! (! io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid));
  assign io_output_rsp_ready = (io_input_rsp_ready && _zz_1);
  assign io_input_rsp_valid = (io_output_rsp_valid && _zz_1);
  assign io_input_rsp_payload_last = io_output_rsp_payload_last;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_context = io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload;
  assign _zz_4 = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      io_input_cmd_fork_io_outputs_0_payload_first <= 1'b1;
    end else begin
      if((io_input_cmd_fork_io_outputs_0_valid && _zz_2))begin
        io_input_cmd_fork_io_outputs_0_payload_first <= io_input_cmd_fork_io_outputs_0_payload_last;
      end
    end
  end


endmodule

module dma_socRuby_StreamFifo_2 (
  input               io_push_valid,
  output              io_push_ready,
  input               io_push_payload_last,
  input      [0:0]    io_push_payload_fragment_opcode,
  input      [31:0]   io_push_payload_fragment_address,
  input      [11:0]   io_push_payload_fragment_length,
  input      [127:0]  io_push_payload_fragment_data,
  input      [15:0]   io_push_payload_fragment_mask,
  input      [15:0]   io_push_payload_fragment_context,
  output              io_pop_valid,
  input               io_pop_ready,
  output              io_pop_payload_last,
  output     [0:0]    io_pop_payload_fragment_opcode,
  output     [31:0]   io_pop_payload_fragment_address,
  output     [11:0]   io_pop_payload_fragment_length,
  output     [127:0]  io_pop_payload_fragment_data,
  output     [15:0]   io_pop_payload_fragment_mask,
  output     [15:0]   io_pop_payload_fragment_context,
  input               io_flush,
  output     [8:0]    io_occupancy,
  output     [8:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [205:0]  _zz_5;
  wire       [0:0]    _zz_6;
  wire       [7:0]    _zz_7;
  wire       [0:0]    _zz_8;
  wire       [7:0]    _zz_9;
  wire       [0:0]    _zz_10;
  wire       [7:0]    _zz_11;
  wire                _zz_12;
  wire       [205:0]  _zz_13;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [7:0]    logic_pushPtr_valueNext;
  reg        [7:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [7:0]    logic_popPtr_valueNext;
  reg        [7:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [205:0]  _zz_3;
  wire       [204:0]  _zz_4;
  wire       [7:0]    logic_ptrDif;
  reg [205:0] logic_ram [0:255];

  assign _zz_6 = logic_pushPtr_willIncrement;
  assign _zz_7 = {7'd0, _zz_6};
  assign _zz_8 = logic_popPtr_willIncrement;
  assign _zz_9 = {7'd0, _zz_8};
  assign _zz_10 = _zz_3[0 : 0];
  assign _zz_11 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_12 = 1'b1;
  assign _zz_13 = {{io_push_payload_fragment_context,{io_push_payload_fragment_mask,{io_push_payload_fragment_data,{io_push_payload_fragment_length,{io_push_payload_fragment_address,io_push_payload_fragment_opcode}}}}},io_push_payload_last};
  always @ (posedge clk) begin
    if(_zz_12) begin
      _zz_5 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_13;
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(logic_pushing)begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing)begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 8'hff);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_7);
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 8'h0;
    end
  end

  always @ (*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping)begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 8'hff);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_9);
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 8'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign _zz_3 = _zz_5;
  assign _zz_4 = _zz_3[205 : 1];
  assign io_pop_payload_last = _zz_10[0];
  assign io_pop_payload_fragment_opcode = _zz_4[0 : 0];
  assign io_pop_payload_fragment_address = _zz_4[32 : 1];
  assign io_pop_payload_fragment_length = _zz_4[44 : 33];
  assign io_pop_payload_fragment_data = _zz_4[172 : 45];
  assign io_pop_payload_fragment_mask = _zz_4[188 : 173];
  assign io_pop_payload_fragment_context = _zz_4[204 : 189];
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_11};
  always @ (posedge clk) begin
    if(reset) begin
      logic_pushPtr_value <= 8'h0;
      logic_popPtr_value <= 8'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_2 <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_2 <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if((logic_pushing != logic_popping))begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush)begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module dma_socRuby_BmbContextRemover (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [11:0]   io_input_cmd_payload_fragment_length,
  input      [23:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [127:0]  io_input_rsp_payload_fragment_data,
  output     [23:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [11:0]   io_output_cmd_payload_fragment_length,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [127:0]  io_output_rsp_payload_fragment_data,
  input               clk,
  input               reset
);
  reg                 _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                io_input_cmd_fork_io_input_ready;
  wire                io_input_cmd_fork_io_outputs_0_valid;
  wire                io_input_cmd_fork_io_outputs_0_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_0_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_address;
  wire       [11:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_length;
  wire       [23:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_1_valid;
  wire                io_input_cmd_fork_io_outputs_1_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_1_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_address;
  wire       [11:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_length;
  wire       [23:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid;
  wire       [23:0]   io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload;
  wire       [2:0]    io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_occupancy;
  wire       [2:0]    io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_availability;
  wire                _zz_5;
  reg                 io_input_cmd_fork_io_outputs_0_payload_first;
  reg                 io_input_cmd_fork_io_outputs_0_thrown_valid;
  wire                io_input_cmd_fork_io_outputs_0_thrown_ready;
  wire                io_input_cmd_fork_io_outputs_0_thrown_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_address;
  wire       [11:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_length;
  wire       [23:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_valid;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_ready;
  wire       [23:0]   io_input_cmd_fork_io_outputs_0_thrown_translated_payload;
  wire                _zz_1;

  assign _zz_5 = (! io_input_cmd_fork_io_outputs_0_payload_first);
  dma_socRuby_StreamFork io_input_cmd_fork (
    .io_input_valid                           (io_input_cmd_valid                                             ), //i
    .io_input_ready                           (io_input_cmd_fork_io_input_ready                               ), //o
    .io_input_payload_last                    (io_input_cmd_payload_last                                      ), //i
    .io_input_payload_fragment_opcode         (io_input_cmd_payload_fragment_opcode                           ), //i
    .io_input_payload_fragment_address        (io_input_cmd_payload_fragment_address[31:0]                    ), //i
    .io_input_payload_fragment_length         (io_input_cmd_payload_fragment_length[11:0]                     ), //i
    .io_input_payload_fragment_context        (io_input_cmd_payload_fragment_context[23:0]                    ), //i
    .io_outputs_0_valid                       (io_input_cmd_fork_io_outputs_0_valid                           ), //o
    .io_outputs_0_ready                       (_zz_2                                                          ), //i
    .io_outputs_0_payload_last                (io_input_cmd_fork_io_outputs_0_payload_last                    ), //o
    .io_outputs_0_payload_fragment_opcode     (io_input_cmd_fork_io_outputs_0_payload_fragment_opcode         ), //o
    .io_outputs_0_payload_fragment_address    (io_input_cmd_fork_io_outputs_0_payload_fragment_address[31:0]  ), //o
    .io_outputs_0_payload_fragment_length     (io_input_cmd_fork_io_outputs_0_payload_fragment_length[11:0]   ), //o
    .io_outputs_0_payload_fragment_context    (io_input_cmd_fork_io_outputs_0_payload_fragment_context[23:0]  ), //o
    .io_outputs_1_valid                       (io_input_cmd_fork_io_outputs_1_valid                           ), //o
    .io_outputs_1_ready                       (io_output_cmd_ready                                            ), //i
    .io_outputs_1_payload_last                (io_input_cmd_fork_io_outputs_1_payload_last                    ), //o
    .io_outputs_1_payload_fragment_opcode     (io_input_cmd_fork_io_outputs_1_payload_fragment_opcode         ), //o
    .io_outputs_1_payload_fragment_address    (io_input_cmd_fork_io_outputs_1_payload_fragment_address[31:0]  ), //o
    .io_outputs_1_payload_fragment_length     (io_input_cmd_fork_io_outputs_1_payload_fragment_length[11:0]   ), //o
    .io_outputs_1_payload_fragment_context    (io_input_cmd_fork_io_outputs_1_payload_fragment_context[23:0]  ), //o
    .clk                                      (clk                                                            ), //i
    .reset                                    (reset                                                          )  //i
  );
  dma_socRuby_StreamFifo io_input_cmd_fork_io_outputs_0_thrown_translated_fifo (
    .io_push_valid      (io_input_cmd_fork_io_outputs_0_thrown_translated_valid                      ), //i
    .io_push_ready      (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready         ), //o
    .io_push_payload    (io_input_cmd_fork_io_outputs_0_thrown_translated_payload[23:0]              ), //i
    .io_pop_valid       (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid          ), //o
    .io_pop_ready       (_zz_3                                                                       ), //i
    .io_pop_payload     (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload[23:0]  ), //o
    .io_flush           (_zz_4                                                                       ), //i
    .io_occupancy       (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_occupancy[2:0]     ), //o
    .io_availability    (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_availability[2:0]  ), //o
    .clk                (clk                                                                         ), //i
    .reset              (reset                                                                       )  //i
  );
  assign io_input_cmd_ready = io_input_cmd_fork_io_input_ready;
  assign io_output_cmd_valid = io_input_cmd_fork_io_outputs_1_valid;
  assign io_output_cmd_payload_last = io_input_cmd_fork_io_outputs_1_payload_last;
  assign io_output_cmd_payload_fragment_opcode = io_input_cmd_fork_io_outputs_1_payload_fragment_opcode;
  assign io_output_cmd_payload_fragment_address = io_input_cmd_fork_io_outputs_1_payload_fragment_address;
  assign io_output_cmd_payload_fragment_length = io_input_cmd_fork_io_outputs_1_payload_fragment_length;
  always @ (*) begin
    io_input_cmd_fork_io_outputs_0_thrown_valid = io_input_cmd_fork_io_outputs_0_valid;
    if(_zz_5)begin
      io_input_cmd_fork_io_outputs_0_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    _zz_2 = io_input_cmd_fork_io_outputs_0_thrown_ready;
    if(_zz_5)begin
      _zz_2 = 1'b1;
    end
  end

  assign io_input_cmd_fork_io_outputs_0_thrown_payload_last = io_input_cmd_fork_io_outputs_0_payload_last;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_opcode = io_input_cmd_fork_io_outputs_0_payload_fragment_opcode;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_address = io_input_cmd_fork_io_outputs_0_payload_fragment_address;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_length = io_input_cmd_fork_io_outputs_0_payload_fragment_length;
  assign io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_context = io_input_cmd_fork_io_outputs_0_payload_fragment_context;
  assign io_input_cmd_fork_io_outputs_0_thrown_translated_valid = io_input_cmd_fork_io_outputs_0_thrown_valid;
  assign io_input_cmd_fork_io_outputs_0_thrown_ready = io_input_cmd_fork_io_outputs_0_thrown_translated_ready;
  assign io_input_cmd_fork_io_outputs_0_thrown_translated_payload = io_input_cmd_fork_io_outputs_0_payload_fragment_context;
  assign io_input_cmd_fork_io_outputs_0_thrown_translated_ready = io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready;
  assign _zz_3 = ((io_output_rsp_valid && io_output_rsp_payload_last) && io_input_rsp_ready);
  assign _zz_1 = (! (! io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid));
  assign io_output_rsp_ready = (io_input_rsp_ready && _zz_1);
  assign io_input_rsp_valid = (io_output_rsp_valid && _zz_1);
  assign io_input_rsp_payload_last = io_output_rsp_payload_last;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_data = io_output_rsp_payload_fragment_data;
  assign io_input_rsp_payload_fragment_context = io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload;
  assign _zz_4 = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      io_input_cmd_fork_io_outputs_0_payload_first <= 1'b1;
    end else begin
      if((io_input_cmd_fork_io_outputs_0_valid && _zz_2))begin
        io_input_cmd_fork_io_outputs_0_payload_first <= io_input_cmd_fork_io_outputs_0_payload_last;
      end
    end
  end


endmodule

module dma_socRuby_StreamArbiter_1 (
  input               io_inputs_0_valid,
  output              io_inputs_0_ready,
  input               io_inputs_0_payload_last,
  input      [1:0]    io_inputs_0_payload_fragment_source,
  input      [0:0]    io_inputs_0_payload_fragment_opcode,
  input      [31:0]   io_inputs_0_payload_fragment_address,
  input      [11:0]   io_inputs_0_payload_fragment_length,
  input      [127:0]  io_inputs_0_payload_fragment_data,
  input      [15:0]   io_inputs_0_payload_fragment_mask,
  input      [13:0]   io_inputs_0_payload_fragment_context,
  input               io_inputs_1_valid,
  output              io_inputs_1_ready,
  input               io_inputs_1_payload_last,
  input      [1:0]    io_inputs_1_payload_fragment_source,
  input      [0:0]    io_inputs_1_payload_fragment_opcode,
  input      [31:0]   io_inputs_1_payload_fragment_address,
  input      [11:0]   io_inputs_1_payload_fragment_length,
  input      [127:0]  io_inputs_1_payload_fragment_data,
  input      [15:0]   io_inputs_1_payload_fragment_mask,
  input      [13:0]   io_inputs_1_payload_fragment_context,
  output              io_output_valid,
  input               io_output_ready,
  output              io_output_payload_last,
  output     [1:0]    io_output_payload_fragment_source,
  output     [0:0]    io_output_payload_fragment_opcode,
  output     [31:0]   io_output_payload_fragment_address,
  output     [11:0]   io_output_payload_fragment_length,
  output     [127:0]  io_output_payload_fragment_data,
  output     [15:0]   io_output_payload_fragment_mask,
  output     [13:0]   io_output_payload_fragment_context,
  output     [0:0]    io_chosen,
  output     [1:0]    io_chosenOH,
  input               clk,
  input               reset
);
  wire       [3:0]    _zz_6;
  wire       [1:0]    _zz_7;
  wire       [3:0]    _zz_8;
  wire       [0:0]    _zz_9;
  wire       [0:0]    _zz_10;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire       [1:0]    _zz_1;
  wire       [3:0]    _zz_2;
  wire       [3:0]    _zz_3;
  wire       [1:0]    _zz_4;
  wire                _zz_5;

  assign _zz_6 = (_zz_2 - _zz_8);
  assign _zz_7 = {maskLocked_0,maskLocked_1};
  assign _zz_8 = {2'd0, _zz_7};
  assign _zz_9 = _zz_4[0 : 0];
  assign _zz_10 = _zz_4[1 : 1];
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_1 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_2 = {_zz_1,_zz_1};
  assign _zz_3 = (_zz_2 & (~ _zz_6));
  assign _zz_4 = (_zz_3[3 : 2] | _zz_3[1 : 0]);
  assign maskProposal_0 = _zz_9[0];
  assign maskProposal_1 = _zz_10[0];
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_last = (maskRouted_0 ? io_inputs_0_payload_last : io_inputs_1_payload_last);
  assign io_output_payload_fragment_source = (maskRouted_0 ? io_inputs_0_payload_fragment_source : io_inputs_1_payload_fragment_source);
  assign io_output_payload_fragment_opcode = (maskRouted_0 ? io_inputs_0_payload_fragment_opcode : io_inputs_1_payload_fragment_opcode);
  assign io_output_payload_fragment_address = (maskRouted_0 ? io_inputs_0_payload_fragment_address : io_inputs_1_payload_fragment_address);
  assign io_output_payload_fragment_length = (maskRouted_0 ? io_inputs_0_payload_fragment_length : io_inputs_1_payload_fragment_length);
  assign io_output_payload_fragment_data = (maskRouted_0 ? io_inputs_0_payload_fragment_data : io_inputs_1_payload_fragment_data);
  assign io_output_payload_fragment_mask = (maskRouted_0 ? io_inputs_0_payload_fragment_mask : io_inputs_1_payload_fragment_mask);
  assign io_output_payload_fragment_context = (maskRouted_0 ? io_inputs_0_payload_fragment_context : io_inputs_1_payload_fragment_context);
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_5 = io_chosenOH[1];
  assign io_chosen = _zz_5;
  always @ (posedge clk) begin
    if(reset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid)begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid)begin
        locked <= 1'b1;
      end
      if(((io_output_valid && io_output_ready) && io_output_payload_last))begin
        locked <= 1'b0;
      end
    end
  end


endmodule

module dma_socRuby_StreamArbiter (
  input               io_inputs_0_valid,
  output              io_inputs_0_ready,
  input               io_inputs_0_payload_last,
  input      [1:0]    io_inputs_0_payload_fragment_source,
  input      [0:0]    io_inputs_0_payload_fragment_opcode,
  input      [31:0]   io_inputs_0_payload_fragment_address,
  input      [11:0]   io_inputs_0_payload_fragment_length,
  input      [21:0]   io_inputs_0_payload_fragment_context,
  input               io_inputs_1_valid,
  output              io_inputs_1_ready,
  input               io_inputs_1_payload_last,
  input      [1:0]    io_inputs_1_payload_fragment_source,
  input      [0:0]    io_inputs_1_payload_fragment_opcode,
  input      [31:0]   io_inputs_1_payload_fragment_address,
  input      [11:0]   io_inputs_1_payload_fragment_length,
  input      [21:0]   io_inputs_1_payload_fragment_context,
  output              io_output_valid,
  input               io_output_ready,
  output              io_output_payload_last,
  output     [1:0]    io_output_payload_fragment_source,
  output     [0:0]    io_output_payload_fragment_opcode,
  output     [31:0]   io_output_payload_fragment_address,
  output     [11:0]   io_output_payload_fragment_length,
  output     [21:0]   io_output_payload_fragment_context,
  output     [0:0]    io_chosen,
  output     [1:0]    io_chosenOH,
  input               clk,
  input               reset
);
  wire       [3:0]    _zz_6;
  wire       [1:0]    _zz_7;
  wire       [3:0]    _zz_8;
  wire       [0:0]    _zz_9;
  wire       [0:0]    _zz_10;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire       [1:0]    _zz_1;
  wire       [3:0]    _zz_2;
  wire       [3:0]    _zz_3;
  wire       [1:0]    _zz_4;
  wire                _zz_5;

  assign _zz_6 = (_zz_2 - _zz_8);
  assign _zz_7 = {maskLocked_0,maskLocked_1};
  assign _zz_8 = {2'd0, _zz_7};
  assign _zz_9 = _zz_4[0 : 0];
  assign _zz_10 = _zz_4[1 : 1];
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_1 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_2 = {_zz_1,_zz_1};
  assign _zz_3 = (_zz_2 & (~ _zz_6));
  assign _zz_4 = (_zz_3[3 : 2] | _zz_3[1 : 0]);
  assign maskProposal_0 = _zz_9[0];
  assign maskProposal_1 = _zz_10[0];
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_last = (maskRouted_0 ? io_inputs_0_payload_last : io_inputs_1_payload_last);
  assign io_output_payload_fragment_source = (maskRouted_0 ? io_inputs_0_payload_fragment_source : io_inputs_1_payload_fragment_source);
  assign io_output_payload_fragment_opcode = (maskRouted_0 ? io_inputs_0_payload_fragment_opcode : io_inputs_1_payload_fragment_opcode);
  assign io_output_payload_fragment_address = (maskRouted_0 ? io_inputs_0_payload_fragment_address : io_inputs_1_payload_fragment_address);
  assign io_output_payload_fragment_length = (maskRouted_0 ? io_inputs_0_payload_fragment_length : io_inputs_1_payload_fragment_length);
  assign io_output_payload_fragment_context = (maskRouted_0 ? io_inputs_0_payload_fragment_context : io_inputs_1_payload_fragment_context);
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_5 = io_chosenOH[1];
  assign io_chosen = _zz_5;
  always @ (posedge clk) begin
    if(reset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid)begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid)begin
        locked <= 1'b1;
      end
      if(((io_output_valid && io_output_ready) && io_output_payload_last))begin
        locked <= 1'b0;
      end
    end
  end


endmodule

module dma_socRuby_FlowCCByToggle (
  input               io_input_valid,
  input      [31:0]   io_input_payload_PRDATA,
  input               io_input_payload_PSLVERROR,
  output              io_output_valid,
  output     [31:0]   io_output_payload_PRDATA,
  output              io_output_payload_PSLVERROR,
  input               clk,
  input               reset,
  input               ctrl_clk,
  input               ctrl_reset
);
  wire                inputArea_target_buffercc_io_dataOut;
  wire                outHitSignal;
  reg                 inputArea_target;
  reg        [31:0]   inputArea_data_PRDATA;
  reg                 inputArea_data_PSLVERROR;
  wire                outputArea_target;
  reg                 outputArea_hit;
  wire                outputArea_flow_valid;
  wire       [31:0]   outputArea_flow_payload_PRDATA;
  wire                outputArea_flow_payload_PSLVERROR;
  reg                 outputArea_flow_regNext_valid;
  reg        [31:0]   outputArea_flow_regNext_payload_PRDATA;
  reg                 outputArea_flow_regNext_payload_PSLVERROR;

  dma_socRuby_BufferCC inputArea_target_buffercc (
    .io_dataIn     (inputArea_target                      ), //i
    .io_dataOut    (inputArea_target_buffercc_io_dataOut  ), //o
    .ctrl_clk      (ctrl_clk                              ), //i
    .ctrl_reset    (ctrl_reset                            )  //i
  );
  assign outputArea_target = inputArea_target_buffercc_io_dataOut;
  assign outputArea_flow_valid = (outputArea_target != outputArea_hit);
  assign outputArea_flow_payload_PRDATA = inputArea_data_PRDATA;
  assign outputArea_flow_payload_PSLVERROR = inputArea_data_PSLVERROR;
  assign io_output_valid = outputArea_flow_regNext_valid;
  assign io_output_payload_PRDATA = outputArea_flow_regNext_payload_PRDATA;
  assign io_output_payload_PSLVERROR = outputArea_flow_regNext_payload_PSLVERROR;
  always @ (posedge clk) begin
    if(reset) begin
      inputArea_target <= 1'b0;
    end else begin
      if(io_input_valid)begin
        inputArea_target <= (! inputArea_target);
      end
    end
  end

  always @ (posedge clk) begin
    if(io_input_valid)begin
      inputArea_data_PRDATA <= io_input_payload_PRDATA;
      inputArea_data_PSLVERROR <= io_input_payload_PSLVERROR;
    end
  end

  always @ (posedge ctrl_clk) begin
    if(ctrl_reset) begin
      outputArea_flow_regNext_valid <= 1'b0;
      outputArea_hit <= 1'b0;
    end else begin
      outputArea_hit <= outputArea_target;
      outputArea_flow_regNext_valid <= outputArea_flow_valid;
    end
  end

  always @ (posedge ctrl_clk) begin
    outputArea_flow_regNext_payload_PRDATA <= outputArea_flow_payload_PRDATA;
    outputArea_flow_regNext_payload_PSLVERROR <= outputArea_flow_payload_PSLVERROR;
  end


endmodule

module dma_socRuby_StreamCCByToggle (
  input               io_input_valid,
  output reg          io_input_ready,
  input      [13:0]   io_input_payload_PADDR,
  input               io_input_payload_PWRITE,
  input      [31:0]   io_input_payload_PWDATA,
  output              io_output_valid,
  input               io_output_ready,
  output     [13:0]   io_output_payload_PADDR,
  output              io_output_payload_PWRITE,
  output     [31:0]   io_output_payload_PWDATA,
  input               ctrl_clk,
  input               ctrl_reset,
  input               clk,
  input               reset
);
  wire                outHitSignal_buffercc_io_dataOut;
  wire                pushArea_target_buffercc_io_dataOut;
  wire                _zz_1;
  wire                outHitSignal;
  wire                pushArea_hit;
  reg                 pushArea_target;
  reg        [13:0]   pushArea_data_PADDR;
  reg                 pushArea_data_PWRITE;
  reg        [31:0]   pushArea_data_PWDATA;
  wire                popArea_target;
  reg                 popArea_hit;
  wire                popArea_stream_valid;
  wire                popArea_stream_ready;
  wire       [13:0]   popArea_stream_payload_PADDR;
  wire                popArea_stream_payload_PWRITE;
  wire       [31:0]   popArea_stream_payload_PWDATA;
  wire                popArea_stream_m2sPipe_valid;
  wire                popArea_stream_m2sPipe_ready;
  wire       [13:0]   popArea_stream_m2sPipe_payload_PADDR;
  wire                popArea_stream_m2sPipe_payload_PWRITE;
  wire       [31:0]   popArea_stream_m2sPipe_payload_PWDATA;
  reg                 popArea_stream_m2sPipe_rValid;
  reg        [13:0]   popArea_stream_m2sPipe_rData_PADDR;
  reg                 popArea_stream_m2sPipe_rData_PWRITE;
  reg        [31:0]   popArea_stream_m2sPipe_rData_PWDATA;

  assign _zz_1 = (io_input_valid && (pushArea_hit == pushArea_target));
  dma_socRuby_BufferCC outHitSignal_buffercc (
    .io_dataIn     (outHitSignal                      ), //i
    .io_dataOut    (outHitSignal_buffercc_io_dataOut  ), //o
    .ctrl_clk      (ctrl_clk                          ), //i
    .ctrl_reset    (ctrl_reset                        )  //i
  );
  dma_socRuby_BufferCC_1 pushArea_target_buffercc (
    .io_dataIn     (pushArea_target                      ), //i
    .io_dataOut    (pushArea_target_buffercc_io_dataOut  ), //o
    .clk           (clk                                  ), //i
    .reset         (reset                                )  //i
  );
  assign pushArea_hit = outHitSignal_buffercc_io_dataOut;
  always @ (*) begin
    io_input_ready = 1'b0;
    if(_zz_1)begin
      io_input_ready = 1'b1;
    end
  end

  assign popArea_target = pushArea_target_buffercc_io_dataOut;
  assign outHitSignal = popArea_hit;
  assign popArea_stream_valid = (popArea_target != popArea_hit);
  assign popArea_stream_payload_PADDR = pushArea_data_PADDR;
  assign popArea_stream_payload_PWRITE = pushArea_data_PWRITE;
  assign popArea_stream_payload_PWDATA = pushArea_data_PWDATA;
  assign popArea_stream_ready = ((1'b1 && (! popArea_stream_m2sPipe_valid)) || popArea_stream_m2sPipe_ready);
  assign popArea_stream_m2sPipe_valid = popArea_stream_m2sPipe_rValid;
  assign popArea_stream_m2sPipe_payload_PADDR = popArea_stream_m2sPipe_rData_PADDR;
  assign popArea_stream_m2sPipe_payload_PWRITE = popArea_stream_m2sPipe_rData_PWRITE;
  assign popArea_stream_m2sPipe_payload_PWDATA = popArea_stream_m2sPipe_rData_PWDATA;
  assign io_output_valid = popArea_stream_m2sPipe_valid;
  assign popArea_stream_m2sPipe_ready = io_output_ready;
  assign io_output_payload_PADDR = popArea_stream_m2sPipe_payload_PADDR;
  assign io_output_payload_PWRITE = popArea_stream_m2sPipe_payload_PWRITE;
  assign io_output_payload_PWDATA = popArea_stream_m2sPipe_payload_PWDATA;
  always @ (posedge ctrl_clk) begin
    if(ctrl_reset) begin
      pushArea_target <= 1'b0;
    end else begin
      if(_zz_1)begin
        pushArea_target <= (! pushArea_target);
      end
    end
  end

  always @ (posedge ctrl_clk) begin
    if(_zz_1)begin
      pushArea_data_PADDR <= io_input_payload_PADDR;
      pushArea_data_PWRITE <= io_input_payload_PWRITE;
      pushArea_data_PWDATA <= io_input_payload_PWDATA;
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      popArea_hit <= 1'b0;
      popArea_stream_m2sPipe_rValid <= 1'b0;
    end else begin
      if((popArea_stream_valid && popArea_stream_ready))begin
        popArea_hit <= (! popArea_hit);
      end
      if(popArea_stream_ready)begin
        popArea_stream_m2sPipe_rValid <= popArea_stream_valid;
      end
    end
  end

  always @ (posedge clk) begin
    if(popArea_stream_ready)begin
      popArea_stream_m2sPipe_rData_PADDR <= popArea_stream_payload_PADDR;
      popArea_stream_m2sPipe_rData_PWRITE <= popArea_stream_payload_PWRITE;
      popArea_stream_m2sPipe_rData_PWDATA <= popArea_stream_payload_PWDATA;
    end
  end


endmodule

module dma_socRuby_Aggregator (
  input               io_input_valid,
  output              io_input_ready,
  input      [127:0]  io_input_payload_data,
  input      [15:0]   io_input_payload_mask,
  output reg [127:0]  io_output_data,
  output reg [15:0]   io_output_mask,
  input               io_output_enough,
  input               io_output_consume,
  output              io_output_consumed,
  input      [3:0]    io_output_lastByteUsed,
  output     [3:0]    io_output_usedUntil,
  input               io_flush,
  input      [3:0]    io_offset,
  input      [11:0]   io_burstLength,
  input               clk,
  input               reset
);
  reg        [0:0]    _zz_428;
  reg        [1:0]    _zz_429;
  reg        [1:0]    _zz_430;
  reg        [2:0]    _zz_431;
  reg        [2:0]    _zz_432;
  reg        [2:0]    _zz_433;
  reg        [2:0]    _zz_434;
  reg        [2:0]    _zz_435;
  reg        [2:0]    _zz_436;
  reg        [2:0]    _zz_437;
  reg        [2:0]    _zz_438;
  reg        [2:0]    _zz_439;
  reg        [3:0]    _zz_440;
  reg        [3:0]    _zz_441;
  reg        [3:0]    _zz_442;
  reg        [3:0]    _zz_443;
  reg        [3:0]    _zz_444;
  reg        [3:0]    _zz_445;
  reg        [3:0]    _zz_446;
  reg        [3:0]    _zz_447;
  reg        [3:0]    _zz_448;
  reg        [3:0]    _zz_449;
  reg        [3:0]    _zz_450;
  reg        [3:0]    _zz_451;
  reg        [3:0]    _zz_452;
  reg        [3:0]    _zz_453;
  reg        [3:0]    _zz_454;
  reg        [3:0]    _zz_455;
  reg        [3:0]    _zz_456;
  reg        [3:0]    _zz_457;
  reg        [3:0]    _zz_458;
  reg        [3:0]    _zz_459;
  reg        [3:0]    _zz_460;
  reg        [3:0]    _zz_461;
  reg        [3:0]    _zz_462;
  reg        [3:0]    _zz_463;
  reg        [3:0]    _zz_464;
  reg        [3:0]    _zz_465;
  reg        [3:0]    _zz_466;
  reg        [3:0]    _zz_467;
  reg        [3:0]    _zz_468;
  reg        [3:0]    _zz_469;
  reg        [3:0]    _zz_470;
  reg        [3:0]    _zz_471;
  reg        [3:0]    _zz_472;
  reg        [4:0]    _zz_473;
  reg        [4:0]    _zz_474;
  reg        [4:0]    _zz_475;
  reg        [4:0]    _zz_476;
  reg        [4:0]    _zz_477;
  reg        [4:0]    _zz_478;
  reg        [7:0]    _zz_479;
  reg        [7:0]    _zz_480;
  reg        [7:0]    _zz_481;
  reg        [7:0]    _zz_482;
  reg        [7:0]    _zz_483;
  reg        [7:0]    _zz_484;
  reg        [7:0]    _zz_485;
  reg        [7:0]    _zz_486;
  reg        [7:0]    _zz_487;
  reg        [7:0]    _zz_488;
  reg        [7:0]    _zz_489;
  reg        [7:0]    _zz_490;
  reg        [7:0]    _zz_491;
  reg        [7:0]    _zz_492;
  reg        [7:0]    _zz_493;
  reg        [7:0]    _zz_494;
  reg        [3:0]    _zz_495;
  wire       [0:0]    _zz_496;
  wire       [2:0]    _zz_497;
  wire       [1:0]    _zz_498;
  wire       [2:0]    _zz_499;
  wire       [2:0]    _zz_500;
  wire       [0:0]    _zz_501;
  wire       [2:0]    _zz_502;
  wire       [3:0]    _zz_503;
  wire       [1:0]    _zz_504;
  wire       [2:0]    _zz_505;
  wire       [3:0]    _zz_506;
  wire       [3:0]    _zz_507;
  wire       [3:0]    _zz_508;
  wire       [0:0]    _zz_509;
  wire       [2:0]    _zz_510;
  wire       [3:0]    _zz_511;
  wire       [3:0]    _zz_512;
  wire       [1:0]    _zz_513;
  wire       [2:0]    _zz_514;
  wire       [3:0]    _zz_515;
  wire       [3:0]    _zz_516;
  wire       [3:0]    _zz_517;
  wire       [3:0]    _zz_518;
  wire       [3:0]    _zz_519;
  wire       [0:0]    _zz_520;
  wire       [2:0]    _zz_521;
  wire       [3:0]    _zz_522;
  wire       [3:0]    _zz_523;
  wire       [3:0]    _zz_524;
  wire       [1:0]    _zz_525;
  wire       [2:0]    _zz_526;
  wire       [3:0]    _zz_527;
  wire       [3:0]    _zz_528;
  wire       [3:0]    _zz_529;
  wire       [4:0]    _zz_530;
  wire       [4:0]    _zz_531;
  wire       [4:0]    _zz_532;
  wire       [4:0]    _zz_533;
  wire       [0:0]    _zz_534;
  wire       [2:0]    _zz_535;
  wire       [4:0]    _zz_536;
  wire       [12:0]   _zz_537;
  wire       [3:0]    _zz_538;
  wire       [3:0]    _zz_539;
  wire       [3:0]    _zz_540;
  wire       [3:0]    _zz_541;
  wire       [3:0]    _zz_542;
  wire       [3:0]    _zz_543;
  wire       [3:0]    _zz_544;
  wire       [12:0]   _zz_545;
  wire       [0:0]    _zz_546;
  wire       [1:0]    _zz_547;
  wire       [2:0]    _zz_548;
  wire       [2:0]    _zz_549;
  wire       [2:0]    _zz_550;
  wire       [2:0]    _zz_551;
  wire       [2:0]    _zz_552;
  wire       [2:0]    _zz_553;
  wire       [2:0]    _zz_554;
  wire       [2:0]    _zz_555;
  wire       [2:0]    _zz_556;
  wire       [2:0]    _zz_557;
  wire       [2:0]    _zz_558;
  wire       [2:0]    _zz_559;
  wire       [2:0]    _zz_560;
  wire       [2:0]    _zz_561;
  wire       [2:0]    _zz_562;
  wire       [2:0]    _zz_563;
  wire       [2:0]    _zz_564;
  wire       [2:0]    _zz_565;
  wire       [2:0]    _zz_566;
  wire       [2:0]    _zz_567;
  wire       [2:0]    _zz_568;
  wire       [2:0]    _zz_569;
  wire       [2:0]    _zz_570;
  wire       [2:0]    _zz_571;
  wire       [2:0]    _zz_572;
  wire       [2:0]    _zz_573;
  wire       [2:0]    _zz_574;
  wire       [2:0]    _zz_575;
  wire       [2:0]    _zz_576;
  wire       [2:0]    _zz_577;
  wire       [2:0]    _zz_578;
  wire       [2:0]    _zz_579;
  wire       [2:0]    _zz_580;
  wire       [2:0]    _zz_581;
  wire       [2:0]    _zz_582;
  wire       [2:0]    _zz_583;
  wire       [2:0]    _zz_584;
  wire       [2:0]    _zz_585;
  wire       [2:0]    _zz_586;
  wire       [2:0]    _zz_587;
  wire       [3:0]    _zz_588;
  wire       [0:0]    _zz_589;
  wire       [6:0]    _zz_590;
  wire       [0:0]    _zz_591;
  wire       [6:0]    _zz_592;
  wire       [0:0]    _zz_593;
  wire       [6:0]    _zz_594;
  wire       [0:0]    _zz_595;
  wire       [6:0]    _zz_596;
  wire       [0:0]    _zz_597;
  wire       [6:0]    _zz_598;
  wire       [0:0]    _zz_599;
  wire       [6:0]    _zz_600;
  wire       [0:0]    _zz_601;
  wire       [6:0]    _zz_602;
  wire       [0:0]    _zz_603;
  wire       [6:0]    _zz_604;
  wire       [0:0]    _zz_605;
  wire       [6:0]    _zz_606;
  wire       [0:0]    _zz_607;
  wire       [6:0]    _zz_608;
  wire       [0:0]    _zz_609;
  wire       [6:0]    _zz_610;
  wire       [0:0]    _zz_611;
  wire       [6:0]    _zz_612;
  wire       [0:0]    _zz_613;
  wire       [6:0]    _zz_614;
  wire       [0:0]    _zz_615;
  wire       [6:0]    _zz_616;
  wire       [0:0]    _zz_617;
  wire       [6:0]    _zz_618;
  wire       [0:0]    _zz_619;
  wire       [6:0]    _zz_620;
  wire                s0_input_valid;
  wire                s0_input_ready;
  wire       [127:0]  s0_input_payload_data;
  wire       [15:0]   s0_input_payload_mask;
  reg                 io_input_m2sPipe_rValid;
  reg        [127:0]  io_input_m2sPipe_rData_data;
  reg        [15:0]   io_input_m2sPipe_rData_mask;
  wire                _zz_1;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  wire                _zz_6;
  wire                _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  wire                _zz_12;
  wire                _zz_13;
  wire                _zz_14;
  wire                _zz_15;
  wire       [0:0]    s0_countOnesLogic_0;
  wire       [1:0]    s0_countOnesLogic_1;
  wire       [1:0]    s0_countOnesLogic_2;
  wire       [2:0]    _zz_16;
  wire       [2:0]    _zz_17;
  wire       [2:0]    _zz_18;
  wire       [2:0]    _zz_19;
  wire       [2:0]    _zz_20;
  wire       [2:0]    _zz_21;
  wire       [2:0]    _zz_22;
  wire       [2:0]    _zz_23;
  wire       [2:0]    s0_countOnesLogic_3;
  wire       [2:0]    _zz_24;
  wire       [2:0]    _zz_25;
  wire       [2:0]    _zz_26;
  wire       [2:0]    _zz_27;
  wire       [2:0]    _zz_28;
  wire       [2:0]    _zz_29;
  wire       [2:0]    _zz_30;
  wire       [2:0]    _zz_31;
  wire       [2:0]    s0_countOnesLogic_4;
  wire       [2:0]    _zz_32;
  wire       [2:0]    _zz_33;
  wire       [2:0]    _zz_34;
  wire       [2:0]    _zz_35;
  wire       [2:0]    _zz_36;
  wire       [2:0]    _zz_37;
  wire       [2:0]    _zz_38;
  wire       [2:0]    _zz_39;
  wire       [2:0]    s0_countOnesLogic_5;
  wire       [2:0]    _zz_40;
  wire       [2:0]    _zz_41;
  wire       [2:0]    _zz_42;
  wire       [2:0]    _zz_43;
  wire       [2:0]    _zz_44;
  wire       [2:0]    _zz_45;
  wire       [2:0]    _zz_46;
  wire       [2:0]    _zz_47;
  wire       [2:0]    s0_countOnesLogic_6;
  wire       [3:0]    _zz_48;
  wire       [3:0]    _zz_49;
  wire       [3:0]    _zz_50;
  wire       [3:0]    _zz_51;
  wire       [3:0]    _zz_52;
  wire       [3:0]    _zz_53;
  wire       [3:0]    _zz_54;
  wire       [3:0]    _zz_55;
  wire       [3:0]    s0_countOnesLogic_7;
  wire       [3:0]    _zz_56;
  wire       [3:0]    _zz_57;
  wire       [3:0]    _zz_58;
  wire       [3:0]    _zz_59;
  wire       [3:0]    _zz_60;
  wire       [3:0]    _zz_61;
  wire       [3:0]    _zz_62;
  wire       [3:0]    _zz_63;
  wire       [3:0]    s0_countOnesLogic_8;
  wire       [3:0]    _zz_64;
  wire       [3:0]    _zz_65;
  wire       [3:0]    _zz_66;
  wire       [3:0]    _zz_67;
  wire       [3:0]    _zz_68;
  wire       [3:0]    _zz_69;
  wire       [3:0]    _zz_70;
  wire       [3:0]    _zz_71;
  wire       [3:0]    s0_countOnesLogic_9;
  wire       [3:0]    _zz_72;
  wire       [3:0]    _zz_73;
  wire       [3:0]    _zz_74;
  wire       [3:0]    _zz_75;
  wire       [3:0]    _zz_76;
  wire       [3:0]    _zz_77;
  wire       [3:0]    _zz_78;
  wire       [3:0]    _zz_79;
  wire       [3:0]    s0_countOnesLogic_10;
  wire       [3:0]    _zz_80;
  wire       [3:0]    _zz_81;
  wire       [3:0]    _zz_82;
  wire       [3:0]    _zz_83;
  wire       [3:0]    _zz_84;
  wire       [3:0]    _zz_85;
  wire       [3:0]    _zz_86;
  wire       [3:0]    _zz_87;
  wire       [3:0]    s0_countOnesLogic_11;
  wire       [3:0]    _zz_88;
  wire       [3:0]    _zz_89;
  wire       [3:0]    _zz_90;
  wire       [3:0]    _zz_91;
  wire       [3:0]    _zz_92;
  wire       [3:0]    _zz_93;
  wire       [3:0]    _zz_94;
  wire       [3:0]    _zz_95;
  wire       [3:0]    s0_countOnesLogic_12;
  wire       [3:0]    _zz_96;
  wire       [3:0]    _zz_97;
  wire       [3:0]    _zz_98;
  wire       [3:0]    _zz_99;
  wire       [3:0]    _zz_100;
  wire       [3:0]    _zz_101;
  wire       [3:0]    _zz_102;
  wire       [3:0]    _zz_103;
  wire       [3:0]    s0_countOnesLogic_13;
  wire       [3:0]    _zz_104;
  wire       [3:0]    _zz_105;
  wire       [3:0]    _zz_106;
  wire       [3:0]    _zz_107;
  wire       [3:0]    _zz_108;
  wire       [3:0]    _zz_109;
  wire       [3:0]    _zz_110;
  wire       [3:0]    _zz_111;
  wire       [3:0]    s0_countOnesLogic_14;
  wire       [4:0]    _zz_112;
  wire       [4:0]    _zz_113;
  wire       [4:0]    _zz_114;
  wire       [4:0]    _zz_115;
  wire       [4:0]    _zz_116;
  wire       [4:0]    _zz_117;
  wire       [4:0]    _zz_118;
  wire       [4:0]    _zz_119;
  wire       [4:0]    s0_countOnesLogic_15;
  wire       [127:0]  s0_outputPayload_cmd_data;
  wire       [15:0]   s0_outputPayload_cmd_mask;
  wire       [0:0]    s0_outputPayload_countOnes_0;
  wire       [1:0]    s0_outputPayload_countOnes_1;
  wire       [1:0]    s0_outputPayload_countOnes_2;
  wire       [2:0]    s0_outputPayload_countOnes_3;
  wire       [2:0]    s0_outputPayload_countOnes_4;
  wire       [2:0]    s0_outputPayload_countOnes_5;
  wire       [2:0]    s0_outputPayload_countOnes_6;
  wire       [3:0]    s0_outputPayload_countOnes_7;
  wire       [3:0]    s0_outputPayload_countOnes_8;
  wire       [3:0]    s0_outputPayload_countOnes_9;
  wire       [3:0]    s0_outputPayload_countOnes_10;
  wire       [3:0]    s0_outputPayload_countOnes_11;
  wire       [3:0]    s0_outputPayload_countOnes_12;
  wire       [3:0]    s0_outputPayload_countOnes_13;
  wire       [3:0]    s0_outputPayload_countOnes_14;
  wire       [4:0]    s0_outputPayload_countOnes_15;
  wire                s0_output_valid;
  wire                s0_output_ready;
  wire       [127:0]  s0_output_payload_cmd_data;
  wire       [15:0]   s0_output_payload_cmd_mask;
  wire       [0:0]    s0_output_payload_countOnes_0;
  wire       [1:0]    s0_output_payload_countOnes_1;
  wire       [1:0]    s0_output_payload_countOnes_2;
  wire       [2:0]    s0_output_payload_countOnes_3;
  wire       [2:0]    s0_output_payload_countOnes_4;
  wire       [2:0]    s0_output_payload_countOnes_5;
  wire       [2:0]    s0_output_payload_countOnes_6;
  wire       [3:0]    s0_output_payload_countOnes_7;
  wire       [3:0]    s0_output_payload_countOnes_8;
  wire       [3:0]    s0_output_payload_countOnes_9;
  wire       [3:0]    s0_output_payload_countOnes_10;
  wire       [3:0]    s0_output_payload_countOnes_11;
  wire       [3:0]    s0_output_payload_countOnes_12;
  wire       [3:0]    s0_output_payload_countOnes_13;
  wire       [3:0]    s0_output_payload_countOnes_14;
  wire       [4:0]    s0_output_payload_countOnes_15;
  wire                s1_input_valid;
  wire                s1_input_ready;
  wire       [127:0]  s1_input_payload_cmd_data;
  wire       [15:0]   s1_input_payload_cmd_mask;
  wire       [0:0]    s1_input_payload_countOnes_0;
  wire       [1:0]    s1_input_payload_countOnes_1;
  wire       [1:0]    s1_input_payload_countOnes_2;
  wire       [2:0]    s1_input_payload_countOnes_3;
  wire       [2:0]    s1_input_payload_countOnes_4;
  wire       [2:0]    s1_input_payload_countOnes_5;
  wire       [2:0]    s1_input_payload_countOnes_6;
  wire       [3:0]    s1_input_payload_countOnes_7;
  wire       [3:0]    s1_input_payload_countOnes_8;
  wire       [3:0]    s1_input_payload_countOnes_9;
  wire       [3:0]    s1_input_payload_countOnes_10;
  wire       [3:0]    s1_input_payload_countOnes_11;
  wire       [3:0]    s1_input_payload_countOnes_12;
  wire       [3:0]    s1_input_payload_countOnes_13;
  wire       [3:0]    s1_input_payload_countOnes_14;
  wire       [4:0]    s1_input_payload_countOnes_15;
  reg                 s0_output_m2sPipe_rValid;
  reg        [127:0]  s0_output_m2sPipe_rData_cmd_data;
  reg        [15:0]   s0_output_m2sPipe_rData_cmd_mask;
  reg        [0:0]    s0_output_m2sPipe_rData_countOnes_0;
  reg        [1:0]    s0_output_m2sPipe_rData_countOnes_1;
  reg        [1:0]    s0_output_m2sPipe_rData_countOnes_2;
  reg        [2:0]    s0_output_m2sPipe_rData_countOnes_3;
  reg        [2:0]    s0_output_m2sPipe_rData_countOnes_4;
  reg        [2:0]    s0_output_m2sPipe_rData_countOnes_5;
  reg        [2:0]    s0_output_m2sPipe_rData_countOnes_6;
  reg        [3:0]    s0_output_m2sPipe_rData_countOnes_7;
  reg        [3:0]    s0_output_m2sPipe_rData_countOnes_8;
  reg        [3:0]    s0_output_m2sPipe_rData_countOnes_9;
  reg        [3:0]    s0_output_m2sPipe_rData_countOnes_10;
  reg        [3:0]    s0_output_m2sPipe_rData_countOnes_11;
  reg        [3:0]    s0_output_m2sPipe_rData_countOnes_12;
  reg        [3:0]    s0_output_m2sPipe_rData_countOnes_13;
  reg        [3:0]    s0_output_m2sPipe_rData_countOnes_14;
  reg        [4:0]    s0_output_m2sPipe_rData_countOnes_15;
  reg        [3:0]    s1_offset;
  wire       [4:0]    s1_offsetNext;
  reg        [12:0]   s1_byteCounter;
  wire       [3:0]    s1_inputIndexes_0;
  wire       [3:0]    s1_inputIndexes_1;
  wire       [3:0]    s1_inputIndexes_2;
  wire       [3:0]    s1_inputIndexes_3;
  wire       [3:0]    s1_inputIndexes_4;
  wire       [3:0]    s1_inputIndexes_5;
  wire       [3:0]    s1_inputIndexes_6;
  wire       [3:0]    s1_inputIndexes_7;
  wire       [3:0]    s1_inputIndexes_8;
  wire       [3:0]    s1_inputIndexes_9;
  wire       [3:0]    s1_inputIndexes_10;
  wire       [3:0]    s1_inputIndexes_11;
  wire       [3:0]    s1_inputIndexes_12;
  wire       [3:0]    s1_inputIndexes_13;
  wire       [3:0]    s1_inputIndexes_14;
  wire       [3:0]    s1_inputIndexes_15;
  wire       [127:0]  s1_outputPayload_cmd_data;
  wire       [15:0]   s1_outputPayload_cmd_mask;
  wire       [3:0]    s1_outputPayload_index_0;
  wire       [3:0]    s1_outputPayload_index_1;
  wire       [3:0]    s1_outputPayload_index_2;
  wire       [3:0]    s1_outputPayload_index_3;
  wire       [3:0]    s1_outputPayload_index_4;
  wire       [3:0]    s1_outputPayload_index_5;
  wire       [3:0]    s1_outputPayload_index_6;
  wire       [3:0]    s1_outputPayload_index_7;
  wire       [3:0]    s1_outputPayload_index_8;
  wire       [3:0]    s1_outputPayload_index_9;
  wire       [3:0]    s1_outputPayload_index_10;
  wire       [3:0]    s1_outputPayload_index_11;
  wire       [3:0]    s1_outputPayload_index_12;
  wire       [3:0]    s1_outputPayload_index_13;
  wire       [3:0]    s1_outputPayload_index_14;
  wire       [3:0]    s1_outputPayload_index_15;
  wire                s1_outputPayload_last;
  wire       [3:0]    s1_outputPayload_sel_0;
  wire       [3:0]    s1_outputPayload_sel_1;
  wire       [3:0]    s1_outputPayload_sel_2;
  wire       [3:0]    s1_outputPayload_sel_3;
  wire       [3:0]    s1_outputPayload_sel_4;
  wire       [3:0]    s1_outputPayload_sel_5;
  wire       [3:0]    s1_outputPayload_sel_6;
  wire       [3:0]    s1_outputPayload_sel_7;
  wire       [3:0]    s1_outputPayload_sel_8;
  wire       [3:0]    s1_outputPayload_sel_9;
  wire       [3:0]    s1_outputPayload_sel_10;
  wire       [3:0]    s1_outputPayload_sel_11;
  wire       [3:0]    s1_outputPayload_sel_12;
  wire       [3:0]    s1_outputPayload_sel_13;
  wire       [3:0]    s1_outputPayload_sel_14;
  wire       [3:0]    s1_outputPayload_sel_15;
  reg        [15:0]   s1_outputPayload_selValid;
  wire                _zz_120;
  wire                _zz_121;
  wire                _zz_122;
  wire                _zz_123;
  wire                _zz_124;
  wire                _zz_125;
  wire                _zz_126;
  wire                _zz_127;
  wire                _zz_128;
  wire                _zz_129;
  wire                _zz_130;
  wire                _zz_131;
  wire                _zz_132;
  wire                _zz_133;
  wire                _zz_134;
  wire                _zz_135;
  wire                _zz_136;
  wire                _zz_137;
  wire                _zz_138;
  wire                _zz_139;
  wire                _zz_140;
  wire                _zz_141;
  wire                _zz_142;
  wire                _zz_143;
  wire                _zz_144;
  wire                _zz_145;
  wire                _zz_146;
  wire                _zz_147;
  wire                _zz_148;
  wire                _zz_149;
  wire                _zz_150;
  wire                _zz_151;
  wire                _zz_152;
  wire                _zz_153;
  wire                _zz_154;
  wire                _zz_155;
  wire                _zz_156;
  wire                _zz_157;
  wire                _zz_158;
  wire                _zz_159;
  wire                _zz_160;
  wire                _zz_161;
  wire                _zz_162;
  wire                _zz_163;
  wire                _zz_164;
  wire                _zz_165;
  wire                _zz_166;
  wire                _zz_167;
  wire                _zz_168;
  wire                _zz_169;
  wire                _zz_170;
  wire                _zz_171;
  wire                _zz_172;
  wire                _zz_173;
  wire                _zz_174;
  wire                _zz_175;
  wire                _zz_176;
  wire                _zz_177;
  wire                _zz_178;
  wire                _zz_179;
  wire                _zz_180;
  wire                _zz_181;
  wire                _zz_182;
  wire                _zz_183;
  wire                _zz_184;
  wire                _zz_185;
  wire                _zz_186;
  wire                _zz_187;
  wire                _zz_188;
  wire                _zz_189;
  wire                _zz_190;
  wire                _zz_191;
  wire                _zz_192;
  wire                _zz_193;
  wire                _zz_194;
  wire                _zz_195;
  wire                _zz_196;
  wire                _zz_197;
  wire                _zz_198;
  wire                _zz_199;
  wire                _zz_200;
  wire                _zz_201;
  wire                _zz_202;
  wire                _zz_203;
  wire                _zz_204;
  wire                _zz_205;
  wire                _zz_206;
  wire                _zz_207;
  wire                _zz_208;
  wire                _zz_209;
  wire                _zz_210;
  wire                _zz_211;
  wire                _zz_212;
  wire                _zz_213;
  wire                _zz_214;
  wire                _zz_215;
  wire                _zz_216;
  wire                _zz_217;
  wire                _zz_218;
  wire                _zz_219;
  wire                _zz_220;
  wire                _zz_221;
  wire                _zz_222;
  wire                _zz_223;
  wire                _zz_224;
  wire                _zz_225;
  wire                _zz_226;
  wire                _zz_227;
  wire                _zz_228;
  wire                _zz_229;
  wire                _zz_230;
  wire                _zz_231;
  wire                _zz_232;
  wire                _zz_233;
  wire                _zz_234;
  wire                _zz_235;
  wire                _zz_236;
  wire                _zz_237;
  wire                _zz_238;
  wire                _zz_239;
  wire                _zz_240;
  wire                _zz_241;
  wire                _zz_242;
  wire                _zz_243;
  wire                _zz_244;
  wire                _zz_245;
  wire                _zz_246;
  wire                _zz_247;
  wire                _zz_248;
  wire                _zz_249;
  wire                _zz_250;
  wire                _zz_251;
  wire                _zz_252;
  wire                _zz_253;
  wire                _zz_254;
  wire                _zz_255;
  wire                _zz_256;
  wire                _zz_257;
  wire                _zz_258;
  wire                _zz_259;
  wire                _zz_260;
  wire                _zz_261;
  wire                _zz_262;
  wire                _zz_263;
  wire                _zz_264;
  wire                _zz_265;
  wire                _zz_266;
  wire                _zz_267;
  wire                _zz_268;
  wire                _zz_269;
  wire                _zz_270;
  wire                _zz_271;
  wire                _zz_272;
  wire                _zz_273;
  wire                _zz_274;
  wire                _zz_275;
  wire                _zz_276;
  wire                _zz_277;
  wire                _zz_278;
  wire                _zz_279;
  wire                _zz_280;
  wire                _zz_281;
  wire                _zz_282;
  wire                _zz_283;
  wire                _zz_284;
  wire                _zz_285;
  wire                _zz_286;
  wire                _zz_287;
  wire                _zz_288;
  wire                _zz_289;
  wire                _zz_290;
  wire                _zz_291;
  wire                _zz_292;
  wire                _zz_293;
  wire                _zz_294;
  wire                _zz_295;
  wire                _zz_296;
  wire                _zz_297;
  wire                _zz_298;
  wire                _zz_299;
  wire                _zz_300;
  wire                _zz_301;
  wire                _zz_302;
  wire                _zz_303;
  wire                _zz_304;
  wire                _zz_305;
  wire                _zz_306;
  wire                _zz_307;
  wire                _zz_308;
  wire                _zz_309;
  wire                _zz_310;
  wire                _zz_311;
  wire                _zz_312;
  wire                _zz_313;
  wire                _zz_314;
  wire                _zz_315;
  wire                _zz_316;
  wire                _zz_317;
  wire                _zz_318;
  wire                _zz_319;
  wire                _zz_320;
  wire                _zz_321;
  wire                _zz_322;
  wire                _zz_323;
  wire                _zz_324;
  wire                _zz_325;
  wire                _zz_326;
  wire                _zz_327;
  wire                _zz_328;
  wire                _zz_329;
  wire                _zz_330;
  wire                _zz_331;
  wire                _zz_332;
  wire                _zz_333;
  wire                _zz_334;
  wire                _zz_335;
  wire                _zz_336;
  wire                _zz_337;
  wire                _zz_338;
  wire                _zz_339;
  wire                _zz_340;
  wire                _zz_341;
  wire                _zz_342;
  wire                _zz_343;
  wire                _zz_344;
  wire                _zz_345;
  wire                _zz_346;
  wire                _zz_347;
  wire                _zz_348;
  wire                _zz_349;
  wire                _zz_350;
  wire                _zz_351;
  wire                _zz_352;
  wire                _zz_353;
  wire                _zz_354;
  wire                _zz_355;
  wire                _zz_356;
  wire                _zz_357;
  wire                _zz_358;
  wire                _zz_359;
  wire                _zz_360;
  wire                _zz_361;
  wire                _zz_362;
  wire                _zz_363;
  wire                _zz_364;
  wire                _zz_365;
  wire                _zz_366;
  wire                _zz_367;
  wire                _zz_368;
  wire                _zz_369;
  wire                _zz_370;
  wire                _zz_371;
  wire                _zz_372;
  wire                _zz_373;
  wire                _zz_374;
  wire                _zz_375;
  wire                _zz_376;
  wire                _zz_377;
  wire                _zz_378;
  wire                _zz_379;
  wire                _zz_380;
  wire                _zz_381;
  wire                _zz_382;
  wire                _zz_383;
  wire                _zz_384;
  wire                _zz_385;
  wire                _zz_386;
  wire                _zz_387;
  wire                _zz_388;
  wire                _zz_389;
  wire                _zz_390;
  wire                _zz_391;
  wire                _zz_392;
  wire                _zz_393;
  wire                _zz_394;
  wire                _zz_395;
  wire                _zz_396;
  wire                _zz_397;
  wire                _zz_398;
  wire                _zz_399;
  wire                _zz_400;
  wire                _zz_401;
  wire                _zz_402;
  wire                _zz_403;
  wire                _zz_404;
  wire                _zz_405;
  wire                _zz_406;
  wire                _zz_407;
  wire                _zz_408;
  wire                _zz_409;
  wire                _zz_410;
  wire                _zz_411;
  wire                _zz_412;
  wire                _zz_413;
  wire                _zz_414;
  wire                _zz_415;
  wire                _zz_416;
  wire                _zz_417;
  wire                _zz_418;
  wire                _zz_419;
  wire                _zz_420;
  wire                _zz_421;
  wire                _zz_422;
  wire                _zz_423;
  wire                s1_output_valid;
  wire                s1_output_ready;
  wire       [127:0]  s1_output_payload_cmd_data;
  wire       [15:0]   s1_output_payload_cmd_mask;
  wire       [3:0]    s1_output_payload_index_0;
  wire       [3:0]    s1_output_payload_index_1;
  wire       [3:0]    s1_output_payload_index_2;
  wire       [3:0]    s1_output_payload_index_3;
  wire       [3:0]    s1_output_payload_index_4;
  wire       [3:0]    s1_output_payload_index_5;
  wire       [3:0]    s1_output_payload_index_6;
  wire       [3:0]    s1_output_payload_index_7;
  wire       [3:0]    s1_output_payload_index_8;
  wire       [3:0]    s1_output_payload_index_9;
  wire       [3:0]    s1_output_payload_index_10;
  wire       [3:0]    s1_output_payload_index_11;
  wire       [3:0]    s1_output_payload_index_12;
  wire       [3:0]    s1_output_payload_index_13;
  wire       [3:0]    s1_output_payload_index_14;
  wire       [3:0]    s1_output_payload_index_15;
  wire                s1_output_payload_last;
  wire       [3:0]    s1_output_payload_sel_0;
  wire       [3:0]    s1_output_payload_sel_1;
  wire       [3:0]    s1_output_payload_sel_2;
  wire       [3:0]    s1_output_payload_sel_3;
  wire       [3:0]    s1_output_payload_sel_4;
  wire       [3:0]    s1_output_payload_sel_5;
  wire       [3:0]    s1_output_payload_sel_6;
  wire       [3:0]    s1_output_payload_sel_7;
  wire       [3:0]    s1_output_payload_sel_8;
  wire       [3:0]    s1_output_payload_sel_9;
  wire       [3:0]    s1_output_payload_sel_10;
  wire       [3:0]    s1_output_payload_sel_11;
  wire       [3:0]    s1_output_payload_sel_12;
  wire       [3:0]    s1_output_payload_sel_13;
  wire       [3:0]    s1_output_payload_sel_14;
  wire       [3:0]    s1_output_payload_sel_15;
  wire       [15:0]   s1_output_payload_selValid;
  wire                s2_input_valid;
  reg                 s2_input_ready;
  wire       [127:0]  s2_input_payload_cmd_data;
  wire       [15:0]   s2_input_payload_cmd_mask;
  wire       [3:0]    s2_input_payload_index_0;
  wire       [3:0]    s2_input_payload_index_1;
  wire       [3:0]    s2_input_payload_index_2;
  wire       [3:0]    s2_input_payload_index_3;
  wire       [3:0]    s2_input_payload_index_4;
  wire       [3:0]    s2_input_payload_index_5;
  wire       [3:0]    s2_input_payload_index_6;
  wire       [3:0]    s2_input_payload_index_7;
  wire       [3:0]    s2_input_payload_index_8;
  wire       [3:0]    s2_input_payload_index_9;
  wire       [3:0]    s2_input_payload_index_10;
  wire       [3:0]    s2_input_payload_index_11;
  wire       [3:0]    s2_input_payload_index_12;
  wire       [3:0]    s2_input_payload_index_13;
  wire       [3:0]    s2_input_payload_index_14;
  wire       [3:0]    s2_input_payload_index_15;
  wire                s2_input_payload_last;
  wire       [3:0]    s2_input_payload_sel_0;
  wire       [3:0]    s2_input_payload_sel_1;
  wire       [3:0]    s2_input_payload_sel_2;
  wire       [3:0]    s2_input_payload_sel_3;
  wire       [3:0]    s2_input_payload_sel_4;
  wire       [3:0]    s2_input_payload_sel_5;
  wire       [3:0]    s2_input_payload_sel_6;
  wire       [3:0]    s2_input_payload_sel_7;
  wire       [3:0]    s2_input_payload_sel_8;
  wire       [3:0]    s2_input_payload_sel_9;
  wire       [3:0]    s2_input_payload_sel_10;
  wire       [3:0]    s2_input_payload_sel_11;
  wire       [3:0]    s2_input_payload_sel_12;
  wire       [3:0]    s2_input_payload_sel_13;
  wire       [3:0]    s2_input_payload_sel_14;
  wire       [3:0]    s2_input_payload_sel_15;
  wire       [15:0]   s2_input_payload_selValid;
  reg                 s1_output_m2sPipe_rValid;
  reg        [127:0]  s1_output_m2sPipe_rData_cmd_data;
  reg        [15:0]   s1_output_m2sPipe_rData_cmd_mask;
  reg        [3:0]    s1_output_m2sPipe_rData_index_0;
  reg        [3:0]    s1_output_m2sPipe_rData_index_1;
  reg        [3:0]    s1_output_m2sPipe_rData_index_2;
  reg        [3:0]    s1_output_m2sPipe_rData_index_3;
  reg        [3:0]    s1_output_m2sPipe_rData_index_4;
  reg        [3:0]    s1_output_m2sPipe_rData_index_5;
  reg        [3:0]    s1_output_m2sPipe_rData_index_6;
  reg        [3:0]    s1_output_m2sPipe_rData_index_7;
  reg        [3:0]    s1_output_m2sPipe_rData_index_8;
  reg        [3:0]    s1_output_m2sPipe_rData_index_9;
  reg        [3:0]    s1_output_m2sPipe_rData_index_10;
  reg        [3:0]    s1_output_m2sPipe_rData_index_11;
  reg        [3:0]    s1_output_m2sPipe_rData_index_12;
  reg        [3:0]    s1_output_m2sPipe_rData_index_13;
  reg        [3:0]    s1_output_m2sPipe_rData_index_14;
  reg        [3:0]    s1_output_m2sPipe_rData_index_15;
  reg                 s1_output_m2sPipe_rData_last;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_0;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_1;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_2;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_3;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_4;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_5;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_6;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_7;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_8;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_9;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_10;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_11;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_12;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_13;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_14;
  reg        [3:0]    s1_output_m2sPipe_rData_sel_15;
  reg        [15:0]   s1_output_m2sPipe_rData_selValid;
  wire       [7:0]    s2_inputDataBytes_0;
  wire       [7:0]    s2_inputDataBytes_1;
  wire       [7:0]    s2_inputDataBytes_2;
  wire       [7:0]    s2_inputDataBytes_3;
  wire       [7:0]    s2_inputDataBytes_4;
  wire       [7:0]    s2_inputDataBytes_5;
  wire       [7:0]    s2_inputDataBytes_6;
  wire       [7:0]    s2_inputDataBytes_7;
  wire       [7:0]    s2_inputDataBytes_8;
  wire       [7:0]    s2_inputDataBytes_9;
  wire       [7:0]    s2_inputDataBytes_10;
  wire       [7:0]    s2_inputDataBytes_11;
  wire       [7:0]    s2_inputDataBytes_12;
  wire       [7:0]    s2_inputDataBytes_13;
  wire       [7:0]    s2_inputDataBytes_14;
  wire       [7:0]    s2_inputDataBytes_15;
  reg                 s2_byteLogic_0_buffer_valid;
  reg        [7:0]    s2_byteLogic_0_buffer_data;
  wire                s2_byteLogic_0_lastUsed;
  wire                s2_byteLogic_0_inputMask;
  wire       [7:0]    s2_byteLogic_0_inputData;
  wire                s2_byteLogic_0_outputMask;
  wire       [7:0]    s2_byteLogic_0_outputData;
  reg                 s2_byteLogic_1_buffer_valid;
  reg        [7:0]    s2_byteLogic_1_buffer_data;
  wire                s2_byteLogic_1_lastUsed;
  wire                s2_byteLogic_1_inputMask;
  wire       [7:0]    s2_byteLogic_1_inputData;
  wire                s2_byteLogic_1_outputMask;
  wire       [7:0]    s2_byteLogic_1_outputData;
  reg                 s2_byteLogic_2_buffer_valid;
  reg        [7:0]    s2_byteLogic_2_buffer_data;
  wire                s2_byteLogic_2_lastUsed;
  wire                s2_byteLogic_2_inputMask;
  wire       [7:0]    s2_byteLogic_2_inputData;
  wire                s2_byteLogic_2_outputMask;
  wire       [7:0]    s2_byteLogic_2_outputData;
  reg                 s2_byteLogic_3_buffer_valid;
  reg        [7:0]    s2_byteLogic_3_buffer_data;
  wire                s2_byteLogic_3_lastUsed;
  wire                s2_byteLogic_3_inputMask;
  wire       [7:0]    s2_byteLogic_3_inputData;
  wire                s2_byteLogic_3_outputMask;
  wire       [7:0]    s2_byteLogic_3_outputData;
  reg                 s2_byteLogic_4_buffer_valid;
  reg        [7:0]    s2_byteLogic_4_buffer_data;
  wire                s2_byteLogic_4_lastUsed;
  wire                s2_byteLogic_4_inputMask;
  wire       [7:0]    s2_byteLogic_4_inputData;
  wire                s2_byteLogic_4_outputMask;
  wire       [7:0]    s2_byteLogic_4_outputData;
  reg                 s2_byteLogic_5_buffer_valid;
  reg        [7:0]    s2_byteLogic_5_buffer_data;
  wire                s2_byteLogic_5_lastUsed;
  wire                s2_byteLogic_5_inputMask;
  wire       [7:0]    s2_byteLogic_5_inputData;
  wire                s2_byteLogic_5_outputMask;
  wire       [7:0]    s2_byteLogic_5_outputData;
  reg                 s2_byteLogic_6_buffer_valid;
  reg        [7:0]    s2_byteLogic_6_buffer_data;
  wire                s2_byteLogic_6_lastUsed;
  wire                s2_byteLogic_6_inputMask;
  wire       [7:0]    s2_byteLogic_6_inputData;
  wire                s2_byteLogic_6_outputMask;
  wire       [7:0]    s2_byteLogic_6_outputData;
  reg                 s2_byteLogic_7_buffer_valid;
  reg        [7:0]    s2_byteLogic_7_buffer_data;
  wire                s2_byteLogic_7_lastUsed;
  wire                s2_byteLogic_7_inputMask;
  wire       [7:0]    s2_byteLogic_7_inputData;
  wire                s2_byteLogic_7_outputMask;
  wire       [7:0]    s2_byteLogic_7_outputData;
  reg                 s2_byteLogic_8_buffer_valid;
  reg        [7:0]    s2_byteLogic_8_buffer_data;
  wire                s2_byteLogic_8_lastUsed;
  wire                s2_byteLogic_8_inputMask;
  wire       [7:0]    s2_byteLogic_8_inputData;
  wire                s2_byteLogic_8_outputMask;
  wire       [7:0]    s2_byteLogic_8_outputData;
  reg                 s2_byteLogic_9_buffer_valid;
  reg        [7:0]    s2_byteLogic_9_buffer_data;
  wire                s2_byteLogic_9_lastUsed;
  wire                s2_byteLogic_9_inputMask;
  wire       [7:0]    s2_byteLogic_9_inputData;
  wire                s2_byteLogic_9_outputMask;
  wire       [7:0]    s2_byteLogic_9_outputData;
  reg                 s2_byteLogic_10_buffer_valid;
  reg        [7:0]    s2_byteLogic_10_buffer_data;
  wire                s2_byteLogic_10_lastUsed;
  wire                s2_byteLogic_10_inputMask;
  wire       [7:0]    s2_byteLogic_10_inputData;
  wire                s2_byteLogic_10_outputMask;
  wire       [7:0]    s2_byteLogic_10_outputData;
  reg                 s2_byteLogic_11_buffer_valid;
  reg        [7:0]    s2_byteLogic_11_buffer_data;
  wire                s2_byteLogic_11_lastUsed;
  wire                s2_byteLogic_11_inputMask;
  wire       [7:0]    s2_byteLogic_11_inputData;
  wire                s2_byteLogic_11_outputMask;
  wire       [7:0]    s2_byteLogic_11_outputData;
  reg                 s2_byteLogic_12_buffer_valid;
  reg        [7:0]    s2_byteLogic_12_buffer_data;
  wire                s2_byteLogic_12_lastUsed;
  wire                s2_byteLogic_12_inputMask;
  wire       [7:0]    s2_byteLogic_12_inputData;
  wire                s2_byteLogic_12_outputMask;
  wire       [7:0]    s2_byteLogic_12_outputData;
  reg                 s2_byteLogic_13_buffer_valid;
  reg        [7:0]    s2_byteLogic_13_buffer_data;
  wire                s2_byteLogic_13_lastUsed;
  wire                s2_byteLogic_13_inputMask;
  wire       [7:0]    s2_byteLogic_13_inputData;
  wire                s2_byteLogic_13_outputMask;
  wire       [7:0]    s2_byteLogic_13_outputData;
  reg                 s2_byteLogic_14_buffer_valid;
  reg        [7:0]    s2_byteLogic_14_buffer_data;
  wire                s2_byteLogic_14_lastUsed;
  wire                s2_byteLogic_14_inputMask;
  wire       [7:0]    s2_byteLogic_14_inputData;
  wire                s2_byteLogic_14_outputMask;
  wire       [7:0]    s2_byteLogic_14_outputData;
  reg                 s2_byteLogic_15_buffer_valid;
  reg        [7:0]    s2_byteLogic_15_buffer_data;
  wire                s2_byteLogic_15_lastUsed;
  wire                s2_byteLogic_15_inputMask;
  wire       [7:0]    s2_byteLogic_15_inputData;
  wire                s2_byteLogic_15_outputMask;
  wire       [7:0]    s2_byteLogic_15_outputData;
  wire                _zz_424;
  wire                _zz_425;
  wire                _zz_426;
  wire                _zz_427;

  assign _zz_496 = _zz_4;
  assign _zz_497 = {2'd0, _zz_496};
  assign _zz_498 = {_zz_5,_zz_4};
  assign _zz_499 = {1'd0, _zz_498};
  assign _zz_500 = (_zz_437 + _zz_438);
  assign _zz_501 = _zz_7;
  assign _zz_502 = {2'd0, _zz_501};
  assign _zz_503 = (_zz_440 + _zz_441);
  assign _zz_504 = {_zz_8,_zz_7};
  assign _zz_505 = {1'd0, _zz_504};
  assign _zz_506 = (_zz_443 + _zz_444);
  assign _zz_507 = (_zz_446 + _zz_447);
  assign _zz_508 = (_zz_448 + _zz_449);
  assign _zz_509 = _zz_10;
  assign _zz_510 = {2'd0, _zz_509};
  assign _zz_511 = (_zz_450 + _zz_451);
  assign _zz_512 = (_zz_452 + _zz_453);
  assign _zz_513 = {_zz_11,_zz_10};
  assign _zz_514 = {1'd0, _zz_513};
  assign _zz_515 = (_zz_454 + _zz_455);
  assign _zz_516 = (_zz_456 + _zz_457);
  assign _zz_517 = (_zz_518 + _zz_519);
  assign _zz_518 = (_zz_458 + _zz_459);
  assign _zz_519 = (_zz_460 + _zz_461);
  assign _zz_520 = _zz_13;
  assign _zz_521 = {2'd0, _zz_520};
  assign _zz_522 = (_zz_523 + _zz_524);
  assign _zz_523 = (_zz_463 + _zz_464);
  assign _zz_524 = (_zz_465 + _zz_466);
  assign _zz_525 = {_zz_14,_zz_13};
  assign _zz_526 = {1'd0, _zz_525};
  assign _zz_527 = (_zz_528 + _zz_529);
  assign _zz_528 = (_zz_468 + _zz_469);
  assign _zz_529 = (_zz_470 + _zz_471);
  assign _zz_530 = (_zz_531 + _zz_532);
  assign _zz_531 = (_zz_473 + _zz_474);
  assign _zz_532 = (_zz_475 + _zz_476);
  assign _zz_533 = (_zz_477 + _zz_478);
  assign _zz_534 = s0_input_payload_mask[15];
  assign _zz_535 = {2'd0, _zz_534};
  assign _zz_536 = {1'd0, s1_offset};
  assign _zz_537 = {8'd0, s1_input_payload_countOnes_15};
  assign _zz_538 = {3'd0, s1_input_payload_countOnes_0};
  assign _zz_539 = {2'd0, s1_input_payload_countOnes_1};
  assign _zz_540 = {2'd0, s1_input_payload_countOnes_2};
  assign _zz_541 = {1'd0, s1_input_payload_countOnes_3};
  assign _zz_542 = {1'd0, s1_input_payload_countOnes_4};
  assign _zz_543 = {1'd0, s1_input_payload_countOnes_5};
  assign _zz_544 = {1'd0, s1_input_payload_countOnes_6};
  assign _zz_545 = {1'd0, io_burstLength};
  assign _zz_546 = _zz_1;
  assign _zz_547 = {_zz_2,_zz_1};
  assign _zz_548 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_549 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_550 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_551 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_552 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_553 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_554 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_555 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_556 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_557 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_558 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_559 = {_zz_9,{_zz_8,_zz_7}};
  assign _zz_560 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_561 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_562 = {_zz_9,{_zz_8,_zz_7}};
  assign _zz_563 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_564 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_565 = {_zz_9,{_zz_8,_zz_7}};
  assign _zz_566 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_567 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_568 = {_zz_9,{_zz_8,_zz_7}};
  assign _zz_569 = {_zz_12,{_zz_11,_zz_10}};
  assign _zz_570 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_571 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_572 = {_zz_9,{_zz_8,_zz_7}};
  assign _zz_573 = {_zz_12,{_zz_11,_zz_10}};
  assign _zz_574 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_575 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_576 = {_zz_9,{_zz_8,_zz_7}};
  assign _zz_577 = {_zz_12,{_zz_11,_zz_10}};
  assign _zz_578 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_579 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_580 = {_zz_9,{_zz_8,_zz_7}};
  assign _zz_581 = {_zz_12,{_zz_11,_zz_10}};
  assign _zz_582 = {_zz_15,{_zz_14,_zz_13}};
  assign _zz_583 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_584 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_585 = {_zz_9,{_zz_8,_zz_7}};
  assign _zz_586 = {_zz_12,{_zz_11,_zz_10}};
  assign _zz_587 = {_zz_15,{_zz_14,_zz_13}};
  assign _zz_588 = {_zz_427,{_zz_426,{_zz_425,_zz_424}}};
  assign _zz_589 = _zz_126;
  assign _zz_590 = {_zz_125,{_zz_124,{_zz_123,{_zz_122,{_zz_121,{_zz_120,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b0000))}}}}}};
  assign _zz_591 = _zz_145;
  assign _zz_592 = {_zz_144,{_zz_143,{_zz_142,{_zz_141,{_zz_140,{_zz_139,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b0001))}}}}}};
  assign _zz_593 = _zz_164;
  assign _zz_594 = {_zz_163,{_zz_162,{_zz_161,{_zz_160,{_zz_159,{_zz_158,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b0010))}}}}}};
  assign _zz_595 = _zz_183;
  assign _zz_596 = {_zz_182,{_zz_181,{_zz_180,{_zz_179,{_zz_178,{_zz_177,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b0011))}}}}}};
  assign _zz_597 = _zz_202;
  assign _zz_598 = {_zz_201,{_zz_200,{_zz_199,{_zz_198,{_zz_197,{_zz_196,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b0100))}}}}}};
  assign _zz_599 = _zz_221;
  assign _zz_600 = {_zz_220,{_zz_219,{_zz_218,{_zz_217,{_zz_216,{_zz_215,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b0101))}}}}}};
  assign _zz_601 = _zz_240;
  assign _zz_602 = {_zz_239,{_zz_238,{_zz_237,{_zz_236,{_zz_235,{_zz_234,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b0110))}}}}}};
  assign _zz_603 = _zz_259;
  assign _zz_604 = {_zz_258,{_zz_257,{_zz_256,{_zz_255,{_zz_254,{_zz_253,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b0111))}}}}}};
  assign _zz_605 = _zz_278;
  assign _zz_606 = {_zz_277,{_zz_276,{_zz_275,{_zz_274,{_zz_273,{_zz_272,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b1000))}}}}}};
  assign _zz_607 = _zz_297;
  assign _zz_608 = {_zz_296,{_zz_295,{_zz_294,{_zz_293,{_zz_292,{_zz_291,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b1001))}}}}}};
  assign _zz_609 = _zz_316;
  assign _zz_610 = {_zz_315,{_zz_314,{_zz_313,{_zz_312,{_zz_311,{_zz_310,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b1010))}}}}}};
  assign _zz_611 = _zz_335;
  assign _zz_612 = {_zz_334,{_zz_333,{_zz_332,{_zz_331,{_zz_330,{_zz_329,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b1011))}}}}}};
  assign _zz_613 = _zz_354;
  assign _zz_614 = {_zz_353,{_zz_352,{_zz_351,{_zz_350,{_zz_349,{_zz_348,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b1100))}}}}}};
  assign _zz_615 = _zz_373;
  assign _zz_616 = {_zz_372,{_zz_371,{_zz_370,{_zz_369,{_zz_368,{_zz_367,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b1101))}}}}}};
  assign _zz_617 = _zz_392;
  assign _zz_618 = {_zz_391,{_zz_390,{_zz_389,{_zz_388,{_zz_387,{_zz_386,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b1110))}}}}}};
  assign _zz_619 = _zz_411;
  assign _zz_620 = {_zz_410,{_zz_409,{_zz_408,{_zz_407,{_zz_406,{_zz_405,(s1_input_payload_cmd_mask[0] && (s1_inputIndexes_0 == 4'b1111))}}}}}};
  always @(*) begin
    case(_zz_546)
      1'b0 : begin
        _zz_428 = 1'b0;
      end
      default : begin
        _zz_428 = 1'b1;
      end
    endcase
  end

  always @(*) begin
    case(_zz_547)
      2'b00 : begin
        _zz_429 = 2'b00;
      end
      2'b01 : begin
        _zz_429 = 2'b01;
      end
      2'b10 : begin
        _zz_429 = 2'b01;
      end
      default : begin
        _zz_429 = 2'b10;
      end
    endcase
  end

  always @(*) begin
    case(_zz_548)
      3'b000 : begin
        _zz_430 = 2'b00;
      end
      3'b001 : begin
        _zz_430 = 2'b01;
      end
      3'b010 : begin
        _zz_430 = 2'b01;
      end
      3'b011 : begin
        _zz_430 = 2'b10;
      end
      3'b100 : begin
        _zz_430 = 2'b01;
      end
      3'b101 : begin
        _zz_430 = 2'b10;
      end
      3'b110 : begin
        _zz_430 = 2'b10;
      end
      default : begin
        _zz_430 = 2'b11;
      end
    endcase
  end

  always @(*) begin
    case(_zz_549)
      3'b000 : begin
        _zz_431 = _zz_16;
      end
      3'b001 : begin
        _zz_431 = _zz_17;
      end
      3'b010 : begin
        _zz_431 = _zz_18;
      end
      3'b011 : begin
        _zz_431 = _zz_19;
      end
      3'b100 : begin
        _zz_431 = _zz_20;
      end
      3'b101 : begin
        _zz_431 = _zz_21;
      end
      3'b110 : begin
        _zz_431 = _zz_22;
      end
      default : begin
        _zz_431 = _zz_23;
      end
    endcase
  end

  always @(*) begin
    case(_zz_497)
      3'b000 : begin
        _zz_432 = _zz_16;
      end
      3'b001 : begin
        _zz_432 = _zz_17;
      end
      3'b010 : begin
        _zz_432 = _zz_18;
      end
      3'b011 : begin
        _zz_432 = _zz_19;
      end
      3'b100 : begin
        _zz_432 = _zz_20;
      end
      3'b101 : begin
        _zz_432 = _zz_21;
      end
      3'b110 : begin
        _zz_432 = _zz_22;
      end
      default : begin
        _zz_432 = _zz_23;
      end
    endcase
  end

  always @(*) begin
    case(_zz_550)
      3'b000 : begin
        _zz_433 = _zz_24;
      end
      3'b001 : begin
        _zz_433 = _zz_25;
      end
      3'b010 : begin
        _zz_433 = _zz_26;
      end
      3'b011 : begin
        _zz_433 = _zz_27;
      end
      3'b100 : begin
        _zz_433 = _zz_28;
      end
      3'b101 : begin
        _zz_433 = _zz_29;
      end
      3'b110 : begin
        _zz_433 = _zz_30;
      end
      default : begin
        _zz_433 = _zz_31;
      end
    endcase
  end

  always @(*) begin
    case(_zz_499)
      3'b000 : begin
        _zz_434 = _zz_24;
      end
      3'b001 : begin
        _zz_434 = _zz_25;
      end
      3'b010 : begin
        _zz_434 = _zz_26;
      end
      3'b011 : begin
        _zz_434 = _zz_27;
      end
      3'b100 : begin
        _zz_434 = _zz_28;
      end
      3'b101 : begin
        _zz_434 = _zz_29;
      end
      3'b110 : begin
        _zz_434 = _zz_30;
      end
      default : begin
        _zz_434 = _zz_31;
      end
    endcase
  end

  always @(*) begin
    case(_zz_551)
      3'b000 : begin
        _zz_435 = _zz_32;
      end
      3'b001 : begin
        _zz_435 = _zz_33;
      end
      3'b010 : begin
        _zz_435 = _zz_34;
      end
      3'b011 : begin
        _zz_435 = _zz_35;
      end
      3'b100 : begin
        _zz_435 = _zz_36;
      end
      3'b101 : begin
        _zz_435 = _zz_37;
      end
      3'b110 : begin
        _zz_435 = _zz_38;
      end
      default : begin
        _zz_435 = _zz_39;
      end
    endcase
  end

  always @(*) begin
    case(_zz_552)
      3'b000 : begin
        _zz_436 = _zz_32;
      end
      3'b001 : begin
        _zz_436 = _zz_33;
      end
      3'b010 : begin
        _zz_436 = _zz_34;
      end
      3'b011 : begin
        _zz_436 = _zz_35;
      end
      3'b100 : begin
        _zz_436 = _zz_36;
      end
      3'b101 : begin
        _zz_436 = _zz_37;
      end
      3'b110 : begin
        _zz_436 = _zz_38;
      end
      default : begin
        _zz_436 = _zz_39;
      end
    endcase
  end

  always @(*) begin
    case(_zz_553)
      3'b000 : begin
        _zz_437 = _zz_40;
      end
      3'b001 : begin
        _zz_437 = _zz_41;
      end
      3'b010 : begin
        _zz_437 = _zz_42;
      end
      3'b011 : begin
        _zz_437 = _zz_43;
      end
      3'b100 : begin
        _zz_437 = _zz_44;
      end
      3'b101 : begin
        _zz_437 = _zz_45;
      end
      3'b110 : begin
        _zz_437 = _zz_46;
      end
      default : begin
        _zz_437 = _zz_47;
      end
    endcase
  end

  always @(*) begin
    case(_zz_554)
      3'b000 : begin
        _zz_438 = _zz_40;
      end
      3'b001 : begin
        _zz_438 = _zz_41;
      end
      3'b010 : begin
        _zz_438 = _zz_42;
      end
      3'b011 : begin
        _zz_438 = _zz_43;
      end
      3'b100 : begin
        _zz_438 = _zz_44;
      end
      3'b101 : begin
        _zz_438 = _zz_45;
      end
      3'b110 : begin
        _zz_438 = _zz_46;
      end
      default : begin
        _zz_438 = _zz_47;
      end
    endcase
  end

  always @(*) begin
    case(_zz_502)
      3'b000 : begin
        _zz_439 = _zz_40;
      end
      3'b001 : begin
        _zz_439 = _zz_41;
      end
      3'b010 : begin
        _zz_439 = _zz_42;
      end
      3'b011 : begin
        _zz_439 = _zz_43;
      end
      3'b100 : begin
        _zz_439 = _zz_44;
      end
      3'b101 : begin
        _zz_439 = _zz_45;
      end
      3'b110 : begin
        _zz_439 = _zz_46;
      end
      default : begin
        _zz_439 = _zz_47;
      end
    endcase
  end

  always @(*) begin
    case(_zz_555)
      3'b000 : begin
        _zz_440 = _zz_48;
      end
      3'b001 : begin
        _zz_440 = _zz_49;
      end
      3'b010 : begin
        _zz_440 = _zz_50;
      end
      3'b011 : begin
        _zz_440 = _zz_51;
      end
      3'b100 : begin
        _zz_440 = _zz_52;
      end
      3'b101 : begin
        _zz_440 = _zz_53;
      end
      3'b110 : begin
        _zz_440 = _zz_54;
      end
      default : begin
        _zz_440 = _zz_55;
      end
    endcase
  end

  always @(*) begin
    case(_zz_556)
      3'b000 : begin
        _zz_441 = _zz_48;
      end
      3'b001 : begin
        _zz_441 = _zz_49;
      end
      3'b010 : begin
        _zz_441 = _zz_50;
      end
      3'b011 : begin
        _zz_441 = _zz_51;
      end
      3'b100 : begin
        _zz_441 = _zz_52;
      end
      3'b101 : begin
        _zz_441 = _zz_53;
      end
      3'b110 : begin
        _zz_441 = _zz_54;
      end
      default : begin
        _zz_441 = _zz_55;
      end
    endcase
  end

  always @(*) begin
    case(_zz_505)
      3'b000 : begin
        _zz_442 = _zz_48;
      end
      3'b001 : begin
        _zz_442 = _zz_49;
      end
      3'b010 : begin
        _zz_442 = _zz_50;
      end
      3'b011 : begin
        _zz_442 = _zz_51;
      end
      3'b100 : begin
        _zz_442 = _zz_52;
      end
      3'b101 : begin
        _zz_442 = _zz_53;
      end
      3'b110 : begin
        _zz_442 = _zz_54;
      end
      default : begin
        _zz_442 = _zz_55;
      end
    endcase
  end

  always @(*) begin
    case(_zz_557)
      3'b000 : begin
        _zz_443 = _zz_56;
      end
      3'b001 : begin
        _zz_443 = _zz_57;
      end
      3'b010 : begin
        _zz_443 = _zz_58;
      end
      3'b011 : begin
        _zz_443 = _zz_59;
      end
      3'b100 : begin
        _zz_443 = _zz_60;
      end
      3'b101 : begin
        _zz_443 = _zz_61;
      end
      3'b110 : begin
        _zz_443 = _zz_62;
      end
      default : begin
        _zz_443 = _zz_63;
      end
    endcase
  end

  always @(*) begin
    case(_zz_558)
      3'b000 : begin
        _zz_444 = _zz_56;
      end
      3'b001 : begin
        _zz_444 = _zz_57;
      end
      3'b010 : begin
        _zz_444 = _zz_58;
      end
      3'b011 : begin
        _zz_444 = _zz_59;
      end
      3'b100 : begin
        _zz_444 = _zz_60;
      end
      3'b101 : begin
        _zz_444 = _zz_61;
      end
      3'b110 : begin
        _zz_444 = _zz_62;
      end
      default : begin
        _zz_444 = _zz_63;
      end
    endcase
  end

  always @(*) begin
    case(_zz_559)
      3'b000 : begin
        _zz_445 = _zz_56;
      end
      3'b001 : begin
        _zz_445 = _zz_57;
      end
      3'b010 : begin
        _zz_445 = _zz_58;
      end
      3'b011 : begin
        _zz_445 = _zz_59;
      end
      3'b100 : begin
        _zz_445 = _zz_60;
      end
      3'b101 : begin
        _zz_445 = _zz_61;
      end
      3'b110 : begin
        _zz_445 = _zz_62;
      end
      default : begin
        _zz_445 = _zz_63;
      end
    endcase
  end

  always @(*) begin
    case(_zz_560)
      3'b000 : begin
        _zz_446 = _zz_64;
      end
      3'b001 : begin
        _zz_446 = _zz_65;
      end
      3'b010 : begin
        _zz_446 = _zz_66;
      end
      3'b011 : begin
        _zz_446 = _zz_67;
      end
      3'b100 : begin
        _zz_446 = _zz_68;
      end
      3'b101 : begin
        _zz_446 = _zz_69;
      end
      3'b110 : begin
        _zz_446 = _zz_70;
      end
      default : begin
        _zz_446 = _zz_71;
      end
    endcase
  end

  always @(*) begin
    case(_zz_561)
      3'b000 : begin
        _zz_447 = _zz_64;
      end
      3'b001 : begin
        _zz_447 = _zz_65;
      end
      3'b010 : begin
        _zz_447 = _zz_66;
      end
      3'b011 : begin
        _zz_447 = _zz_67;
      end
      3'b100 : begin
        _zz_447 = _zz_68;
      end
      3'b101 : begin
        _zz_447 = _zz_69;
      end
      3'b110 : begin
        _zz_447 = _zz_70;
      end
      default : begin
        _zz_447 = _zz_71;
      end
    endcase
  end

  always @(*) begin
    case(_zz_562)
      3'b000 : begin
        _zz_448 = _zz_64;
      end
      3'b001 : begin
        _zz_448 = _zz_65;
      end
      3'b010 : begin
        _zz_448 = _zz_66;
      end
      3'b011 : begin
        _zz_448 = _zz_67;
      end
      3'b100 : begin
        _zz_448 = _zz_68;
      end
      3'b101 : begin
        _zz_448 = _zz_69;
      end
      3'b110 : begin
        _zz_448 = _zz_70;
      end
      default : begin
        _zz_448 = _zz_71;
      end
    endcase
  end

  always @(*) begin
    case(_zz_510)
      3'b000 : begin
        _zz_449 = _zz_64;
      end
      3'b001 : begin
        _zz_449 = _zz_65;
      end
      3'b010 : begin
        _zz_449 = _zz_66;
      end
      3'b011 : begin
        _zz_449 = _zz_67;
      end
      3'b100 : begin
        _zz_449 = _zz_68;
      end
      3'b101 : begin
        _zz_449 = _zz_69;
      end
      3'b110 : begin
        _zz_449 = _zz_70;
      end
      default : begin
        _zz_449 = _zz_71;
      end
    endcase
  end

  always @(*) begin
    case(_zz_563)
      3'b000 : begin
        _zz_450 = _zz_72;
      end
      3'b001 : begin
        _zz_450 = _zz_73;
      end
      3'b010 : begin
        _zz_450 = _zz_74;
      end
      3'b011 : begin
        _zz_450 = _zz_75;
      end
      3'b100 : begin
        _zz_450 = _zz_76;
      end
      3'b101 : begin
        _zz_450 = _zz_77;
      end
      3'b110 : begin
        _zz_450 = _zz_78;
      end
      default : begin
        _zz_450 = _zz_79;
      end
    endcase
  end

  always @(*) begin
    case(_zz_564)
      3'b000 : begin
        _zz_451 = _zz_72;
      end
      3'b001 : begin
        _zz_451 = _zz_73;
      end
      3'b010 : begin
        _zz_451 = _zz_74;
      end
      3'b011 : begin
        _zz_451 = _zz_75;
      end
      3'b100 : begin
        _zz_451 = _zz_76;
      end
      3'b101 : begin
        _zz_451 = _zz_77;
      end
      3'b110 : begin
        _zz_451 = _zz_78;
      end
      default : begin
        _zz_451 = _zz_79;
      end
    endcase
  end

  always @(*) begin
    case(_zz_565)
      3'b000 : begin
        _zz_452 = _zz_72;
      end
      3'b001 : begin
        _zz_452 = _zz_73;
      end
      3'b010 : begin
        _zz_452 = _zz_74;
      end
      3'b011 : begin
        _zz_452 = _zz_75;
      end
      3'b100 : begin
        _zz_452 = _zz_76;
      end
      3'b101 : begin
        _zz_452 = _zz_77;
      end
      3'b110 : begin
        _zz_452 = _zz_78;
      end
      default : begin
        _zz_452 = _zz_79;
      end
    endcase
  end

  always @(*) begin
    case(_zz_514)
      3'b000 : begin
        _zz_453 = _zz_72;
      end
      3'b001 : begin
        _zz_453 = _zz_73;
      end
      3'b010 : begin
        _zz_453 = _zz_74;
      end
      3'b011 : begin
        _zz_453 = _zz_75;
      end
      3'b100 : begin
        _zz_453 = _zz_76;
      end
      3'b101 : begin
        _zz_453 = _zz_77;
      end
      3'b110 : begin
        _zz_453 = _zz_78;
      end
      default : begin
        _zz_453 = _zz_79;
      end
    endcase
  end

  always @(*) begin
    case(_zz_566)
      3'b000 : begin
        _zz_454 = _zz_80;
      end
      3'b001 : begin
        _zz_454 = _zz_81;
      end
      3'b010 : begin
        _zz_454 = _zz_82;
      end
      3'b011 : begin
        _zz_454 = _zz_83;
      end
      3'b100 : begin
        _zz_454 = _zz_84;
      end
      3'b101 : begin
        _zz_454 = _zz_85;
      end
      3'b110 : begin
        _zz_454 = _zz_86;
      end
      default : begin
        _zz_454 = _zz_87;
      end
    endcase
  end

  always @(*) begin
    case(_zz_567)
      3'b000 : begin
        _zz_455 = _zz_80;
      end
      3'b001 : begin
        _zz_455 = _zz_81;
      end
      3'b010 : begin
        _zz_455 = _zz_82;
      end
      3'b011 : begin
        _zz_455 = _zz_83;
      end
      3'b100 : begin
        _zz_455 = _zz_84;
      end
      3'b101 : begin
        _zz_455 = _zz_85;
      end
      3'b110 : begin
        _zz_455 = _zz_86;
      end
      default : begin
        _zz_455 = _zz_87;
      end
    endcase
  end

  always @(*) begin
    case(_zz_568)
      3'b000 : begin
        _zz_456 = _zz_80;
      end
      3'b001 : begin
        _zz_456 = _zz_81;
      end
      3'b010 : begin
        _zz_456 = _zz_82;
      end
      3'b011 : begin
        _zz_456 = _zz_83;
      end
      3'b100 : begin
        _zz_456 = _zz_84;
      end
      3'b101 : begin
        _zz_456 = _zz_85;
      end
      3'b110 : begin
        _zz_456 = _zz_86;
      end
      default : begin
        _zz_456 = _zz_87;
      end
    endcase
  end

  always @(*) begin
    case(_zz_569)
      3'b000 : begin
        _zz_457 = _zz_80;
      end
      3'b001 : begin
        _zz_457 = _zz_81;
      end
      3'b010 : begin
        _zz_457 = _zz_82;
      end
      3'b011 : begin
        _zz_457 = _zz_83;
      end
      3'b100 : begin
        _zz_457 = _zz_84;
      end
      3'b101 : begin
        _zz_457 = _zz_85;
      end
      3'b110 : begin
        _zz_457 = _zz_86;
      end
      default : begin
        _zz_457 = _zz_87;
      end
    endcase
  end

  always @(*) begin
    case(_zz_570)
      3'b000 : begin
        _zz_458 = _zz_88;
      end
      3'b001 : begin
        _zz_458 = _zz_89;
      end
      3'b010 : begin
        _zz_458 = _zz_90;
      end
      3'b011 : begin
        _zz_458 = _zz_91;
      end
      3'b100 : begin
        _zz_458 = _zz_92;
      end
      3'b101 : begin
        _zz_458 = _zz_93;
      end
      3'b110 : begin
        _zz_458 = _zz_94;
      end
      default : begin
        _zz_458 = _zz_95;
      end
    endcase
  end

  always @(*) begin
    case(_zz_571)
      3'b000 : begin
        _zz_459 = _zz_88;
      end
      3'b001 : begin
        _zz_459 = _zz_89;
      end
      3'b010 : begin
        _zz_459 = _zz_90;
      end
      3'b011 : begin
        _zz_459 = _zz_91;
      end
      3'b100 : begin
        _zz_459 = _zz_92;
      end
      3'b101 : begin
        _zz_459 = _zz_93;
      end
      3'b110 : begin
        _zz_459 = _zz_94;
      end
      default : begin
        _zz_459 = _zz_95;
      end
    endcase
  end

  always @(*) begin
    case(_zz_572)
      3'b000 : begin
        _zz_460 = _zz_88;
      end
      3'b001 : begin
        _zz_460 = _zz_89;
      end
      3'b010 : begin
        _zz_460 = _zz_90;
      end
      3'b011 : begin
        _zz_460 = _zz_91;
      end
      3'b100 : begin
        _zz_460 = _zz_92;
      end
      3'b101 : begin
        _zz_460 = _zz_93;
      end
      3'b110 : begin
        _zz_460 = _zz_94;
      end
      default : begin
        _zz_460 = _zz_95;
      end
    endcase
  end

  always @(*) begin
    case(_zz_573)
      3'b000 : begin
        _zz_461 = _zz_88;
      end
      3'b001 : begin
        _zz_461 = _zz_89;
      end
      3'b010 : begin
        _zz_461 = _zz_90;
      end
      3'b011 : begin
        _zz_461 = _zz_91;
      end
      3'b100 : begin
        _zz_461 = _zz_92;
      end
      3'b101 : begin
        _zz_461 = _zz_93;
      end
      3'b110 : begin
        _zz_461 = _zz_94;
      end
      default : begin
        _zz_461 = _zz_95;
      end
    endcase
  end

  always @(*) begin
    case(_zz_521)
      3'b000 : begin
        _zz_462 = _zz_88;
      end
      3'b001 : begin
        _zz_462 = _zz_89;
      end
      3'b010 : begin
        _zz_462 = _zz_90;
      end
      3'b011 : begin
        _zz_462 = _zz_91;
      end
      3'b100 : begin
        _zz_462 = _zz_92;
      end
      3'b101 : begin
        _zz_462 = _zz_93;
      end
      3'b110 : begin
        _zz_462 = _zz_94;
      end
      default : begin
        _zz_462 = _zz_95;
      end
    endcase
  end

  always @(*) begin
    case(_zz_574)
      3'b000 : begin
        _zz_463 = _zz_96;
      end
      3'b001 : begin
        _zz_463 = _zz_97;
      end
      3'b010 : begin
        _zz_463 = _zz_98;
      end
      3'b011 : begin
        _zz_463 = _zz_99;
      end
      3'b100 : begin
        _zz_463 = _zz_100;
      end
      3'b101 : begin
        _zz_463 = _zz_101;
      end
      3'b110 : begin
        _zz_463 = _zz_102;
      end
      default : begin
        _zz_463 = _zz_103;
      end
    endcase
  end

  always @(*) begin
    case(_zz_575)
      3'b000 : begin
        _zz_464 = _zz_96;
      end
      3'b001 : begin
        _zz_464 = _zz_97;
      end
      3'b010 : begin
        _zz_464 = _zz_98;
      end
      3'b011 : begin
        _zz_464 = _zz_99;
      end
      3'b100 : begin
        _zz_464 = _zz_100;
      end
      3'b101 : begin
        _zz_464 = _zz_101;
      end
      3'b110 : begin
        _zz_464 = _zz_102;
      end
      default : begin
        _zz_464 = _zz_103;
      end
    endcase
  end

  always @(*) begin
    case(_zz_576)
      3'b000 : begin
        _zz_465 = _zz_96;
      end
      3'b001 : begin
        _zz_465 = _zz_97;
      end
      3'b010 : begin
        _zz_465 = _zz_98;
      end
      3'b011 : begin
        _zz_465 = _zz_99;
      end
      3'b100 : begin
        _zz_465 = _zz_100;
      end
      3'b101 : begin
        _zz_465 = _zz_101;
      end
      3'b110 : begin
        _zz_465 = _zz_102;
      end
      default : begin
        _zz_465 = _zz_103;
      end
    endcase
  end

  always @(*) begin
    case(_zz_577)
      3'b000 : begin
        _zz_466 = _zz_96;
      end
      3'b001 : begin
        _zz_466 = _zz_97;
      end
      3'b010 : begin
        _zz_466 = _zz_98;
      end
      3'b011 : begin
        _zz_466 = _zz_99;
      end
      3'b100 : begin
        _zz_466 = _zz_100;
      end
      3'b101 : begin
        _zz_466 = _zz_101;
      end
      3'b110 : begin
        _zz_466 = _zz_102;
      end
      default : begin
        _zz_466 = _zz_103;
      end
    endcase
  end

  always @(*) begin
    case(_zz_526)
      3'b000 : begin
        _zz_467 = _zz_96;
      end
      3'b001 : begin
        _zz_467 = _zz_97;
      end
      3'b010 : begin
        _zz_467 = _zz_98;
      end
      3'b011 : begin
        _zz_467 = _zz_99;
      end
      3'b100 : begin
        _zz_467 = _zz_100;
      end
      3'b101 : begin
        _zz_467 = _zz_101;
      end
      3'b110 : begin
        _zz_467 = _zz_102;
      end
      default : begin
        _zz_467 = _zz_103;
      end
    endcase
  end

  always @(*) begin
    case(_zz_578)
      3'b000 : begin
        _zz_468 = _zz_104;
      end
      3'b001 : begin
        _zz_468 = _zz_105;
      end
      3'b010 : begin
        _zz_468 = _zz_106;
      end
      3'b011 : begin
        _zz_468 = _zz_107;
      end
      3'b100 : begin
        _zz_468 = _zz_108;
      end
      3'b101 : begin
        _zz_468 = _zz_109;
      end
      3'b110 : begin
        _zz_468 = _zz_110;
      end
      default : begin
        _zz_468 = _zz_111;
      end
    endcase
  end

  always @(*) begin
    case(_zz_579)
      3'b000 : begin
        _zz_469 = _zz_104;
      end
      3'b001 : begin
        _zz_469 = _zz_105;
      end
      3'b010 : begin
        _zz_469 = _zz_106;
      end
      3'b011 : begin
        _zz_469 = _zz_107;
      end
      3'b100 : begin
        _zz_469 = _zz_108;
      end
      3'b101 : begin
        _zz_469 = _zz_109;
      end
      3'b110 : begin
        _zz_469 = _zz_110;
      end
      default : begin
        _zz_469 = _zz_111;
      end
    endcase
  end

  always @(*) begin
    case(_zz_580)
      3'b000 : begin
        _zz_470 = _zz_104;
      end
      3'b001 : begin
        _zz_470 = _zz_105;
      end
      3'b010 : begin
        _zz_470 = _zz_106;
      end
      3'b011 : begin
        _zz_470 = _zz_107;
      end
      3'b100 : begin
        _zz_470 = _zz_108;
      end
      3'b101 : begin
        _zz_470 = _zz_109;
      end
      3'b110 : begin
        _zz_470 = _zz_110;
      end
      default : begin
        _zz_470 = _zz_111;
      end
    endcase
  end

  always @(*) begin
    case(_zz_581)
      3'b000 : begin
        _zz_471 = _zz_104;
      end
      3'b001 : begin
        _zz_471 = _zz_105;
      end
      3'b010 : begin
        _zz_471 = _zz_106;
      end
      3'b011 : begin
        _zz_471 = _zz_107;
      end
      3'b100 : begin
        _zz_471 = _zz_108;
      end
      3'b101 : begin
        _zz_471 = _zz_109;
      end
      3'b110 : begin
        _zz_471 = _zz_110;
      end
      default : begin
        _zz_471 = _zz_111;
      end
    endcase
  end

  always @(*) begin
    case(_zz_582)
      3'b000 : begin
        _zz_472 = _zz_104;
      end
      3'b001 : begin
        _zz_472 = _zz_105;
      end
      3'b010 : begin
        _zz_472 = _zz_106;
      end
      3'b011 : begin
        _zz_472 = _zz_107;
      end
      3'b100 : begin
        _zz_472 = _zz_108;
      end
      3'b101 : begin
        _zz_472 = _zz_109;
      end
      3'b110 : begin
        _zz_472 = _zz_110;
      end
      default : begin
        _zz_472 = _zz_111;
      end
    endcase
  end

  always @(*) begin
    case(_zz_583)
      3'b000 : begin
        _zz_473 = _zz_112;
      end
      3'b001 : begin
        _zz_473 = _zz_113;
      end
      3'b010 : begin
        _zz_473 = _zz_114;
      end
      3'b011 : begin
        _zz_473 = _zz_115;
      end
      3'b100 : begin
        _zz_473 = _zz_116;
      end
      3'b101 : begin
        _zz_473 = _zz_117;
      end
      3'b110 : begin
        _zz_473 = _zz_118;
      end
      default : begin
        _zz_473 = _zz_119;
      end
    endcase
  end

  always @(*) begin
    case(_zz_584)
      3'b000 : begin
        _zz_474 = _zz_112;
      end
      3'b001 : begin
        _zz_474 = _zz_113;
      end
      3'b010 : begin
        _zz_474 = _zz_114;
      end
      3'b011 : begin
        _zz_474 = _zz_115;
      end
      3'b100 : begin
        _zz_474 = _zz_116;
      end
      3'b101 : begin
        _zz_474 = _zz_117;
      end
      3'b110 : begin
        _zz_474 = _zz_118;
      end
      default : begin
        _zz_474 = _zz_119;
      end
    endcase
  end

  always @(*) begin
    case(_zz_585)
      3'b000 : begin
        _zz_475 = _zz_112;
      end
      3'b001 : begin
        _zz_475 = _zz_113;
      end
      3'b010 : begin
        _zz_475 = _zz_114;
      end
      3'b011 : begin
        _zz_475 = _zz_115;
      end
      3'b100 : begin
        _zz_475 = _zz_116;
      end
      3'b101 : begin
        _zz_475 = _zz_117;
      end
      3'b110 : begin
        _zz_475 = _zz_118;
      end
      default : begin
        _zz_475 = _zz_119;
      end
    endcase
  end

  always @(*) begin
    case(_zz_586)
      3'b000 : begin
        _zz_476 = _zz_112;
      end
      3'b001 : begin
        _zz_476 = _zz_113;
      end
      3'b010 : begin
        _zz_476 = _zz_114;
      end
      3'b011 : begin
        _zz_476 = _zz_115;
      end
      3'b100 : begin
        _zz_476 = _zz_116;
      end
      3'b101 : begin
        _zz_476 = _zz_117;
      end
      3'b110 : begin
        _zz_476 = _zz_118;
      end
      default : begin
        _zz_476 = _zz_119;
      end
    endcase
  end

  always @(*) begin
    case(_zz_587)
      3'b000 : begin
        _zz_477 = _zz_112;
      end
      3'b001 : begin
        _zz_477 = _zz_113;
      end
      3'b010 : begin
        _zz_477 = _zz_114;
      end
      3'b011 : begin
        _zz_477 = _zz_115;
      end
      3'b100 : begin
        _zz_477 = _zz_116;
      end
      3'b101 : begin
        _zz_477 = _zz_117;
      end
      3'b110 : begin
        _zz_477 = _zz_118;
      end
      default : begin
        _zz_477 = _zz_119;
      end
    endcase
  end

  always @(*) begin
    case(_zz_535)
      3'b000 : begin
        _zz_478 = _zz_112;
      end
      3'b001 : begin
        _zz_478 = _zz_113;
      end
      3'b010 : begin
        _zz_478 = _zz_114;
      end
      3'b011 : begin
        _zz_478 = _zz_115;
      end
      3'b100 : begin
        _zz_478 = _zz_116;
      end
      3'b101 : begin
        _zz_478 = _zz_117;
      end
      3'b110 : begin
        _zz_478 = _zz_118;
      end
      default : begin
        _zz_478 = _zz_119;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_0)
      4'b0000 : begin
        _zz_479 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_479 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_479 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_479 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_479 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_479 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_479 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_479 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_479 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_479 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_479 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_479 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_479 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_479 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_479 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_479 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_1)
      4'b0000 : begin
        _zz_480 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_480 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_480 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_480 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_480 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_480 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_480 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_480 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_480 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_480 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_480 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_480 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_480 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_480 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_480 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_480 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_2)
      4'b0000 : begin
        _zz_481 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_481 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_481 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_481 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_481 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_481 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_481 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_481 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_481 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_481 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_481 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_481 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_481 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_481 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_481 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_481 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_3)
      4'b0000 : begin
        _zz_482 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_482 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_482 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_482 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_482 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_482 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_482 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_482 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_482 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_482 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_482 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_482 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_482 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_482 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_482 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_482 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_4)
      4'b0000 : begin
        _zz_483 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_483 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_483 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_483 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_483 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_483 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_483 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_483 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_483 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_483 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_483 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_483 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_483 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_483 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_483 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_483 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_5)
      4'b0000 : begin
        _zz_484 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_484 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_484 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_484 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_484 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_484 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_484 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_484 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_484 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_484 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_484 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_484 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_484 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_484 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_484 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_484 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_6)
      4'b0000 : begin
        _zz_485 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_485 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_485 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_485 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_485 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_485 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_485 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_485 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_485 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_485 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_485 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_485 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_485 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_485 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_485 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_485 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_7)
      4'b0000 : begin
        _zz_486 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_486 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_486 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_486 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_486 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_486 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_486 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_486 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_486 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_486 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_486 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_486 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_486 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_486 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_486 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_486 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_8)
      4'b0000 : begin
        _zz_487 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_487 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_487 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_487 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_487 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_487 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_487 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_487 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_487 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_487 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_487 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_487 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_487 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_487 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_487 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_487 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_9)
      4'b0000 : begin
        _zz_488 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_488 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_488 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_488 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_488 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_488 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_488 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_488 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_488 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_488 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_488 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_488 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_488 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_488 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_488 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_488 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_10)
      4'b0000 : begin
        _zz_489 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_489 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_489 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_489 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_489 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_489 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_489 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_489 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_489 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_489 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_489 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_489 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_489 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_489 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_489 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_489 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_11)
      4'b0000 : begin
        _zz_490 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_490 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_490 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_490 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_490 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_490 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_490 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_490 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_490 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_490 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_490 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_490 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_490 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_490 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_490 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_490 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_12)
      4'b0000 : begin
        _zz_491 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_491 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_491 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_491 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_491 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_491 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_491 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_491 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_491 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_491 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_491 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_491 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_491 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_491 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_491 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_491 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_13)
      4'b0000 : begin
        _zz_492 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_492 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_492 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_492 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_492 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_492 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_492 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_492 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_492 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_492 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_492 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_492 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_492 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_492 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_492 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_492 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_14)
      4'b0000 : begin
        _zz_493 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_493 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_493 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_493 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_493 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_493 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_493 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_493 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_493 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_493 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_493 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_493 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_493 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_493 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_493 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_493 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(s2_input_payload_sel_15)
      4'b0000 : begin
        _zz_494 = s2_inputDataBytes_0;
      end
      4'b0001 : begin
        _zz_494 = s2_inputDataBytes_1;
      end
      4'b0010 : begin
        _zz_494 = s2_inputDataBytes_2;
      end
      4'b0011 : begin
        _zz_494 = s2_inputDataBytes_3;
      end
      4'b0100 : begin
        _zz_494 = s2_inputDataBytes_4;
      end
      4'b0101 : begin
        _zz_494 = s2_inputDataBytes_5;
      end
      4'b0110 : begin
        _zz_494 = s2_inputDataBytes_6;
      end
      4'b0111 : begin
        _zz_494 = s2_inputDataBytes_7;
      end
      4'b1000 : begin
        _zz_494 = s2_inputDataBytes_8;
      end
      4'b1001 : begin
        _zz_494 = s2_inputDataBytes_9;
      end
      4'b1010 : begin
        _zz_494 = s2_inputDataBytes_10;
      end
      4'b1011 : begin
        _zz_494 = s2_inputDataBytes_11;
      end
      4'b1100 : begin
        _zz_494 = s2_inputDataBytes_12;
      end
      4'b1101 : begin
        _zz_494 = s2_inputDataBytes_13;
      end
      4'b1110 : begin
        _zz_494 = s2_inputDataBytes_14;
      end
      default : begin
        _zz_494 = s2_inputDataBytes_15;
      end
    endcase
  end

  always @(*) begin
    case(_zz_588)
      4'b0000 : begin
        _zz_495 = s2_input_payload_sel_0;
      end
      4'b0001 : begin
        _zz_495 = s2_input_payload_sel_1;
      end
      4'b0010 : begin
        _zz_495 = s2_input_payload_sel_2;
      end
      4'b0011 : begin
        _zz_495 = s2_input_payload_sel_3;
      end
      4'b0100 : begin
        _zz_495 = s2_input_payload_sel_4;
      end
      4'b0101 : begin
        _zz_495 = s2_input_payload_sel_5;
      end
      4'b0110 : begin
        _zz_495 = s2_input_payload_sel_6;
      end
      4'b0111 : begin
        _zz_495 = s2_input_payload_sel_7;
      end
      4'b1000 : begin
        _zz_495 = s2_input_payload_sel_8;
      end
      4'b1001 : begin
        _zz_495 = s2_input_payload_sel_9;
      end
      4'b1010 : begin
        _zz_495 = s2_input_payload_sel_10;
      end
      4'b1011 : begin
        _zz_495 = s2_input_payload_sel_11;
      end
      4'b1100 : begin
        _zz_495 = s2_input_payload_sel_12;
      end
      4'b1101 : begin
        _zz_495 = s2_input_payload_sel_13;
      end
      4'b1110 : begin
        _zz_495 = s2_input_payload_sel_14;
      end
      default : begin
        _zz_495 = s2_input_payload_sel_15;
      end
    endcase
  end

  assign io_input_ready = ((1'b1 && (! s0_input_valid)) || s0_input_ready);
  assign s0_input_valid = io_input_m2sPipe_rValid;
  assign s0_input_payload_data = io_input_m2sPipe_rData_data;
  assign s0_input_payload_mask = io_input_m2sPipe_rData_mask;
  assign _zz_1 = s0_input_payload_mask[0];
  assign _zz_2 = s0_input_payload_mask[1];
  assign _zz_3 = s0_input_payload_mask[2];
  assign _zz_4 = s0_input_payload_mask[3];
  assign _zz_5 = s0_input_payload_mask[4];
  assign _zz_6 = s0_input_payload_mask[5];
  assign _zz_7 = s0_input_payload_mask[6];
  assign _zz_8 = s0_input_payload_mask[7];
  assign _zz_9 = s0_input_payload_mask[8];
  assign _zz_10 = s0_input_payload_mask[9];
  assign _zz_11 = s0_input_payload_mask[10];
  assign _zz_12 = s0_input_payload_mask[11];
  assign _zz_13 = s0_input_payload_mask[12];
  assign _zz_14 = s0_input_payload_mask[13];
  assign _zz_15 = s0_input_payload_mask[14];
  assign s0_countOnesLogic_0 = _zz_428;
  assign s0_countOnesLogic_1 = _zz_429;
  assign s0_countOnesLogic_2 = _zz_430;
  assign _zz_16 = 3'b000;
  assign _zz_17 = 3'b001;
  assign _zz_18 = 3'b001;
  assign _zz_19 = 3'b010;
  assign _zz_20 = 3'b001;
  assign _zz_21 = 3'b010;
  assign _zz_22 = 3'b010;
  assign _zz_23 = 3'b011;
  assign s0_countOnesLogic_3 = (_zz_431 + _zz_432);
  assign _zz_24 = 3'b000;
  assign _zz_25 = 3'b001;
  assign _zz_26 = 3'b001;
  assign _zz_27 = 3'b010;
  assign _zz_28 = 3'b001;
  assign _zz_29 = 3'b010;
  assign _zz_30 = 3'b010;
  assign _zz_31 = 3'b011;
  assign s0_countOnesLogic_4 = (_zz_433 + _zz_434);
  assign _zz_32 = 3'b000;
  assign _zz_33 = 3'b001;
  assign _zz_34 = 3'b001;
  assign _zz_35 = 3'b010;
  assign _zz_36 = 3'b001;
  assign _zz_37 = 3'b010;
  assign _zz_38 = 3'b010;
  assign _zz_39 = 3'b011;
  assign s0_countOnesLogic_5 = (_zz_435 + _zz_436);
  assign _zz_40 = 3'b000;
  assign _zz_41 = 3'b001;
  assign _zz_42 = 3'b001;
  assign _zz_43 = 3'b010;
  assign _zz_44 = 3'b001;
  assign _zz_45 = 3'b010;
  assign _zz_46 = 3'b010;
  assign _zz_47 = 3'b011;
  assign s0_countOnesLogic_6 = (_zz_500 + _zz_439);
  assign _zz_48 = 4'b0000;
  assign _zz_49 = 4'b0001;
  assign _zz_50 = 4'b0001;
  assign _zz_51 = 4'b0010;
  assign _zz_52 = 4'b0001;
  assign _zz_53 = 4'b0010;
  assign _zz_54 = 4'b0010;
  assign _zz_55 = 4'b0011;
  assign s0_countOnesLogic_7 = (_zz_503 + _zz_442);
  assign _zz_56 = 4'b0000;
  assign _zz_57 = 4'b0001;
  assign _zz_58 = 4'b0001;
  assign _zz_59 = 4'b0010;
  assign _zz_60 = 4'b0001;
  assign _zz_61 = 4'b0010;
  assign _zz_62 = 4'b0010;
  assign _zz_63 = 4'b0011;
  assign s0_countOnesLogic_8 = (_zz_506 + _zz_445);
  assign _zz_64 = 4'b0000;
  assign _zz_65 = 4'b0001;
  assign _zz_66 = 4'b0001;
  assign _zz_67 = 4'b0010;
  assign _zz_68 = 4'b0001;
  assign _zz_69 = 4'b0010;
  assign _zz_70 = 4'b0010;
  assign _zz_71 = 4'b0011;
  assign s0_countOnesLogic_9 = (_zz_507 + _zz_508);
  assign _zz_72 = 4'b0000;
  assign _zz_73 = 4'b0001;
  assign _zz_74 = 4'b0001;
  assign _zz_75 = 4'b0010;
  assign _zz_76 = 4'b0001;
  assign _zz_77 = 4'b0010;
  assign _zz_78 = 4'b0010;
  assign _zz_79 = 4'b0011;
  assign s0_countOnesLogic_10 = (_zz_511 + _zz_512);
  assign _zz_80 = 4'b0000;
  assign _zz_81 = 4'b0001;
  assign _zz_82 = 4'b0001;
  assign _zz_83 = 4'b0010;
  assign _zz_84 = 4'b0001;
  assign _zz_85 = 4'b0010;
  assign _zz_86 = 4'b0010;
  assign _zz_87 = 4'b0011;
  assign s0_countOnesLogic_11 = (_zz_515 + _zz_516);
  assign _zz_88 = 4'b0000;
  assign _zz_89 = 4'b0001;
  assign _zz_90 = 4'b0001;
  assign _zz_91 = 4'b0010;
  assign _zz_92 = 4'b0001;
  assign _zz_93 = 4'b0010;
  assign _zz_94 = 4'b0010;
  assign _zz_95 = 4'b0011;
  assign s0_countOnesLogic_12 = (_zz_517 + _zz_462);
  assign _zz_96 = 4'b0000;
  assign _zz_97 = 4'b0001;
  assign _zz_98 = 4'b0001;
  assign _zz_99 = 4'b0010;
  assign _zz_100 = 4'b0001;
  assign _zz_101 = 4'b0010;
  assign _zz_102 = 4'b0010;
  assign _zz_103 = 4'b0011;
  assign s0_countOnesLogic_13 = (_zz_522 + _zz_467);
  assign _zz_104 = 4'b0000;
  assign _zz_105 = 4'b0001;
  assign _zz_106 = 4'b0001;
  assign _zz_107 = 4'b0010;
  assign _zz_108 = 4'b0001;
  assign _zz_109 = 4'b0010;
  assign _zz_110 = 4'b0010;
  assign _zz_111 = 4'b0011;
  assign s0_countOnesLogic_14 = (_zz_527 + _zz_472);
  assign _zz_112 = 5'h0;
  assign _zz_113 = 5'h01;
  assign _zz_114 = 5'h01;
  assign _zz_115 = 5'h02;
  assign _zz_116 = 5'h01;
  assign _zz_117 = 5'h02;
  assign _zz_118 = 5'h02;
  assign _zz_119 = 5'h03;
  assign s0_countOnesLogic_15 = (_zz_530 + _zz_533);
  assign s0_outputPayload_cmd_data = s0_input_payload_data;
  assign s0_outputPayload_cmd_mask = s0_input_payload_mask;
  assign s0_outputPayload_countOnes_0 = s0_countOnesLogic_0;
  assign s0_outputPayload_countOnes_1 = s0_countOnesLogic_1;
  assign s0_outputPayload_countOnes_2 = s0_countOnesLogic_2;
  assign s0_outputPayload_countOnes_3 = s0_countOnesLogic_3;
  assign s0_outputPayload_countOnes_4 = s0_countOnesLogic_4;
  assign s0_outputPayload_countOnes_5 = s0_countOnesLogic_5;
  assign s0_outputPayload_countOnes_6 = s0_countOnesLogic_6;
  assign s0_outputPayload_countOnes_7 = s0_countOnesLogic_7;
  assign s0_outputPayload_countOnes_8 = s0_countOnesLogic_8;
  assign s0_outputPayload_countOnes_9 = s0_countOnesLogic_9;
  assign s0_outputPayload_countOnes_10 = s0_countOnesLogic_10;
  assign s0_outputPayload_countOnes_11 = s0_countOnesLogic_11;
  assign s0_outputPayload_countOnes_12 = s0_countOnesLogic_12;
  assign s0_outputPayload_countOnes_13 = s0_countOnesLogic_13;
  assign s0_outputPayload_countOnes_14 = s0_countOnesLogic_14;
  assign s0_outputPayload_countOnes_15 = s0_countOnesLogic_15;
  assign s0_output_valid = s0_input_valid;
  assign s0_input_ready = s0_output_ready;
  assign s0_output_payload_cmd_data = s0_outputPayload_cmd_data;
  assign s0_output_payload_cmd_mask = s0_outputPayload_cmd_mask;
  assign s0_output_payload_countOnes_0 = s0_outputPayload_countOnes_0;
  assign s0_output_payload_countOnes_1 = s0_outputPayload_countOnes_1;
  assign s0_output_payload_countOnes_2 = s0_outputPayload_countOnes_2;
  assign s0_output_payload_countOnes_3 = s0_outputPayload_countOnes_3;
  assign s0_output_payload_countOnes_4 = s0_outputPayload_countOnes_4;
  assign s0_output_payload_countOnes_5 = s0_outputPayload_countOnes_5;
  assign s0_output_payload_countOnes_6 = s0_outputPayload_countOnes_6;
  assign s0_output_payload_countOnes_7 = s0_outputPayload_countOnes_7;
  assign s0_output_payload_countOnes_8 = s0_outputPayload_countOnes_8;
  assign s0_output_payload_countOnes_9 = s0_outputPayload_countOnes_9;
  assign s0_output_payload_countOnes_10 = s0_outputPayload_countOnes_10;
  assign s0_output_payload_countOnes_11 = s0_outputPayload_countOnes_11;
  assign s0_output_payload_countOnes_12 = s0_outputPayload_countOnes_12;
  assign s0_output_payload_countOnes_13 = s0_outputPayload_countOnes_13;
  assign s0_output_payload_countOnes_14 = s0_outputPayload_countOnes_14;
  assign s0_output_payload_countOnes_15 = s0_outputPayload_countOnes_15;
  assign s0_output_ready = ((1'b1 && (! s1_input_valid)) || s1_input_ready);
  assign s1_input_valid = s0_output_m2sPipe_rValid;
  assign s1_input_payload_cmd_data = s0_output_m2sPipe_rData_cmd_data;
  assign s1_input_payload_cmd_mask = s0_output_m2sPipe_rData_cmd_mask;
  assign s1_input_payload_countOnes_0 = s0_output_m2sPipe_rData_countOnes_0;
  assign s1_input_payload_countOnes_1 = s0_output_m2sPipe_rData_countOnes_1;
  assign s1_input_payload_countOnes_2 = s0_output_m2sPipe_rData_countOnes_2;
  assign s1_input_payload_countOnes_3 = s0_output_m2sPipe_rData_countOnes_3;
  assign s1_input_payload_countOnes_4 = s0_output_m2sPipe_rData_countOnes_4;
  assign s1_input_payload_countOnes_5 = s0_output_m2sPipe_rData_countOnes_5;
  assign s1_input_payload_countOnes_6 = s0_output_m2sPipe_rData_countOnes_6;
  assign s1_input_payload_countOnes_7 = s0_output_m2sPipe_rData_countOnes_7;
  assign s1_input_payload_countOnes_8 = s0_output_m2sPipe_rData_countOnes_8;
  assign s1_input_payload_countOnes_9 = s0_output_m2sPipe_rData_countOnes_9;
  assign s1_input_payload_countOnes_10 = s0_output_m2sPipe_rData_countOnes_10;
  assign s1_input_payload_countOnes_11 = s0_output_m2sPipe_rData_countOnes_11;
  assign s1_input_payload_countOnes_12 = s0_output_m2sPipe_rData_countOnes_12;
  assign s1_input_payload_countOnes_13 = s0_output_m2sPipe_rData_countOnes_13;
  assign s1_input_payload_countOnes_14 = s0_output_m2sPipe_rData_countOnes_14;
  assign s1_input_payload_countOnes_15 = s0_output_m2sPipe_rData_countOnes_15;
  assign s1_offsetNext = (_zz_536 + s1_input_payload_countOnes_15);
  assign s1_inputIndexes_0 = (4'b0000 + s1_offset);
  assign s1_inputIndexes_1 = (_zz_538 + s1_offset);
  assign s1_inputIndexes_2 = (_zz_539 + s1_offset);
  assign s1_inputIndexes_3 = (_zz_540 + s1_offset);
  assign s1_inputIndexes_4 = (_zz_541 + s1_offset);
  assign s1_inputIndexes_5 = (_zz_542 + s1_offset);
  assign s1_inputIndexes_6 = (_zz_543 + s1_offset);
  assign s1_inputIndexes_7 = (_zz_544 + s1_offset);
  assign s1_inputIndexes_8 = (s1_input_payload_countOnes_7 + s1_offset);
  assign s1_inputIndexes_9 = (s1_input_payload_countOnes_8 + s1_offset);
  assign s1_inputIndexes_10 = (s1_input_payload_countOnes_9 + s1_offset);
  assign s1_inputIndexes_11 = (s1_input_payload_countOnes_10 + s1_offset);
  assign s1_inputIndexes_12 = (s1_input_payload_countOnes_11 + s1_offset);
  assign s1_inputIndexes_13 = (s1_input_payload_countOnes_12 + s1_offset);
  assign s1_inputIndexes_14 = (s1_input_payload_countOnes_13 + s1_offset);
  assign s1_inputIndexes_15 = (s1_input_payload_countOnes_14 + s1_offset);
  assign s1_outputPayload_cmd_data = s1_input_payload_cmd_data;
  assign s1_outputPayload_cmd_mask = s1_input_payload_cmd_mask;
  assign s1_outputPayload_index_0 = s1_inputIndexes_0;
  assign s1_outputPayload_index_1 = s1_inputIndexes_1;
  assign s1_outputPayload_index_2 = s1_inputIndexes_2;
  assign s1_outputPayload_index_3 = s1_inputIndexes_3;
  assign s1_outputPayload_index_4 = s1_inputIndexes_4;
  assign s1_outputPayload_index_5 = s1_inputIndexes_5;
  assign s1_outputPayload_index_6 = s1_inputIndexes_6;
  assign s1_outputPayload_index_7 = s1_inputIndexes_7;
  assign s1_outputPayload_index_8 = s1_inputIndexes_8;
  assign s1_outputPayload_index_9 = s1_inputIndexes_9;
  assign s1_outputPayload_index_10 = s1_inputIndexes_10;
  assign s1_outputPayload_index_11 = s1_inputIndexes_11;
  assign s1_outputPayload_index_12 = s1_inputIndexes_12;
  assign s1_outputPayload_index_13 = s1_inputIndexes_13;
  assign s1_outputPayload_index_14 = s1_inputIndexes_14;
  assign s1_outputPayload_index_15 = s1_inputIndexes_15;
  assign s1_outputPayload_last = s1_offsetNext[4];
  assign _zz_120 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b0000));
  assign _zz_121 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b0000));
  assign _zz_122 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b0000));
  assign _zz_123 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b0000));
  assign _zz_124 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b0000));
  assign _zz_125 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b0000));
  assign _zz_126 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b0000));
  assign _zz_127 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b0000));
  assign _zz_128 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b0000));
  assign _zz_129 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b0000));
  assign _zz_130 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b0000));
  assign _zz_131 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b0000));
  assign _zz_132 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b0000));
  assign _zz_133 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b0000));
  assign _zz_134 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b0000));
  assign _zz_135 = (((((((_zz_120 || _zz_122) || _zz_124) || _zz_126) || _zz_128) || _zz_130) || _zz_132) || _zz_134);
  assign _zz_136 = (((((((_zz_121 || _zz_122) || _zz_125) || _zz_126) || _zz_129) || _zz_130) || _zz_133) || _zz_134);
  assign _zz_137 = (((((((_zz_123 || _zz_124) || _zz_125) || _zz_126) || _zz_131) || _zz_132) || _zz_133) || _zz_134);
  assign _zz_138 = (((((((_zz_127 || _zz_128) || _zz_129) || _zz_130) || _zz_131) || _zz_132) || _zz_133) || _zz_134);
  assign s1_outputPayload_sel_0 = {_zz_138,{_zz_137,{_zz_136,_zz_135}}};
  always @ (*) begin
    s1_outputPayload_selValid[0] = (({_zz_134,{_zz_133,{_zz_132,{_zz_131,{_zz_130,{_zz_129,{_zz_128,{_zz_127,{_zz_589,_zz_590}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_0]);
    s1_outputPayload_selValid[1] = (({_zz_153,{_zz_152,{_zz_151,{_zz_150,{_zz_149,{_zz_148,{_zz_147,{_zz_146,{_zz_591,_zz_592}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_1]);
    s1_outputPayload_selValid[2] = (({_zz_172,{_zz_171,{_zz_170,{_zz_169,{_zz_168,{_zz_167,{_zz_166,{_zz_165,{_zz_593,_zz_594}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_2]);
    s1_outputPayload_selValid[3] = (({_zz_191,{_zz_190,{_zz_189,{_zz_188,{_zz_187,{_zz_186,{_zz_185,{_zz_184,{_zz_595,_zz_596}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_3]);
    s1_outputPayload_selValid[4] = (({_zz_210,{_zz_209,{_zz_208,{_zz_207,{_zz_206,{_zz_205,{_zz_204,{_zz_203,{_zz_597,_zz_598}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_4]);
    s1_outputPayload_selValid[5] = (({_zz_229,{_zz_228,{_zz_227,{_zz_226,{_zz_225,{_zz_224,{_zz_223,{_zz_222,{_zz_599,_zz_600}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_5]);
    s1_outputPayload_selValid[6] = (({_zz_248,{_zz_247,{_zz_246,{_zz_245,{_zz_244,{_zz_243,{_zz_242,{_zz_241,{_zz_601,_zz_602}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_6]);
    s1_outputPayload_selValid[7] = (({_zz_267,{_zz_266,{_zz_265,{_zz_264,{_zz_263,{_zz_262,{_zz_261,{_zz_260,{_zz_603,_zz_604}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_7]);
    s1_outputPayload_selValid[8] = (({_zz_286,{_zz_285,{_zz_284,{_zz_283,{_zz_282,{_zz_281,{_zz_280,{_zz_279,{_zz_605,_zz_606}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_8]);
    s1_outputPayload_selValid[9] = (({_zz_305,{_zz_304,{_zz_303,{_zz_302,{_zz_301,{_zz_300,{_zz_299,{_zz_298,{_zz_607,_zz_608}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_9]);
    s1_outputPayload_selValid[10] = (({_zz_324,{_zz_323,{_zz_322,{_zz_321,{_zz_320,{_zz_319,{_zz_318,{_zz_317,{_zz_609,_zz_610}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_10]);
    s1_outputPayload_selValid[11] = (({_zz_343,{_zz_342,{_zz_341,{_zz_340,{_zz_339,{_zz_338,{_zz_337,{_zz_336,{_zz_611,_zz_612}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_11]);
    s1_outputPayload_selValid[12] = (({_zz_362,{_zz_361,{_zz_360,{_zz_359,{_zz_358,{_zz_357,{_zz_356,{_zz_355,{_zz_613,_zz_614}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_12]);
    s1_outputPayload_selValid[13] = (({_zz_381,{_zz_380,{_zz_379,{_zz_378,{_zz_377,{_zz_376,{_zz_375,{_zz_374,{_zz_615,_zz_616}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_13]);
    s1_outputPayload_selValid[14] = (({_zz_400,{_zz_399,{_zz_398,{_zz_397,{_zz_396,{_zz_395,{_zz_394,{_zz_393,{_zz_617,_zz_618}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_14]);
    s1_outputPayload_selValid[15] = (({_zz_419,{_zz_418,{_zz_417,{_zz_416,{_zz_415,{_zz_414,{_zz_413,{_zz_412,{_zz_619,_zz_620}}}}}}}}} != 16'h0) && s1_outputPayload_cmd_mask[s1_outputPayload_sel_15]);
  end

  assign _zz_139 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b0001));
  assign _zz_140 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b0001));
  assign _zz_141 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b0001));
  assign _zz_142 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b0001));
  assign _zz_143 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b0001));
  assign _zz_144 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b0001));
  assign _zz_145 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b0001));
  assign _zz_146 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b0001));
  assign _zz_147 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b0001));
  assign _zz_148 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b0001));
  assign _zz_149 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b0001));
  assign _zz_150 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b0001));
  assign _zz_151 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b0001));
  assign _zz_152 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b0001));
  assign _zz_153 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b0001));
  assign _zz_154 = (((((((_zz_139 || _zz_141) || _zz_143) || _zz_145) || _zz_147) || _zz_149) || _zz_151) || _zz_153);
  assign _zz_155 = (((((((_zz_140 || _zz_141) || _zz_144) || _zz_145) || _zz_148) || _zz_149) || _zz_152) || _zz_153);
  assign _zz_156 = (((((((_zz_142 || _zz_143) || _zz_144) || _zz_145) || _zz_150) || _zz_151) || _zz_152) || _zz_153);
  assign _zz_157 = (((((((_zz_146 || _zz_147) || _zz_148) || _zz_149) || _zz_150) || _zz_151) || _zz_152) || _zz_153);
  assign s1_outputPayload_sel_1 = {_zz_157,{_zz_156,{_zz_155,_zz_154}}};
  assign _zz_158 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b0010));
  assign _zz_159 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b0010));
  assign _zz_160 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b0010));
  assign _zz_161 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b0010));
  assign _zz_162 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b0010));
  assign _zz_163 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b0010));
  assign _zz_164 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b0010));
  assign _zz_165 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b0010));
  assign _zz_166 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b0010));
  assign _zz_167 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b0010));
  assign _zz_168 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b0010));
  assign _zz_169 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b0010));
  assign _zz_170 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b0010));
  assign _zz_171 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b0010));
  assign _zz_172 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b0010));
  assign _zz_173 = (((((((_zz_158 || _zz_160) || _zz_162) || _zz_164) || _zz_166) || _zz_168) || _zz_170) || _zz_172);
  assign _zz_174 = (((((((_zz_159 || _zz_160) || _zz_163) || _zz_164) || _zz_167) || _zz_168) || _zz_171) || _zz_172);
  assign _zz_175 = (((((((_zz_161 || _zz_162) || _zz_163) || _zz_164) || _zz_169) || _zz_170) || _zz_171) || _zz_172);
  assign _zz_176 = (((((((_zz_165 || _zz_166) || _zz_167) || _zz_168) || _zz_169) || _zz_170) || _zz_171) || _zz_172);
  assign s1_outputPayload_sel_2 = {_zz_176,{_zz_175,{_zz_174,_zz_173}}};
  assign _zz_177 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b0011));
  assign _zz_178 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b0011));
  assign _zz_179 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b0011));
  assign _zz_180 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b0011));
  assign _zz_181 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b0011));
  assign _zz_182 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b0011));
  assign _zz_183 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b0011));
  assign _zz_184 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b0011));
  assign _zz_185 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b0011));
  assign _zz_186 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b0011));
  assign _zz_187 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b0011));
  assign _zz_188 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b0011));
  assign _zz_189 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b0011));
  assign _zz_190 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b0011));
  assign _zz_191 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b0011));
  assign _zz_192 = (((((((_zz_177 || _zz_179) || _zz_181) || _zz_183) || _zz_185) || _zz_187) || _zz_189) || _zz_191);
  assign _zz_193 = (((((((_zz_178 || _zz_179) || _zz_182) || _zz_183) || _zz_186) || _zz_187) || _zz_190) || _zz_191);
  assign _zz_194 = (((((((_zz_180 || _zz_181) || _zz_182) || _zz_183) || _zz_188) || _zz_189) || _zz_190) || _zz_191);
  assign _zz_195 = (((((((_zz_184 || _zz_185) || _zz_186) || _zz_187) || _zz_188) || _zz_189) || _zz_190) || _zz_191);
  assign s1_outputPayload_sel_3 = {_zz_195,{_zz_194,{_zz_193,_zz_192}}};
  assign _zz_196 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b0100));
  assign _zz_197 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b0100));
  assign _zz_198 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b0100));
  assign _zz_199 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b0100));
  assign _zz_200 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b0100));
  assign _zz_201 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b0100));
  assign _zz_202 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b0100));
  assign _zz_203 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b0100));
  assign _zz_204 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b0100));
  assign _zz_205 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b0100));
  assign _zz_206 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b0100));
  assign _zz_207 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b0100));
  assign _zz_208 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b0100));
  assign _zz_209 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b0100));
  assign _zz_210 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b0100));
  assign _zz_211 = (((((((_zz_196 || _zz_198) || _zz_200) || _zz_202) || _zz_204) || _zz_206) || _zz_208) || _zz_210);
  assign _zz_212 = (((((((_zz_197 || _zz_198) || _zz_201) || _zz_202) || _zz_205) || _zz_206) || _zz_209) || _zz_210);
  assign _zz_213 = (((((((_zz_199 || _zz_200) || _zz_201) || _zz_202) || _zz_207) || _zz_208) || _zz_209) || _zz_210);
  assign _zz_214 = (((((((_zz_203 || _zz_204) || _zz_205) || _zz_206) || _zz_207) || _zz_208) || _zz_209) || _zz_210);
  assign s1_outputPayload_sel_4 = {_zz_214,{_zz_213,{_zz_212,_zz_211}}};
  assign _zz_215 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b0101));
  assign _zz_216 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b0101));
  assign _zz_217 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b0101));
  assign _zz_218 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b0101));
  assign _zz_219 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b0101));
  assign _zz_220 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b0101));
  assign _zz_221 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b0101));
  assign _zz_222 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b0101));
  assign _zz_223 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b0101));
  assign _zz_224 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b0101));
  assign _zz_225 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b0101));
  assign _zz_226 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b0101));
  assign _zz_227 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b0101));
  assign _zz_228 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b0101));
  assign _zz_229 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b0101));
  assign _zz_230 = (((((((_zz_215 || _zz_217) || _zz_219) || _zz_221) || _zz_223) || _zz_225) || _zz_227) || _zz_229);
  assign _zz_231 = (((((((_zz_216 || _zz_217) || _zz_220) || _zz_221) || _zz_224) || _zz_225) || _zz_228) || _zz_229);
  assign _zz_232 = (((((((_zz_218 || _zz_219) || _zz_220) || _zz_221) || _zz_226) || _zz_227) || _zz_228) || _zz_229);
  assign _zz_233 = (((((((_zz_222 || _zz_223) || _zz_224) || _zz_225) || _zz_226) || _zz_227) || _zz_228) || _zz_229);
  assign s1_outputPayload_sel_5 = {_zz_233,{_zz_232,{_zz_231,_zz_230}}};
  assign _zz_234 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b0110));
  assign _zz_235 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b0110));
  assign _zz_236 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b0110));
  assign _zz_237 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b0110));
  assign _zz_238 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b0110));
  assign _zz_239 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b0110));
  assign _zz_240 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b0110));
  assign _zz_241 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b0110));
  assign _zz_242 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b0110));
  assign _zz_243 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b0110));
  assign _zz_244 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b0110));
  assign _zz_245 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b0110));
  assign _zz_246 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b0110));
  assign _zz_247 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b0110));
  assign _zz_248 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b0110));
  assign _zz_249 = (((((((_zz_234 || _zz_236) || _zz_238) || _zz_240) || _zz_242) || _zz_244) || _zz_246) || _zz_248);
  assign _zz_250 = (((((((_zz_235 || _zz_236) || _zz_239) || _zz_240) || _zz_243) || _zz_244) || _zz_247) || _zz_248);
  assign _zz_251 = (((((((_zz_237 || _zz_238) || _zz_239) || _zz_240) || _zz_245) || _zz_246) || _zz_247) || _zz_248);
  assign _zz_252 = (((((((_zz_241 || _zz_242) || _zz_243) || _zz_244) || _zz_245) || _zz_246) || _zz_247) || _zz_248);
  assign s1_outputPayload_sel_6 = {_zz_252,{_zz_251,{_zz_250,_zz_249}}};
  assign _zz_253 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b0111));
  assign _zz_254 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b0111));
  assign _zz_255 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b0111));
  assign _zz_256 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b0111));
  assign _zz_257 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b0111));
  assign _zz_258 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b0111));
  assign _zz_259 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b0111));
  assign _zz_260 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b0111));
  assign _zz_261 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b0111));
  assign _zz_262 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b0111));
  assign _zz_263 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b0111));
  assign _zz_264 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b0111));
  assign _zz_265 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b0111));
  assign _zz_266 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b0111));
  assign _zz_267 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b0111));
  assign _zz_268 = (((((((_zz_253 || _zz_255) || _zz_257) || _zz_259) || _zz_261) || _zz_263) || _zz_265) || _zz_267);
  assign _zz_269 = (((((((_zz_254 || _zz_255) || _zz_258) || _zz_259) || _zz_262) || _zz_263) || _zz_266) || _zz_267);
  assign _zz_270 = (((((((_zz_256 || _zz_257) || _zz_258) || _zz_259) || _zz_264) || _zz_265) || _zz_266) || _zz_267);
  assign _zz_271 = (((((((_zz_260 || _zz_261) || _zz_262) || _zz_263) || _zz_264) || _zz_265) || _zz_266) || _zz_267);
  assign s1_outputPayload_sel_7 = {_zz_271,{_zz_270,{_zz_269,_zz_268}}};
  assign _zz_272 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b1000));
  assign _zz_273 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b1000));
  assign _zz_274 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b1000));
  assign _zz_275 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b1000));
  assign _zz_276 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b1000));
  assign _zz_277 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b1000));
  assign _zz_278 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b1000));
  assign _zz_279 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b1000));
  assign _zz_280 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b1000));
  assign _zz_281 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b1000));
  assign _zz_282 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b1000));
  assign _zz_283 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b1000));
  assign _zz_284 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b1000));
  assign _zz_285 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b1000));
  assign _zz_286 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b1000));
  assign _zz_287 = (((((((_zz_272 || _zz_274) || _zz_276) || _zz_278) || _zz_280) || _zz_282) || _zz_284) || _zz_286);
  assign _zz_288 = (((((((_zz_273 || _zz_274) || _zz_277) || _zz_278) || _zz_281) || _zz_282) || _zz_285) || _zz_286);
  assign _zz_289 = (((((((_zz_275 || _zz_276) || _zz_277) || _zz_278) || _zz_283) || _zz_284) || _zz_285) || _zz_286);
  assign _zz_290 = (((((((_zz_279 || _zz_280) || _zz_281) || _zz_282) || _zz_283) || _zz_284) || _zz_285) || _zz_286);
  assign s1_outputPayload_sel_8 = {_zz_290,{_zz_289,{_zz_288,_zz_287}}};
  assign _zz_291 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b1001));
  assign _zz_292 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b1001));
  assign _zz_293 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b1001));
  assign _zz_294 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b1001));
  assign _zz_295 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b1001));
  assign _zz_296 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b1001));
  assign _zz_297 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b1001));
  assign _zz_298 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b1001));
  assign _zz_299 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b1001));
  assign _zz_300 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b1001));
  assign _zz_301 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b1001));
  assign _zz_302 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b1001));
  assign _zz_303 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b1001));
  assign _zz_304 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b1001));
  assign _zz_305 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b1001));
  assign _zz_306 = (((((((_zz_291 || _zz_293) || _zz_295) || _zz_297) || _zz_299) || _zz_301) || _zz_303) || _zz_305);
  assign _zz_307 = (((((((_zz_292 || _zz_293) || _zz_296) || _zz_297) || _zz_300) || _zz_301) || _zz_304) || _zz_305);
  assign _zz_308 = (((((((_zz_294 || _zz_295) || _zz_296) || _zz_297) || _zz_302) || _zz_303) || _zz_304) || _zz_305);
  assign _zz_309 = (((((((_zz_298 || _zz_299) || _zz_300) || _zz_301) || _zz_302) || _zz_303) || _zz_304) || _zz_305);
  assign s1_outputPayload_sel_9 = {_zz_309,{_zz_308,{_zz_307,_zz_306}}};
  assign _zz_310 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b1010));
  assign _zz_311 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b1010));
  assign _zz_312 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b1010));
  assign _zz_313 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b1010));
  assign _zz_314 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b1010));
  assign _zz_315 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b1010));
  assign _zz_316 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b1010));
  assign _zz_317 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b1010));
  assign _zz_318 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b1010));
  assign _zz_319 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b1010));
  assign _zz_320 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b1010));
  assign _zz_321 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b1010));
  assign _zz_322 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b1010));
  assign _zz_323 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b1010));
  assign _zz_324 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b1010));
  assign _zz_325 = (((((((_zz_310 || _zz_312) || _zz_314) || _zz_316) || _zz_318) || _zz_320) || _zz_322) || _zz_324);
  assign _zz_326 = (((((((_zz_311 || _zz_312) || _zz_315) || _zz_316) || _zz_319) || _zz_320) || _zz_323) || _zz_324);
  assign _zz_327 = (((((((_zz_313 || _zz_314) || _zz_315) || _zz_316) || _zz_321) || _zz_322) || _zz_323) || _zz_324);
  assign _zz_328 = (((((((_zz_317 || _zz_318) || _zz_319) || _zz_320) || _zz_321) || _zz_322) || _zz_323) || _zz_324);
  assign s1_outputPayload_sel_10 = {_zz_328,{_zz_327,{_zz_326,_zz_325}}};
  assign _zz_329 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b1011));
  assign _zz_330 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b1011));
  assign _zz_331 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b1011));
  assign _zz_332 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b1011));
  assign _zz_333 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b1011));
  assign _zz_334 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b1011));
  assign _zz_335 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b1011));
  assign _zz_336 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b1011));
  assign _zz_337 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b1011));
  assign _zz_338 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b1011));
  assign _zz_339 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b1011));
  assign _zz_340 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b1011));
  assign _zz_341 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b1011));
  assign _zz_342 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b1011));
  assign _zz_343 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b1011));
  assign _zz_344 = (((((((_zz_329 || _zz_331) || _zz_333) || _zz_335) || _zz_337) || _zz_339) || _zz_341) || _zz_343);
  assign _zz_345 = (((((((_zz_330 || _zz_331) || _zz_334) || _zz_335) || _zz_338) || _zz_339) || _zz_342) || _zz_343);
  assign _zz_346 = (((((((_zz_332 || _zz_333) || _zz_334) || _zz_335) || _zz_340) || _zz_341) || _zz_342) || _zz_343);
  assign _zz_347 = (((((((_zz_336 || _zz_337) || _zz_338) || _zz_339) || _zz_340) || _zz_341) || _zz_342) || _zz_343);
  assign s1_outputPayload_sel_11 = {_zz_347,{_zz_346,{_zz_345,_zz_344}}};
  assign _zz_348 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b1100));
  assign _zz_349 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b1100));
  assign _zz_350 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b1100));
  assign _zz_351 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b1100));
  assign _zz_352 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b1100));
  assign _zz_353 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b1100));
  assign _zz_354 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b1100));
  assign _zz_355 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b1100));
  assign _zz_356 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b1100));
  assign _zz_357 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b1100));
  assign _zz_358 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b1100));
  assign _zz_359 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b1100));
  assign _zz_360 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b1100));
  assign _zz_361 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b1100));
  assign _zz_362 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b1100));
  assign _zz_363 = (((((((_zz_348 || _zz_350) || _zz_352) || _zz_354) || _zz_356) || _zz_358) || _zz_360) || _zz_362);
  assign _zz_364 = (((((((_zz_349 || _zz_350) || _zz_353) || _zz_354) || _zz_357) || _zz_358) || _zz_361) || _zz_362);
  assign _zz_365 = (((((((_zz_351 || _zz_352) || _zz_353) || _zz_354) || _zz_359) || _zz_360) || _zz_361) || _zz_362);
  assign _zz_366 = (((((((_zz_355 || _zz_356) || _zz_357) || _zz_358) || _zz_359) || _zz_360) || _zz_361) || _zz_362);
  assign s1_outputPayload_sel_12 = {_zz_366,{_zz_365,{_zz_364,_zz_363}}};
  assign _zz_367 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b1101));
  assign _zz_368 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b1101));
  assign _zz_369 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b1101));
  assign _zz_370 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b1101));
  assign _zz_371 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b1101));
  assign _zz_372 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b1101));
  assign _zz_373 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b1101));
  assign _zz_374 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b1101));
  assign _zz_375 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b1101));
  assign _zz_376 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b1101));
  assign _zz_377 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b1101));
  assign _zz_378 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b1101));
  assign _zz_379 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b1101));
  assign _zz_380 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b1101));
  assign _zz_381 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b1101));
  assign _zz_382 = (((((((_zz_367 || _zz_369) || _zz_371) || _zz_373) || _zz_375) || _zz_377) || _zz_379) || _zz_381);
  assign _zz_383 = (((((((_zz_368 || _zz_369) || _zz_372) || _zz_373) || _zz_376) || _zz_377) || _zz_380) || _zz_381);
  assign _zz_384 = (((((((_zz_370 || _zz_371) || _zz_372) || _zz_373) || _zz_378) || _zz_379) || _zz_380) || _zz_381);
  assign _zz_385 = (((((((_zz_374 || _zz_375) || _zz_376) || _zz_377) || _zz_378) || _zz_379) || _zz_380) || _zz_381);
  assign s1_outputPayload_sel_13 = {_zz_385,{_zz_384,{_zz_383,_zz_382}}};
  assign _zz_386 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b1110));
  assign _zz_387 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b1110));
  assign _zz_388 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b1110));
  assign _zz_389 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b1110));
  assign _zz_390 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b1110));
  assign _zz_391 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b1110));
  assign _zz_392 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b1110));
  assign _zz_393 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b1110));
  assign _zz_394 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b1110));
  assign _zz_395 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b1110));
  assign _zz_396 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b1110));
  assign _zz_397 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b1110));
  assign _zz_398 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b1110));
  assign _zz_399 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b1110));
  assign _zz_400 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b1110));
  assign _zz_401 = (((((((_zz_386 || _zz_388) || _zz_390) || _zz_392) || _zz_394) || _zz_396) || _zz_398) || _zz_400);
  assign _zz_402 = (((((((_zz_387 || _zz_388) || _zz_391) || _zz_392) || _zz_395) || _zz_396) || _zz_399) || _zz_400);
  assign _zz_403 = (((((((_zz_389 || _zz_390) || _zz_391) || _zz_392) || _zz_397) || _zz_398) || _zz_399) || _zz_400);
  assign _zz_404 = (((((((_zz_393 || _zz_394) || _zz_395) || _zz_396) || _zz_397) || _zz_398) || _zz_399) || _zz_400);
  assign s1_outputPayload_sel_14 = {_zz_404,{_zz_403,{_zz_402,_zz_401}}};
  assign _zz_405 = (s1_input_payload_cmd_mask[1] && (s1_inputIndexes_1 == 4'b1111));
  assign _zz_406 = (s1_input_payload_cmd_mask[2] && (s1_inputIndexes_2 == 4'b1111));
  assign _zz_407 = (s1_input_payload_cmd_mask[3] && (s1_inputIndexes_3 == 4'b1111));
  assign _zz_408 = (s1_input_payload_cmd_mask[4] && (s1_inputIndexes_4 == 4'b1111));
  assign _zz_409 = (s1_input_payload_cmd_mask[5] && (s1_inputIndexes_5 == 4'b1111));
  assign _zz_410 = (s1_input_payload_cmd_mask[6] && (s1_inputIndexes_6 == 4'b1111));
  assign _zz_411 = (s1_input_payload_cmd_mask[7] && (s1_inputIndexes_7 == 4'b1111));
  assign _zz_412 = (s1_input_payload_cmd_mask[8] && (s1_inputIndexes_8 == 4'b1111));
  assign _zz_413 = (s1_input_payload_cmd_mask[9] && (s1_inputIndexes_9 == 4'b1111));
  assign _zz_414 = (s1_input_payload_cmd_mask[10] && (s1_inputIndexes_10 == 4'b1111));
  assign _zz_415 = (s1_input_payload_cmd_mask[11] && (s1_inputIndexes_11 == 4'b1111));
  assign _zz_416 = (s1_input_payload_cmd_mask[12] && (s1_inputIndexes_12 == 4'b1111));
  assign _zz_417 = (s1_input_payload_cmd_mask[13] && (s1_inputIndexes_13 == 4'b1111));
  assign _zz_418 = (s1_input_payload_cmd_mask[14] && (s1_inputIndexes_14 == 4'b1111));
  assign _zz_419 = (s1_input_payload_cmd_mask[15] && (s1_inputIndexes_15 == 4'b1111));
  assign _zz_420 = (((((((_zz_405 || _zz_407) || _zz_409) || _zz_411) || _zz_413) || _zz_415) || _zz_417) || _zz_419);
  assign _zz_421 = (((((((_zz_406 || _zz_407) || _zz_410) || _zz_411) || _zz_414) || _zz_415) || _zz_418) || _zz_419);
  assign _zz_422 = (((((((_zz_408 || _zz_409) || _zz_410) || _zz_411) || _zz_416) || _zz_417) || _zz_418) || _zz_419);
  assign _zz_423 = (((((((_zz_412 || _zz_413) || _zz_414) || _zz_415) || _zz_416) || _zz_417) || _zz_418) || _zz_419);
  assign s1_outputPayload_sel_15 = {_zz_423,{_zz_422,{_zz_421,_zz_420}}};
  assign s1_output_valid = s1_input_valid;
  assign s1_input_ready = s1_output_ready;
  assign s1_output_payload_cmd_data = s1_outputPayload_cmd_data;
  assign s1_output_payload_cmd_mask = s1_outputPayload_cmd_mask;
  assign s1_output_payload_index_0 = s1_outputPayload_index_0;
  assign s1_output_payload_index_1 = s1_outputPayload_index_1;
  assign s1_output_payload_index_2 = s1_outputPayload_index_2;
  assign s1_output_payload_index_3 = s1_outputPayload_index_3;
  assign s1_output_payload_index_4 = s1_outputPayload_index_4;
  assign s1_output_payload_index_5 = s1_outputPayload_index_5;
  assign s1_output_payload_index_6 = s1_outputPayload_index_6;
  assign s1_output_payload_index_7 = s1_outputPayload_index_7;
  assign s1_output_payload_index_8 = s1_outputPayload_index_8;
  assign s1_output_payload_index_9 = s1_outputPayload_index_9;
  assign s1_output_payload_index_10 = s1_outputPayload_index_10;
  assign s1_output_payload_index_11 = s1_outputPayload_index_11;
  assign s1_output_payload_index_12 = s1_outputPayload_index_12;
  assign s1_output_payload_index_13 = s1_outputPayload_index_13;
  assign s1_output_payload_index_14 = s1_outputPayload_index_14;
  assign s1_output_payload_index_15 = s1_outputPayload_index_15;
  assign s1_output_payload_last = s1_outputPayload_last;
  assign s1_output_payload_sel_0 = s1_outputPayload_sel_0;
  assign s1_output_payload_sel_1 = s1_outputPayload_sel_1;
  assign s1_output_payload_sel_2 = s1_outputPayload_sel_2;
  assign s1_output_payload_sel_3 = s1_outputPayload_sel_3;
  assign s1_output_payload_sel_4 = s1_outputPayload_sel_4;
  assign s1_output_payload_sel_5 = s1_outputPayload_sel_5;
  assign s1_output_payload_sel_6 = s1_outputPayload_sel_6;
  assign s1_output_payload_sel_7 = s1_outputPayload_sel_7;
  assign s1_output_payload_sel_8 = s1_outputPayload_sel_8;
  assign s1_output_payload_sel_9 = s1_outputPayload_sel_9;
  assign s1_output_payload_sel_10 = s1_outputPayload_sel_10;
  assign s1_output_payload_sel_11 = s1_outputPayload_sel_11;
  assign s1_output_payload_sel_12 = s1_outputPayload_sel_12;
  assign s1_output_payload_sel_13 = s1_outputPayload_sel_13;
  assign s1_output_payload_sel_14 = s1_outputPayload_sel_14;
  assign s1_output_payload_sel_15 = s1_outputPayload_sel_15;
  assign s1_output_payload_selValid = s1_outputPayload_selValid;
  assign s1_output_ready = ((1'b1 && (! s2_input_valid)) || s2_input_ready);
  assign s2_input_valid = s1_output_m2sPipe_rValid;
  assign s2_input_payload_cmd_data = s1_output_m2sPipe_rData_cmd_data;
  assign s2_input_payload_cmd_mask = s1_output_m2sPipe_rData_cmd_mask;
  assign s2_input_payload_index_0 = s1_output_m2sPipe_rData_index_0;
  assign s2_input_payload_index_1 = s1_output_m2sPipe_rData_index_1;
  assign s2_input_payload_index_2 = s1_output_m2sPipe_rData_index_2;
  assign s2_input_payload_index_3 = s1_output_m2sPipe_rData_index_3;
  assign s2_input_payload_index_4 = s1_output_m2sPipe_rData_index_4;
  assign s2_input_payload_index_5 = s1_output_m2sPipe_rData_index_5;
  assign s2_input_payload_index_6 = s1_output_m2sPipe_rData_index_6;
  assign s2_input_payload_index_7 = s1_output_m2sPipe_rData_index_7;
  assign s2_input_payload_index_8 = s1_output_m2sPipe_rData_index_8;
  assign s2_input_payload_index_9 = s1_output_m2sPipe_rData_index_9;
  assign s2_input_payload_index_10 = s1_output_m2sPipe_rData_index_10;
  assign s2_input_payload_index_11 = s1_output_m2sPipe_rData_index_11;
  assign s2_input_payload_index_12 = s1_output_m2sPipe_rData_index_12;
  assign s2_input_payload_index_13 = s1_output_m2sPipe_rData_index_13;
  assign s2_input_payload_index_14 = s1_output_m2sPipe_rData_index_14;
  assign s2_input_payload_index_15 = s1_output_m2sPipe_rData_index_15;
  assign s2_input_payload_last = s1_output_m2sPipe_rData_last;
  assign s2_input_payload_sel_0 = s1_output_m2sPipe_rData_sel_0;
  assign s2_input_payload_sel_1 = s1_output_m2sPipe_rData_sel_1;
  assign s2_input_payload_sel_2 = s1_output_m2sPipe_rData_sel_2;
  assign s2_input_payload_sel_3 = s1_output_m2sPipe_rData_sel_3;
  assign s2_input_payload_sel_4 = s1_output_m2sPipe_rData_sel_4;
  assign s2_input_payload_sel_5 = s1_output_m2sPipe_rData_sel_5;
  assign s2_input_payload_sel_6 = s1_output_m2sPipe_rData_sel_6;
  assign s2_input_payload_sel_7 = s1_output_m2sPipe_rData_sel_7;
  assign s2_input_payload_sel_8 = s1_output_m2sPipe_rData_sel_8;
  assign s2_input_payload_sel_9 = s1_output_m2sPipe_rData_sel_9;
  assign s2_input_payload_sel_10 = s1_output_m2sPipe_rData_sel_10;
  assign s2_input_payload_sel_11 = s1_output_m2sPipe_rData_sel_11;
  assign s2_input_payload_sel_12 = s1_output_m2sPipe_rData_sel_12;
  assign s2_input_payload_sel_13 = s1_output_m2sPipe_rData_sel_13;
  assign s2_input_payload_sel_14 = s1_output_m2sPipe_rData_sel_14;
  assign s2_input_payload_sel_15 = s1_output_m2sPipe_rData_sel_15;
  assign s2_input_payload_selValid = s1_output_m2sPipe_rData_selValid;
  always @ (*) begin
    s2_input_ready = ((! io_output_enough) || io_output_consume);
    if((_zz_545 < s1_byteCounter))begin
      s2_input_ready = 1'b0;
    end
  end

  assign io_output_consumed = (s2_input_valid && s2_input_ready);
  assign s2_inputDataBytes_0 = s2_input_payload_cmd_data[7 : 0];
  assign s2_inputDataBytes_1 = s2_input_payload_cmd_data[15 : 8];
  assign s2_inputDataBytes_2 = s2_input_payload_cmd_data[23 : 16];
  assign s2_inputDataBytes_3 = s2_input_payload_cmd_data[31 : 24];
  assign s2_inputDataBytes_4 = s2_input_payload_cmd_data[39 : 32];
  assign s2_inputDataBytes_5 = s2_input_payload_cmd_data[47 : 40];
  assign s2_inputDataBytes_6 = s2_input_payload_cmd_data[55 : 48];
  assign s2_inputDataBytes_7 = s2_input_payload_cmd_data[63 : 56];
  assign s2_inputDataBytes_8 = s2_input_payload_cmd_data[71 : 64];
  assign s2_inputDataBytes_9 = s2_input_payload_cmd_data[79 : 72];
  assign s2_inputDataBytes_10 = s2_input_payload_cmd_data[87 : 80];
  assign s2_inputDataBytes_11 = s2_input_payload_cmd_data[95 : 88];
  assign s2_inputDataBytes_12 = s2_input_payload_cmd_data[103 : 96];
  assign s2_inputDataBytes_13 = s2_input_payload_cmd_data[111 : 104];
  assign s2_inputDataBytes_14 = s2_input_payload_cmd_data[119 : 112];
  assign s2_inputDataBytes_15 = s2_input_payload_cmd_data[127 : 120];
  assign s2_byteLogic_0_lastUsed = (4'b0000 == io_output_lastByteUsed);
  assign s2_byteLogic_0_inputMask = s2_input_payload_selValid[0];
  assign s2_byteLogic_0_inputData = _zz_479;
  assign s2_byteLogic_0_outputMask = (s2_byteLogic_0_buffer_valid || (s2_input_valid && s2_byteLogic_0_inputMask));
  assign s2_byteLogic_0_outputData = (s2_byteLogic_0_buffer_valid ? s2_byteLogic_0_buffer_data : s2_byteLogic_0_inputData);
  always @ (*) begin
    io_output_mask[0] = s2_byteLogic_0_outputMask;
    io_output_mask[1] = s2_byteLogic_1_outputMask;
    io_output_mask[2] = s2_byteLogic_2_outputMask;
    io_output_mask[3] = s2_byteLogic_3_outputMask;
    io_output_mask[4] = s2_byteLogic_4_outputMask;
    io_output_mask[5] = s2_byteLogic_5_outputMask;
    io_output_mask[6] = s2_byteLogic_6_outputMask;
    io_output_mask[7] = s2_byteLogic_7_outputMask;
    io_output_mask[8] = s2_byteLogic_8_outputMask;
    io_output_mask[9] = s2_byteLogic_9_outputMask;
    io_output_mask[10] = s2_byteLogic_10_outputMask;
    io_output_mask[11] = s2_byteLogic_11_outputMask;
    io_output_mask[12] = s2_byteLogic_12_outputMask;
    io_output_mask[13] = s2_byteLogic_13_outputMask;
    io_output_mask[14] = s2_byteLogic_14_outputMask;
    io_output_mask[15] = s2_byteLogic_15_outputMask;
  end

  always @ (*) begin
    io_output_data[7 : 0] = s2_byteLogic_0_outputData;
    io_output_data[15 : 8] = s2_byteLogic_1_outputData;
    io_output_data[23 : 16] = s2_byteLogic_2_outputData;
    io_output_data[31 : 24] = s2_byteLogic_3_outputData;
    io_output_data[39 : 32] = s2_byteLogic_4_outputData;
    io_output_data[47 : 40] = s2_byteLogic_5_outputData;
    io_output_data[55 : 48] = s2_byteLogic_6_outputData;
    io_output_data[63 : 56] = s2_byteLogic_7_outputData;
    io_output_data[71 : 64] = s2_byteLogic_8_outputData;
    io_output_data[79 : 72] = s2_byteLogic_9_outputData;
    io_output_data[87 : 80] = s2_byteLogic_10_outputData;
    io_output_data[95 : 88] = s2_byteLogic_11_outputData;
    io_output_data[103 : 96] = s2_byteLogic_12_outputData;
    io_output_data[111 : 104] = s2_byteLogic_13_outputData;
    io_output_data[119 : 112] = s2_byteLogic_14_outputData;
    io_output_data[127 : 120] = s2_byteLogic_15_outputData;
  end

  assign s2_byteLogic_1_lastUsed = (4'b0001 == io_output_lastByteUsed);
  assign s2_byteLogic_1_inputMask = s2_input_payload_selValid[1];
  assign s2_byteLogic_1_inputData = _zz_480;
  assign s2_byteLogic_1_outputMask = (s2_byteLogic_1_buffer_valid || (s2_input_valid && s2_byteLogic_1_inputMask));
  assign s2_byteLogic_1_outputData = (s2_byteLogic_1_buffer_valid ? s2_byteLogic_1_buffer_data : s2_byteLogic_1_inputData);
  assign s2_byteLogic_2_lastUsed = (4'b0010 == io_output_lastByteUsed);
  assign s2_byteLogic_2_inputMask = s2_input_payload_selValid[2];
  assign s2_byteLogic_2_inputData = _zz_481;
  assign s2_byteLogic_2_outputMask = (s2_byteLogic_2_buffer_valid || (s2_input_valid && s2_byteLogic_2_inputMask));
  assign s2_byteLogic_2_outputData = (s2_byteLogic_2_buffer_valid ? s2_byteLogic_2_buffer_data : s2_byteLogic_2_inputData);
  assign s2_byteLogic_3_lastUsed = (4'b0011 == io_output_lastByteUsed);
  assign s2_byteLogic_3_inputMask = s2_input_payload_selValid[3];
  assign s2_byteLogic_3_inputData = _zz_482;
  assign s2_byteLogic_3_outputMask = (s2_byteLogic_3_buffer_valid || (s2_input_valid && s2_byteLogic_3_inputMask));
  assign s2_byteLogic_3_outputData = (s2_byteLogic_3_buffer_valid ? s2_byteLogic_3_buffer_data : s2_byteLogic_3_inputData);
  assign s2_byteLogic_4_lastUsed = (4'b0100 == io_output_lastByteUsed);
  assign s2_byteLogic_4_inputMask = s2_input_payload_selValid[4];
  assign s2_byteLogic_4_inputData = _zz_483;
  assign s2_byteLogic_4_outputMask = (s2_byteLogic_4_buffer_valid || (s2_input_valid && s2_byteLogic_4_inputMask));
  assign s2_byteLogic_4_outputData = (s2_byteLogic_4_buffer_valid ? s2_byteLogic_4_buffer_data : s2_byteLogic_4_inputData);
  assign s2_byteLogic_5_lastUsed = (4'b0101 == io_output_lastByteUsed);
  assign s2_byteLogic_5_inputMask = s2_input_payload_selValid[5];
  assign s2_byteLogic_5_inputData = _zz_484;
  assign s2_byteLogic_5_outputMask = (s2_byteLogic_5_buffer_valid || (s2_input_valid && s2_byteLogic_5_inputMask));
  assign s2_byteLogic_5_outputData = (s2_byteLogic_5_buffer_valid ? s2_byteLogic_5_buffer_data : s2_byteLogic_5_inputData);
  assign s2_byteLogic_6_lastUsed = (4'b0110 == io_output_lastByteUsed);
  assign s2_byteLogic_6_inputMask = s2_input_payload_selValid[6];
  assign s2_byteLogic_6_inputData = _zz_485;
  assign s2_byteLogic_6_outputMask = (s2_byteLogic_6_buffer_valid || (s2_input_valid && s2_byteLogic_6_inputMask));
  assign s2_byteLogic_6_outputData = (s2_byteLogic_6_buffer_valid ? s2_byteLogic_6_buffer_data : s2_byteLogic_6_inputData);
  assign s2_byteLogic_7_lastUsed = (4'b0111 == io_output_lastByteUsed);
  assign s2_byteLogic_7_inputMask = s2_input_payload_selValid[7];
  assign s2_byteLogic_7_inputData = _zz_486;
  assign s2_byteLogic_7_outputMask = (s2_byteLogic_7_buffer_valid || (s2_input_valid && s2_byteLogic_7_inputMask));
  assign s2_byteLogic_7_outputData = (s2_byteLogic_7_buffer_valid ? s2_byteLogic_7_buffer_data : s2_byteLogic_7_inputData);
  assign s2_byteLogic_8_lastUsed = (4'b1000 == io_output_lastByteUsed);
  assign s2_byteLogic_8_inputMask = s2_input_payload_selValid[8];
  assign s2_byteLogic_8_inputData = _zz_487;
  assign s2_byteLogic_8_outputMask = (s2_byteLogic_8_buffer_valid || (s2_input_valid && s2_byteLogic_8_inputMask));
  assign s2_byteLogic_8_outputData = (s2_byteLogic_8_buffer_valid ? s2_byteLogic_8_buffer_data : s2_byteLogic_8_inputData);
  assign s2_byteLogic_9_lastUsed = (4'b1001 == io_output_lastByteUsed);
  assign s2_byteLogic_9_inputMask = s2_input_payload_selValid[9];
  assign s2_byteLogic_9_inputData = _zz_488;
  assign s2_byteLogic_9_outputMask = (s2_byteLogic_9_buffer_valid || (s2_input_valid && s2_byteLogic_9_inputMask));
  assign s2_byteLogic_9_outputData = (s2_byteLogic_9_buffer_valid ? s2_byteLogic_9_buffer_data : s2_byteLogic_9_inputData);
  assign s2_byteLogic_10_lastUsed = (4'b1010 == io_output_lastByteUsed);
  assign s2_byteLogic_10_inputMask = s2_input_payload_selValid[10];
  assign s2_byteLogic_10_inputData = _zz_489;
  assign s2_byteLogic_10_outputMask = (s2_byteLogic_10_buffer_valid || (s2_input_valid && s2_byteLogic_10_inputMask));
  assign s2_byteLogic_10_outputData = (s2_byteLogic_10_buffer_valid ? s2_byteLogic_10_buffer_data : s2_byteLogic_10_inputData);
  assign s2_byteLogic_11_lastUsed = (4'b1011 == io_output_lastByteUsed);
  assign s2_byteLogic_11_inputMask = s2_input_payload_selValid[11];
  assign s2_byteLogic_11_inputData = _zz_490;
  assign s2_byteLogic_11_outputMask = (s2_byteLogic_11_buffer_valid || (s2_input_valid && s2_byteLogic_11_inputMask));
  assign s2_byteLogic_11_outputData = (s2_byteLogic_11_buffer_valid ? s2_byteLogic_11_buffer_data : s2_byteLogic_11_inputData);
  assign s2_byteLogic_12_lastUsed = (4'b1100 == io_output_lastByteUsed);
  assign s2_byteLogic_12_inputMask = s2_input_payload_selValid[12];
  assign s2_byteLogic_12_inputData = _zz_491;
  assign s2_byteLogic_12_outputMask = (s2_byteLogic_12_buffer_valid || (s2_input_valid && s2_byteLogic_12_inputMask));
  assign s2_byteLogic_12_outputData = (s2_byteLogic_12_buffer_valid ? s2_byteLogic_12_buffer_data : s2_byteLogic_12_inputData);
  assign s2_byteLogic_13_lastUsed = (4'b1101 == io_output_lastByteUsed);
  assign s2_byteLogic_13_inputMask = s2_input_payload_selValid[13];
  assign s2_byteLogic_13_inputData = _zz_492;
  assign s2_byteLogic_13_outputMask = (s2_byteLogic_13_buffer_valid || (s2_input_valid && s2_byteLogic_13_inputMask));
  assign s2_byteLogic_13_outputData = (s2_byteLogic_13_buffer_valid ? s2_byteLogic_13_buffer_data : s2_byteLogic_13_inputData);
  assign s2_byteLogic_14_lastUsed = (4'b1110 == io_output_lastByteUsed);
  assign s2_byteLogic_14_inputMask = s2_input_payload_selValid[14];
  assign s2_byteLogic_14_inputData = _zz_493;
  assign s2_byteLogic_14_outputMask = (s2_byteLogic_14_buffer_valid || (s2_input_valid && s2_byteLogic_14_inputMask));
  assign s2_byteLogic_14_outputData = (s2_byteLogic_14_buffer_valid ? s2_byteLogic_14_buffer_data : s2_byteLogic_14_inputData);
  assign s2_byteLogic_15_lastUsed = (4'b1111 == io_output_lastByteUsed);
  assign s2_byteLogic_15_inputMask = s2_input_payload_selValid[15];
  assign s2_byteLogic_15_inputData = _zz_494;
  assign s2_byteLogic_15_outputMask = (s2_byteLogic_15_buffer_valid || (s2_input_valid && s2_byteLogic_15_inputMask));
  assign s2_byteLogic_15_outputData = (s2_byteLogic_15_buffer_valid ? s2_byteLogic_15_buffer_data : s2_byteLogic_15_inputData);
  assign _zz_424 = (((((((s2_byteLogic_1_lastUsed || s2_byteLogic_3_lastUsed) || s2_byteLogic_5_lastUsed) || s2_byteLogic_7_lastUsed) || s2_byteLogic_9_lastUsed) || s2_byteLogic_11_lastUsed) || s2_byteLogic_13_lastUsed) || s2_byteLogic_15_lastUsed);
  assign _zz_425 = (((((((s2_byteLogic_2_lastUsed || s2_byteLogic_3_lastUsed) || s2_byteLogic_6_lastUsed) || s2_byteLogic_7_lastUsed) || s2_byteLogic_10_lastUsed) || s2_byteLogic_11_lastUsed) || s2_byteLogic_14_lastUsed) || s2_byteLogic_15_lastUsed);
  assign _zz_426 = (((((((s2_byteLogic_4_lastUsed || s2_byteLogic_5_lastUsed) || s2_byteLogic_6_lastUsed) || s2_byteLogic_7_lastUsed) || s2_byteLogic_12_lastUsed) || s2_byteLogic_13_lastUsed) || s2_byteLogic_14_lastUsed) || s2_byteLogic_15_lastUsed);
  assign _zz_427 = (((((((s2_byteLogic_8_lastUsed || s2_byteLogic_9_lastUsed) || s2_byteLogic_10_lastUsed) || s2_byteLogic_11_lastUsed) || s2_byteLogic_12_lastUsed) || s2_byteLogic_13_lastUsed) || s2_byteLogic_14_lastUsed) || s2_byteLogic_15_lastUsed);
  assign io_output_usedUntil = _zz_495;
  always @ (posedge clk) begin
    if(reset) begin
      io_input_m2sPipe_rValid <= 1'b0;
      s0_output_m2sPipe_rValid <= 1'b0;
      s1_output_m2sPipe_rValid <= 1'b0;
    end else begin
      if(io_input_ready)begin
        io_input_m2sPipe_rValid <= io_input_valid;
      end
      if(io_flush)begin
        io_input_m2sPipe_rValid <= 1'b0;
      end
      if(s0_output_ready)begin
        s0_output_m2sPipe_rValid <= s0_output_valid;
      end
      if(io_flush)begin
        s0_output_m2sPipe_rValid <= 1'b0;
      end
      if(s1_output_ready)begin
        s1_output_m2sPipe_rValid <= s1_output_valid;
      end
      if(io_flush)begin
        s1_output_m2sPipe_rValid <= 1'b0;
      end
    end
  end

  always @ (posedge clk) begin
    if(io_input_ready)begin
      io_input_m2sPipe_rData_data <= io_input_payload_data;
      io_input_m2sPipe_rData_mask <= io_input_payload_mask;
    end
    if(s0_output_ready)begin
      s0_output_m2sPipe_rData_cmd_data <= s0_output_payload_cmd_data;
      s0_output_m2sPipe_rData_cmd_mask <= s0_output_payload_cmd_mask;
      s0_output_m2sPipe_rData_countOnes_0 <= s0_output_payload_countOnes_0;
      s0_output_m2sPipe_rData_countOnes_1 <= s0_output_payload_countOnes_1;
      s0_output_m2sPipe_rData_countOnes_2 <= s0_output_payload_countOnes_2;
      s0_output_m2sPipe_rData_countOnes_3 <= s0_output_payload_countOnes_3;
      s0_output_m2sPipe_rData_countOnes_4 <= s0_output_payload_countOnes_4;
      s0_output_m2sPipe_rData_countOnes_5 <= s0_output_payload_countOnes_5;
      s0_output_m2sPipe_rData_countOnes_6 <= s0_output_payload_countOnes_6;
      s0_output_m2sPipe_rData_countOnes_7 <= s0_output_payload_countOnes_7;
      s0_output_m2sPipe_rData_countOnes_8 <= s0_output_payload_countOnes_8;
      s0_output_m2sPipe_rData_countOnes_9 <= s0_output_payload_countOnes_9;
      s0_output_m2sPipe_rData_countOnes_10 <= s0_output_payload_countOnes_10;
      s0_output_m2sPipe_rData_countOnes_11 <= s0_output_payload_countOnes_11;
      s0_output_m2sPipe_rData_countOnes_12 <= s0_output_payload_countOnes_12;
      s0_output_m2sPipe_rData_countOnes_13 <= s0_output_payload_countOnes_13;
      s0_output_m2sPipe_rData_countOnes_14 <= s0_output_payload_countOnes_14;
      s0_output_m2sPipe_rData_countOnes_15 <= s0_output_payload_countOnes_15;
    end
    if((s1_input_valid && s1_input_ready))begin
      s1_offset <= s1_offsetNext[3:0];
    end
    if(io_flush)begin
      s1_offset <= io_offset;
    end
    if((s1_input_valid && s1_input_ready))begin
      s1_byteCounter <= (s1_byteCounter + _zz_537);
    end
    if(io_flush)begin
      s1_byteCounter <= 13'h0;
    end
    if(s1_output_ready)begin
      s1_output_m2sPipe_rData_cmd_data <= s1_output_payload_cmd_data;
      s1_output_m2sPipe_rData_cmd_mask <= s1_output_payload_cmd_mask;
      s1_output_m2sPipe_rData_index_0 <= s1_output_payload_index_0;
      s1_output_m2sPipe_rData_index_1 <= s1_output_payload_index_1;
      s1_output_m2sPipe_rData_index_2 <= s1_output_payload_index_2;
      s1_output_m2sPipe_rData_index_3 <= s1_output_payload_index_3;
      s1_output_m2sPipe_rData_index_4 <= s1_output_payload_index_4;
      s1_output_m2sPipe_rData_index_5 <= s1_output_payload_index_5;
      s1_output_m2sPipe_rData_index_6 <= s1_output_payload_index_6;
      s1_output_m2sPipe_rData_index_7 <= s1_output_payload_index_7;
      s1_output_m2sPipe_rData_index_8 <= s1_output_payload_index_8;
      s1_output_m2sPipe_rData_index_9 <= s1_output_payload_index_9;
      s1_output_m2sPipe_rData_index_10 <= s1_output_payload_index_10;
      s1_output_m2sPipe_rData_index_11 <= s1_output_payload_index_11;
      s1_output_m2sPipe_rData_index_12 <= s1_output_payload_index_12;
      s1_output_m2sPipe_rData_index_13 <= s1_output_payload_index_13;
      s1_output_m2sPipe_rData_index_14 <= s1_output_payload_index_14;
      s1_output_m2sPipe_rData_index_15 <= s1_output_payload_index_15;
      s1_output_m2sPipe_rData_last <= s1_output_payload_last;
      s1_output_m2sPipe_rData_sel_0 <= s1_output_payload_sel_0;
      s1_output_m2sPipe_rData_sel_1 <= s1_output_payload_sel_1;
      s1_output_m2sPipe_rData_sel_2 <= s1_output_payload_sel_2;
      s1_output_m2sPipe_rData_sel_3 <= s1_output_payload_sel_3;
      s1_output_m2sPipe_rData_sel_4 <= s1_output_payload_sel_4;
      s1_output_m2sPipe_rData_sel_5 <= s1_output_payload_sel_5;
      s1_output_m2sPipe_rData_sel_6 <= s1_output_payload_sel_6;
      s1_output_m2sPipe_rData_sel_7 <= s1_output_payload_sel_7;
      s1_output_m2sPipe_rData_sel_8 <= s1_output_payload_sel_8;
      s1_output_m2sPipe_rData_sel_9 <= s1_output_payload_sel_9;
      s1_output_m2sPipe_rData_sel_10 <= s1_output_payload_sel_10;
      s1_output_m2sPipe_rData_sel_11 <= s1_output_payload_sel_11;
      s1_output_m2sPipe_rData_sel_12 <= s1_output_payload_sel_12;
      s1_output_m2sPipe_rData_sel_13 <= s1_output_payload_sel_13;
      s1_output_m2sPipe_rData_sel_14 <= s1_output_payload_sel_14;
      s1_output_m2sPipe_rData_sel_15 <= s1_output_payload_sel_15;
      s1_output_m2sPipe_rData_selValid <= s1_output_payload_selValid;
    end
    if(io_output_consume)begin
      s2_byteLogic_0_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_0_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_0_inputMask && ((! io_output_consume) || s2_byteLogic_0_buffer_valid)))begin
        s2_byteLogic_0_buffer_valid <= 1'b1;
        s2_byteLogic_0_buffer_data <= s2_byteLogic_0_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_0_buffer_valid <= (4'b0000 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_1_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_1_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_1_inputMask && ((! io_output_consume) || s2_byteLogic_1_buffer_valid)))begin
        s2_byteLogic_1_buffer_valid <= 1'b1;
        s2_byteLogic_1_buffer_data <= s2_byteLogic_1_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_1_buffer_valid <= (4'b0001 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_2_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_2_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_2_inputMask && ((! io_output_consume) || s2_byteLogic_2_buffer_valid)))begin
        s2_byteLogic_2_buffer_valid <= 1'b1;
        s2_byteLogic_2_buffer_data <= s2_byteLogic_2_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_2_buffer_valid <= (4'b0010 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_3_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_3_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_3_inputMask && ((! io_output_consume) || s2_byteLogic_3_buffer_valid)))begin
        s2_byteLogic_3_buffer_valid <= 1'b1;
        s2_byteLogic_3_buffer_data <= s2_byteLogic_3_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_3_buffer_valid <= (4'b0011 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_4_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_4_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_4_inputMask && ((! io_output_consume) || s2_byteLogic_4_buffer_valid)))begin
        s2_byteLogic_4_buffer_valid <= 1'b1;
        s2_byteLogic_4_buffer_data <= s2_byteLogic_4_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_4_buffer_valid <= (4'b0100 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_5_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_5_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_5_inputMask && ((! io_output_consume) || s2_byteLogic_5_buffer_valid)))begin
        s2_byteLogic_5_buffer_valid <= 1'b1;
        s2_byteLogic_5_buffer_data <= s2_byteLogic_5_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_5_buffer_valid <= (4'b0101 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_6_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_6_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_6_inputMask && ((! io_output_consume) || s2_byteLogic_6_buffer_valid)))begin
        s2_byteLogic_6_buffer_valid <= 1'b1;
        s2_byteLogic_6_buffer_data <= s2_byteLogic_6_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_6_buffer_valid <= (4'b0110 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_7_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_7_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_7_inputMask && ((! io_output_consume) || s2_byteLogic_7_buffer_valid)))begin
        s2_byteLogic_7_buffer_valid <= 1'b1;
        s2_byteLogic_7_buffer_data <= s2_byteLogic_7_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_7_buffer_valid <= (4'b0111 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_8_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_8_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_8_inputMask && ((! io_output_consume) || s2_byteLogic_8_buffer_valid)))begin
        s2_byteLogic_8_buffer_valid <= 1'b1;
        s2_byteLogic_8_buffer_data <= s2_byteLogic_8_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_8_buffer_valid <= (4'b1000 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_9_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_9_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_9_inputMask && ((! io_output_consume) || s2_byteLogic_9_buffer_valid)))begin
        s2_byteLogic_9_buffer_valid <= 1'b1;
        s2_byteLogic_9_buffer_data <= s2_byteLogic_9_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_9_buffer_valid <= (4'b1001 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_10_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_10_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_10_inputMask && ((! io_output_consume) || s2_byteLogic_10_buffer_valid)))begin
        s2_byteLogic_10_buffer_valid <= 1'b1;
        s2_byteLogic_10_buffer_data <= s2_byteLogic_10_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_10_buffer_valid <= (4'b1010 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_11_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_11_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_11_inputMask && ((! io_output_consume) || s2_byteLogic_11_buffer_valid)))begin
        s2_byteLogic_11_buffer_valid <= 1'b1;
        s2_byteLogic_11_buffer_data <= s2_byteLogic_11_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_11_buffer_valid <= (4'b1011 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_12_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_12_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_12_inputMask && ((! io_output_consume) || s2_byteLogic_12_buffer_valid)))begin
        s2_byteLogic_12_buffer_valid <= 1'b1;
        s2_byteLogic_12_buffer_data <= s2_byteLogic_12_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_12_buffer_valid <= (4'b1100 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_13_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_13_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_13_inputMask && ((! io_output_consume) || s2_byteLogic_13_buffer_valid)))begin
        s2_byteLogic_13_buffer_valid <= 1'b1;
        s2_byteLogic_13_buffer_data <= s2_byteLogic_13_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_13_buffer_valid <= (4'b1101 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_14_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_14_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_14_inputMask && ((! io_output_consume) || s2_byteLogic_14_buffer_valid)))begin
        s2_byteLogic_14_buffer_valid <= 1'b1;
        s2_byteLogic_14_buffer_data <= s2_byteLogic_14_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_14_buffer_valid <= (4'b1110 < io_offset);
    end
    if(io_output_consume)begin
      s2_byteLogic_15_buffer_valid <= 1'b0;
    end
    if((s2_input_valid && s2_input_ready))begin
      if(s2_input_payload_last)begin
        s2_byteLogic_15_buffer_valid <= 1'b0;
      end
      if((s2_byteLogic_15_inputMask && ((! io_output_consume) || s2_byteLogic_15_buffer_valid)))begin
        s2_byteLogic_15_buffer_valid <= 1'b1;
        s2_byteLogic_15_buffer_data <= s2_byteLogic_15_inputData;
      end
    end
    if(io_flush)begin
      s2_byteLogic_15_buffer_valid <= (4'b1111 < io_offset);
    end
  end


endmodule

module dma_socRuby_DmaMemoryCore (
  input               io_writes_0_cmd_valid,
  output              io_writes_0_cmd_ready,
  input      [8:0]    io_writes_0_cmd_payload_address,
  input      [127:0]  io_writes_0_cmd_payload_data,
  input      [15:0]   io_writes_0_cmd_payload_mask,
  input      [1:0]    io_writes_0_cmd_payload_priority,
  input      [7:0]    io_writes_0_cmd_payload_context,
  output              io_writes_0_rsp_valid,
  output     [7:0]    io_writes_0_rsp_payload_context,
  input               io_writes_1_cmd_valid,
  output              io_writes_1_cmd_ready,
  input      [8:0]    io_writes_1_cmd_payload_address,
  input      [127:0]  io_writes_1_cmd_payload_data,
  input      [15:0]   io_writes_1_cmd_payload_mask,
  input      [1:0]    io_writes_1_cmd_payload_priority,
  input      [7:0]    io_writes_1_cmd_payload_context,
  output              io_writes_1_rsp_valid,
  output     [7:0]    io_writes_1_rsp_payload_context,
  input               io_writes_2_cmd_valid,
  output              io_writes_2_cmd_ready,
  input      [8:0]    io_writes_2_cmd_payload_address,
  input      [127:0]  io_writes_2_cmd_payload_data,
  input      [15:0]   io_writes_2_cmd_payload_mask,
  input      [7:0]    io_writes_2_cmd_payload_context,
  output              io_writes_2_rsp_valid,
  output     [7:0]    io_writes_2_rsp_payload_context,
  input               io_reads_0_cmd_valid,
  output              io_reads_0_cmd_ready,
  input      [8:0]    io_reads_0_cmd_payload_address,
  input      [1:0]    io_reads_0_cmd_payload_priority,
  input      [2:0]    io_reads_0_cmd_payload_context,
  output              io_reads_0_rsp_valid,
  input               io_reads_0_rsp_ready,
  output     [127:0]  io_reads_0_rsp_payload_data,
  output     [15:0]   io_reads_0_rsp_payload_mask,
  output     [2:0]    io_reads_0_rsp_payload_context,
  input               io_reads_1_cmd_valid,
  output              io_reads_1_cmd_ready,
  input      [8:0]    io_reads_1_cmd_payload_address,
  input      [1:0]    io_reads_1_cmd_payload_priority,
  input      [2:0]    io_reads_1_cmd_payload_context,
  output              io_reads_1_rsp_valid,
  input               io_reads_1_rsp_ready,
  output     [127:0]  io_reads_1_rsp_payload_data,
  output     [15:0]   io_reads_1_rsp_payload_mask,
  output     [2:0]    io_reads_1_rsp_payload_context,
  input               io_reads_2_cmd_valid,
  output              io_reads_2_cmd_ready,
  input      [8:0]    io_reads_2_cmd_payload_address,
  input      [10:0]   io_reads_2_cmd_payload_context,
  output              io_reads_2_rsp_valid,
  input               io_reads_2_rsp_ready,
  output     [127:0]  io_reads_2_rsp_payload_data,
  output     [15:0]   io_reads_2_rsp_payload_mask,
  output     [10:0]   io_reads_2_rsp_payload_context,
  input               clk,
  input               reset
);
  reg        [143:0]  _zz_52;
  reg        [143:0]  _zz_53;
  reg        [127:0]  _zz_54;
  reg        [15:0]   _zz_55;
  reg        [127:0]  _zz_56;
  reg        [15:0]   _zz_57;
  reg        [127:0]  _zz_58;
  reg        [15:0]   _zz_59;
  wire                _zz_60;
  wire                _zz_61;
  wire                _zz_62;
  wire                _zz_63;
  wire                _zz_64;
  wire                _zz_65;
  wire                _zz_66;
  wire                _zz_67;
  wire                _zz_68;
  wire                _zz_69;
  wire                _zz_70;
  wire                _zz_71;
  wire                _zz_72;
  wire                _zz_73;
  wire                _zz_74;
  wire       [7:0]    _zz_75;
  wire       [7:0]    _zz_76;
  wire       [8:0]    _zz_77;
  wire       [8:0]    _zz_78;
  wire       [8:0]    _zz_79;
  wire       [8:0]    _zz_80;
  wire       [8:0]    _zz_81;
  wire       [8:0]    _zz_82;
  wire       [7:0]    _zz_83;
  wire       [7:0]    _zz_84;
  wire       [8:0]    _zz_85;
  wire       [8:0]    _zz_86;
  wire       [8:0]    _zz_87;
  wire       [8:0]    _zz_88;
  wire       [8:0]    _zz_89;
  wire       [8:0]    _zz_90;
  wire       [0:0]    _zz_91;
  wire       [0:0]    _zz_92;
  wire       [0:0]    _zz_93;
  wire       [0:0]    _zz_94;
  wire       [143:0]  _zz_95;
  wire       [143:0]  _zz_96;
  reg                 _zz_1;
  reg                 _zz_2;
  wire                banks_0_write_valid;
  wire       [7:0]    banks_0_write_payload_address;
  wire       [127:0]  banks_0_write_payload_data_data;
  wire       [15:0]   banks_0_write_payload_data_mask;
  wire                banks_0_read_cmd_valid;
  wire       [7:0]    banks_0_read_cmd_payload;
  wire       [127:0]  banks_0_read_rsp_data;
  wire       [15:0]   banks_0_read_rsp_mask;
  wire       [143:0]  _zz_3;
  wire                banks_0_writeOr_value_valid;
  wire       [7:0]    banks_0_writeOr_value_payload_address;
  wire       [127:0]  banks_0_writeOr_value_payload_data_data;
  wire       [15:0]   banks_0_writeOr_value_payload_data_mask;
  wire                banks_0_readOr_value_valid;
  wire       [7:0]    banks_0_readOr_value_payload;
  wire                banks_1_write_valid;
  wire       [7:0]    banks_1_write_payload_address;
  wire       [127:0]  banks_1_write_payload_data_data;
  wire       [15:0]   banks_1_write_payload_data_mask;
  wire                banks_1_read_cmd_valid;
  wire       [7:0]    banks_1_read_cmd_payload;
  wire       [127:0]  banks_1_read_rsp_data;
  wire       [15:0]   banks_1_read_rsp_mask;
  wire       [143:0]  _zz_4;
  wire                banks_1_writeOr_value_valid;
  wire       [7:0]    banks_1_writeOr_value_payload_address;
  wire       [127:0]  banks_1_writeOr_value_payload_data_data;
  wire       [15:0]   banks_1_writeOr_value_payload_data_mask;
  wire                banks_1_readOr_value_valid;
  wire       [7:0]    banks_1_readOr_value_payload;
  reg        [7:0]    write_ports_0_priority_value = 8'b00000000;
  reg        [7:0]    write_ports_1_priority_value = 8'b00000000;
  wire                write_nodes_0_0_priority;
  wire                write_nodes_0_0_conflict;
  wire                write_nodes_0_1_priority;
  wire                write_nodes_0_1_conflict;
  wire                write_nodes_0_2_priority;
  wire                write_nodes_0_2_conflict;
  wire                write_nodes_1_0_priority;
  wire                write_nodes_1_0_conflict;
  wire                write_nodes_1_1_priority;
  wire                write_nodes_1_1_conflict;
  wire                write_nodes_1_2_priority;
  wire                write_nodes_1_2_conflict;
  wire                write_nodes_2_0_priority;
  wire                write_nodes_2_0_conflict;
  wire                write_nodes_2_1_priority;
  wire                write_nodes_2_1_conflict;
  wire                write_nodes_2_2_priority;
  wire                write_nodes_2_2_conflict;
  reg        [1:0]    write_arbiter_0_losedAgainst;
  wire                write_arbiter_0_doIt;
  reg                 _zz_5;
  reg        [7:0]    _zz_6;
  reg        [127:0]  _zz_7;
  reg        [15:0]   _zz_8;
  reg                 _zz_9;
  reg        [7:0]    _zz_10;
  reg        [127:0]  _zz_11;
  reg        [15:0]   _zz_12;
  reg                 write_arbiter_0_doIt_regNext;
  reg        [7:0]    io_writes_0_cmd_payload_context_regNext;
  reg        [1:0]    write_arbiter_1_losedAgainst;
  wire                write_arbiter_1_doIt;
  reg                 _zz_13;
  reg        [7:0]    _zz_14;
  reg        [127:0]  _zz_15;
  reg        [15:0]   _zz_16;
  reg                 _zz_17;
  reg        [7:0]    _zz_18;
  reg        [127:0]  _zz_19;
  reg        [15:0]   _zz_20;
  reg                 write_arbiter_1_doIt_regNext;
  reg        [7:0]    io_writes_1_cmd_payload_context_regNext;
  reg        [1:0]    write_arbiter_2_losedAgainst;
  wire                write_arbiter_2_doIt;
  reg                 _zz_21;
  reg        [7:0]    _zz_22;
  reg        [127:0]  _zz_23;
  reg        [15:0]   _zz_24;
  reg                 _zz_25;
  reg        [7:0]    _zz_26;
  reg        [127:0]  _zz_27;
  reg        [15:0]   _zz_28;
  reg                 write_arbiter_2_doIt_regNext;
  reg        [7:0]    io_writes_2_cmd_payload_context_regNext;
  wire                read_ports_0_buffer_s0_valid;
  wire       [2:0]    read_ports_0_buffer_s0_payload_context;
  wire       [8:0]    read_ports_0_buffer_s0_payload_address;
  reg                 read_ports_0_buffer_s1_valid;
  reg        [2:0]    read_ports_0_buffer_s1_payload_context;
  reg        [8:0]    read_ports_0_buffer_s1_payload_address;
  wire       [0:0]    read_ports_0_buffer_groupSel;
  wire                read_ports_0_buffer_bufferIn_valid;
  wire                read_ports_0_buffer_bufferIn_ready;
  wire       [127:0]  read_ports_0_buffer_bufferIn_payload_data;
  wire       [15:0]   read_ports_0_buffer_bufferIn_payload_mask;
  wire       [2:0]    read_ports_0_buffer_bufferIn_payload_context;
  wire                read_ports_0_buffer_bufferOut_valid;
  wire                read_ports_0_buffer_bufferOut_ready;
  wire       [127:0]  read_ports_0_buffer_bufferOut_payload_data;
  wire       [15:0]   read_ports_0_buffer_bufferOut_payload_mask;
  wire       [2:0]    read_ports_0_buffer_bufferOut_payload_context;
  reg                 read_ports_0_buffer_bufferIn_s2mPipe_rValid;
  reg        [127:0]  read_ports_0_buffer_bufferIn_s2mPipe_rData_data;
  reg        [15:0]   read_ports_0_buffer_bufferIn_s2mPipe_rData_mask;
  reg        [2:0]    read_ports_0_buffer_bufferIn_s2mPipe_rData_context;
  wire                read_ports_0_buffer_full;
  wire                _zz_29;
  wire                read_ports_0_cmd_valid;
  wire                read_ports_0_cmd_ready;
  wire       [8:0]    read_ports_0_cmd_payload_address;
  wire       [1:0]    read_ports_0_cmd_payload_priority;
  wire       [2:0]    read_ports_0_cmd_payload_context;
  reg        [7:0]    read_ports_0_priority_value = 8'b00000000;
  wire                read_ports_1_buffer_s0_valid;
  wire       [2:0]    read_ports_1_buffer_s0_payload_context;
  wire       [8:0]    read_ports_1_buffer_s0_payload_address;
  reg                 read_ports_1_buffer_s1_valid;
  reg        [2:0]    read_ports_1_buffer_s1_payload_context;
  reg        [8:0]    read_ports_1_buffer_s1_payload_address;
  wire       [0:0]    read_ports_1_buffer_groupSel;
  wire                read_ports_1_buffer_bufferIn_valid;
  wire                read_ports_1_buffer_bufferIn_ready;
  wire       [127:0]  read_ports_1_buffer_bufferIn_payload_data;
  wire       [15:0]   read_ports_1_buffer_bufferIn_payload_mask;
  wire       [2:0]    read_ports_1_buffer_bufferIn_payload_context;
  wire                read_ports_1_buffer_bufferOut_valid;
  wire                read_ports_1_buffer_bufferOut_ready;
  wire       [127:0]  read_ports_1_buffer_bufferOut_payload_data;
  wire       [15:0]   read_ports_1_buffer_bufferOut_payload_mask;
  wire       [2:0]    read_ports_1_buffer_bufferOut_payload_context;
  reg                 read_ports_1_buffer_bufferIn_s2mPipe_rValid;
  reg        [127:0]  read_ports_1_buffer_bufferIn_s2mPipe_rData_data;
  reg        [15:0]   read_ports_1_buffer_bufferIn_s2mPipe_rData_mask;
  reg        [2:0]    read_ports_1_buffer_bufferIn_s2mPipe_rData_context;
  wire                read_ports_1_buffer_full;
  wire                _zz_30;
  wire                read_ports_1_cmd_valid;
  wire                read_ports_1_cmd_ready;
  wire       [8:0]    read_ports_1_cmd_payload_address;
  wire       [1:0]    read_ports_1_cmd_payload_priority;
  wire       [2:0]    read_ports_1_cmd_payload_context;
  reg        [7:0]    read_ports_1_priority_value = 8'b00000000;
  wire                read_ports_2_buffer_s0_valid;
  wire       [10:0]   read_ports_2_buffer_s0_payload_context;
  wire       [8:0]    read_ports_2_buffer_s0_payload_address;
  reg                 read_ports_2_buffer_s1_valid;
  reg        [10:0]   read_ports_2_buffer_s1_payload_context;
  reg        [8:0]    read_ports_2_buffer_s1_payload_address;
  wire       [0:0]    read_ports_2_buffer_groupSel;
  wire                read_ports_2_buffer_bufferIn_valid;
  wire                read_ports_2_buffer_bufferIn_ready;
  wire       [127:0]  read_ports_2_buffer_bufferIn_payload_data;
  wire       [15:0]   read_ports_2_buffer_bufferIn_payload_mask;
  wire       [10:0]   read_ports_2_buffer_bufferIn_payload_context;
  wire                read_ports_2_buffer_bufferOut_valid;
  wire                read_ports_2_buffer_bufferOut_ready;
  wire       [127:0]  read_ports_2_buffer_bufferOut_payload_data;
  wire       [15:0]   read_ports_2_buffer_bufferOut_payload_mask;
  wire       [10:0]   read_ports_2_buffer_bufferOut_payload_context;
  reg                 read_ports_2_buffer_bufferIn_s2mPipe_rValid;
  reg        [127:0]  read_ports_2_buffer_bufferIn_s2mPipe_rData_data;
  reg        [15:0]   read_ports_2_buffer_bufferIn_s2mPipe_rData_mask;
  reg        [10:0]   read_ports_2_buffer_bufferIn_s2mPipe_rData_context;
  wire                read_ports_2_buffer_full;
  wire                _zz_31;
  wire                read_ports_2_cmd_valid;
  wire                read_ports_2_cmd_ready;
  wire       [8:0]    read_ports_2_cmd_payload_address;
  wire       [10:0]   read_ports_2_cmd_payload_context;
  wire                read_nodes_0_0_priority;
  wire                read_nodes_0_0_conflict;
  wire                read_nodes_0_1_priority;
  wire                read_nodes_0_1_conflict;
  wire                read_nodes_0_2_priority;
  wire                read_nodes_0_2_conflict;
  wire                read_nodes_1_0_priority;
  wire                read_nodes_1_0_conflict;
  wire                read_nodes_1_1_priority;
  wire                read_nodes_1_1_conflict;
  wire                read_nodes_1_2_priority;
  wire                read_nodes_1_2_conflict;
  wire                read_nodes_2_0_priority;
  wire                read_nodes_2_0_conflict;
  wire                read_nodes_2_1_priority;
  wire                read_nodes_2_1_conflict;
  wire                read_nodes_2_2_priority;
  wire                read_nodes_2_2_conflict;
  reg        [1:0]    read_arbiter_0_losedAgainst;
  wire                read_arbiter_0_doIt;
  reg                 _zz_32;
  reg        [7:0]    _zz_33;
  reg                 _zz_34;
  reg        [7:0]    _zz_35;
  reg        [1:0]    read_arbiter_1_losedAgainst;
  wire                read_arbiter_1_doIt;
  reg                 _zz_36;
  reg        [7:0]    _zz_37;
  reg                 _zz_38;
  reg        [7:0]    _zz_39;
  reg        [1:0]    read_arbiter_2_losedAgainst;
  wire                read_arbiter_2_doIt;
  reg                 _zz_40;
  reg        [7:0]    _zz_41;
  reg                 _zz_42;
  reg        [7:0]    _zz_43;
  wire       [152:0]  _zz_44;
  wire       [151:0]  _zz_45;
  wire       [143:0]  _zz_46;
  wire       [8:0]    _zz_47;
  wire       [152:0]  _zz_48;
  wire       [151:0]  _zz_49;
  wire       [143:0]  _zz_50;
  wire       [8:0]    _zz_51;
  (* ram_style = "block" *) reg [143:0] banks_0_ram [0:255];
  (* ram_style = "block" *) reg [143:0] banks_1_ram [0:255];

  assign _zz_60 = (write_arbiter_0_doIt && (_zz_77[0 : 0] == 1'b0));
  assign _zz_61 = (write_arbiter_0_doIt && (_zz_78[0 : 0] == 1'b0));
  assign _zz_62 = (write_arbiter_1_doIt && (_zz_79[0 : 0] == 1'b0));
  assign _zz_63 = (write_arbiter_1_doIt && (_zz_80[0 : 0] == 1'b0));
  assign _zz_64 = (write_arbiter_2_doIt && (_zz_81[0 : 0] == 1'b0));
  assign _zz_65 = (write_arbiter_2_doIt && (_zz_82[0 : 0] == 1'b0));
  assign _zz_66 = (read_arbiter_0_doIt && (_zz_85[0 : 0] == 1'b0));
  assign _zz_67 = (read_arbiter_0_doIt && (_zz_86[0 : 0] == 1'b0));
  assign _zz_68 = (read_arbiter_1_doIt && (_zz_87[0 : 0] == 1'b0));
  assign _zz_69 = (read_arbiter_1_doIt && (_zz_88[0 : 0] == 1'b0));
  assign _zz_70 = (read_arbiter_2_doIt && (_zz_89[0 : 0] == 1'b0));
  assign _zz_71 = (read_arbiter_2_doIt && (_zz_90[0 : 0] == 1'b0));
  assign _zz_72 = (read_ports_0_buffer_bufferIn_ready && (! read_ports_0_buffer_bufferOut_ready));
  assign _zz_73 = (read_ports_1_buffer_bufferIn_ready && (! read_ports_1_buffer_bufferOut_ready));
  assign _zz_74 = (read_ports_2_buffer_bufferIn_ready && (! read_ports_2_buffer_bufferOut_ready));
  assign _zz_75 = {6'd0, io_writes_0_cmd_payload_priority};
  assign _zz_76 = {6'd0, io_writes_1_cmd_payload_priority};
  assign _zz_77 = (io_writes_0_cmd_payload_address ^ 9'h0);
  assign _zz_78 = (io_writes_0_cmd_payload_address ^ 9'h001);
  assign _zz_79 = (io_writes_1_cmd_payload_address ^ 9'h0);
  assign _zz_80 = (io_writes_1_cmd_payload_address ^ 9'h001);
  assign _zz_81 = (io_writes_2_cmd_payload_address ^ 9'h0);
  assign _zz_82 = (io_writes_2_cmd_payload_address ^ 9'h001);
  assign _zz_83 = {6'd0, read_ports_0_cmd_payload_priority};
  assign _zz_84 = {6'd0, read_ports_1_cmd_payload_priority};
  assign _zz_85 = (read_ports_0_cmd_payload_address ^ 9'h0);
  assign _zz_86 = (read_ports_0_cmd_payload_address ^ 9'h001);
  assign _zz_87 = (read_ports_1_cmd_payload_address ^ 9'h0);
  assign _zz_88 = (read_ports_1_cmd_payload_address ^ 9'h001);
  assign _zz_89 = (read_ports_2_cmd_payload_address ^ 9'h0);
  assign _zz_90 = (read_ports_2_cmd_payload_address ^ 9'h001);
  assign _zz_91 = _zz_44[0 : 0];
  assign _zz_92 = _zz_47[0 : 0];
  assign _zz_93 = _zz_48[0 : 0];
  assign _zz_94 = _zz_51[0 : 0];
  assign _zz_95 = {banks_0_write_payload_data_mask,banks_0_write_payload_data_data};
  assign _zz_96 = {banks_1_write_payload_data_mask,banks_1_write_payload_data_data};
  always @ (posedge clk) begin
    if(_zz_2) begin
      banks_0_ram[banks_0_write_payload_address] <= _zz_95;
    end
  end

  always @ (posedge clk) begin
    if(banks_0_read_cmd_valid) begin
      _zz_52 <= banks_0_ram[banks_0_read_cmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      banks_1_ram[banks_1_write_payload_address] <= _zz_96;
    end
  end

  always @ (posedge clk) begin
    if(banks_1_read_cmd_valid) begin
      _zz_53 <= banks_1_ram[banks_1_read_cmd_payload];
    end
  end

  always @(*) begin
    case(read_ports_0_buffer_groupSel)
      1'b0 : begin
        _zz_54 = banks_0_read_rsp_data;
        _zz_55 = banks_0_read_rsp_mask;
      end
      default : begin
        _zz_54 = banks_1_read_rsp_data;
        _zz_55 = banks_1_read_rsp_mask;
      end
    endcase
  end

  always @(*) begin
    case(read_ports_1_buffer_groupSel)
      1'b0 : begin
        _zz_56 = banks_0_read_rsp_data;
        _zz_57 = banks_0_read_rsp_mask;
      end
      default : begin
        _zz_56 = banks_1_read_rsp_data;
        _zz_57 = banks_1_read_rsp_mask;
      end
    endcase
  end

  always @(*) begin
    case(read_ports_2_buffer_groupSel)
      1'b0 : begin
        _zz_58 = banks_0_read_rsp_data;
        _zz_59 = banks_0_read_rsp_mask;
      end
      default : begin
        _zz_58 = banks_1_read_rsp_data;
        _zz_59 = banks_1_read_rsp_mask;
      end
    endcase
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(banks_1_write_valid)begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2 = 1'b0;
    if(banks_0_write_valid)begin
      _zz_2 = 1'b1;
    end
  end

  assign _zz_3 = _zz_52;
  assign banks_0_read_rsp_data = _zz_3[127 : 0];
  assign banks_0_read_rsp_mask = _zz_3[143 : 128];
  assign banks_0_write_valid = banks_0_writeOr_value_valid;
  assign banks_0_write_payload_address = banks_0_writeOr_value_payload_address;
  assign banks_0_write_payload_data_data = banks_0_writeOr_value_payload_data_data;
  assign banks_0_write_payload_data_mask = banks_0_writeOr_value_payload_data_mask;
  assign banks_0_read_cmd_valid = banks_0_readOr_value_valid;
  assign banks_0_read_cmd_payload = banks_0_readOr_value_payload;
  assign _zz_4 = _zz_53;
  assign banks_1_read_rsp_data = _zz_4[127 : 0];
  assign banks_1_read_rsp_mask = _zz_4[143 : 128];
  assign banks_1_write_valid = banks_1_writeOr_value_valid;
  assign banks_1_write_payload_address = banks_1_writeOr_value_payload_address;
  assign banks_1_write_payload_data_data = banks_1_writeOr_value_payload_data_data;
  assign banks_1_write_payload_data_mask = banks_1_writeOr_value_payload_data_mask;
  assign banks_1_read_cmd_valid = banks_1_readOr_value_valid;
  assign banks_1_read_cmd_payload = banks_1_readOr_value_payload;
  assign write_nodes_0_1_priority = (write_ports_1_priority_value < write_ports_0_priority_value);
  assign write_nodes_1_0_priority = (! write_nodes_0_1_priority);
  assign write_nodes_0_1_conflict = ((io_writes_0_cmd_valid && io_writes_1_cmd_valid) && (((io_writes_0_cmd_payload_address ^ io_writes_1_cmd_payload_address) & 9'h001) == 9'h0));
  assign write_nodes_1_0_conflict = write_nodes_0_1_conflict;
  assign write_nodes_0_2_priority = 1'b0;
  assign write_nodes_2_0_priority = 1'b1;
  assign write_nodes_0_2_conflict = ((io_writes_0_cmd_valid && io_writes_2_cmd_valid) && (((io_writes_0_cmd_payload_address ^ io_writes_2_cmd_payload_address) & 9'h001) == 9'h0));
  assign write_nodes_2_0_conflict = write_nodes_0_2_conflict;
  assign write_nodes_1_2_priority = 1'b0;
  assign write_nodes_2_1_priority = 1'b1;
  assign write_nodes_1_2_conflict = ((io_writes_1_cmd_valid && io_writes_2_cmd_valid) && (((io_writes_1_cmd_payload_address ^ io_writes_2_cmd_payload_address) & 9'h001) == 9'h0));
  assign write_nodes_2_1_conflict = write_nodes_1_2_conflict;
  always @ (*) begin
    write_arbiter_0_losedAgainst[0] = (write_nodes_0_1_conflict && (! write_nodes_0_1_priority));
    write_arbiter_0_losedAgainst[1] = (write_nodes_0_2_conflict && (! write_nodes_0_2_priority));
  end

  assign write_arbiter_0_doIt = (io_writes_0_cmd_valid && (write_arbiter_0_losedAgainst == 2'b00));
  always @ (*) begin
    if(_zz_60)begin
      _zz_5 = 1'b1;
    end else begin
      _zz_5 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_60)begin
      _zz_6 = (io_writes_0_cmd_payload_address >>> 1);
    end else begin
      _zz_6 = 8'h0;
    end
  end

  always @ (*) begin
    if(_zz_60)begin
      _zz_7 = io_writes_0_cmd_payload_data[127 : 0];
    end else begin
      _zz_7 = 128'h0;
    end
  end

  always @ (*) begin
    if(_zz_60)begin
      _zz_8 = io_writes_0_cmd_payload_mask[15 : 0];
    end else begin
      _zz_8 = 16'h0;
    end
  end

  always @ (*) begin
    if(_zz_61)begin
      _zz_9 = 1'b1;
    end else begin
      _zz_9 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_61)begin
      _zz_10 = (io_writes_0_cmd_payload_address >>> 1);
    end else begin
      _zz_10 = 8'h0;
    end
  end

  always @ (*) begin
    if(_zz_61)begin
      _zz_11 = io_writes_0_cmd_payload_data[127 : 0];
    end else begin
      _zz_11 = 128'h0;
    end
  end

  always @ (*) begin
    if(_zz_61)begin
      _zz_12 = io_writes_0_cmd_payload_mask[15 : 0];
    end else begin
      _zz_12 = 16'h0;
    end
  end

  assign io_writes_0_cmd_ready = write_arbiter_0_doIt;
  assign io_writes_0_rsp_valid = write_arbiter_0_doIt_regNext;
  assign io_writes_0_rsp_payload_context = io_writes_0_cmd_payload_context_regNext;
  always @ (*) begin
    write_arbiter_1_losedAgainst[0] = (write_nodes_1_0_conflict && (! write_nodes_1_0_priority));
    write_arbiter_1_losedAgainst[1] = (write_nodes_1_2_conflict && (! write_nodes_1_2_priority));
  end

  assign write_arbiter_1_doIt = (io_writes_1_cmd_valid && (write_arbiter_1_losedAgainst == 2'b00));
  always @ (*) begin
    if(_zz_62)begin
      _zz_13 = 1'b1;
    end else begin
      _zz_13 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_62)begin
      _zz_14 = (io_writes_1_cmd_payload_address >>> 1);
    end else begin
      _zz_14 = 8'h0;
    end
  end

  always @ (*) begin
    if(_zz_62)begin
      _zz_15 = io_writes_1_cmd_payload_data[127 : 0];
    end else begin
      _zz_15 = 128'h0;
    end
  end

  always @ (*) begin
    if(_zz_62)begin
      _zz_16 = io_writes_1_cmd_payload_mask[15 : 0];
    end else begin
      _zz_16 = 16'h0;
    end
  end

  always @ (*) begin
    if(_zz_63)begin
      _zz_17 = 1'b1;
    end else begin
      _zz_17 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_63)begin
      _zz_18 = (io_writes_1_cmd_payload_address >>> 1);
    end else begin
      _zz_18 = 8'h0;
    end
  end

  always @ (*) begin
    if(_zz_63)begin
      _zz_19 = io_writes_1_cmd_payload_data[127 : 0];
    end else begin
      _zz_19 = 128'h0;
    end
  end

  always @ (*) begin
    if(_zz_63)begin
      _zz_20 = io_writes_1_cmd_payload_mask[15 : 0];
    end else begin
      _zz_20 = 16'h0;
    end
  end

  assign io_writes_1_cmd_ready = write_arbiter_1_doIt;
  assign io_writes_1_rsp_valid = write_arbiter_1_doIt_regNext;
  assign io_writes_1_rsp_payload_context = io_writes_1_cmd_payload_context_regNext;
  always @ (*) begin
    write_arbiter_2_losedAgainst[0] = (write_nodes_2_0_conflict && (! write_nodes_2_0_priority));
    write_arbiter_2_losedAgainst[1] = (write_nodes_2_1_conflict && (! write_nodes_2_1_priority));
  end

  assign write_arbiter_2_doIt = (io_writes_2_cmd_valid && (write_arbiter_2_losedAgainst == 2'b00));
  always @ (*) begin
    if(_zz_64)begin
      _zz_21 = 1'b1;
    end else begin
      _zz_21 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_64)begin
      _zz_22 = (io_writes_2_cmd_payload_address >>> 1);
    end else begin
      _zz_22 = 8'h0;
    end
  end

  always @ (*) begin
    if(_zz_64)begin
      _zz_23 = io_writes_2_cmd_payload_data[127 : 0];
    end else begin
      _zz_23 = 128'h0;
    end
  end

  always @ (*) begin
    if(_zz_64)begin
      _zz_24 = io_writes_2_cmd_payload_mask[15 : 0];
    end else begin
      _zz_24 = 16'h0;
    end
  end

  always @ (*) begin
    if(_zz_65)begin
      _zz_25 = 1'b1;
    end else begin
      _zz_25 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_65)begin
      _zz_26 = (io_writes_2_cmd_payload_address >>> 1);
    end else begin
      _zz_26 = 8'h0;
    end
  end

  always @ (*) begin
    if(_zz_65)begin
      _zz_27 = io_writes_2_cmd_payload_data[127 : 0];
    end else begin
      _zz_27 = 128'h0;
    end
  end

  always @ (*) begin
    if(_zz_65)begin
      _zz_28 = io_writes_2_cmd_payload_mask[15 : 0];
    end else begin
      _zz_28 = 16'h0;
    end
  end

  assign io_writes_2_cmd_ready = write_arbiter_2_doIt;
  assign io_writes_2_rsp_valid = write_arbiter_2_doIt_regNext;
  assign io_writes_2_rsp_payload_context = io_writes_2_cmd_payload_context_regNext;
  assign read_ports_0_buffer_groupSel = read_ports_0_buffer_s1_payload_address[0 : 0];
  assign read_ports_0_buffer_bufferIn_valid = read_ports_0_buffer_s1_valid;
  assign read_ports_0_buffer_bufferIn_payload_context = read_ports_0_buffer_s1_payload_context;
  assign read_ports_0_buffer_bufferIn_payload_data = _zz_54;
  assign read_ports_0_buffer_bufferIn_payload_mask = _zz_55;
  assign read_ports_0_buffer_bufferOut_valid = (read_ports_0_buffer_bufferIn_valid || read_ports_0_buffer_bufferIn_s2mPipe_rValid);
  assign read_ports_0_buffer_bufferIn_ready = (! read_ports_0_buffer_bufferIn_s2mPipe_rValid);
  assign read_ports_0_buffer_bufferOut_payload_data = (read_ports_0_buffer_bufferIn_s2mPipe_rValid ? read_ports_0_buffer_bufferIn_s2mPipe_rData_data : read_ports_0_buffer_bufferIn_payload_data);
  assign read_ports_0_buffer_bufferOut_payload_mask = (read_ports_0_buffer_bufferIn_s2mPipe_rValid ? read_ports_0_buffer_bufferIn_s2mPipe_rData_mask : read_ports_0_buffer_bufferIn_payload_mask);
  assign read_ports_0_buffer_bufferOut_payload_context = (read_ports_0_buffer_bufferIn_s2mPipe_rValid ? read_ports_0_buffer_bufferIn_s2mPipe_rData_context : read_ports_0_buffer_bufferIn_payload_context);
  assign io_reads_0_rsp_valid = read_ports_0_buffer_bufferOut_valid;
  assign read_ports_0_buffer_bufferOut_ready = io_reads_0_rsp_ready;
  assign io_reads_0_rsp_payload_data = read_ports_0_buffer_bufferOut_payload_data;
  assign io_reads_0_rsp_payload_mask = read_ports_0_buffer_bufferOut_payload_mask;
  assign io_reads_0_rsp_payload_context = read_ports_0_buffer_bufferOut_payload_context;
  assign read_ports_0_buffer_full = (read_ports_0_buffer_bufferOut_valid && (! read_ports_0_buffer_bufferOut_ready));
  assign _zz_29 = (! read_ports_0_buffer_full);
  assign read_ports_0_cmd_valid = (io_reads_0_cmd_valid && _zz_29);
  assign io_reads_0_cmd_ready = (read_ports_0_cmd_ready && _zz_29);
  assign read_ports_0_cmd_payload_address = io_reads_0_cmd_payload_address;
  assign read_ports_0_cmd_payload_priority = io_reads_0_cmd_payload_priority;
  assign read_ports_0_cmd_payload_context = io_reads_0_cmd_payload_context;
  assign read_ports_1_buffer_groupSel = read_ports_1_buffer_s1_payload_address[0 : 0];
  assign read_ports_1_buffer_bufferIn_valid = read_ports_1_buffer_s1_valid;
  assign read_ports_1_buffer_bufferIn_payload_context = read_ports_1_buffer_s1_payload_context;
  assign read_ports_1_buffer_bufferIn_payload_data = _zz_56;
  assign read_ports_1_buffer_bufferIn_payload_mask = _zz_57;
  assign read_ports_1_buffer_bufferOut_valid = (read_ports_1_buffer_bufferIn_valid || read_ports_1_buffer_bufferIn_s2mPipe_rValid);
  assign read_ports_1_buffer_bufferIn_ready = (! read_ports_1_buffer_bufferIn_s2mPipe_rValid);
  assign read_ports_1_buffer_bufferOut_payload_data = (read_ports_1_buffer_bufferIn_s2mPipe_rValid ? read_ports_1_buffer_bufferIn_s2mPipe_rData_data : read_ports_1_buffer_bufferIn_payload_data);
  assign read_ports_1_buffer_bufferOut_payload_mask = (read_ports_1_buffer_bufferIn_s2mPipe_rValid ? read_ports_1_buffer_bufferIn_s2mPipe_rData_mask : read_ports_1_buffer_bufferIn_payload_mask);
  assign read_ports_1_buffer_bufferOut_payload_context = (read_ports_1_buffer_bufferIn_s2mPipe_rValid ? read_ports_1_buffer_bufferIn_s2mPipe_rData_context : read_ports_1_buffer_bufferIn_payload_context);
  assign io_reads_1_rsp_valid = read_ports_1_buffer_bufferOut_valid;
  assign read_ports_1_buffer_bufferOut_ready = io_reads_1_rsp_ready;
  assign io_reads_1_rsp_payload_data = read_ports_1_buffer_bufferOut_payload_data;
  assign io_reads_1_rsp_payload_mask = read_ports_1_buffer_bufferOut_payload_mask;
  assign io_reads_1_rsp_payload_context = read_ports_1_buffer_bufferOut_payload_context;
  assign read_ports_1_buffer_full = (read_ports_1_buffer_bufferOut_valid && (! read_ports_1_buffer_bufferOut_ready));
  assign _zz_30 = (! read_ports_1_buffer_full);
  assign read_ports_1_cmd_valid = (io_reads_1_cmd_valid && _zz_30);
  assign io_reads_1_cmd_ready = (read_ports_1_cmd_ready && _zz_30);
  assign read_ports_1_cmd_payload_address = io_reads_1_cmd_payload_address;
  assign read_ports_1_cmd_payload_priority = io_reads_1_cmd_payload_priority;
  assign read_ports_1_cmd_payload_context = io_reads_1_cmd_payload_context;
  assign read_ports_2_buffer_groupSel = read_ports_2_buffer_s1_payload_address[0 : 0];
  assign read_ports_2_buffer_bufferIn_valid = read_ports_2_buffer_s1_valid;
  assign read_ports_2_buffer_bufferIn_payload_context = read_ports_2_buffer_s1_payload_context;
  assign read_ports_2_buffer_bufferIn_payload_data = _zz_58;
  assign read_ports_2_buffer_bufferIn_payload_mask = _zz_59;
  assign read_ports_2_buffer_bufferOut_valid = (read_ports_2_buffer_bufferIn_valid || read_ports_2_buffer_bufferIn_s2mPipe_rValid);
  assign read_ports_2_buffer_bufferIn_ready = (! read_ports_2_buffer_bufferIn_s2mPipe_rValid);
  assign read_ports_2_buffer_bufferOut_payload_data = (read_ports_2_buffer_bufferIn_s2mPipe_rValid ? read_ports_2_buffer_bufferIn_s2mPipe_rData_data : read_ports_2_buffer_bufferIn_payload_data);
  assign read_ports_2_buffer_bufferOut_payload_mask = (read_ports_2_buffer_bufferIn_s2mPipe_rValid ? read_ports_2_buffer_bufferIn_s2mPipe_rData_mask : read_ports_2_buffer_bufferIn_payload_mask);
  assign read_ports_2_buffer_bufferOut_payload_context = (read_ports_2_buffer_bufferIn_s2mPipe_rValid ? read_ports_2_buffer_bufferIn_s2mPipe_rData_context : read_ports_2_buffer_bufferIn_payload_context);
  assign io_reads_2_rsp_valid = read_ports_2_buffer_bufferOut_valid;
  assign read_ports_2_buffer_bufferOut_ready = io_reads_2_rsp_ready;
  assign io_reads_2_rsp_payload_data = read_ports_2_buffer_bufferOut_payload_data;
  assign io_reads_2_rsp_payload_mask = read_ports_2_buffer_bufferOut_payload_mask;
  assign io_reads_2_rsp_payload_context = read_ports_2_buffer_bufferOut_payload_context;
  assign read_ports_2_buffer_full = (read_ports_2_buffer_bufferOut_valid && (! read_ports_2_buffer_bufferOut_ready));
  assign _zz_31 = (! read_ports_2_buffer_full);
  assign read_ports_2_cmd_valid = (io_reads_2_cmd_valid && _zz_31);
  assign io_reads_2_cmd_ready = (read_ports_2_cmd_ready && _zz_31);
  assign read_ports_2_cmd_payload_address = io_reads_2_cmd_payload_address;
  assign read_ports_2_cmd_payload_context = io_reads_2_cmd_payload_context;
  assign read_nodes_0_1_priority = (read_ports_1_priority_value < read_ports_0_priority_value);
  assign read_nodes_1_0_priority = (! read_nodes_0_1_priority);
  assign read_nodes_0_1_conflict = ((read_ports_0_cmd_valid && read_ports_1_cmd_valid) && (((read_ports_0_cmd_payload_address ^ io_reads_1_cmd_payload_address) & 9'h001) == 9'h0));
  assign read_nodes_1_0_conflict = read_nodes_0_1_conflict;
  assign read_nodes_0_2_priority = 1'b0;
  assign read_nodes_2_0_priority = 1'b1;
  assign read_nodes_0_2_conflict = ((read_ports_0_cmd_valid && read_ports_2_cmd_valid) && (((read_ports_0_cmd_payload_address ^ io_reads_2_cmd_payload_address) & 9'h001) == 9'h0));
  assign read_nodes_2_0_conflict = read_nodes_0_2_conflict;
  assign read_nodes_1_2_priority = 1'b0;
  assign read_nodes_2_1_priority = 1'b1;
  assign read_nodes_1_2_conflict = ((read_ports_1_cmd_valid && read_ports_2_cmd_valid) && (((read_ports_1_cmd_payload_address ^ io_reads_2_cmd_payload_address) & 9'h001) == 9'h0));
  assign read_nodes_2_1_conflict = read_nodes_1_2_conflict;
  always @ (*) begin
    read_arbiter_0_losedAgainst[0] = (read_nodes_0_1_conflict && (! read_nodes_0_1_priority));
    read_arbiter_0_losedAgainst[1] = (read_nodes_0_2_conflict && (! read_nodes_0_2_priority));
  end

  assign read_arbiter_0_doIt = (read_ports_0_cmd_valid && (read_arbiter_0_losedAgainst == 2'b00));
  always @ (*) begin
    if(_zz_66)begin
      _zz_32 = 1'b1;
    end else begin
      _zz_32 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_66)begin
      _zz_33 = (read_ports_0_cmd_payload_address >>> 1);
    end else begin
      _zz_33 = 8'h0;
    end
  end

  always @ (*) begin
    if(_zz_67)begin
      _zz_34 = 1'b1;
    end else begin
      _zz_34 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_67)begin
      _zz_35 = (read_ports_0_cmd_payload_address >>> 1);
    end else begin
      _zz_35 = 8'h0;
    end
  end

  assign read_ports_0_cmd_ready = read_arbiter_0_doIt;
  assign read_ports_0_buffer_s0_valid = read_arbiter_0_doIt;
  assign read_ports_0_buffer_s0_payload_context = read_ports_0_cmd_payload_context;
  assign read_ports_0_buffer_s0_payload_address = read_ports_0_cmd_payload_address;
  always @ (*) begin
    read_arbiter_1_losedAgainst[0] = (read_nodes_1_0_conflict && (! read_nodes_1_0_priority));
    read_arbiter_1_losedAgainst[1] = (read_nodes_1_2_conflict && (! read_nodes_1_2_priority));
  end

  assign read_arbiter_1_doIt = (read_ports_1_cmd_valid && (read_arbiter_1_losedAgainst == 2'b00));
  always @ (*) begin
    if(_zz_68)begin
      _zz_36 = 1'b1;
    end else begin
      _zz_36 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_68)begin
      _zz_37 = (read_ports_1_cmd_payload_address >>> 1);
    end else begin
      _zz_37 = 8'h0;
    end
  end

  always @ (*) begin
    if(_zz_69)begin
      _zz_38 = 1'b1;
    end else begin
      _zz_38 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_69)begin
      _zz_39 = (read_ports_1_cmd_payload_address >>> 1);
    end else begin
      _zz_39 = 8'h0;
    end
  end

  assign read_ports_1_cmd_ready = read_arbiter_1_doIt;
  assign read_ports_1_buffer_s0_valid = read_arbiter_1_doIt;
  assign read_ports_1_buffer_s0_payload_context = read_ports_1_cmd_payload_context;
  assign read_ports_1_buffer_s0_payload_address = read_ports_1_cmd_payload_address;
  always @ (*) begin
    read_arbiter_2_losedAgainst[0] = (read_nodes_2_0_conflict && (! read_nodes_2_0_priority));
    read_arbiter_2_losedAgainst[1] = (read_nodes_2_1_conflict && (! read_nodes_2_1_priority));
  end

  assign read_arbiter_2_doIt = (read_ports_2_cmd_valid && (read_arbiter_2_losedAgainst == 2'b00));
  always @ (*) begin
    if(_zz_70)begin
      _zz_40 = 1'b1;
    end else begin
      _zz_40 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_70)begin
      _zz_41 = (read_ports_2_cmd_payload_address >>> 1);
    end else begin
      _zz_41 = 8'h0;
    end
  end

  always @ (*) begin
    if(_zz_71)begin
      _zz_42 = 1'b1;
    end else begin
      _zz_42 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_71)begin
      _zz_43 = (read_ports_2_cmd_payload_address >>> 1);
    end else begin
      _zz_43 = 8'h0;
    end
  end

  assign read_ports_2_cmd_ready = read_arbiter_2_doIt;
  assign read_ports_2_buffer_s0_valid = read_arbiter_2_doIt;
  assign read_ports_2_buffer_s0_payload_context = read_ports_2_cmd_payload_context;
  assign read_ports_2_buffer_s0_payload_address = read_ports_2_cmd_payload_address;
  assign _zz_44 = (({{{_zz_8,_zz_7},_zz_6},_zz_5} | {{{_zz_16,_zz_15},_zz_14},_zz_13}) | {{{_zz_24,_zz_23},_zz_22},_zz_21});
  assign banks_0_writeOr_value_valid = _zz_91[0];
  assign _zz_45 = _zz_44[152 : 1];
  assign banks_0_writeOr_value_payload_address = _zz_45[7 : 0];
  assign _zz_46 = _zz_45[151 : 8];
  assign banks_0_writeOr_value_payload_data_data = _zz_46[127 : 0];
  assign banks_0_writeOr_value_payload_data_mask = _zz_46[143 : 128];
  assign _zz_47 = (({_zz_33,_zz_32} | {_zz_37,_zz_36}) | {_zz_41,_zz_40});
  assign banks_0_readOr_value_valid = _zz_92[0];
  assign banks_0_readOr_value_payload = _zz_47[8 : 1];
  assign _zz_48 = (({{{_zz_12,_zz_11},_zz_10},_zz_9} | {{{_zz_20,_zz_19},_zz_18},_zz_17}) | {{{_zz_28,_zz_27},_zz_26},_zz_25});
  assign banks_1_writeOr_value_valid = _zz_93[0];
  assign _zz_49 = _zz_48[152 : 1];
  assign banks_1_writeOr_value_payload_address = _zz_49[7 : 0];
  assign _zz_50 = _zz_49[151 : 8];
  assign banks_1_writeOr_value_payload_data_data = _zz_50[127 : 0];
  assign banks_1_writeOr_value_payload_data_mask = _zz_50[143 : 128];
  assign _zz_51 = (({_zz_35,_zz_34} | {_zz_39,_zz_38}) | {_zz_43,_zz_42});
  assign banks_1_readOr_value_valid = _zz_94[0];
  assign banks_1_readOr_value_payload = _zz_51[8 : 1];
  always @ (posedge clk) begin
    if(io_writes_0_cmd_valid)begin
      write_ports_0_priority_value <= (write_ports_0_priority_value + _zz_75);
      if(io_writes_0_cmd_ready)begin
        write_ports_0_priority_value <= 8'h0;
      end
    end
    if(io_writes_1_cmd_valid)begin
      write_ports_1_priority_value <= (write_ports_1_priority_value + _zz_76);
      if(io_writes_1_cmd_ready)begin
        write_ports_1_priority_value <= 8'h0;
      end
    end
    io_writes_0_cmd_payload_context_regNext <= io_writes_0_cmd_payload_context;
    io_writes_1_cmd_payload_context_regNext <= io_writes_1_cmd_payload_context;
    io_writes_2_cmd_payload_context_regNext <= io_writes_2_cmd_payload_context;
    read_ports_0_buffer_s1_payload_context <= read_ports_0_buffer_s0_payload_context;
    read_ports_0_buffer_s1_payload_address <= read_ports_0_buffer_s0_payload_address;
    if(_zz_72)begin
      read_ports_0_buffer_bufferIn_s2mPipe_rData_data <= read_ports_0_buffer_bufferIn_payload_data;
      read_ports_0_buffer_bufferIn_s2mPipe_rData_mask <= read_ports_0_buffer_bufferIn_payload_mask;
      read_ports_0_buffer_bufferIn_s2mPipe_rData_context <= read_ports_0_buffer_bufferIn_payload_context;
    end
    if(read_ports_0_cmd_valid)begin
      read_ports_0_priority_value <= (read_ports_0_priority_value + _zz_83);
      if(read_ports_0_cmd_ready)begin
        read_ports_0_priority_value <= 8'h0;
      end
    end
    read_ports_1_buffer_s1_payload_context <= read_ports_1_buffer_s0_payload_context;
    read_ports_1_buffer_s1_payload_address <= read_ports_1_buffer_s0_payload_address;
    if(_zz_73)begin
      read_ports_1_buffer_bufferIn_s2mPipe_rData_data <= read_ports_1_buffer_bufferIn_payload_data;
      read_ports_1_buffer_bufferIn_s2mPipe_rData_mask <= read_ports_1_buffer_bufferIn_payload_mask;
      read_ports_1_buffer_bufferIn_s2mPipe_rData_context <= read_ports_1_buffer_bufferIn_payload_context;
    end
    if(read_ports_1_cmd_valid)begin
      read_ports_1_priority_value <= (read_ports_1_priority_value + _zz_84);
      if(read_ports_1_cmd_ready)begin
        read_ports_1_priority_value <= 8'h0;
      end
    end
    read_ports_2_buffer_s1_payload_context <= read_ports_2_buffer_s0_payload_context;
    read_ports_2_buffer_s1_payload_address <= read_ports_2_buffer_s0_payload_address;
    if(_zz_74)begin
      read_ports_2_buffer_bufferIn_s2mPipe_rData_data <= read_ports_2_buffer_bufferIn_payload_data;
      read_ports_2_buffer_bufferIn_s2mPipe_rData_mask <= read_ports_2_buffer_bufferIn_payload_mask;
      read_ports_2_buffer_bufferIn_s2mPipe_rData_context <= read_ports_2_buffer_bufferIn_payload_context;
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      write_arbiter_0_doIt_regNext <= 1'b0;
      write_arbiter_1_doIt_regNext <= 1'b0;
      write_arbiter_2_doIt_regNext <= 1'b0;
      read_ports_0_buffer_s1_valid <= 1'b0;
      read_ports_0_buffer_bufferIn_s2mPipe_rValid <= 1'b0;
      read_ports_1_buffer_s1_valid <= 1'b0;
      read_ports_1_buffer_bufferIn_s2mPipe_rValid <= 1'b0;
      read_ports_2_buffer_s1_valid <= 1'b0;
      read_ports_2_buffer_bufferIn_s2mPipe_rValid <= 1'b0;
    end else begin
      write_arbiter_0_doIt_regNext <= write_arbiter_0_doIt;
      write_arbiter_1_doIt_regNext <= write_arbiter_1_doIt;
      write_arbiter_2_doIt_regNext <= write_arbiter_2_doIt;
      read_ports_0_buffer_s1_valid <= read_ports_0_buffer_s0_valid;
      if(read_ports_0_buffer_bufferOut_ready)begin
        read_ports_0_buffer_bufferIn_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_72)begin
        read_ports_0_buffer_bufferIn_s2mPipe_rValid <= read_ports_0_buffer_bufferIn_valid;
      end
      read_ports_1_buffer_s1_valid <= read_ports_1_buffer_s0_valid;
      if(read_ports_1_buffer_bufferOut_ready)begin
        read_ports_1_buffer_bufferIn_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_73)begin
        read_ports_1_buffer_bufferIn_s2mPipe_rValid <= read_ports_1_buffer_bufferIn_valid;
      end
      read_ports_2_buffer_s1_valid <= read_ports_2_buffer_s0_valid;
      if(read_ports_2_buffer_bufferOut_ready)begin
        read_ports_2_buffer_bufferIn_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_74)begin
        read_ports_2_buffer_bufferIn_s2mPipe_rValid <= read_ports_2_buffer_bufferIn_valid;
      end
    end
  end


endmodule

module dma_socRuby_StreamFifo_1 (
  input               io_push_valid,
  output              io_push_ready,
  input      [15:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [15:0]   io_pop_payload,
  input               io_flush,
  output reg [2:0]    io_occupancy,
  output reg [2:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [15:0]   _zz_3;
  wire       [0:0]    _zz_4;
  wire       [2:0]    _zz_5;
  wire       [0:0]    _zz_6;
  wire       [2:0]    _zz_7;
  wire       [2:0]    _zz_8;
  wire       [2:0]    _zz_9;
  wire       [2:0]    _zz_10;
  wire       [2:0]    _zz_11;
  wire                _zz_12;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [2:0]    logic_pushPtr_valueNext;
  reg        [2:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [2:0]    logic_popPtr_valueNext;
  reg        [2:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [2:0]    logic_ptrDif;
  reg [15:0] logic_ram [0:6];

  assign _zz_4 = logic_pushPtr_willIncrement;
  assign _zz_5 = {2'd0, _zz_4};
  assign _zz_6 = logic_popPtr_willIncrement;
  assign _zz_7 = {2'd0, _zz_6};
  assign _zz_8 = (3'b111 + logic_ptrDif);
  assign _zz_9 = (3'b111 + _zz_10);
  assign _zz_10 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_11 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_12 = 1'b1;
  always @ (posedge clk) begin
    if(_zz_12) begin
      _zz_3 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= io_push_payload;
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(logic_pushing)begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing)begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 3'b110);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    if(logic_pushPtr_willOverflow)begin
      logic_pushPtr_valueNext = 3'b000;
    end else begin
      logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_5);
    end
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 3'b000;
    end
  end

  always @ (*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping)begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 3'b110);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    if(logic_popPtr_willOverflow)begin
      logic_popPtr_valueNext = 3'b000;
    end else begin
      logic_popPtr_valueNext = (logic_popPtr_value + _zz_7);
    end
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 3'b000;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign io_pop_payload = _zz_3;
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  always @ (*) begin
    if(logic_ptrMatch)begin
      io_occupancy = (logic_risingOccupancy ? 3'b111 : 3'b000);
    end else begin
      io_occupancy = ((logic_popPtr_value < logic_pushPtr_value) ? logic_ptrDif : _zz_8);
    end
  end

  always @ (*) begin
    if(logic_ptrMatch)begin
      io_availability = (logic_risingOccupancy ? 3'b000 : 3'b111);
    end else begin
      io_availability = ((logic_popPtr_value < logic_pushPtr_value) ? _zz_9 : _zz_11);
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      logic_pushPtr_value <= 3'b000;
      logic_popPtr_value <= 3'b000;
      logic_risingOccupancy <= 1'b0;
      _zz_2 <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_2 <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if((logic_pushing != logic_popping))begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush)begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module dma_socRuby_StreamFork_1 (
  input               io_input_valid,
  output reg          io_input_ready,
  input               io_input_payload_last,
  input      [0:0]    io_input_payload_fragment_opcode,
  input      [31:0]   io_input_payload_fragment_address,
  input      [11:0]   io_input_payload_fragment_length,
  input      [127:0]  io_input_payload_fragment_data,
  input      [15:0]   io_input_payload_fragment_mask,
  input      [15:0]   io_input_payload_fragment_context,
  output              io_outputs_0_valid,
  input               io_outputs_0_ready,
  output              io_outputs_0_payload_last,
  output     [0:0]    io_outputs_0_payload_fragment_opcode,
  output     [31:0]   io_outputs_0_payload_fragment_address,
  output     [11:0]   io_outputs_0_payload_fragment_length,
  output     [127:0]  io_outputs_0_payload_fragment_data,
  output     [15:0]   io_outputs_0_payload_fragment_mask,
  output     [15:0]   io_outputs_0_payload_fragment_context,
  output              io_outputs_1_valid,
  input               io_outputs_1_ready,
  output              io_outputs_1_payload_last,
  output     [0:0]    io_outputs_1_payload_fragment_opcode,
  output     [31:0]   io_outputs_1_payload_fragment_address,
  output     [11:0]   io_outputs_1_payload_fragment_length,
  output     [127:0]  io_outputs_1_payload_fragment_data,
  output     [15:0]   io_outputs_1_payload_fragment_mask,
  output     [15:0]   io_outputs_1_payload_fragment_context,
  input               clk,
  input               reset
);
  reg                 _zz_1;
  reg                 _zz_2;

  always @ (*) begin
    io_input_ready = 1'b1;
    if(((! io_outputs_0_ready) && _zz_1))begin
      io_input_ready = 1'b0;
    end
    if(((! io_outputs_1_ready) && _zz_2))begin
      io_input_ready = 1'b0;
    end
  end

  assign io_outputs_0_valid = (io_input_valid && _zz_1);
  assign io_outputs_0_payload_last = io_input_payload_last;
  assign io_outputs_0_payload_fragment_opcode = io_input_payload_fragment_opcode;
  assign io_outputs_0_payload_fragment_address = io_input_payload_fragment_address;
  assign io_outputs_0_payload_fragment_length = io_input_payload_fragment_length;
  assign io_outputs_0_payload_fragment_data = io_input_payload_fragment_data;
  assign io_outputs_0_payload_fragment_mask = io_input_payload_fragment_mask;
  assign io_outputs_0_payload_fragment_context = io_input_payload_fragment_context;
  assign io_outputs_1_valid = (io_input_valid && _zz_2);
  assign io_outputs_1_payload_last = io_input_payload_last;
  assign io_outputs_1_payload_fragment_opcode = io_input_payload_fragment_opcode;
  assign io_outputs_1_payload_fragment_address = io_input_payload_fragment_address;
  assign io_outputs_1_payload_fragment_length = io_input_payload_fragment_length;
  assign io_outputs_1_payload_fragment_data = io_input_payload_fragment_data;
  assign io_outputs_1_payload_fragment_mask = io_input_payload_fragment_mask;
  assign io_outputs_1_payload_fragment_context = io_input_payload_fragment_context;
  always @ (posedge clk) begin
    if(reset) begin
      _zz_1 <= 1'b1;
      _zz_2 <= 1'b1;
    end else begin
      if((io_outputs_0_valid && io_outputs_0_ready))begin
        _zz_1 <= 1'b0;
      end
      if((io_outputs_1_valid && io_outputs_1_ready))begin
        _zz_2 <= 1'b0;
      end
      if(io_input_ready)begin
        _zz_1 <= 1'b1;
        _zz_2 <= 1'b1;
      end
    end
  end


endmodule

module dma_socRuby_StreamFifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [23:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [23:0]   io_pop_payload,
  input               io_flush,
  output reg [2:0]    io_occupancy,
  output reg [2:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [23:0]   _zz_3;
  wire       [0:0]    _zz_4;
  wire       [2:0]    _zz_5;
  wire       [0:0]    _zz_6;
  wire       [2:0]    _zz_7;
  wire       [2:0]    _zz_8;
  wire       [2:0]    _zz_9;
  wire       [2:0]    _zz_10;
  wire       [2:0]    _zz_11;
  wire                _zz_12;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [2:0]    logic_pushPtr_valueNext;
  reg        [2:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [2:0]    logic_popPtr_valueNext;
  reg        [2:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [2:0]    logic_ptrDif;
  reg [23:0] logic_ram [0:6];

  assign _zz_4 = logic_pushPtr_willIncrement;
  assign _zz_5 = {2'd0, _zz_4};
  assign _zz_6 = logic_popPtr_willIncrement;
  assign _zz_7 = {2'd0, _zz_6};
  assign _zz_8 = (3'b111 + logic_ptrDif);
  assign _zz_9 = (3'b111 + _zz_10);
  assign _zz_10 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_11 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_12 = 1'b1;
  always @ (posedge clk) begin
    if(_zz_12) begin
      _zz_3 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= io_push_payload;
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(logic_pushing)begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing)begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 3'b110);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    if(logic_pushPtr_willOverflow)begin
      logic_pushPtr_valueNext = 3'b000;
    end else begin
      logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_5);
    end
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 3'b000;
    end
  end

  always @ (*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping)begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 3'b110);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    if(logic_popPtr_willOverflow)begin
      logic_popPtr_valueNext = 3'b000;
    end else begin
      logic_popPtr_valueNext = (logic_popPtr_value + _zz_7);
    end
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 3'b000;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign io_pop_payload = _zz_3;
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  always @ (*) begin
    if(logic_ptrMatch)begin
      io_occupancy = (logic_risingOccupancy ? 3'b111 : 3'b000);
    end else begin
      io_occupancy = ((logic_popPtr_value < logic_pushPtr_value) ? logic_ptrDif : _zz_8);
    end
  end

  always @ (*) begin
    if(logic_ptrMatch)begin
      io_availability = (logic_risingOccupancy ? 3'b000 : 3'b111);
    end else begin
      io_availability = ((logic_popPtr_value < logic_pushPtr_value) ? _zz_9 : _zz_11);
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      logic_pushPtr_value <= 3'b000;
      logic_popPtr_value <= 3'b000;
      logic_risingOccupancy <= 1'b0;
      _zz_2 <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_2 <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if((logic_pushing != logic_popping))begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush)begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module dma_socRuby_StreamFork (
  input               io_input_valid,
  output reg          io_input_ready,
  input               io_input_payload_last,
  input      [0:0]    io_input_payload_fragment_opcode,
  input      [31:0]   io_input_payload_fragment_address,
  input      [11:0]   io_input_payload_fragment_length,
  input      [23:0]   io_input_payload_fragment_context,
  output              io_outputs_0_valid,
  input               io_outputs_0_ready,
  output              io_outputs_0_payload_last,
  output     [0:0]    io_outputs_0_payload_fragment_opcode,
  output     [31:0]   io_outputs_0_payload_fragment_address,
  output     [11:0]   io_outputs_0_payload_fragment_length,
  output     [23:0]   io_outputs_0_payload_fragment_context,
  output              io_outputs_1_valid,
  input               io_outputs_1_ready,
  output              io_outputs_1_payload_last,
  output     [0:0]    io_outputs_1_payload_fragment_opcode,
  output     [31:0]   io_outputs_1_payload_fragment_address,
  output     [11:0]   io_outputs_1_payload_fragment_length,
  output     [23:0]   io_outputs_1_payload_fragment_context,
  input               clk,
  input               reset
);
  reg                 _zz_1;
  reg                 _zz_2;

  always @ (*) begin
    io_input_ready = 1'b1;
    if(((! io_outputs_0_ready) && _zz_1))begin
      io_input_ready = 1'b0;
    end
    if(((! io_outputs_1_ready) && _zz_2))begin
      io_input_ready = 1'b0;
    end
  end

  assign io_outputs_0_valid = (io_input_valid && _zz_1);
  assign io_outputs_0_payload_last = io_input_payload_last;
  assign io_outputs_0_payload_fragment_opcode = io_input_payload_fragment_opcode;
  assign io_outputs_0_payload_fragment_address = io_input_payload_fragment_address;
  assign io_outputs_0_payload_fragment_length = io_input_payload_fragment_length;
  assign io_outputs_0_payload_fragment_context = io_input_payload_fragment_context;
  assign io_outputs_1_valid = (io_input_valid && _zz_2);
  assign io_outputs_1_payload_last = io_input_payload_last;
  assign io_outputs_1_payload_fragment_opcode = io_input_payload_fragment_opcode;
  assign io_outputs_1_payload_fragment_address = io_input_payload_fragment_address;
  assign io_outputs_1_payload_fragment_length = io_input_payload_fragment_length;
  assign io_outputs_1_payload_fragment_context = io_input_payload_fragment_context;
  always @ (posedge clk) begin
    if(reset) begin
      _zz_1 <= 1'b1;
      _zz_2 <= 1'b1;
    end else begin
      if((io_outputs_0_valid && io_outputs_0_ready))begin
        _zz_1 <= 1'b0;
      end
      if((io_outputs_1_valid && io_outputs_1_ready))begin
        _zz_2 <= 1'b0;
      end
      if(io_input_ready)begin
        _zz_1 <= 1'b1;
        _zz_2 <= 1'b1;
      end
    end
  end


endmodule

//dma_socRuby_BufferCC replaced by dma_socRuby_BufferCC

module dma_socRuby_BufferCC_1 (
  input               io_dataIn,
  output              io_dataOut,
  input               clk,
  input               reset
);
  (* async_reg *) reg                 buffers_0;
  (* async_reg *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge clk) begin
    if(reset) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module dma_socRuby_BufferCC (
  input               io_dataIn,
  output              io_dataOut,
  input               ctrl_clk,
  input               ctrl_reset
);
  (* async_reg *) reg                 buffers_0;
  (* async_reg *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge ctrl_clk) begin
    if(ctrl_reset) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
