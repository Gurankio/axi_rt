`include "axi/typedef.svh"
`include "axi/assign.svh"
`include "axi-rt/assign.svh"
`include "axi-rt/port.svh"

///  Vivado AXI flattned wrapper
module axi_write_buffer_flat #(
    parameter int unsigned NumOutstanding = 32'd16,
    parameter int unsigned WBufferDepth   = 32'd16,


    /// AXI
    /// Address width of all AXI4+ATOP ports
    parameter int signed AddrWidth = 48'd0,
    /// Data width of all AXI4+ATOP ports
    parameter int signed DataWidth = 64'd0,
    /// ID width of all AXI4+ATOP ports
    parameter int signed IdWidth = 4'd0,
    /// User signal width of all AXI4+ATOP ports
    parameter int signed UserWidth = 4'd0,
    // derived types for AXI interface
    parameter type axi_id_t   = logic [IdWidth-1    :0],
    parameter type axi_addr_t = logic [AddrWidth-1  :0],
    parameter type axi_data_t = logic [DataWidth-1  :0],
    parameter type axi_strb_t = logic [DataWidth/8-1:0],
    parameter type axi_user_t = logic [UserWidth-1  :0]
) (
    input logic clk_i,
    input logic rst_ni,

    output [$clog2(WBufferDepth):0] num_w_stored_o,
    output [$clog2(NumOutstanding):0] num_aw_stored_o,

    // AXI manager port (with array to keep _i/_o suffixes)
    output [0:0][  IdWidth-1 : 0] m_axi_rt_awid_o,
    output [0:0][  AddrWidth-1:0] m_axi_rt_awaddr_o,
    output [0:0][            7:0] m_axi_rt_awlen_o,
    output [0:0][            2:0] m_axi_rt_awsize_o,
    output [0:0][            1:0] m_axi_rt_awburst_o,
    output [0:0]                  m_axi_rt_awlock_o,
    output [0:0][            3:0] m_axi_rt_awcache_o,
    output [0:0][            2:0] m_axi_rt_awprot_o,
    output [0:0][            3:0] m_axi_rt_awqos_o,
    output [0:0][UserWidth-1 : 0] m_axi_rt_awuser_o,
    output [0:0]                  m_axi_rt_awvalid_o,
    input  [0:0]                  m_axi_rt_awready_i,
    output [0:0][  DataWidth-1:0] m_axi_rt_wdata_o,
    output [0:0][DataWidth/8-1:0] m_axi_rt_wstrb_o,
    output [0:0]                  m_axi_rt_wlast_o,
    output [0:0]                  m_axi_rt_wvalid_o,
    input  [0:0]                  m_axi_rt_wready_i,
    input  [0:0][  IdWidth-1 : 0] m_axi_rt_bid_i,
    input  [0:0][            1:0] m_axi_rt_bresp_i,
    input  [0:0]                  m_axi_rt_bvalid_i,
    output [0:0]                  m_axi_rt_bready_o,
    output [0:0][  IdWidth-1 : 0] m_axi_rt_arid_o,
    output [0:0][  AddrWidth-1:0] m_axi_rt_araddr_o,
    output [0:0][            7:0] m_axi_rt_arlen_o,
    output [0:0][            2:0] m_axi_rt_arsize_o,
    output [0:0][            1:0] m_axi_rt_arburst_o,
    output [0:0]                  m_axi_rt_arlock_o,
    output [0:0][            3:0] m_axi_rt_arcache_o,
    output [0:0][            2:0] m_axi_rt_arprot_o,
    output [0:0][            3:0] m_axi_rt_arqos_o,
    output [0:0][UserWidth-1 : 0] m_axi_rt_aruser_o,
    output [0:0]                  m_axi_rt_arvalid_o,
    input  [0:0]                  m_axi_rt_arready_i,
    input  [0:0][  IdWidth-1 : 0] m_axi_rt_rid_i,
    input  [0:0][  DataWidth-1:0] m_axi_rt_rdata_i,
    input  [0:0][            1:0] m_axi_rt_rresp_i,
    input  [0:0]                  m_axi_rt_rlast_i,
    input  [0:0]                  m_axi_rt_rvalid_i,
    output [0:0]                  m_axi_rt_rready_o,

    // AXI subordinate ports
    input  [0:0][  IdWidth-1 : 0] s_axi_rt_awid_i,
    input  [0:0][  AddrWidth-1:0] s_axi_rt_awaddr_i,
    input  [0:0][            7:0] s_axi_rt_awlen_i,
    input  [0:0][            2:0] s_axi_rt_awsize_i,
    input  [0:0][            1:0] s_axi_rt_awburst_i,
    input  [0:0]                  s_axi_rt_awlock_i,
    input  [0:0][            3:0] s_axi_rt_awcache_i,
    input  [0:0][            2:0] s_axi_rt_awprot_i,
    input  [0:0][            3:0] s_axi_rt_awqos_i,
    input  [0:0][UserWidth-1 : 0] s_axi_rt_awuser_i,
    input  [0:0]                  s_axi_rt_awvalid_i,
    output [0:0]                  s_axi_rt_awready_o,
    input  [0:0][  DataWidth-1:0] s_axi_rt_wdata_i,
    input  [0:0][DataWidth/8-1:0] s_axi_rt_wstrb_i,
    input  [0:0]                  s_axi_rt_wlast_i,
    input  [0:0]                  s_axi_rt_wvalid_i,
    output [0:0]                  s_axi_rt_wready_o,
    output [0:0][  IdWidth-1 : 0] s_axi_rt_bid_o,
    output [0:0][            1:0] s_axi_rt_bresp_o,
    output [0:0]                  s_axi_rt_bvalid_o,
    input  [0:0]                  s_axi_rt_bready_i,
    input  [0:0][  IdWidth-1 : 0] s_axi_rt_arid_i,
    input  [0:0][  AddrWidth-1:0] s_axi_rt_araddr_i,
    input  [0:0][            7:0] s_axi_rt_arlen_i,
    input  [0:0][            2:0] s_axi_rt_arsize_i,
    input  [0:0][            1:0] s_axi_rt_arburst_i,
    input  [0:0]                  s_axi_rt_arlock_i,
    input  [0:0][            3:0] s_axi_rt_arcache_i,
    input  [0:0][            2:0] s_axi_rt_arprot_i,
    input  [0:0][            3:0] s_axi_rt_arqos_i,
    input  [0:0][UserWidth-1 : 0] s_axi_rt_aruser_i,
    input  [0:0]                  s_axi_rt_arvalid_i,
    output [0:0]                  s_axi_rt_arready_o,
    output [0:0][  IdWidth-1 : 0] s_axi_rt_rid_o,
    output [0:0][  DataWidth-1:0] s_axi_rt_rdata_o,
    output [0:0][            1:0] s_axi_rt_rresp_o,
    output [0:0]                  s_axi_rt_rlast_o,
    output [0:0]                  s_axi_rt_rvalid_o,
    input  [0:0]                  s_axi_rt_rready_i
);

    // Define unused AXI signals for FPGA wrapper
    axi_pkg::region_t
        m_axi_rt_awregion_o, s_axi_rt_awregion_i, m_axi_rt_arregion_o, s_axi_rt_arregion_i;
    axi_user_t
        m_axi_rt_wuser_o,
        m_axi_rt_buser_i,
        m_axi_rt_ruser_i,
        s_axi_rt_wuser_i,
        s_axi_rt_buser_o,
        s_axi_rt_ruser_o;

    // Tie unused inputs to 0, leave output floating
    assign s_axi_rt_awregion_i = '0;
    assign s_axi_rt_arregion_i = '0;
    assign m_axi_rt_buser_i = '0;
    assign m_axi_rt_ruser_i = '0;
    assign s_axi_rt_wuser_i = '0;

    // Define AXI struct channels types
    `AXI_TYPEDEF_ALL(axi, axi_addr_t, axi_id_t, axi_data_t, axi_strb_t, axi_user_t)

    axi_req_t [0:0] m_req, s_req;
    axi_resp_t [0:0] m_rsp, s_rsp;

    // Connect AXI structs to flatten in/out AXI ports
    `AXI_ASSIGN_MASTER_TO_FLAT_ARRAY(rt, 1, m_req, m_rsp)
    `AXI_ASSIGN_SLAVE_TO_FLAT_ARRAY(rt, 1, s_req, s_rsp)

    //-----------------------------------
    // DUT
    //-----------------------------------
    axi_write_buffer #(
        .NumOutstanding(NumOutstanding),
        .WBufferDepth  (WBufferDepth),
        .aw_chan_t     (axi_aw_chan_t),
        .w_chan_t      (axi_w_chan_t),
        .axi_req_t     (axi_req_t),
        .axi_resp_t    (axi_resp_t)
    ) i_axi_write_buffer (
        .clk_i,
        .rst_ni,
        .num_aw_stored_o(num_aw_stored_o),
        .num_w_stored_o(num_w_stored_o),
        .slv_req_i(s_req[0]),
        .slv_resp_o(s_rsp[0]),
        .mst_req_o(m_req[0]),
        .mst_resp_i(m_rsp[0])
    );

endmodule
