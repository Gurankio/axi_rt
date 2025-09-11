// Copyright (c) 2019-2020 ETH Zurich, University of Bologna
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Authors:
// - Wolfgang Roenninger <wroennin@iis.ee.ethz.ch>
// - Andreas Kurth <akurth@iis.ee.ethz.ch>

`include "axi/typedef.svh"
`include "common_cells/registers.svh"

/// This module can isolate the AXI4+ATOPs bus on the master port from the slave port.  When the
/// isolation is not active, the two ports are directly connected.
///
/// This module counts how many open transactions are currently in flight on the read and write
/// channels.  It is further capable of tracking the amount of open atomic transactions with read
/// responses.
///
/// The isolation interface has two signals: `isolate_i` and `isolated_o`.  When `isolate_i` is
/// asserted, all open transactions are gracefully terminated.  When no transactions are in flight
/// anymore, the `isolated_o` output is asserted.  As long as `isolated_o` is asserted, all output
/// signals in `mst_req_o` are silenced to `'0`.  When isolated, new transactions initiated on the
/// slave port are stalled until the isolation is terminated by deasserting `isolate_i`.
///
/// ## Response
///
/// If the `TerminateTransaction` parameter is set to `1'b1`, the module will return response errors
/// in case there is an incoming transaction while the module isolates.  The data returned on the
/// bus is `1501A7ED` (hexspeak for isolated).
///
/// If `TerminateTransaction` is set to `1'b0`, the transaction will block indefinitely until the
/// module is de-isolated again.
// `define DEBUG_AXI_ISOLATE 

module axi_isolate #(
  /// Address width of all AXI4+ATOP ports
  parameter int signed AxiAddrWidth = 32'd0,
  /// Data width of all AXI4+ATOP ports
  parameter int signed AxiDataWidth = 32'd0,
  /// ID width of all AXI4+ATOP ports
  parameter int signed AxiIdWidth = 32'd0,
  /// User signal width of all AXI4+ATOP ports
  parameter int signed AxiUserWidth = 32'd0,
  /// Request struct type of all AXI4+ATOP ports
  parameter type         axi_req_t  = logic,
  /// Response struct type of all AXI4+ATOP ports
  parameter type         axi_resp_t = logic
) (
  /// Rising-edge clock of all ports
  input  logic      clk_i,
  /// Asynchronous reset, active low
  input  logic      rst_ni,
  /// Slave port request
  input  axi_req_t  slv_req_i,
  /// Slave port response
  output axi_resp_t slv_resp_o,
  /// Master port request
  output axi_req_t  mst_req_o,
  /// Master port response
  input  axi_resp_t mst_resp_i,
  /// Isolate master port from slave port
  input  logic      isolate_r_i,
  /// Isolate master port from slave port
  input  logic      isolate_w_i
);

  typedef logic [AxiIdWidth-1:0]     id_t;
  typedef logic [AxiAddrWidth-1:0]   addr_t;
  typedef logic [AxiDataWidth-1:0]   data_t;
  typedef logic [AxiDataWidth/8-1:0] strb_t;
  typedef logic [AxiUserWidth-1:0]   user_t;

  `AXI_TYPEDEF_AW_CHAN_T(aw_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_W_CHAN_T(w_chan_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_B_CHAN_T(b_chan_t, id_t, user_t)
  `AXI_TYPEDEF_AR_CHAN_T(ar_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_R_CHAN_T(r_chan_t, data_t, id_t, user_t)

  axi_isolate_inner #(
    .axi_req_t  ( axi_req_t   ),
    .axi_resp_t ( axi_resp_t  )
  ) i_axi_isolate (
    .clk_i,
    .rst_ni,
    .slv_req_i  ( slv_req_i ),
    .slv_resp_o ( slv_resp_o ),
    .mst_req_o,
    .mst_resp_i,
    .isolate_r_i,
    .isolate_w_i
  );
endmodule

module axi_isolate_inner #(
  parameter type         axi_req_t  = logic,
  parameter type         axi_resp_t = logic
) (
  input  logic      clk_i,
  input  logic      rst_ni,
  input  axi_req_t  slv_req_i,
  output axi_resp_t slv_resp_o,
  output axi_req_t  mst_req_o,
  input  axi_resp_t mst_resp_i,
  input  logic      isolate_r_i,
  input  logic      isolate_w_i
);

  // Perform isolation.
  always_comb begin

    // Connect channel per default
    mst_req_o       = slv_req_i;
    slv_resp_o      = mst_resp_i;
    
    if (isolate_w_i) begin
        mst_req_o.aw_valid  = 1'b0;
        slv_resp_o.aw_ready = 1'b0;
    end

    if (isolate_r_i) begin 
        mst_req_o.ar_valid  = 1'b0;
        slv_resp_o.ar_ready = 1'b0;
    end
  end
endmodule
