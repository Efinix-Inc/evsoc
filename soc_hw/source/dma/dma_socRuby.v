///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020 github-efx
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

// Generator : SpinalHDL v1.4.2    git head : 68df843068cb6532edf7bbe2830c394f1791233d
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
  input      [255:0]  read_rdata,
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
  output     [255:0]  write_wdata,
  output     [31:0]   write_wstrb,
  output              write_wlast,
  input               write_bvalid,
  output              write_bready,
  input      [1:0]    write_bresp,
  input               dat0_i_tvalid,
  output              dat0_i_tready,
  input      [63:0]   dat0_i_tdata,
  input      [7:0]    dat0_i_tkeep,
  input      [3:0]    dat0_i_tdest,
  input               dat0_i_tlast,
  input               dat1_i_tvalid,
  output              dat1_i_tready,
  input      [31:0]   dat1_i_tdata,
  input      [3:0]    dat1_i_tkeep,
  input      [3:0]    dat1_i_tdest,
  input               dat1_i_tlast,
  output              dat0_o_tvalid,
  input               dat0_o_tready,
  output     [63:0]   dat0_o_tdata,
  output     [7:0]    dat0_o_tkeep,
  output     [3:0]    dat0_o_tdest,
  output              dat0_o_tlast,
  output              dat1_o_tvalid,
  input               dat1_o_tready,
  output     [31:0]   dat1_o_tdata,
  output     [3:0]    dat1_o_tkeep,
  output     [3:0]    dat1_o_tdest,
  output              dat1_o_tlast,
  output              io_0_descriptorUpdate,
  output              io_1_descriptorUpdate,
  output              io_2_descriptorUpdate,
  output              io_3_descriptorUpdate,
  input               clk,
  input               reset,
  input               ctrl_clk,
  input               ctrl_reset,
  input               dat0_i_clk,
  input               dat0_i_reset,
  input               dat1_i_clk,
  input               dat1_i_reset,
  input               dat0_o_clk,
  input               dat0_o_reset,
  input               dat1_o_clk,
  input               dat1_o_reset
);
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  wire                _zz_6;
  wire                _zz_7;
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
  wire       [63:0]   core_io_sgWrite_cmd_payload_fragment_data;
  wire       [7:0]    core_io_sgWrite_cmd_payload_fragment_mask;
  wire       [1:0]    core_io_sgWrite_cmd_payload_fragment_context;
  wire                core_io_sgWrite_rsp_ready;
  wire                core_io_read_cmd_valid;
  wire                core_io_read_cmd_payload_last;
  wire       [0:0]    core_io_read_cmd_payload_fragment_source;
  wire       [0:0]    core_io_read_cmd_payload_fragment_opcode;
  wire       [31:0]   core_io_read_cmd_payload_fragment_address;
  wire       [10:0]   core_io_read_cmd_payload_fragment_length;
  wire       [18:0]   core_io_read_cmd_payload_fragment_context;
  wire                core_io_read_rsp_ready;
  wire                core_io_write_cmd_valid;
  wire                core_io_write_cmd_payload_last;
  wire       [0:0]    core_io_write_cmd_payload_fragment_source;
  wire       [0:0]    core_io_write_cmd_payload_fragment_opcode;
  wire       [31:0]   core_io_write_cmd_payload_fragment_address;
  wire       [10:0]   core_io_write_cmd_payload_fragment_length;
  wire       [63:0]   core_io_write_cmd_payload_fragment_data;
  wire       [7:0]    core_io_write_cmd_payload_fragment_mask;
  wire       [12:0]   core_io_write_cmd_payload_fragment_context;
  wire                core_io_write_rsp_ready;
  wire                core_io_outputs_0_valid;
  wire       [63:0]   core_io_outputs_0_payload_data;
  wire       [7:0]    core_io_outputs_0_payload_mask;
  wire       [3:0]    core_io_outputs_0_payload_sink;
  wire                core_io_outputs_0_payload_last;
  wire                core_io_outputs_1_valid;
  wire       [63:0]   core_io_outputs_1_payload_data;
  wire       [7:0]    core_io_outputs_1_payload_mask;
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
  wire       [63:0]   interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_data;
  wire       [1:0]    interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_context;
  wire                interconnect_read_aggregated_arbiter_io_inputs_1_cmd_ready;
  wire                interconnect_read_aggregated_arbiter_io_inputs_1_rsp_valid;
  wire                interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_last;
  wire       [0:0]    interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode;
  wire       [63:0]   interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_data;
  wire       [18:0]   interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context;
  wire                interconnect_read_aggregated_arbiter_io_output_cmd_valid;
  wire                interconnect_read_aggregated_arbiter_io_output_cmd_payload_last;
  wire       [1:0]    interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_address;
  wire       [10:0]   interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_length;
  wire       [18:0]   interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_context;
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
  wire       [12:0]   interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context;
  wire                interconnect_write_aggregated_arbiter_io_output_cmd_valid;
  wire                interconnect_write_aggregated_arbiter_io_output_cmd_payload_last;
  wire       [1:0]    interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_source;
  wire       [0:0]    interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_address;
  wire       [10:0]   interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_length;
  wire       [63:0]   interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_data;
  wire       [7:0]    interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_mask;
  wire       [12:0]   interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_context;
  wire                interconnect_write_aggregated_arbiter_io_output_rsp_ready;
  wire                bmbUpSizerBridge_io_input_cmd_ready;
  wire                bmbUpSizerBridge_io_input_rsp_valid;
  wire                bmbUpSizerBridge_io_input_rsp_payload_last;
  wire       [1:0]    bmbUpSizerBridge_io_input_rsp_payload_fragment_source;
  wire       [0:0]    bmbUpSizerBridge_io_input_rsp_payload_fragment_opcode;
  wire       [63:0]   bmbUpSizerBridge_io_input_rsp_payload_fragment_data;
  wire       [18:0]   bmbUpSizerBridge_io_input_rsp_payload_fragment_context;
  wire                bmbUpSizerBridge_io_output_cmd_valid;
  wire                bmbUpSizerBridge_io_output_cmd_payload_last;
  wire       [1:0]    bmbUpSizerBridge_io_output_cmd_payload_fragment_source;
  wire       [0:0]    bmbUpSizerBridge_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   bmbUpSizerBridge_io_output_cmd_payload_fragment_address;
  wire       [10:0]   bmbUpSizerBridge_io_output_cmd_payload_fragment_length;
  wire       [22:0]   bmbUpSizerBridge_io_output_cmd_payload_fragment_context;
  wire                bmbUpSizerBridge_io_output_rsp_ready;
  wire                readLogic_sourceRemover_io_input_cmd_ready;
  wire                readLogic_sourceRemover_io_input_rsp_valid;
  wire                readLogic_sourceRemover_io_input_rsp_payload_last;
  wire       [1:0]    readLogic_sourceRemover_io_input_rsp_payload_fragment_source;
  wire       [0:0]    readLogic_sourceRemover_io_input_rsp_payload_fragment_opcode;
  wire       [255:0]  readLogic_sourceRemover_io_input_rsp_payload_fragment_data;
  wire       [22:0]   readLogic_sourceRemover_io_input_rsp_payload_fragment_context;
  wire                readLogic_sourceRemover_io_output_cmd_valid;
  wire                readLogic_sourceRemover_io_output_cmd_payload_last;
  wire       [0:0]    readLogic_sourceRemover_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   readLogic_sourceRemover_io_output_cmd_payload_fragment_address;
  wire       [10:0]   readLogic_sourceRemover_io_output_cmd_payload_fragment_length;
  wire       [24:0]   readLogic_sourceRemover_io_output_cmd_payload_fragment_context;
  wire                readLogic_sourceRemover_io_output_rsp_ready;
  wire                readLogic_bridge_io_input_cmd_ready;
  wire                readLogic_bridge_io_input_rsp_valid;
  wire                readLogic_bridge_io_input_rsp_payload_last;
  wire       [0:0]    readLogic_bridge_io_input_rsp_payload_fragment_opcode;
  wire       [255:0]  readLogic_bridge_io_input_rsp_payload_fragment_data;
  wire       [24:0]   readLogic_bridge_io_input_rsp_payload_fragment_context;
  wire                readLogic_bridge_io_output_ar_valid;
  wire       [31:0]   readLogic_bridge_io_output_ar_payload_addr;
  wire       [7:0]    readLogic_bridge_io_output_ar_payload_len;
  wire       [2:0]    readLogic_bridge_io_output_ar_payload_size;
  wire       [3:0]    readLogic_bridge_io_output_ar_payload_cache;
  wire       [2:0]    readLogic_bridge_io_output_ar_payload_prot;
  wire                readLogic_bridge_io_output_r_ready;
  wire                bmbUpSizerBridge_1_io_input_cmd_ready;
  wire                bmbUpSizerBridge_1_io_input_rsp_valid;
  wire                bmbUpSizerBridge_1_io_input_rsp_payload_last;
  wire       [1:0]    bmbUpSizerBridge_1_io_input_rsp_payload_fragment_source;
  wire       [0:0]    bmbUpSizerBridge_1_io_input_rsp_payload_fragment_opcode;
  wire       [12:0]   bmbUpSizerBridge_1_io_input_rsp_payload_fragment_context;
  wire                bmbUpSizerBridge_1_io_output_cmd_valid;
  wire                bmbUpSizerBridge_1_io_output_cmd_payload_last;
  wire       [1:0]    bmbUpSizerBridge_1_io_output_cmd_payload_fragment_source;
  wire       [0:0]    bmbUpSizerBridge_1_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   bmbUpSizerBridge_1_io_output_cmd_payload_fragment_address;
  wire       [10:0]   bmbUpSizerBridge_1_io_output_cmd_payload_fragment_length;
  wire       [255:0]  bmbUpSizerBridge_1_io_output_cmd_payload_fragment_data;
  wire       [31:0]   bmbUpSizerBridge_1_io_output_cmd_payload_fragment_mask;
  wire       [12:0]   bmbUpSizerBridge_1_io_output_cmd_payload_fragment_context;
  wire                bmbUpSizerBridge_1_io_output_rsp_ready;
  wire                writeLogic_sourceRemover_io_input_cmd_ready;
  wire                writeLogic_sourceRemover_io_input_rsp_valid;
  wire                writeLogic_sourceRemover_io_input_rsp_payload_last;
  wire       [1:0]    writeLogic_sourceRemover_io_input_rsp_payload_fragment_source;
  wire       [0:0]    writeLogic_sourceRemover_io_input_rsp_payload_fragment_opcode;
  wire       [12:0]   writeLogic_sourceRemover_io_input_rsp_payload_fragment_context;
  wire                writeLogic_sourceRemover_io_output_cmd_valid;
  wire                writeLogic_sourceRemover_io_output_cmd_payload_last;
  wire       [0:0]    writeLogic_sourceRemover_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   writeLogic_sourceRemover_io_output_cmd_payload_fragment_address;
  wire       [10:0]   writeLogic_sourceRemover_io_output_cmd_payload_fragment_length;
  wire       [255:0]  writeLogic_sourceRemover_io_output_cmd_payload_fragment_data;
  wire       [31:0]   writeLogic_sourceRemover_io_output_cmd_payload_fragment_mask;
  wire       [14:0]   writeLogic_sourceRemover_io_output_cmd_payload_fragment_context;
  wire                writeLogic_sourceRemover_io_output_rsp_ready;
  wire                writeLogic_bridge_io_input_cmd_ready;
  wire                writeLogic_bridge_io_input_rsp_valid;
  wire                writeLogic_bridge_io_input_rsp_payload_last;
  wire       [0:0]    writeLogic_bridge_io_input_rsp_payload_fragment_opcode;
  wire       [14:0]   writeLogic_bridge_io_input_rsp_payload_fragment_context;
  wire                writeLogic_bridge_io_output_aw_valid;
  wire       [31:0]   writeLogic_bridge_io_output_aw_payload_addr;
  wire       [7:0]    writeLogic_bridge_io_output_aw_payload_len;
  wire       [2:0]    writeLogic_bridge_io_output_aw_payload_size;
  wire       [3:0]    writeLogic_bridge_io_output_aw_payload_cache;
  wire       [2:0]    writeLogic_bridge_io_output_aw_payload_prot;
  wire                writeLogic_bridge_io_output_w_valid;
  wire       [255:0]  writeLogic_bridge_io_output_w_payload_data;
  wire       [31:0]   writeLogic_bridge_io_output_w_payload_strb;
  wire                writeLogic_bridge_io_output_w_payload_last;
  wire                writeLogic_bridge_io_output_b_ready;
  wire                inputsAdapter_0_crossclock_fifo_io_push_ready;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_valid;
  wire       [63:0]   inputsAdapter_0_crossclock_fifo_io_pop_payload_data;
  wire       [7:0]    inputsAdapter_0_crossclock_fifo_io_pop_payload_mask;
  wire       [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_payload_sink;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_payload_last;
  wire       [4:0]    inputsAdapter_0_crossclock_fifo_io_pushOccupancy;
  wire       [4:0]    inputsAdapter_0_crossclock_fifo_io_popOccupancy;
  wire                inputsAdapter_1_crossclock_fifo_io_push_ready;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_valid;
  wire       [31:0]   inputsAdapter_1_crossclock_fifo_io_pop_payload_data;
  wire       [3:0]    inputsAdapter_1_crossclock_fifo_io_pop_payload_mask;
  wire       [3:0]    inputsAdapter_1_crossclock_fifo_io_pop_payload_sink;
  wire                inputsAdapter_1_crossclock_fifo_io_pop_payload_last;
  wire       [4:0]    inputsAdapter_1_crossclock_fifo_io_pushOccupancy;
  wire       [4:0]    inputsAdapter_1_crossclock_fifo_io_popOccupancy;
  wire                inputsAdapter_1_upsizer_logic_io_input_ready;
  wire                inputsAdapter_1_upsizer_logic_io_output_valid;
  wire       [63:0]   inputsAdapter_1_upsizer_logic_io_output_payload_data;
  wire       [7:0]    inputsAdapter_1_upsizer_logic_io_output_payload_mask;
  wire       [3:0]    inputsAdapter_1_upsizer_logic_io_output_payload_sink;
  wire                inputsAdapter_1_upsizer_logic_io_output_payload_last;
  wire                outputsAdapter_0_crossclock_fifo_io_push_ready;
  wire                outputsAdapter_0_crossclock_fifo_io_pop_valid;
  wire       [63:0]   outputsAdapter_0_crossclock_fifo_io_pop_payload_data;
  wire       [7:0]    outputsAdapter_0_crossclock_fifo_io_pop_payload_mask;
  wire       [3:0]    outputsAdapter_0_crossclock_fifo_io_pop_payload_sink;
  wire                outputsAdapter_0_crossclock_fifo_io_pop_payload_last;
  wire       [4:0]    outputsAdapter_0_crossclock_fifo_io_pushOccupancy;
  wire       [4:0]    outputsAdapter_0_crossclock_fifo_io_popOccupancy;
  wire                outputsAdapter_1_sparseDownsizer_logic_io_input_ready;
  wire                outputsAdapter_1_sparseDownsizer_logic_io_output_valid;
  wire       [31:0]   outputsAdapter_1_sparseDownsizer_logic_io_output_payload_data;
  wire       [3:0]    outputsAdapter_1_sparseDownsizer_logic_io_output_payload_mask;
  wire       [3:0]    outputsAdapter_1_sparseDownsizer_logic_io_output_payload_sink;
  wire                outputsAdapter_1_sparseDownsizer_logic_io_output_payload_last;
  wire                outputsAdapter_1_crossclock_fifo_io_push_ready;
  wire                outputsAdapter_1_crossclock_fifo_io_pop_valid;
  wire       [31:0]   outputsAdapter_1_crossclock_fifo_io_pop_payload_data;
  wire       [3:0]    outputsAdapter_1_crossclock_fifo_io_pop_payload_mask;
  wire       [3:0]    outputsAdapter_1_crossclock_fifo_io_pop_payload_sink;
  wire                outputsAdapter_1_crossclock_fifo_io_pop_payload_last;
  wire       [4:0]    outputsAdapter_1_crossclock_fifo_io_pushOccupancy;
  wire       [4:0]    outputsAdapter_1_crossclock_fifo_io_popOccupancy;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  wire                _zz_12;
  wire                _zz_13;
  wire                _zz_14;
  wire                _zz_15;
  wire                _zz_16;
  wire                _zz_17;
  wire                _zz_18;
  wire                core_io_write_cmd_s2mPipe_valid;
  wire                core_io_write_cmd_s2mPipe_ready;
  wire                core_io_write_cmd_s2mPipe_payload_last;
  wire       [0:0]    core_io_write_cmd_s2mPipe_payload_fragment_source;
  wire       [0:0]    core_io_write_cmd_s2mPipe_payload_fragment_opcode;
  wire       [31:0]   core_io_write_cmd_s2mPipe_payload_fragment_address;
  wire       [10:0]   core_io_write_cmd_s2mPipe_payload_fragment_length;
  wire       [63:0]   core_io_write_cmd_s2mPipe_payload_fragment_data;
  wire       [7:0]    core_io_write_cmd_s2mPipe_payload_fragment_mask;
  wire       [12:0]   core_io_write_cmd_s2mPipe_payload_fragment_context;
  reg                 core_io_write_cmd_s2mPipe_rValid;
  reg                 core_io_write_cmd_s2mPipe_rData_last;
  reg        [0:0]    core_io_write_cmd_s2mPipe_rData_fragment_source;
  reg        [0:0]    core_io_write_cmd_s2mPipe_rData_fragment_opcode;
  reg        [31:0]   core_io_write_cmd_s2mPipe_rData_fragment_address;
  reg        [10:0]   core_io_write_cmd_s2mPipe_rData_fragment_length;
  reg        [63:0]   core_io_write_cmd_s2mPipe_rData_fragment_data;
  reg        [7:0]    core_io_write_cmd_s2mPipe_rData_fragment_mask;
  reg        [12:0]   core_io_write_cmd_s2mPipe_rData_fragment_context;
  wire                core_io_write_cmd_s2mPipe_m2sPipe_valid;
  wire                core_io_write_cmd_s2mPipe_m2sPipe_ready;
  wire                core_io_write_cmd_s2mPipe_m2sPipe_payload_last;
  wire       [0:0]    core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_source;
  wire       [0:0]    core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_opcode;
  wire       [31:0]   core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_address;
  wire       [10:0]   core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_length;
  wire       [63:0]   core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_data;
  wire       [7:0]    core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_mask;
  wire       [12:0]   core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_context;
  reg                 core_io_write_cmd_s2mPipe_m2sPipe_rValid;
  reg                 core_io_write_cmd_s2mPipe_m2sPipe_rData_last;
  reg        [0:0]    core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_source;
  reg        [0:0]    core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_opcode;
  reg        [31:0]   core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_address;
  reg        [10:0]   core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_length;
  reg        [63:0]   core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_data;
  reg        [7:0]    core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_mask;
  reg        [12:0]   core_io_write_cmd_s2mPipe_m2sPipe_rData_fragment_context;
  wire                interconnect_read_aggregated_cmd_valid;
  wire                interconnect_read_aggregated_cmd_ready;
  wire                interconnect_read_aggregated_cmd_payload_last;
  wire       [1:0]    interconnect_read_aggregated_cmd_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_cmd_payload_fragment_opcode;
  wire       [31:0]   interconnect_read_aggregated_cmd_payload_fragment_address;
  wire       [10:0]   interconnect_read_aggregated_cmd_payload_fragment_length;
  wire       [18:0]   interconnect_read_aggregated_cmd_payload_fragment_context;
  wire                interconnect_read_aggregated_rsp_valid;
  wire                interconnect_read_aggregated_rsp_ready;
  wire                interconnect_read_aggregated_rsp_payload_last;
  wire       [1:0]    interconnect_read_aggregated_rsp_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_rsp_payload_fragment_opcode;
  wire       [63:0]   interconnect_read_aggregated_rsp_payload_fragment_data;
  wire       [18:0]   interconnect_read_aggregated_rsp_payload_fragment_context;
  wire                interconnect_write_aggregated_cmd_valid;
  wire                interconnect_write_aggregated_cmd_ready;
  wire                interconnect_write_aggregated_cmd_payload_last;
  wire       [1:0]    interconnect_write_aggregated_cmd_payload_fragment_source;
  wire       [0:0]    interconnect_write_aggregated_cmd_payload_fragment_opcode;
  wire       [31:0]   interconnect_write_aggregated_cmd_payload_fragment_address;
  wire       [10:0]   interconnect_write_aggregated_cmd_payload_fragment_length;
  wire       [63:0]   interconnect_write_aggregated_cmd_payload_fragment_data;
  wire       [7:0]    interconnect_write_aggregated_cmd_payload_fragment_mask;
  wire       [12:0]   interconnect_write_aggregated_cmd_payload_fragment_context;
  wire                interconnect_write_aggregated_rsp_valid;
  wire                interconnect_write_aggregated_rsp_ready;
  wire                interconnect_write_aggregated_rsp_payload_last;
  wire       [1:0]    interconnect_write_aggregated_rsp_payload_fragment_source;
  wire       [0:0]    interconnect_write_aggregated_rsp_payload_fragment_opcode;
  wire       [12:0]   interconnect_write_aggregated_rsp_payload_fragment_context;
  wire                interconnect_read_aggregated_cmd_halfPipe_valid;
  wire                interconnect_read_aggregated_cmd_halfPipe_ready;
  wire                interconnect_read_aggregated_cmd_halfPipe_payload_last;
  wire       [1:0]    interconnect_read_aggregated_cmd_halfPipe_payload_fragment_source;
  wire       [0:0]    interconnect_read_aggregated_cmd_halfPipe_payload_fragment_opcode;
  wire       [31:0]   interconnect_read_aggregated_cmd_halfPipe_payload_fragment_address;
  wire       [10:0]   interconnect_read_aggregated_cmd_halfPipe_payload_fragment_length;
  wire       [18:0]   interconnect_read_aggregated_cmd_halfPipe_payload_fragment_context;
  reg                 interconnect_read_aggregated_cmd_halfPipe_regs_valid;
  reg                 interconnect_read_aggregated_cmd_halfPipe_regs_ready;
  reg                 interconnect_read_aggregated_cmd_halfPipe_regs_payload_last;
  reg        [1:0]    interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_source;
  reg        [0:0]    interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_opcode;
  reg        [31:0]   interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_address;
  reg        [10:0]   interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_length;
  reg        [18:0]   interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_context;
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
  wire       [255:0]  readLogic_adapter_r_payload_data;
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
  wire       [255:0]  read_r_s2mPipe_payload_data;
  wire       [1:0]    read_r_s2mPipe_payload_resp;
  wire                read_r_s2mPipe_payload_last;
  reg                 read_r_s2mPipe_rValid;
  reg        [255:0]  read_r_s2mPipe_rData_data;
  reg        [1:0]    read_r_s2mPipe_rData_resp;
  reg                 read_r_s2mPipe_rData_last;
  wire                read_r_s2mPipe_m2sPipe_valid;
  wire                read_r_s2mPipe_m2sPipe_ready;
  wire       [255:0]  read_r_s2mPipe_m2sPipe_payload_data;
  wire       [1:0]    read_r_s2mPipe_m2sPipe_payload_resp;
  wire                read_r_s2mPipe_m2sPipe_payload_last;
  reg                 read_r_s2mPipe_m2sPipe_rValid;
  reg        [255:0]  read_r_s2mPipe_m2sPipe_rData_data;
  reg        [1:0]    read_r_s2mPipe_m2sPipe_rData_resp;
  reg                 read_r_s2mPipe_m2sPipe_rData_last;
  wire                interconnect_write_aggregated_cmd_m2sPipe_valid;
  wire                interconnect_write_aggregated_cmd_m2sPipe_ready;
  wire                interconnect_write_aggregated_cmd_m2sPipe_payload_last;
  wire       [1:0]    interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_source;
  wire       [0:0]    interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_opcode;
  wire       [31:0]   interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_address;
  wire       [10:0]   interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_length;
  wire       [63:0]   interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_data;
  wire       [7:0]    interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_mask;
  wire       [12:0]   interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_context;
  reg                 interconnect_write_aggregated_cmd_m2sPipe_rValid;
  reg                 interconnect_write_aggregated_cmd_m2sPipe_rData_last;
  reg        [1:0]    interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_source;
  reg        [0:0]    interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_opcode;
  reg        [31:0]   interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_address;
  reg        [10:0]   interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_length;
  reg        [63:0]   interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_data;
  reg        [7:0]    interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_mask;
  reg        [12:0]   interconnect_write_aggregated_cmd_m2sPipe_rData_fragment_context;
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
  wire       [255:0]  writeLogic_adapter_w_payload_data;
  wire       [31:0]   writeLogic_adapter_w_payload_strb;
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
  wire       [255:0]  writeLogic_adapter_w_s2mPipe_payload_data;
  wire       [31:0]   writeLogic_adapter_w_s2mPipe_payload_strb;
  wire                writeLogic_adapter_w_s2mPipe_payload_last;
  reg                 writeLogic_adapter_w_s2mPipe_rValid;
  reg        [255:0]  writeLogic_adapter_w_s2mPipe_rData_data;
  reg        [31:0]   writeLogic_adapter_w_s2mPipe_rData_strb;
  reg                 writeLogic_adapter_w_s2mPipe_rData_last;
  wire                writeLogic_adapter_w_s2mPipe_m2sPipe_valid;
  wire                writeLogic_adapter_w_s2mPipe_m2sPipe_ready;
  wire       [255:0]  writeLogic_adapter_w_s2mPipe_m2sPipe_payload_data;
  wire       [31:0]   writeLogic_adapter_w_s2mPipe_m2sPipe_payload_strb;
  wire                writeLogic_adapter_w_s2mPipe_m2sPipe_payload_last;
  reg                 writeLogic_adapter_w_s2mPipe_m2sPipe_rValid;
  reg        [255:0]  writeLogic_adapter_w_s2mPipe_m2sPipe_rData_data;
  reg        [31:0]   writeLogic_adapter_w_s2mPipe_m2sPipe_rData_strb;
  reg                 writeLogic_adapter_w_s2mPipe_m2sPipe_rData_last;
  wire                write_b_halfPipe_valid;
  wire                write_b_halfPipe_ready;
  wire       [1:0]    write_b_halfPipe_payload_resp;
  reg                 write_b_halfPipe_regs_valid;
  reg                 write_b_halfPipe_regs_ready;
  reg        [1:0]    write_b_halfPipe_regs_payload_resp;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_valid;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready;
  wire       [63:0]   inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_data;
  wire       [7:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_mask;
  wire       [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_sink;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_payload_last;
  reg                 inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid;
  reg        [63:0]   inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_data;
  reg        [7:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_mask;
  reg        [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_sink;
  reg                 inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rData_last;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_ready;
  wire       [63:0]   inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_data;
  wire       [7:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_mask;
  wire       [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_sink;
  wire                inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_last;
  reg                 inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid;
  reg        [63:0]   inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_data;
  reg        [7:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_mask;
  reg        [3:0]    inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_sink;
  reg                 inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rData_last;
  wire                inputsAdapter_1_upsizer_logic_io_output_s2mPipe_valid;
  wire                inputsAdapter_1_upsizer_logic_io_output_s2mPipe_ready;
  wire       [63:0]   inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_data;
  wire       [7:0]    inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_mask;
  wire       [3:0]    inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_sink;
  wire                inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_last;
  reg                 inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid;
  reg        [63:0]   inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_data;
  reg        [7:0]    inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_mask;
  reg        [3:0]    inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_sink;
  reg                 inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_last;
  wire                inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_valid;
  wire                inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_ready;
  wire       [63:0]   inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_data;
  wire       [7:0]    inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_mask;
  wire       [3:0]    inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_sink;
  wire                inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_last;
  reg                 inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rValid;
  reg        [63:0]   inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_data;
  reg        [7:0]    inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_mask;
  reg        [3:0]    inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_sink;
  reg                 inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_last;
  wire                core_io_outputs_0_s2mPipe_valid;
  wire                core_io_outputs_0_s2mPipe_ready;
  wire       [63:0]   core_io_outputs_0_s2mPipe_payload_data;
  wire       [7:0]    core_io_outputs_0_s2mPipe_payload_mask;
  wire       [3:0]    core_io_outputs_0_s2mPipe_payload_sink;
  wire                core_io_outputs_0_s2mPipe_payload_last;
  reg                 core_io_outputs_0_s2mPipe_rValid;
  reg        [63:0]   core_io_outputs_0_s2mPipe_rData_data;
  reg        [7:0]    core_io_outputs_0_s2mPipe_rData_mask;
  reg        [3:0]    core_io_outputs_0_s2mPipe_rData_sink;
  reg                 core_io_outputs_0_s2mPipe_rData_last;
  wire                outputsAdapter_0_ptr_valid;
  wire                outputsAdapter_0_ptr_ready;
  wire       [63:0]   outputsAdapter_0_ptr_payload_data;
  wire       [7:0]    outputsAdapter_0_ptr_payload_mask;
  wire       [3:0]    outputsAdapter_0_ptr_payload_sink;
  wire                outputsAdapter_0_ptr_payload_last;
  reg                 core_io_outputs_0_s2mPipe_m2sPipe_rValid;
  reg        [63:0]   core_io_outputs_0_s2mPipe_m2sPipe_rData_data;
  reg        [7:0]    core_io_outputs_0_s2mPipe_m2sPipe_rData_mask;
  reg        [3:0]    core_io_outputs_0_s2mPipe_m2sPipe_rData_sink;
  reg                 core_io_outputs_0_s2mPipe_m2sPipe_rData_last;
  wire                core_io_outputs_1_s2mPipe_valid;
  wire                core_io_outputs_1_s2mPipe_ready;
  wire       [63:0]   core_io_outputs_1_s2mPipe_payload_data;
  wire       [7:0]    core_io_outputs_1_s2mPipe_payload_mask;
  wire       [3:0]    core_io_outputs_1_s2mPipe_payload_sink;
  wire                core_io_outputs_1_s2mPipe_payload_last;
  reg                 core_io_outputs_1_s2mPipe_rValid;
  reg        [63:0]   core_io_outputs_1_s2mPipe_rData_data;
  reg        [7:0]    core_io_outputs_1_s2mPipe_rData_mask;
  reg        [3:0]    core_io_outputs_1_s2mPipe_rData_sink;
  reg                 core_io_outputs_1_s2mPipe_rData_last;
  wire                outputsAdapter_1_ptr_valid;
  wire                outputsAdapter_1_ptr_ready;
  wire       [63:0]   outputsAdapter_1_ptr_payload_data;
  wire       [7:0]    outputsAdapter_1_ptr_payload_mask;
  wire       [3:0]    outputsAdapter_1_ptr_payload_sink;
  wire                outputsAdapter_1_ptr_payload_last;
  reg                 core_io_outputs_1_s2mPipe_m2sPipe_rValid;
  reg        [63:0]   core_io_outputs_1_s2mPipe_m2sPipe_rData_data;
  reg        [7:0]    core_io_outputs_1_s2mPipe_m2sPipe_rData_mask;
  reg        [3:0]    core_io_outputs_1_s2mPipe_m2sPipe_rData_sink;
  reg                 core_io_outputs_1_s2mPipe_m2sPipe_rData_last;

  assign _zz_8 = (_zz_3 && (! core_io_write_cmd_s2mPipe_ready));
  assign _zz_9 = (! interconnect_read_aggregated_cmd_halfPipe_regs_valid);
  assign _zz_10 = (! readLogic_adapter_ar_halfPipe_regs_valid);
  assign _zz_11 = (read_rready && (! read_r_s2mPipe_ready));
  assign _zz_12 = (! writeLogic_adapter_aw_halfPipe_regs_valid);
  assign _zz_13 = (writeLogic_adapter_w_ready && (! writeLogic_adapter_w_s2mPipe_ready));
  assign _zz_14 = (! write_b_halfPipe_regs_valid);
  assign _zz_15 = (_zz_6 && (! inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready));
  assign _zz_16 = (_zz_7 && (! inputsAdapter_1_upsizer_logic_io_output_s2mPipe_ready));
  assign _zz_17 = (_zz_4 && (! core_io_outputs_0_s2mPipe_ready));
  assign _zz_18 = (_zz_5 && (! core_io_outputs_1_s2mPipe_ready));
  dma_socRuby_Core core (
    .io_0_descriptorUpdate                      (io_0_descriptorUpdate),
    .io_1_descriptorUpdate                      (io_1_descriptorUpdate),
    .io_2_descriptorUpdate                      (io_2_descriptorUpdate),
    .io_3_descriptorUpdate                      (io_3_descriptorUpdate),
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
    .io_sgRead_rsp_payload_fragment_data        (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_data[63:0]      ), //i
    .io_sgRead_rsp_payload_fragment_context     (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_context[1:0]    ), //i
    .io_sgWrite_cmd_valid                       (core_io_sgWrite_cmd_valid                                                             ), //o
    .io_sgWrite_cmd_ready                       (interconnect_write_aggregated_arbiter_io_inputs_0_cmd_ready                           ), //i
    .io_sgWrite_cmd_payload_last                (core_io_sgWrite_cmd_payload_last                                                      ), //o
    .io_sgWrite_cmd_payload_fragment_opcode     (core_io_sgWrite_cmd_payload_fragment_opcode                                           ), //o
    .io_sgWrite_cmd_payload_fragment_address    (core_io_sgWrite_cmd_payload_fragment_address[31:0]                                    ), //o
    .io_sgWrite_cmd_payload_fragment_length     (core_io_sgWrite_cmd_payload_fragment_length[1:0]                                      ), //o
    .io_sgWrite_cmd_payload_fragment_data       (core_io_sgWrite_cmd_payload_fragment_data[63:0]                                       ), //o
    .io_sgWrite_cmd_payload_fragment_mask       (core_io_sgWrite_cmd_payload_fragment_mask[7:0]                                        ), //o
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
    .io_read_cmd_payload_fragment_length        (core_io_read_cmd_payload_fragment_length[10:0]                                        ), //o
    .io_read_cmd_payload_fragment_context       (core_io_read_cmd_payload_fragment_context[18:0]                                       ), //o
    .io_read_rsp_valid                          (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_valid                            ), //i
    .io_read_rsp_ready                          (core_io_read_rsp_ready                                                                ), //o
    .io_read_rsp_payload_last                   (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_last                     ), //i
    .io_read_rsp_payload_fragment_source        (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source          ), //i
    .io_read_rsp_payload_fragment_opcode        (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode          ), //i
    .io_read_rsp_payload_fragment_data          (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_data[63:0]      ), //i
    .io_read_rsp_payload_fragment_context       (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context[18:0]   ), //i
    .io_write_cmd_valid                         (core_io_write_cmd_valid                                                               ), //o
    .io_write_cmd_ready                         (_zz_3                                                                                 ), //i
    .io_write_cmd_payload_last                  (core_io_write_cmd_payload_last                                                        ), //o
    .io_write_cmd_payload_fragment_source       (core_io_write_cmd_payload_fragment_source                                             ), //o
    .io_write_cmd_payload_fragment_opcode       (core_io_write_cmd_payload_fragment_opcode                                             ), //o
    .io_write_cmd_payload_fragment_address      (core_io_write_cmd_payload_fragment_address[31:0]                                      ), //o
    .io_write_cmd_payload_fragment_length       (core_io_write_cmd_payload_fragment_length[10:0]                                       ), //o
    .io_write_cmd_payload_fragment_data         (core_io_write_cmd_payload_fragment_data[63:0]                                         ), //o
    .io_write_cmd_payload_fragment_mask         (core_io_write_cmd_payload_fragment_mask[7:0]                                          ), //o
    .io_write_cmd_payload_fragment_context      (core_io_write_cmd_payload_fragment_context[12:0]                                      ), //o
    .io_write_rsp_valid                         (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_valid                           ), //i
    .io_write_rsp_ready                         (core_io_write_rsp_ready                                                               ), //o
    .io_write_rsp_payload_last                  (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_last                    ), //i
    .io_write_rsp_payload_fragment_source       (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source         ), //i
    .io_write_rsp_payload_fragment_opcode       (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode         ), //i
    .io_write_rsp_payload_fragment_context      (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context[12:0]  ), //i
    .io_outputs_0_valid                         (core_io_outputs_0_valid                                                               ), //o
    .io_outputs_0_ready                         (_zz_4                                                                                 ), //i
    .io_outputs_0_payload_data                  (core_io_outputs_0_payload_data[63:0]                                                  ), //o
    .io_outputs_0_payload_mask                  (core_io_outputs_0_payload_mask[7:0]                                                   ), //o
    .io_outputs_0_payload_sink                  (core_io_outputs_0_payload_sink[3:0]                                                   ), //o
    .io_outputs_0_payload_last                  (core_io_outputs_0_payload_last                                                        ), //o
    .io_outputs_1_valid                         (core_io_outputs_1_valid                                                               ), //o
    .io_outputs_1_ready                         (_zz_5                                                                                 ), //i
    .io_outputs_1_payload_data                  (core_io_outputs_1_payload_data[63:0]                                                  ), //o
    .io_outputs_1_payload_mask                  (core_io_outputs_1_payload_mask[7:0]                                                   ), //o
    .io_outputs_1_payload_sink                  (core_io_outputs_1_payload_sink[3:0]                                                   ), //o
    .io_outputs_1_payload_last                  (core_io_outputs_1_payload_last                                                        ), //o
    .io_inputs_0_valid                          (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_valid                          ), //i
    .io_inputs_0_ready                          (core_io_inputs_0_ready                                                                ), //o
    .io_inputs_0_payload_data                   (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_data[63:0]             ), //i
    .io_inputs_0_payload_mask                   (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_mask[7:0]              ), //i
    .io_inputs_0_payload_sink                   (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_sink[3:0]              ), //i
    .io_inputs_0_payload_last                   (inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_payload_last                   ), //i
    .io_inputs_1_valid                          (inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_valid                         ), //i
    .io_inputs_1_ready                          (core_io_inputs_1_ready                                                                ), //o
    .io_inputs_1_payload_data                   (inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_data[63:0]            ), //i
    .io_inputs_1_payload_mask                   (inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_mask[7:0]             ), //i
    .io_inputs_1_payload_sink                   (inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_sink[3:0]             ), //i
    .io_inputs_1_payload_last                   (inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_last                  ), //i
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
    .io_inputs_0_rsp_payload_fragment_data       (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_data[63:0]     ), //o
    .io_inputs_0_rsp_payload_fragment_context    (interconnect_read_aggregated_arbiter_io_inputs_0_rsp_payload_fragment_context[1:0]   ), //o
    .io_inputs_1_cmd_valid                       (core_io_read_cmd_valid                                                               ), //i
    .io_inputs_1_cmd_ready                       (interconnect_read_aggregated_arbiter_io_inputs_1_cmd_ready                           ), //o
    .io_inputs_1_cmd_payload_last                (core_io_read_cmd_payload_last                                                        ), //i
    .io_inputs_1_cmd_payload_fragment_source     (core_io_read_cmd_payload_fragment_source                                             ), //i
    .io_inputs_1_cmd_payload_fragment_opcode     (core_io_read_cmd_payload_fragment_opcode                                             ), //i
    .io_inputs_1_cmd_payload_fragment_address    (core_io_read_cmd_payload_fragment_address[31:0]                                      ), //i
    .io_inputs_1_cmd_payload_fragment_length     (core_io_read_cmd_payload_fragment_length[10:0]                                       ), //i
    .io_inputs_1_cmd_payload_fragment_context    (core_io_read_cmd_payload_fragment_context[18:0]                                      ), //i
    .io_inputs_1_rsp_valid                       (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_valid                           ), //o
    .io_inputs_1_rsp_ready                       (core_io_read_rsp_ready                                                               ), //i
    .io_inputs_1_rsp_payload_last                (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_last                    ), //o
    .io_inputs_1_rsp_payload_fragment_source     (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source         ), //o
    .io_inputs_1_rsp_payload_fragment_opcode     (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode         ), //o
    .io_inputs_1_rsp_payload_fragment_data       (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_data[63:0]     ), //o
    .io_inputs_1_rsp_payload_fragment_context    (interconnect_read_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context[18:0]  ), //o
    .io_output_cmd_valid                         (interconnect_read_aggregated_arbiter_io_output_cmd_valid                             ), //o
    .io_output_cmd_ready                         (interconnect_read_aggregated_cmd_ready                                               ), //i
    .io_output_cmd_payload_last                  (interconnect_read_aggregated_arbiter_io_output_cmd_payload_last                      ), //o
    .io_output_cmd_payload_fragment_source       (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_source[1:0]      ), //o
    .io_output_cmd_payload_fragment_opcode       (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_opcode           ), //o
    .io_output_cmd_payload_fragment_address      (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_address[31:0]    ), //o
    .io_output_cmd_payload_fragment_length       (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_length[10:0]     ), //o
    .io_output_cmd_payload_fragment_context      (interconnect_read_aggregated_arbiter_io_output_cmd_payload_fragment_context[18:0]    ), //o
    .io_output_rsp_valid                         (interconnect_read_aggregated_rsp_valid                                               ), //i
    .io_output_rsp_ready                         (interconnect_read_aggregated_arbiter_io_output_rsp_ready                             ), //o
    .io_output_rsp_payload_last                  (interconnect_read_aggregated_rsp_payload_last                                        ), //i
    .io_output_rsp_payload_fragment_source       (interconnect_read_aggregated_rsp_payload_fragment_source[1:0]                        ), //i
    .io_output_rsp_payload_fragment_opcode       (interconnect_read_aggregated_rsp_payload_fragment_opcode                             ), //i
    .io_output_rsp_payload_fragment_data         (interconnect_read_aggregated_rsp_payload_fragment_data[63:0]                         ), //i
    .io_output_rsp_payload_fragment_context      (interconnect_read_aggregated_rsp_payload_fragment_context[18:0]                      ), //i
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
    .io_inputs_0_cmd_payload_fragment_data       (core_io_sgWrite_cmd_payload_fragment_data[63:0]                                       ), //i
    .io_inputs_0_cmd_payload_fragment_mask       (core_io_sgWrite_cmd_payload_fragment_mask[7:0]                                        ), //i
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
    .io_inputs_1_cmd_payload_fragment_length     (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_length[10:0]                       ), //i
    .io_inputs_1_cmd_payload_fragment_data       (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_data[63:0]                         ), //i
    .io_inputs_1_cmd_payload_fragment_mask       (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_mask[7:0]                          ), //i
    .io_inputs_1_cmd_payload_fragment_context    (core_io_write_cmd_s2mPipe_m2sPipe_payload_fragment_context[12:0]                      ), //i
    .io_inputs_1_rsp_valid                       (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_valid                           ), //o
    .io_inputs_1_rsp_ready                       (core_io_write_rsp_ready                                                               ), //i
    .io_inputs_1_rsp_payload_last                (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_last                    ), //o
    .io_inputs_1_rsp_payload_fragment_source     (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_source         ), //o
    .io_inputs_1_rsp_payload_fragment_opcode     (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_opcode         ), //o
    .io_inputs_1_rsp_payload_fragment_context    (interconnect_write_aggregated_arbiter_io_inputs_1_rsp_payload_fragment_context[12:0]  ), //o
    .io_output_cmd_valid                         (interconnect_write_aggregated_arbiter_io_output_cmd_valid                             ), //o
    .io_output_cmd_ready                         (interconnect_write_aggregated_cmd_ready                                               ), //i
    .io_output_cmd_payload_last                  (interconnect_write_aggregated_arbiter_io_output_cmd_payload_last                      ), //o
    .io_output_cmd_payload_fragment_source       (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_source[1:0]      ), //o
    .io_output_cmd_payload_fragment_opcode       (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_opcode           ), //o
    .io_output_cmd_payload_fragment_address      (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_address[31:0]    ), //o
    .io_output_cmd_payload_fragment_length       (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_length[10:0]     ), //o
    .io_output_cmd_payload_fragment_data         (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_data[63:0]       ), //o
    .io_output_cmd_payload_fragment_mask         (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_mask[7:0]        ), //o
    .io_output_cmd_payload_fragment_context      (interconnect_write_aggregated_arbiter_io_output_cmd_payload_fragment_context[12:0]    ), //o
    .io_output_rsp_valid                         (interconnect_write_aggregated_rsp_valid                                               ), //i
    .io_output_rsp_ready                         (interconnect_write_aggregated_arbiter_io_output_rsp_ready                             ), //o
    .io_output_rsp_payload_last                  (interconnect_write_aggregated_rsp_payload_last                                        ), //i
    .io_output_rsp_payload_fragment_source       (interconnect_write_aggregated_rsp_payload_fragment_source[1:0]                        ), //i
    .io_output_rsp_payload_fragment_opcode       (interconnect_write_aggregated_rsp_payload_fragment_opcode                             ), //i
    .io_output_rsp_payload_fragment_context      (interconnect_write_aggregated_rsp_payload_fragment_context[12:0]                      ), //i
    .clk                                         (clk                                                                                   ), //i
    .reset                                       (reset                                                                                 )  //i
  );
  dma_socRuby_BmbUpSizerBridge bmbUpSizerBridge (
    .io_input_cmd_valid                        (interconnect_read_aggregated_cmd_halfPipe_valid                           ), //i
    .io_input_cmd_ready                        (bmbUpSizerBridge_io_input_cmd_ready                                       ), //o
    .io_input_cmd_payload_last                 (interconnect_read_aggregated_cmd_halfPipe_payload_last                    ), //i
    .io_input_cmd_payload_fragment_source      (interconnect_read_aggregated_cmd_halfPipe_payload_fragment_source[1:0]    ), //i
    .io_input_cmd_payload_fragment_opcode      (interconnect_read_aggregated_cmd_halfPipe_payload_fragment_opcode         ), //i
    .io_input_cmd_payload_fragment_address     (interconnect_read_aggregated_cmd_halfPipe_payload_fragment_address[31:0]  ), //i
    .io_input_cmd_payload_fragment_length      (interconnect_read_aggregated_cmd_halfPipe_payload_fragment_length[10:0]   ), //i
    .io_input_cmd_payload_fragment_context     (interconnect_read_aggregated_cmd_halfPipe_payload_fragment_context[18:0]  ), //i
    .io_input_rsp_valid                        (bmbUpSizerBridge_io_input_rsp_valid                                       ), //o
    .io_input_rsp_ready                        (interconnect_read_aggregated_rsp_ready                                    ), //i
    .io_input_rsp_payload_last                 (bmbUpSizerBridge_io_input_rsp_payload_last                                ), //o
    .io_input_rsp_payload_fragment_source      (bmbUpSizerBridge_io_input_rsp_payload_fragment_source[1:0]                ), //o
    .io_input_rsp_payload_fragment_opcode      (bmbUpSizerBridge_io_input_rsp_payload_fragment_opcode                     ), //o
    .io_input_rsp_payload_fragment_data        (bmbUpSizerBridge_io_input_rsp_payload_fragment_data[63:0]                 ), //o
    .io_input_rsp_payload_fragment_context     (bmbUpSizerBridge_io_input_rsp_payload_fragment_context[18:0]              ), //o
    .io_output_cmd_valid                       (bmbUpSizerBridge_io_output_cmd_valid                                      ), //o
    .io_output_cmd_ready                       (readLogic_sourceRemover_io_input_cmd_ready                                ), //i
    .io_output_cmd_payload_last                (bmbUpSizerBridge_io_output_cmd_payload_last                               ), //o
    .io_output_cmd_payload_fragment_source     (bmbUpSizerBridge_io_output_cmd_payload_fragment_source[1:0]               ), //o
    .io_output_cmd_payload_fragment_opcode     (bmbUpSizerBridge_io_output_cmd_payload_fragment_opcode                    ), //o
    .io_output_cmd_payload_fragment_address    (bmbUpSizerBridge_io_output_cmd_payload_fragment_address[31:0]             ), //o
    .io_output_cmd_payload_fragment_length     (bmbUpSizerBridge_io_output_cmd_payload_fragment_length[10:0]              ), //o
    .io_output_cmd_payload_fragment_context    (bmbUpSizerBridge_io_output_cmd_payload_fragment_context[22:0]             ), //o
    .io_output_rsp_valid                       (readLogic_sourceRemover_io_input_rsp_valid                                ), //i
    .io_output_rsp_ready                       (bmbUpSizerBridge_io_output_rsp_ready                                      ), //o
    .io_output_rsp_payload_last                (readLogic_sourceRemover_io_input_rsp_payload_last                         ), //i
    .io_output_rsp_payload_fragment_source     (readLogic_sourceRemover_io_input_rsp_payload_fragment_source[1:0]         ), //i
    .io_output_rsp_payload_fragment_opcode     (readLogic_sourceRemover_io_input_rsp_payload_fragment_opcode              ), //i
    .io_output_rsp_payload_fragment_data       (readLogic_sourceRemover_io_input_rsp_payload_fragment_data[255:0]         ), //i
    .io_output_rsp_payload_fragment_context    (readLogic_sourceRemover_io_input_rsp_payload_fragment_context[22:0]       ), //i
    .clk                                       (clk                                                                       ), //i
    .reset                                     (reset                                                                     )  //i
  );
  dma_socRuby_BmbSourceRemover readLogic_sourceRemover (
    .io_input_cmd_valid                        (bmbUpSizerBridge_io_output_cmd_valid                                  ), //i
    .io_input_cmd_ready                        (readLogic_sourceRemover_io_input_cmd_ready                            ), //o
    .io_input_cmd_payload_last                 (bmbUpSizerBridge_io_output_cmd_payload_last                           ), //i
    .io_input_cmd_payload_fragment_source      (bmbUpSizerBridge_io_output_cmd_payload_fragment_source[1:0]           ), //i
    .io_input_cmd_payload_fragment_opcode      (bmbUpSizerBridge_io_output_cmd_payload_fragment_opcode                ), //i
    .io_input_cmd_payload_fragment_address     (bmbUpSizerBridge_io_output_cmd_payload_fragment_address[31:0]         ), //i
    .io_input_cmd_payload_fragment_length      (bmbUpSizerBridge_io_output_cmd_payload_fragment_length[10:0]          ), //i
    .io_input_cmd_payload_fragment_context     (bmbUpSizerBridge_io_output_cmd_payload_fragment_context[22:0]         ), //i
    .io_input_rsp_valid                        (readLogic_sourceRemover_io_input_rsp_valid                            ), //o
    .io_input_rsp_ready                        (bmbUpSizerBridge_io_output_rsp_ready                                  ), //i
    .io_input_rsp_payload_last                 (readLogic_sourceRemover_io_input_rsp_payload_last                     ), //o
    .io_input_rsp_payload_fragment_source      (readLogic_sourceRemover_io_input_rsp_payload_fragment_source[1:0]     ), //o
    .io_input_rsp_payload_fragment_opcode      (readLogic_sourceRemover_io_input_rsp_payload_fragment_opcode          ), //o
    .io_input_rsp_payload_fragment_data        (readLogic_sourceRemover_io_input_rsp_payload_fragment_data[255:0]     ), //o
    .io_input_rsp_payload_fragment_context     (readLogic_sourceRemover_io_input_rsp_payload_fragment_context[22:0]   ), //o
    .io_output_cmd_valid                       (readLogic_sourceRemover_io_output_cmd_valid                           ), //o
    .io_output_cmd_ready                       (readLogic_bridge_io_input_cmd_ready                                   ), //i
    .io_output_cmd_payload_last                (readLogic_sourceRemover_io_output_cmd_payload_last                    ), //o
    .io_output_cmd_payload_fragment_opcode     (readLogic_sourceRemover_io_output_cmd_payload_fragment_opcode         ), //o
    .io_output_cmd_payload_fragment_address    (readLogic_sourceRemover_io_output_cmd_payload_fragment_address[31:0]  ), //o
    .io_output_cmd_payload_fragment_length     (readLogic_sourceRemover_io_output_cmd_payload_fragment_length[10:0]   ), //o
    .io_output_cmd_payload_fragment_context    (readLogic_sourceRemover_io_output_cmd_payload_fragment_context[24:0]  ), //o
    .io_output_rsp_valid                       (readLogic_bridge_io_input_rsp_valid                                   ), //i
    .io_output_rsp_ready                       (readLogic_sourceRemover_io_output_rsp_ready                           ), //o
    .io_output_rsp_payload_last                (readLogic_bridge_io_input_rsp_payload_last                            ), //i
    .io_output_rsp_payload_fragment_opcode     (readLogic_bridge_io_input_rsp_payload_fragment_opcode                 ), //i
    .io_output_rsp_payload_fragment_data       (readLogic_bridge_io_input_rsp_payload_fragment_data[255:0]            ), //i
    .io_output_rsp_payload_fragment_context    (readLogic_bridge_io_input_rsp_payload_fragment_context[24:0]          )  //i
  );
  dma_socRuby_BmbToAxi4ReadOnlyBridge readLogic_bridge (
    .io_input_cmd_valid                       (readLogic_sourceRemover_io_output_cmd_valid                           ), //i
    .io_input_cmd_ready                       (readLogic_bridge_io_input_cmd_ready                                   ), //o
    .io_input_cmd_payload_last                (readLogic_sourceRemover_io_output_cmd_payload_last                    ), //i
    .io_input_cmd_payload_fragment_opcode     (readLogic_sourceRemover_io_output_cmd_payload_fragment_opcode         ), //i
    .io_input_cmd_payload_fragment_address    (readLogic_sourceRemover_io_output_cmd_payload_fragment_address[31:0]  ), //i
    .io_input_cmd_payload_fragment_length     (readLogic_sourceRemover_io_output_cmd_payload_fragment_length[10:0]   ), //i
    .io_input_cmd_payload_fragment_context    (readLogic_sourceRemover_io_output_cmd_payload_fragment_context[24:0]  ), //i
    .io_input_rsp_valid                       (readLogic_bridge_io_input_rsp_valid                                   ), //o
    .io_input_rsp_ready                       (readLogic_sourceRemover_io_output_rsp_ready                           ), //i
    .io_input_rsp_payload_last                (readLogic_bridge_io_input_rsp_payload_last                            ), //o
    .io_input_rsp_payload_fragment_opcode     (readLogic_bridge_io_input_rsp_payload_fragment_opcode                 ), //o
    .io_input_rsp_payload_fragment_data       (readLogic_bridge_io_input_rsp_payload_fragment_data[255:0]            ), //o
    .io_input_rsp_payload_fragment_context    (readLogic_bridge_io_input_rsp_payload_fragment_context[24:0]          ), //o
    .io_output_ar_valid                       (readLogic_bridge_io_output_ar_valid                                   ), //o
    .io_output_ar_ready                       (readLogic_adapter_ar_ready                                            ), //i
    .io_output_ar_payload_addr                (readLogic_bridge_io_output_ar_payload_addr[31:0]                      ), //o
    .io_output_ar_payload_len                 (readLogic_bridge_io_output_ar_payload_len[7:0]                        ), //o
    .io_output_ar_payload_size                (readLogic_bridge_io_output_ar_payload_size[2:0]                       ), //o
    .io_output_ar_payload_cache               (readLogic_bridge_io_output_ar_payload_cache[3:0]                      ), //o
    .io_output_ar_payload_prot                (readLogic_bridge_io_output_ar_payload_prot[2:0]                       ), //o
    .io_output_r_valid                        (readLogic_adapter_r_valid                                             ), //i
    .io_output_r_ready                        (readLogic_bridge_io_output_r_ready                                    ), //o
    .io_output_r_payload_data                 (readLogic_adapter_r_payload_data[255:0]                               ), //i
    .io_output_r_payload_resp                 (readLogic_adapter_r_payload_resp[1:0]                                 ), //i
    .io_output_r_payload_last                 (readLogic_adapter_r_payload_last                                      ), //i
    .clk                                      (clk                                                                   ), //i
    .reset                                    (reset                                                                 )  //i
  );
  dma_socRuby_BmbUpSizerBridge_1 bmbUpSizerBridge_1 (
    .io_input_cmd_valid                        (interconnect_write_aggregated_cmd_m2sPipe_valid                           ), //i
    .io_input_cmd_ready                        (bmbUpSizerBridge_1_io_input_cmd_ready                                     ), //o
    .io_input_cmd_payload_last                 (interconnect_write_aggregated_cmd_m2sPipe_payload_last                    ), //i
    .io_input_cmd_payload_fragment_source      (interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_source[1:0]    ), //i
    .io_input_cmd_payload_fragment_opcode      (interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_opcode         ), //i
    .io_input_cmd_payload_fragment_address     (interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_address[31:0]  ), //i
    .io_input_cmd_payload_fragment_length      (interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_length[10:0]   ), //i
    .io_input_cmd_payload_fragment_data        (interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_data[63:0]     ), //i
    .io_input_cmd_payload_fragment_mask        (interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_mask[7:0]      ), //i
    .io_input_cmd_payload_fragment_context     (interconnect_write_aggregated_cmd_m2sPipe_payload_fragment_context[12:0]  ), //i
    .io_input_rsp_valid                        (bmbUpSizerBridge_1_io_input_rsp_valid                                     ), //o
    .io_input_rsp_ready                        (interconnect_write_aggregated_rsp_ready                                   ), //i
    .io_input_rsp_payload_last                 (bmbUpSizerBridge_1_io_input_rsp_payload_last                              ), //o
    .io_input_rsp_payload_fragment_source      (bmbUpSizerBridge_1_io_input_rsp_payload_fragment_source[1:0]              ), //o
    .io_input_rsp_payload_fragment_opcode      (bmbUpSizerBridge_1_io_input_rsp_payload_fragment_opcode                   ), //o
    .io_input_rsp_payload_fragment_context     (bmbUpSizerBridge_1_io_input_rsp_payload_fragment_context[12:0]            ), //o
    .io_output_cmd_valid                       (bmbUpSizerBridge_1_io_output_cmd_valid                                    ), //o
    .io_output_cmd_ready                       (writeLogic_sourceRemover_io_input_cmd_ready                               ), //i
    .io_output_cmd_payload_last                (bmbUpSizerBridge_1_io_output_cmd_payload_last                             ), //o
    .io_output_cmd_payload_fragment_source     (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_source[1:0]             ), //o
    .io_output_cmd_payload_fragment_opcode     (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_opcode                  ), //o
    .io_output_cmd_payload_fragment_address    (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_address[31:0]           ), //o
    .io_output_cmd_payload_fragment_length     (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_length[10:0]            ), //o
    .io_output_cmd_payload_fragment_data       (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_data[255:0]             ), //o
    .io_output_cmd_payload_fragment_mask       (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_mask[31:0]              ), //o
    .io_output_cmd_payload_fragment_context    (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_context[12:0]           ), //o
    .io_output_rsp_valid                       (writeLogic_sourceRemover_io_input_rsp_valid                               ), //i
    .io_output_rsp_ready                       (bmbUpSizerBridge_1_io_output_rsp_ready                                    ), //o
    .io_output_rsp_payload_last                (writeLogic_sourceRemover_io_input_rsp_payload_last                        ), //i
    .io_output_rsp_payload_fragment_source     (writeLogic_sourceRemover_io_input_rsp_payload_fragment_source[1:0]        ), //i
    .io_output_rsp_payload_fragment_opcode     (writeLogic_sourceRemover_io_input_rsp_payload_fragment_opcode             ), //i
    .io_output_rsp_payload_fragment_context    (writeLogic_sourceRemover_io_input_rsp_payload_fragment_context[12:0]      ), //i
    .clk                                       (clk                                                                       ), //i
    .reset                                     (reset                                                                     )  //i
  );
  dma_socRuby_BmbSourceRemover_1 writeLogic_sourceRemover (
    .io_input_cmd_valid                        (bmbUpSizerBridge_1_io_output_cmd_valid                                 ), //i
    .io_input_cmd_ready                        (writeLogic_sourceRemover_io_input_cmd_ready                            ), //o
    .io_input_cmd_payload_last                 (bmbUpSizerBridge_1_io_output_cmd_payload_last                          ), //i
    .io_input_cmd_payload_fragment_source      (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_source[1:0]          ), //i
    .io_input_cmd_payload_fragment_opcode      (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_opcode               ), //i
    .io_input_cmd_payload_fragment_address     (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_address[31:0]        ), //i
    .io_input_cmd_payload_fragment_length      (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_length[10:0]         ), //i
    .io_input_cmd_payload_fragment_data        (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_data[255:0]          ), //i
    .io_input_cmd_payload_fragment_mask        (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_mask[31:0]           ), //i
    .io_input_cmd_payload_fragment_context     (bmbUpSizerBridge_1_io_output_cmd_payload_fragment_context[12:0]        ), //i
    .io_input_rsp_valid                        (writeLogic_sourceRemover_io_input_rsp_valid                            ), //o
    .io_input_rsp_ready                        (bmbUpSizerBridge_1_io_output_rsp_ready                                 ), //i
    .io_input_rsp_payload_last                 (writeLogic_sourceRemover_io_input_rsp_payload_last                     ), //o
    .io_input_rsp_payload_fragment_source      (writeLogic_sourceRemover_io_input_rsp_payload_fragment_source[1:0]     ), //o
    .io_input_rsp_payload_fragment_opcode      (writeLogic_sourceRemover_io_input_rsp_payload_fragment_opcode          ), //o
    .io_input_rsp_payload_fragment_context     (writeLogic_sourceRemover_io_input_rsp_payload_fragment_context[12:0]   ), //o
    .io_output_cmd_valid                       (writeLogic_sourceRemover_io_output_cmd_valid                           ), //o
    .io_output_cmd_ready                       (writeLogic_bridge_io_input_cmd_ready                                   ), //i
    .io_output_cmd_payload_last                (writeLogic_sourceRemover_io_output_cmd_payload_last                    ), //o
    .io_output_cmd_payload_fragment_opcode     (writeLogic_sourceRemover_io_output_cmd_payload_fragment_opcode         ), //o
    .io_output_cmd_payload_fragment_address    (writeLogic_sourceRemover_io_output_cmd_payload_fragment_address[31:0]  ), //o
    .io_output_cmd_payload_fragment_length     (writeLogic_sourceRemover_io_output_cmd_payload_fragment_length[10:0]   ), //o
    .io_output_cmd_payload_fragment_data       (writeLogic_sourceRemover_io_output_cmd_payload_fragment_data[255:0]    ), //o
    .io_output_cmd_payload_fragment_mask       (writeLogic_sourceRemover_io_output_cmd_payload_fragment_mask[31:0]     ), //o
    .io_output_cmd_payload_fragment_context    (writeLogic_sourceRemover_io_output_cmd_payload_fragment_context[14:0]  ), //o
    .io_output_rsp_valid                       (writeLogic_bridge_io_input_rsp_valid                                   ), //i
    .io_output_rsp_ready                       (writeLogic_sourceRemover_io_output_rsp_ready                           ), //o
    .io_output_rsp_payload_last                (writeLogic_bridge_io_input_rsp_payload_last                            ), //i
    .io_output_rsp_payload_fragment_opcode     (writeLogic_bridge_io_input_rsp_payload_fragment_opcode                 ), //i
    .io_output_rsp_payload_fragment_context    (writeLogic_bridge_io_input_rsp_payload_fragment_context[14:0]          )  //i
  );
  dma_socRuby_BmbToAxi4WriteOnlyBridge writeLogic_bridge (
    .io_input_cmd_valid                       (writeLogic_sourceRemover_io_output_cmd_valid                           ), //i
    .io_input_cmd_ready                       (writeLogic_bridge_io_input_cmd_ready                                   ), //o
    .io_input_cmd_payload_last                (writeLogic_sourceRemover_io_output_cmd_payload_last                    ), //i
    .io_input_cmd_payload_fragment_opcode     (writeLogic_sourceRemover_io_output_cmd_payload_fragment_opcode         ), //i
    .io_input_cmd_payload_fragment_address    (writeLogic_sourceRemover_io_output_cmd_payload_fragment_address[31:0]  ), //i
    .io_input_cmd_payload_fragment_length     (writeLogic_sourceRemover_io_output_cmd_payload_fragment_length[10:0]   ), //i
    .io_input_cmd_payload_fragment_data       (writeLogic_sourceRemover_io_output_cmd_payload_fragment_data[255:0]    ), //i
    .io_input_cmd_payload_fragment_mask       (writeLogic_sourceRemover_io_output_cmd_payload_fragment_mask[31:0]     ), //i
    .io_input_cmd_payload_fragment_context    (writeLogic_sourceRemover_io_output_cmd_payload_fragment_context[14:0]  ), //i
    .io_input_rsp_valid                       (writeLogic_bridge_io_input_rsp_valid                                   ), //o
    .io_input_rsp_ready                       (writeLogic_sourceRemover_io_output_rsp_ready                           ), //i
    .io_input_rsp_payload_last                (writeLogic_bridge_io_input_rsp_payload_last                            ), //o
    .io_input_rsp_payload_fragment_opcode     (writeLogic_bridge_io_input_rsp_payload_fragment_opcode                 ), //o
    .io_input_rsp_payload_fragment_context    (writeLogic_bridge_io_input_rsp_payload_fragment_context[14:0]          ), //o
    .io_output_aw_valid                       (writeLogic_bridge_io_output_aw_valid                                   ), //o
    .io_output_aw_ready                       (writeLogic_adapter_aw_ready                                            ), //i
    .io_output_aw_payload_addr                (writeLogic_bridge_io_output_aw_payload_addr[31:0]                      ), //o
    .io_output_aw_payload_len                 (writeLogic_bridge_io_output_aw_payload_len[7:0]                        ), //o
    .io_output_aw_payload_size                (writeLogic_bridge_io_output_aw_payload_size[2:0]                       ), //o
    .io_output_aw_payload_cache               (writeLogic_bridge_io_output_aw_payload_cache[3:0]                      ), //o
    .io_output_aw_payload_prot                (writeLogic_bridge_io_output_aw_payload_prot[2:0]                       ), //o
    .io_output_w_valid                        (writeLogic_bridge_io_output_w_valid                                    ), //o
    .io_output_w_ready                        (writeLogic_adapter_w_ready                                             ), //i
    .io_output_w_payload_data                 (writeLogic_bridge_io_output_w_payload_data[255:0]                      ), //o
    .io_output_w_payload_strb                 (writeLogic_bridge_io_output_w_payload_strb[31:0]                       ), //o
    .io_output_w_payload_last                 (writeLogic_bridge_io_output_w_payload_last                             ), //o
    .io_output_b_valid                        (writeLogic_adapter_b_valid                                             ), //i
    .io_output_b_ready                        (writeLogic_bridge_io_output_b_ready                                    ), //o
    .io_output_b_payload_resp                 (writeLogic_adapter_b_payload_resp[1:0]                                 ), //i
    .clk                                      (clk                                                                    ), //i
    .reset                                    (reset                                                                  )  //i
  );
  dma_socRuby_StreamFifoCC inputsAdapter_0_crossclock_fifo (
    .io_push_valid           (dat0_i_tvalid                                              ), //i
    .io_push_ready           (inputsAdapter_0_crossclock_fifo_io_push_ready              ), //o
    .io_push_payload_data    (dat0_i_tdata[63:0]                                         ), //i
    .io_push_payload_mask    (dat0_i_tkeep[7:0]                                          ), //i
    .io_push_payload_sink    (dat0_i_tdest[3:0]                                          ), //i
    .io_push_payload_last    (dat0_i_tlast                                               ), //i
    .io_pop_valid            (inputsAdapter_0_crossclock_fifo_io_pop_valid               ), //o
    .io_pop_ready            (_zz_6                                                      ), //i
    .io_pop_payload_data     (inputsAdapter_0_crossclock_fifo_io_pop_payload_data[63:0]  ), //o
    .io_pop_payload_mask     (inputsAdapter_0_crossclock_fifo_io_pop_payload_mask[7:0]   ), //o
    .io_pop_payload_sink     (inputsAdapter_0_crossclock_fifo_io_pop_payload_sink[3:0]   ), //o
    .io_pop_payload_last     (inputsAdapter_0_crossclock_fifo_io_pop_payload_last        ), //o
    .io_pushOccupancy        (inputsAdapter_0_crossclock_fifo_io_pushOccupancy[4:0]      ), //o
    .io_popOccupancy         (inputsAdapter_0_crossclock_fifo_io_popOccupancy[4:0]       ), //o
    .dat0_i_clk              (dat0_i_clk                                                 ), //i
    .dat0_i_reset            (dat0_i_reset                                               ), //i
    .clk                     (clk                                                        ), //i
    .reset                   (reset                                                      )  //i
  );
  dma_socRuby_StreamFifoCC_1 inputsAdapter_1_crossclock_fifo (
    .io_push_valid           (dat1_i_tvalid                                              ), //i
    .io_push_ready           (inputsAdapter_1_crossclock_fifo_io_push_ready              ), //o
    .io_push_payload_data    (dat1_i_tdata[31:0]                                         ), //i
    .io_push_payload_mask    (dat1_i_tkeep[3:0]                                          ), //i
    .io_push_payload_sink    (dat1_i_tdest[3:0]                                          ), //i
    .io_push_payload_last    (dat1_i_tlast                                               ), //i
    .io_pop_valid            (inputsAdapter_1_crossclock_fifo_io_pop_valid               ), //o
    .io_pop_ready            (inputsAdapter_1_upsizer_logic_io_input_ready               ), //i
    .io_pop_payload_data     (inputsAdapter_1_crossclock_fifo_io_pop_payload_data[31:0]  ), //o
    .io_pop_payload_mask     (inputsAdapter_1_crossclock_fifo_io_pop_payload_mask[3:0]   ), //o
    .io_pop_payload_sink     (inputsAdapter_1_crossclock_fifo_io_pop_payload_sink[3:0]   ), //o
    .io_pop_payload_last     (inputsAdapter_1_crossclock_fifo_io_pop_payload_last        ), //o
    .io_pushOccupancy        (inputsAdapter_1_crossclock_fifo_io_pushOccupancy[4:0]      ), //o
    .io_popOccupancy         (inputsAdapter_1_crossclock_fifo_io_popOccupancy[4:0]       ), //o
    .dat1_i_clk              (dat1_i_clk                                                 ), //i
    .dat1_i_reset            (dat1_i_reset                                               ), //i
    .clk                     (clk                                                        ), //i
    .reset                   (reset                                                      )  //i
  );
  dma_socRuby_BsbUpSizerDense inputsAdapter_1_upsizer_logic (
    .io_input_valid            (inputsAdapter_1_crossclock_fifo_io_pop_valid                ), //i
    .io_input_ready            (inputsAdapter_1_upsizer_logic_io_input_ready                ), //o
    .io_input_payload_data     (inputsAdapter_1_crossclock_fifo_io_pop_payload_data[31:0]   ), //i
    .io_input_payload_mask     (inputsAdapter_1_crossclock_fifo_io_pop_payload_mask[3:0]    ), //i
    .io_input_payload_sink     (inputsAdapter_1_crossclock_fifo_io_pop_payload_sink[3:0]    ), //i
    .io_input_payload_last     (inputsAdapter_1_crossclock_fifo_io_pop_payload_last         ), //i
    .io_output_valid           (inputsAdapter_1_upsizer_logic_io_output_valid               ), //o
    .io_output_ready           (_zz_7                                                       ), //i
    .io_output_payload_data    (inputsAdapter_1_upsizer_logic_io_output_payload_data[63:0]  ), //o
    .io_output_payload_mask    (inputsAdapter_1_upsizer_logic_io_output_payload_mask[7:0]   ), //o
    .io_output_payload_sink    (inputsAdapter_1_upsizer_logic_io_output_payload_sink[3:0]   ), //o
    .io_output_payload_last    (inputsAdapter_1_upsizer_logic_io_output_payload_last        ), //o
    .clk                       (clk                                                         ), //i
    .reset                     (reset                                                       )  //i
  );
  dma_socRuby_StreamFifoCC_2 outputsAdapter_0_crossclock_fifo (
    .io_push_valid           (outputsAdapter_0_ptr_valid                                  ), //i
    .io_push_ready           (outputsAdapter_0_crossclock_fifo_io_push_ready              ), //o
    .io_push_payload_data    (outputsAdapter_0_ptr_payload_data[63:0]                     ), //i
    .io_push_payload_mask    (outputsAdapter_0_ptr_payload_mask[7:0]                      ), //i
    .io_push_payload_sink    (outputsAdapter_0_ptr_payload_sink[3:0]                      ), //i
    .io_push_payload_last    (outputsAdapter_0_ptr_payload_last                           ), //i
    .io_pop_valid            (outputsAdapter_0_crossclock_fifo_io_pop_valid               ), //o
    .io_pop_ready            (dat0_o_tready                                               ), //i
    .io_pop_payload_data     (outputsAdapter_0_crossclock_fifo_io_pop_payload_data[63:0]  ), //o
    .io_pop_payload_mask     (outputsAdapter_0_crossclock_fifo_io_pop_payload_mask[7:0]   ), //o
    .io_pop_payload_sink     (outputsAdapter_0_crossclock_fifo_io_pop_payload_sink[3:0]   ), //o
    .io_pop_payload_last     (outputsAdapter_0_crossclock_fifo_io_pop_payload_last        ), //o
    .io_pushOccupancy        (outputsAdapter_0_crossclock_fifo_io_pushOccupancy[4:0]      ), //o
    .io_popOccupancy         (outputsAdapter_0_crossclock_fifo_io_popOccupancy[4:0]       ), //o
    .clk                     (clk                                                         ), //i
    .reset                   (reset                                                       ), //i
    .dat0_o_clk              (dat0_o_clk                                                  ), //i
    .dat0_o_reset            (dat0_o_reset                                                )  //i
  );
  dma_socRuby_BsbDownSizerSparse outputsAdapter_1_sparseDownsizer_logic (
    .io_input_valid            (outputsAdapter_1_ptr_valid                                           ), //i
    .io_input_ready            (outputsAdapter_1_sparseDownsizer_logic_io_input_ready                ), //o
    .io_input_payload_data     (outputsAdapter_1_ptr_payload_data[63:0]                              ), //i
    .io_input_payload_mask     (outputsAdapter_1_ptr_payload_mask[7:0]                               ), //i
    .io_input_payload_sink     (outputsAdapter_1_ptr_payload_sink[3:0]                               ), //i
    .io_input_payload_last     (outputsAdapter_1_ptr_payload_last                                    ), //i
    .io_output_valid           (outputsAdapter_1_sparseDownsizer_logic_io_output_valid               ), //o
    .io_output_ready           (outputsAdapter_1_crossclock_fifo_io_push_ready                       ), //i
    .io_output_payload_data    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_data[31:0]  ), //o
    .io_output_payload_mask    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_mask[3:0]   ), //o
    .io_output_payload_sink    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_sink[3:0]   ), //o
    .io_output_payload_last    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_last        ), //o
    .clk                       (clk                                                                  ), //i
    .reset                     (reset                                                                )  //i
  );
  dma_socRuby_StreamFifoCC_3 outputsAdapter_1_crossclock_fifo (
    .io_push_valid           (outputsAdapter_1_sparseDownsizer_logic_io_output_valid               ), //i
    .io_push_ready           (outputsAdapter_1_crossclock_fifo_io_push_ready                       ), //o
    .io_push_payload_data    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_data[31:0]  ), //i
    .io_push_payload_mask    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_mask[3:0]   ), //i
    .io_push_payload_sink    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_sink[3:0]   ), //i
    .io_push_payload_last    (outputsAdapter_1_sparseDownsizer_logic_io_output_payload_last        ), //i
    .io_pop_valid            (outputsAdapter_1_crossclock_fifo_io_pop_valid                        ), //o
    .io_pop_ready            (dat1_o_tready                                                        ), //i
    .io_pop_payload_data     (outputsAdapter_1_crossclock_fifo_io_pop_payload_data[31:0]           ), //o
    .io_pop_payload_mask     (outputsAdapter_1_crossclock_fifo_io_pop_payload_mask[3:0]            ), //o
    .io_pop_payload_sink     (outputsAdapter_1_crossclock_fifo_io_pop_payload_sink[3:0]            ), //o
    .io_pop_payload_last     (outputsAdapter_1_crossclock_fifo_io_pop_payload_last                 ), //o
    .io_pushOccupancy        (outputsAdapter_1_crossclock_fifo_io_pushOccupancy[4:0]               ), //o
    .io_popOccupancy         (outputsAdapter_1_crossclock_fifo_io_popOccupancy[4:0]                ), //o
    .clk                     (clk                                                                  ), //i
    .reset                   (reset                                                                ), //i
    .dat1_o_clk              (dat1_o_clk                                                           ), //i
    .dat1_o_reset            (dat1_o_reset                                                         )  //i
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
  assign interconnect_read_aggregated_cmd_halfPipe_ready = bmbUpSizerBridge_io_input_cmd_ready;
  assign interconnect_read_aggregated_rsp_valid = bmbUpSizerBridge_io_input_rsp_valid;
  assign interconnect_read_aggregated_rsp_payload_last = bmbUpSizerBridge_io_input_rsp_payload_last;
  assign interconnect_read_aggregated_rsp_payload_fragment_source = bmbUpSizerBridge_io_input_rsp_payload_fragment_source;
  assign interconnect_read_aggregated_rsp_payload_fragment_opcode = bmbUpSizerBridge_io_input_rsp_payload_fragment_opcode;
  assign interconnect_read_aggregated_rsp_payload_fragment_data = bmbUpSizerBridge_io_input_rsp_payload_fragment_data;
  assign interconnect_read_aggregated_rsp_payload_fragment_context = bmbUpSizerBridge_io_input_rsp_payload_fragment_context;
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
  assign read_r_s2mPipe_ready = ((1'b1 && (! read_r_s2mPipe_m2sPipe_valid)) || read_r_s2mPipe_m2sPipe_ready);
  assign read_r_s2mPipe_m2sPipe_valid = read_r_s2mPipe_m2sPipe_rValid;
  assign read_r_s2mPipe_m2sPipe_payload_data = read_r_s2mPipe_m2sPipe_rData_data;
  assign read_r_s2mPipe_m2sPipe_payload_resp = read_r_s2mPipe_m2sPipe_rData_resp;
  assign read_r_s2mPipe_m2sPipe_payload_last = read_r_s2mPipe_m2sPipe_rData_last;
  assign readLogic_adapter_r_valid = read_r_s2mPipe_m2sPipe_valid;
  assign read_r_s2mPipe_m2sPipe_ready = readLogic_adapter_r_ready;
  assign readLogic_adapter_r_payload_data = read_r_s2mPipe_m2sPipe_payload_data;
  assign readLogic_adapter_r_payload_resp = read_r_s2mPipe_m2sPipe_payload_resp;
  assign readLogic_adapter_r_payload_last = read_r_s2mPipe_m2sPipe_payload_last;
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
  assign interconnect_write_aggregated_cmd_m2sPipe_ready = bmbUpSizerBridge_1_io_input_cmd_ready;
  assign interconnect_write_aggregated_rsp_valid = bmbUpSizerBridge_1_io_input_rsp_valid;
  assign interconnect_write_aggregated_rsp_payload_last = bmbUpSizerBridge_1_io_input_rsp_payload_last;
  assign interconnect_write_aggregated_rsp_payload_fragment_source = bmbUpSizerBridge_1_io_input_rsp_payload_fragment_source;
  assign interconnect_write_aggregated_rsp_payload_fragment_opcode = bmbUpSizerBridge_1_io_input_rsp_payload_fragment_opcode;
  assign interconnect_write_aggregated_rsp_payload_fragment_context = bmbUpSizerBridge_1_io_input_rsp_payload_fragment_context;
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
  assign dat0_i_tready = inputsAdapter_0_crossclock_fifo_io_push_ready;
  assign inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_valid = (inputsAdapter_0_crossclock_fifo_io_pop_valid || inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid);
  assign _zz_6 = (! inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid);
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
  assign dat1_i_tready = inputsAdapter_1_crossclock_fifo_io_push_ready;
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_valid = (inputsAdapter_1_upsizer_logic_io_output_valid || inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid);
  assign _zz_7 = (! inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid);
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_data = (inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid ? inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_data : inputsAdapter_1_upsizer_logic_io_output_payload_data);
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_mask = (inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid ? inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_mask : inputsAdapter_1_upsizer_logic_io_output_payload_mask);
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_sink = (inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid ? inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_sink : inputsAdapter_1_upsizer_logic_io_output_payload_sink);
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_last = (inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid ? inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_last : inputsAdapter_1_upsizer_logic_io_output_payload_last);
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_ready = ((1'b1 && (! inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_valid)) || inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_ready);
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_valid = inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rValid;
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_data = inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_data;
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_mask = inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_mask;
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_sink = inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_sink;
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_payload_last = inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_last;
  assign inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_ready = core_io_inputs_1_ready;
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
  assign dat0_o_tvalid = outputsAdapter_0_crossclock_fifo_io_pop_valid;
  assign dat0_o_tdata = outputsAdapter_0_crossclock_fifo_io_pop_payload_data;
  assign dat0_o_tkeep = outputsAdapter_0_crossclock_fifo_io_pop_payload_mask;
  assign dat0_o_tdest = outputsAdapter_0_crossclock_fifo_io_pop_payload_sink;
  assign dat0_o_tlast = outputsAdapter_0_crossclock_fifo_io_pop_payload_last;
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
  assign outputsAdapter_1_ptr_ready = outputsAdapter_1_sparseDownsizer_logic_io_input_ready;
  assign dat1_o_tvalid = outputsAdapter_1_crossclock_fifo_io_pop_valid;
  assign dat1_o_tdata = outputsAdapter_1_crossclock_fifo_io_pop_payload_data;
  assign dat1_o_tkeep = outputsAdapter_1_crossclock_fifo_io_pop_payload_mask;
  assign dat1_o_tdest = outputsAdapter_1_crossclock_fifo_io_pop_payload_sink;
  assign dat1_o_tlast = outputsAdapter_1_crossclock_fifo_io_pop_payload_last;
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
      interconnect_write_aggregated_cmd_m2sPipe_rValid <= 1'b0;
      writeLogic_adapter_aw_halfPipe_regs_valid <= 1'b0;
      writeLogic_adapter_aw_halfPipe_regs_ready <= 1'b1;
      writeLogic_adapter_w_s2mPipe_rValid <= 1'b0;
      writeLogic_adapter_w_s2mPipe_m2sPipe_rValid <= 1'b0;
      write_b_halfPipe_regs_valid <= 1'b0;
      write_b_halfPipe_regs_ready <= 1'b1;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid <= 1'b0;
      inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid <= 1'b0;
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid <= 1'b0;
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rValid <= 1'b0;
      core_io_outputs_0_s2mPipe_rValid <= 1'b0;
      core_io_outputs_0_s2mPipe_m2sPipe_rValid <= 1'b0;
      core_io_outputs_1_s2mPipe_rValid <= 1'b0;
      core_io_outputs_1_s2mPipe_m2sPipe_rValid <= 1'b0;
    end else begin
      if(core_io_write_cmd_s2mPipe_ready)begin
        core_io_write_cmd_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_8)begin
        core_io_write_cmd_s2mPipe_rValid <= core_io_write_cmd_valid;
      end
      if(core_io_write_cmd_s2mPipe_ready)begin
        core_io_write_cmd_s2mPipe_m2sPipe_rValid <= core_io_write_cmd_s2mPipe_valid;
      end
      if(_zz_9)begin
        interconnect_read_aggregated_cmd_halfPipe_regs_valid <= interconnect_read_aggregated_cmd_valid;
        interconnect_read_aggregated_cmd_halfPipe_regs_ready <= (! interconnect_read_aggregated_cmd_valid);
      end else begin
        interconnect_read_aggregated_cmd_halfPipe_regs_valid <= (! interconnect_read_aggregated_cmd_halfPipe_ready);
        interconnect_read_aggregated_cmd_halfPipe_regs_ready <= interconnect_read_aggregated_cmd_halfPipe_ready;
      end
      if(_zz_10)begin
        readLogic_adapter_ar_halfPipe_regs_valid <= readLogic_adapter_ar_valid;
        readLogic_adapter_ar_halfPipe_regs_ready <= (! readLogic_adapter_ar_valid);
      end else begin
        readLogic_adapter_ar_halfPipe_regs_valid <= (! readLogic_adapter_ar_halfPipe_ready);
        readLogic_adapter_ar_halfPipe_regs_ready <= readLogic_adapter_ar_halfPipe_ready;
      end
      if(read_r_s2mPipe_ready)begin
        read_r_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_11)begin
        read_r_s2mPipe_rValid <= read_rvalid;
      end
      if(read_r_s2mPipe_ready)begin
        read_r_s2mPipe_m2sPipe_rValid <= read_r_s2mPipe_valid;
      end
      if(interconnect_write_aggregated_cmd_ready)begin
        interconnect_write_aggregated_cmd_m2sPipe_rValid <= interconnect_write_aggregated_cmd_valid;
      end
      if(_zz_12)begin
        writeLogic_adapter_aw_halfPipe_regs_valid <= writeLogic_adapter_aw_valid;
        writeLogic_adapter_aw_halfPipe_regs_ready <= (! writeLogic_adapter_aw_valid);
      end else begin
        writeLogic_adapter_aw_halfPipe_regs_valid <= (! writeLogic_adapter_aw_halfPipe_ready);
        writeLogic_adapter_aw_halfPipe_regs_ready <= writeLogic_adapter_aw_halfPipe_ready;
      end
      if(writeLogic_adapter_w_s2mPipe_ready)begin
        writeLogic_adapter_w_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_13)begin
        writeLogic_adapter_w_s2mPipe_rValid <= writeLogic_adapter_w_valid;
      end
      if(writeLogic_adapter_w_s2mPipe_ready)begin
        writeLogic_adapter_w_s2mPipe_m2sPipe_rValid <= writeLogic_adapter_w_s2mPipe_valid;
      end
      if(_zz_14)begin
        write_b_halfPipe_regs_valid <= write_bvalid;
        write_b_halfPipe_regs_ready <= (! write_bvalid);
      end else begin
        write_b_halfPipe_regs_valid <= (! write_b_halfPipe_ready);
        write_b_halfPipe_regs_ready <= write_b_halfPipe_ready;
      end
      if(inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready)begin
        inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_15)begin
        inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_rValid <= inputsAdapter_0_crossclock_fifo_io_pop_valid;
      end
      if(inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_ready)begin
        inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_m2sPipe_rValid <= inputsAdapter_0_crossclock_fifo_io_pop_s2mPipe_valid;
      end
      if(inputsAdapter_1_upsizer_logic_io_output_s2mPipe_ready)begin
        inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_16)begin
        inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rValid <= inputsAdapter_1_upsizer_logic_io_output_valid;
      end
      if(inputsAdapter_1_upsizer_logic_io_output_s2mPipe_ready)begin
        inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rValid <= inputsAdapter_1_upsizer_logic_io_output_s2mPipe_valid;
      end
      if(core_io_outputs_0_s2mPipe_ready)begin
        core_io_outputs_0_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_17)begin
        core_io_outputs_0_s2mPipe_rValid <= core_io_outputs_0_valid;
      end
      if(core_io_outputs_0_s2mPipe_ready)begin
        core_io_outputs_0_s2mPipe_m2sPipe_rValid <= core_io_outputs_0_s2mPipe_valid;
      end
      if(core_io_outputs_1_s2mPipe_ready)begin
        core_io_outputs_1_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_18)begin
        core_io_outputs_1_s2mPipe_rValid <= core_io_outputs_1_valid;
      end
      if(core_io_outputs_1_s2mPipe_ready)begin
        core_io_outputs_1_s2mPipe_m2sPipe_rValid <= core_io_outputs_1_s2mPipe_valid;
      end
    end
  end

  always @ (posedge clk) begin
    if(_zz_8)begin
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
    if(_zz_9)begin
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_last <= interconnect_read_aggregated_cmd_payload_last;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_source <= interconnect_read_aggregated_cmd_payload_fragment_source;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_opcode <= interconnect_read_aggregated_cmd_payload_fragment_opcode;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_address <= interconnect_read_aggregated_cmd_payload_fragment_address;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_length <= interconnect_read_aggregated_cmd_payload_fragment_length;
      interconnect_read_aggregated_cmd_halfPipe_regs_payload_fragment_context <= interconnect_read_aggregated_cmd_payload_fragment_context;
    end
    if(_zz_10)begin
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
    if(_zz_11)begin
      read_r_s2mPipe_rData_data <= read_rdata;
      read_r_s2mPipe_rData_resp <= read_rresp;
      read_r_s2mPipe_rData_last <= read_rlast;
    end
    if(read_r_s2mPipe_ready)begin
      read_r_s2mPipe_m2sPipe_rData_data <= read_r_s2mPipe_payload_data;
      read_r_s2mPipe_m2sPipe_rData_resp <= read_r_s2mPipe_payload_resp;
      read_r_s2mPipe_m2sPipe_rData_last <= read_r_s2mPipe_payload_last;
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
    if(_zz_12)begin
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
    if(_zz_13)begin
      writeLogic_adapter_w_s2mPipe_rData_data <= writeLogic_adapter_w_payload_data;
      writeLogic_adapter_w_s2mPipe_rData_strb <= writeLogic_adapter_w_payload_strb;
      writeLogic_adapter_w_s2mPipe_rData_last <= writeLogic_adapter_w_payload_last;
    end
    if(writeLogic_adapter_w_s2mPipe_ready)begin
      writeLogic_adapter_w_s2mPipe_m2sPipe_rData_data <= writeLogic_adapter_w_s2mPipe_payload_data;
      writeLogic_adapter_w_s2mPipe_m2sPipe_rData_strb <= writeLogic_adapter_w_s2mPipe_payload_strb;
      writeLogic_adapter_w_s2mPipe_m2sPipe_rData_last <= writeLogic_adapter_w_s2mPipe_payload_last;
    end
    if(_zz_14)begin
      write_b_halfPipe_regs_payload_resp <= write_bresp;
    end
    if(_zz_15)begin
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
    if(_zz_16)begin
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_data <= inputsAdapter_1_upsizer_logic_io_output_payload_data;
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_mask <= inputsAdapter_1_upsizer_logic_io_output_payload_mask;
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_sink <= inputsAdapter_1_upsizer_logic_io_output_payload_sink;
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_rData_last <= inputsAdapter_1_upsizer_logic_io_output_payload_last;
    end
    if(inputsAdapter_1_upsizer_logic_io_output_s2mPipe_ready)begin
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_data <= inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_data;
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_mask <= inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_mask;
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_sink <= inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_sink;
      inputsAdapter_1_upsizer_logic_io_output_s2mPipe_m2sPipe_rData_last <= inputsAdapter_1_upsizer_logic_io_output_s2mPipe_payload_last;
    end
    if(_zz_17)begin
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
    if(_zz_18)begin
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

module dma_socRuby_StreamFifoCC_3 (
  input               io_push_valid,
  output              io_push_ready,
  input      [31:0]   io_push_payload_data,
  input      [3:0]    io_push_payload_mask,
  input      [3:0]    io_push_payload_sink,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [31:0]   io_pop_payload_data,
  output     [3:0]    io_pop_payload_mask,
  output     [3:0]    io_pop_payload_sink,
  output              io_pop_payload_last,
  output     [4:0]    io_pushOccupancy,
  output     [4:0]    io_popOccupancy,
  input               clk,
  input               reset,
  input               dat1_o_clk,
  input               dat1_o_reset
);
  reg        [40:0]   _zz_12;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire                _zz_13;
  wire       [4:0]    _zz_14;
  wire       [3:0]    _zz_15;
  wire       [4:0]    _zz_16;
  wire       [3:0]    _zz_17;
  wire       [0:0]    _zz_18;
  wire       [40:0]   _zz_19;
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
  wire       [40:0]   _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  reg [40:0] ram [0:15];

  assign _zz_13 = (io_push_valid && io_push_ready);
  assign _zz_14 = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_15 = pushCC_pushPtr[3:0];
  assign _zz_16 = (popCC_popPtrPlus >>> 1'b1);
  assign _zz_17 = _zz_6[3:0];
  assign _zz_18 = _zz_7[40 : 40];
  assign _zz_19 = {io_push_payload_last,{io_push_payload_sink,{io_push_payload_mask,io_push_payload_data}}};
  assign _zz_20 = 1'b1;
  always @ (posedge clk) begin
    if(_zz_1) begin
      ram[_zz_15] <= _zz_19;
    end
  end

  always @ (posedge dat1_o_clk) begin
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
    .io_dataIn       (pushToPopGray[4:0]                      ), //i
    .io_dataOut      (pushToPopGray_buffercc_io_dataOut[4:0]  ), //o
    .dat1_o_clk      (dat1_o_clk                              ), //i
    .dat1_o_reset    (dat1_o_reset                            )  //i
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
  assign io_pop_payload_data = _zz_7[31 : 0];
  assign io_pop_payload_mask = _zz_7[35 : 32];
  assign io_pop_payload_sink = _zz_7[39 : 36];
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

  always @ (posedge dat1_o_clk) begin
    if(dat1_o_reset) begin
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
  input      [63:0]   io_input_payload_data,
  input      [7:0]    io_input_payload_mask,
  input      [3:0]    io_input_payload_sink,
  input               io_input_payload_last,
  output              io_output_valid,
  input               io_output_ready,
  output     [31:0]   io_output_payload_data,
  output     [3:0]    io_output_payload_mask,
  output     [3:0]    io_output_payload_sink,
  output              io_output_payload_last,
  input               clk,
  input               reset
);
  reg        [31:0]   _zz_1;
  reg        [3:0]    _zz_2;
  reg        [0:0]    counter;
  wire                end_1;

  always @(*) begin
    case(counter)
      1'b0 : begin
        _zz_1 = io_input_payload_data[31 : 0];
        _zz_2 = io_input_payload_mask[3 : 0];
      end
      default : begin
        _zz_1 = io_input_payload_data[63 : 32];
        _zz_2 = io_input_payload_mask[7 : 4];
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
  always @ (posedge clk) begin
    if(reset) begin
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
  input      [63:0]   io_push_payload_data,
  input      [7:0]    io_push_payload_mask,
  input      [3:0]    io_push_payload_sink,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload_data,
  output     [7:0]    io_pop_payload_mask,
  output     [3:0]    io_pop_payload_sink,
  output              io_pop_payload_last,
  output     [4:0]    io_pushOccupancy,
  output     [4:0]    io_popOccupancy,
  input               clk,
  input               reset,
  input               dat0_o_clk,
  input               dat0_o_reset
);
  reg        [76:0]   _zz_12;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire                _zz_13;
  wire       [4:0]    _zz_14;
  wire       [3:0]    _zz_15;
  wire       [4:0]    _zz_16;
  wire       [3:0]    _zz_17;
  wire       [0:0]    _zz_18;
  wire       [76:0]   _zz_19;
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
  wire       [76:0]   _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  reg [76:0] ram [0:15];

  assign _zz_13 = (io_push_valid && io_push_ready);
  assign _zz_14 = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_15 = pushCC_pushPtr[3:0];
  assign _zz_16 = (popCC_popPtrPlus >>> 1'b1);
  assign _zz_17 = _zz_6[3:0];
  assign _zz_18 = _zz_7[76 : 76];
  assign _zz_19 = {io_push_payload_last,{io_push_payload_sink,{io_push_payload_mask,io_push_payload_data}}};
  assign _zz_20 = 1'b1;
  always @ (posedge clk) begin
    if(_zz_1) begin
      ram[_zz_15] <= _zz_19;
    end
  end

  always @ (posedge dat0_o_clk) begin
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
    .io_dataIn       (pushToPopGray[4:0]                      ), //i
    .io_dataOut      (pushToPopGray_buffercc_io_dataOut[4:0]  ), //o
    .dat0_o_clk      (dat0_o_clk                              ), //i
    .dat0_o_reset    (dat0_o_reset                            )  //i
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
  assign io_pop_payload_data = _zz_7[63 : 0];
  assign io_pop_payload_mask = _zz_7[71 : 64];
  assign io_pop_payload_sink = _zz_7[75 : 72];
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

  always @ (posedge dat0_o_clk) begin
    if(dat0_o_reset) begin
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
  input      [31:0]   io_input_payload_data,
  input      [3:0]    io_input_payload_mask,
  input      [3:0]    io_input_payload_sink,
  input               io_input_payload_last,
  output              io_output_valid,
  input               io_output_ready,
  output     [63:0]   io_output_payload_data,
  output     [7:0]    io_output_payload_mask,
  output     [3:0]    io_output_payload_sink,
  output              io_output_payload_last,
  input               clk,
  input               reset
);
  wire                _zz_3;
  reg                 valid;
  reg        [0:0]    counter;
  reg        [63:0]   buffer_data;
  reg        [7:0]    buffer_mask;
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
  always @ (posedge clk) begin
    if(reset) begin
      valid <= 1'b0;
      counter <= 1'b0;
      buffer_last <= 1'b0;
      buffer_mask <= 8'h0;
    end else begin
      if((io_output_valid && io_output_ready))begin
        valid <= 1'b0;
        buffer_mask <= 8'h0;
      end
      if(_zz_3)begin
        valid <= 1'b1;
        if(_zz_2[0])begin
          buffer_mask[3 : 0] <= io_input_payload_mask;
        end
        if(_zz_2[1])begin
          buffer_mask[7 : 4] <= io_input_payload_mask;
        end
        buffer_last <= io_input_payload_last;
        counter <= (counterSample + 1'b1);
      end
    end
  end

  always @ (posedge clk) begin
    if(_zz_3)begin
      buffer_sink <= io_input_payload_sink;
      if(_zz_1[0])begin
        buffer_data[31 : 0] <= io_input_payload_data;
      end
      if(_zz_1[1])begin
        buffer_data[63 : 32] <= io_input_payload_data;
      end
    end
  end


endmodule

module dma_socRuby_StreamFifoCC_1 (
  input               io_push_valid,
  output              io_push_ready,
  input      [31:0]   io_push_payload_data,
  input      [3:0]    io_push_payload_mask,
  input      [3:0]    io_push_payload_sink,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [31:0]   io_pop_payload_data,
  output     [3:0]    io_pop_payload_mask,
  output     [3:0]    io_pop_payload_sink,
  output              io_pop_payload_last,
  output     [4:0]    io_pushOccupancy,
  output     [4:0]    io_popOccupancy,
  input               dat1_i_clk,
  input               dat1_i_reset,
  input               clk,
  input               reset
);
  reg        [40:0]   _zz_12;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire                _zz_13;
  wire       [4:0]    _zz_14;
  wire       [3:0]    _zz_15;
  wire       [4:0]    _zz_16;
  wire       [3:0]    _zz_17;
  wire       [0:0]    _zz_18;
  wire       [40:0]   _zz_19;
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
  wire       [40:0]   _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  reg [40:0] ram [0:15];

  assign _zz_13 = (io_push_valid && io_push_ready);
  assign _zz_14 = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_15 = pushCC_pushPtr[3:0];
  assign _zz_16 = (popCC_popPtrPlus >>> 1'b1);
  assign _zz_17 = _zz_6[3:0];
  assign _zz_18 = _zz_7[40 : 40];
  assign _zz_19 = {io_push_payload_last,{io_push_payload_sink,{io_push_payload_mask,io_push_payload_data}}};
  assign _zz_20 = 1'b1;
  always @ (posedge dat1_i_clk) begin
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
    .io_dataIn       (popToPushGray[4:0]                      ), //i
    .io_dataOut      (popToPushGray_buffercc_io_dataOut[4:0]  ), //o
    .dat1_i_clk      (dat1_i_clk                              ), //i
    .dat1_i_reset    (dat1_i_reset                            )  //i
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
  assign io_pop_payload_data = _zz_7[31 : 0];
  assign io_pop_payload_mask = _zz_7[35 : 32];
  assign io_pop_payload_sink = _zz_7[39 : 36];
  assign io_pop_payload_last = _zz_18[0];
  assign _zz_8 = (popCC_pushPtrGray[1] ^ _zz_9);
  assign _zz_9 = (popCC_pushPtrGray[2] ^ _zz_10);
  assign _zz_10 = (popCC_pushPtrGray[3] ^ _zz_11);
  assign _zz_11 = popCC_pushPtrGray[4];
  assign io_popOccupancy = ({_zz_11,{_zz_10,{_zz_9,{_zz_8,(popCC_pushPtrGray[0] ^ _zz_8)}}}} - popCC_popPtr);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_popPtrGray;
  always @ (posedge dat1_i_clk) begin
    if(dat1_i_reset) begin
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

module dma_socRuby_StreamFifoCC (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload_data,
  input      [7:0]    io_push_payload_mask,
  input      [3:0]    io_push_payload_sink,
  input               io_push_payload_last,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload_data,
  output     [7:0]    io_pop_payload_mask,
  output     [3:0]    io_pop_payload_sink,
  output              io_pop_payload_last,
  output     [4:0]    io_pushOccupancy,
  output     [4:0]    io_popOccupancy,
  input               dat0_i_clk,
  input               dat0_i_reset,
  input               clk,
  input               reset
);
  reg        [76:0]   _zz_12;
  wire       [4:0]    popToPushGray_buffercc_io_dataOut;
  wire       [4:0]    pushToPopGray_buffercc_io_dataOut;
  wire                _zz_13;
  wire       [4:0]    _zz_14;
  wire       [3:0]    _zz_15;
  wire       [4:0]    _zz_16;
  wire       [3:0]    _zz_17;
  wire       [0:0]    _zz_18;
  wire       [76:0]   _zz_19;
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
  wire       [76:0]   _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  reg [76:0] ram [0:15];

  assign _zz_13 = (io_push_valid && io_push_ready);
  assign _zz_14 = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_15 = pushCC_pushPtr[3:0];
  assign _zz_16 = (popCC_popPtrPlus >>> 1'b1);
  assign _zz_17 = _zz_6[3:0];
  assign _zz_18 = _zz_7[76 : 76];
  assign _zz_19 = {io_push_payload_last,{io_push_payload_sink,{io_push_payload_mask,io_push_payload_data}}};
  assign _zz_20 = 1'b1;
  always @ (posedge dat0_i_clk) begin
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
    .io_dataIn       (popToPushGray[4:0]                      ), //i
    .io_dataOut      (popToPushGray_buffercc_io_dataOut[4:0]  ), //o
    .dat0_i_clk      (dat0_i_clk                              ), //i
    .dat0_i_reset    (dat0_i_reset                            )  //i
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
  assign io_pop_payload_data = _zz_7[63 : 0];
  assign io_pop_payload_mask = _zz_7[71 : 64];
  assign io_pop_payload_sink = _zz_7[75 : 72];
  assign io_pop_payload_last = _zz_18[0];
  assign _zz_8 = (popCC_pushPtrGray[1] ^ _zz_9);
  assign _zz_9 = (popCC_pushPtrGray[2] ^ _zz_10);
  assign _zz_10 = (popCC_pushPtrGray[3] ^ _zz_11);
  assign _zz_11 = popCC_pushPtrGray[4];
  assign io_popOccupancy = ({_zz_11,{_zz_10,{_zz_9,{_zz_8,(popCC_pushPtrGray[0] ^ _zz_8)}}}} - popCC_popPtr);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_popPtrGray;
  always @ (posedge dat0_i_clk) begin
    if(dat0_i_reset) begin
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

module dma_socRuby_BmbToAxi4WriteOnlyBridge (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [10:0]   io_input_cmd_payload_fragment_length,
  input      [255:0]  io_input_cmd_payload_fragment_data,
  input      [31:0]   io_input_cmd_payload_fragment_mask,
  input      [14:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [14:0]   io_input_rsp_payload_fragment_context,
  output              io_output_aw_valid,
  input               io_output_aw_ready,
  output     [31:0]   io_output_aw_payload_addr,
  output     [7:0]    io_output_aw_payload_len,
  output     [2:0]    io_output_aw_payload_size,
  output     [3:0]    io_output_aw_payload_cache,
  output     [2:0]    io_output_aw_payload_prot,
  output              io_output_w_valid,
  input               io_output_w_ready,
  output     [255:0]  io_output_w_payload_data,
  output     [31:0]   io_output_w_payload_strb,
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
  wire       [14:0]   contextRemover_io_input_rsp_payload_fragment_context;
  wire                contextRemover_io_output_cmd_valid;
  wire                contextRemover_io_output_cmd_payload_last;
  wire       [0:0]    contextRemover_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   contextRemover_io_output_cmd_payload_fragment_address;
  wire       [10:0]   contextRemover_io_output_cmd_payload_fragment_length;
  wire       [255:0]  contextRemover_io_output_cmd_payload_fragment_data;
  wire       [31:0]   contextRemover_io_output_cmd_payload_fragment_mask;
  wire                contextRemover_io_output_rsp_ready;
  wire                contextRemover_io_output_cmd_fork_io_input_ready;
  wire                contextRemover_io_output_cmd_fork_io_outputs_0_valid;
  wire                contextRemover_io_output_cmd_fork_io_outputs_0_payload_last;
  wire       [0:0]    contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_opcode;
  wire       [31:0]   contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_address;
  wire       [10:0]   contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_length;
  wire       [255:0]  contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_data;
  wire       [31:0]   contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_mask;
  wire                contextRemover_io_output_cmd_fork_io_outputs_1_valid;
  wire                contextRemover_io_output_cmd_fork_io_outputs_1_payload_last;
  wire       [0:0]    contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_opcode;
  wire       [31:0]   contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_address;
  wire       [10:0]   contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_length;
  wire       [255:0]  contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_data;
  wire       [31:0]   contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_mask;
  wire                _zz_4;
  wire       [6:0]    _zz_5;
  wire       [11:0]   _zz_6;
  wire       [4:0]    _zz_7;
  wire       [11:0]   _zz_8;
  reg                 contextRemover_io_output_cmd_payload_first;
  reg                 cmdStage_valid;
  wire                cmdStage_ready;
  wire                cmdStage_payload_last;
  wire       [0:0]    cmdStage_payload_fragment_opcode;
  wire       [31:0]   cmdStage_payload_fragment_address;
  wire       [10:0]   cmdStage_payload_fragment_length;
  wire       [255:0]  cmdStage_payload_fragment_data;
  wire       [31:0]   cmdStage_payload_fragment_mask;

  assign _zz_4 = (! contextRemover_io_output_cmd_payload_first);
  assign _zz_5 = _zz_6[11 : 5];
  assign _zz_6 = ({1'b0,cmdStage_payload_fragment_length} + _zz_8);
  assign _zz_7 = cmdStage_payload_fragment_address[4 : 0];
  assign _zz_8 = {7'd0, _zz_7};
  dma_socRuby_BmbContextRemover_1 contextRemover (
    .io_input_cmd_valid                        (io_input_cmd_valid                                           ), //i
    .io_input_cmd_ready                        (contextRemover_io_input_cmd_ready                            ), //o
    .io_input_cmd_payload_last                 (io_input_cmd_payload_last                                    ), //i
    .io_input_cmd_payload_fragment_opcode      (io_input_cmd_payload_fragment_opcode                         ), //i
    .io_input_cmd_payload_fragment_address     (io_input_cmd_payload_fragment_address[31:0]                  ), //i
    .io_input_cmd_payload_fragment_length      (io_input_cmd_payload_fragment_length[10:0]                   ), //i
    .io_input_cmd_payload_fragment_data        (io_input_cmd_payload_fragment_data[255:0]                    ), //i
    .io_input_cmd_payload_fragment_mask        (io_input_cmd_payload_fragment_mask[31:0]                     ), //i
    .io_input_cmd_payload_fragment_context     (io_input_cmd_payload_fragment_context[14:0]                  ), //i
    .io_input_rsp_valid                        (contextRemover_io_input_rsp_valid                            ), //o
    .io_input_rsp_ready                        (io_input_rsp_ready                                           ), //i
    .io_input_rsp_payload_last                 (contextRemover_io_input_rsp_payload_last                     ), //o
    .io_input_rsp_payload_fragment_opcode      (contextRemover_io_input_rsp_payload_fragment_opcode          ), //o
    .io_input_rsp_payload_fragment_context     (contextRemover_io_input_rsp_payload_fragment_context[14:0]   ), //o
    .io_output_cmd_valid                       (contextRemover_io_output_cmd_valid                           ), //o
    .io_output_cmd_ready                       (contextRemover_io_output_cmd_fork_io_input_ready             ), //i
    .io_output_cmd_payload_last                (contextRemover_io_output_cmd_payload_last                    ), //o
    .io_output_cmd_payload_fragment_opcode     (contextRemover_io_output_cmd_payload_fragment_opcode         ), //o
    .io_output_cmd_payload_fragment_address    (contextRemover_io_output_cmd_payload_fragment_address[31:0]  ), //o
    .io_output_cmd_payload_fragment_length     (contextRemover_io_output_cmd_payload_fragment_length[10:0]   ), //o
    .io_output_cmd_payload_fragment_data       (contextRemover_io_output_cmd_payload_fragment_data[255:0]    ), //o
    .io_output_cmd_payload_fragment_mask       (contextRemover_io_output_cmd_payload_fragment_mask[31:0]     ), //o
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
    .io_input_payload_fragment_length         (contextRemover_io_output_cmd_payload_fragment_length[10:0]                     ), //i
    .io_input_payload_fragment_data           (contextRemover_io_output_cmd_payload_fragment_data[255:0]                      ), //i
    .io_input_payload_fragment_mask           (contextRemover_io_output_cmd_payload_fragment_mask[31:0]                       ), //i
    .io_outputs_0_valid                       (contextRemover_io_output_cmd_fork_io_outputs_0_valid                           ), //o
    .io_outputs_0_ready                       (_zz_3                                                                          ), //i
    .io_outputs_0_payload_last                (contextRemover_io_output_cmd_fork_io_outputs_0_payload_last                    ), //o
    .io_outputs_0_payload_fragment_opcode     (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_opcode         ), //o
    .io_outputs_0_payload_fragment_address    (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_address[31:0]  ), //o
    .io_outputs_0_payload_fragment_length     (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_length[10:0]   ), //o
    .io_outputs_0_payload_fragment_data       (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_data[255:0]    ), //o
    .io_outputs_0_payload_fragment_mask       (contextRemover_io_output_cmd_fork_io_outputs_0_payload_fragment_mask[31:0]     ), //o
    .io_outputs_1_valid                       (contextRemover_io_output_cmd_fork_io_outputs_1_valid                           ), //o
    .io_outputs_1_ready                       (io_output_w_ready                                                              ), //i
    .io_outputs_1_payload_last                (contextRemover_io_output_cmd_fork_io_outputs_1_payload_last                    ), //o
    .io_outputs_1_payload_fragment_opcode     (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_opcode         ), //o
    .io_outputs_1_payload_fragment_address    (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_address[31:0]  ), //o
    .io_outputs_1_payload_fragment_length     (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_length[10:0]   ), //o
    .io_outputs_1_payload_fragment_data       (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_data[255:0]    ), //o
    .io_outputs_1_payload_fragment_mask       (contextRemover_io_output_cmd_fork_io_outputs_1_payload_fragment_mask[31:0]     ), //o
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
  assign io_output_aw_payload_len = {1'd0, _zz_5};
  assign io_output_aw_payload_size = 3'b101;
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

module dma_socRuby_BmbSourceRemover_1 (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [1:0]    io_input_cmd_payload_fragment_source,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [10:0]   io_input_cmd_payload_fragment_length,
  input      [255:0]  io_input_cmd_payload_fragment_data,
  input      [31:0]   io_input_cmd_payload_fragment_mask,
  input      [12:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [1:0]    io_input_rsp_payload_fragment_source,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [12:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [10:0]   io_output_cmd_payload_fragment_length,
  output     [255:0]  io_output_cmd_payload_fragment_data,
  output     [31:0]   io_output_cmd_payload_fragment_mask,
  output     [14:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [14:0]   io_output_rsp_payload_fragment_context
);
  wire       [1:0]    cmdContext_source;
  wire       [12:0]   cmdContext_context;
  wire       [1:0]    rspContext_source;
  wire       [12:0]   rspContext_context;
  wire       [14:0]   _zz_1;

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
  assign rspContext_context = _zz_1[14 : 2];
  assign io_input_rsp_valid = io_output_rsp_valid;
  assign io_output_rsp_ready = io_input_rsp_ready;
  assign io_input_rsp_payload_last = io_output_rsp_payload_last;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_source = rspContext_source;
  assign io_input_rsp_payload_fragment_context = rspContext_context;

endmodule

module dma_socRuby_BmbUpSizerBridge_1 (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [1:0]    io_input_cmd_payload_fragment_source,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [10:0]   io_input_cmd_payload_fragment_length,
  input      [63:0]   io_input_cmd_payload_fragment_data,
  input      [7:0]    io_input_cmd_payload_fragment_mask,
  input      [12:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [1:0]    io_input_rsp_payload_fragment_source,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [12:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [1:0]    io_output_cmd_payload_fragment_source,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [10:0]   io_output_cmd_payload_fragment_length,
  output reg [255:0]  io_output_cmd_payload_fragment_data,
  output reg [31:0]   io_output_cmd_payload_fragment_mask,
  output     [12:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [1:0]    io_output_rsp_payload_fragment_source,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [12:0]   io_output_rsp_payload_fragment_context,
  input               clk,
  input               reset
);
  wire                _zz_1;
  wire                _zz_2;
  wire                _zz_3;
  wire       [1:0]    cmdArea_selStart;
  wire       [12:0]   cmdArea_context_context;
  reg        [63:0]   cmdArea_writeLogic_dataRegs_0;
  reg        [63:0]   cmdArea_writeLogic_dataRegs_1;
  reg        [63:0]   cmdArea_writeLogic_dataRegs_2;
  reg        [7:0]    cmdArea_writeLogic_maskRegs_0;
  reg        [7:0]    cmdArea_writeLogic_maskRegs_1;
  reg        [7:0]    cmdArea_writeLogic_maskRegs_2;
  reg        [1:0]    cmdArea_writeLogic_selReg;
  reg                 io_input_cmd_payload_first;
  wire       [1:0]    cmdArea_writeLogic_sel;
  wire       [63:0]   cmdArea_writeLogic_outputData_0;
  wire       [63:0]   cmdArea_writeLogic_outputData_1;
  wire       [63:0]   cmdArea_writeLogic_outputData_2;
  wire       [63:0]   cmdArea_writeLogic_outputData_3;
  wire       [7:0]    cmdArea_writeLogic_outputMask_0;
  wire       [7:0]    cmdArea_writeLogic_outputMask_1;
  wire       [7:0]    cmdArea_writeLogic_outputMask_2;
  wire       [7:0]    cmdArea_writeLogic_outputMask_3;
  wire       [12:0]   rspArea_context_context;

  assign _zz_1 = ((! io_input_cmd_payload_first) && (cmdArea_writeLogic_selReg != 2'b00));
  assign _zz_2 = ((! io_input_cmd_payload_first) && (cmdArea_writeLogic_selReg != 2'b01));
  assign _zz_3 = ((! io_input_cmd_payload_first) && (cmdArea_writeLogic_selReg != 2'b10));
  assign cmdArea_selStart = io_input_cmd_payload_fragment_address[4 : 3];
  assign cmdArea_context_context = io_input_cmd_payload_fragment_context;
  assign io_output_cmd_payload_last = io_input_cmd_payload_last;
  assign io_output_cmd_payload_fragment_opcode = io_input_cmd_payload_fragment_opcode;
  assign io_output_cmd_payload_fragment_address = io_input_cmd_payload_fragment_address;
  assign io_output_cmd_payload_fragment_length = io_input_cmd_payload_fragment_length;
  assign io_output_cmd_payload_fragment_source = io_input_cmd_payload_fragment_source;
  assign io_output_cmd_payload_fragment_context = cmdArea_context_context;
  assign cmdArea_writeLogic_sel = (io_input_cmd_payload_first ? cmdArea_selStart : cmdArea_writeLogic_selReg);
  assign cmdArea_writeLogic_outputData_0 = io_output_cmd_payload_fragment_data[63 : 0];
  assign cmdArea_writeLogic_outputData_1 = io_output_cmd_payload_fragment_data[127 : 64];
  assign cmdArea_writeLogic_outputData_2 = io_output_cmd_payload_fragment_data[191 : 128];
  assign cmdArea_writeLogic_outputData_3 = io_output_cmd_payload_fragment_data[255 : 192];
  assign cmdArea_writeLogic_outputMask_0 = io_output_cmd_payload_fragment_mask[7 : 0];
  assign cmdArea_writeLogic_outputMask_1 = io_output_cmd_payload_fragment_mask[15 : 8];
  assign cmdArea_writeLogic_outputMask_2 = io_output_cmd_payload_fragment_mask[23 : 16];
  assign cmdArea_writeLogic_outputMask_3 = io_output_cmd_payload_fragment_mask[31 : 24];
  always @ (*) begin
    io_output_cmd_payload_fragment_data[63 : 0] = io_input_cmd_payload_fragment_data;
    if(_zz_1)begin
      io_output_cmd_payload_fragment_data[63 : 0] = cmdArea_writeLogic_dataRegs_0;
    end
    io_output_cmd_payload_fragment_data[127 : 64] = io_input_cmd_payload_fragment_data;
    if(_zz_2)begin
      io_output_cmd_payload_fragment_data[127 : 64] = cmdArea_writeLogic_dataRegs_1;
    end
    io_output_cmd_payload_fragment_data[191 : 128] = io_input_cmd_payload_fragment_data;
    if(_zz_3)begin
      io_output_cmd_payload_fragment_data[191 : 128] = cmdArea_writeLogic_dataRegs_2;
    end
    io_output_cmd_payload_fragment_data[255 : 192] = io_input_cmd_payload_fragment_data;
  end

  always @ (*) begin
    io_output_cmd_payload_fragment_mask[7 : 0] = ((cmdArea_writeLogic_sel == 2'b00) ? io_input_cmd_payload_fragment_mask : cmdArea_writeLogic_maskRegs_0);
    io_output_cmd_payload_fragment_mask[15 : 8] = ((cmdArea_writeLogic_sel == 2'b01) ? io_input_cmd_payload_fragment_mask : cmdArea_writeLogic_maskRegs_1);
    io_output_cmd_payload_fragment_mask[23 : 16] = ((cmdArea_writeLogic_sel == 2'b10) ? io_input_cmd_payload_fragment_mask : cmdArea_writeLogic_maskRegs_2);
    io_output_cmd_payload_fragment_mask[31 : 24] = ((cmdArea_writeLogic_sel == 2'b11) ? io_input_cmd_payload_fragment_mask : 8'h0);
  end

  assign io_output_cmd_valid = (io_input_cmd_valid && ((cmdArea_writeLogic_sel == 2'b11) || io_input_cmd_payload_last));
  assign io_input_cmd_ready = (! (io_output_cmd_valid && (! io_output_cmd_ready)));
  assign rspArea_context_context = io_output_rsp_payload_fragment_context[12 : 0];
  assign io_input_rsp_valid = io_output_rsp_valid;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_source = io_output_rsp_payload_fragment_source;
  assign io_input_rsp_payload_fragment_context = rspArea_context_context;
  assign io_input_rsp_payload_last = io_output_rsp_payload_last;
  assign io_output_rsp_ready = io_input_rsp_ready;
  always @ (posedge clk) begin
    if(reset) begin
      cmdArea_writeLogic_maskRegs_0 <= 8'h0;
      cmdArea_writeLogic_maskRegs_1 <= 8'h0;
      cmdArea_writeLogic_maskRegs_2 <= 8'h0;
      io_input_cmd_payload_first <= 1'b1;
    end else begin
      if((io_input_cmd_valid && io_input_cmd_ready))begin
        io_input_cmd_payload_first <= io_input_cmd_payload_last;
      end
      if((io_input_cmd_valid && (cmdArea_writeLogic_sel == 2'b00)))begin
        cmdArea_writeLogic_maskRegs_0 <= io_input_cmd_payload_fragment_mask;
      end
      if((io_output_cmd_valid && io_output_cmd_ready))begin
        cmdArea_writeLogic_maskRegs_0 <= 8'h0;
      end
      if((io_input_cmd_valid && (cmdArea_writeLogic_sel == 2'b01)))begin
        cmdArea_writeLogic_maskRegs_1 <= io_input_cmd_payload_fragment_mask;
      end
      if((io_output_cmd_valid && io_output_cmd_ready))begin
        cmdArea_writeLogic_maskRegs_1 <= 8'h0;
      end
      if((io_input_cmd_valid && (cmdArea_writeLogic_sel == 2'b10)))begin
        cmdArea_writeLogic_maskRegs_2 <= io_input_cmd_payload_fragment_mask;
      end
      if((io_output_cmd_valid && io_output_cmd_ready))begin
        cmdArea_writeLogic_maskRegs_2 <= 8'h0;
      end
    end
  end

  always @ (posedge clk) begin
    if((io_input_cmd_valid && io_input_cmd_ready))begin
      cmdArea_writeLogic_selReg <= (cmdArea_writeLogic_sel + 2'b01);
    end
    if(! _zz_1) begin
      cmdArea_writeLogic_dataRegs_0 <= io_input_cmd_payload_fragment_data;
    end
    if(! _zz_2) begin
      cmdArea_writeLogic_dataRegs_1 <= io_input_cmd_payload_fragment_data;
    end
    if(! _zz_3) begin
      cmdArea_writeLogic_dataRegs_2 <= io_input_cmd_payload_fragment_data;
    end
  end


endmodule

module dma_socRuby_BmbToAxi4ReadOnlyBridge (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [10:0]   io_input_cmd_payload_fragment_length,
  input      [24:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [255:0]  io_input_rsp_payload_fragment_data,
  output     [24:0]   io_input_rsp_payload_fragment_context,
  output              io_output_ar_valid,
  input               io_output_ar_ready,
  output     [31:0]   io_output_ar_payload_addr,
  output     [7:0]    io_output_ar_payload_len,
  output     [2:0]    io_output_ar_payload_size,
  output     [3:0]    io_output_ar_payload_cache,
  output     [2:0]    io_output_ar_payload_prot,
  input               io_output_r_valid,
  output              io_output_r_ready,
  input      [255:0]  io_output_r_payload_data,
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
  wire       [255:0]  contextRemover_io_input_rsp_payload_fragment_data;
  wire       [24:0]   contextRemover_io_input_rsp_payload_fragment_context;
  wire                contextRemover_io_output_cmd_valid;
  wire                contextRemover_io_output_cmd_payload_last;
  wire       [0:0]    contextRemover_io_output_cmd_payload_fragment_opcode;
  wire       [31:0]   contextRemover_io_output_cmd_payload_fragment_address;
  wire       [10:0]   contextRemover_io_output_cmd_payload_fragment_length;
  wire                contextRemover_io_output_rsp_ready;
  wire       [6:0]    _zz_2;
  wire       [11:0]   _zz_3;
  wire       [4:0]    _zz_4;
  wire       [11:0]   _zz_5;

  assign _zz_2 = _zz_3[11 : 5];
  assign _zz_3 = ({1'b0,contextRemover_io_output_cmd_payload_fragment_length} + _zz_5);
  assign _zz_4 = contextRemover_io_output_cmd_payload_fragment_address[4 : 0];
  assign _zz_5 = {7'd0, _zz_4};
  dma_socRuby_BmbContextRemover contextRemover (
    .io_input_cmd_valid                        (io_input_cmd_valid                                           ), //i
    .io_input_cmd_ready                        (contextRemover_io_input_cmd_ready                            ), //o
    .io_input_cmd_payload_last                 (io_input_cmd_payload_last                                    ), //i
    .io_input_cmd_payload_fragment_opcode      (io_input_cmd_payload_fragment_opcode                         ), //i
    .io_input_cmd_payload_fragment_address     (io_input_cmd_payload_fragment_address[31:0]                  ), //i
    .io_input_cmd_payload_fragment_length      (io_input_cmd_payload_fragment_length[10:0]                   ), //i
    .io_input_cmd_payload_fragment_context     (io_input_cmd_payload_fragment_context[24:0]                  ), //i
    .io_input_rsp_valid                        (contextRemover_io_input_rsp_valid                            ), //o
    .io_input_rsp_ready                        (io_input_rsp_ready                                           ), //i
    .io_input_rsp_payload_last                 (contextRemover_io_input_rsp_payload_last                     ), //o
    .io_input_rsp_payload_fragment_opcode      (contextRemover_io_input_rsp_payload_fragment_opcode          ), //o
    .io_input_rsp_payload_fragment_data        (contextRemover_io_input_rsp_payload_fragment_data[255:0]     ), //o
    .io_input_rsp_payload_fragment_context     (contextRemover_io_input_rsp_payload_fragment_context[24:0]   ), //o
    .io_output_cmd_valid                       (contextRemover_io_output_cmd_valid                           ), //o
    .io_output_cmd_ready                       (io_output_ar_ready                                           ), //i
    .io_output_cmd_payload_last                (contextRemover_io_output_cmd_payload_last                    ), //o
    .io_output_cmd_payload_fragment_opcode     (contextRemover_io_output_cmd_payload_fragment_opcode         ), //o
    .io_output_cmd_payload_fragment_address    (contextRemover_io_output_cmd_payload_fragment_address[31:0]  ), //o
    .io_output_cmd_payload_fragment_length     (contextRemover_io_output_cmd_payload_fragment_length[10:0]   ), //o
    .io_output_rsp_valid                       (io_output_r_valid                                            ), //i
    .io_output_rsp_ready                       (contextRemover_io_output_rsp_ready                           ), //o
    .io_output_rsp_payload_last                (io_output_r_payload_last                                     ), //i
    .io_output_rsp_payload_fragment_opcode     (_zz_1                                                        ), //i
    .io_output_rsp_payload_fragment_data       (io_output_r_payload_data[255:0]                              ), //i
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
  assign io_output_ar_payload_len = {1'd0, _zz_2};
  assign io_output_ar_payload_size = 3'b101;
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
  input      [10:0]   io_input_cmd_payload_fragment_length,
  input      [22:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [1:0]    io_input_rsp_payload_fragment_source,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [255:0]  io_input_rsp_payload_fragment_data,
  output     [22:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [10:0]   io_output_cmd_payload_fragment_length,
  output     [24:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [255:0]  io_output_rsp_payload_fragment_data,
  input      [24:0]   io_output_rsp_payload_fragment_context
);
  wire       [1:0]    cmdContext_source;
  wire       [22:0]   cmdContext_context;
  wire       [1:0]    rspContext_source;
  wire       [22:0]   rspContext_context;
  wire       [24:0]   _zz_1;

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
  assign rspContext_context = _zz_1[24 : 2];
  assign io_input_rsp_valid = io_output_rsp_valid;
  assign io_output_rsp_ready = io_input_rsp_ready;
  assign io_input_rsp_payload_last = io_output_rsp_payload_last;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_data = io_output_rsp_payload_fragment_data;
  assign io_input_rsp_payload_fragment_source = rspContext_source;
  assign io_input_rsp_payload_fragment_context = rspContext_context;

endmodule

module dma_socRuby_BmbUpSizerBridge (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [1:0]    io_input_cmd_payload_fragment_source,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [10:0]   io_input_cmd_payload_fragment_length,
  input      [18:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output reg          io_input_rsp_payload_last,
  output     [1:0]    io_input_rsp_payload_fragment_source,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [63:0]   io_input_rsp_payload_fragment_data,
  output     [18:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [1:0]    io_output_cmd_payload_fragment_source,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [10:0]   io_output_cmd_payload_fragment_length,
  output     [22:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [1:0]    io_output_rsp_payload_fragment_source,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [255:0]  io_output_rsp_payload_fragment_data,
  input      [22:0]   io_output_rsp_payload_fragment_context,
  input               clk,
  input               reset
);
  reg        [63:0]   _zz_2;
  wire       [8:0]    _zz_3;
  wire       [1:0]    _zz_4;
  wire       [8:0]    _zz_5;
  wire       [11:0]   _zz_6;
  wire       [2:0]    _zz_7;
  wire       [11:0]   _zz_8;
  wire       [1:0]    cmdArea_selStart;
  wire       [1:0]    cmdArea_context_selStart;
  wire       [1:0]    cmdArea_context_selEnd;
  wire       [18:0]   cmdArea_context_context;
  wire       [1:0]    rspArea_context_selStart;
  wire       [1:0]    rspArea_context_selEnd;
  wire       [18:0]   rspArea_context_context;
  wire       [22:0]   _zz_1;
  reg        [1:0]    rspArea_readLogic_selReg;
  reg                 io_input_rsp_payload_first;
  wire       [1:0]    rspArea_readLogic_sel;

  assign _zz_3 = (_zz_5 + _zz_6[11 : 3]);
  assign _zz_4 = io_input_cmd_payload_fragment_address[4 : 3];
  assign _zz_5 = {7'd0, _zz_4};
  assign _zz_6 = ({1'b0,io_input_cmd_payload_fragment_length} + _zz_8);
  assign _zz_7 = io_input_cmd_payload_fragment_address[2 : 0];
  assign _zz_8 = {9'd0, _zz_7};
  always @(*) begin
    case(rspArea_readLogic_sel)
      2'b00 : begin
        _zz_2 = io_output_rsp_payload_fragment_data[63 : 0];
      end
      2'b01 : begin
        _zz_2 = io_output_rsp_payload_fragment_data[127 : 64];
      end
      2'b10 : begin
        _zz_2 = io_output_rsp_payload_fragment_data[191 : 128];
      end
      default : begin
        _zz_2 = io_output_rsp_payload_fragment_data[255 : 192];
      end
    endcase
  end

  assign cmdArea_selStart = io_input_cmd_payload_fragment_address[4 : 3];
  assign cmdArea_context_context = io_input_cmd_payload_fragment_context;
  assign cmdArea_context_selStart = cmdArea_selStart;
  assign cmdArea_context_selEnd = _zz_3[1:0];
  assign io_output_cmd_payload_last = io_input_cmd_payload_last;
  assign io_output_cmd_payload_fragment_opcode = io_input_cmd_payload_fragment_opcode;
  assign io_output_cmd_payload_fragment_address = io_input_cmd_payload_fragment_address;
  assign io_output_cmd_payload_fragment_length = io_input_cmd_payload_fragment_length;
  assign io_output_cmd_payload_fragment_source = io_input_cmd_payload_fragment_source;
  assign io_output_cmd_payload_fragment_context = {cmdArea_context_context,{cmdArea_context_selEnd,cmdArea_context_selStart}};
  assign io_output_cmd_valid = io_input_cmd_valid;
  assign io_input_cmd_ready = io_output_cmd_ready;
  assign _zz_1 = io_output_rsp_payload_fragment_context;
  assign rspArea_context_selStart = _zz_1[1 : 0];
  assign rspArea_context_selEnd = _zz_1[3 : 2];
  assign rspArea_context_context = _zz_1[22 : 4];
  assign io_input_rsp_valid = io_output_rsp_valid;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_source = io_output_rsp_payload_fragment_source;
  assign io_input_rsp_payload_fragment_context = rspArea_context_context;
  assign rspArea_readLogic_sel = (io_input_rsp_payload_first ? rspArea_context_selStart : rspArea_readLogic_selReg);
  always @ (*) begin
    io_input_rsp_payload_last = (io_output_rsp_payload_last && (rspArea_readLogic_sel == rspArea_context_selEnd));
    if((rspArea_context_selEnd != rspArea_readLogic_sel))begin
      io_input_rsp_payload_last = 1'b0;
    end
  end

  assign io_output_rsp_ready = (io_input_rsp_ready && (io_input_rsp_payload_last || (rspArea_readLogic_sel == 2'b11)));
  assign io_input_rsp_payload_fragment_data = _zz_2;
  always @ (posedge clk) begin
    if(reset) begin
      io_input_rsp_payload_first <= 1'b1;
    end else begin
      if((io_input_rsp_valid && io_input_rsp_ready))begin
        io_input_rsp_payload_first <= io_input_rsp_payload_last;
      end
    end
  end

  always @ (posedge clk) begin
    rspArea_readLogic_selReg <= rspArea_readLogic_sel;
    if((io_input_rsp_valid && io_input_rsp_ready))begin
      rspArea_readLogic_selReg <= (rspArea_readLogic_sel + 2'b01);
    end
  end


endmodule

module dma_socRuby_BmbArbiter_1 (
  input               io_inputs_0_cmd_valid,
  output              io_inputs_0_cmd_ready,
  input               io_inputs_0_cmd_payload_last,
  input      [0:0]    io_inputs_0_cmd_payload_fragment_opcode,
  input      [31:0]   io_inputs_0_cmd_payload_fragment_address,
  input      [1:0]    io_inputs_0_cmd_payload_fragment_length,
  input      [63:0]   io_inputs_0_cmd_payload_fragment_data,
  input      [7:0]    io_inputs_0_cmd_payload_fragment_mask,
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
  input      [10:0]   io_inputs_1_cmd_payload_fragment_length,
  input      [63:0]   io_inputs_1_cmd_payload_fragment_data,
  input      [7:0]    io_inputs_1_cmd_payload_fragment_mask,
  input      [12:0]   io_inputs_1_cmd_payload_fragment_context,
  output              io_inputs_1_rsp_valid,
  input               io_inputs_1_rsp_ready,
  output              io_inputs_1_rsp_payload_last,
  output     [0:0]    io_inputs_1_rsp_payload_fragment_source,
  output     [0:0]    io_inputs_1_rsp_payload_fragment_opcode,
  output     [12:0]   io_inputs_1_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [1:0]    io_output_cmd_payload_fragment_source,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [10:0]   io_output_cmd_payload_fragment_length,
  output     [63:0]   io_output_cmd_payload_fragment_data,
  output     [7:0]    io_output_cmd_payload_fragment_mask,
  output     [12:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [1:0]    io_output_rsp_payload_fragment_source,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [12:0]   io_output_rsp_payload_fragment_context,
  input               clk,
  input               reset
);
  wire       [1:0]    _zz_1;
  wire       [10:0]   _zz_2;
  wire       [12:0]   _zz_3;
  wire       [1:0]    _zz_4;
  reg                 _zz_5;
  wire                memory_arbiter_io_inputs_0_ready;
  wire                memory_arbiter_io_inputs_1_ready;
  wire                memory_arbiter_io_output_valid;
  wire                memory_arbiter_io_output_payload_last;
  wire       [1:0]    memory_arbiter_io_output_payload_fragment_source;
  wire       [0:0]    memory_arbiter_io_output_payload_fragment_opcode;
  wire       [31:0]   memory_arbiter_io_output_payload_fragment_address;
  wire       [10:0]   memory_arbiter_io_output_payload_fragment_length;
  wire       [63:0]   memory_arbiter_io_output_payload_fragment_data;
  wire       [7:0]    memory_arbiter_io_output_payload_fragment_mask;
  wire       [12:0]   memory_arbiter_io_output_payload_fragment_context;
  wire       [0:0]    memory_arbiter_io_chosen;
  wire       [1:0]    memory_arbiter_io_chosenOH;
  wire       [2:0]    _zz_6;
  wire       [0:0]    memory_rspSel;

  assign _zz_6 = {memory_arbiter_io_output_payload_fragment_source,memory_arbiter_io_chosen};
  dma_socRuby_StreamArbiter_3 memory_arbiter (
    .io_inputs_0_valid                       (io_inputs_0_cmd_valid                                    ), //i
    .io_inputs_0_ready                       (memory_arbiter_io_inputs_0_ready                         ), //o
    .io_inputs_0_payload_last                (io_inputs_0_cmd_payload_last                             ), //i
    .io_inputs_0_payload_fragment_source     (_zz_1[1:0]                                               ), //i
    .io_inputs_0_payload_fragment_opcode     (io_inputs_0_cmd_payload_fragment_opcode                  ), //i
    .io_inputs_0_payload_fragment_address    (io_inputs_0_cmd_payload_fragment_address[31:0]           ), //i
    .io_inputs_0_payload_fragment_length     (_zz_2[10:0]                                              ), //i
    .io_inputs_0_payload_fragment_data       (io_inputs_0_cmd_payload_fragment_data[63:0]              ), //i
    .io_inputs_0_payload_fragment_mask       (io_inputs_0_cmd_payload_fragment_mask[7:0]               ), //i
    .io_inputs_0_payload_fragment_context    (_zz_3[12:0]                                              ), //i
    .io_inputs_1_valid                       (io_inputs_1_cmd_valid                                    ), //i
    .io_inputs_1_ready                       (memory_arbiter_io_inputs_1_ready                         ), //o
    .io_inputs_1_payload_last                (io_inputs_1_cmd_payload_last                             ), //i
    .io_inputs_1_payload_fragment_source     (_zz_4[1:0]                                               ), //i
    .io_inputs_1_payload_fragment_opcode     (io_inputs_1_cmd_payload_fragment_opcode                  ), //i
    .io_inputs_1_payload_fragment_address    (io_inputs_1_cmd_payload_fragment_address[31:0]           ), //i
    .io_inputs_1_payload_fragment_length     (io_inputs_1_cmd_payload_fragment_length[10:0]            ), //i
    .io_inputs_1_payload_fragment_data       (io_inputs_1_cmd_payload_fragment_data[63:0]              ), //i
    .io_inputs_1_payload_fragment_mask       (io_inputs_1_cmd_payload_fragment_mask[7:0]               ), //i
    .io_inputs_1_payload_fragment_context    (io_inputs_1_cmd_payload_fragment_context[12:0]           ), //i
    .io_output_valid                         (memory_arbiter_io_output_valid                           ), //o
    .io_output_ready                         (io_output_cmd_ready                                      ), //i
    .io_output_payload_last                  (memory_arbiter_io_output_payload_last                    ), //o
    .io_output_payload_fragment_source       (memory_arbiter_io_output_payload_fragment_source[1:0]    ), //o
    .io_output_payload_fragment_opcode       (memory_arbiter_io_output_payload_fragment_opcode         ), //o
    .io_output_payload_fragment_address      (memory_arbiter_io_output_payload_fragment_address[31:0]  ), //o
    .io_output_payload_fragment_length       (memory_arbiter_io_output_payload_fragment_length[10:0]   ), //o
    .io_output_payload_fragment_data         (memory_arbiter_io_output_payload_fragment_data[63:0]     ), //o
    .io_output_payload_fragment_mask         (memory_arbiter_io_output_payload_fragment_mask[7:0]      ), //o
    .io_output_payload_fragment_context      (memory_arbiter_io_output_payload_fragment_context[12:0]  ), //o
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
  assign _zz_2 = {9'd0, io_inputs_0_cmd_payload_fragment_length};
  assign _zz_3 = {11'd0, io_inputs_0_cmd_payload_fragment_context};
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
  output     [63:0]   io_inputs_0_rsp_payload_fragment_data,
  output     [1:0]    io_inputs_0_rsp_payload_fragment_context,
  input               io_inputs_1_cmd_valid,
  output              io_inputs_1_cmd_ready,
  input               io_inputs_1_cmd_payload_last,
  input      [0:0]    io_inputs_1_cmd_payload_fragment_source,
  input      [0:0]    io_inputs_1_cmd_payload_fragment_opcode,
  input      [31:0]   io_inputs_1_cmd_payload_fragment_address,
  input      [10:0]   io_inputs_1_cmd_payload_fragment_length,
  input      [18:0]   io_inputs_1_cmd_payload_fragment_context,
  output              io_inputs_1_rsp_valid,
  input               io_inputs_1_rsp_ready,
  output              io_inputs_1_rsp_payload_last,
  output     [0:0]    io_inputs_1_rsp_payload_fragment_source,
  output     [0:0]    io_inputs_1_rsp_payload_fragment_opcode,
  output     [63:0]   io_inputs_1_rsp_payload_fragment_data,
  output     [18:0]   io_inputs_1_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [1:0]    io_output_cmd_payload_fragment_source,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [10:0]   io_output_cmd_payload_fragment_length,
  output     [18:0]   io_output_cmd_payload_fragment_context,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [1:0]    io_output_rsp_payload_fragment_source,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [63:0]   io_output_rsp_payload_fragment_data,
  input      [18:0]   io_output_rsp_payload_fragment_context,
  input               clk,
  input               reset
);
  wire       [1:0]    _zz_1;
  wire       [10:0]   _zz_2;
  wire       [18:0]   _zz_3;
  wire       [1:0]    _zz_4;
  reg                 _zz_5;
  wire                memory_arbiter_io_inputs_0_ready;
  wire                memory_arbiter_io_inputs_1_ready;
  wire                memory_arbiter_io_output_valid;
  wire                memory_arbiter_io_output_payload_last;
  wire       [1:0]    memory_arbiter_io_output_payload_fragment_source;
  wire       [0:0]    memory_arbiter_io_output_payload_fragment_opcode;
  wire       [31:0]   memory_arbiter_io_output_payload_fragment_address;
  wire       [10:0]   memory_arbiter_io_output_payload_fragment_length;
  wire       [18:0]   memory_arbiter_io_output_payload_fragment_context;
  wire       [0:0]    memory_arbiter_io_chosen;
  wire       [1:0]    memory_arbiter_io_chosenOH;
  wire       [2:0]    _zz_6;
  wire       [0:0]    memory_rspSel;

  assign _zz_6 = {memory_arbiter_io_output_payload_fragment_source,memory_arbiter_io_chosen};
  dma_socRuby_StreamArbiter_2 memory_arbiter (
    .io_inputs_0_valid                       (io_inputs_0_cmd_valid                                    ), //i
    .io_inputs_0_ready                       (memory_arbiter_io_inputs_0_ready                         ), //o
    .io_inputs_0_payload_last                (io_inputs_0_cmd_payload_last                             ), //i
    .io_inputs_0_payload_fragment_source     (_zz_1[1:0]                                               ), //i
    .io_inputs_0_payload_fragment_opcode     (io_inputs_0_cmd_payload_fragment_opcode                  ), //i
    .io_inputs_0_payload_fragment_address    (io_inputs_0_cmd_payload_fragment_address[31:0]           ), //i
    .io_inputs_0_payload_fragment_length     (_zz_2[10:0]                                              ), //i
    .io_inputs_0_payload_fragment_context    (_zz_3[18:0]                                              ), //i
    .io_inputs_1_valid                       (io_inputs_1_cmd_valid                                    ), //i
    .io_inputs_1_ready                       (memory_arbiter_io_inputs_1_ready                         ), //o
    .io_inputs_1_payload_last                (io_inputs_1_cmd_payload_last                             ), //i
    .io_inputs_1_payload_fragment_source     (_zz_4[1:0]                                               ), //i
    .io_inputs_1_payload_fragment_opcode     (io_inputs_1_cmd_payload_fragment_opcode                  ), //i
    .io_inputs_1_payload_fragment_address    (io_inputs_1_cmd_payload_fragment_address[31:0]           ), //i
    .io_inputs_1_payload_fragment_length     (io_inputs_1_cmd_payload_fragment_length[10:0]            ), //i
    .io_inputs_1_payload_fragment_context    (io_inputs_1_cmd_payload_fragment_context[18:0]           ), //i
    .io_output_valid                         (memory_arbiter_io_output_valid                           ), //o
    .io_output_ready                         (io_output_cmd_ready                                      ), //i
    .io_output_payload_last                  (memory_arbiter_io_output_payload_last                    ), //o
    .io_output_payload_fragment_source       (memory_arbiter_io_output_payload_fragment_source[1:0]    ), //o
    .io_output_payload_fragment_opcode       (memory_arbiter_io_output_payload_fragment_opcode         ), //o
    .io_output_payload_fragment_address      (memory_arbiter_io_output_payload_fragment_address[31:0]  ), //o
    .io_output_payload_fragment_length       (memory_arbiter_io_output_payload_fragment_length[10:0]   ), //o
    .io_output_payload_fragment_context      (memory_arbiter_io_output_payload_fragment_context[18:0]  ), //o
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
  assign _zz_2 = {6'd0, io_inputs_0_cmd_payload_fragment_length};
  assign _zz_3 = {17'd0, io_inputs_0_cmd_payload_fragment_context};
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
  reg        [3:0]    buffers_0;
  reg        [3:0]    buffers_1;

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
  input      [63:0]   io_sgRead_rsp_payload_fragment_data,
  input      [1:0]    io_sgRead_rsp_payload_fragment_context,
  output              io_sgWrite_cmd_valid,
  input               io_sgWrite_cmd_ready,
  output              io_sgWrite_cmd_payload_last,
  output     [0:0]    io_sgWrite_cmd_payload_fragment_opcode,
  output     [31:0]   io_sgWrite_cmd_payload_fragment_address,
  output     [1:0]    io_sgWrite_cmd_payload_fragment_length,
  output reg [63:0]   io_sgWrite_cmd_payload_fragment_data,
  output reg [7:0]    io_sgWrite_cmd_payload_fragment_mask,
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
  output     [10:0]   io_read_cmd_payload_fragment_length,
  output     [18:0]   io_read_cmd_payload_fragment_context,
  input               io_read_rsp_valid,
  output              io_read_rsp_ready,
  input               io_read_rsp_payload_last,
  input      [0:0]    io_read_rsp_payload_fragment_source,
  input      [0:0]    io_read_rsp_payload_fragment_opcode,
  input      [63:0]   io_read_rsp_payload_fragment_data,
  input      [18:0]   io_read_rsp_payload_fragment_context,
  output              io_write_cmd_valid,
  input               io_write_cmd_ready,
  output              io_write_cmd_payload_last,
  output     [0:0]    io_write_cmd_payload_fragment_source,
  output     [0:0]    io_write_cmd_payload_fragment_opcode,
  output     [31:0]   io_write_cmd_payload_fragment_address,
  output     [10:0]   io_write_cmd_payload_fragment_length,
  output     [63:0]   io_write_cmd_payload_fragment_data,
  output     [7:0]    io_write_cmd_payload_fragment_mask,
  output     [12:0]   io_write_cmd_payload_fragment_context,
  input               io_write_rsp_valid,
  output              io_write_rsp_ready,
  input               io_write_rsp_payload_last,
  input      [0:0]    io_write_rsp_payload_fragment_source,
  input      [0:0]    io_write_rsp_payload_fragment_opcode,
  input      [12:0]   io_write_rsp_payload_fragment_context,
  output              io_outputs_0_valid,
  input               io_outputs_0_ready,
  output     [63:0]   io_outputs_0_payload_data,
  output     [7:0]    io_outputs_0_payload_mask,
  output     [3:0]    io_outputs_0_payload_sink,
  output              io_outputs_0_payload_last,
  output              io_outputs_1_valid,
  input               io_outputs_1_ready,
  output     [63:0]   io_outputs_1_payload_data,
  output     [7:0]    io_outputs_1_payload_mask,
  output     [3:0]    io_outputs_1_payload_sink,
  output              io_outputs_1_payload_last,
  input               io_inputs_0_valid,
  output reg          io_inputs_0_ready,
  input      [63:0]   io_inputs_0_payload_data,
  input      [7:0]    io_inputs_0_payload_mask,
  input      [3:0]    io_inputs_0_payload_sink,
  input               io_inputs_0_payload_last,
  input               io_inputs_1_valid,
  output reg          io_inputs_1_ready,
  input      [63:0]   io_inputs_1_payload_data,
  input      [7:0]    io_inputs_1_payload_mask,
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
  output              io_0_descriptorUpdate,
  output              io_1_descriptorUpdate,
  output              io_2_descriptorUpdate,
  output              io_3_descriptorUpdate,
  input               clk,
  input               reset
);
  wire       [9:0]    _zz_107;
  wire       [6:0]    _zz_108;
  wire       [9:0]    _zz_109;
  wire       [6:0]    _zz_110;
  wire       [9:0]    _zz_111;
  reg        [7:0]    _zz_112;
  wire       [6:0]    _zz_113;
  wire                _zz_114;
  wire       [9:0]    _zz_115;
  wire       [2:0]    _zz_116;
  wire                _zz_117;
  wire       [9:0]    _zz_118;
  wire       [2:0]    _zz_119;
  wire       [9:0]    _zz_120;
  wire       [11:0]   _zz_121;
  wire                _zz_122;
  reg                 _zz_123;
  reg                 _zz_124;
  wire       [7:0]    _zz_125;
  wire                _zz_126;
  wire                _zz_127;
  wire       [2:0]    _zz_128;
  reg        [3:0]    _zz_129;
  reg        [3:0]    _zz_130;
  reg        [3:0]    _zz_131;
  reg        [3:0]    _zz_132;
  reg        [3:0]    _zz_133;
  reg        [3:0]    _zz_134;
  reg        [31:0]   _zz_135;
  reg        [25:0]   _zz_136;
  reg        [10:0]   _zz_137;
  reg        [10:0]   _zz_138;
  reg        [31:0]   _zz_139;
  reg        [10:0]   _zz_140;
  reg        [10:0]   _zz_141;
  reg        [10:0]   _zz_142;
  reg        [13:0]   _zz_143;
  reg                 _zz_144;
  reg                 _zz_145;
  reg        [26:0]   _zz_146;
  reg        [10:0]   _zz_147;
  reg        [2:0]    _zz_148;
  reg                 _zz_149;
  reg                 _zz_150;
  reg        [31:0]   _zz_151;
  reg        [31:0]   _zz_152;
  reg                 _zz_153;
  wire                memory_core_io_writes_0_cmd_ready;
  wire                memory_core_io_writes_0_rsp_valid;
  wire       [6:0]    memory_core_io_writes_0_rsp_payload_context;
  wire                memory_core_io_writes_1_cmd_ready;
  wire                memory_core_io_writes_1_rsp_valid;
  wire       [6:0]    memory_core_io_writes_1_rsp_payload_context;
  wire                memory_core_io_writes_2_cmd_ready;
  wire                memory_core_io_writes_2_rsp_valid;
  wire       [6:0]    memory_core_io_writes_2_rsp_payload_context;
  wire                memory_core_io_reads_0_cmd_ready;
  wire                memory_core_io_reads_0_rsp_valid;
  wire       [63:0]   memory_core_io_reads_0_rsp_payload_data;
  wire       [7:0]    memory_core_io_reads_0_rsp_payload_mask;
  wire       [2:0]    memory_core_io_reads_0_rsp_payload_context;
  wire                memory_core_io_reads_1_cmd_ready;
  wire                memory_core_io_reads_1_rsp_valid;
  wire       [63:0]   memory_core_io_reads_1_rsp_payload_data;
  wire       [7:0]    memory_core_io_reads_1_rsp_payload_mask;
  wire       [2:0]    memory_core_io_reads_1_rsp_payload_context;
  wire                memory_core_io_reads_2_cmd_ready;
  wire                memory_core_io_reads_2_rsp_valid;
  wire       [63:0]   memory_core_io_reads_2_rsp_payload_data;
  wire       [7:0]    memory_core_io_reads_2_rsp_payload_mask;
  wire       [11:0]   memory_core_io_reads_2_rsp_payload_context;
  wire                m2b_cmd_arbiter_io_inputs_0_ready;
  wire                m2b_cmd_arbiter_io_inputs_1_ready;
  wire                m2b_cmd_arbiter_io_output_valid;
  wire       [0:0]    m2b_cmd_arbiter_io_chosen;
  wire       [1:0]    m2b_cmd_arbiter_io_chosenOH;
  wire                b2m_fsm_arbiter_core_io_inputs_0_ready;
  wire                b2m_fsm_arbiter_core_io_inputs_1_ready;
  wire                b2m_fsm_arbiter_core_io_output_valid;
  wire       [0:0]    b2m_fsm_arbiter_core_io_chosen;
  wire       [1:0]    b2m_fsm_arbiter_core_io_chosenOH;
  wire                b2m_fsm_aggregate_engine_io_input_ready;
  wire       [63:0]   b2m_fsm_aggregate_engine_io_output_data;
  wire       [7:0]    b2m_fsm_aggregate_engine_io_output_mask;
  wire                b2m_fsm_aggregate_engine_io_output_consumed;
  wire       [2:0]    b2m_fsm_aggregate_engine_io_output_usedUntil;
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
  wire       [26:0]   _zz_194;
  wire       [26:0]   _zz_195;
  wire       [13:0]   _zz_196;
  wire       [13:0]   _zz_197;
  wire       [13:0]   _zz_198;
  wire       [9:0]    _zz_199;
  wire       [10:0]   _zz_200;
  wire       [3:0]    _zz_201;
  wire       [0:0]    _zz_202;
  wire       [3:0]    _zz_203;
  wire       [0:0]    _zz_204;
  wire       [3:0]    _zz_205;
  wire       [26:0]   _zz_206;
  wire       [31:0]   _zz_207;
  wire       [31:0]   _zz_208;
  wire       [10:0]   _zz_209;
  wire       [13:0]   _zz_210;
  wire       [3:0]    _zz_211;
  wire       [0:0]    _zz_212;
  wire       [3:0]    _zz_213;
  wire       [0:0]    _zz_214;
  wire       [3:0]    _zz_215;
  wire       [7:0]    _zz_216;
  wire       [10:0]   _zz_217;
  wire       [25:0]   _zz_218;
  wire       [31:0]   _zz_219;
  wire       [31:0]   _zz_220;
  wire       [10:0]   _zz_221;
  wire       [26:0]   _zz_222;
  wire       [26:0]   _zz_223;
  wire       [13:0]   _zz_224;
  wire       [13:0]   _zz_225;
  wire       [13:0]   _zz_226;
  wire       [9:0]    _zz_227;
  wire       [10:0]   _zz_228;
  wire       [3:0]    _zz_229;
  wire       [0:0]    _zz_230;
  wire       [3:0]    _zz_231;
  wire       [0:0]    _zz_232;
  wire       [3:0]    _zz_233;
  wire       [26:0]   _zz_234;
  wire       [31:0]   _zz_235;
  wire       [31:0]   _zz_236;
  wire       [10:0]   _zz_237;
  wire       [13:0]   _zz_238;
  wire       [3:0]    _zz_239;
  wire       [0:0]    _zz_240;
  wire       [3:0]    _zz_241;
  wire       [0:0]    _zz_242;
  wire       [3:0]    _zz_243;
  wire       [7:0]    _zz_244;
  wire       [10:0]   _zz_245;
  wire       [25:0]   _zz_246;
  wire       [31:0]   _zz_247;
  wire       [31:0]   _zz_248;
  wire       [10:0]   _zz_249;
  wire       [3:0]    _zz_250;
  wire       [1:0]    _zz_251;
  wire       [2:0]    _zz_252;
  wire       [0:0]    _zz_253;
  wire       [0:0]    _zz_254;
  wire       [3:0]    _zz_255;
  wire       [1:0]    _zz_256;
  wire       [2:0]    _zz_257;
  wire       [0:0]    _zz_258;
  wire       [0:0]    _zz_259;
  wire       [0:0]    _zz_260;
  wire       [0:0]    _zz_261;
  wire       [0:0]    _zz_262;
  wire       [0:0]    _zz_263;
  wire       [25:0]   _zz_264;
  wire       [25:0]   _zz_265;
  wire       [25:0]   _zz_266;
  wire       [25:0]   _zz_267;
  wire       [31:0]   _zz_268;
  wire       [31:0]   _zz_269;
  wire       [31:0]   _zz_270;
  wire       [31:0]   _zz_271;
  wire       [25:0]   _zz_272;
  wire       [25:0]   _zz_273;
  wire       [11:0]   _zz_274;
  wire       [10:0]   _zz_275;
  wire       [2:0]    _zz_276;
  wire       [10:0]   _zz_277;
  wire       [1:0]    _zz_278;
  wire       [11:0]   _zz_279;
  wire       [0:0]    _zz_280;
  wire       [0:0]    _zz_281;
  wire       [0:0]    _zz_282;
  wire       [31:0]   _zz_283;
  wire       [11:0]   _zz_284;
  wire       [26:0]   _zz_285;
  wire       [25:0]   _zz_286;
  wire       [25:0]   _zz_287;
  wire       [10:0]   _zz_288;
  wire       [25:0]   _zz_289;
  wire       [25:0]   _zz_290;
  wire       [25:0]   _zz_291;
  wire       [13:0]   _zz_292;
  wire       [13:0]   _zz_293;
  wire       [10:0]   _zz_294;
  wire       [2:0]    _zz_295;
  wire       [10:0]   _zz_296;
  wire       [10:0]   _zz_297;
  wire       [0:0]    _zz_298;
  wire       [2:0]    _zz_299;
  wire       [0:0]    _zz_300;
  wire       [3:0]    _zz_301;
  wire       [0:0]    _zz_302;
  wire       [0:0]    _zz_303;
  wire       [0:0]    _zz_304;
  wire       [0:0]    _zz_305;
  wire       [0:0]    _zz_306;
  wire       [0:0]    _zz_307;
  wire       [0:0]    _zz_308;
  wire       [0:0]    _zz_309;
  wire       [0:0]    _zz_310;
  wire       [0:0]    _zz_311;
  wire       [0:0]    _zz_312;
  wire       [0:0]    _zz_313;
  wire       [0:0]    _zz_314;
  wire       [0:0]    _zz_315;
  wire       [0:0]    _zz_316;
  wire       [0:0]    _zz_317;
  wire       [0:0]    _zz_318;
  wire       [0:0]    _zz_319;
  wire       [0:0]    _zz_320;
  wire       [0:0]    _zz_321;
  wire       [0:0]    _zz_322;
  wire       [0:0]    _zz_323;
  wire       [0:0]    _zz_324;
  wire       [0:0]    _zz_325;
  wire       [0:0]    _zz_326;
  wire       [0:0]    _zz_327;
  wire       [0:0]    _zz_328;
  wire       [0:0]    _zz_329;
  wire       [0:0]    _zz_330;
  wire       [0:0]    _zz_331;
  wire       [0:0]    _zz_332;
  wire       [0:0]    _zz_333;
  wire       [0:0]    _zz_334;
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
  wire       [31:0]   _zz_371;
  wire       [31:0]   _zz_372;
  wire       [0:0]    _zz_373;
  wire       [0:0]    _zz_374;
  wire       [0:0]    _zz_375;
  wire       [0:0]    _zz_376;
  wire       [0:0]    _zz_377;
  wire       [0:0]    _zz_378;
  wire       [0:0]    _zz_379;
  wire       [31:0]   _zz_380;
  wire       [31:0]   _zz_381;
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
  wire       [31:0]   _zz_393;
  wire       [31:0]   _zz_394;
  wire       [0:0]    _zz_395;
  wire       [0:0]    _zz_396;
  wire       [0:0]    _zz_397;
  wire       [0:0]    _zz_398;
  wire       [0:0]    _zz_399;
  wire       [0:0]    _zz_400;
  wire       [0:0]    _zz_401;
  wire       [31:0]   _zz_402;
  wire       [31:0]   _zz_403;
  wire       [0:0]    _zz_404;
  wire       [0:0]    _zz_405;
  wire       [0:0]    _zz_406;
  wire       [0:0]    _zz_407;
  wire       [0:0]    _zz_408;
  wire       [0:0]    _zz_409;
  wire       [0:0]    _zz_410;
  wire       [0:0]    _zz_411;
  wire       [0:0]    _zz_412;
  wire       [10:0]   _zz_413;
  wire       [3:0]    _zz_414;
  wire       [13:0]   _zz_415;
  wire       [0:0]    _zz_416;
  wire       [10:0]   _zz_417;
  wire       [0:0]    _zz_418;
  wire       [10:0]   _zz_419;
  wire       [3:0]    _zz_420;
  wire       [13:0]   _zz_421;
  wire       [3:0]    _zz_422;
  wire       [0:0]    _zz_423;
  wire       [10:0]   _zz_424;
  wire       [0:0]    _zz_425;
  wire       [10:0]   _zz_426;
  wire       [3:0]    _zz_427;
  wire       [13:0]   _zz_428;
  wire       [0:0]    _zz_429;
  wire       [10:0]   _zz_430;
  wire       [0:0]    _zz_431;
  wire       [10:0]   _zz_432;
  wire       [3:0]    _zz_433;
  wire       [13:0]   _zz_434;
  wire       [3:0]    _zz_435;
  wire       [0:0]    _zz_436;
  wire       [10:0]   _zz_437;
  wire       [2:0]    _zz_438;
  wire       [2:0]    _zz_439;
  wire       [2:0]    _zz_440;
  wire       [2:0]    _zz_441;
  wire       [1:0]    _zz_442;
  wire       [1:0]    _zz_443;
  wire       [1:0]    _zz_444;
  wire       [1:0]    _zz_445;
  wire       [1:0]    _zz_446;
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
  reg                 channels_0_selfRestart;
  reg                 channels_0_readyToStop;
  reg        [26:0]   channels_0_bytesProbe_value;
  reg                 channels_0_bytesProbe_incr_valid;
  reg        [10:0]   channels_0_bytesProbe_incr_payload;
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
  wire       [10:0]   channels_0_fifo_base;
  wire       [10:0]   channels_0_fifo_words;
  reg        [10:0]   channels_0_fifo_push_available;
  wire       [10:0]   channels_0_fifo_push_availableDecr;
  reg        [10:0]   channels_0_fifo_push_ptr;
  wire       [10:0]   channels_0_fifo_push_ptrWithBase;
  wire       [10:0]   channels_0_fifo_push_ptrIncr_value;
  reg        [10:0]   channels_0_fifo_pop_ptr;
  wire       [13:0]   channels_0_fifo_pop_bytes;
  wire       [10:0]   channels_0_fifo_pop_ptrWithBase;
  wire       [13:0]   channels_0_fifo_pop_bytesIncr_value;
  wire       [13:0]   channels_0_fifo_pop_bytesDecr_value;
  wire                channels_0_fifo_pop_empty;
  wire       [10:0]   channels_0_fifo_pop_ptrIncr_value;
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
  wire       [10:0]   channels_0_pop_b2m_bytePerBurst;
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
  reg        [2:0]    channels_0_pop_b2m_bytesToSkip;
  reg        [13:0]   channels_0_pop_b2m_decrBytes;
  wire                channels_0_readyForChannelCompletion;
  reg                 _zz_1;
  wire                channels_0_s2b_full;
  reg        [10:0]   channels_0_fifo_pop_ptrIncr_value_regNext;
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
  wire       [10:0]   channels_1_fifo_base;
  wire       [10:0]   channels_1_fifo_words;
  reg        [10:0]   channels_1_fifo_push_available;
  reg        [10:0]   channels_1_fifo_push_availableDecr;
  reg        [10:0]   channels_1_fifo_push_ptr;
  wire       [10:0]   channels_1_fifo_push_ptrWithBase;
  wire       [10:0]   channels_1_fifo_push_ptrIncr_value;
  reg        [10:0]   channels_1_fifo_pop_ptr;
  wire       [13:0]   channels_1_fifo_pop_bytes;
  wire       [10:0]   channels_1_fifo_pop_ptrWithBase;
  wire       [13:0]   channels_1_fifo_pop_bytesIncr_value;
  wire       [13:0]   channels_1_fifo_pop_bytesDecr_value;
  wire                channels_1_fifo_pop_empty;
  wire       [10:0]   channels_1_fifo_pop_ptrIncr_value;
  reg        [13:0]   channels_1_fifo_pop_withoutOverride_exposed;
  wire                channels_1_fifo_empty;
  reg                 channels_1_push_memory;
  reg        [31:0]   channels_1_push_m2b_address;
  wire       [10:0]   channels_1_push_m2b_bytePerBurst;
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
  reg        [10:0]   channels_1_pop_b2s_veryLastPtr;
  reg                 channels_1_pop_b2s_veryLastEndPacket;
  reg                 channels_1_readyForChannelCompletion;
  reg                 _zz_2;
  wire                channels_1_s2b_full;
  reg        [10:0]   channels_1_fifo_pop_ptrIncr_value_regNext;
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
  reg                 channels_2_selfRestart;
  reg                 channels_2_readyToStop;
  reg        [26:0]   channels_2_bytesProbe_value;
  reg                 channels_2_bytesProbe_incr_valid;
  reg        [10:0]   channels_2_bytesProbe_incr_payload;
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
  wire       [10:0]   channels_2_fifo_base;
  wire       [10:0]   channels_2_fifo_words;
  reg        [10:0]   channels_2_fifo_push_available;
  wire       [10:0]   channels_2_fifo_push_availableDecr;
  reg        [10:0]   channels_2_fifo_push_ptr;
  wire       [10:0]   channels_2_fifo_push_ptrWithBase;
  wire       [10:0]   channels_2_fifo_push_ptrIncr_value;
  reg        [10:0]   channels_2_fifo_pop_ptr;
  wire       [13:0]   channels_2_fifo_pop_bytes;
  wire       [10:0]   channels_2_fifo_pop_ptrWithBase;
  wire       [13:0]   channels_2_fifo_pop_bytesIncr_value;
  wire       [13:0]   channels_2_fifo_pop_bytesDecr_value;
  wire                channels_2_fifo_pop_empty;
  wire       [10:0]   channels_2_fifo_pop_ptrIncr_value;
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
  wire       [10:0]   channels_2_pop_b2m_bytePerBurst;
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
  reg        [2:0]    channels_2_pop_b2m_bytesToSkip;
  reg        [13:0]   channels_2_pop_b2m_decrBytes;
  wire                channels_2_readyForChannelCompletion;
  reg                 _zz_3;
  wire                channels_2_s2b_full;
  reg        [10:0]   channels_2_fifo_pop_ptrIncr_value_regNext;
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
  wire       [10:0]   channels_3_fifo_base;
  wire       [10:0]   channels_3_fifo_words;
  reg        [10:0]   channels_3_fifo_push_available;
  reg        [10:0]   channels_3_fifo_push_availableDecr;
  reg        [10:0]   channels_3_fifo_push_ptr;
  wire       [10:0]   channels_3_fifo_push_ptrWithBase;
  wire       [10:0]   channels_3_fifo_push_ptrIncr_value;
  reg        [10:0]   channels_3_fifo_pop_ptr;
  wire       [13:0]   channels_3_fifo_pop_bytes;
  wire       [10:0]   channels_3_fifo_pop_ptrWithBase;
  wire       [13:0]   channels_3_fifo_pop_bytesIncr_value;
  wire       [13:0]   channels_3_fifo_pop_bytesDecr_value;
  wire                channels_3_fifo_pop_empty;
  wire       [10:0]   channels_3_fifo_pop_ptrIncr_value;
  reg        [13:0]   channels_3_fifo_pop_withoutOverride_exposed;
  wire                channels_3_fifo_empty;
  reg                 channels_3_push_memory;
  reg        [31:0]   channels_3_push_m2b_address;
  wire       [10:0]   channels_3_push_m2b_bytePerBurst;
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
  reg        [10:0]   channels_3_pop_b2s_veryLastPtr;
  reg                 channels_3_pop_b2s_veryLastEndPacket;
  reg                 channels_3_readyForChannelCompletion;
  reg                 _zz_4;
  wire                channels_3_s2b_full;
  reg        [10:0]   channels_3_fifo_pop_ptrIncr_value_regNext;
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
  wire       [63:0]   io_inputs_0_thrown_payload_data;
  wire       [7:0]    io_inputs_0_thrown_payload_mask;
  wire       [3:0]    io_inputs_0_thrown_payload_sink;
  wire                io_inputs_0_thrown_payload_last;
  wire                _zz_5;
  wire                s2b_0_cmd_sinkHalted_valid;
  wire                s2b_0_cmd_sinkHalted_ready;
  wire       [63:0]   s2b_0_cmd_sinkHalted_payload_data;
  wire       [7:0]    s2b_0_cmd_sinkHalted_payload_mask;
  wire       [3:0]    s2b_0_cmd_sinkHalted_payload_sink;
  wire                s2b_0_cmd_sinkHalted_payload_last;
  wire       [3:0]    _zz_6;
  wire       [3:0]    _zz_7;
  wire       [3:0]    _zz_8;
  wire       [3:0]    _zz_9;
  wire       [3:0]    _zz_10;
  wire       [3:0]    _zz_11;
  wire       [3:0]    _zz_12;
  wire       [3:0]    _zz_13;
  wire       [3:0]    s2b_0_cmd_byteCount;
  wire       [0:0]    s2b_0_cmd_context_channel;
  wire       [3:0]    s2b_0_cmd_context_bytes;
  wire                s2b_0_cmd_context_flush;
  wire                s2b_0_cmd_context_packet;
  wire                _zz_14;
  wire       [0:0]    s2b_0_rsp_context_channel;
  wire       [3:0]    s2b_0_rsp_context_bytes;
  wire                s2b_0_rsp_context_flush;
  wire                s2b_0_rsp_context_packet;
  wire       [6:0]    _zz_15;
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
  wire       [63:0]   io_inputs_1_thrown_payload_data;
  wire       [7:0]    io_inputs_1_thrown_payload_mask;
  wire       [3:0]    io_inputs_1_thrown_payload_sink;
  wire                io_inputs_1_thrown_payload_last;
  wire                _zz_17;
  wire                s2b_1_cmd_sinkHalted_valid;
  wire                s2b_1_cmd_sinkHalted_ready;
  wire       [63:0]   s2b_1_cmd_sinkHalted_payload_data;
  wire       [7:0]    s2b_1_cmd_sinkHalted_payload_mask;
  wire       [3:0]    s2b_1_cmd_sinkHalted_payload_sink;
  wire                s2b_1_cmd_sinkHalted_payload_last;
  wire       [3:0]    _zz_18;
  wire       [3:0]    _zz_19;
  wire       [3:0]    _zz_20;
  wire       [3:0]    _zz_21;
  wire       [3:0]    _zz_22;
  wire       [3:0]    _zz_23;
  wire       [3:0]    _zz_24;
  wire       [3:0]    _zz_25;
  wire       [3:0]    s2b_1_cmd_byteCount;
  wire       [0:0]    s2b_1_cmd_context_channel;
  wire       [3:0]    s2b_1_cmd_context_bytes;
  wire                s2b_1_cmd_context_flush;
  wire                s2b_1_cmd_context_packet;
  wire                _zz_26;
  wire       [0:0]    s2b_1_rsp_context_channel;
  wire       [3:0]    s2b_1_rsp_context_bytes;
  wire                s2b_1_rsp_context_flush;
  wire                s2b_1_rsp_context_packet;
  wire       [6:0]    _zz_27;
  wire                _zz_28;
  wire       [0:0]    b2s_0_cmd_channelsOh;
  wire       [0:0]    b2s_0_cmd_context_channel;
  wire                b2s_0_cmd_context_veryLast;
  wire                b2s_0_cmd_context_endPacket;
  wire       [10:0]   b2s_0_cmd_veryLastPtr;
  wire       [10:0]   b2s_0_cmd_address;
  wire       [0:0]    b2s_0_rsp_context_channel;
  wire                b2s_0_rsp_context_veryLast;
  wire                b2s_0_rsp_context_endPacket;
  wire       [2:0]    _zz_29;
  wire       [0:0]    b2s_1_cmd_channelsOh;
  wire       [0:0]    b2s_1_cmd_context_channel;
  wire                b2s_1_cmd_context_veryLast;
  wire                b2s_1_cmd_context_endPacket;
  wire       [10:0]   b2s_1_cmd_veryLastPtr;
  wire       [10:0]   b2s_1_cmd_address;
  wire       [0:0]    b2s_1_rsp_context_channel;
  wire                b2s_1_rsp_context_veryLast;
  wire                b2s_1_rsp_context_endPacket;
  wire       [2:0]    _zz_30;
  reg                 m2b_cmd_s0_valid;
  reg        [0:0]    m2b_cmd_s0_chosen;
  wire       [1:0]    _zz_31;
  wire       [31:0]   m2b_cmd_s0_address;
  wire       [25:0]   m2b_cmd_s0_bytesLeft;
  wire       [10:0]   m2b_cmd_s0_readAddressBurstRange;
  wire       [10:0]   m2b_cmd_s0_lengthHead;
  wire       [10:0]   m2b_cmd_s0_length;
  wire                m2b_cmd_s0_lastBurst;
  reg                 m2b_cmd_s1_valid;
  reg        [31:0]   m2b_cmd_s1_address;
  reg        [10:0]   m2b_cmd_s1_length;
  reg                 m2b_cmd_s1_lastBurst;
  reg        [25:0]   m2b_cmd_s1_bytesLeft;
  wire       [0:0]    m2b_cmd_s1_context_channel;
  wire       [2:0]    m2b_cmd_s1_context_start;
  wire       [2:0]    m2b_cmd_s1_context_stop;
  wire       [10:0]   m2b_cmd_s1_context_length;
  wire                m2b_cmd_s1_context_last;
  wire       [31:0]   m2b_cmd_s1_addressNext;
  wire       [25:0]   m2b_cmd_s1_byteLeftNext;
  wire       [8:0]    m2b_cmd_s1_fifoPushDecr;
  wire       [0:0]    m2b_rsp_context_channel;
  wire       [2:0]    m2b_rsp_context_start;
  wire       [2:0]    m2b_rsp_context_stop;
  wire       [10:0]   m2b_rsp_context_length;
  wire                m2b_rsp_context_last;
  wire       [18:0]   _zz_32;
  wire                m2b_rsp_veryLast;
  reg                 m2b_rsp_first;
  wire                m2b_rsp_writeContext_last;
  wire                m2b_rsp_writeContext_lastOfBurst;
  wire       [0:0]    m2b_rsp_writeContext_channel;
  wire       [3:0]    m2b_rsp_writeContext_loadByteInNextBeat;
  wire                m2b_writeRsp_context_last;
  wire                m2b_writeRsp_context_lastOfBurst;
  wire       [0:0]    m2b_writeRsp_context_channel;
  wire       [3:0]    m2b_writeRsp_context_loadByteInNextBeat;
  wire       [6:0]    _zz_33;
  wire                _zz_34;
  wire                _zz_35;
  reg                 b2m_fsm_sel_valid;
  reg                 b2m_fsm_sel_ready;
  reg        [0:0]    b2m_fsm_sel_channel;
  reg        [10:0]   b2m_fsm_sel_bytePerBurst;
  reg        [10:0]   b2m_fsm_sel_bytesInBurst;
  reg        [13:0]   b2m_fsm_sel_bytesInFifo;
  reg        [31:0]   b2m_fsm_sel_address;
  reg        [10:0]   b2m_fsm_sel_ptr;
  reg        [10:0]   b2m_fsm_sel_ptrMask;
  reg                 b2m_fsm_sel_flush;
  reg                 b2m_fsm_sel_packet;
  reg        [25:0]   b2m_fsm_sel_bytesLeft;
  wire       [1:0]    _zz_36;
  wire       [10:0]   b2m_fsm_bytesInBurstP1;
  wire       [31:0]   b2m_fsm_addressNext;
  wire       [26:0]   b2m_fsm_bytesLeftNext;
  wire                b2m_fsm_isFinalCmd;
  reg        [7:0]    b2m_fsm_beatCounter;
  reg                 b2m_fsm_sel_valid_regNext;
  wire                b2m_fsm_s0;
  reg                 b2m_fsm_s1;
  reg                 b2m_fsm_s2;
  wire       [13:0]   _zz_37;
  wire       [25:0]   _zz_38;
  wire       [10:0]   _zz_39;
  wire                b2m_fsm_fifoCompletion;
  reg                 b2m_fsm_toggle;
  wire       [10:0]   b2m_fsm_fetch_context_ptr;
  wire                b2m_fsm_fetch_context_toggle;
  wire       [10:0]   b2m_fsm_aggregate_context_ptr;
  wire                b2m_fsm_aggregate_context_toggle;
  wire       [11:0]   _zz_40;
  wire                memory_core_io_reads_2_rsp_s2mPipe_valid;
  reg                 memory_core_io_reads_2_rsp_s2mPipe_ready;
  wire       [63:0]   memory_core_io_reads_2_rsp_s2mPipe_payload_data;
  wire       [7:0]    memory_core_io_reads_2_rsp_s2mPipe_payload_mask;
  wire       [11:0]   memory_core_io_reads_2_rsp_s2mPipe_payload_context;
  reg                 memory_core_io_reads_2_rsp_s2mPipe_rValid;
  reg        [63:0]   memory_core_io_reads_2_rsp_s2mPipe_rData_data;
  reg        [7:0]    memory_core_io_reads_2_rsp_s2mPipe_rData_mask;
  reg        [11:0]   memory_core_io_reads_2_rsp_s2mPipe_rData_context;
  reg                 b2m_fsm_aggregate_memoryPort_valid;
  wire                b2m_fsm_aggregate_memoryPort_ready;
  wire       [63:0]   b2m_fsm_aggregate_memoryPort_payload_data;
  wire       [7:0]    b2m_fsm_aggregate_memoryPort_payload_mask;
  wire       [11:0]   b2m_fsm_aggregate_memoryPort_payload_context;
  reg                 b2m_fsm_aggregate_first;
  wire       [2:0]    b2m_fsm_aggregate_bytesToSkip;
  reg        [7:0]    b2m_fsm_aggregate_bytesToSkipMask;
  reg                 _zz_41;
  wire       [2:0]    b2m_fsm_cmd_maskFirstTrigger;
  wire       [2:0]    b2m_fsm_cmd_maskLastTriggerComb;
  reg        [2:0]    b2m_fsm_cmd_maskLastTriggerReg;
  reg        [7:0]    _zz_42;
  reg        [7:0]    b2m_fsm_cmd_maskLast;
  reg        [7:0]    b2m_fsm_cmd_maskFirst;
  wire                b2m_fsm_cmd_enoughAggregation;
  reg                 io_write_cmd_payload_first;
  wire                b2m_fsm_cmd_doPtrIncr;
  wire       [0:0]    b2m_fsm_cmd_context_channel;
  wire       [10:0]   b2m_fsm_cmd_context_length;
  wire                b2m_fsm_cmd_context_doPacketSync;
  wire       [1:0]    _zz_43;
  wire       [2:0]    _zz_44;
  wire       [0:0]    b2m_rsp_context_channel;
  wire       [10:0]   b2m_rsp_context_length;
  wire                b2m_rsp_context_doPacketSync;
  wire       [12:0]   _zz_45;
  wire       [1:0]    _zz_46;
  wire       [3:0]    _zz_47;
  wire       [3:0]    _zz_48;
  wire                _zz_49;
  wire                _zz_50;
  wire                _zz_51;
  reg        [3:0]    _zz_52;
  wire                _zz_53;
  wire                _zz_54;
  wire                _zz_55;
  wire                ll_arbiter_head;
  reg        [3:0]    _zz_56;
  wire                _zz_57;
  wire                _zz_58;
  wire                _zz_59;
  wire                ll_arbiter_isJustASink;
  reg                 ll_cmd_valid;
  reg                 ll_cmd_oh_0;
  reg                 ll_cmd_oh_1;
  reg                 ll_cmd_oh_2;
  reg                 ll_cmd_oh_3;
  reg        [3:0]    _zz_60;
  wire                _zz_61;
  wire                _zz_62;
  wire                _zz_63;
  reg        [31:0]   ll_cmd_ptr;
  reg        [3:0]    _zz_64;
  wire                _zz_65;
  wire                _zz_66;
  wire                _zz_67;
  reg        [31:0]   ll_cmd_ptrNext;
  reg        [1:0]    _zz_68;
  reg        [26:0]   ll_cmd_bytesDone;
  reg        [3:0]    _zz_69;
  wire                _zz_70;
  wire                _zz_71;
  wire                _zz_72;
  reg                 ll_cmd_endOfPacket;
  reg                 ll_cmd_isJustASink;
  reg                 ll_cmd_readFired;
  reg                 ll_cmd_writeFired;
  wire       [1:0]    ll_cmd_context_channel;
  wire                _zz_73;
  wire                _zz_74;
  wire       [3:0]    ll_cmd_writeMaskSplit_0;
  wire       [3:0]    ll_cmd_writeMaskSplit_1;
  wire       [31:0]   ll_cmd_writeDataSplit_0;
  wire       [31:0]   ll_cmd_writeDataSplit_1;
  wire       [1:0]    ll_readRsp_context_channel;
  reg        [3:0]    _zz_75;
  wire                ll_readRsp_oh_0;
  wire                ll_readRsp_oh_1;
  wire                ll_readRsp_oh_2;
  wire                ll_readRsp_oh_3;
  reg        [1:0]    ll_readRsp_beatCounter;
  reg                 ll_readRsp_completed;
  wire       [1:0]    ll_writeRsp_context_channel;
  reg        [3:0]    _zz_76;
  wire                ll_writeRsp_oh_0;
  wire                ll_writeRsp_oh_1;
  wire                ll_writeRsp_oh_2;
  wire                ll_writeRsp_oh_3;
  reg                 _zz_77;
  reg                 _zz_78;
  reg                 _zz_79;
  reg                 _zz_80;
  reg                 _zz_81;
  reg                 _zz_82;
  reg                 _zz_83;
  reg                 _zz_84;
  reg                 _zz_85;
  reg                 _zz_86;
  reg                 _zz_87;
  reg                 _zz_88;
  reg                 _zz_89;
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
  function [7:0] zz_io_sgWrite_cmd_payload_fragment_mask(input dummy);
    begin
      zz_io_sgWrite_cmd_payload_fragment_mask[7 : 4] = 4'b0000;
      zz_io_sgWrite_cmd_payload_fragment_mask[3 : 0] = 4'b1111;
    end
  endfunction
  wire [7:0] _zz_447;

  assign io_0_descriptorUpdate = channels_0_ll_descriptorUpdated & !channels_0_ll_gotDescriptorStall;
  assign io_1_descriptorUpdate = channels_1_ll_descriptorUpdated & !channels_1_ll_gotDescriptorStall;
  assign io_2_descriptorUpdate = channels_2_ll_descriptorUpdated & !channels_2_ll_gotDescriptorStall;
  assign io_3_descriptorUpdate = channels_3_ll_descriptorUpdated & !channels_3_ll_gotDescriptorStall;
  assign _zz_154 = (((channels_0_ll_valid && channels_0_ll_waitDone) && channels_0_ll_writeDone) && channels_0_ll_readDone);
  assign _zz_155 = (! channels_0_ll_justASync);
  assign _zz_156 = (! channels_0_ll_gotDescriptorStall);
  assign _zz_157 = (! channels_0_descriptorValid);
  assign _zz_158 = (channels_0_selfRestart && (! channels_0_ctrl_kick));
  assign _zz_159 = (channels_0_descriptorValid && (! channels_0_push_memory));
  assign _zz_160 = (io_write_rsp_valid && io_write_rsp_ready);
  assign _zz_161 = (b2m_rsp_context_channel == 1'b0);
  assign _zz_162 = ((! b2m_fsm_sel_valid) && b2m_fsm_arbiter_core_io_output_valid);
  assign _zz_163 = ((channels_0_pop_b2m_memPending == 4'b0000) && (channels_0_fifo_pop_bytes == 14'h0));
  assign _zz_164 = (b2m_fsm_sel_channel == 1'b0);
  assign _zz_165 = (((channels_1_ll_valid && channels_1_ll_waitDone) && channels_1_ll_writeDone) && channels_1_ll_readDone);
  assign _zz_166 = (! channels_1_ll_justASync);
  assign _zz_167 = (! channels_1_ll_gotDescriptorStall);
  assign _zz_168 = (! channels_1_descriptorValid);
  assign _zz_169 = (channels_1_selfRestart && (! channels_1_ctrl_kick));
  assign _zz_170 = (1'b0 == m2b_cmd_s0_chosen);
  assign _zz_171 = (! m2b_cmd_s0_valid);
  assign _zz_172 = ({channels_3_push_m2b_loadRequest,channels_1_push_m2b_loadRequest} != 2'b00);
  assign _zz_173 = ((io_read_rsp_valid && io_read_rsp_ready) && m2b_rsp_veryLast);
  assign _zz_174 = (((channels_2_ll_valid && channels_2_ll_waitDone) && channels_2_ll_writeDone) && channels_2_ll_readDone);
  assign _zz_175 = (! channels_2_ll_justASync);
  assign _zz_176 = (! channels_2_ll_gotDescriptorStall);
  assign _zz_177 = (! channels_2_descriptorValid);
  assign _zz_178 = (channels_2_selfRestart && (! channels_2_ctrl_kick));
  assign _zz_179 = (channels_2_descriptorValid && (! channels_2_push_memory));
  assign _zz_180 = (b2m_rsp_context_channel == 1'b1);
  assign _zz_181 = ((channels_2_pop_b2m_memPending == 4'b0000) && (channels_2_fifo_pop_bytes == 14'h0));
  assign _zz_182 = (b2m_fsm_sel_channel == 1'b1);
  assign _zz_183 = (((channels_3_ll_valid && channels_3_ll_waitDone) && channels_3_ll_writeDone) && channels_3_ll_readDone);
  assign _zz_184 = (! channels_3_ll_justASync);
  assign _zz_185 = (! channels_3_ll_gotDescriptorStall);
  assign _zz_186 = (! channels_3_descriptorValid);
  assign _zz_187 = (channels_3_selfRestart && (! channels_3_ctrl_kick));
  assign _zz_188 = (1'b1 == m2b_cmd_s0_chosen);
  assign _zz_189 = ((io_write_cmd_valid && io_write_cmd_ready) && io_write_cmd_payload_last);
  assign _zz_190 = (b2m_fsm_aggregate_context_toggle != b2m_fsm_toggle);
  assign _zz_191 = (_zz_122 && (! memory_core_io_reads_2_rsp_s2mPipe_ready));
  assign _zz_192 = (! ll_cmd_valid);
  assign _zz_193 = (io_sgRead_rsp_valid && io_sgRead_rsp_ready);
  assign _zz_194 = (channels_0_bytesProbe_value + _zz_195);
  assign _zz_195 = {16'd0, channels_0_bytesProbe_incr_payload};
  assign _zz_196 = (channels_0_fifo_pop_withOverride_backup + channels_0_fifo_pop_bytesIncr_value);
  assign _zz_197 = (channels_0_fifo_pop_withOverride_exposed - channels_0_fifo_pop_bytesDecr_value);
  assign _zz_198 = {3'd0, channels_0_pop_b2m_bytePerBurst};
  assign _zz_199 = (channels_0_fifo_words >>> 1);
  assign _zz_200 = {1'd0, _zz_199};
  assign _zz_201 = (channels_0_pop_b2m_memPending + _zz_203);
  assign _zz_202 = channels_0_pop_b2m_fire;
  assign _zz_203 = {3'd0, _zz_202};
  assign _zz_204 = channels_0_pop_b2m_memRsp;
  assign _zz_205 = {3'd0, _zz_204};
  assign _zz_206 = {13'd0, channels_0_fifo_pop_bytes};
  assign _zz_207 = (channels_0_pop_b2m_address - _zz_208);
  assign _zz_208 = {6'd0, channels_0_bytes};
  assign _zz_209 = (channels_0_fifo_push_available + channels_0_fifo_pop_ptrIncr_value_regNext);
  assign _zz_210 = (channels_1_fifo_pop_withoutOverride_exposed + channels_1_fifo_pop_bytesIncr_value);
  assign _zz_211 = (channels_1_push_m2b_memPending + _zz_213);
  assign _zz_212 = channels_1_push_m2b_memPendingIncr;
  assign _zz_213 = {3'd0, _zz_212};
  assign _zz_214 = channels_1_push_m2b_memPendingDecr;
  assign _zz_215 = {3'd0, _zz_214};
  assign _zz_216 = (channels_1_push_m2b_bytePerBurst >>> 3);
  assign _zz_217 = {3'd0, _zz_216};
  assign _zz_218 = {15'd0, channels_1_push_m2b_bytePerBurst};
  assign _zz_219 = (channels_1_push_m2b_address - _zz_220);
  assign _zz_220 = {6'd0, channels_1_bytes};
  assign _zz_221 = (channels_1_fifo_push_available + channels_1_fifo_pop_ptrIncr_value_regNext);
  assign _zz_222 = (channels_2_bytesProbe_value + _zz_223);
  assign _zz_223 = {16'd0, channels_2_bytesProbe_incr_payload};
  assign _zz_224 = (channels_2_fifo_pop_withOverride_backup + channels_2_fifo_pop_bytesIncr_value);
  assign _zz_225 = (channels_2_fifo_pop_withOverride_exposed - channels_2_fifo_pop_bytesDecr_value);
  assign _zz_226 = {3'd0, channels_2_pop_b2m_bytePerBurst};
  assign _zz_227 = (channels_2_fifo_words >>> 1);
  assign _zz_228 = {1'd0, _zz_227};
  assign _zz_229 = (channels_2_pop_b2m_memPending + _zz_231);
  assign _zz_230 = channels_2_pop_b2m_fire;
  assign _zz_231 = {3'd0, _zz_230};
  assign _zz_232 = channels_2_pop_b2m_memRsp;
  assign _zz_233 = {3'd0, _zz_232};
  assign _zz_234 = {13'd0, channels_2_fifo_pop_bytes};
  assign _zz_235 = (channels_2_pop_b2m_address - _zz_236);
  assign _zz_236 = {6'd0, channels_2_bytes};
  assign _zz_237 = (channels_2_fifo_push_available + channels_2_fifo_pop_ptrIncr_value_regNext);
  assign _zz_238 = (channels_3_fifo_pop_withoutOverride_exposed + channels_3_fifo_pop_bytesIncr_value);
  assign _zz_239 = (channels_3_push_m2b_memPending + _zz_241);
  assign _zz_240 = channels_3_push_m2b_memPendingIncr;
  assign _zz_241 = {3'd0, _zz_240};
  assign _zz_242 = channels_3_push_m2b_memPendingDecr;
  assign _zz_243 = {3'd0, _zz_242};
  assign _zz_244 = (channels_3_push_m2b_bytePerBurst >>> 3);
  assign _zz_245 = {3'd0, _zz_244};
  assign _zz_246 = {15'd0, channels_3_push_m2b_bytePerBurst};
  assign _zz_247 = (channels_3_push_m2b_address - _zz_248);
  assign _zz_248 = {6'd0, channels_3_bytes};
  assign _zz_249 = (channels_3_fifo_push_available + channels_3_fifo_pop_ptrIncr_value_regNext);
  assign _zz_250 = (_zz_129 + _zz_130);
  assign _zz_251 = {s2b_0_cmd_sinkHalted_payload_mask[7],s2b_0_cmd_sinkHalted_payload_mask[6]};
  assign _zz_252 = {1'd0, _zz_251};
  assign _zz_253 = _zz_15[5 : 5];
  assign _zz_254 = _zz_15[6 : 6];
  assign _zz_255 = (_zz_132 + _zz_133);
  assign _zz_256 = {s2b_1_cmd_sinkHalted_payload_mask[7],s2b_1_cmd_sinkHalted_payload_mask[6]};
  assign _zz_257 = {1'd0, _zz_256};
  assign _zz_258 = _zz_27[5 : 5];
  assign _zz_259 = _zz_27[6 : 6];
  assign _zz_260 = _zz_29[1 : 1];
  assign _zz_261 = _zz_29[2 : 2];
  assign _zz_262 = _zz_30[1 : 1];
  assign _zz_263 = _zz_30[2 : 2];
  assign _zz_264 = ((_zz_265 < m2b_cmd_s0_bytesLeft) ? _zz_266 : m2b_cmd_s0_bytesLeft);
  assign _zz_265 = {15'd0, m2b_cmd_s0_lengthHead};
  assign _zz_266 = {15'd0, m2b_cmd_s0_lengthHead};
  assign _zz_267 = {15'd0, m2b_cmd_s0_length};
  assign _zz_268 = (m2b_cmd_s1_address + _zz_269);
  assign _zz_269 = {21'd0, m2b_cmd_s1_length};
  assign _zz_270 = (m2b_cmd_s1_address + _zz_271);
  assign _zz_271 = {21'd0, m2b_cmd_s1_length};
  assign _zz_272 = (m2b_cmd_s1_bytesLeft - _zz_273);
  assign _zz_273 = {15'd0, m2b_cmd_s1_length};
  assign _zz_274 = ({1'b0,(_zz_275 | 11'h007)} + _zz_279);
  assign _zz_275 = (_zz_277 + io_read_cmd_payload_fragment_length);
  assign _zz_276 = m2b_cmd_s1_address[2 : 0];
  assign _zz_277 = {8'd0, _zz_276};
  assign _zz_278 = {1'b0,1'b1};
  assign _zz_279 = {10'd0, _zz_278};
  assign _zz_280 = _zz_32[18 : 18];
  assign _zz_281 = _zz_33[0 : 0];
  assign _zz_282 = _zz_33[1 : 1];
  assign _zz_283 = {21'd0, b2m_fsm_bytesInBurstP1};
  assign _zz_284 = {1'b0,b2m_fsm_bytesInBurstP1};
  assign _zz_285 = {15'd0, _zz_284};
  assign _zz_286 = {12'd0, _zz_37};
  assign _zz_287 = {12'd0, _zz_37};
  assign _zz_288 = b2m_fsm_sel_address[10:0];
  assign _zz_289 = ((_zz_38 < _zz_290) ? _zz_38 : _zz_291);
  assign _zz_290 = {15'd0, _zz_39};
  assign _zz_291 = {15'd0, _zz_39};
  assign _zz_292 = {3'd0, b2m_fsm_sel_bytesInBurst};
  assign _zz_293 = (b2m_fsm_sel_bytesInFifo - 14'h0001);
  assign _zz_294 = (_zz_296 + b2m_fsm_sel_bytesInBurst);
  assign _zz_295 = b2m_fsm_sel_address[2 : 0];
  assign _zz_296 = {8'd0, _zz_295};
  assign _zz_297 = (b2m_fsm_sel_ptr + 11'h001);
  assign _zz_298 = _zz_40[11 : 11];
  assign _zz_299 = b2m_fsm_sel_bytesInBurst[2:0];
  assign _zz_300 = _zz_45[12 : 12];
  assign _zz_301 = (_zz_47 - 4'b0001);
  assign _zz_302 = io_sgRead_rsp_payload_fragment_data[62 : 62];
  assign _zz_303 = io_sgRead_rsp_payload_fragment_data[62 : 62];
  assign _zz_304 = io_sgRead_rsp_payload_fragment_data[31 : 31];
  assign _zz_305 = io_sgRead_rsp_payload_fragment_data[31 : 31];
  assign _zz_306 = io_sgRead_rsp_payload_fragment_data[31 : 31];
  assign _zz_307 = io_sgRead_rsp_payload_fragment_data[31 : 31];
  assign _zz_308 = io_ctrl_PWDATA[0 : 0];
  assign _zz_309 = 1'b1;
  assign _zz_310 = io_ctrl_PWDATA[0 : 0];
  assign _zz_311 = 1'b1;
  assign _zz_312 = io_ctrl_PWDATA[4 : 4];
  assign _zz_313 = 1'b1;
  assign _zz_314 = io_ctrl_PWDATA[4 : 4];
  assign _zz_315 = 1'b1;
  assign _zz_316 = io_ctrl_PWDATA[0 : 0];
  assign _zz_317 = 1'b0;
  assign _zz_318 = io_ctrl_PWDATA[2 : 2];
  assign _zz_319 = 1'b0;
  assign _zz_320 = io_ctrl_PWDATA[3 : 3];
  assign _zz_321 = 1'b0;
  assign _zz_322 = io_ctrl_PWDATA[4 : 4];
  assign _zz_323 = 1'b0;
  assign _zz_324 = io_ctrl_PWDATA[0 : 0];
  assign _zz_325 = 1'b1;
  assign _zz_326 = io_ctrl_PWDATA[0 : 0];
  assign _zz_327 = 1'b1;
  assign _zz_328 = io_ctrl_PWDATA[4 : 4];
  assign _zz_329 = 1'b1;
  assign _zz_330 = io_ctrl_PWDATA[4 : 4];
  assign _zz_331 = 1'b1;
  assign _zz_332 = io_ctrl_PWDATA[0 : 0];
  assign _zz_333 = 1'b0;
  assign _zz_334 = io_ctrl_PWDATA[2 : 2];
  assign _zz_335 = 1'b0;
  assign _zz_336 = io_ctrl_PWDATA[3 : 3];
  assign _zz_337 = 1'b0;
  assign _zz_338 = io_ctrl_PWDATA[0 : 0];
  assign _zz_339 = 1'b1;
  assign _zz_340 = io_ctrl_PWDATA[0 : 0];
  assign _zz_341 = 1'b1;
  assign _zz_342 = io_ctrl_PWDATA[4 : 4];
  assign _zz_343 = 1'b1;
  assign _zz_344 = io_ctrl_PWDATA[4 : 4];
  assign _zz_345 = 1'b1;
  assign _zz_346 = io_ctrl_PWDATA[0 : 0];
  assign _zz_347 = 1'b0;
  assign _zz_348 = io_ctrl_PWDATA[2 : 2];
  assign _zz_349 = 1'b0;
  assign _zz_350 = io_ctrl_PWDATA[3 : 3];
  assign _zz_351 = 1'b0;
  assign _zz_352 = io_ctrl_PWDATA[4 : 4];
  assign _zz_353 = 1'b0;
  assign _zz_354 = io_ctrl_PWDATA[0 : 0];
  assign _zz_355 = 1'b1;
  assign _zz_356 = io_ctrl_PWDATA[0 : 0];
  assign _zz_357 = 1'b1;
  assign _zz_358 = io_ctrl_PWDATA[4 : 4];
  assign _zz_359 = 1'b1;
  assign _zz_360 = io_ctrl_PWDATA[4 : 4];
  assign _zz_361 = 1'b1;
  assign _zz_362 = io_ctrl_PWDATA[0 : 0];
  assign _zz_363 = 1'b0;
  assign _zz_364 = io_ctrl_PWDATA[2 : 2];
  assign _zz_365 = 1'b0;
  assign _zz_366 = io_ctrl_PWDATA[3 : 3];
  assign _zz_367 = 1'b0;
  assign _zz_368 = io_ctrl_PWDATA[12 : 12];
  assign _zz_369 = io_ctrl_PWDATA[13 : 13];
  assign _zz_370 = io_ctrl_PWDATA[14 : 14];
  assign _zz_371 = io_ctrl_PWDATA[31 : 0];
  assign _zz_372 = _zz_371;
  assign _zz_373 = io_ctrl_PWDATA[12 : 12];
  assign _zz_374 = io_ctrl_PWDATA[2 : 2];
  assign _zz_375 = io_ctrl_PWDATA[1 : 1];
  assign _zz_376 = io_ctrl_PWDATA[0 : 0];
  assign _zz_377 = io_ctrl_PWDATA[2 : 2];
  assign _zz_378 = io_ctrl_PWDATA[3 : 3];
  assign _zz_379 = io_ctrl_PWDATA[4 : 4];
  assign _zz_380 = io_ctrl_PWDATA[31 : 0];
  assign _zz_381 = _zz_380;
  assign _zz_382 = io_ctrl_PWDATA[12 : 12];
  assign _zz_383 = io_ctrl_PWDATA[12 : 12];
  assign _zz_384 = io_ctrl_PWDATA[13 : 13];
  assign _zz_385 = io_ctrl_PWDATA[2 : 2];
  assign _zz_386 = io_ctrl_PWDATA[1 : 1];
  assign _zz_387 = io_ctrl_PWDATA[0 : 0];
  assign _zz_388 = io_ctrl_PWDATA[2 : 2];
  assign _zz_389 = io_ctrl_PWDATA[3 : 3];
  assign _zz_390 = io_ctrl_PWDATA[12 : 12];
  assign _zz_391 = io_ctrl_PWDATA[13 : 13];
  assign _zz_392 = io_ctrl_PWDATA[14 : 14];
  assign _zz_393 = io_ctrl_PWDATA[31 : 0];
  assign _zz_394 = _zz_393;
  assign _zz_395 = io_ctrl_PWDATA[12 : 12];
  assign _zz_396 = io_ctrl_PWDATA[2 : 2];
  assign _zz_397 = io_ctrl_PWDATA[1 : 1];
  assign _zz_398 = io_ctrl_PWDATA[0 : 0];
  assign _zz_399 = io_ctrl_PWDATA[2 : 2];
  assign _zz_400 = io_ctrl_PWDATA[3 : 3];
  assign _zz_401 = io_ctrl_PWDATA[4 : 4];
  assign _zz_402 = io_ctrl_PWDATA[31 : 0];
  assign _zz_403 = _zz_402;
  assign _zz_404 = io_ctrl_PWDATA[12 : 12];
  assign _zz_405 = io_ctrl_PWDATA[12 : 12];
  assign _zz_406 = io_ctrl_PWDATA[13 : 13];
  assign _zz_407 = io_ctrl_PWDATA[2 : 2];
  assign _zz_408 = io_ctrl_PWDATA[1 : 1];
  assign _zz_409 = io_ctrl_PWDATA[0 : 0];
  assign _zz_410 = io_ctrl_PWDATA[2 : 2];
  assign _zz_411 = io_ctrl_PWDATA[3 : 3];
  assign _zz_412 = ((_zz_14 && (s2b_0_cmd_sinkHalted_payload_mask != 8'h0)) ? 1'b1 : 1'b0);
  assign _zz_413 = {10'd0, _zz_412};
  assign _zz_414 = (_zz_16 ? s2b_0_rsp_context_bytes : 4'b0000);
  assign _zz_415 = {10'd0, _zz_414};
  assign _zz_416 = ((b2m_fsm_cmd_doPtrIncr && (b2m_fsm_sel_channel == 1'b0)) ? 1'b1 : 1'b0);
  assign _zz_417 = {10'd0, _zz_416};
  assign _zz_418 = (((io_read_rsp_valid && memory_core_io_writes_2_cmd_ready) && (m2b_rsp_context_channel == 1'b0)) ? 1'b1 : 1'b0);
  assign _zz_419 = {10'd0, _zz_418};
  assign _zz_420 = (_zz_34 ? _zz_422 : 4'b0000);
  assign _zz_421 = {10'd0, _zz_420};
  assign _zz_422 = (m2b_writeRsp_context_loadByteInNextBeat + 4'b0001);
  assign _zz_423 = ((b2s_0_cmd_channelsOh[0] && memory_core_io_reads_0_cmd_ready) ? 1'b1 : 1'b0);
  assign _zz_424 = {10'd0, _zz_423};
  assign _zz_425 = ((_zz_26 && (s2b_1_cmd_sinkHalted_payload_mask != 8'h0)) ? 1'b1 : 1'b0);
  assign _zz_426 = {10'd0, _zz_425};
  assign _zz_427 = (_zz_28 ? s2b_1_rsp_context_bytes : 4'b0000);
  assign _zz_428 = {10'd0, _zz_427};
  assign _zz_429 = ((b2m_fsm_cmd_doPtrIncr && (b2m_fsm_sel_channel == 1'b1)) ? 1'b1 : 1'b0);
  assign _zz_430 = {10'd0, _zz_429};
  assign _zz_431 = (((io_read_rsp_valid && memory_core_io_writes_2_cmd_ready) && (m2b_rsp_context_channel == 1'b1)) ? 1'b1 : 1'b0);
  assign _zz_432 = {10'd0, _zz_431};
  assign _zz_433 = (_zz_35 ? _zz_435 : 4'b0000);
  assign _zz_434 = {10'd0, _zz_433};
  assign _zz_435 = (m2b_writeRsp_context_loadByteInNextBeat + 4'b0001);
  assign _zz_436 = ((b2s_1_cmd_channelsOh[0] && memory_core_io_reads_1_cmd_ready) ? 1'b1 : 1'b0);
  assign _zz_437 = {10'd0, _zz_436};
  assign _zz_438 = {s2b_0_cmd_sinkHalted_payload_mask[2],{s2b_0_cmd_sinkHalted_payload_mask[1],s2b_0_cmd_sinkHalted_payload_mask[0]}};
  assign _zz_439 = {s2b_0_cmd_sinkHalted_payload_mask[5],{s2b_0_cmd_sinkHalted_payload_mask[4],s2b_0_cmd_sinkHalted_payload_mask[3]}};
  assign _zz_440 = {s2b_1_cmd_sinkHalted_payload_mask[2],{s2b_1_cmd_sinkHalted_payload_mask[1],s2b_1_cmd_sinkHalted_payload_mask[0]}};
  assign _zz_441 = {s2b_1_cmd_sinkHalted_payload_mask[5],{s2b_1_cmd_sinkHalted_payload_mask[4],s2b_1_cmd_sinkHalted_payload_mask[3]}};
  assign _zz_442 = {_zz_55,_zz_54};
  assign _zz_443 = {_zz_59,_zz_58};
  assign _zz_444 = {_zz_63,_zz_62};
  assign _zz_445 = {_zz_67,_zz_66};
  assign _zz_446 = {_zz_72,_zz_71};
  dma_socRuby_DmaMemoryCore memory_core (
    .io_writes_0_cmd_valid               (s2b_0_cmd_sinkHalted_valid                        ), //i
    .io_writes_0_cmd_ready               (memory_core_io_writes_0_cmd_ready                 ), //o
    .io_writes_0_cmd_payload_address     (_zz_107[9:0]                                      ), //i
    .io_writes_0_cmd_payload_data        (s2b_0_cmd_sinkHalted_payload_data[63:0]           ), //i
    .io_writes_0_cmd_payload_mask        (s2b_0_cmd_sinkHalted_payload_mask[7:0]            ), //i
    .io_writes_0_cmd_payload_priority    (channels_0_priority[1:0]                          ), //i
    .io_writes_0_cmd_payload_context     (_zz_108[6:0]                                      ), //i
    .io_writes_0_rsp_valid               (memory_core_io_writes_0_rsp_valid                 ), //o
    .io_writes_0_rsp_payload_context     (memory_core_io_writes_0_rsp_payload_context[6:0]  ), //o
    .io_writes_1_cmd_valid               (s2b_1_cmd_sinkHalted_valid                        ), //i
    .io_writes_1_cmd_ready               (memory_core_io_writes_1_cmd_ready                 ), //o
    .io_writes_1_cmd_payload_address     (_zz_109[9:0]                                      ), //i
    .io_writes_1_cmd_payload_data        (s2b_1_cmd_sinkHalted_payload_data[63:0]           ), //i
    .io_writes_1_cmd_payload_mask        (s2b_1_cmd_sinkHalted_payload_mask[7:0]            ), //i
    .io_writes_1_cmd_payload_priority    (channels_2_priority[1:0]                          ), //i
    .io_writes_1_cmd_payload_context     (_zz_110[6:0]                                      ), //i
    .io_writes_1_rsp_valid               (memory_core_io_writes_1_rsp_valid                 ), //o
    .io_writes_1_rsp_payload_context     (memory_core_io_writes_1_rsp_payload_context[6:0]  ), //o
    .io_writes_2_cmd_valid               (io_read_rsp_valid                                 ), //i
    .io_writes_2_cmd_ready               (memory_core_io_writes_2_cmd_ready                 ), //o
    .io_writes_2_cmd_payload_address     (_zz_111[9:0]                                      ), //i
    .io_writes_2_cmd_payload_data        (io_read_rsp_payload_fragment_data[63:0]           ), //i
    .io_writes_2_cmd_payload_mask        (_zz_112[7:0]                                      ), //i
    .io_writes_2_cmd_payload_context     (_zz_113[6:0]                                      ), //i
    .io_writes_2_rsp_valid               (memory_core_io_writes_2_rsp_valid                 ), //o
    .io_writes_2_rsp_payload_context     (memory_core_io_writes_2_rsp_payload_context[6:0]  ), //o
    .io_reads_0_cmd_valid                (_zz_114                                           ), //i
    .io_reads_0_cmd_ready                (memory_core_io_reads_0_cmd_ready                  ), //o
    .io_reads_0_cmd_payload_address      (_zz_115[9:0]                                      ), //i
    .io_reads_0_cmd_payload_priority     (channels_1_priority[1:0]                          ), //i
    .io_reads_0_cmd_payload_context      (_zz_116[2:0]                                      ), //i
    .io_reads_0_rsp_valid                (memory_core_io_reads_0_rsp_valid                  ), //o
    .io_reads_0_rsp_ready                (io_outputs_0_ready                                ), //i
    .io_reads_0_rsp_payload_data         (memory_core_io_reads_0_rsp_payload_data[63:0]     ), //o
    .io_reads_0_rsp_payload_mask         (memory_core_io_reads_0_rsp_payload_mask[7:0]      ), //o
    .io_reads_0_rsp_payload_context      (memory_core_io_reads_0_rsp_payload_context[2:0]   ), //o
    .io_reads_1_cmd_valid                (_zz_117                                           ), //i
    .io_reads_1_cmd_ready                (memory_core_io_reads_1_cmd_ready                  ), //o
    .io_reads_1_cmd_payload_address      (_zz_118[9:0]                                      ), //i
    .io_reads_1_cmd_payload_priority     (channels_3_priority[1:0]                          ), //i
    .io_reads_1_cmd_payload_context      (_zz_119[2:0]                                      ), //i
    .io_reads_1_rsp_valid                (memory_core_io_reads_1_rsp_valid                  ), //o
    .io_reads_1_rsp_ready                (io_outputs_1_ready                                ), //i
    .io_reads_1_rsp_payload_data         (memory_core_io_reads_1_rsp_payload_data[63:0]     ), //o
    .io_reads_1_rsp_payload_mask         (memory_core_io_reads_1_rsp_payload_mask[7:0]      ), //o
    .io_reads_1_rsp_payload_context      (memory_core_io_reads_1_rsp_payload_context[2:0]   ), //o
    .io_reads_2_cmd_valid                (b2m_fsm_sel_valid                                 ), //i
    .io_reads_2_cmd_ready                (memory_core_io_reads_2_cmd_ready                  ), //o
    .io_reads_2_cmd_payload_address      (_zz_120[9:0]                                      ), //i
    .io_reads_2_cmd_payload_context      (_zz_121[11:0]                                     ), //i
    .io_reads_2_rsp_valid                (memory_core_io_reads_2_rsp_valid                  ), //o
    .io_reads_2_rsp_ready                (_zz_122                                           ), //i
    .io_reads_2_rsp_payload_data         (memory_core_io_reads_2_rsp_payload_data[63:0]     ), //o
    .io_reads_2_rsp_payload_mask         (memory_core_io_reads_2_rsp_payload_mask[7:0]      ), //o
    .io_reads_2_rsp_payload_context      (memory_core_io_reads_2_rsp_payload_context[11:0]  ), //o
    .clk                                 (clk                                               ), //i
    .reset                               (reset                                             )  //i
  );
  dma_socRuby_StreamArbiter m2b_cmd_arbiter (
    .io_inputs_0_valid    (channels_1_push_m2b_loadRequest    ), //i
    .io_inputs_0_ready    (m2b_cmd_arbiter_io_inputs_0_ready  ), //o
    .io_inputs_1_valid    (channels_3_push_m2b_loadRequest    ), //i
    .io_inputs_1_ready    (m2b_cmd_arbiter_io_inputs_1_ready  ), //o
    .io_output_valid      (m2b_cmd_arbiter_io_output_valid    ), //o
    .io_output_ready      (_zz_123                            ), //i
    .io_chosen            (m2b_cmd_arbiter_io_chosen          ), //o
    .io_chosenOH          (m2b_cmd_arbiter_io_chosenOH[1:0]   ), //o
    .clk                  (clk                                ), //i
    .reset                (reset                              )  //i
  );
  dma_socRuby_StreamArbiter b2m_fsm_arbiter_core (
    .io_inputs_0_valid    (channels_0_pop_b2m_request              ), //i
    .io_inputs_0_ready    (b2m_fsm_arbiter_core_io_inputs_0_ready  ), //o
    .io_inputs_1_valid    (channels_2_pop_b2m_request              ), //i
    .io_inputs_1_ready    (b2m_fsm_arbiter_core_io_inputs_1_ready  ), //o
    .io_output_valid      (b2m_fsm_arbiter_core_io_output_valid    ), //o
    .io_output_ready      (_zz_124                                 ), //i
    .io_chosen            (b2m_fsm_arbiter_core_io_chosen          ), //o
    .io_chosenOH          (b2m_fsm_arbiter_core_io_chosenOH[1:0]   ), //o
    .clk                  (clk                                     ), //i
    .reset                (reset                                   )  //i
  );
  dma_socRuby_Aggregator b2m_fsm_aggregate_engine (
    .io_input_valid            (b2m_fsm_aggregate_memoryPort_valid                 ), //i
    .io_input_ready            (b2m_fsm_aggregate_engine_io_input_ready            ), //o
    .io_input_payload_data     (b2m_fsm_aggregate_memoryPort_payload_data[63:0]    ), //i
    .io_input_payload_mask     (_zz_125[7:0]                                       ), //i
    .io_output_data            (b2m_fsm_aggregate_engine_io_output_data[63:0]      ), //o
    .io_output_mask            (b2m_fsm_aggregate_engine_io_output_mask[7:0]       ), //o
    .io_output_enough          (b2m_fsm_cmd_enoughAggregation                      ), //i
    .io_output_consume         (_zz_126                                            ), //i
    .io_output_consumed        (b2m_fsm_aggregate_engine_io_output_consumed        ), //o
    .io_output_lastByteUsed    (b2m_fsm_cmd_maskLastTriggerReg[2:0]                ), //i
    .io_output_usedUntil       (b2m_fsm_aggregate_engine_io_output_usedUntil[2:0]  ), //o
    .io_flush                  (_zz_127                                            ), //i
    .io_offset                 (_zz_128[2:0]                                       ), //i
    .io_burstLength            (b2m_fsm_sel_bytesInBurst[10:0]                     ), //i
    .clk                       (clk                                                ), //i
    .reset                     (reset                                              )  //i
  );
  always @(*) begin
    case(_zz_438)
      3'b000 : begin
        _zz_129 = _zz_6;
      end
      3'b001 : begin
        _zz_129 = _zz_7;
      end
      3'b010 : begin
        _zz_129 = _zz_8;
      end
      3'b011 : begin
        _zz_129 = _zz_9;
      end
      3'b100 : begin
        _zz_129 = _zz_10;
      end
      3'b101 : begin
        _zz_129 = _zz_11;
      end
      3'b110 : begin
        _zz_129 = _zz_12;
      end
      default : begin
        _zz_129 = _zz_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_439)
      3'b000 : begin
        _zz_130 = _zz_6;
      end
      3'b001 : begin
        _zz_130 = _zz_7;
      end
      3'b010 : begin
        _zz_130 = _zz_8;
      end
      3'b011 : begin
        _zz_130 = _zz_9;
      end
      3'b100 : begin
        _zz_130 = _zz_10;
      end
      3'b101 : begin
        _zz_130 = _zz_11;
      end
      3'b110 : begin
        _zz_130 = _zz_12;
      end
      default : begin
        _zz_130 = _zz_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_252)
      3'b000 : begin
        _zz_131 = _zz_6;
      end
      3'b001 : begin
        _zz_131 = _zz_7;
      end
      3'b010 : begin
        _zz_131 = _zz_8;
      end
      3'b011 : begin
        _zz_131 = _zz_9;
      end
      3'b100 : begin
        _zz_131 = _zz_10;
      end
      3'b101 : begin
        _zz_131 = _zz_11;
      end
      3'b110 : begin
        _zz_131 = _zz_12;
      end
      default : begin
        _zz_131 = _zz_13;
      end
    endcase
  end

  always @(*) begin
    case(_zz_440)
      3'b000 : begin
        _zz_132 = _zz_18;
      end
      3'b001 : begin
        _zz_132 = _zz_19;
      end
      3'b010 : begin
        _zz_132 = _zz_20;
      end
      3'b011 : begin
        _zz_132 = _zz_21;
      end
      3'b100 : begin
        _zz_132 = _zz_22;
      end
      3'b101 : begin
        _zz_132 = _zz_23;
      end
      3'b110 : begin
        _zz_132 = _zz_24;
      end
      default : begin
        _zz_132 = _zz_25;
      end
    endcase
  end

  always @(*) begin
    case(_zz_441)
      3'b000 : begin
        _zz_133 = _zz_18;
      end
      3'b001 : begin
        _zz_133 = _zz_19;
      end
      3'b010 : begin
        _zz_133 = _zz_20;
      end
      3'b011 : begin
        _zz_133 = _zz_21;
      end
      3'b100 : begin
        _zz_133 = _zz_22;
      end
      3'b101 : begin
        _zz_133 = _zz_23;
      end
      3'b110 : begin
        _zz_133 = _zz_24;
      end
      default : begin
        _zz_133 = _zz_25;
      end
    endcase
  end

  always @(*) begin
    case(_zz_257)
      3'b000 : begin
        _zz_134 = _zz_18;
      end
      3'b001 : begin
        _zz_134 = _zz_19;
      end
      3'b010 : begin
        _zz_134 = _zz_20;
      end
      3'b011 : begin
        _zz_134 = _zz_21;
      end
      3'b100 : begin
        _zz_134 = _zz_22;
      end
      3'b101 : begin
        _zz_134 = _zz_23;
      end
      3'b110 : begin
        _zz_134 = _zz_24;
      end
      default : begin
        _zz_134 = _zz_25;
      end
    endcase
  end

  always @(*) begin
    case(m2b_cmd_s0_chosen)
      1'b0 : begin
        _zz_135 = channels_1_push_m2b_address;
        _zz_136 = channels_1_push_m2b_bytesLeft;
        _zz_137 = channels_1_push_m2b_bytePerBurst;
      end
      default : begin
        _zz_135 = channels_3_push_m2b_address;
        _zz_136 = channels_3_push_m2b_bytesLeft;
        _zz_137 = channels_3_push_m2b_bytePerBurst;
      end
    endcase
  end

  always @(*) begin
    case(m2b_rsp_context_channel)
      1'b0 : begin
        _zz_138 = channels_1_fifo_push_ptrWithBase;
      end
      default : begin
        _zz_138 = channels_3_fifo_push_ptrWithBase;
      end
    endcase
  end

  always @(*) begin
    case(b2m_fsm_arbiter_core_io_chosen)
      1'b0 : begin
        _zz_139 = channels_0_pop_b2m_address;
        _zz_140 = channels_0_fifo_pop_ptrWithBase;
        _zz_141 = channels_0_fifo_words;
        _zz_142 = channels_0_pop_b2m_bytePerBurst;
        _zz_143 = channels_0_fifo_pop_bytes;
        _zz_144 = channels_0_pop_b2m_flush;
        _zz_145 = channels_0_pop_b2m_packet;
        _zz_146 = channels_0_pop_b2m_bytesLeft;
      end
      default : begin
        _zz_139 = channels_2_pop_b2m_address;
        _zz_140 = channels_2_fifo_pop_ptrWithBase;
        _zz_141 = channels_2_fifo_words;
        _zz_142 = channels_2_pop_b2m_bytePerBurst;
        _zz_143 = channels_2_fifo_pop_bytes;
        _zz_144 = channels_2_pop_b2m_flush;
        _zz_145 = channels_2_pop_b2m_packet;
        _zz_146 = channels_2_pop_b2m_bytesLeft;
      end
    endcase
  end

  always @(*) begin
    case(b2m_fsm_sel_channel)
      1'b0 : begin
        _zz_147 = channels_0_fifo_pop_ptr;
        _zz_148 = channels_0_pop_b2m_bytesToSkip;
      end
      default : begin
        _zz_147 = channels_2_fifo_pop_ptr;
        _zz_148 = channels_2_pop_b2m_bytesToSkip;
      end
    endcase
  end

  always @(*) begin
    case(_zz_442)
      2'b00 : begin
        _zz_149 = channels_0_ll_head;
      end
      2'b01 : begin
        _zz_149 = channels_1_ll_head;
      end
      2'b10 : begin
        _zz_149 = channels_2_ll_head;
      end
      default : begin
        _zz_149 = channels_3_ll_head;
      end
    endcase
  end

  always @(*) begin
    case(_zz_443)
      2'b00 : begin
        _zz_150 = channels_0_descriptorValid;
      end
      2'b01 : begin
        _zz_150 = channels_1_descriptorValid;
      end
      2'b10 : begin
        _zz_150 = channels_2_descriptorValid;
      end
      default : begin
        _zz_150 = channels_3_descriptorValid;
      end
    endcase
  end

  always @(*) begin
    case(_zz_444)
      2'b00 : begin
        _zz_151 = channels_0_ll_ptr;
      end
      2'b01 : begin
        _zz_151 = channels_1_ll_ptr;
      end
      2'b10 : begin
        _zz_151 = channels_2_ll_ptr;
      end
      default : begin
        _zz_151 = channels_3_ll_ptr;
      end
    endcase
  end

  always @(*) begin
    case(_zz_445)
      2'b00 : begin
        _zz_152 = channels_0_ll_ptrNext;
      end
      2'b01 : begin
        _zz_152 = channels_1_ll_ptrNext;
      end
      2'b10 : begin
        _zz_152 = channels_2_ll_ptrNext;
      end
      default : begin
        _zz_152 = channels_3_ll_ptrNext;
      end
    endcase
  end

  always @(*) begin
    case(_zz_446)
      2'b00 : begin
        _zz_153 = channels_0_ll_packet;
      end
      2'b01 : begin
        _zz_153 = channels_1_ll_packet;
      end
      2'b10 : begin
        _zz_153 = channels_2_ll_packet;
      end
      default : begin
        _zz_153 = channels_3_ll_packet;
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
    if(_zz_77)begin
      if(_zz_308[0])begin
        channels_0_channelStart = _zz_309[0];
      end
    end
    if(_zz_79)begin
      if(_zz_312[0])begin
        channels_0_channelStart = _zz_313[0];
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
    if(_zz_154)begin
      if(_zz_155)begin
        if(_zz_156)begin
          channels_0_descriptorStart = 1'b1;
        end
      end
    end
    if(channels_0_channelValid)begin
      if(! channels_0_channelStop) begin
        if(_zz_157)begin
          if(_zz_158)begin
            channels_0_descriptorStart = 1'b1;
          end
        end
      end
    end
  end

  always @ (*) begin
    channels_0_descriptorCompletion = 1'b0;
    if(channels_0_pop_b2m_packetSync)begin
      if(_zz_159)begin
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
    if(_zz_160)begin
      if(_zz_161)begin
        channels_0_bytesProbe_incr_valid = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_0_bytesProbe_incr_payload = 11'h0;
    if(_zz_160)begin
      if(_zz_161)begin
        channels_0_bytesProbe_incr_payload = b2m_rsp_context_length;
      end
    end
  end

  always @ (*) begin
    channels_0_ll_sgStart = 1'b0;
    if(_zz_80)begin
      if(_zz_314[0])begin
        channels_0_ll_sgStart = _zz_315[0];
      end
    end
  end

  assign channels_0_ll_requestLl = ((((channels_0_channelValid && channels_0_ll_valid) && (! channels_0_channelStop)) && (! channels_0_ll_waitDone)) && ((! channels_0_descriptorValid) || channels_0_ll_requireSync));
  always @ (*) begin
    channels_0_ll_descriptorUpdated = 1'b0;
    if(_zz_154)begin
      if((! channels_0_ll_head))begin
        channels_0_ll_descriptorUpdated = 1'b1;
      end
    end
  end

  assign channels_0_fifo_base = 11'h0;
  assign channels_0_fifo_words = 11'h0ff;
  assign channels_0_fifo_push_availableDecr = 11'h0;
  assign channels_0_fifo_push_ptrWithBase = ((channels_0_fifo_base & (~ channels_0_fifo_words)) | (channels_0_fifo_push_ptr & channels_0_fifo_words));
  assign channels_0_fifo_pop_ptrWithBase = ((channels_0_fifo_base & (~ channels_0_fifo_words)) | (channels_0_fifo_pop_ptr & channels_0_fifo_words));
  assign channels_0_fifo_pop_empty = (channels_0_fifo_pop_ptr == channels_0_fifo_push_ptr);
  assign channels_0_fifo_pop_withOverride_backupNext = (_zz_196 - channels_0_fifo_pop_bytesDecr_value);
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

  assign channels_0_pop_b2m_bytePerBurst = 11'h1ff;
  always @ (*) begin
    channels_0_pop_b2m_fire = 1'b0;
    if(_zz_162)begin
      if(_zz_36[0])begin
        channels_0_pop_b2m_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_0_pop_b2m_packetSync = 1'b0;
    if(_zz_163)begin
      if(channels_0_pop_b2m_packet)begin
        channels_0_pop_b2m_packetSync = 1'b1;
      end
    end
    if(_zz_160)begin
      if(_zz_161)begin
        if(b2m_rsp_context_doPacketSync)begin
          channels_0_pop_b2m_packetSync = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_0_pop_b2m_memRsp = 1'b0;
    if(_zz_160)begin
      if(_zz_46[0])begin
        channels_0_pop_b2m_memRsp = 1'b1;
      end
    end
  end

  assign channels_0_pop_b2m_request = ((((((channels_0_descriptorValid && (! channels_0_channelStop)) && (! channels_0_pop_b2m_waitFinalRsp)) && channels_0_pop_memory) && ((_zz_198 < channels_0_fifo_pop_bytes) || ((channels_0_fifo_push_available < _zz_200) || channels_0_pop_b2m_flush))) && (channels_0_fifo_pop_bytes != 14'h0)) && (channels_0_pop_b2m_memPending != 4'b1111));
  always @ (*) begin
    channels_0_pop_b2m_decrBytes = 14'h0;
    if(b2m_fsm_s1)begin
      if(_zz_164)begin
        channels_0_pop_b2m_decrBytes = {3'd0, b2m_fsm_bytesInBurstP1};
      end
    end
  end

  assign channels_0_readyForChannelCompletion = 1'b1;
  always @ (*) begin
    _zz_1 = 1'b1;
    if(_zz_158)begin
      _zz_1 = 1'b0;
    end
    if(channels_0_ctrl_kick)begin
      _zz_1 = 1'b0;
    end
    if(channels_0_ll_valid)begin
      _zz_1 = 1'b0;
    end
  end

  assign channels_0_s2b_full = (channels_0_fifo_push_available < 11'h001);
  always @ (*) begin
    channels_1_channelStart = 1'b0;
    if(_zz_85)begin
      if(_zz_324[0])begin
        channels_1_channelStart = _zz_325[0];
      end
    end
    if(_zz_87)begin
      if(_zz_328[0])begin
        channels_1_channelStart = _zz_329[0];
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
    if(_zz_165)begin
      if(_zz_166)begin
        if(_zz_167)begin
          channels_1_descriptorStart = 1'b1;
        end
      end
    end
    if(channels_1_channelValid)begin
      if(! channels_1_channelStop) begin
        if(_zz_168)begin
          if(_zz_169)begin
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
    if(_zz_88)begin
      if(_zz_330[0])begin
        channels_1_ll_sgStart = _zz_331[0];
      end
    end
  end

  assign channels_1_ll_requestLl = ((((channels_1_channelValid && channels_1_ll_valid) && (! channels_1_channelStop)) && (! channels_1_ll_waitDone)) && ((! channels_1_descriptorValid) || channels_1_ll_requireSync));
  always @ (*) begin
    channels_1_ll_descriptorUpdated = 1'b0;
    if(_zz_165)begin
      if((! channels_1_ll_head))begin
        channels_1_ll_descriptorUpdated = 1'b1;
      end
    end
  end

  assign channels_1_fifo_base = 11'h100;
  assign channels_1_fifo_words = 11'h0ff;
  always @ (*) begin
    channels_1_fifo_push_availableDecr = 11'h0;
    if(m2b_cmd_s1_valid)begin
      if(io_read_cmd_ready)begin
        if(_zz_170)begin
          channels_1_fifo_push_availableDecr = {2'd0, m2b_cmd_s1_fifoPushDecr};
        end
      end
    end
  end

  assign channels_1_fifo_push_ptrWithBase = ((channels_1_fifo_base & (~ channels_1_fifo_words)) | (channels_1_fifo_push_ptr & channels_1_fifo_words));
  assign channels_1_fifo_pop_ptrWithBase = ((channels_1_fifo_base & (~ channels_1_fifo_words)) | (channels_1_fifo_pop_ptr & channels_1_fifo_words));
  assign channels_1_fifo_pop_empty = (channels_1_fifo_pop_ptr == channels_1_fifo_push_ptr);
  assign channels_1_fifo_pop_bytes = channels_1_fifo_pop_withoutOverride_exposed;
  assign channels_1_fifo_empty = (channels_1_fifo_push_ptr == channels_1_fifo_pop_ptr);
  assign channels_1_push_m2b_bytePerBurst = 11'h0ff;
  always @ (*) begin
    channels_1_push_m2b_memPendingIncr = 1'b0;
    if(_zz_171)begin
      if(_zz_172)begin
        if(_zz_31[0])begin
          channels_1_push_m2b_memPendingIncr = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_1_push_m2b_memPendingDecr = 1'b0;
    if((_zz_34 && m2b_writeRsp_context_lastOfBurst))begin
      channels_1_push_m2b_memPendingDecr = 1'b1;
    end
  end

  always @ (*) begin
    channels_1_push_m2b_loadRequest = (((((channels_1_descriptorValid && (! channels_1_channelStop)) && (! channels_1_push_m2b_loadDone)) && channels_1_push_memory) && (_zz_217 < channels_1_fifo_push_available)) && (channels_1_push_m2b_memPending != 4'b1111));
    if((((! channels_1_pop_memory) && channels_1_pop_b2s_veryLastValid) && (channels_1_push_m2b_bytesLeft <= _zz_218)))begin
      channels_1_push_m2b_loadRequest = 1'b0;
    end
  end

  always @ (*) begin
    channels_1_pop_b2s_veryLastTrigger = 1'b0;
    if(_zz_173)begin
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
    if(_zz_169)begin
      _zz_2 = 1'b0;
    end
    if(channels_1_ctrl_kick)begin
      _zz_2 = 1'b0;
    end
    if(channels_1_ll_valid)begin
      _zz_2 = 1'b0;
    end
  end

  assign channels_1_s2b_full = (channels_1_fifo_push_available < 11'h001);
  always @ (*) begin
    channels_2_channelStart = 1'b0;
    if(_zz_92)begin
      if(_zz_338[0])begin
        channels_2_channelStart = _zz_339[0];
      end
    end
    if(_zz_94)begin
      if(_zz_342[0])begin
        channels_2_channelStart = _zz_343[0];
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
    if(_zz_174)begin
      if(_zz_175)begin
        if(_zz_176)begin
          channels_2_descriptorStart = 1'b1;
        end
      end
    end
    if(channels_2_channelValid)begin
      if(! channels_2_channelStop) begin
        if(_zz_177)begin
          if(_zz_178)begin
            channels_2_descriptorStart = 1'b1;
          end
        end
      end
    end
  end

  always @ (*) begin
    channels_2_descriptorCompletion = 1'b0;
    if(channels_2_pop_b2m_packetSync)begin
      if(_zz_179)begin
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
    if(_zz_160)begin
      if(_zz_180)begin
        channels_2_bytesProbe_incr_valid = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_2_bytesProbe_incr_payload = 11'h0;
    if(_zz_160)begin
      if(_zz_180)begin
        channels_2_bytesProbe_incr_payload = b2m_rsp_context_length;
      end
    end
  end

  always @ (*) begin
    channels_2_ll_sgStart = 1'b0;
    if(_zz_95)begin
      if(_zz_344[0])begin
        channels_2_ll_sgStart = _zz_345[0];
      end
    end
  end

  assign channels_2_ll_requestLl = ((((channels_2_channelValid && channels_2_ll_valid) && (! channels_2_channelStop)) && (! channels_2_ll_waitDone)) && ((! channels_2_descriptorValid) || channels_2_ll_requireSync));
  always @ (*) begin
    channels_2_ll_descriptorUpdated = 1'b0;
    if(_zz_174)begin
      if((! channels_2_ll_head))begin
        channels_2_ll_descriptorUpdated = 1'b1;
      end
    end
  end

  assign channels_2_fifo_base = 11'h200;
  assign channels_2_fifo_words = 11'h0ff;
  assign channels_2_fifo_push_availableDecr = 11'h0;
  assign channels_2_fifo_push_ptrWithBase = ((channels_2_fifo_base & (~ channels_2_fifo_words)) | (channels_2_fifo_push_ptr & channels_2_fifo_words));
  assign channels_2_fifo_pop_ptrWithBase = ((channels_2_fifo_base & (~ channels_2_fifo_words)) | (channels_2_fifo_pop_ptr & channels_2_fifo_words));
  assign channels_2_fifo_pop_empty = (channels_2_fifo_pop_ptr == channels_2_fifo_push_ptr);
  assign channels_2_fifo_pop_withOverride_backupNext = (_zz_224 - channels_2_fifo_pop_bytesDecr_value);
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

  assign channels_2_pop_b2m_bytePerBurst = 11'h1ff;
  always @ (*) begin
    channels_2_pop_b2m_fire = 1'b0;
    if(_zz_162)begin
      if(_zz_36[1])begin
        channels_2_pop_b2m_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    channels_2_pop_b2m_packetSync = 1'b0;
    if(_zz_181)begin
      if(channels_2_pop_b2m_packet)begin
        channels_2_pop_b2m_packetSync = 1'b1;
      end
    end
    if(_zz_160)begin
      if(_zz_180)begin
        if(b2m_rsp_context_doPacketSync)begin
          channels_2_pop_b2m_packetSync = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_2_pop_b2m_memRsp = 1'b0;
    if(_zz_160)begin
      if(_zz_46[1])begin
        channels_2_pop_b2m_memRsp = 1'b1;
      end
    end
  end

  assign channels_2_pop_b2m_request = ((((((channels_2_descriptorValid && (! channels_2_channelStop)) && (! channels_2_pop_b2m_waitFinalRsp)) && channels_2_pop_memory) && ((_zz_226 < channels_2_fifo_pop_bytes) || ((channels_2_fifo_push_available < _zz_228) || channels_2_pop_b2m_flush))) && (channels_2_fifo_pop_bytes != 14'h0)) && (channels_2_pop_b2m_memPending != 4'b1111));
  always @ (*) begin
    channels_2_pop_b2m_decrBytes = 14'h0;
    if(b2m_fsm_s1)begin
      if(_zz_182)begin
        channels_2_pop_b2m_decrBytes = {3'd0, b2m_fsm_bytesInBurstP1};
      end
    end
  end

  assign channels_2_readyForChannelCompletion = 1'b1;
  always @ (*) begin
    _zz_3 = 1'b1;
    if(_zz_178)begin
      _zz_3 = 1'b0;
    end
    if(channels_2_ctrl_kick)begin
      _zz_3 = 1'b0;
    end
    if(channels_2_ll_valid)begin
      _zz_3 = 1'b0;
    end
  end

  assign channels_2_s2b_full = (channels_2_fifo_push_available < 11'h001);
  always @ (*) begin
    channels_3_channelStart = 1'b0;
    if(_zz_100)begin
      if(_zz_354[0])begin
        channels_3_channelStart = _zz_355[0];
      end
    end
    if(_zz_102)begin
      if(_zz_358[0])begin
        channels_3_channelStart = _zz_359[0];
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
    if(_zz_183)begin
      if(_zz_184)begin
        if(_zz_185)begin
          channels_3_descriptorStart = 1'b1;
        end
      end
    end
    if(channels_3_channelValid)begin
      if(! channels_3_channelStop) begin
        if(_zz_186)begin
          if(_zz_187)begin
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
    if(_zz_103)begin
      if(_zz_360[0])begin
        channels_3_ll_sgStart = _zz_361[0];
      end
    end
  end

  assign channels_3_ll_requestLl = ((((channels_3_channelValid && channels_3_ll_valid) && (! channels_3_channelStop)) && (! channels_3_ll_waitDone)) && ((! channels_3_descriptorValid) || channels_3_ll_requireSync));
  always @ (*) begin
    channels_3_ll_descriptorUpdated = 1'b0;
    if(_zz_183)begin
      if((! channels_3_ll_head))begin
        channels_3_ll_descriptorUpdated = 1'b1;
      end
    end
  end

  assign channels_3_fifo_base = 11'h300;
  assign channels_3_fifo_words = 11'h0ff;
  always @ (*) begin
    channels_3_fifo_push_availableDecr = 11'h0;
    if(m2b_cmd_s1_valid)begin
      if(io_read_cmd_ready)begin
        if(_zz_188)begin
          channels_3_fifo_push_availableDecr = {2'd0, m2b_cmd_s1_fifoPushDecr};
        end
      end
    end
  end

  assign channels_3_fifo_push_ptrWithBase = ((channels_3_fifo_base & (~ channels_3_fifo_words)) | (channels_3_fifo_push_ptr & channels_3_fifo_words));
  assign channels_3_fifo_pop_ptrWithBase = ((channels_3_fifo_base & (~ channels_3_fifo_words)) | (channels_3_fifo_pop_ptr & channels_3_fifo_words));
  assign channels_3_fifo_pop_empty = (channels_3_fifo_pop_ptr == channels_3_fifo_push_ptr);
  assign channels_3_fifo_pop_bytes = channels_3_fifo_pop_withoutOverride_exposed;
  assign channels_3_fifo_empty = (channels_3_fifo_push_ptr == channels_3_fifo_pop_ptr);
  assign channels_3_push_m2b_bytePerBurst = 11'h0ff;
  always @ (*) begin
    channels_3_push_m2b_memPendingIncr = 1'b0;
    if(_zz_171)begin
      if(_zz_172)begin
        if(_zz_31[1])begin
          channels_3_push_m2b_memPendingIncr = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    channels_3_push_m2b_memPendingDecr = 1'b0;
    if((_zz_35 && m2b_writeRsp_context_lastOfBurst))begin
      channels_3_push_m2b_memPendingDecr = 1'b1;
    end
  end

  always @ (*) begin
    channels_3_push_m2b_loadRequest = (((((channels_3_descriptorValid && (! channels_3_channelStop)) && (! channels_3_push_m2b_loadDone)) && channels_3_push_memory) && (_zz_245 < channels_3_fifo_push_available)) && (channels_3_push_m2b_memPending != 4'b1111));
    if((((! channels_3_pop_memory) && channels_3_pop_b2s_veryLastValid) && (channels_3_push_m2b_bytesLeft <= _zz_246)))begin
      channels_3_push_m2b_loadRequest = 1'b0;
    end
  end

  always @ (*) begin
    channels_3_pop_b2s_veryLastTrigger = 1'b0;
    if(_zz_173)begin
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
    if(_zz_187)begin
      _zz_4 = 1'b0;
    end
    if(channels_3_ctrl_kick)begin
      _zz_4 = 1'b0;
    end
    if(channels_3_ll_valid)begin
      _zz_4 = 1'b0;
    end
  end

  assign channels_3_s2b_full = (channels_3_fifo_push_available < 11'h001);
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
  assign _zz_6 = 4'b0000;
  assign _zz_7 = 4'b0001;
  assign _zz_8 = 4'b0001;
  assign _zz_9 = 4'b0010;
  assign _zz_10 = 4'b0001;
  assign _zz_11 = 4'b0010;
  assign _zz_12 = 4'b0010;
  assign _zz_13 = 4'b0011;
  assign s2b_0_cmd_byteCount = (_zz_250 + _zz_131);
  assign s2b_0_cmd_context_channel = s2b_0_cmd_channelsOh;
  assign s2b_0_cmd_context_bytes = s2b_0_cmd_byteCount;
  assign s2b_0_cmd_context_flush = io_inputs_0_payload_last;
  assign s2b_0_cmd_context_packet = io_inputs_0_payload_last;
  assign s2b_0_cmd_sinkHalted_ready = memory_core_io_writes_0_cmd_ready;
  assign _zz_107 = channels_0_fifo_push_ptrWithBase[9:0];
  assign _zz_108 = {s2b_0_cmd_context_packet,{s2b_0_cmd_context_flush,{s2b_0_cmd_context_bytes,s2b_0_cmd_context_channel}}};
  assign _zz_14 = (s2b_0_cmd_channelsOh[0] && (s2b_0_cmd_sinkHalted_valid && memory_core_io_writes_0_cmd_ready));
  assign _zz_15 = memory_core_io_writes_0_rsp_payload_context;
  assign s2b_0_rsp_context_channel = _zz_15[0 : 0];
  assign s2b_0_rsp_context_bytes = _zz_15[4 : 1];
  assign s2b_0_rsp_context_flush = _zz_253[0];
  assign s2b_0_rsp_context_packet = _zz_254[0];
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
  assign _zz_18 = 4'b0000;
  assign _zz_19 = 4'b0001;
  assign _zz_20 = 4'b0001;
  assign _zz_21 = 4'b0010;
  assign _zz_22 = 4'b0001;
  assign _zz_23 = 4'b0010;
  assign _zz_24 = 4'b0010;
  assign _zz_25 = 4'b0011;
  assign s2b_1_cmd_byteCount = (_zz_255 + _zz_134);
  assign s2b_1_cmd_context_channel = s2b_1_cmd_channelsOh;
  assign s2b_1_cmd_context_bytes = s2b_1_cmd_byteCount;
  assign s2b_1_cmd_context_flush = io_inputs_1_payload_last;
  assign s2b_1_cmd_context_packet = io_inputs_1_payload_last;
  assign s2b_1_cmd_sinkHalted_ready = memory_core_io_writes_1_cmd_ready;
  assign _zz_109 = channels_2_fifo_push_ptrWithBase[9:0];
  assign _zz_110 = {s2b_1_cmd_context_packet,{s2b_1_cmd_context_flush,{s2b_1_cmd_context_bytes,s2b_1_cmd_context_channel}}};
  assign _zz_26 = (s2b_1_cmd_channelsOh[0] && (s2b_1_cmd_sinkHalted_valid && memory_core_io_writes_1_cmd_ready));
  assign _zz_27 = memory_core_io_writes_1_rsp_payload_context;
  assign s2b_1_rsp_context_channel = _zz_27[0 : 0];
  assign s2b_1_rsp_context_bytes = _zz_27[4 : 1];
  assign s2b_1_rsp_context_flush = _zz_258[0];
  assign s2b_1_rsp_context_packet = _zz_259[0];
  assign _zz_28 = (memory_core_io_writes_1_rsp_valid && s2b_1_rsp_context_channel[0]);
  assign b2s_0_cmd_channelsOh = (((channels_1_channelValid && (! channels_1_pop_memory)) && (channels_1_pop_b2s_portId == 1'b0)) && (! channels_1_fifo_pop_empty));
  assign b2s_0_cmd_veryLastPtr = channels_1_pop_b2s_veryLastPtr;
  assign b2s_0_cmd_address = channels_1_fifo_pop_ptrWithBase;
  assign b2s_0_cmd_context_channel = b2s_0_cmd_channelsOh;
  assign b2s_0_cmd_context_veryLast = ((channels_1_pop_b2s_veryLastValid && (b2s_0_cmd_address[10 : 0] == b2s_0_cmd_veryLastPtr[10 : 0])) && 1'b1);
  assign b2s_0_cmd_context_endPacket = channels_1_pop_b2s_veryLastEndPacket;
  assign _zz_114 = (b2s_0_cmd_channelsOh != 1'b0);
  assign _zz_115 = b2s_0_cmd_address[9:0];
  assign _zz_116 = {b2s_0_cmd_context_endPacket,{b2s_0_cmd_context_veryLast,b2s_0_cmd_context_channel}};
  assign _zz_29 = memory_core_io_reads_0_rsp_payload_context;
  assign b2s_0_rsp_context_channel = _zz_29[0 : 0];
  assign b2s_0_rsp_context_veryLast = _zz_260[0];
  assign b2s_0_rsp_context_endPacket = _zz_261[0];
  assign io_outputs_0_valid = memory_core_io_reads_0_rsp_valid;
  assign io_outputs_0_payload_data = memory_core_io_reads_0_rsp_payload_data;
  assign io_outputs_0_payload_mask = memory_core_io_reads_0_rsp_payload_mask;
  assign io_outputs_0_payload_sink = channels_1_pop_b2s_sinkId;
  assign io_outputs_0_payload_last = (b2s_0_rsp_context_veryLast && b2s_0_rsp_context_endPacket);
  assign b2s_1_cmd_channelsOh = (((channels_3_channelValid && (! channels_3_pop_memory)) && (channels_3_pop_b2s_portId == 1'b0)) && (! channels_3_fifo_pop_empty));
  assign b2s_1_cmd_veryLastPtr = channels_3_pop_b2s_veryLastPtr;
  assign b2s_1_cmd_address = channels_3_fifo_pop_ptrWithBase;
  assign b2s_1_cmd_context_channel = b2s_1_cmd_channelsOh;
  assign b2s_1_cmd_context_veryLast = ((channels_3_pop_b2s_veryLastValid && (b2s_1_cmd_address[10 : 0] == b2s_1_cmd_veryLastPtr[10 : 0])) && 1'b1);
  assign b2s_1_cmd_context_endPacket = channels_3_pop_b2s_veryLastEndPacket;
  assign _zz_117 = (b2s_1_cmd_channelsOh != 1'b0);
  assign _zz_118 = b2s_1_cmd_address[9:0];
  assign _zz_119 = {b2s_1_cmd_context_endPacket,{b2s_1_cmd_context_veryLast,b2s_1_cmd_context_channel}};
  assign _zz_30 = memory_core_io_reads_1_rsp_payload_context;
  assign b2s_1_rsp_context_channel = _zz_30[0 : 0];
  assign b2s_1_rsp_context_veryLast = _zz_262[0];
  assign b2s_1_rsp_context_endPacket = _zz_263[0];
  assign io_outputs_1_valid = memory_core_io_reads_1_rsp_valid;
  assign io_outputs_1_payload_data = memory_core_io_reads_1_rsp_payload_data;
  assign io_outputs_1_payload_mask = memory_core_io_reads_1_rsp_payload_mask;
  assign io_outputs_1_payload_sink = channels_3_pop_b2s_sinkId;
  assign io_outputs_1_payload_last = (b2s_1_rsp_context_veryLast && b2s_1_rsp_context_endPacket);
  always @ (*) begin
    _zz_123 = 1'b0;
    if(_zz_171)begin
      _zz_123 = 1'b1;
    end
  end

  assign _zz_31 = ({1'd0,1'b1} <<< m2b_cmd_arbiter_io_chosen);
  assign m2b_cmd_s0_address = _zz_135;
  assign m2b_cmd_s0_bytesLeft = _zz_136;
  assign m2b_cmd_s0_readAddressBurstRange = m2b_cmd_s0_address[10 : 0];
  assign m2b_cmd_s0_lengthHead = ((~ m2b_cmd_s0_readAddressBurstRange) & _zz_137);
  assign m2b_cmd_s0_length = _zz_264[10:0];
  assign m2b_cmd_s0_lastBurst = (m2b_cmd_s0_bytesLeft == _zz_267);
  assign m2b_cmd_s1_context_channel = m2b_cmd_s0_chosen;
  assign m2b_cmd_s1_context_start = m2b_cmd_s1_address[2:0];
  assign m2b_cmd_s1_context_stop = _zz_268[2:0];
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
  assign m2b_cmd_s1_addressNext = (_zz_270 + 32'h00000001);
  assign m2b_cmd_s1_byteLeftNext = (_zz_272 - 26'h0000001);
  assign m2b_cmd_s1_fifoPushDecr = (_zz_274 >>> 3);
  assign _zz_32 = io_read_rsp_payload_fragment_context;
  assign m2b_rsp_context_channel = _zz_32[0 : 0];
  assign m2b_rsp_context_start = _zz_32[3 : 1];
  assign m2b_rsp_context_stop = _zz_32[6 : 4];
  assign m2b_rsp_context_length = _zz_32[17 : 7];
  assign m2b_rsp_context_last = _zz_280[0];
  assign m2b_rsp_veryLast = (m2b_rsp_context_last && io_read_rsp_payload_last);
  always @ (*) begin
    _zz_112[0] = ((! (m2b_rsp_first && (3'b000 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 3'b000))));
    _zz_112[1] = ((! (m2b_rsp_first && (3'b001 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 3'b001))));
    _zz_112[2] = ((! (m2b_rsp_first && (3'b010 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 3'b010))));
    _zz_112[3] = ((! (m2b_rsp_first && (3'b011 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 3'b011))));
    _zz_112[4] = ((! (m2b_rsp_first && (3'b100 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 3'b100))));
    _zz_112[5] = ((! (m2b_rsp_first && (3'b101 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 3'b101))));
    _zz_112[6] = ((! (m2b_rsp_first && (3'b110 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 3'b110))));
    _zz_112[7] = ((! (m2b_rsp_first && (3'b111 < m2b_rsp_context_start))) && (! (io_read_rsp_payload_last && (m2b_rsp_context_stop < 3'b111))));
  end

  assign m2b_rsp_writeContext_last = m2b_rsp_veryLast;
  assign m2b_rsp_writeContext_lastOfBurst = io_read_rsp_payload_last;
  assign m2b_rsp_writeContext_channel = m2b_rsp_context_channel;
  assign m2b_rsp_writeContext_loadByteInNextBeat = ({1'b0,(io_read_rsp_payload_last ? m2b_rsp_context_stop : 3'b111)} - {1'b0,(m2b_rsp_first ? m2b_rsp_context_start : 3'b000)});
  assign _zz_111 = _zz_138[9:0];
  assign io_read_rsp_ready = memory_core_io_writes_2_cmd_ready;
  assign _zz_113 = {m2b_rsp_writeContext_loadByteInNextBeat,{m2b_rsp_writeContext_channel,{m2b_rsp_writeContext_lastOfBurst,m2b_rsp_writeContext_last}}};
  assign _zz_33 = memory_core_io_writes_2_rsp_payload_context;
  assign m2b_writeRsp_context_last = _zz_281[0];
  assign m2b_writeRsp_context_lastOfBurst = _zz_282[0];
  assign m2b_writeRsp_context_channel = _zz_33[2 : 2];
  assign m2b_writeRsp_context_loadByteInNextBeat = _zz_33[6 : 3];
  assign _zz_34 = (memory_core_io_writes_2_rsp_valid && (m2b_writeRsp_context_channel == 1'b0));
  assign _zz_35 = (memory_core_io_writes_2_rsp_valid && (m2b_writeRsp_context_channel == 1'b1));
  always @ (*) begin
    _zz_124 = 1'b0;
    if(_zz_162)begin
      _zz_124 = 1'b1;
    end
  end

  assign _zz_36 = ({1'd0,1'b1} <<< b2m_fsm_arbiter_core_io_chosen);
  assign b2m_fsm_bytesInBurstP1 = (b2m_fsm_sel_bytesInBurst + 11'h001);
  assign b2m_fsm_addressNext = (b2m_fsm_sel_address + _zz_283);
  assign b2m_fsm_bytesLeftNext = ({1'b0,b2m_fsm_sel_bytesLeft} - _zz_285);
  assign b2m_fsm_isFinalCmd = b2m_fsm_bytesLeftNext[26];
  assign b2m_fsm_s0 = (b2m_fsm_sel_valid && (! b2m_fsm_sel_valid_regNext));
  assign _zz_37 = (b2m_fsm_sel_bytesInFifo - 14'h0001);
  assign _zz_38 = ((_zz_286 < b2m_fsm_sel_bytesLeft) ? _zz_287 : b2m_fsm_sel_bytesLeft);
  assign _zz_39 = (b2m_fsm_sel_bytePerBurst - (_zz_288 & b2m_fsm_sel_bytePerBurst));
  assign b2m_fsm_fifoCompletion = (_zz_292 == _zz_293);
  always @ (*) begin
    b2m_fsm_sel_ready = 1'b0;
    if(_zz_189)begin
      b2m_fsm_sel_ready = 1'b1;
    end
  end

  assign b2m_fsm_fetch_context_ptr = _zz_147;
  assign b2m_fsm_fetch_context_toggle = b2m_fsm_toggle;
  assign _zz_120 = b2m_fsm_sel_ptr[9:0];
  assign _zz_121 = {b2m_fsm_fetch_context_toggle,b2m_fsm_fetch_context_ptr};
  assign _zz_40 = memory_core_io_reads_2_rsp_payload_context;
  assign b2m_fsm_aggregate_context_ptr = _zz_40[10 : 0];
  assign b2m_fsm_aggregate_context_toggle = _zz_298[0];
  assign memory_core_io_reads_2_rsp_s2mPipe_valid = (memory_core_io_reads_2_rsp_valid || memory_core_io_reads_2_rsp_s2mPipe_rValid);
  assign _zz_122 = (! memory_core_io_reads_2_rsp_s2mPipe_rValid);
  assign memory_core_io_reads_2_rsp_s2mPipe_payload_data = (memory_core_io_reads_2_rsp_s2mPipe_rValid ? memory_core_io_reads_2_rsp_s2mPipe_rData_data : memory_core_io_reads_2_rsp_payload_data);
  assign memory_core_io_reads_2_rsp_s2mPipe_payload_mask = (memory_core_io_reads_2_rsp_s2mPipe_rValid ? memory_core_io_reads_2_rsp_s2mPipe_rData_mask : memory_core_io_reads_2_rsp_payload_mask);
  assign memory_core_io_reads_2_rsp_s2mPipe_payload_context = (memory_core_io_reads_2_rsp_s2mPipe_rValid ? memory_core_io_reads_2_rsp_s2mPipe_rData_context : memory_core_io_reads_2_rsp_payload_context);
  always @ (*) begin
    b2m_fsm_aggregate_memoryPort_valid = memory_core_io_reads_2_rsp_s2mPipe_valid;
    if(_zz_190)begin
      b2m_fsm_aggregate_memoryPort_valid = 1'b0;
    end
  end

  always @ (*) begin
    memory_core_io_reads_2_rsp_s2mPipe_ready = b2m_fsm_aggregate_memoryPort_ready;
    if(_zz_190)begin
      memory_core_io_reads_2_rsp_s2mPipe_ready = 1'b1;
    end
  end

  assign b2m_fsm_aggregate_memoryPort_payload_data = memory_core_io_reads_2_rsp_s2mPipe_payload_data;
  assign b2m_fsm_aggregate_memoryPort_payload_mask = memory_core_io_reads_2_rsp_s2mPipe_payload_mask;
  assign b2m_fsm_aggregate_memoryPort_payload_context = memory_core_io_reads_2_rsp_s2mPipe_payload_context;
  assign b2m_fsm_aggregate_bytesToSkip = _zz_148;
  always @ (*) begin
    b2m_fsm_aggregate_bytesToSkipMask[0] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 3'b000));
    b2m_fsm_aggregate_bytesToSkipMask[1] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 3'b001));
    b2m_fsm_aggregate_bytesToSkipMask[2] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 3'b010));
    b2m_fsm_aggregate_bytesToSkipMask[3] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 3'b011));
    b2m_fsm_aggregate_bytesToSkipMask[4] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 3'b100));
    b2m_fsm_aggregate_bytesToSkipMask[5] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 3'b101));
    b2m_fsm_aggregate_bytesToSkipMask[6] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 3'b110));
    b2m_fsm_aggregate_bytesToSkipMask[7] = ((! b2m_fsm_aggregate_first) || (b2m_fsm_aggregate_bytesToSkip <= 3'b111));
  end

  assign b2m_fsm_aggregate_memoryPort_ready = b2m_fsm_aggregate_engine_io_input_ready;
  assign _zz_125 = (b2m_fsm_aggregate_memoryPort_payload_mask & b2m_fsm_aggregate_bytesToSkipMask);
  assign _zz_128 = b2m_fsm_sel_address[2:0];
  assign _zz_127 = (! _zz_41);
  assign b2m_fsm_cmd_maskFirstTrigger = b2m_fsm_sel_address[2:0];
  assign b2m_fsm_cmd_maskLastTriggerComb = (b2m_fsm_cmd_maskFirstTrigger + _zz_299);
  always @ (*) begin
    _zz_42[0] = (3'b000 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_42[1] = (3'b001 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_42[2] = (3'b010 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_42[3] = (3'b011 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_42[4] = (3'b100 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_42[5] = (3'b101 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_42[6] = (3'b110 <= b2m_fsm_cmd_maskLastTriggerComb);
    _zz_42[7] = (3'b111 <= b2m_fsm_cmd_maskLastTriggerComb);
  end

  always @ (*) begin
    b2m_fsm_cmd_maskFirst[0] = (b2m_fsm_cmd_maskFirstTrigger <= 3'b000);
    b2m_fsm_cmd_maskFirst[1] = (b2m_fsm_cmd_maskFirstTrigger <= 3'b001);
    b2m_fsm_cmd_maskFirst[2] = (b2m_fsm_cmd_maskFirstTrigger <= 3'b010);
    b2m_fsm_cmd_maskFirst[3] = (b2m_fsm_cmd_maskFirstTrigger <= 3'b011);
    b2m_fsm_cmd_maskFirst[4] = (b2m_fsm_cmd_maskFirstTrigger <= 3'b100);
    b2m_fsm_cmd_maskFirst[5] = (b2m_fsm_cmd_maskFirstTrigger <= 3'b101);
    b2m_fsm_cmd_maskFirst[6] = (b2m_fsm_cmd_maskFirstTrigger <= 3'b110);
    b2m_fsm_cmd_maskFirst[7] = (b2m_fsm_cmd_maskFirstTrigger <= 3'b111);
  end

  assign b2m_fsm_cmd_enoughAggregation = (((b2m_fsm_s2 && b2m_fsm_sel_valid) && (! _zz_127)) && (io_write_cmd_payload_last ? ((b2m_fsm_aggregate_engine_io_output_mask & b2m_fsm_cmd_maskLast) == b2m_fsm_cmd_maskLast) : (b2m_fsm_aggregate_engine_io_output_mask == 8'hff)));
  assign _zz_126 = (io_write_cmd_valid && io_write_cmd_ready);
  assign io_write_cmd_valid = b2m_fsm_cmd_enoughAggregation;
  assign io_write_cmd_payload_last = (b2m_fsm_beatCounter == 8'h0);
  assign io_write_cmd_payload_fragment_address = b2m_fsm_sel_address;
  assign io_write_cmd_payload_fragment_opcode = 1'b1;
  assign io_write_cmd_payload_fragment_data = b2m_fsm_aggregate_engine_io_output_data;
  assign io_write_cmd_payload_fragment_mask = (~ ((io_write_cmd_payload_first ? (~ b2m_fsm_cmd_maskFirst) : 8'h0) | (io_write_cmd_payload_last ? (~ b2m_fsm_cmd_maskLast) : 8'h0)));
  assign io_write_cmd_payload_fragment_length = b2m_fsm_sel_bytesInBurst;
  assign io_write_cmd_payload_fragment_source = b2m_fsm_sel_channel;
  assign b2m_fsm_cmd_doPtrIncr = (b2m_fsm_sel_valid && (b2m_fsm_aggregate_engine_io_output_consumed || (((io_write_cmd_valid && io_write_cmd_ready) && io_write_cmd_payload_last) && (b2m_fsm_aggregate_engine_io_output_usedUntil == 3'b111))));
  assign b2m_fsm_cmd_context_channel = b2m_fsm_sel_channel;
  assign b2m_fsm_cmd_context_length = b2m_fsm_sel_bytesInBurst;
  assign b2m_fsm_cmd_context_doPacketSync = (b2m_fsm_sel_packet && b2m_fsm_fifoCompletion);
  assign io_write_cmd_payload_fragment_context = {b2m_fsm_cmd_context_doPacketSync,{b2m_fsm_cmd_context_length,b2m_fsm_cmd_context_channel}};
  assign _zz_43 = ({1'd0,1'b1} <<< b2m_fsm_sel_channel);
  assign _zz_44 = (b2m_fsm_aggregate_engine_io_output_usedUntil + 3'b001);
  assign io_write_rsp_ready = 1'b1;
  assign _zz_45 = io_write_rsp_payload_fragment_context;
  assign b2m_rsp_context_channel = _zz_45[0 : 0];
  assign b2m_rsp_context_length = _zz_45[11 : 1];
  assign b2m_rsp_context_doPacketSync = _zz_300[0];
  assign _zz_46 = ({1'd0,1'b1} <<< b2m_rsp_context_channel);
  assign _zz_47 = {channels_3_ll_requestLl,{channels_2_ll_requestLl,{channels_1_ll_requestLl,channels_0_ll_requestLl}}};
  assign _zz_48 = (_zz_47 & (~ _zz_301));
  assign _zz_49 = _zz_48[1];
  assign _zz_50 = _zz_48[2];
  assign _zz_51 = _zz_48[3];
  always @ (*) begin
    _zz_52[0] = channels_0_ll_requestLl;
    _zz_52[1] = _zz_49;
    _zz_52[2] = _zz_50;
    _zz_52[3] = _zz_51;
  end

  assign _zz_53 = _zz_52[3];
  assign _zz_54 = (_zz_52[1] || _zz_53);
  assign _zz_55 = (_zz_52[2] || _zz_53);
  assign ll_arbiter_head = _zz_149;
  always @ (*) begin
    _zz_56[0] = channels_0_ll_requestLl;
    _zz_56[1] = _zz_49;
    _zz_56[2] = _zz_50;
    _zz_56[3] = _zz_51;
  end

  assign _zz_57 = _zz_56[3];
  assign _zz_58 = (_zz_56[1] || _zz_57);
  assign _zz_59 = (_zz_56[2] || _zz_57);
  assign ll_arbiter_isJustASink = _zz_150;
  always @ (*) begin
    _zz_60[0] = channels_0_ll_requestLl;
    _zz_60[1] = _zz_49;
    _zz_60[2] = _zz_50;
    _zz_60[3] = _zz_51;
  end

  assign _zz_61 = _zz_60[3];
  assign _zz_62 = (_zz_60[1] || _zz_61);
  assign _zz_63 = (_zz_60[2] || _zz_61);
  always @ (*) begin
    _zz_64[0] = channels_0_ll_requestLl;
    _zz_64[1] = _zz_49;
    _zz_64[2] = _zz_50;
    _zz_64[3] = _zz_51;
  end

  assign _zz_65 = _zz_64[3];
  assign _zz_66 = (_zz_64[1] || _zz_65);
  assign _zz_67 = (_zz_64[2] || _zz_65);
  always @ (*) begin
    _zz_68[0] = channels_0_ll_requestLl;
    _zz_68[1] = _zz_50;
  end

  always @ (*) begin
    _zz_69[0] = channels_0_ll_requestLl;
    _zz_69[1] = _zz_49;
    _zz_69[2] = _zz_50;
    _zz_69[3] = _zz_51;
  end

  assign _zz_70 = _zz_69[3];
  assign _zz_71 = (_zz_69[1] || _zz_70);
  assign _zz_72 = (_zz_69[2] || _zz_70);
  assign _zz_73 = (ll_cmd_oh_1 || ll_cmd_oh_3);
  assign _zz_74 = (ll_cmd_oh_2 || ll_cmd_oh_3);
  assign ll_cmd_context_channel = {_zz_74,_zz_73};
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
  assign ll_cmd_writeDataSplit_0 = io_sgWrite_cmd_payload_fragment_data[31 : 0];
  assign ll_cmd_writeDataSplit_1 = io_sgWrite_cmd_payload_fragment_data[63 : 32];
  assign _zz_447 = zz_io_sgWrite_cmd_payload_fragment_mask(1'b0);
  always @ (*) io_sgWrite_cmd_payload_fragment_mask = _zz_447;
  always @ (*) begin
    io_sgWrite_cmd_payload_fragment_data[63 : 32] = 32'h0;
    io_sgWrite_cmd_payload_fragment_data[31 : 0] = 32'h0;
    io_sgWrite_cmd_payload_fragment_data[26 : 0] = ll_cmd_bytesDone;
    io_sgWrite_cmd_payload_fragment_data[30] = ll_cmd_endOfPacket;
    io_sgWrite_cmd_payload_fragment_data[31] = (! ll_cmd_isJustASink);
  end

  assign ll_readRsp_context_channel = io_sgRead_rsp_payload_fragment_context[1 : 0];
  always @ (*) begin
    _zz_75[0] = (ll_readRsp_context_channel == 2'b00);
    _zz_75[1] = (ll_readRsp_context_channel == 2'b01);
    _zz_75[2] = (ll_readRsp_context_channel == 2'b10);
    _zz_75[3] = (ll_readRsp_context_channel == 2'b11);
  end

  assign ll_readRsp_oh_0 = _zz_75[0];
  assign ll_readRsp_oh_1 = _zz_75[1];
  assign ll_readRsp_oh_2 = _zz_75[2];
  assign ll_readRsp_oh_3 = _zz_75[3];
  assign io_sgRead_rsp_ready = 1'b1;
  assign ll_writeRsp_context_channel = io_sgWrite_rsp_payload_fragment_context[1 : 0];
  always @ (*) begin
    _zz_76[0] = (ll_writeRsp_context_channel == 2'b00);
    _zz_76[1] = (ll_writeRsp_context_channel == 2'b01);
    _zz_76[2] = (ll_writeRsp_context_channel == 2'b10);
    _zz_76[3] = (ll_writeRsp_context_channel == 2'b11);
  end

  assign ll_writeRsp_oh_0 = _zz_76[0];
  assign ll_writeRsp_oh_1 = _zz_76[1];
  assign ll_writeRsp_oh_2 = _zz_76[2];
  assign ll_writeRsp_oh_3 = _zz_76[3];
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
    _zz_77 = 1'b0;
    case(io_ctrl_PADDR)
      14'h002c : begin
        if(ctrl_doWrite)begin
          _zz_77 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_78 = 1'b0;
    case(io_ctrl_PADDR)
      14'h002c : begin
        if(ctrl_doWrite)begin
          _zz_78 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_79 = 1'b0;
    case(io_ctrl_PADDR)
      14'h002c : begin
        if(ctrl_doWrite)begin
          _zz_79 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_80 = 1'b0;
    case(io_ctrl_PADDR)
      14'h002c : begin
        if(ctrl_doWrite)begin
          _zz_80 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_81 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0054 : begin
        if(ctrl_doWrite)begin
          _zz_81 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_82 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0054 : begin
        if(ctrl_doWrite)begin
          _zz_82 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_83 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0054 : begin
        if(ctrl_doWrite)begin
          _zz_83 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_84 = 1'b0;
    case(io_ctrl_PADDR)
      14'h0054 : begin
        if(ctrl_doWrite)begin
          _zz_84 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_85 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00ac : begin
        if(ctrl_doWrite)begin
          _zz_85 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_86 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00ac : begin
        if(ctrl_doWrite)begin
          _zz_86 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_87 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00ac : begin
        if(ctrl_doWrite)begin
          _zz_87 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_88 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00ac : begin
        if(ctrl_doWrite)begin
          _zz_88 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_89 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00d4 : begin
        if(ctrl_doWrite)begin
          _zz_89 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_90 = 1'b0;
    case(io_ctrl_PADDR)
      14'h00d4 : begin
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
      14'h00d4 : begin
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
      14'h012c : begin
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
      14'h012c : begin
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
      14'h012c : begin
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
      14'h012c : begin
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
      14'h0154 : begin
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
      14'h0154 : begin
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
      14'h0154 : begin
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
      14'h0154 : begin
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
      14'h01ac : begin
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
      14'h01ac : begin
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
      14'h01ac : begin
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
      14'h01ac : begin
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
      14'h01d4 : begin
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
      14'h01d4 : begin
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
      14'h01d4 : begin
        if(ctrl_doWrite)begin
          _zz_106 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign channels_0_fifo_push_ptrIncr_value = _zz_413;
  assign channels_0_fifo_pop_bytesIncr_value = _zz_415;
  assign channels_0_fifo_pop_bytesDecr_value = channels_0_pop_b2m_decrBytes;
  assign channels_0_fifo_pop_ptrIncr_value = _zz_417;
  assign channels_1_fifo_push_ptrIncr_value = _zz_419;
  assign channels_1_fifo_pop_bytesIncr_value = _zz_421;
  assign channels_1_fifo_pop_bytesDecr_value = 14'h0;
  assign channels_1_fifo_pop_ptrIncr_value = _zz_424;
  assign channels_2_fifo_push_ptrIncr_value = _zz_426;
  assign channels_2_fifo_pop_bytesIncr_value = _zz_428;
  assign channels_2_fifo_pop_bytesDecr_value = channels_2_pop_b2m_decrBytes;
  assign channels_2_fifo_pop_ptrIncr_value = _zz_430;
  assign channels_3_fifo_push_ptrIncr_value = _zz_432;
  assign channels_3_fifo_pop_bytesIncr_value = _zz_434;
  assign channels_3_fifo_pop_bytesDecr_value = 14'h0;
  assign channels_3_fifo_pop_ptrIncr_value = _zz_437;
  always @ (posedge clk) begin
    if(reset) begin
      channels_0_channelValid <= 1'b0;
      channels_0_descriptorValid <= 1'b0;
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
      m2b_cmd_s1_valid <= 1'b0;
      m2b_rsp_first <= 1'b1;
      b2m_fsm_sel_valid <= 1'b0;
      b2m_fsm_sel_valid_regNext <= 1'b0;
      b2m_fsm_s1 <= 1'b0;
      b2m_fsm_s2 <= 1'b0;
      b2m_fsm_toggle <= 1'b0;
      memory_core_io_reads_2_rsp_s2mPipe_rValid <= 1'b0;
      _zz_41 <= 1'b0;
      io_write_cmd_payload_first <= 1'b1;
      ll_cmd_valid <= 1'b0;
      ll_readRsp_beatCounter <= 2'b00;
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
      if(_zz_154)begin
        if(_zz_155)begin
          if(! _zz_156) begin
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
      channels_0_pop_b2m_memPending <= (_zz_201 - _zz_205);
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
      if(_zz_165)begin
        if(_zz_166)begin
          if(! _zz_167) begin
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
      channels_1_push_m2b_memPending <= (_zz_211 - _zz_215);
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
      if(_zz_174)begin
        if(_zz_175)begin
          if(! _zz_176) begin
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
      channels_2_pop_b2m_memPending <= (_zz_229 - _zz_233);
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
      if(_zz_183)begin
        if(_zz_184)begin
          if(! _zz_185) begin
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
      channels_3_push_m2b_memPending <= (_zz_239 - _zz_243);
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
      if(_zz_171)begin
        if(_zz_172)begin
          m2b_cmd_s0_valid <= 1'b1;
        end
      end
      if(m2b_cmd_s0_valid)begin
        m2b_cmd_s1_valid <= 1'b1;
      end
      if(m2b_cmd_s1_valid)begin
        if(io_read_cmd_ready)begin
          m2b_cmd_s0_valid <= 1'b0;
          m2b_cmd_s1_valid <= 1'b0;
          if(_zz_170)begin
            if(m2b_cmd_s1_lastBurst)begin
              channels_1_push_m2b_loadDone <= 1'b1;
            end
          end
          if(_zz_188)begin
            if(m2b_cmd_s1_lastBurst)begin
              channels_3_push_m2b_loadDone <= 1'b1;
            end
          end
        end
      end
      if((io_read_rsp_valid && io_read_rsp_ready))begin
        m2b_rsp_first <= io_read_rsp_payload_last;
      end
      if(b2m_fsm_sel_ready)begin
        b2m_fsm_sel_valid <= 1'b0;
      end
      if(_zz_162)begin
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
      if(_zz_191)begin
        memory_core_io_reads_2_rsp_s2mPipe_rValid <= memory_core_io_reads_2_rsp_valid;
      end
      _zz_41 <= (b2m_fsm_sel_valid && (! b2m_fsm_sel_ready));
      if((io_write_cmd_valid && io_write_cmd_ready))begin
        io_write_cmd_payload_first <= io_write_cmd_payload_last;
      end
      if(_zz_192)begin
        if(({_zz_51,{_zz_50,{_zz_49,channels_0_ll_requestLl}}} != 4'b0000))begin
          ll_cmd_valid <= 1'b1;
        end
      end else begin
        if((ll_cmd_writeFired && ll_cmd_readFired))begin
          ll_cmd_valid <= 1'b0;
        end
      end
      if(_zz_193)begin
        ll_readRsp_beatCounter <= (ll_readRsp_beatCounter + 2'b01);
      end
      if(_zz_78)begin
        if(_zz_310[0])begin
          channels_0_ctrl_kick <= _zz_311[0];
        end
      end
      if(_zz_81)begin
        if(_zz_316[0])begin
          channels_0_interrupts_completion_valid <= _zz_317[0];
        end
      end
      if(_zz_82)begin
        if(_zz_318[0])begin
          channels_0_interrupts_onChannelCompletion_valid <= _zz_319[0];
        end
      end
      if(_zz_83)begin
        if(_zz_320[0])begin
          channels_0_interrupts_onLinkedListUpdate_valid <= _zz_321[0];
        end
      end
      if(_zz_84)begin
        if(_zz_322[0])begin
          channels_0_interrupts_s2mPacket_valid <= _zz_323[0];
        end
      end
      if(_zz_86)begin
        if(_zz_326[0])begin
          channels_1_ctrl_kick <= _zz_327[0];
        end
      end
      if(_zz_89)begin
        if(_zz_332[0])begin
          channels_1_interrupts_completion_valid <= _zz_333[0];
        end
      end
      if(_zz_90)begin
        if(_zz_334[0])begin
          channels_1_interrupts_onChannelCompletion_valid <= _zz_335[0];
        end
      end
      if(_zz_91)begin
        if(_zz_336[0])begin
          channels_1_interrupts_onLinkedListUpdate_valid <= _zz_337[0];
        end
      end
      if(_zz_93)begin
        if(_zz_340[0])begin
          channels_2_ctrl_kick <= _zz_341[0];
        end
      end
      if(_zz_96)begin
        if(_zz_346[0])begin
          channels_2_interrupts_completion_valid <= _zz_347[0];
        end
      end
      if(_zz_97)begin
        if(_zz_348[0])begin
          channels_2_interrupts_onChannelCompletion_valid <= _zz_349[0];
        end
      end
      if(_zz_98)begin
        if(_zz_350[0])begin
          channels_2_interrupts_onLinkedListUpdate_valid <= _zz_351[0];
        end
      end
      if(_zz_99)begin
        if(_zz_352[0])begin
          channels_2_interrupts_s2mPacket_valid <= _zz_353[0];
        end
      end
      if(_zz_101)begin
        if(_zz_356[0])begin
          channels_3_ctrl_kick <= _zz_357[0];
        end
      end
      if(_zz_104)begin
        if(_zz_362[0])begin
          channels_3_interrupts_completion_valid <= _zz_363[0];
        end
      end
      if(_zz_105)begin
        if(_zz_364[0])begin
          channels_3_interrupts_onChannelCompletion_valid <= _zz_365[0];
        end
      end
      if(_zz_106)begin
        if(_zz_366[0])begin
          channels_3_interrupts_onLinkedListUpdate_valid <= _zz_367[0];
        end
      end
      case(io_ctrl_PADDR)
        14'h0050 : begin
          if(ctrl_doWrite)begin
            channels_0_interrupts_completion_enable <= _zz_376[0];
            channels_0_interrupts_onChannelCompletion_enable <= _zz_377[0];
            channels_0_interrupts_onLinkedListUpdate_enable <= _zz_378[0];
            channels_0_interrupts_s2mPacket_enable <= _zz_379[0];
          end
        end
        14'h00d0 : begin
          if(ctrl_doWrite)begin
            channels_1_interrupts_completion_enable <= _zz_387[0];
            channels_1_interrupts_onChannelCompletion_enable <= _zz_388[0];
            channels_1_interrupts_onLinkedListUpdate_enable <= _zz_389[0];
          end
        end
        14'h0150 : begin
          if(ctrl_doWrite)begin
            channels_2_interrupts_completion_enable <= _zz_398[0];
            channels_2_interrupts_onChannelCompletion_enable <= _zz_399[0];
            channels_2_interrupts_onLinkedListUpdate_enable <= _zz_400[0];
            channels_2_interrupts_s2mPacket_enable <= _zz_401[0];
          end
        end
        14'h01d0 : begin
          if(ctrl_doWrite)begin
            channels_3_interrupts_completion_enable <= _zz_409[0];
            channels_3_interrupts_onChannelCompletion_enable <= _zz_410[0];
            channels_3_interrupts_onLinkedListUpdate_enable <= _zz_411[0];
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    if(channels_0_bytesProbe_incr_valid)begin
      channels_0_bytesProbe_value <= (_zz_194 + 27'h0000001);
    end
    if(channels_0_descriptorStart)begin
      channels_0_ll_packet <= 1'b0;
    end
    if(channels_0_descriptorStart)begin
      channels_0_ll_requireSync <= 1'b0;
    end
    if(_zz_154)begin
      channels_0_ll_waitDone <= 1'b0;
      if(_zz_155)begin
        channels_0_ll_head <= 1'b0;
      end
    end
    if(channels_0_channelStart)begin
      channels_0_ll_waitDone <= 1'b0;
      channels_0_ll_head <= 1'b1;
    end
    channels_0_fifo_push_ptr <= (channels_0_fifo_push_ptr + channels_0_fifo_push_ptrIncr_value);
    if(channels_0_channelStart)begin
      channels_0_fifo_push_ptr <= 11'h0;
    end
    channels_0_fifo_pop_ptr <= (channels_0_fifo_pop_ptr + channels_0_fifo_pop_ptrIncr_value);
    channels_0_fifo_pop_withOverride_backup <= channels_0_fifo_pop_withOverride_backupNext;
    if((channels_0_channelStart || channels_0_fifo_pop_withOverride_unload))begin
      channels_0_fifo_pop_withOverride_valid <= 1'b0;
    end
    if(channels_0_fifo_pop_withOverride_load)begin
      channels_0_fifo_pop_withOverride_valid <= 1'b1;
    end
    channels_0_fifo_pop_withOverride_exposed <= ((! channels_0_fifo_pop_withOverride_valid) ? channels_0_fifo_pop_withOverride_backupNext : _zz_197);
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
    if((channels_0_pop_b2m_bytesLeft < _zz_206))begin
      channels_0_pop_b2m_flush <= 1'b1;
    end
    if(_zz_163)begin
      channels_0_pop_b2m_flush <= 1'b0;
      channels_0_pop_b2m_packet <= 1'b0;
    end
    if(channels_0_pop_b2m_packetSync)begin
      channels_0_push_s2b_packetLock <= 1'b0;
      if(_zz_159)begin
        if(! channels_0_push_s2b_completionOnLast) begin
          if((! channels_0_pop_b2m_waitFinalRsp))begin
            channels_0_ll_requireSync <= 1'b1;
          end
        end
        channels_0_ll_packet <= 1'b1;
      end
    end
    if(channels_0_channelStart)begin
      channels_0_pop_b2m_bytesToSkip <= 3'b000;
      channels_0_pop_b2m_flush <= 1'b0;
    end
    if(channels_0_descriptorStart)begin
      channels_0_pop_b2m_bytesLeft <= {1'd0, channels_0_bytes};
      channels_0_pop_b2m_waitFinalRsp <= 1'b0;
    end
    if(channels_0_channelValid)begin
      if(! channels_0_channelStop) begin
        if(_zz_157)begin
          if(_zz_158)begin
            channels_0_pop_b2m_address <= (_zz_207 - 32'h00000001);
          end
          if((_zz_1 && channels_0_readyForChannelCompletion))begin
            channels_0_channelStop <= 1'b1;
          end
        end
      end
    end
    channels_0_fifo_pop_ptrIncr_value_regNext <= channels_0_fifo_pop_ptrIncr_value;
    channels_0_fifo_push_available <= (_zz_209 - (channels_0_push_memory ? channels_0_fifo_push_availableDecr : channels_0_fifo_push_ptrIncr_value));
    if(channels_0_channelStart)begin
      channels_0_fifo_push_ptr <= 11'h0;
      channels_0_fifo_push_available <= (channels_0_fifo_words + 11'h001);
      channels_0_fifo_pop_ptr <= 11'h0;
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
    if(_zz_165)begin
      channels_1_ll_waitDone <= 1'b0;
      if(_zz_166)begin
        channels_1_ll_head <= 1'b0;
      end
    end
    if(channels_1_channelStart)begin
      channels_1_ll_waitDone <= 1'b0;
      channels_1_ll_head <= 1'b1;
    end
    channels_1_fifo_push_ptr <= (channels_1_fifo_push_ptr + channels_1_fifo_push_ptrIncr_value);
    if(channels_1_channelStart)begin
      channels_1_fifo_push_ptr <= 11'h0;
    end
    channels_1_fifo_pop_ptr <= (channels_1_fifo_pop_ptr + channels_1_fifo_pop_ptrIncr_value);
    channels_1_fifo_pop_withoutOverride_exposed <= (_zz_210 - channels_1_fifo_pop_bytesDecr_value);
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
        if(_zz_168)begin
          if(_zz_169)begin
            channels_1_push_m2b_address <= (_zz_219 - 32'h00000001);
          end
          if((_zz_2 && channels_1_readyForChannelCompletion))begin
            channels_1_channelStop <= 1'b1;
          end
        end
      end
    end
    channels_1_fifo_pop_ptrIncr_value_regNext <= channels_1_fifo_pop_ptrIncr_value;
    channels_1_fifo_push_available <= (_zz_221 - (channels_1_push_memory ? channels_1_fifo_push_availableDecr : channels_1_fifo_push_ptrIncr_value));
    if(channels_1_channelStart)begin
      channels_1_fifo_push_ptr <= 11'h0;
      channels_1_fifo_push_available <= (channels_1_fifo_words + 11'h001);
      channels_1_fifo_pop_ptr <= 11'h0;
    end
    if(channels_2_bytesProbe_incr_valid)begin
      channels_2_bytesProbe_value <= (_zz_222 + 27'h0000001);
    end
    if(channels_2_descriptorStart)begin
      channels_2_ll_packet <= 1'b0;
    end
    if(channels_2_descriptorStart)begin
      channels_2_ll_requireSync <= 1'b0;
    end
    if(_zz_174)begin
      channels_2_ll_waitDone <= 1'b0;
      if(_zz_175)begin
        channels_2_ll_head <= 1'b0;
      end
    end
    if(channels_2_channelStart)begin
      channels_2_ll_waitDone <= 1'b0;
      channels_2_ll_head <= 1'b1;
    end
    channels_2_fifo_push_ptr <= (channels_2_fifo_push_ptr + channels_2_fifo_push_ptrIncr_value);
    if(channels_2_channelStart)begin
      channels_2_fifo_push_ptr <= 11'h0;
    end
    channels_2_fifo_pop_ptr <= (channels_2_fifo_pop_ptr + channels_2_fifo_pop_ptrIncr_value);
    channels_2_fifo_pop_withOverride_backup <= channels_2_fifo_pop_withOverride_backupNext;
    if((channels_2_channelStart || channels_2_fifo_pop_withOverride_unload))begin
      channels_2_fifo_pop_withOverride_valid <= 1'b0;
    end
    if(channels_2_fifo_pop_withOverride_load)begin
      channels_2_fifo_pop_withOverride_valid <= 1'b1;
    end
    channels_2_fifo_pop_withOverride_exposed <= ((! channels_2_fifo_pop_withOverride_valid) ? channels_2_fifo_pop_withOverride_backupNext : _zz_225);
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
    if((channels_2_pop_b2m_bytesLeft < _zz_234))begin
      channels_2_pop_b2m_flush <= 1'b1;
    end
    if(_zz_181)begin
      channels_2_pop_b2m_flush <= 1'b0;
      channels_2_pop_b2m_packet <= 1'b0;
    end
    if(channels_2_pop_b2m_packetSync)begin
      channels_2_push_s2b_packetLock <= 1'b0;
      if(_zz_179)begin
        if(! channels_2_push_s2b_completionOnLast) begin
          if((! channels_2_pop_b2m_waitFinalRsp))begin
            channels_2_ll_requireSync <= 1'b1;
          end
        end
        channels_2_ll_packet <= 1'b1;
      end
    end
    if(channels_2_channelStart)begin
      channels_2_pop_b2m_bytesToSkip <= 3'b000;
      channels_2_pop_b2m_flush <= 1'b0;
    end
    if(channels_2_descriptorStart)begin
      channels_2_pop_b2m_bytesLeft <= {1'd0, channels_2_bytes};
      channels_2_pop_b2m_waitFinalRsp <= 1'b0;
    end
    if(channels_2_channelValid)begin
      if(! channels_2_channelStop) begin
        if(_zz_177)begin
          if(_zz_178)begin
            channels_2_pop_b2m_address <= (_zz_235 - 32'h00000001);
          end
          if((_zz_3 && channels_2_readyForChannelCompletion))begin
            channels_2_channelStop <= 1'b1;
          end
        end
      end
    end
    channels_2_fifo_pop_ptrIncr_value_regNext <= channels_2_fifo_pop_ptrIncr_value;
    channels_2_fifo_push_available <= (_zz_237 - (channels_2_push_memory ? channels_2_fifo_push_availableDecr : channels_2_fifo_push_ptrIncr_value));
    if(channels_2_channelStart)begin
      channels_2_fifo_push_ptr <= 11'h0;
      channels_2_fifo_push_available <= (channels_2_fifo_words + 11'h001);
      channels_2_fifo_pop_ptr <= 11'h0;
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
    if(_zz_183)begin
      channels_3_ll_waitDone <= 1'b0;
      if(_zz_184)begin
        channels_3_ll_head <= 1'b0;
      end
    end
    if(channels_3_channelStart)begin
      channels_3_ll_waitDone <= 1'b0;
      channels_3_ll_head <= 1'b1;
    end
    channels_3_fifo_push_ptr <= (channels_3_fifo_push_ptr + channels_3_fifo_push_ptrIncr_value);
    if(channels_3_channelStart)begin
      channels_3_fifo_push_ptr <= 11'h0;
    end
    channels_3_fifo_pop_ptr <= (channels_3_fifo_pop_ptr + channels_3_fifo_pop_ptrIncr_value);
    channels_3_fifo_pop_withoutOverride_exposed <= (_zz_238 - channels_3_fifo_pop_bytesDecr_value);
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
        if(_zz_186)begin
          if(_zz_187)begin
            channels_3_push_m2b_address <= (_zz_247 - 32'h00000001);
          end
          if((_zz_4 && channels_3_readyForChannelCompletion))begin
            channels_3_channelStop <= 1'b1;
          end
        end
      end
    end
    channels_3_fifo_pop_ptrIncr_value_regNext <= channels_3_fifo_pop_ptrIncr_value;
    channels_3_fifo_push_available <= (_zz_249 - (channels_3_push_memory ? channels_3_fifo_push_availableDecr : channels_3_fifo_push_ptrIncr_value));
    if(channels_3_channelStart)begin
      channels_3_fifo_push_ptr <= 11'h0;
      channels_3_fifo_push_available <= (channels_3_fifo_words + 11'h001);
      channels_3_fifo_pop_ptr <= 11'h0;
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
    if(_zz_171)begin
      m2b_cmd_s0_chosen <= m2b_cmd_arbiter_io_chosen;
    end
    m2b_cmd_s1_address <= m2b_cmd_s0_address;
    m2b_cmd_s1_length <= m2b_cmd_s0_length;
    m2b_cmd_s1_lastBurst <= m2b_cmd_s0_lastBurst;
    m2b_cmd_s1_bytesLeft <= m2b_cmd_s0_bytesLeft;
    if(m2b_cmd_s1_valid)begin
      if(io_read_cmd_ready)begin
        if(_zz_170)begin
          channels_1_push_m2b_address <= m2b_cmd_s1_addressNext;
          channels_1_push_m2b_bytesLeft <= m2b_cmd_s1_byteLeftNext;
        end
        if(_zz_188)begin
          channels_3_push_m2b_address <= m2b_cmd_s1_addressNext;
          channels_3_push_m2b_bytesLeft <= m2b_cmd_s1_byteLeftNext;
        end
      end
    end
    if(_zz_162)begin
      b2m_fsm_sel_channel <= b2m_fsm_arbiter_core_io_chosen;
      b2m_fsm_sel_address <= _zz_139;
      b2m_fsm_sel_ptr <= _zz_140;
      b2m_fsm_sel_ptrMask <= _zz_141;
      b2m_fsm_sel_bytePerBurst <= _zz_142;
      b2m_fsm_sel_bytesInFifo <= _zz_143;
      b2m_fsm_sel_flush <= _zz_144;
      b2m_fsm_sel_packet <= _zz_145;
      b2m_fsm_sel_bytesLeft <= _zz_146[25:0];
    end
    if(b2m_fsm_s0)begin
      b2m_fsm_sel_bytesInBurst <= _zz_289[10:0];
    end
    if(b2m_fsm_s1)begin
      b2m_fsm_beatCounter <= (_zz_294 >>> 3);
      if(_zz_164)begin
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
      if(_zz_182)begin
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
      b2m_fsm_sel_ptr <= ((b2m_fsm_sel_ptr & (~ b2m_fsm_sel_ptrMask)) | (_zz_297 & b2m_fsm_sel_ptrMask));
    end
    if(_zz_191)begin
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
    b2m_fsm_cmd_maskLast <= _zz_42;
    if((io_write_cmd_valid && io_write_cmd_ready))begin
      b2m_fsm_beatCounter <= (b2m_fsm_beatCounter - 8'h01);
    end
    if(_zz_189)begin
      if(_zz_43[0])begin
        channels_0_pop_b2m_bytesToSkip <= _zz_44;
      end
      if(_zz_43[1])begin
        channels_2_pop_b2m_bytesToSkip <= _zz_44;
      end
    end
    if((! ll_cmd_valid))begin
      ll_cmd_oh_0 <= channels_0_ll_requestLl;
      ll_cmd_oh_1 <= _zz_49;
      ll_cmd_oh_2 <= _zz_50;
      ll_cmd_oh_3 <= _zz_51;
    end
    if((! ll_cmd_valid))begin
      ll_cmd_ptr <= _zz_151;
    end
    if((! ll_cmd_valid))begin
      ll_cmd_ptrNext <= _zz_152;
    end
    if((! ll_cmd_valid))begin
      ll_cmd_bytesDone <= (_zz_68[0] ? channels_0_bytesProbe_value : channels_2_bytesProbe_value);
    end
    if((! ll_cmd_valid))begin
      ll_cmd_endOfPacket <= _zz_153;
    end
    if((! ll_cmd_valid))begin
      ll_cmd_isJustASink <= ll_arbiter_isJustASink;
    end
    if(_zz_192)begin
      ll_cmd_oh_0 <= channels_0_ll_requestLl;
      ll_cmd_oh_1 <= _zz_49;
      ll_cmd_oh_2 <= _zz_50;
      ll_cmd_oh_3 <= _zz_51;
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
      if(_zz_49)begin
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
      if(_zz_50)begin
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
      if(_zz_51)begin
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
    if(_zz_193)begin
      if((2'b01 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_1)begin
          channels_1_push_m2b_address <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
        if(ll_readRsp_oh_3)begin
          channels_3_push_m2b_address <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
      end
      if((2'b10 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_0)begin
          channels_0_pop_b2m_address <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
        if(ll_readRsp_oh_2)begin
          channels_2_pop_b2m_address <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
      end
      if((2'b11 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_0)begin
          channels_0_ll_ptrNext <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
        if(ll_readRsp_oh_1)begin
          channels_1_ll_ptrNext <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
        if(ll_readRsp_oh_2)begin
          channels_2_ll_ptrNext <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
        if(ll_readRsp_oh_3)begin
          channels_3_ll_ptrNext <= io_sgRead_rsp_payload_fragment_data[31 : 0];
        end
      end
      if((2'b00 == ll_readRsp_beatCounter))begin
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
      if((2'b00 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_1)begin
          channels_1_pop_b2s_last <= _zz_302[0];
        end
        if(ll_readRsp_oh_3)begin
          channels_3_pop_b2s_last <= _zz_303[0];
        end
      end
      if((2'b00 == ll_readRsp_beatCounter))begin
        if(ll_readRsp_oh_0)begin
          channels_0_ll_gotDescriptorStall <= _zz_304[0];
        end
        if(ll_readRsp_oh_1)begin
          channels_1_ll_gotDescriptorStall <= _zz_305[0];
        end
        if(ll_readRsp_oh_2)begin
          channels_2_ll_gotDescriptorStall <= _zz_306[0];
        end
        if(ll_readRsp_oh_3)begin
          channels_3_ll_gotDescriptorStall <= _zz_307[0];
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
          channels_0_push_memory <= _zz_368[0];
          channels_0_push_s2b_completionOnLast <= _zz_369[0];
          channels_0_push_s2b_waitFirst <= _zz_370[0];
        end
      end
      14'h0010 : begin
        if(ctrl_doWrite)begin
          channels_0_pop_b2m_address[31 : 0] <= _zz_372;
        end
      end
      14'h001c : begin
        if(ctrl_doWrite)begin
          channels_0_pop_memory <= _zz_373[0];
        end
      end
      14'h002c : begin
        if(ctrl_doWrite)begin
          channels_0_channelStop <= _zz_374[0];
          channels_0_selfRestart <= _zz_375[0];
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
      14'h0044 : begin
        if(ctrl_doWrite)begin
          channels_0_priority <= io_ctrl_PWDATA[1 : 0];
        end
      end
      14'h0080 : begin
        if(ctrl_doWrite)begin
          channels_1_push_m2b_address[31 : 0] <= _zz_381;
        end
      end
      14'h008c : begin
        if(ctrl_doWrite)begin
          channels_1_push_memory <= _zz_382[0];
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
          channels_1_pop_memory <= _zz_383[0];
          channels_1_pop_b2s_last <= _zz_384[0];
        end
      end
      14'h00ac : begin
        if(ctrl_doWrite)begin
          channels_1_channelStop <= _zz_385[0];
          channels_1_selfRestart <= _zz_386[0];
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
      14'h00c4 : begin
        if(ctrl_doWrite)begin
          channels_1_priority <= io_ctrl_PWDATA[1 : 0];
        end
      end
      14'h010c : begin
        if(ctrl_doWrite)begin
          channels_2_push_memory <= _zz_390[0];
          channels_2_push_s2b_completionOnLast <= _zz_391[0];
          channels_2_push_s2b_waitFirst <= _zz_392[0];
        end
      end
      14'h0110 : begin
        if(ctrl_doWrite)begin
          channels_2_pop_b2m_address[31 : 0] <= _zz_394;
        end
      end
      14'h011c : begin
        if(ctrl_doWrite)begin
          channels_2_pop_memory <= _zz_395[0];
        end
      end
      14'h012c : begin
        if(ctrl_doWrite)begin
          channels_2_channelStop <= _zz_396[0];
          channels_2_selfRestart <= _zz_397[0];
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
      14'h0144 : begin
        if(ctrl_doWrite)begin
          channels_2_priority <= io_ctrl_PWDATA[1 : 0];
        end
      end
      14'h0180 : begin
        if(ctrl_doWrite)begin
          channels_3_push_m2b_address[31 : 0] <= _zz_403;
        end
      end
      14'h018c : begin
        if(ctrl_doWrite)begin
          channels_3_push_memory <= _zz_404[0];
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
          channels_3_pop_memory <= _zz_405[0];
          channels_3_pop_b2s_last <= _zz_406[0];
        end
      end
      14'h01ac : begin
        if(ctrl_doWrite)begin
          channels_3_channelStop <= _zz_407[0];
          channels_3_selfRestart <= _zz_408[0];
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
      14'h01c4 : begin
        if(ctrl_doWrite)begin
          channels_3_priority <= io_ctrl_PWDATA[1 : 0];
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
  input               dat1_o_clk,
  input               dat1_o_reset
);
  reg        [4:0]    buffers_0;
  reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge dat1_o_clk) begin
    if(dat1_o_reset) begin
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
  input               dat0_o_clk,
  input               dat0_o_reset
);
  reg        [4:0]    buffers_0;
  reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge dat0_o_clk) begin
    if(dat0_o_reset) begin
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
  input               dat1_i_clk,
  input               dat1_i_reset
);
  reg        [4:0]    buffers_0;
  reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge dat1_i_clk) begin
    if(dat1_i_reset) begin
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
  reg        [4:0]    buffers_0;
  reg        [4:0]    buffers_1;

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
  input               dat0_i_clk,
  input               dat0_i_reset
);
  reg        [4:0]    buffers_0;
  reg        [4:0]    buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge dat0_i_clk) begin
    if(dat0_i_reset) begin
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
  input      [10:0]   io_input_payload_fragment_length,
  input      [255:0]  io_input_payload_fragment_data,
  input      [31:0]   io_input_payload_fragment_mask,
  output              io_outputs_0_valid,
  input               io_outputs_0_ready,
  output              io_outputs_0_payload_last,
  output     [0:0]    io_outputs_0_payload_fragment_opcode,
  output     [31:0]   io_outputs_0_payload_fragment_address,
  output     [10:0]   io_outputs_0_payload_fragment_length,
  output     [255:0]  io_outputs_0_payload_fragment_data,
  output     [31:0]   io_outputs_0_payload_fragment_mask,
  output              io_outputs_1_valid,
  input               io_outputs_1_ready,
  output              io_outputs_1_payload_last,
  output     [0:0]    io_outputs_1_payload_fragment_opcode,
  output     [31:0]   io_outputs_1_payload_fragment_address,
  output     [10:0]   io_outputs_1_payload_fragment_length,
  output     [255:0]  io_outputs_1_payload_fragment_data,
  output     [31:0]   io_outputs_1_payload_fragment_mask,
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
  input      [10:0]   io_input_cmd_payload_fragment_length,
  input      [255:0]  io_input_cmd_payload_fragment_data,
  input      [31:0]   io_input_cmd_payload_fragment_mask,
  input      [14:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [14:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [10:0]   io_output_cmd_payload_fragment_length,
  output     [255:0]  io_output_cmd_payload_fragment_data,
  output     [31:0]   io_output_cmd_payload_fragment_mask,
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
  wire       [10:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_length;
  wire       [255:0]  io_input_cmd_fork_io_outputs_0_payload_fragment_data;
  wire       [31:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_mask;
  wire       [14:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_1_valid;
  wire                io_input_cmd_fork_io_outputs_1_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_1_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_address;
  wire       [10:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_length;
  wire       [255:0]  io_input_cmd_fork_io_outputs_1_payload_fragment_data;
  wire       [31:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_mask;
  wire       [14:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid;
  wire       [14:0]   io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload;
  wire       [2:0]    io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_occupancy;
  wire       [2:0]    io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_availability;
  wire                _zz_5;
  reg                 io_input_cmd_fork_io_outputs_0_payload_first;
  reg                 io_input_cmd_fork_io_outputs_0_thrown_valid;
  wire                io_input_cmd_fork_io_outputs_0_thrown_ready;
  wire                io_input_cmd_fork_io_outputs_0_thrown_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_address;
  wire       [10:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_length;
  wire       [255:0]  io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_data;
  wire       [31:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_mask;
  wire       [14:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_valid;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_ready;
  wire       [14:0]   io_input_cmd_fork_io_outputs_0_thrown_translated_payload;
  wire                _zz_1;

  assign _zz_5 = (! io_input_cmd_fork_io_outputs_0_payload_first);
  dma_socRuby_StreamFork_1 io_input_cmd_fork (
    .io_input_valid                           (io_input_cmd_valid                                             ), //i
    .io_input_ready                           (io_input_cmd_fork_io_input_ready                               ), //o
    .io_input_payload_last                    (io_input_cmd_payload_last                                      ), //i
    .io_input_payload_fragment_opcode         (io_input_cmd_payload_fragment_opcode                           ), //i
    .io_input_payload_fragment_address        (io_input_cmd_payload_fragment_address[31:0]                    ), //i
    .io_input_payload_fragment_length         (io_input_cmd_payload_fragment_length[10:0]                     ), //i
    .io_input_payload_fragment_data           (io_input_cmd_payload_fragment_data[255:0]                      ), //i
    .io_input_payload_fragment_mask           (io_input_cmd_payload_fragment_mask[31:0]                       ), //i
    .io_input_payload_fragment_context        (io_input_cmd_payload_fragment_context[14:0]                    ), //i
    .io_outputs_0_valid                       (io_input_cmd_fork_io_outputs_0_valid                           ), //o
    .io_outputs_0_ready                       (_zz_2                                                          ), //i
    .io_outputs_0_payload_last                (io_input_cmd_fork_io_outputs_0_payload_last                    ), //o
    .io_outputs_0_payload_fragment_opcode     (io_input_cmd_fork_io_outputs_0_payload_fragment_opcode         ), //o
    .io_outputs_0_payload_fragment_address    (io_input_cmd_fork_io_outputs_0_payload_fragment_address[31:0]  ), //o
    .io_outputs_0_payload_fragment_length     (io_input_cmd_fork_io_outputs_0_payload_fragment_length[10:0]   ), //o
    .io_outputs_0_payload_fragment_data       (io_input_cmd_fork_io_outputs_0_payload_fragment_data[255:0]    ), //o
    .io_outputs_0_payload_fragment_mask       (io_input_cmd_fork_io_outputs_0_payload_fragment_mask[31:0]     ), //o
    .io_outputs_0_payload_fragment_context    (io_input_cmd_fork_io_outputs_0_payload_fragment_context[14:0]  ), //o
    .io_outputs_1_valid                       (io_input_cmd_fork_io_outputs_1_valid                           ), //o
    .io_outputs_1_ready                       (io_output_cmd_ready                                            ), //i
    .io_outputs_1_payload_last                (io_input_cmd_fork_io_outputs_1_payload_last                    ), //o
    .io_outputs_1_payload_fragment_opcode     (io_input_cmd_fork_io_outputs_1_payload_fragment_opcode         ), //o
    .io_outputs_1_payload_fragment_address    (io_input_cmd_fork_io_outputs_1_payload_fragment_address[31:0]  ), //o
    .io_outputs_1_payload_fragment_length     (io_input_cmd_fork_io_outputs_1_payload_fragment_length[10:0]   ), //o
    .io_outputs_1_payload_fragment_data       (io_input_cmd_fork_io_outputs_1_payload_fragment_data[255:0]    ), //o
    .io_outputs_1_payload_fragment_mask       (io_input_cmd_fork_io_outputs_1_payload_fragment_mask[31:0]     ), //o
    .io_outputs_1_payload_fragment_context    (io_input_cmd_fork_io_outputs_1_payload_fragment_context[14:0]  ), //o
    .clk                                      (clk                                                            ), //i
    .reset                                    (reset                                                          )  //i
  );
  dma_socRuby_StreamFifo_1 io_input_cmd_fork_io_outputs_0_thrown_translated_fifo (
    .io_push_valid      (io_input_cmd_fork_io_outputs_0_thrown_translated_valid                      ), //i
    .io_push_ready      (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready         ), //o
    .io_push_payload    (io_input_cmd_fork_io_outputs_0_thrown_translated_payload[14:0]              ), //i
    .io_pop_valid       (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid          ), //o
    .io_pop_ready       (_zz_3                                                                       ), //i
    .io_pop_payload     (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload[14:0]  ), //o
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

module dma_socRuby_BmbContextRemover (
  input               io_input_cmd_valid,
  output              io_input_cmd_ready,
  input               io_input_cmd_payload_last,
  input      [0:0]    io_input_cmd_payload_fragment_opcode,
  input      [31:0]   io_input_cmd_payload_fragment_address,
  input      [10:0]   io_input_cmd_payload_fragment_length,
  input      [24:0]   io_input_cmd_payload_fragment_context,
  output              io_input_rsp_valid,
  input               io_input_rsp_ready,
  output              io_input_rsp_payload_last,
  output     [0:0]    io_input_rsp_payload_fragment_opcode,
  output     [255:0]  io_input_rsp_payload_fragment_data,
  output     [24:0]   io_input_rsp_payload_fragment_context,
  output              io_output_cmd_valid,
  input               io_output_cmd_ready,
  output              io_output_cmd_payload_last,
  output     [0:0]    io_output_cmd_payload_fragment_opcode,
  output     [31:0]   io_output_cmd_payload_fragment_address,
  output     [10:0]   io_output_cmd_payload_fragment_length,
  input               io_output_rsp_valid,
  output              io_output_rsp_ready,
  input               io_output_rsp_payload_last,
  input      [0:0]    io_output_rsp_payload_fragment_opcode,
  input      [255:0]  io_output_rsp_payload_fragment_data,
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
  wire       [10:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_length;
  wire       [24:0]   io_input_cmd_fork_io_outputs_0_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_1_valid;
  wire                io_input_cmd_fork_io_outputs_1_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_1_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_address;
  wire       [10:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_length;
  wire       [24:0]   io_input_cmd_fork_io_outputs_1_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid;
  wire       [24:0]   io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload;
  wire       [2:0]    io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_occupancy;
  wire       [2:0]    io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_availability;
  wire                _zz_5;
  reg                 io_input_cmd_fork_io_outputs_0_payload_first;
  reg                 io_input_cmd_fork_io_outputs_0_thrown_valid;
  wire                io_input_cmd_fork_io_outputs_0_thrown_ready;
  wire                io_input_cmd_fork_io_outputs_0_thrown_payload_last;
  wire       [0:0]    io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_opcode;
  wire       [31:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_address;
  wire       [10:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_length;
  wire       [24:0]   io_input_cmd_fork_io_outputs_0_thrown_payload_fragment_context;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_valid;
  wire                io_input_cmd_fork_io_outputs_0_thrown_translated_ready;
  wire       [24:0]   io_input_cmd_fork_io_outputs_0_thrown_translated_payload;
  wire                _zz_1;

  assign _zz_5 = (! io_input_cmd_fork_io_outputs_0_payload_first);
  dma_socRuby_StreamFork io_input_cmd_fork (
    .io_input_valid                           (io_input_cmd_valid                                             ), //i
    .io_input_ready                           (io_input_cmd_fork_io_input_ready                               ), //o
    .io_input_payload_last                    (io_input_cmd_payload_last                                      ), //i
    .io_input_payload_fragment_opcode         (io_input_cmd_payload_fragment_opcode                           ), //i
    .io_input_payload_fragment_address        (io_input_cmd_payload_fragment_address[31:0]                    ), //i
    .io_input_payload_fragment_length         (io_input_cmd_payload_fragment_length[10:0]                     ), //i
    .io_input_payload_fragment_context        (io_input_cmd_payload_fragment_context[24:0]                    ), //i
    .io_outputs_0_valid                       (io_input_cmd_fork_io_outputs_0_valid                           ), //o
    .io_outputs_0_ready                       (_zz_2                                                          ), //i
    .io_outputs_0_payload_last                (io_input_cmd_fork_io_outputs_0_payload_last                    ), //o
    .io_outputs_0_payload_fragment_opcode     (io_input_cmd_fork_io_outputs_0_payload_fragment_opcode         ), //o
    .io_outputs_0_payload_fragment_address    (io_input_cmd_fork_io_outputs_0_payload_fragment_address[31:0]  ), //o
    .io_outputs_0_payload_fragment_length     (io_input_cmd_fork_io_outputs_0_payload_fragment_length[10:0]   ), //o
    .io_outputs_0_payload_fragment_context    (io_input_cmd_fork_io_outputs_0_payload_fragment_context[24:0]  ), //o
    .io_outputs_1_valid                       (io_input_cmd_fork_io_outputs_1_valid                           ), //o
    .io_outputs_1_ready                       (io_output_cmd_ready                                            ), //i
    .io_outputs_1_payload_last                (io_input_cmd_fork_io_outputs_1_payload_last                    ), //o
    .io_outputs_1_payload_fragment_opcode     (io_input_cmd_fork_io_outputs_1_payload_fragment_opcode         ), //o
    .io_outputs_1_payload_fragment_address    (io_input_cmd_fork_io_outputs_1_payload_fragment_address[31:0]  ), //o
    .io_outputs_1_payload_fragment_length     (io_input_cmd_fork_io_outputs_1_payload_fragment_length[10:0]   ), //o
    .io_outputs_1_payload_fragment_context    (io_input_cmd_fork_io_outputs_1_payload_fragment_context[24:0]  ), //o
    .clk                                      (clk                                                            ), //i
    .reset                                    (reset                                                          )  //i
  );
  dma_socRuby_StreamFifo io_input_cmd_fork_io_outputs_0_thrown_translated_fifo (
    .io_push_valid      (io_input_cmd_fork_io_outputs_0_thrown_translated_valid                      ), //i
    .io_push_ready      (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_push_ready         ), //o
    .io_push_payload    (io_input_cmd_fork_io_outputs_0_thrown_translated_payload[24:0]              ), //i
    .io_pop_valid       (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_valid          ), //o
    .io_pop_ready       (_zz_3                                                                       ), //i
    .io_pop_payload     (io_input_cmd_fork_io_outputs_0_thrown_translated_fifo_io_pop_payload[24:0]  ), //o
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

module dma_socRuby_StreamArbiter_3 (
  input               io_inputs_0_valid,
  output              io_inputs_0_ready,
  input               io_inputs_0_payload_last,
  input      [1:0]    io_inputs_0_payload_fragment_source,
  input      [0:0]    io_inputs_0_payload_fragment_opcode,
  input      [31:0]   io_inputs_0_payload_fragment_address,
  input      [10:0]   io_inputs_0_payload_fragment_length,
  input      [63:0]   io_inputs_0_payload_fragment_data,
  input      [7:0]    io_inputs_0_payload_fragment_mask,
  input      [12:0]   io_inputs_0_payload_fragment_context,
  input               io_inputs_1_valid,
  output              io_inputs_1_ready,
  input               io_inputs_1_payload_last,
  input      [1:0]    io_inputs_1_payload_fragment_source,
  input      [0:0]    io_inputs_1_payload_fragment_opcode,
  input      [31:0]   io_inputs_1_payload_fragment_address,
  input      [10:0]   io_inputs_1_payload_fragment_length,
  input      [63:0]   io_inputs_1_payload_fragment_data,
  input      [7:0]    io_inputs_1_payload_fragment_mask,
  input      [12:0]   io_inputs_1_payload_fragment_context,
  output              io_output_valid,
  input               io_output_ready,
  output              io_output_payload_last,
  output     [1:0]    io_output_payload_fragment_source,
  output     [0:0]    io_output_payload_fragment_opcode,
  output     [31:0]   io_output_payload_fragment_address,
  output     [10:0]   io_output_payload_fragment_length,
  output     [63:0]   io_output_payload_fragment_data,
  output     [7:0]    io_output_payload_fragment_mask,
  output     [12:0]   io_output_payload_fragment_context,
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

module dma_socRuby_StreamArbiter_2 (
  input               io_inputs_0_valid,
  output              io_inputs_0_ready,
  input               io_inputs_0_payload_last,
  input      [1:0]    io_inputs_0_payload_fragment_source,
  input      [0:0]    io_inputs_0_payload_fragment_opcode,
  input      [31:0]   io_inputs_0_payload_fragment_address,
  input      [10:0]   io_inputs_0_payload_fragment_length,
  input      [18:0]   io_inputs_0_payload_fragment_context,
  input               io_inputs_1_valid,
  output              io_inputs_1_ready,
  input               io_inputs_1_payload_last,
  input      [1:0]    io_inputs_1_payload_fragment_source,
  input      [0:0]    io_inputs_1_payload_fragment_opcode,
  input      [31:0]   io_inputs_1_payload_fragment_address,
  input      [10:0]   io_inputs_1_payload_fragment_length,
  input      [18:0]   io_inputs_1_payload_fragment_context,
  output              io_output_valid,
  input               io_output_ready,
  output              io_output_payload_last,
  output     [1:0]    io_output_payload_fragment_source,
  output     [0:0]    io_output_payload_fragment_opcode,
  output     [31:0]   io_output_payload_fragment_address,
  output     [10:0]   io_output_payload_fragment_length,
  output     [18:0]   io_output_payload_fragment_context,
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
  input      [63:0]   io_input_payload_data,
  input      [7:0]    io_input_payload_mask,
  output reg [63:0]   io_output_data,
  output reg [7:0]    io_output_mask,
  input               io_output_enough,
  input               io_output_consume,
  output              io_output_consumed,
  input      [2:0]    io_output_lastByteUsed,
  output     [2:0]    io_output_usedUntil,
  input               io_flush,
  input      [2:0]    io_offset,
  input      [10:0]   io_burstLength,
  input               clk,
  input               reset
);
  reg        [0:0]    _zz_83;
  reg        [1:0]    _zz_84;
  reg        [1:0]    _zz_85;
  reg        [2:0]    _zz_86;
  reg        [2:0]    _zz_87;
  reg        [2:0]    _zz_88;
  reg        [2:0]    _zz_89;
  reg        [2:0]    _zz_90;
  reg        [2:0]    _zz_91;
  reg        [2:0]    _zz_92;
  reg        [2:0]    _zz_93;
  reg        [2:0]    _zz_94;
  reg        [3:0]    _zz_95;
  reg        [3:0]    _zz_96;
  reg        [3:0]    _zz_97;
  reg        [7:0]    _zz_98;
  reg        [7:0]    _zz_99;
  reg        [7:0]    _zz_100;
  reg        [7:0]    _zz_101;
  reg        [7:0]    _zz_102;
  reg        [7:0]    _zz_103;
  reg        [7:0]    _zz_104;
  reg        [7:0]    _zz_105;
  reg        [2:0]    _zz_106;
  wire       [0:0]    _zz_107;
  wire       [2:0]    _zz_108;
  wire       [1:0]    _zz_109;
  wire       [2:0]    _zz_110;
  wire       [2:0]    _zz_111;
  wire       [0:0]    _zz_112;
  wire       [2:0]    _zz_113;
  wire       [3:0]    _zz_114;
  wire       [1:0]    _zz_115;
  wire       [2:0]    _zz_116;
  wire       [3:0]    _zz_117;
  wire       [11:0]   _zz_118;
  wire       [2:0]    _zz_119;
  wire       [2:0]    _zz_120;
  wire       [2:0]    _zz_121;
  wire       [11:0]   _zz_122;
  wire       [0:0]    _zz_123;
  wire       [1:0]    _zz_124;
  wire       [2:0]    _zz_125;
  wire       [2:0]    _zz_126;
  wire       [2:0]    _zz_127;
  wire       [2:0]    _zz_128;
  wire       [2:0]    _zz_129;
  wire       [2:0]    _zz_130;
  wire       [2:0]    _zz_131;
  wire       [2:0]    _zz_132;
  wire       [2:0]    _zz_133;
  wire       [2:0]    _zz_134;
  wire                _zz_1;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  wire                _zz_6;
  wire                _zz_7;
  wire       [0:0]    s0_countOnes_0;
  wire       [1:0]    s0_countOnes_1;
  wire       [1:0]    s0_countOnes_2;
  wire       [2:0]    _zz_8;
  wire       [2:0]    _zz_9;
  wire       [2:0]    _zz_10;
  wire       [2:0]    _zz_11;
  wire       [2:0]    _zz_12;
  wire       [2:0]    _zz_13;
  wire       [2:0]    _zz_14;
  wire       [2:0]    _zz_15;
  wire       [2:0]    s0_countOnes_3;
  wire       [2:0]    _zz_16;
  wire       [2:0]    _zz_17;
  wire       [2:0]    _zz_18;
  wire       [2:0]    _zz_19;
  wire       [2:0]    _zz_20;
  wire       [2:0]    _zz_21;
  wire       [2:0]    _zz_22;
  wire       [2:0]    _zz_23;
  wire       [2:0]    s0_countOnes_4;
  wire       [2:0]    _zz_24;
  wire       [2:0]    _zz_25;
  wire       [2:0]    _zz_26;
  wire       [2:0]    _zz_27;
  wire       [2:0]    _zz_28;
  wire       [2:0]    _zz_29;
  wire       [2:0]    _zz_30;
  wire       [2:0]    _zz_31;
  wire       [2:0]    s0_countOnes_5;
  wire       [2:0]    _zz_32;
  wire       [2:0]    _zz_33;
  wire       [2:0]    _zz_34;
  wire       [2:0]    _zz_35;
  wire       [2:0]    _zz_36;
  wire       [2:0]    _zz_37;
  wire       [2:0]    _zz_38;
  wire       [2:0]    _zz_39;
  wire       [2:0]    s0_countOnes_6;
  wire       [3:0]    _zz_40;
  wire       [3:0]    _zz_41;
  wire       [3:0]    _zz_42;
  wire       [3:0]    _zz_43;
  wire       [3:0]    _zz_44;
  wire       [3:0]    _zz_45;
  wire       [3:0]    _zz_46;
  wire       [3:0]    _zz_47;
  wire       [3:0]    s0_countOnes_7;
  reg        [2:0]    s0_offset;
  wire       [3:0]    s0_offsetNext;
  reg        [11:0]   s0_byteCounter;
  wire       [2:0]    s0_inputIndexes_0;
  wire       [2:0]    s0_inputIndexes_1;
  wire       [2:0]    s0_inputIndexes_2;
  wire       [2:0]    s0_inputIndexes_3;
  wire       [2:0]    s0_inputIndexes_4;
  wire       [2:0]    s0_inputIndexes_5;
  wire       [2:0]    s0_inputIndexes_6;
  wire       [2:0]    s0_inputIndexes_7;
  wire       [63:0]   s0_outputPayload_cmd_data;
  wire       [7:0]    s0_outputPayload_cmd_mask;
  wire       [2:0]    s0_outputPayload_index_0;
  wire       [2:0]    s0_outputPayload_index_1;
  wire       [2:0]    s0_outputPayload_index_2;
  wire       [2:0]    s0_outputPayload_index_3;
  wire       [2:0]    s0_outputPayload_index_4;
  wire       [2:0]    s0_outputPayload_index_5;
  wire       [2:0]    s0_outputPayload_index_6;
  wire       [2:0]    s0_outputPayload_index_7;
  wire                s0_outputPayload_last;
  wire                s0_output_valid;
  wire                s0_output_ready;
  wire       [63:0]   s0_output_payload_cmd_data;
  wire       [7:0]    s0_output_payload_cmd_mask;
  wire       [2:0]    s0_output_payload_index_0;
  wire       [2:0]    s0_output_payload_index_1;
  wire       [2:0]    s0_output_payload_index_2;
  wire       [2:0]    s0_output_payload_index_3;
  wire       [2:0]    s0_output_payload_index_4;
  wire       [2:0]    s0_output_payload_index_5;
  wire       [2:0]    s0_output_payload_index_6;
  wire       [2:0]    s0_output_payload_index_7;
  wire                s0_output_payload_last;
  wire                s1_input_valid;
  reg                 s1_input_ready;
  wire       [63:0]   s1_input_payload_cmd_data;
  wire       [7:0]    s1_input_payload_cmd_mask;
  wire       [2:0]    s1_input_payload_index_0;
  wire       [2:0]    s1_input_payload_index_1;
  wire       [2:0]    s1_input_payload_index_2;
  wire       [2:0]    s1_input_payload_index_3;
  wire       [2:0]    s1_input_payload_index_4;
  wire       [2:0]    s1_input_payload_index_5;
  wire       [2:0]    s1_input_payload_index_6;
  wire       [2:0]    s1_input_payload_index_7;
  wire                s1_input_payload_last;
  reg                 s0_output_m2sPipe_rValid;
  reg        [63:0]   s0_output_m2sPipe_rData_cmd_data;
  reg        [7:0]    s0_output_m2sPipe_rData_cmd_mask;
  reg        [2:0]    s0_output_m2sPipe_rData_index_0;
  reg        [2:0]    s0_output_m2sPipe_rData_index_1;
  reg        [2:0]    s0_output_m2sPipe_rData_index_2;
  reg        [2:0]    s0_output_m2sPipe_rData_index_3;
  reg        [2:0]    s0_output_m2sPipe_rData_index_4;
  reg        [2:0]    s0_output_m2sPipe_rData_index_5;
  reg        [2:0]    s0_output_m2sPipe_rData_index_6;
  reg        [2:0]    s0_output_m2sPipe_rData_index_7;
  reg                 s0_output_m2sPipe_rData_last;
  wire       [7:0]    s1_inputDataBytes_0;
  wire       [7:0]    s1_inputDataBytes_1;
  wire       [7:0]    s1_inputDataBytes_2;
  wire       [7:0]    s1_inputDataBytes_3;
  wire       [7:0]    s1_inputDataBytes_4;
  wire       [7:0]    s1_inputDataBytes_5;
  wire       [7:0]    s1_inputDataBytes_6;
  wire       [7:0]    s1_inputDataBytes_7;
  reg                 s1_byteLogic_0_buffer_valid;
  reg        [7:0]    s1_byteLogic_0_buffer_data;
  wire                s1_byteLogic_0_selOh_0;
  wire                s1_byteLogic_0_selOh_1;
  wire                s1_byteLogic_0_selOh_2;
  wire                s1_byteLogic_0_selOh_3;
  wire                s1_byteLogic_0_selOh_4;
  wire                s1_byteLogic_0_selOh_5;
  wire                s1_byteLogic_0_selOh_6;
  wire                s1_byteLogic_0_selOh_7;
  wire                _zz_48;
  wire                _zz_49;
  wire                _zz_50;
  wire       [2:0]    s1_byteLogic_0_sel;
  wire                s1_byteLogic_0_lastUsed;
  reg        [7:0]    _zz_51;
  wire                s1_byteLogic_0_inputMask;
  wire       [7:0]    s1_byteLogic_0_inputData;
  wire                s1_byteLogic_0_outputMask;
  wire       [7:0]    s1_byteLogic_0_outputData;
  reg                 s1_byteLogic_1_buffer_valid;
  reg        [7:0]    s1_byteLogic_1_buffer_data;
  wire                s1_byteLogic_1_selOh_0;
  wire                s1_byteLogic_1_selOh_1;
  wire                s1_byteLogic_1_selOh_2;
  wire                s1_byteLogic_1_selOh_3;
  wire                s1_byteLogic_1_selOh_4;
  wire                s1_byteLogic_1_selOh_5;
  wire                s1_byteLogic_1_selOh_6;
  wire                s1_byteLogic_1_selOh_7;
  wire                _zz_52;
  wire                _zz_53;
  wire                _zz_54;
  wire       [2:0]    s1_byteLogic_1_sel;
  wire                s1_byteLogic_1_lastUsed;
  reg        [7:0]    _zz_55;
  wire                s1_byteLogic_1_inputMask;
  wire       [7:0]    s1_byteLogic_1_inputData;
  wire                s1_byteLogic_1_outputMask;
  wire       [7:0]    s1_byteLogic_1_outputData;
  reg                 s1_byteLogic_2_buffer_valid;
  reg        [7:0]    s1_byteLogic_2_buffer_data;
  wire                s1_byteLogic_2_selOh_0;
  wire                s1_byteLogic_2_selOh_1;
  wire                s1_byteLogic_2_selOh_2;
  wire                s1_byteLogic_2_selOh_3;
  wire                s1_byteLogic_2_selOh_4;
  wire                s1_byteLogic_2_selOh_5;
  wire                s1_byteLogic_2_selOh_6;
  wire                s1_byteLogic_2_selOh_7;
  wire                _zz_56;
  wire                _zz_57;
  wire                _zz_58;
  wire       [2:0]    s1_byteLogic_2_sel;
  wire                s1_byteLogic_2_lastUsed;
  reg        [7:0]    _zz_59;
  wire                s1_byteLogic_2_inputMask;
  wire       [7:0]    s1_byteLogic_2_inputData;
  wire                s1_byteLogic_2_outputMask;
  wire       [7:0]    s1_byteLogic_2_outputData;
  reg                 s1_byteLogic_3_buffer_valid;
  reg        [7:0]    s1_byteLogic_3_buffer_data;
  wire                s1_byteLogic_3_selOh_0;
  wire                s1_byteLogic_3_selOh_1;
  wire                s1_byteLogic_3_selOh_2;
  wire                s1_byteLogic_3_selOh_3;
  wire                s1_byteLogic_3_selOh_4;
  wire                s1_byteLogic_3_selOh_5;
  wire                s1_byteLogic_3_selOh_6;
  wire                s1_byteLogic_3_selOh_7;
  wire                _zz_60;
  wire                _zz_61;
  wire                _zz_62;
  wire       [2:0]    s1_byteLogic_3_sel;
  wire                s1_byteLogic_3_lastUsed;
  reg        [7:0]    _zz_63;
  wire                s1_byteLogic_3_inputMask;
  wire       [7:0]    s1_byteLogic_3_inputData;
  wire                s1_byteLogic_3_outputMask;
  wire       [7:0]    s1_byteLogic_3_outputData;
  reg                 s1_byteLogic_4_buffer_valid;
  reg        [7:0]    s1_byteLogic_4_buffer_data;
  wire                s1_byteLogic_4_selOh_0;
  wire                s1_byteLogic_4_selOh_1;
  wire                s1_byteLogic_4_selOh_2;
  wire                s1_byteLogic_4_selOh_3;
  wire                s1_byteLogic_4_selOh_4;
  wire                s1_byteLogic_4_selOh_5;
  wire                s1_byteLogic_4_selOh_6;
  wire                s1_byteLogic_4_selOh_7;
  wire                _zz_64;
  wire                _zz_65;
  wire                _zz_66;
  wire       [2:0]    s1_byteLogic_4_sel;
  wire                s1_byteLogic_4_lastUsed;
  reg        [7:0]    _zz_67;
  wire                s1_byteLogic_4_inputMask;
  wire       [7:0]    s1_byteLogic_4_inputData;
  wire                s1_byteLogic_4_outputMask;
  wire       [7:0]    s1_byteLogic_4_outputData;
  reg                 s1_byteLogic_5_buffer_valid;
  reg        [7:0]    s1_byteLogic_5_buffer_data;
  wire                s1_byteLogic_5_selOh_0;
  wire                s1_byteLogic_5_selOh_1;
  wire                s1_byteLogic_5_selOh_2;
  wire                s1_byteLogic_5_selOh_3;
  wire                s1_byteLogic_5_selOh_4;
  wire                s1_byteLogic_5_selOh_5;
  wire                s1_byteLogic_5_selOh_6;
  wire                s1_byteLogic_5_selOh_7;
  wire                _zz_68;
  wire                _zz_69;
  wire                _zz_70;
  wire       [2:0]    s1_byteLogic_5_sel;
  wire                s1_byteLogic_5_lastUsed;
  reg        [7:0]    _zz_71;
  wire                s1_byteLogic_5_inputMask;
  wire       [7:0]    s1_byteLogic_5_inputData;
  wire                s1_byteLogic_5_outputMask;
  wire       [7:0]    s1_byteLogic_5_outputData;
  reg                 s1_byteLogic_6_buffer_valid;
  reg        [7:0]    s1_byteLogic_6_buffer_data;
  wire                s1_byteLogic_6_selOh_0;
  wire                s1_byteLogic_6_selOh_1;
  wire                s1_byteLogic_6_selOh_2;
  wire                s1_byteLogic_6_selOh_3;
  wire                s1_byteLogic_6_selOh_4;
  wire                s1_byteLogic_6_selOh_5;
  wire                s1_byteLogic_6_selOh_6;
  wire                s1_byteLogic_6_selOh_7;
  wire                _zz_72;
  wire                _zz_73;
  wire                _zz_74;
  wire       [2:0]    s1_byteLogic_6_sel;
  wire                s1_byteLogic_6_lastUsed;
  reg        [7:0]    _zz_75;
  wire                s1_byteLogic_6_inputMask;
  wire       [7:0]    s1_byteLogic_6_inputData;
  wire                s1_byteLogic_6_outputMask;
  wire       [7:0]    s1_byteLogic_6_outputData;
  reg                 s1_byteLogic_7_buffer_valid;
  reg        [7:0]    s1_byteLogic_7_buffer_data;
  wire                s1_byteLogic_7_selOh_0;
  wire                s1_byteLogic_7_selOh_1;
  wire                s1_byteLogic_7_selOh_2;
  wire                s1_byteLogic_7_selOh_3;
  wire                s1_byteLogic_7_selOh_4;
  wire                s1_byteLogic_7_selOh_5;
  wire                s1_byteLogic_7_selOh_6;
  wire                s1_byteLogic_7_selOh_7;
  wire                _zz_76;
  wire                _zz_77;
  wire                _zz_78;
  wire       [2:0]    s1_byteLogic_7_sel;
  wire                s1_byteLogic_7_lastUsed;
  reg        [7:0]    _zz_79;
  wire                s1_byteLogic_7_inputMask;
  wire       [7:0]    s1_byteLogic_7_inputData;
  wire                s1_byteLogic_7_outputMask;
  wire       [7:0]    s1_byteLogic_7_outputData;
  wire                _zz_80;
  wire                _zz_81;
  wire                _zz_82;

  assign _zz_107 = _zz_4;
  assign _zz_108 = {2'd0, _zz_107};
  assign _zz_109 = {_zz_5,_zz_4};
  assign _zz_110 = {1'd0, _zz_109};
  assign _zz_111 = (_zz_92 + _zz_93);
  assign _zz_112 = _zz_7;
  assign _zz_113 = {2'd0, _zz_112};
  assign _zz_114 = (_zz_95 + _zz_96);
  assign _zz_115 = {io_input_payload_mask[7],_zz_7};
  assign _zz_116 = {1'd0, _zz_115};
  assign _zz_117 = {1'd0, s0_offset};
  assign _zz_118 = {8'd0, s0_countOnes_7};
  assign _zz_119 = {2'd0, s0_countOnes_0};
  assign _zz_120 = {1'd0, s0_countOnes_1};
  assign _zz_121 = {1'd0, s0_countOnes_2};
  assign _zz_122 = {1'd0, io_burstLength};
  assign _zz_123 = _zz_1;
  assign _zz_124 = {_zz_2,_zz_1};
  assign _zz_125 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_126 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_127 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_128 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_129 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_130 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_131 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_132 = {_zz_3,{_zz_2,_zz_1}};
  assign _zz_133 = {_zz_6,{_zz_5,_zz_4}};
  assign _zz_134 = {_zz_82,{_zz_81,_zz_80}};
  always @(*) begin
    case(_zz_123)
      1'b0 : begin
        _zz_83 = 1'b0;
      end
      default : begin
        _zz_83 = 1'b1;
      end
    endcase
  end

  always @(*) begin
    case(_zz_124)
      2'b00 : begin
        _zz_84 = 2'b00;
      end
      2'b01 : begin
        _zz_84 = 2'b01;
      end
      2'b10 : begin
        _zz_84 = 2'b01;
      end
      default : begin
        _zz_84 = 2'b10;
      end
    endcase
  end

  always @(*) begin
    case(_zz_125)
      3'b000 : begin
        _zz_85 = 2'b00;
      end
      3'b001 : begin
        _zz_85 = 2'b01;
      end
      3'b010 : begin
        _zz_85 = 2'b01;
      end
      3'b011 : begin
        _zz_85 = 2'b10;
      end
      3'b100 : begin
        _zz_85 = 2'b01;
      end
      3'b101 : begin
        _zz_85 = 2'b10;
      end
      3'b110 : begin
        _zz_85 = 2'b10;
      end
      default : begin
        _zz_85 = 2'b11;
      end
    endcase
  end

  always @(*) begin
    case(_zz_126)
      3'b000 : begin
        _zz_86 = _zz_8;
      end
      3'b001 : begin
        _zz_86 = _zz_9;
      end
      3'b010 : begin
        _zz_86 = _zz_10;
      end
      3'b011 : begin
        _zz_86 = _zz_11;
      end
      3'b100 : begin
        _zz_86 = _zz_12;
      end
      3'b101 : begin
        _zz_86 = _zz_13;
      end
      3'b110 : begin
        _zz_86 = _zz_14;
      end
      default : begin
        _zz_86 = _zz_15;
      end
    endcase
  end

  always @(*) begin
    case(_zz_108)
      3'b000 : begin
        _zz_87 = _zz_8;
      end
      3'b001 : begin
        _zz_87 = _zz_9;
      end
      3'b010 : begin
        _zz_87 = _zz_10;
      end
      3'b011 : begin
        _zz_87 = _zz_11;
      end
      3'b100 : begin
        _zz_87 = _zz_12;
      end
      3'b101 : begin
        _zz_87 = _zz_13;
      end
      3'b110 : begin
        _zz_87 = _zz_14;
      end
      default : begin
        _zz_87 = _zz_15;
      end
    endcase
  end

  always @(*) begin
    case(_zz_127)
      3'b000 : begin
        _zz_88 = _zz_16;
      end
      3'b001 : begin
        _zz_88 = _zz_17;
      end
      3'b010 : begin
        _zz_88 = _zz_18;
      end
      3'b011 : begin
        _zz_88 = _zz_19;
      end
      3'b100 : begin
        _zz_88 = _zz_20;
      end
      3'b101 : begin
        _zz_88 = _zz_21;
      end
      3'b110 : begin
        _zz_88 = _zz_22;
      end
      default : begin
        _zz_88 = _zz_23;
      end
    endcase
  end

  always @(*) begin
    case(_zz_110)
      3'b000 : begin
        _zz_89 = _zz_16;
      end
      3'b001 : begin
        _zz_89 = _zz_17;
      end
      3'b010 : begin
        _zz_89 = _zz_18;
      end
      3'b011 : begin
        _zz_89 = _zz_19;
      end
      3'b100 : begin
        _zz_89 = _zz_20;
      end
      3'b101 : begin
        _zz_89 = _zz_21;
      end
      3'b110 : begin
        _zz_89 = _zz_22;
      end
      default : begin
        _zz_89 = _zz_23;
      end
    endcase
  end

  always @(*) begin
    case(_zz_128)
      3'b000 : begin
        _zz_90 = _zz_24;
      end
      3'b001 : begin
        _zz_90 = _zz_25;
      end
      3'b010 : begin
        _zz_90 = _zz_26;
      end
      3'b011 : begin
        _zz_90 = _zz_27;
      end
      3'b100 : begin
        _zz_90 = _zz_28;
      end
      3'b101 : begin
        _zz_90 = _zz_29;
      end
      3'b110 : begin
        _zz_90 = _zz_30;
      end
      default : begin
        _zz_90 = _zz_31;
      end
    endcase
  end

  always @(*) begin
    case(_zz_129)
      3'b000 : begin
        _zz_91 = _zz_24;
      end
      3'b001 : begin
        _zz_91 = _zz_25;
      end
      3'b010 : begin
        _zz_91 = _zz_26;
      end
      3'b011 : begin
        _zz_91 = _zz_27;
      end
      3'b100 : begin
        _zz_91 = _zz_28;
      end
      3'b101 : begin
        _zz_91 = _zz_29;
      end
      3'b110 : begin
        _zz_91 = _zz_30;
      end
      default : begin
        _zz_91 = _zz_31;
      end
    endcase
  end

  always @(*) begin
    case(_zz_130)
      3'b000 : begin
        _zz_92 = _zz_32;
      end
      3'b001 : begin
        _zz_92 = _zz_33;
      end
      3'b010 : begin
        _zz_92 = _zz_34;
      end
      3'b011 : begin
        _zz_92 = _zz_35;
      end
      3'b100 : begin
        _zz_92 = _zz_36;
      end
      3'b101 : begin
        _zz_92 = _zz_37;
      end
      3'b110 : begin
        _zz_92 = _zz_38;
      end
      default : begin
        _zz_92 = _zz_39;
      end
    endcase
  end

  always @(*) begin
    case(_zz_131)
      3'b000 : begin
        _zz_93 = _zz_32;
      end
      3'b001 : begin
        _zz_93 = _zz_33;
      end
      3'b010 : begin
        _zz_93 = _zz_34;
      end
      3'b011 : begin
        _zz_93 = _zz_35;
      end
      3'b100 : begin
        _zz_93 = _zz_36;
      end
      3'b101 : begin
        _zz_93 = _zz_37;
      end
      3'b110 : begin
        _zz_93 = _zz_38;
      end
      default : begin
        _zz_93 = _zz_39;
      end
    endcase
  end

  always @(*) begin
    case(_zz_113)
      3'b000 : begin
        _zz_94 = _zz_32;
      end
      3'b001 : begin
        _zz_94 = _zz_33;
      end
      3'b010 : begin
        _zz_94 = _zz_34;
      end
      3'b011 : begin
        _zz_94 = _zz_35;
      end
      3'b100 : begin
        _zz_94 = _zz_36;
      end
      3'b101 : begin
        _zz_94 = _zz_37;
      end
      3'b110 : begin
        _zz_94 = _zz_38;
      end
      default : begin
        _zz_94 = _zz_39;
      end
    endcase
  end

  always @(*) begin
    case(_zz_132)
      3'b000 : begin
        _zz_95 = _zz_40;
      end
      3'b001 : begin
        _zz_95 = _zz_41;
      end
      3'b010 : begin
        _zz_95 = _zz_42;
      end
      3'b011 : begin
        _zz_95 = _zz_43;
      end
      3'b100 : begin
        _zz_95 = _zz_44;
      end
      3'b101 : begin
        _zz_95 = _zz_45;
      end
      3'b110 : begin
        _zz_95 = _zz_46;
      end
      default : begin
        _zz_95 = _zz_47;
      end
    endcase
  end

  always @(*) begin
    case(_zz_133)
      3'b000 : begin
        _zz_96 = _zz_40;
      end
      3'b001 : begin
        _zz_96 = _zz_41;
      end
      3'b010 : begin
        _zz_96 = _zz_42;
      end
      3'b011 : begin
        _zz_96 = _zz_43;
      end
      3'b100 : begin
        _zz_96 = _zz_44;
      end
      3'b101 : begin
        _zz_96 = _zz_45;
      end
      3'b110 : begin
        _zz_96 = _zz_46;
      end
      default : begin
        _zz_96 = _zz_47;
      end
    endcase
  end

  always @(*) begin
    case(_zz_116)
      3'b000 : begin
        _zz_97 = _zz_40;
      end
      3'b001 : begin
        _zz_97 = _zz_41;
      end
      3'b010 : begin
        _zz_97 = _zz_42;
      end
      3'b011 : begin
        _zz_97 = _zz_43;
      end
      3'b100 : begin
        _zz_97 = _zz_44;
      end
      3'b101 : begin
        _zz_97 = _zz_45;
      end
      3'b110 : begin
        _zz_97 = _zz_46;
      end
      default : begin
        _zz_97 = _zz_47;
      end
    endcase
  end

  always @(*) begin
    case(s1_byteLogic_0_sel)
      3'b000 : begin
        _zz_98 = s1_inputDataBytes_0;
      end
      3'b001 : begin
        _zz_98 = s1_inputDataBytes_1;
      end
      3'b010 : begin
        _zz_98 = s1_inputDataBytes_2;
      end
      3'b011 : begin
        _zz_98 = s1_inputDataBytes_3;
      end
      3'b100 : begin
        _zz_98 = s1_inputDataBytes_4;
      end
      3'b101 : begin
        _zz_98 = s1_inputDataBytes_5;
      end
      3'b110 : begin
        _zz_98 = s1_inputDataBytes_6;
      end
      default : begin
        _zz_98 = s1_inputDataBytes_7;
      end
    endcase
  end

  always @(*) begin
    case(s1_byteLogic_1_sel)
      3'b000 : begin
        _zz_99 = s1_inputDataBytes_0;
      end
      3'b001 : begin
        _zz_99 = s1_inputDataBytes_1;
      end
      3'b010 : begin
        _zz_99 = s1_inputDataBytes_2;
      end
      3'b011 : begin
        _zz_99 = s1_inputDataBytes_3;
      end
      3'b100 : begin
        _zz_99 = s1_inputDataBytes_4;
      end
      3'b101 : begin
        _zz_99 = s1_inputDataBytes_5;
      end
      3'b110 : begin
        _zz_99 = s1_inputDataBytes_6;
      end
      default : begin
        _zz_99 = s1_inputDataBytes_7;
      end
    endcase
  end

  always @(*) begin
    case(s1_byteLogic_2_sel)
      3'b000 : begin
        _zz_100 = s1_inputDataBytes_0;
      end
      3'b001 : begin
        _zz_100 = s1_inputDataBytes_1;
      end
      3'b010 : begin
        _zz_100 = s1_inputDataBytes_2;
      end
      3'b011 : begin
        _zz_100 = s1_inputDataBytes_3;
      end
      3'b100 : begin
        _zz_100 = s1_inputDataBytes_4;
      end
      3'b101 : begin
        _zz_100 = s1_inputDataBytes_5;
      end
      3'b110 : begin
        _zz_100 = s1_inputDataBytes_6;
      end
      default : begin
        _zz_100 = s1_inputDataBytes_7;
      end
    endcase
  end

  always @(*) begin
    case(s1_byteLogic_3_sel)
      3'b000 : begin
        _zz_101 = s1_inputDataBytes_0;
      end
      3'b001 : begin
        _zz_101 = s1_inputDataBytes_1;
      end
      3'b010 : begin
        _zz_101 = s1_inputDataBytes_2;
      end
      3'b011 : begin
        _zz_101 = s1_inputDataBytes_3;
      end
      3'b100 : begin
        _zz_101 = s1_inputDataBytes_4;
      end
      3'b101 : begin
        _zz_101 = s1_inputDataBytes_5;
      end
      3'b110 : begin
        _zz_101 = s1_inputDataBytes_6;
      end
      default : begin
        _zz_101 = s1_inputDataBytes_7;
      end
    endcase
  end

  always @(*) begin
    case(s1_byteLogic_4_sel)
      3'b000 : begin
        _zz_102 = s1_inputDataBytes_0;
      end
      3'b001 : begin
        _zz_102 = s1_inputDataBytes_1;
      end
      3'b010 : begin
        _zz_102 = s1_inputDataBytes_2;
      end
      3'b011 : begin
        _zz_102 = s1_inputDataBytes_3;
      end
      3'b100 : begin
        _zz_102 = s1_inputDataBytes_4;
      end
      3'b101 : begin
        _zz_102 = s1_inputDataBytes_5;
      end
      3'b110 : begin
        _zz_102 = s1_inputDataBytes_6;
      end
      default : begin
        _zz_102 = s1_inputDataBytes_7;
      end
    endcase
  end

  always @(*) begin
    case(s1_byteLogic_5_sel)
      3'b000 : begin
        _zz_103 = s1_inputDataBytes_0;
      end
      3'b001 : begin
        _zz_103 = s1_inputDataBytes_1;
      end
      3'b010 : begin
        _zz_103 = s1_inputDataBytes_2;
      end
      3'b011 : begin
        _zz_103 = s1_inputDataBytes_3;
      end
      3'b100 : begin
        _zz_103 = s1_inputDataBytes_4;
      end
      3'b101 : begin
        _zz_103 = s1_inputDataBytes_5;
      end
      3'b110 : begin
        _zz_103 = s1_inputDataBytes_6;
      end
      default : begin
        _zz_103 = s1_inputDataBytes_7;
      end
    endcase
  end

  always @(*) begin
    case(s1_byteLogic_6_sel)
      3'b000 : begin
        _zz_104 = s1_inputDataBytes_0;
      end
      3'b001 : begin
        _zz_104 = s1_inputDataBytes_1;
      end
      3'b010 : begin
        _zz_104 = s1_inputDataBytes_2;
      end
      3'b011 : begin
        _zz_104 = s1_inputDataBytes_3;
      end
      3'b100 : begin
        _zz_104 = s1_inputDataBytes_4;
      end
      3'b101 : begin
        _zz_104 = s1_inputDataBytes_5;
      end
      3'b110 : begin
        _zz_104 = s1_inputDataBytes_6;
      end
      default : begin
        _zz_104 = s1_inputDataBytes_7;
      end
    endcase
  end

  always @(*) begin
    case(s1_byteLogic_7_sel)
      3'b000 : begin
        _zz_105 = s1_inputDataBytes_0;
      end
      3'b001 : begin
        _zz_105 = s1_inputDataBytes_1;
      end
      3'b010 : begin
        _zz_105 = s1_inputDataBytes_2;
      end
      3'b011 : begin
        _zz_105 = s1_inputDataBytes_3;
      end
      3'b100 : begin
        _zz_105 = s1_inputDataBytes_4;
      end
      3'b101 : begin
        _zz_105 = s1_inputDataBytes_5;
      end
      3'b110 : begin
        _zz_105 = s1_inputDataBytes_6;
      end
      default : begin
        _zz_105 = s1_inputDataBytes_7;
      end
    endcase
  end

  always @(*) begin
    case(_zz_134)
      3'b000 : begin
        _zz_106 = s1_byteLogic_0_sel;
      end
      3'b001 : begin
        _zz_106 = s1_byteLogic_1_sel;
      end
      3'b010 : begin
        _zz_106 = s1_byteLogic_2_sel;
      end
      3'b011 : begin
        _zz_106 = s1_byteLogic_3_sel;
      end
      3'b100 : begin
        _zz_106 = s1_byteLogic_4_sel;
      end
      3'b101 : begin
        _zz_106 = s1_byteLogic_5_sel;
      end
      3'b110 : begin
        _zz_106 = s1_byteLogic_6_sel;
      end
      default : begin
        _zz_106 = s1_byteLogic_7_sel;
      end
    endcase
  end

  assign _zz_1 = io_input_payload_mask[0];
  assign _zz_2 = io_input_payload_mask[1];
  assign _zz_3 = io_input_payload_mask[2];
  assign _zz_4 = io_input_payload_mask[3];
  assign _zz_5 = io_input_payload_mask[4];
  assign _zz_6 = io_input_payload_mask[5];
  assign _zz_7 = io_input_payload_mask[6];
  assign s0_countOnes_0 = _zz_83;
  assign s0_countOnes_1 = _zz_84;
  assign s0_countOnes_2 = _zz_85;
  assign _zz_8 = 3'b000;
  assign _zz_9 = 3'b001;
  assign _zz_10 = 3'b001;
  assign _zz_11 = 3'b010;
  assign _zz_12 = 3'b001;
  assign _zz_13 = 3'b010;
  assign _zz_14 = 3'b010;
  assign _zz_15 = 3'b011;
  assign s0_countOnes_3 = (_zz_86 + _zz_87);
  assign _zz_16 = 3'b000;
  assign _zz_17 = 3'b001;
  assign _zz_18 = 3'b001;
  assign _zz_19 = 3'b010;
  assign _zz_20 = 3'b001;
  assign _zz_21 = 3'b010;
  assign _zz_22 = 3'b010;
  assign _zz_23 = 3'b011;
  assign s0_countOnes_4 = (_zz_88 + _zz_89);
  assign _zz_24 = 3'b000;
  assign _zz_25 = 3'b001;
  assign _zz_26 = 3'b001;
  assign _zz_27 = 3'b010;
  assign _zz_28 = 3'b001;
  assign _zz_29 = 3'b010;
  assign _zz_30 = 3'b010;
  assign _zz_31 = 3'b011;
  assign s0_countOnes_5 = (_zz_90 + _zz_91);
  assign _zz_32 = 3'b000;
  assign _zz_33 = 3'b001;
  assign _zz_34 = 3'b001;
  assign _zz_35 = 3'b010;
  assign _zz_36 = 3'b001;
  assign _zz_37 = 3'b010;
  assign _zz_38 = 3'b010;
  assign _zz_39 = 3'b011;
  assign s0_countOnes_6 = (_zz_111 + _zz_94);
  assign _zz_40 = 4'b0000;
  assign _zz_41 = 4'b0001;
  assign _zz_42 = 4'b0001;
  assign _zz_43 = 4'b0010;
  assign _zz_44 = 4'b0001;
  assign _zz_45 = 4'b0010;
  assign _zz_46 = 4'b0010;
  assign _zz_47 = 4'b0011;
  assign s0_countOnes_7 = (_zz_114 + _zz_97);
  assign s0_offsetNext = (_zz_117 + s0_countOnes_7);
  assign s0_inputIndexes_0 = (3'b000 + s0_offset);
  assign s0_inputIndexes_1 = (_zz_119 + s0_offset);
  assign s0_inputIndexes_2 = (_zz_120 + s0_offset);
  assign s0_inputIndexes_3 = (_zz_121 + s0_offset);
  assign s0_inputIndexes_4 = (s0_countOnes_3 + s0_offset);
  assign s0_inputIndexes_5 = (s0_countOnes_4 + s0_offset);
  assign s0_inputIndexes_6 = (s0_countOnes_5 + s0_offset);
  assign s0_inputIndexes_7 = (s0_countOnes_6 + s0_offset);
  assign s0_outputPayload_cmd_data = io_input_payload_data;
  assign s0_outputPayload_cmd_mask = io_input_payload_mask;
  assign s0_outputPayload_index_0 = s0_inputIndexes_0;
  assign s0_outputPayload_index_1 = s0_inputIndexes_1;
  assign s0_outputPayload_index_2 = s0_inputIndexes_2;
  assign s0_outputPayload_index_3 = s0_inputIndexes_3;
  assign s0_outputPayload_index_4 = s0_inputIndexes_4;
  assign s0_outputPayload_index_5 = s0_inputIndexes_5;
  assign s0_outputPayload_index_6 = s0_inputIndexes_6;
  assign s0_outputPayload_index_7 = s0_inputIndexes_7;
  assign s0_outputPayload_last = s0_offsetNext[3];
  assign s0_output_valid = io_input_valid;
  assign io_input_ready = s0_output_ready;
  assign s0_output_payload_cmd_data = s0_outputPayload_cmd_data;
  assign s0_output_payload_cmd_mask = s0_outputPayload_cmd_mask;
  assign s0_output_payload_index_0 = s0_outputPayload_index_0;
  assign s0_output_payload_index_1 = s0_outputPayload_index_1;
  assign s0_output_payload_index_2 = s0_outputPayload_index_2;
  assign s0_output_payload_index_3 = s0_outputPayload_index_3;
  assign s0_output_payload_index_4 = s0_outputPayload_index_4;
  assign s0_output_payload_index_5 = s0_outputPayload_index_5;
  assign s0_output_payload_index_6 = s0_outputPayload_index_6;
  assign s0_output_payload_index_7 = s0_outputPayload_index_7;
  assign s0_output_payload_last = s0_outputPayload_last;
  assign s0_output_ready = ((1'b1 && (! s1_input_valid)) || s1_input_ready);
  assign s1_input_valid = s0_output_m2sPipe_rValid;
  assign s1_input_payload_cmd_data = s0_output_m2sPipe_rData_cmd_data;
  assign s1_input_payload_cmd_mask = s0_output_m2sPipe_rData_cmd_mask;
  assign s1_input_payload_index_0 = s0_output_m2sPipe_rData_index_0;
  assign s1_input_payload_index_1 = s0_output_m2sPipe_rData_index_1;
  assign s1_input_payload_index_2 = s0_output_m2sPipe_rData_index_2;
  assign s1_input_payload_index_3 = s0_output_m2sPipe_rData_index_3;
  assign s1_input_payload_index_4 = s0_output_m2sPipe_rData_index_4;
  assign s1_input_payload_index_5 = s0_output_m2sPipe_rData_index_5;
  assign s1_input_payload_index_6 = s0_output_m2sPipe_rData_index_6;
  assign s1_input_payload_index_7 = s0_output_m2sPipe_rData_index_7;
  assign s1_input_payload_last = s0_output_m2sPipe_rData_last;
  always @ (*) begin
    s1_input_ready = ((! io_output_enough) || io_output_consume);
    if((_zz_122 < s0_byteCounter))begin
      s1_input_ready = 1'b0;
    end
  end

  assign io_output_consumed = (s1_input_valid && s1_input_ready);
  assign s1_inputDataBytes_0 = s1_input_payload_cmd_data[7 : 0];
  assign s1_inputDataBytes_1 = s1_input_payload_cmd_data[15 : 8];
  assign s1_inputDataBytes_2 = s1_input_payload_cmd_data[23 : 16];
  assign s1_inputDataBytes_3 = s1_input_payload_cmd_data[31 : 24];
  assign s1_inputDataBytes_4 = s1_input_payload_cmd_data[39 : 32];
  assign s1_inputDataBytes_5 = s1_input_payload_cmd_data[47 : 40];
  assign s1_inputDataBytes_6 = s1_input_payload_cmd_data[55 : 48];
  assign s1_inputDataBytes_7 = s1_input_payload_cmd_data[63 : 56];
  assign s1_byteLogic_0_selOh_0 = (s1_input_payload_cmd_mask[0] && (s1_input_payload_index_0 == 3'b000));
  assign s1_byteLogic_0_selOh_1 = (s1_input_payload_cmd_mask[1] && (s1_input_payload_index_1 == 3'b000));
  assign s1_byteLogic_0_selOh_2 = (s1_input_payload_cmd_mask[2] && (s1_input_payload_index_2 == 3'b000));
  assign s1_byteLogic_0_selOh_3 = (s1_input_payload_cmd_mask[3] && (s1_input_payload_index_3 == 3'b000));
  assign s1_byteLogic_0_selOh_4 = (s1_input_payload_cmd_mask[4] && (s1_input_payload_index_4 == 3'b000));
  assign s1_byteLogic_0_selOh_5 = (s1_input_payload_cmd_mask[5] && (s1_input_payload_index_5 == 3'b000));
  assign s1_byteLogic_0_selOh_6 = (s1_input_payload_cmd_mask[6] && (s1_input_payload_index_6 == 3'b000));
  assign s1_byteLogic_0_selOh_7 = (s1_input_payload_cmd_mask[7] && (s1_input_payload_index_7 == 3'b000));
  assign _zz_48 = (((s1_byteLogic_0_selOh_1 || s1_byteLogic_0_selOh_3) || s1_byteLogic_0_selOh_5) || s1_byteLogic_0_selOh_7);
  assign _zz_49 = (((s1_byteLogic_0_selOh_2 || s1_byteLogic_0_selOh_3) || s1_byteLogic_0_selOh_6) || s1_byteLogic_0_selOh_7);
  assign _zz_50 = (((s1_byteLogic_0_selOh_4 || s1_byteLogic_0_selOh_5) || s1_byteLogic_0_selOh_6) || s1_byteLogic_0_selOh_7);
  assign s1_byteLogic_0_sel = {_zz_50,{_zz_49,_zz_48}};
  assign s1_byteLogic_0_lastUsed = (3'b000 == io_output_lastByteUsed);
  always @ (*) begin
    _zz_51[0] = s1_byteLogic_0_selOh_0;
    _zz_51[1] = s1_byteLogic_0_selOh_1;
    _zz_51[2] = s1_byteLogic_0_selOh_2;
    _zz_51[3] = s1_byteLogic_0_selOh_3;
    _zz_51[4] = s1_byteLogic_0_selOh_4;
    _zz_51[5] = s1_byteLogic_0_selOh_5;
    _zz_51[6] = s1_byteLogic_0_selOh_6;
    _zz_51[7] = s1_byteLogic_0_selOh_7;
  end

  assign s1_byteLogic_0_inputMask = ((_zz_51 & s1_input_payload_cmd_mask) != 8'h0);
  assign s1_byteLogic_0_inputData = _zz_98;
  assign s1_byteLogic_0_outputMask = (s1_byteLogic_0_buffer_valid || (s1_input_valid && s1_byteLogic_0_inputMask));
  assign s1_byteLogic_0_outputData = (s1_byteLogic_0_buffer_valid ? s1_byteLogic_0_buffer_data : s1_byteLogic_0_inputData);
  always @ (*) begin
    io_output_mask[0] = s1_byteLogic_0_outputMask;
    io_output_mask[1] = s1_byteLogic_1_outputMask;
    io_output_mask[2] = s1_byteLogic_2_outputMask;
    io_output_mask[3] = s1_byteLogic_3_outputMask;
    io_output_mask[4] = s1_byteLogic_4_outputMask;
    io_output_mask[5] = s1_byteLogic_5_outputMask;
    io_output_mask[6] = s1_byteLogic_6_outputMask;
    io_output_mask[7] = s1_byteLogic_7_outputMask;
  end

  always @ (*) begin
    io_output_data[7 : 0] = s1_byteLogic_0_outputData;
    io_output_data[15 : 8] = s1_byteLogic_1_outputData;
    io_output_data[23 : 16] = s1_byteLogic_2_outputData;
    io_output_data[31 : 24] = s1_byteLogic_3_outputData;
    io_output_data[39 : 32] = s1_byteLogic_4_outputData;
    io_output_data[47 : 40] = s1_byteLogic_5_outputData;
    io_output_data[55 : 48] = s1_byteLogic_6_outputData;
    io_output_data[63 : 56] = s1_byteLogic_7_outputData;
  end

  assign s1_byteLogic_1_selOh_0 = (s1_input_payload_cmd_mask[0] && (s1_input_payload_index_0 == 3'b001));
  assign s1_byteLogic_1_selOh_1 = (s1_input_payload_cmd_mask[1] && (s1_input_payload_index_1 == 3'b001));
  assign s1_byteLogic_1_selOh_2 = (s1_input_payload_cmd_mask[2] && (s1_input_payload_index_2 == 3'b001));
  assign s1_byteLogic_1_selOh_3 = (s1_input_payload_cmd_mask[3] && (s1_input_payload_index_3 == 3'b001));
  assign s1_byteLogic_1_selOh_4 = (s1_input_payload_cmd_mask[4] && (s1_input_payload_index_4 == 3'b001));
  assign s1_byteLogic_1_selOh_5 = (s1_input_payload_cmd_mask[5] && (s1_input_payload_index_5 == 3'b001));
  assign s1_byteLogic_1_selOh_6 = (s1_input_payload_cmd_mask[6] && (s1_input_payload_index_6 == 3'b001));
  assign s1_byteLogic_1_selOh_7 = (s1_input_payload_cmd_mask[7] && (s1_input_payload_index_7 == 3'b001));
  assign _zz_52 = (((s1_byteLogic_1_selOh_1 || s1_byteLogic_1_selOh_3) || s1_byteLogic_1_selOh_5) || s1_byteLogic_1_selOh_7);
  assign _zz_53 = (((s1_byteLogic_1_selOh_2 || s1_byteLogic_1_selOh_3) || s1_byteLogic_1_selOh_6) || s1_byteLogic_1_selOh_7);
  assign _zz_54 = (((s1_byteLogic_1_selOh_4 || s1_byteLogic_1_selOh_5) || s1_byteLogic_1_selOh_6) || s1_byteLogic_1_selOh_7);
  assign s1_byteLogic_1_sel = {_zz_54,{_zz_53,_zz_52}};
  assign s1_byteLogic_1_lastUsed = (3'b001 == io_output_lastByteUsed);
  always @ (*) begin
    _zz_55[0] = s1_byteLogic_1_selOh_0;
    _zz_55[1] = s1_byteLogic_1_selOh_1;
    _zz_55[2] = s1_byteLogic_1_selOh_2;
    _zz_55[3] = s1_byteLogic_1_selOh_3;
    _zz_55[4] = s1_byteLogic_1_selOh_4;
    _zz_55[5] = s1_byteLogic_1_selOh_5;
    _zz_55[6] = s1_byteLogic_1_selOh_6;
    _zz_55[7] = s1_byteLogic_1_selOh_7;
  end

  assign s1_byteLogic_1_inputMask = ((_zz_55 & s1_input_payload_cmd_mask) != 8'h0);
  assign s1_byteLogic_1_inputData = _zz_99;
  assign s1_byteLogic_1_outputMask = (s1_byteLogic_1_buffer_valid || (s1_input_valid && s1_byteLogic_1_inputMask));
  assign s1_byteLogic_1_outputData = (s1_byteLogic_1_buffer_valid ? s1_byteLogic_1_buffer_data : s1_byteLogic_1_inputData);
  assign s1_byteLogic_2_selOh_0 = (s1_input_payload_cmd_mask[0] && (s1_input_payload_index_0 == 3'b010));
  assign s1_byteLogic_2_selOh_1 = (s1_input_payload_cmd_mask[1] && (s1_input_payload_index_1 == 3'b010));
  assign s1_byteLogic_2_selOh_2 = (s1_input_payload_cmd_mask[2] && (s1_input_payload_index_2 == 3'b010));
  assign s1_byteLogic_2_selOh_3 = (s1_input_payload_cmd_mask[3] && (s1_input_payload_index_3 == 3'b010));
  assign s1_byteLogic_2_selOh_4 = (s1_input_payload_cmd_mask[4] && (s1_input_payload_index_4 == 3'b010));
  assign s1_byteLogic_2_selOh_5 = (s1_input_payload_cmd_mask[5] && (s1_input_payload_index_5 == 3'b010));
  assign s1_byteLogic_2_selOh_6 = (s1_input_payload_cmd_mask[6] && (s1_input_payload_index_6 == 3'b010));
  assign s1_byteLogic_2_selOh_7 = (s1_input_payload_cmd_mask[7] && (s1_input_payload_index_7 == 3'b010));
  assign _zz_56 = (((s1_byteLogic_2_selOh_1 || s1_byteLogic_2_selOh_3) || s1_byteLogic_2_selOh_5) || s1_byteLogic_2_selOh_7);
  assign _zz_57 = (((s1_byteLogic_2_selOh_2 || s1_byteLogic_2_selOh_3) || s1_byteLogic_2_selOh_6) || s1_byteLogic_2_selOh_7);
  assign _zz_58 = (((s1_byteLogic_2_selOh_4 || s1_byteLogic_2_selOh_5) || s1_byteLogic_2_selOh_6) || s1_byteLogic_2_selOh_7);
  assign s1_byteLogic_2_sel = {_zz_58,{_zz_57,_zz_56}};
  assign s1_byteLogic_2_lastUsed = (3'b010 == io_output_lastByteUsed);
  always @ (*) begin
    _zz_59[0] = s1_byteLogic_2_selOh_0;
    _zz_59[1] = s1_byteLogic_2_selOh_1;
    _zz_59[2] = s1_byteLogic_2_selOh_2;
    _zz_59[3] = s1_byteLogic_2_selOh_3;
    _zz_59[4] = s1_byteLogic_2_selOh_4;
    _zz_59[5] = s1_byteLogic_2_selOh_5;
    _zz_59[6] = s1_byteLogic_2_selOh_6;
    _zz_59[7] = s1_byteLogic_2_selOh_7;
  end

  assign s1_byteLogic_2_inputMask = ((_zz_59 & s1_input_payload_cmd_mask) != 8'h0);
  assign s1_byteLogic_2_inputData = _zz_100;
  assign s1_byteLogic_2_outputMask = (s1_byteLogic_2_buffer_valid || (s1_input_valid && s1_byteLogic_2_inputMask));
  assign s1_byteLogic_2_outputData = (s1_byteLogic_2_buffer_valid ? s1_byteLogic_2_buffer_data : s1_byteLogic_2_inputData);
  assign s1_byteLogic_3_selOh_0 = (s1_input_payload_cmd_mask[0] && (s1_input_payload_index_0 == 3'b011));
  assign s1_byteLogic_3_selOh_1 = (s1_input_payload_cmd_mask[1] && (s1_input_payload_index_1 == 3'b011));
  assign s1_byteLogic_3_selOh_2 = (s1_input_payload_cmd_mask[2] && (s1_input_payload_index_2 == 3'b011));
  assign s1_byteLogic_3_selOh_3 = (s1_input_payload_cmd_mask[3] && (s1_input_payload_index_3 == 3'b011));
  assign s1_byteLogic_3_selOh_4 = (s1_input_payload_cmd_mask[4] && (s1_input_payload_index_4 == 3'b011));
  assign s1_byteLogic_3_selOh_5 = (s1_input_payload_cmd_mask[5] && (s1_input_payload_index_5 == 3'b011));
  assign s1_byteLogic_3_selOh_6 = (s1_input_payload_cmd_mask[6] && (s1_input_payload_index_6 == 3'b011));
  assign s1_byteLogic_3_selOh_7 = (s1_input_payload_cmd_mask[7] && (s1_input_payload_index_7 == 3'b011));
  assign _zz_60 = (((s1_byteLogic_3_selOh_1 || s1_byteLogic_3_selOh_3) || s1_byteLogic_3_selOh_5) || s1_byteLogic_3_selOh_7);
  assign _zz_61 = (((s1_byteLogic_3_selOh_2 || s1_byteLogic_3_selOh_3) || s1_byteLogic_3_selOh_6) || s1_byteLogic_3_selOh_7);
  assign _zz_62 = (((s1_byteLogic_3_selOh_4 || s1_byteLogic_3_selOh_5) || s1_byteLogic_3_selOh_6) || s1_byteLogic_3_selOh_7);
  assign s1_byteLogic_3_sel = {_zz_62,{_zz_61,_zz_60}};
  assign s1_byteLogic_3_lastUsed = (3'b011 == io_output_lastByteUsed);
  always @ (*) begin
    _zz_63[0] = s1_byteLogic_3_selOh_0;
    _zz_63[1] = s1_byteLogic_3_selOh_1;
    _zz_63[2] = s1_byteLogic_3_selOh_2;
    _zz_63[3] = s1_byteLogic_3_selOh_3;
    _zz_63[4] = s1_byteLogic_3_selOh_4;
    _zz_63[5] = s1_byteLogic_3_selOh_5;
    _zz_63[6] = s1_byteLogic_3_selOh_6;
    _zz_63[7] = s1_byteLogic_3_selOh_7;
  end

  assign s1_byteLogic_3_inputMask = ((_zz_63 & s1_input_payload_cmd_mask) != 8'h0);
  assign s1_byteLogic_3_inputData = _zz_101;
  assign s1_byteLogic_3_outputMask = (s1_byteLogic_3_buffer_valid || (s1_input_valid && s1_byteLogic_3_inputMask));
  assign s1_byteLogic_3_outputData = (s1_byteLogic_3_buffer_valid ? s1_byteLogic_3_buffer_data : s1_byteLogic_3_inputData);
  assign s1_byteLogic_4_selOh_0 = (s1_input_payload_cmd_mask[0] && (s1_input_payload_index_0 == 3'b100));
  assign s1_byteLogic_4_selOh_1 = (s1_input_payload_cmd_mask[1] && (s1_input_payload_index_1 == 3'b100));
  assign s1_byteLogic_4_selOh_2 = (s1_input_payload_cmd_mask[2] && (s1_input_payload_index_2 == 3'b100));
  assign s1_byteLogic_4_selOh_3 = (s1_input_payload_cmd_mask[3] && (s1_input_payload_index_3 == 3'b100));
  assign s1_byteLogic_4_selOh_4 = (s1_input_payload_cmd_mask[4] && (s1_input_payload_index_4 == 3'b100));
  assign s1_byteLogic_4_selOh_5 = (s1_input_payload_cmd_mask[5] && (s1_input_payload_index_5 == 3'b100));
  assign s1_byteLogic_4_selOh_6 = (s1_input_payload_cmd_mask[6] && (s1_input_payload_index_6 == 3'b100));
  assign s1_byteLogic_4_selOh_7 = (s1_input_payload_cmd_mask[7] && (s1_input_payload_index_7 == 3'b100));
  assign _zz_64 = (((s1_byteLogic_4_selOh_1 || s1_byteLogic_4_selOh_3) || s1_byteLogic_4_selOh_5) || s1_byteLogic_4_selOh_7);
  assign _zz_65 = (((s1_byteLogic_4_selOh_2 || s1_byteLogic_4_selOh_3) || s1_byteLogic_4_selOh_6) || s1_byteLogic_4_selOh_7);
  assign _zz_66 = (((s1_byteLogic_4_selOh_4 || s1_byteLogic_4_selOh_5) || s1_byteLogic_4_selOh_6) || s1_byteLogic_4_selOh_7);
  assign s1_byteLogic_4_sel = {_zz_66,{_zz_65,_zz_64}};
  assign s1_byteLogic_4_lastUsed = (3'b100 == io_output_lastByteUsed);
  always @ (*) begin
    _zz_67[0] = s1_byteLogic_4_selOh_0;
    _zz_67[1] = s1_byteLogic_4_selOh_1;
    _zz_67[2] = s1_byteLogic_4_selOh_2;
    _zz_67[3] = s1_byteLogic_4_selOh_3;
    _zz_67[4] = s1_byteLogic_4_selOh_4;
    _zz_67[5] = s1_byteLogic_4_selOh_5;
    _zz_67[6] = s1_byteLogic_4_selOh_6;
    _zz_67[7] = s1_byteLogic_4_selOh_7;
  end

  assign s1_byteLogic_4_inputMask = ((_zz_67 & s1_input_payload_cmd_mask) != 8'h0);
  assign s1_byteLogic_4_inputData = _zz_102;
  assign s1_byteLogic_4_outputMask = (s1_byteLogic_4_buffer_valid || (s1_input_valid && s1_byteLogic_4_inputMask));
  assign s1_byteLogic_4_outputData = (s1_byteLogic_4_buffer_valid ? s1_byteLogic_4_buffer_data : s1_byteLogic_4_inputData);
  assign s1_byteLogic_5_selOh_0 = (s1_input_payload_cmd_mask[0] && (s1_input_payload_index_0 == 3'b101));
  assign s1_byteLogic_5_selOh_1 = (s1_input_payload_cmd_mask[1] && (s1_input_payload_index_1 == 3'b101));
  assign s1_byteLogic_5_selOh_2 = (s1_input_payload_cmd_mask[2] && (s1_input_payload_index_2 == 3'b101));
  assign s1_byteLogic_5_selOh_3 = (s1_input_payload_cmd_mask[3] && (s1_input_payload_index_3 == 3'b101));
  assign s1_byteLogic_5_selOh_4 = (s1_input_payload_cmd_mask[4] && (s1_input_payload_index_4 == 3'b101));
  assign s1_byteLogic_5_selOh_5 = (s1_input_payload_cmd_mask[5] && (s1_input_payload_index_5 == 3'b101));
  assign s1_byteLogic_5_selOh_6 = (s1_input_payload_cmd_mask[6] && (s1_input_payload_index_6 == 3'b101));
  assign s1_byteLogic_5_selOh_7 = (s1_input_payload_cmd_mask[7] && (s1_input_payload_index_7 == 3'b101));
  assign _zz_68 = (((s1_byteLogic_5_selOh_1 || s1_byteLogic_5_selOh_3) || s1_byteLogic_5_selOh_5) || s1_byteLogic_5_selOh_7);
  assign _zz_69 = (((s1_byteLogic_5_selOh_2 || s1_byteLogic_5_selOh_3) || s1_byteLogic_5_selOh_6) || s1_byteLogic_5_selOh_7);
  assign _zz_70 = (((s1_byteLogic_5_selOh_4 || s1_byteLogic_5_selOh_5) || s1_byteLogic_5_selOh_6) || s1_byteLogic_5_selOh_7);
  assign s1_byteLogic_5_sel = {_zz_70,{_zz_69,_zz_68}};
  assign s1_byteLogic_5_lastUsed = (3'b101 == io_output_lastByteUsed);
  always @ (*) begin
    _zz_71[0] = s1_byteLogic_5_selOh_0;
    _zz_71[1] = s1_byteLogic_5_selOh_1;
    _zz_71[2] = s1_byteLogic_5_selOh_2;
    _zz_71[3] = s1_byteLogic_5_selOh_3;
    _zz_71[4] = s1_byteLogic_5_selOh_4;
    _zz_71[5] = s1_byteLogic_5_selOh_5;
    _zz_71[6] = s1_byteLogic_5_selOh_6;
    _zz_71[7] = s1_byteLogic_5_selOh_7;
  end

  assign s1_byteLogic_5_inputMask = ((_zz_71 & s1_input_payload_cmd_mask) != 8'h0);
  assign s1_byteLogic_5_inputData = _zz_103;
  assign s1_byteLogic_5_outputMask = (s1_byteLogic_5_buffer_valid || (s1_input_valid && s1_byteLogic_5_inputMask));
  assign s1_byteLogic_5_outputData = (s1_byteLogic_5_buffer_valid ? s1_byteLogic_5_buffer_data : s1_byteLogic_5_inputData);
  assign s1_byteLogic_6_selOh_0 = (s1_input_payload_cmd_mask[0] && (s1_input_payload_index_0 == 3'b110));
  assign s1_byteLogic_6_selOh_1 = (s1_input_payload_cmd_mask[1] && (s1_input_payload_index_1 == 3'b110));
  assign s1_byteLogic_6_selOh_2 = (s1_input_payload_cmd_mask[2] && (s1_input_payload_index_2 == 3'b110));
  assign s1_byteLogic_6_selOh_3 = (s1_input_payload_cmd_mask[3] && (s1_input_payload_index_3 == 3'b110));
  assign s1_byteLogic_6_selOh_4 = (s1_input_payload_cmd_mask[4] && (s1_input_payload_index_4 == 3'b110));
  assign s1_byteLogic_6_selOh_5 = (s1_input_payload_cmd_mask[5] && (s1_input_payload_index_5 == 3'b110));
  assign s1_byteLogic_6_selOh_6 = (s1_input_payload_cmd_mask[6] && (s1_input_payload_index_6 == 3'b110));
  assign s1_byteLogic_6_selOh_7 = (s1_input_payload_cmd_mask[7] && (s1_input_payload_index_7 == 3'b110));
  assign _zz_72 = (((s1_byteLogic_6_selOh_1 || s1_byteLogic_6_selOh_3) || s1_byteLogic_6_selOh_5) || s1_byteLogic_6_selOh_7);
  assign _zz_73 = (((s1_byteLogic_6_selOh_2 || s1_byteLogic_6_selOh_3) || s1_byteLogic_6_selOh_6) || s1_byteLogic_6_selOh_7);
  assign _zz_74 = (((s1_byteLogic_6_selOh_4 || s1_byteLogic_6_selOh_5) || s1_byteLogic_6_selOh_6) || s1_byteLogic_6_selOh_7);
  assign s1_byteLogic_6_sel = {_zz_74,{_zz_73,_zz_72}};
  assign s1_byteLogic_6_lastUsed = (3'b110 == io_output_lastByteUsed);
  always @ (*) begin
    _zz_75[0] = s1_byteLogic_6_selOh_0;
    _zz_75[1] = s1_byteLogic_6_selOh_1;
    _zz_75[2] = s1_byteLogic_6_selOh_2;
    _zz_75[3] = s1_byteLogic_6_selOh_3;
    _zz_75[4] = s1_byteLogic_6_selOh_4;
    _zz_75[5] = s1_byteLogic_6_selOh_5;
    _zz_75[6] = s1_byteLogic_6_selOh_6;
    _zz_75[7] = s1_byteLogic_6_selOh_7;
  end

  assign s1_byteLogic_6_inputMask = ((_zz_75 & s1_input_payload_cmd_mask) != 8'h0);
  assign s1_byteLogic_6_inputData = _zz_104;
  assign s1_byteLogic_6_outputMask = (s1_byteLogic_6_buffer_valid || (s1_input_valid && s1_byteLogic_6_inputMask));
  assign s1_byteLogic_6_outputData = (s1_byteLogic_6_buffer_valid ? s1_byteLogic_6_buffer_data : s1_byteLogic_6_inputData);
  assign s1_byteLogic_7_selOh_0 = (s1_input_payload_cmd_mask[0] && (s1_input_payload_index_0 == 3'b111));
  assign s1_byteLogic_7_selOh_1 = (s1_input_payload_cmd_mask[1] && (s1_input_payload_index_1 == 3'b111));
  assign s1_byteLogic_7_selOh_2 = (s1_input_payload_cmd_mask[2] && (s1_input_payload_index_2 == 3'b111));
  assign s1_byteLogic_7_selOh_3 = (s1_input_payload_cmd_mask[3] && (s1_input_payload_index_3 == 3'b111));
  assign s1_byteLogic_7_selOh_4 = (s1_input_payload_cmd_mask[4] && (s1_input_payload_index_4 == 3'b111));
  assign s1_byteLogic_7_selOh_5 = (s1_input_payload_cmd_mask[5] && (s1_input_payload_index_5 == 3'b111));
  assign s1_byteLogic_7_selOh_6 = (s1_input_payload_cmd_mask[6] && (s1_input_payload_index_6 == 3'b111));
  assign s1_byteLogic_7_selOh_7 = (s1_input_payload_cmd_mask[7] && (s1_input_payload_index_7 == 3'b111));
  assign _zz_76 = (((s1_byteLogic_7_selOh_1 || s1_byteLogic_7_selOh_3) || s1_byteLogic_7_selOh_5) || s1_byteLogic_7_selOh_7);
  assign _zz_77 = (((s1_byteLogic_7_selOh_2 || s1_byteLogic_7_selOh_3) || s1_byteLogic_7_selOh_6) || s1_byteLogic_7_selOh_7);
  assign _zz_78 = (((s1_byteLogic_7_selOh_4 || s1_byteLogic_7_selOh_5) || s1_byteLogic_7_selOh_6) || s1_byteLogic_7_selOh_7);
  assign s1_byteLogic_7_sel = {_zz_78,{_zz_77,_zz_76}};
  assign s1_byteLogic_7_lastUsed = (3'b111 == io_output_lastByteUsed);
  always @ (*) begin
    _zz_79[0] = s1_byteLogic_7_selOh_0;
    _zz_79[1] = s1_byteLogic_7_selOh_1;
    _zz_79[2] = s1_byteLogic_7_selOh_2;
    _zz_79[3] = s1_byteLogic_7_selOh_3;
    _zz_79[4] = s1_byteLogic_7_selOh_4;
    _zz_79[5] = s1_byteLogic_7_selOh_5;
    _zz_79[6] = s1_byteLogic_7_selOh_6;
    _zz_79[7] = s1_byteLogic_7_selOh_7;
  end

  assign s1_byteLogic_7_inputMask = ((_zz_79 & s1_input_payload_cmd_mask) != 8'h0);
  assign s1_byteLogic_7_inputData = _zz_105;
  assign s1_byteLogic_7_outputMask = (s1_byteLogic_7_buffer_valid || (s1_input_valid && s1_byteLogic_7_inputMask));
  assign s1_byteLogic_7_outputData = (s1_byteLogic_7_buffer_valid ? s1_byteLogic_7_buffer_data : s1_byteLogic_7_inputData);
  assign _zz_80 = (((s1_byteLogic_1_lastUsed || s1_byteLogic_3_lastUsed) || s1_byteLogic_5_lastUsed) || s1_byteLogic_7_lastUsed);
  assign _zz_81 = (((s1_byteLogic_2_lastUsed || s1_byteLogic_3_lastUsed) || s1_byteLogic_6_lastUsed) || s1_byteLogic_7_lastUsed);
  assign _zz_82 = (((s1_byteLogic_4_lastUsed || s1_byteLogic_5_lastUsed) || s1_byteLogic_6_lastUsed) || s1_byteLogic_7_lastUsed);
  assign io_output_usedUntil = _zz_106;
  always @ (posedge clk) begin
    if((io_input_valid && io_input_ready))begin
      s0_offset <= s0_offsetNext[2:0];
    end
    if(io_flush)begin
      s0_offset <= io_offset;
    end
    if((io_input_valid && io_input_ready))begin
      s0_byteCounter <= (s0_byteCounter + _zz_118);
    end
    if(io_flush)begin
      s0_byteCounter <= 12'h0;
    end
    if(s0_output_ready)begin
      s0_output_m2sPipe_rData_cmd_data <= s0_output_payload_cmd_data;
      s0_output_m2sPipe_rData_cmd_mask <= s0_output_payload_cmd_mask;
      s0_output_m2sPipe_rData_index_0 <= s0_output_payload_index_0;
      s0_output_m2sPipe_rData_index_1 <= s0_output_payload_index_1;
      s0_output_m2sPipe_rData_index_2 <= s0_output_payload_index_2;
      s0_output_m2sPipe_rData_index_3 <= s0_output_payload_index_3;
      s0_output_m2sPipe_rData_index_4 <= s0_output_payload_index_4;
      s0_output_m2sPipe_rData_index_5 <= s0_output_payload_index_5;
      s0_output_m2sPipe_rData_index_6 <= s0_output_payload_index_6;
      s0_output_m2sPipe_rData_index_7 <= s0_output_payload_index_7;
      s0_output_m2sPipe_rData_last <= s0_output_payload_last;
    end
    if(io_output_consume)begin
      s1_byteLogic_0_buffer_valid <= 1'b0;
    end
    if((s1_input_valid && s1_input_ready))begin
      if(s1_input_payload_last)begin
        s1_byteLogic_0_buffer_valid <= 1'b0;
      end
      if((s1_byteLogic_0_inputMask && ((! io_output_consume) || s1_byteLogic_0_buffer_valid)))begin
        s1_byteLogic_0_buffer_valid <= 1'b1;
        s1_byteLogic_0_buffer_data <= s1_byteLogic_0_inputData;
      end
    end
    if(io_flush)begin
      s1_byteLogic_0_buffer_valid <= (3'b000 < io_offset);
    end
    if(io_output_consume)begin
      s1_byteLogic_1_buffer_valid <= 1'b0;
    end
    if((s1_input_valid && s1_input_ready))begin
      if(s1_input_payload_last)begin
        s1_byteLogic_1_buffer_valid <= 1'b0;
      end
      if((s1_byteLogic_1_inputMask && ((! io_output_consume) || s1_byteLogic_1_buffer_valid)))begin
        s1_byteLogic_1_buffer_valid <= 1'b1;
        s1_byteLogic_1_buffer_data <= s1_byteLogic_1_inputData;
      end
    end
    if(io_flush)begin
      s1_byteLogic_1_buffer_valid <= (3'b001 < io_offset);
    end
    if(io_output_consume)begin
      s1_byteLogic_2_buffer_valid <= 1'b0;
    end
    if((s1_input_valid && s1_input_ready))begin
      if(s1_input_payload_last)begin
        s1_byteLogic_2_buffer_valid <= 1'b0;
      end
      if((s1_byteLogic_2_inputMask && ((! io_output_consume) || s1_byteLogic_2_buffer_valid)))begin
        s1_byteLogic_2_buffer_valid <= 1'b1;
        s1_byteLogic_2_buffer_data <= s1_byteLogic_2_inputData;
      end
    end
    if(io_flush)begin
      s1_byteLogic_2_buffer_valid <= (3'b010 < io_offset);
    end
    if(io_output_consume)begin
      s1_byteLogic_3_buffer_valid <= 1'b0;
    end
    if((s1_input_valid && s1_input_ready))begin
      if(s1_input_payload_last)begin
        s1_byteLogic_3_buffer_valid <= 1'b0;
      end
      if((s1_byteLogic_3_inputMask && ((! io_output_consume) || s1_byteLogic_3_buffer_valid)))begin
        s1_byteLogic_3_buffer_valid <= 1'b1;
        s1_byteLogic_3_buffer_data <= s1_byteLogic_3_inputData;
      end
    end
    if(io_flush)begin
      s1_byteLogic_3_buffer_valid <= (3'b011 < io_offset);
    end
    if(io_output_consume)begin
      s1_byteLogic_4_buffer_valid <= 1'b0;
    end
    if((s1_input_valid && s1_input_ready))begin
      if(s1_input_payload_last)begin
        s1_byteLogic_4_buffer_valid <= 1'b0;
      end
      if((s1_byteLogic_4_inputMask && ((! io_output_consume) || s1_byteLogic_4_buffer_valid)))begin
        s1_byteLogic_4_buffer_valid <= 1'b1;
        s1_byteLogic_4_buffer_data <= s1_byteLogic_4_inputData;
      end
    end
    if(io_flush)begin
      s1_byteLogic_4_buffer_valid <= (3'b100 < io_offset);
    end
    if(io_output_consume)begin
      s1_byteLogic_5_buffer_valid <= 1'b0;
    end
    if((s1_input_valid && s1_input_ready))begin
      if(s1_input_payload_last)begin
        s1_byteLogic_5_buffer_valid <= 1'b0;
      end
      if((s1_byteLogic_5_inputMask && ((! io_output_consume) || s1_byteLogic_5_buffer_valid)))begin
        s1_byteLogic_5_buffer_valid <= 1'b1;
        s1_byteLogic_5_buffer_data <= s1_byteLogic_5_inputData;
      end
    end
    if(io_flush)begin
      s1_byteLogic_5_buffer_valid <= (3'b101 < io_offset);
    end
    if(io_output_consume)begin
      s1_byteLogic_6_buffer_valid <= 1'b0;
    end
    if((s1_input_valid && s1_input_ready))begin
      if(s1_input_payload_last)begin
        s1_byteLogic_6_buffer_valid <= 1'b0;
      end
      if((s1_byteLogic_6_inputMask && ((! io_output_consume) || s1_byteLogic_6_buffer_valid)))begin
        s1_byteLogic_6_buffer_valid <= 1'b1;
        s1_byteLogic_6_buffer_data <= s1_byteLogic_6_inputData;
      end
    end
    if(io_flush)begin
      s1_byteLogic_6_buffer_valid <= (3'b110 < io_offset);
    end
    if(io_output_consume)begin
      s1_byteLogic_7_buffer_valid <= 1'b0;
    end
    if((s1_input_valid && s1_input_ready))begin
      if(s1_input_payload_last)begin
        s1_byteLogic_7_buffer_valid <= 1'b0;
      end
      if((s1_byteLogic_7_inputMask && ((! io_output_consume) || s1_byteLogic_7_buffer_valid)))begin
        s1_byteLogic_7_buffer_valid <= 1'b1;
        s1_byteLogic_7_buffer_data <= s1_byteLogic_7_inputData;
      end
    end
    if(io_flush)begin
      s1_byteLogic_7_buffer_valid <= (3'b111 < io_offset);
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      s0_output_m2sPipe_rValid <= 1'b0;
    end else begin
      if(s0_output_ready)begin
        s0_output_m2sPipe_rValid <= s0_output_valid;
      end
      if(io_flush)begin
        s0_output_m2sPipe_rValid <= 1'b0;
      end
    end
  end


endmodule

//dma_socRuby_StreamArbiter replaced by dma_socRuby_StreamArbiter

module dma_socRuby_StreamArbiter (
  input               io_inputs_0_valid,
  output              io_inputs_0_ready,
  input               io_inputs_1_valid,
  output              io_inputs_1_ready,
  output              io_output_valid,
  input               io_output_ready,
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
  wire                locked;
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
  assign locked = 1'b0;
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_1 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_2 = {_zz_1,_zz_1};
  assign _zz_3 = (_zz_2 & (~ _zz_6));
  assign _zz_4 = (_zz_3[3 : 2] | _zz_3[1 : 0]);
  assign maskProposal_0 = _zz_9[0];
  assign maskProposal_1 = _zz_10[0];
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_5 = io_chosenOH[1];
  assign io_chosen = _zz_5;
  always @ (posedge clk) begin
    if(reset) begin
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid)begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
    end
  end


endmodule

module dma_socRuby_DmaMemoryCore (
  input               io_writes_0_cmd_valid,
  output              io_writes_0_cmd_ready,
  input      [9:0]    io_writes_0_cmd_payload_address,
  input      [63:0]   io_writes_0_cmd_payload_data,
  input      [7:0]    io_writes_0_cmd_payload_mask,
  input      [1:0]    io_writes_0_cmd_payload_priority,
  input      [6:0]    io_writes_0_cmd_payload_context,
  output              io_writes_0_rsp_valid,
  output     [6:0]    io_writes_0_rsp_payload_context,
  input               io_writes_1_cmd_valid,
  output              io_writes_1_cmd_ready,
  input      [9:0]    io_writes_1_cmd_payload_address,
  input      [63:0]   io_writes_1_cmd_payload_data,
  input      [7:0]    io_writes_1_cmd_payload_mask,
  input      [1:0]    io_writes_1_cmd_payload_priority,
  input      [6:0]    io_writes_1_cmd_payload_context,
  output              io_writes_1_rsp_valid,
  output     [6:0]    io_writes_1_rsp_payload_context,
  input               io_writes_2_cmd_valid,
  output              io_writes_2_cmd_ready,
  input      [9:0]    io_writes_2_cmd_payload_address,
  input      [63:0]   io_writes_2_cmd_payload_data,
  input      [7:0]    io_writes_2_cmd_payload_mask,
  input      [6:0]    io_writes_2_cmd_payload_context,
  output              io_writes_2_rsp_valid,
  output     [6:0]    io_writes_2_rsp_payload_context,
  input               io_reads_0_cmd_valid,
  output              io_reads_0_cmd_ready,
  input      [9:0]    io_reads_0_cmd_payload_address,
  input      [1:0]    io_reads_0_cmd_payload_priority,
  input      [2:0]    io_reads_0_cmd_payload_context,
  output              io_reads_0_rsp_valid,
  input               io_reads_0_rsp_ready,
  output     [63:0]   io_reads_0_rsp_payload_data,
  output     [7:0]    io_reads_0_rsp_payload_mask,
  output     [2:0]    io_reads_0_rsp_payload_context,
  input               io_reads_1_cmd_valid,
  output              io_reads_1_cmd_ready,
  input      [9:0]    io_reads_1_cmd_payload_address,
  input      [1:0]    io_reads_1_cmd_payload_priority,
  input      [2:0]    io_reads_1_cmd_payload_context,
  output              io_reads_1_rsp_valid,
  input               io_reads_1_rsp_ready,
  output     [63:0]   io_reads_1_rsp_payload_data,
  output     [7:0]    io_reads_1_rsp_payload_mask,
  output     [2:0]    io_reads_1_rsp_payload_context,
  input               io_reads_2_cmd_valid,
  output              io_reads_2_cmd_ready,
  input      [9:0]    io_reads_2_cmd_payload_address,
  input      [11:0]   io_reads_2_cmd_payload_context,
  output              io_reads_2_rsp_valid,
  input               io_reads_2_rsp_ready,
  output     [63:0]   io_reads_2_rsp_payload_data,
  output     [7:0]    io_reads_2_rsp_payload_mask,
  output     [11:0]   io_reads_2_rsp_payload_context,
  input               clk,
  input               reset
);
  reg        [71:0]   _zz_28;
  wire                _zz_29;
  wire                _zz_30;
  wire                _zz_31;
  wire                _zz_32;
  wire                _zz_33;
  wire                _zz_34;
  wire                _zz_35;
  wire                _zz_36;
  wire                _zz_37;
  wire       [7:0]    _zz_38;
  wire       [7:0]    _zz_39;
  wire       [7:0]    _zz_40;
  wire       [7:0]    _zz_41;
  wire       [0:0]    _zz_42;
  wire       [0:0]    _zz_43;
  wire       [71:0]   _zz_44;
  reg                 _zz_1;
  wire                banks_0_write_valid;
  wire       [9:0]    banks_0_write_payload_address;
  wire       [63:0]   banks_0_write_payload_data_data;
  wire       [7:0]    banks_0_write_payload_data_mask;
  wire                banks_0_read_cmd_valid;
  wire       [9:0]    banks_0_read_cmd_payload;
  wire       [63:0]   banks_0_read_rsp_data;
  wire       [7:0]    banks_0_read_rsp_mask;
  wire       [71:0]   _zz_2;
  wire                banks_0_writeOr_value_valid;
  wire       [9:0]    banks_0_writeOr_value_payload_address;
  wire       [63:0]   banks_0_writeOr_value_payload_data_data;
  wire       [7:0]    banks_0_writeOr_value_payload_data_mask;
  wire                banks_0_readOr_value_valid;
  wire       [9:0]    banks_0_readOr_value_payload;
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
  reg                 _zz_3;
  reg        [9:0]    _zz_4;
  reg        [63:0]   _zz_5;
  reg        [7:0]    _zz_6;
  reg                 write_arbiter_0_doIt_regNext;
  reg        [6:0]    io_writes_0_cmd_payload_context_regNext;
  reg        [1:0]    write_arbiter_1_losedAgainst;
  wire                write_arbiter_1_doIt;
  reg                 _zz_7;
  reg        [9:0]    _zz_8;
  reg        [63:0]   _zz_9;
  reg        [7:0]    _zz_10;
  reg                 write_arbiter_1_doIt_regNext;
  reg        [6:0]    io_writes_1_cmd_payload_context_regNext;
  reg        [1:0]    write_arbiter_2_losedAgainst;
  wire                write_arbiter_2_doIt;
  reg                 _zz_11;
  reg        [9:0]    _zz_12;
  reg        [63:0]   _zz_13;
  reg        [7:0]    _zz_14;
  reg                 write_arbiter_2_doIt_regNext;
  reg        [6:0]    io_writes_2_cmd_payload_context_regNext;
  wire                read_ports_0_buffer_s0_valid;
  wire       [2:0]    read_ports_0_buffer_s0_payload_context;
  wire       [9:0]    read_ports_0_buffer_s0_payload_address;
  reg                 read_ports_0_buffer_s1_valid;
  reg        [2:0]    read_ports_0_buffer_s1_payload_context;
  reg        [9:0]    read_ports_0_buffer_s1_payload_address;
  wire                read_ports_0_buffer_bufferIn_valid;
  wire                read_ports_0_buffer_bufferIn_ready;
  wire       [63:0]   read_ports_0_buffer_bufferIn_payload_data;
  wire       [7:0]    read_ports_0_buffer_bufferIn_payload_mask;
  wire       [2:0]    read_ports_0_buffer_bufferIn_payload_context;
  wire                read_ports_0_buffer_bufferOut_valid;
  wire                read_ports_0_buffer_bufferOut_ready;
  wire       [63:0]   read_ports_0_buffer_bufferOut_payload_data;
  wire       [7:0]    read_ports_0_buffer_bufferOut_payload_mask;
  wire       [2:0]    read_ports_0_buffer_bufferOut_payload_context;
  reg                 read_ports_0_buffer_bufferIn_s2mPipe_rValid;
  reg        [63:0]   read_ports_0_buffer_bufferIn_s2mPipe_rData_data;
  reg        [7:0]    read_ports_0_buffer_bufferIn_s2mPipe_rData_mask;
  reg        [2:0]    read_ports_0_buffer_bufferIn_s2mPipe_rData_context;
  wire                read_ports_0_buffer_full;
  wire                _zz_15;
  wire                read_ports_0_cmd_valid;
  wire                read_ports_0_cmd_ready;
  wire       [9:0]    read_ports_0_cmd_payload_address;
  wire       [1:0]    read_ports_0_cmd_payload_priority;
  wire       [2:0]    read_ports_0_cmd_payload_context;
  reg        [7:0]    read_ports_0_priority_value = 8'b00000000;
  wire                read_ports_1_buffer_s0_valid;
  wire       [2:0]    read_ports_1_buffer_s0_payload_context;
  wire       [9:0]    read_ports_1_buffer_s0_payload_address;
  reg                 read_ports_1_buffer_s1_valid;
  reg        [2:0]    read_ports_1_buffer_s1_payload_context;
  reg        [9:0]    read_ports_1_buffer_s1_payload_address;
  wire                read_ports_1_buffer_bufferIn_valid;
  wire                read_ports_1_buffer_bufferIn_ready;
  wire       [63:0]   read_ports_1_buffer_bufferIn_payload_data;
  wire       [7:0]    read_ports_1_buffer_bufferIn_payload_mask;
  wire       [2:0]    read_ports_1_buffer_bufferIn_payload_context;
  wire                read_ports_1_buffer_bufferOut_valid;
  wire                read_ports_1_buffer_bufferOut_ready;
  wire       [63:0]   read_ports_1_buffer_bufferOut_payload_data;
  wire       [7:0]    read_ports_1_buffer_bufferOut_payload_mask;
  wire       [2:0]    read_ports_1_buffer_bufferOut_payload_context;
  reg                 read_ports_1_buffer_bufferIn_s2mPipe_rValid;
  reg        [63:0]   read_ports_1_buffer_bufferIn_s2mPipe_rData_data;
  reg        [7:0]    read_ports_1_buffer_bufferIn_s2mPipe_rData_mask;
  reg        [2:0]    read_ports_1_buffer_bufferIn_s2mPipe_rData_context;
  wire                read_ports_1_buffer_full;
  wire                _zz_16;
  wire                read_ports_1_cmd_valid;
  wire                read_ports_1_cmd_ready;
  wire       [9:0]    read_ports_1_cmd_payload_address;
  wire       [1:0]    read_ports_1_cmd_payload_priority;
  wire       [2:0]    read_ports_1_cmd_payload_context;
  reg        [7:0]    read_ports_1_priority_value = 8'b00000000;
  wire                read_ports_2_buffer_s0_valid;
  wire       [11:0]   read_ports_2_buffer_s0_payload_context;
  wire       [9:0]    read_ports_2_buffer_s0_payload_address;
  reg                 read_ports_2_buffer_s1_valid;
  reg        [11:0]   read_ports_2_buffer_s1_payload_context;
  reg        [9:0]    read_ports_2_buffer_s1_payload_address;
  wire                read_ports_2_buffer_bufferIn_valid;
  wire                read_ports_2_buffer_bufferIn_ready;
  wire       [63:0]   read_ports_2_buffer_bufferIn_payload_data;
  wire       [7:0]    read_ports_2_buffer_bufferIn_payload_mask;
  wire       [11:0]   read_ports_2_buffer_bufferIn_payload_context;
  wire                read_ports_2_buffer_bufferOut_valid;
  wire                read_ports_2_buffer_bufferOut_ready;
  wire       [63:0]   read_ports_2_buffer_bufferOut_payload_data;
  wire       [7:0]    read_ports_2_buffer_bufferOut_payload_mask;
  wire       [11:0]   read_ports_2_buffer_bufferOut_payload_context;
  reg                 read_ports_2_buffer_bufferIn_s2mPipe_rValid;
  reg        [63:0]   read_ports_2_buffer_bufferIn_s2mPipe_rData_data;
  reg        [7:0]    read_ports_2_buffer_bufferIn_s2mPipe_rData_mask;
  reg        [11:0]   read_ports_2_buffer_bufferIn_s2mPipe_rData_context;
  wire                read_ports_2_buffer_full;
  wire                _zz_17;
  wire                read_ports_2_cmd_valid;
  wire                read_ports_2_cmd_ready;
  wire       [9:0]    read_ports_2_cmd_payload_address;
  wire       [11:0]   read_ports_2_cmd_payload_context;
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
  reg                 _zz_18;
  reg        [9:0]    _zz_19;
  reg        [1:0]    read_arbiter_1_losedAgainst;
  wire                read_arbiter_1_doIt;
  reg                 _zz_20;
  reg        [9:0]    _zz_21;
  reg        [1:0]    read_arbiter_2_losedAgainst;
  wire                read_arbiter_2_doIt;
  reg                 _zz_22;
  reg        [9:0]    _zz_23;
  wire       [82:0]   _zz_24;
  wire       [81:0]   _zz_25;
  wire       [71:0]   _zz_26;
  wire       [10:0]   _zz_27;
  (* ram_style = "block" *) reg [71:0] banks_0_ram [0:1023];

  assign _zz_29 = (write_arbiter_0_doIt && 1'b1);
  assign _zz_30 = (write_arbiter_1_doIt && 1'b1);
  assign _zz_31 = (write_arbiter_2_doIt && 1'b1);
  assign _zz_32 = (read_arbiter_0_doIt && 1'b1);
  assign _zz_33 = (read_arbiter_1_doIt && 1'b1);
  assign _zz_34 = (read_arbiter_2_doIt && 1'b1);
  assign _zz_35 = (read_ports_0_buffer_bufferIn_ready && (! read_ports_0_buffer_bufferOut_ready));
  assign _zz_36 = (read_ports_1_buffer_bufferIn_ready && (! read_ports_1_buffer_bufferOut_ready));
  assign _zz_37 = (read_ports_2_buffer_bufferIn_ready && (! read_ports_2_buffer_bufferOut_ready));
  assign _zz_38 = {6'd0, io_writes_0_cmd_payload_priority};
  assign _zz_39 = {6'd0, io_writes_1_cmd_payload_priority};
  assign _zz_40 = {6'd0, read_ports_0_cmd_payload_priority};
  assign _zz_41 = {6'd0, read_ports_1_cmd_payload_priority};
  assign _zz_42 = _zz_24[0 : 0];
  assign _zz_43 = _zz_27[0 : 0];
  assign _zz_44 = {banks_0_write_payload_data_mask,banks_0_write_payload_data_data};
  always @ (posedge clk) begin
    if(_zz_1) begin
      banks_0_ram[banks_0_write_payload_address] <= _zz_44;
    end
  end

  always @ (posedge clk) begin
    if(banks_0_read_cmd_valid) begin
      _zz_28 <= banks_0_ram[banks_0_read_cmd_payload];
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(banks_0_write_valid)begin
      _zz_1 = 1'b1;
    end
  end

  assign _zz_2 = _zz_28;
  assign banks_0_read_rsp_data = _zz_2[63 : 0];
  assign banks_0_read_rsp_mask = _zz_2[71 : 64];
  assign banks_0_write_valid = banks_0_writeOr_value_valid;
  assign banks_0_write_payload_address = banks_0_writeOr_value_payload_address;
  assign banks_0_write_payload_data_data = banks_0_writeOr_value_payload_data_data;
  assign banks_0_write_payload_data_mask = banks_0_writeOr_value_payload_data_mask;
  assign banks_0_read_cmd_valid = banks_0_readOr_value_valid;
  assign banks_0_read_cmd_payload = banks_0_readOr_value_payload;
  assign write_nodes_0_1_priority = (write_ports_1_priority_value < write_ports_0_priority_value);
  assign write_nodes_1_0_priority = (! write_nodes_0_1_priority);
  assign write_nodes_0_1_conflict = ((io_writes_0_cmd_valid && io_writes_1_cmd_valid) && (((io_writes_0_cmd_payload_address ^ io_writes_1_cmd_payload_address) & 10'h0) == 10'h0));
  assign write_nodes_1_0_conflict = write_nodes_0_1_conflict;
  assign write_nodes_0_2_priority = 1'b0;
  assign write_nodes_2_0_priority = 1'b1;
  assign write_nodes_0_2_conflict = ((io_writes_0_cmd_valid && io_writes_2_cmd_valid) && (((io_writes_0_cmd_payload_address ^ io_writes_2_cmd_payload_address) & 10'h0) == 10'h0));
  assign write_nodes_2_0_conflict = write_nodes_0_2_conflict;
  assign write_nodes_1_2_priority = 1'b0;
  assign write_nodes_2_1_priority = 1'b1;
  assign write_nodes_1_2_conflict = ((io_writes_1_cmd_valid && io_writes_2_cmd_valid) && (((io_writes_1_cmd_payload_address ^ io_writes_2_cmd_payload_address) & 10'h0) == 10'h0));
  assign write_nodes_2_1_conflict = write_nodes_1_2_conflict;
  always @ (*) begin
    write_arbiter_0_losedAgainst[0] = (write_nodes_0_1_conflict && (! write_nodes_0_1_priority));
    write_arbiter_0_losedAgainst[1] = (write_nodes_0_2_conflict && (! write_nodes_0_2_priority));
  end

  assign write_arbiter_0_doIt = (io_writes_0_cmd_valid && (write_arbiter_0_losedAgainst == 2'b00));
  always @ (*) begin
    if(_zz_29)begin
      _zz_3 = 1'b1;
    end else begin
      _zz_3 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_29)begin
      _zz_4 = (io_writes_0_cmd_payload_address >>> 0);
    end else begin
      _zz_4 = 10'h0;
    end
  end

  always @ (*) begin
    if(_zz_29)begin
      _zz_5 = io_writes_0_cmd_payload_data[63 : 0];
    end else begin
      _zz_5 = 64'h0;
    end
  end

  always @ (*) begin
    if(_zz_29)begin
      _zz_6 = io_writes_0_cmd_payload_mask[7 : 0];
    end else begin
      _zz_6 = 8'h0;
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
    if(_zz_30)begin
      _zz_7 = 1'b1;
    end else begin
      _zz_7 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_30)begin
      _zz_8 = (io_writes_1_cmd_payload_address >>> 0);
    end else begin
      _zz_8 = 10'h0;
    end
  end

  always @ (*) begin
    if(_zz_30)begin
      _zz_9 = io_writes_1_cmd_payload_data[63 : 0];
    end else begin
      _zz_9 = 64'h0;
    end
  end

  always @ (*) begin
    if(_zz_30)begin
      _zz_10 = io_writes_1_cmd_payload_mask[7 : 0];
    end else begin
      _zz_10 = 8'h0;
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
    if(_zz_31)begin
      _zz_11 = 1'b1;
    end else begin
      _zz_11 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_31)begin
      _zz_12 = (io_writes_2_cmd_payload_address >>> 0);
    end else begin
      _zz_12 = 10'h0;
    end
  end

  always @ (*) begin
    if(_zz_31)begin
      _zz_13 = io_writes_2_cmd_payload_data[63 : 0];
    end else begin
      _zz_13 = 64'h0;
    end
  end

  always @ (*) begin
    if(_zz_31)begin
      _zz_14 = io_writes_2_cmd_payload_mask[7 : 0];
    end else begin
      _zz_14 = 8'h0;
    end
  end

  assign io_writes_2_cmd_ready = write_arbiter_2_doIt;
  assign io_writes_2_rsp_valid = write_arbiter_2_doIt_regNext;
  assign io_writes_2_rsp_payload_context = io_writes_2_cmd_payload_context_regNext;
  assign read_ports_0_buffer_bufferIn_valid = read_ports_0_buffer_s1_valid;
  assign read_ports_0_buffer_bufferIn_payload_context = read_ports_0_buffer_s1_payload_context;
  assign read_ports_0_buffer_bufferIn_payload_data = banks_0_read_rsp_data;
  assign read_ports_0_buffer_bufferIn_payload_mask = banks_0_read_rsp_mask;
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
  assign _zz_15 = (! read_ports_0_buffer_full);
  assign read_ports_0_cmd_valid = (io_reads_0_cmd_valid && _zz_15);
  assign io_reads_0_cmd_ready = (read_ports_0_cmd_ready && _zz_15);
  assign read_ports_0_cmd_payload_address = io_reads_0_cmd_payload_address;
  assign read_ports_0_cmd_payload_priority = io_reads_0_cmd_payload_priority;
  assign read_ports_0_cmd_payload_context = io_reads_0_cmd_payload_context;
  assign read_ports_1_buffer_bufferIn_valid = read_ports_1_buffer_s1_valid;
  assign read_ports_1_buffer_bufferIn_payload_context = read_ports_1_buffer_s1_payload_context;
  assign read_ports_1_buffer_bufferIn_payload_data = banks_0_read_rsp_data;
  assign read_ports_1_buffer_bufferIn_payload_mask = banks_0_read_rsp_mask;
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
  assign _zz_16 = (! read_ports_1_buffer_full);
  assign read_ports_1_cmd_valid = (io_reads_1_cmd_valid && _zz_16);
  assign io_reads_1_cmd_ready = (read_ports_1_cmd_ready && _zz_16);
  assign read_ports_1_cmd_payload_address = io_reads_1_cmd_payload_address;
  assign read_ports_1_cmd_payload_priority = io_reads_1_cmd_payload_priority;
  assign read_ports_1_cmd_payload_context = io_reads_1_cmd_payload_context;
  assign read_ports_2_buffer_bufferIn_valid = read_ports_2_buffer_s1_valid;
  assign read_ports_2_buffer_bufferIn_payload_context = read_ports_2_buffer_s1_payload_context;
  assign read_ports_2_buffer_bufferIn_payload_data = banks_0_read_rsp_data;
  assign read_ports_2_buffer_bufferIn_payload_mask = banks_0_read_rsp_mask;
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
  assign _zz_17 = (! read_ports_2_buffer_full);
  assign read_ports_2_cmd_valid = (io_reads_2_cmd_valid && _zz_17);
  assign io_reads_2_cmd_ready = (read_ports_2_cmd_ready && _zz_17);
  assign read_ports_2_cmd_payload_address = io_reads_2_cmd_payload_address;
  assign read_ports_2_cmd_payload_context = io_reads_2_cmd_payload_context;
  assign read_nodes_0_1_priority = (read_ports_1_priority_value < read_ports_0_priority_value);
  assign read_nodes_1_0_priority = (! read_nodes_0_1_priority);
  assign read_nodes_0_1_conflict = ((read_ports_0_cmd_valid && read_ports_1_cmd_valid) && (((read_ports_0_cmd_payload_address ^ io_reads_1_cmd_payload_address) & 10'h0) == 10'h0));
  assign read_nodes_1_0_conflict = read_nodes_0_1_conflict;
  assign read_nodes_0_2_priority = 1'b0;
  assign read_nodes_2_0_priority = 1'b1;
  assign read_nodes_0_2_conflict = ((read_ports_0_cmd_valid && read_ports_2_cmd_valid) && (((read_ports_0_cmd_payload_address ^ io_reads_2_cmd_payload_address) & 10'h0) == 10'h0));
  assign read_nodes_2_0_conflict = read_nodes_0_2_conflict;
  assign read_nodes_1_2_priority = 1'b0;
  assign read_nodes_2_1_priority = 1'b1;
  assign read_nodes_1_2_conflict = ((read_ports_1_cmd_valid && read_ports_2_cmd_valid) && (((read_ports_1_cmd_payload_address ^ io_reads_2_cmd_payload_address) & 10'h0) == 10'h0));
  assign read_nodes_2_1_conflict = read_nodes_1_2_conflict;
  always @ (*) begin
    read_arbiter_0_losedAgainst[0] = (read_nodes_0_1_conflict && (! read_nodes_0_1_priority));
    read_arbiter_0_losedAgainst[1] = (read_nodes_0_2_conflict && (! read_nodes_0_2_priority));
  end

  assign read_arbiter_0_doIt = (read_ports_0_cmd_valid && (read_arbiter_0_losedAgainst == 2'b00));
  always @ (*) begin
    if(_zz_32)begin
      _zz_18 = 1'b1;
    end else begin
      _zz_18 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_32)begin
      _zz_19 = (read_ports_0_cmd_payload_address >>> 0);
    end else begin
      _zz_19 = 10'h0;
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
    if(_zz_33)begin
      _zz_20 = 1'b1;
    end else begin
      _zz_20 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_33)begin
      _zz_21 = (read_ports_1_cmd_payload_address >>> 0);
    end else begin
      _zz_21 = 10'h0;
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
    if(_zz_34)begin
      _zz_22 = 1'b1;
    end else begin
      _zz_22 = 1'b0;
    end
  end

  always @ (*) begin
    if(_zz_34)begin
      _zz_23 = (read_ports_2_cmd_payload_address >>> 0);
    end else begin
      _zz_23 = 10'h0;
    end
  end

  assign read_ports_2_cmd_ready = read_arbiter_2_doIt;
  assign read_ports_2_buffer_s0_valid = read_arbiter_2_doIt;
  assign read_ports_2_buffer_s0_payload_context = read_ports_2_cmd_payload_context;
  assign read_ports_2_buffer_s0_payload_address = read_ports_2_cmd_payload_address;
  assign _zz_24 = (({{{_zz_6,_zz_5},_zz_4},_zz_3} | {{{_zz_10,_zz_9},_zz_8},_zz_7}) | {{{_zz_14,_zz_13},_zz_12},_zz_11});
  assign banks_0_writeOr_value_valid = _zz_42[0];
  assign _zz_25 = _zz_24[82 : 1];
  assign banks_0_writeOr_value_payload_address = _zz_25[9 : 0];
  assign _zz_26 = _zz_25[81 : 10];
  assign banks_0_writeOr_value_payload_data_data = _zz_26[63 : 0];
  assign banks_0_writeOr_value_payload_data_mask = _zz_26[71 : 64];
  assign _zz_27 = (({_zz_19,_zz_18} | {_zz_21,_zz_20}) | {_zz_23,_zz_22});
  assign banks_0_readOr_value_valid = _zz_43[0];
  assign banks_0_readOr_value_payload = _zz_27[10 : 1];
  always @ (posedge clk) begin
    if(io_writes_0_cmd_valid)begin
      write_ports_0_priority_value <= (write_ports_0_priority_value + _zz_38);
      if(io_writes_0_cmd_ready)begin
        write_ports_0_priority_value <= 8'h0;
      end
    end
    if(io_writes_1_cmd_valid)begin
      write_ports_1_priority_value <= (write_ports_1_priority_value + _zz_39);
      if(io_writes_1_cmd_ready)begin
        write_ports_1_priority_value <= 8'h0;
      end
    end
    io_writes_0_cmd_payload_context_regNext <= io_writes_0_cmd_payload_context;
    io_writes_1_cmd_payload_context_regNext <= io_writes_1_cmd_payload_context;
    io_writes_2_cmd_payload_context_regNext <= io_writes_2_cmd_payload_context;
    read_ports_0_buffer_s1_payload_context <= read_ports_0_buffer_s0_payload_context;
    read_ports_0_buffer_s1_payload_address <= read_ports_0_buffer_s0_payload_address;
    if(_zz_35)begin
      read_ports_0_buffer_bufferIn_s2mPipe_rData_data <= read_ports_0_buffer_bufferIn_payload_data;
      read_ports_0_buffer_bufferIn_s2mPipe_rData_mask <= read_ports_0_buffer_bufferIn_payload_mask;
      read_ports_0_buffer_bufferIn_s2mPipe_rData_context <= read_ports_0_buffer_bufferIn_payload_context;
    end
    if(read_ports_0_cmd_valid)begin
      read_ports_0_priority_value <= (read_ports_0_priority_value + _zz_40);
      if(read_ports_0_cmd_ready)begin
        read_ports_0_priority_value <= 8'h0;
      end
    end
    read_ports_1_buffer_s1_payload_context <= read_ports_1_buffer_s0_payload_context;
    read_ports_1_buffer_s1_payload_address <= read_ports_1_buffer_s0_payload_address;
    if(_zz_36)begin
      read_ports_1_buffer_bufferIn_s2mPipe_rData_data <= read_ports_1_buffer_bufferIn_payload_data;
      read_ports_1_buffer_bufferIn_s2mPipe_rData_mask <= read_ports_1_buffer_bufferIn_payload_mask;
      read_ports_1_buffer_bufferIn_s2mPipe_rData_context <= read_ports_1_buffer_bufferIn_payload_context;
    end
    if(read_ports_1_cmd_valid)begin
      read_ports_1_priority_value <= (read_ports_1_priority_value + _zz_41);
      if(read_ports_1_cmd_ready)begin
        read_ports_1_priority_value <= 8'h0;
      end
    end
    read_ports_2_buffer_s1_payload_context <= read_ports_2_buffer_s0_payload_context;
    read_ports_2_buffer_s1_payload_address <= read_ports_2_buffer_s0_payload_address;
    if(_zz_37)begin
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
      if(_zz_35)begin
        read_ports_0_buffer_bufferIn_s2mPipe_rValid <= read_ports_0_buffer_bufferIn_valid;
      end
      read_ports_1_buffer_s1_valid <= read_ports_1_buffer_s0_valid;
      if(read_ports_1_buffer_bufferOut_ready)begin
        read_ports_1_buffer_bufferIn_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_36)begin
        read_ports_1_buffer_bufferIn_s2mPipe_rValid <= read_ports_1_buffer_bufferIn_valid;
      end
      read_ports_2_buffer_s1_valid <= read_ports_2_buffer_s0_valid;
      if(read_ports_2_buffer_bufferOut_ready)begin
        read_ports_2_buffer_bufferIn_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_37)begin
        read_ports_2_buffer_bufferIn_s2mPipe_rValid <= read_ports_2_buffer_bufferIn_valid;
      end
    end
  end


endmodule

module dma_socRuby_StreamFifo_1 (
  input               io_push_valid,
  output              io_push_ready,
  input      [14:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [14:0]   io_pop_payload,
  input               io_flush,
  output reg [2:0]    io_occupancy,
  output reg [2:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [14:0]   _zz_3;
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
  reg [14:0] logic_ram [0:6];

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
  input      [10:0]   io_input_payload_fragment_length,
  input      [255:0]  io_input_payload_fragment_data,
  input      [31:0]   io_input_payload_fragment_mask,
  input      [14:0]   io_input_payload_fragment_context,
  output              io_outputs_0_valid,
  input               io_outputs_0_ready,
  output              io_outputs_0_payload_last,
  output     [0:0]    io_outputs_0_payload_fragment_opcode,
  output     [31:0]   io_outputs_0_payload_fragment_address,
  output     [10:0]   io_outputs_0_payload_fragment_length,
  output     [255:0]  io_outputs_0_payload_fragment_data,
  output     [31:0]   io_outputs_0_payload_fragment_mask,
  output     [14:0]   io_outputs_0_payload_fragment_context,
  output              io_outputs_1_valid,
  input               io_outputs_1_ready,
  output              io_outputs_1_payload_last,
  output     [0:0]    io_outputs_1_payload_fragment_opcode,
  output     [31:0]   io_outputs_1_payload_fragment_address,
  output     [10:0]   io_outputs_1_payload_fragment_length,
  output     [255:0]  io_outputs_1_payload_fragment_data,
  output     [31:0]   io_outputs_1_payload_fragment_mask,
  output     [14:0]   io_outputs_1_payload_fragment_context,
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
  input      [24:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [24:0]   io_pop_payload,
  input               io_flush,
  output reg [2:0]    io_occupancy,
  output reg [2:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [24:0]   _zz_3;
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
  reg [24:0] logic_ram [0:6];

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
  input      [10:0]   io_input_payload_fragment_length,
  input      [24:0]   io_input_payload_fragment_context,
  output              io_outputs_0_valid,
  input               io_outputs_0_ready,
  output              io_outputs_0_payload_last,
  output     [0:0]    io_outputs_0_payload_fragment_opcode,
  output     [31:0]   io_outputs_0_payload_fragment_address,
  output     [10:0]   io_outputs_0_payload_fragment_length,
  output     [24:0]   io_outputs_0_payload_fragment_context,
  output              io_outputs_1_valid,
  input               io_outputs_1_ready,
  output              io_outputs_1_payload_last,
  output     [0:0]    io_outputs_1_payload_fragment_opcode,
  output     [31:0]   io_outputs_1_payload_fragment_address,
  output     [10:0]   io_outputs_1_payload_fragment_length,
  output     [24:0]   io_outputs_1_payload_fragment_context,
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
  reg                 buffers_0;
  reg                 buffers_1;

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
  reg                 buffers_0;
  reg                 buffers_1;

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
