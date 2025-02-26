`include "axi/typedef.svh"
`include "axi/assign.svh"
`include "axi-rt/assign.svh"
`include "axi-rt/port.svh"

///  Vivado AXI flattned wrapper
module axi_isolate_flat #(
    /// Maximum number of pending requests per channel
    parameter int unsigned NumPending = 32'd16,
    /// Gracefully terminate all incoming transactions in case of isolation by returning proper error
    /// responses.
    parameter bit TerminateTransaction = 1'b0,
    /// Support atomic operations (ATOPs)
    parameter bit AtopSupport = 1'b1,
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

    input  logic isolate_i,
    output logic isolated_o,

    // AXI manager port (with array to keep _i/_o suffixes)
    output [  IdWidth-1 : 0] m_axi_rt_awid_o,
    output [  AddrWidth-1:0] m_axi_rt_awaddr_o,
    output [            7:0] m_axi_rt_awlen_o,
    output [            2:0] m_axi_rt_awsize_o,
    output [            1:0] m_axi_rt_awburst_o,
    output                   m_axi_rt_awlock_o,
    output [            3:0] m_axi_rt_awcache_o,
    output [            2:0] m_axi_rt_awprot_o,
    output [            3:0] m_axi_rt_awqos_o,
    output [UserWidth-1 : 0] m_axi_rt_awuser_o,
    output                   m_axi_rt_awvalid_o,
    input                    m_axi_rt_awready_i,
    output [  DataWidth-1:0] m_axi_rt_wdata_o,
    output [DataWidth/8-1:0] m_axi_rt_wstrb_o,
    output                   m_axi_rt_wlast_o,
    output                   m_axi_rt_wvalid_o,
    input                    m_axi_rt_wready_i,
    input  [  IdWidth-1 : 0] m_axi_rt_bid_i,
    input  [            1:0] m_axi_rt_bresp_i,
    input                    m_axi_rt_bvalid_i,
    output                   m_axi_rt_bready_o,
    output [  IdWidth-1 : 0] m_axi_rt_arid_o,
    output [  AddrWidth-1:0] m_axi_rt_araddr_o,
    output [            7:0] m_axi_rt_arlen_o,
    output [            2:0] m_axi_rt_arsize_o,
    output [            1:0] m_axi_rt_arburst_o,
    output                   m_axi_rt_arlock_o,
    output [            3:0] m_axi_rt_arcache_o,
    output [            2:0] m_axi_rt_arprot_o,
    output [            3:0] m_axi_rt_arqos_o,
    output [UserWidth-1 : 0] m_axi_rt_aruser_o,
    output                   m_axi_rt_arvalid_o,
    input                    m_axi_rt_arready_i,
    input  [  IdWidth-1 : 0] m_axi_rt_rid_i,
    input  [  DataWidth-1:0] m_axi_rt_rdata_i,
    input  [            1:0] m_axi_rt_rresp_i,
    input                    m_axi_rt_rlast_i,
    input                    m_axi_rt_rvalid_i,
    output                   m_axi_rt_rready_o,

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

    //localparam type reg_id_t       = logic    [RtRegIdWidth-1    :0];

    // Define AXI struct channels types
    `AXI_TYPEDEF_ALL(axi, axi_addr_t, axi_id_t, axi_data_t, axi_strb_t, axi_user_t)

    axi_req_t m_req;
    axi_req_t [0:0] s_req;
    axi_resp_t m_rsp;
    axi_resp_t [0:0] s_rsp;

    // Connect AXI structs to flatten in/out AXI ports
    assign m_axi_rt_awvalid_o  = m_req.aw_valid;
    assign m_axi_rt_awid_o     = m_req.aw.id;
    assign m_axi_rt_awaddr_o   = m_req.aw.addr;
    assign m_axi_rt_awlen_o    = m_req.aw.len;
    assign m_axi_rt_awsize_o   = m_req.aw.size;
    assign m_axi_rt_awburst_o  = m_req.aw.burst;
    assign m_axi_rt_awlock_o   = m_req.aw.lock;
    assign m_axi_rt_awcache_o  = m_req.aw.cache;
    assign m_axi_rt_awprot_o   = m_req.aw.prot;
    assign m_axi_rt_awqos_o    = m_req.aw.qos;
    assign m_axi_rt_awregion_o = m_req.aw.region;
    assign m_axi_rt_awuser_o   = m_req.aw.user;

    assign m_axi_rt_wvalid_o   = m_req.w_valid;
    assign m_axi_rt_wdata_o    = m_req.w.data;
    assign m_axi_rt_wstrb_o    = m_req.w.strb;
    assign m_axi_rt_wlast_o    = m_req.w.last;
    assign m_axi_rt_wuser_o    = m_req.w.user;

    assign m_axi_rt_bready_o   = m_req.b_ready;

    // TODO: Here something goes bad and Vivado's simulator loops indefinetely.
    assign m_axi_rt_arvalid_o  = m_req.ar_valid;
    assign m_axi_rt_arid_o     = m_req.ar.id;
    assign m_axi_rt_araddr_o   = m_req.ar.addr;
    assign m_axi_rt_arlen_o    = m_req.ar.len;
    assign m_axi_rt_arsize_o   = m_req.ar.size;
    assign m_axi_rt_arburst_o  = m_req.ar.burst;
    assign m_axi_rt_arlock_o   = m_req.ar.lock;
    assign m_axi_rt_arcache_o  = m_req.ar.cache;
    assign m_axi_rt_arprot_o   = m_req.ar.prot;
    assign m_axi_rt_arqos_o    = m_req.ar.qos;
    assign m_axi_rt_arregion_o = m_req.ar.region;
    assign m_axi_rt_aruser_o   = m_req.ar.user;

    assign m_axi_rt_rready_o   = m_req.r_ready;

    assign m_rsp.aw_ready      = m_axi_rt_awready_i;
    assign m_rsp.ar_ready      = m_axi_rt_arready_i;
    assign m_rsp.w_ready       = m_axi_rt_wready_i;

    assign m_rsp.b_valid       = m_axi_rt_bvalid_i;
    assign m_rsp.b.id          = m_axi_rt_bid_i;
    assign m_rsp.b.resp        = m_axi_rt_bresp_i;
    assign m_rsp.b.user        = m_axi_rt_buser_i;

    assign m_rsp.r_valid       = m_axi_rt_rvalid_i;
    assign m_rsp.r.id          = m_axi_rt_rid_i;
    assign m_rsp.r.data        = m_axi_rt_rdata_i;
    assign m_rsp.r.resp        = m_axi_rt_rresp_i;
    assign m_rsp.r.last        = m_axi_rt_rlast_i;
    assign m_rsp.r.user        = m_axi_rt_ruser_i;

    `AXI_ASSIGN_SLAVE_TO_FLAT_ARRAY(rt, 1, s_req, s_rsp)

    //-----------------------------------
    // DUT
    //-----------------------------------
    axi_isolate #(
        .NumPending          (NumPending),
        .TerminateTransaction(TerminateTransaction),
        .AtopSupport         (AtopSupport),
        .AxiAddrWidth        (AddrWidth),
        .AxiDataWidth        (DataWidth),
        .AxiIdWidth          (IdWidth),
        .AxiUserWidth        (UserWidth),
        .axi_req_t           (axi_req_t),
        .axi_resp_t          (axi_resp_t)
    ) i_axi_isolate (
        .clk_i,
        .rst_ni,
        .slv_req_i (s_req[0]),
        .slv_resp_o(s_rsp[0]),
        .mst_req_o (m_req),
        .mst_resp_i(m_rsp),
        .isolate_i (isolate_i),
        .isolated_o(isolated_o)
    );

endmodule
