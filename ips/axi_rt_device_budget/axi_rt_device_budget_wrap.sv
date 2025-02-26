module axi_rt_device_budget_wrap #(
    parameter integer BudgetWidth = 'd16,
    parameter integer NumPorts = 'd1,
    parameter integer AxiAddrWidth = 'd48,
    parameter integer AxiDataWidth = 'd64,
    parameter integer AxiIdWidth = 'd16
) (
    // TODO: constrains on clock: compare with AXI clock
    input clock,
    input aresetn,

    // Controls
    input enable,
    input incr_r,
    input incr_w,
    input [BudgetWidth-1:0] budget_w,
    input [BudgetWidth-1:0] budget_r,

    // State
    output budget_used_w,
    output budget_used_r,

    // Isolation
    output budget_spent_w,
    output budget_spent_r,

    // Ports (4 max)
    input [    AxiIdWidth-1:0] axi_0_awid,
    input [  AxiAddrWidth-1:0] axi_0_awaddr,
    input [               2:0] axi_0_awprot,
    input [               7:0] axi_0_awlen,
    input [               2:0] axi_0_awsize,
    input [               1:0] axi_0_awburst,
    input [               3:0] axi_0_awcache,
    input                      axi_0_awlock,
    input                      axi_0_awvalid,
    input                      axi_0_awready,
    input [  AxiDataWidth-1:0] axi_0_wdata,
    input [AxiDataWidth/8-1:0] axi_0_wstrb,
    input                      axi_0_wlast,
    input                      axi_0_wvalid,
    input                      axi_0_wready,
    input [    AxiIdWidth-1:0] axi_0_bid,
    input [               1:0] axi_0_bresp,
    input                      axi_0_bvalid,
    input                      axi_0_bready,
    input [    AxiIdWidth-1:0] axi_0_arid,
    input [  AxiAddrWidth-1:0] axi_0_araddr,
    input [               7:0] axi_0_arlen,
    input [               2:0] axi_0_arsize,
    input [               1:0] axi_0_arburst,
    input [               3:0] axi_0_arcache,
    input [               2:0] axi_0_arprot,
    input                      axi_0_arlock,
    input                      axi_0_arvalid,
    input                      axi_0_arready,
    input [    AxiIdWidth-1:0] axi_0_rid,
    input [  AxiDataWidth-1:0] axi_0_rdata,
    input [               1:0] axi_0_rresp,
    input                      axi_0_rlast,
    input                      axi_0_rvalid,
    input                      axi_0_rready,

    input [    AxiIdWidth-1:0] axi_1_awid,
    input [  AxiAddrWidth-1:0] axi_1_awaddr,
    input [               2:0] axi_1_awprot,
    input [               7:0] axi_1_awlen,
    input [               2:0] axi_1_awsize,
    input [               1:0] axi_1_awburst,
    input [               3:0] axi_1_awcache,
    input                      axi_1_awlock,
    input                      axi_1_awvalid,
    input                      axi_1_awready,
    input [  AxiDataWidth-1:0] axi_1_wdata,
    input [AxiDataWidth/8-1:0] axi_1_wstrb,
    input                      axi_1_wlast,
    input                      axi_1_wvalid,
    input                      axi_1_wready,
    input [    AxiIdWidth-1:0] axi_1_bid,
    input [               1:0] axi_1_bresp,
    input                      axi_1_bvalid,
    input                      axi_1_bready,
    input [    AxiIdWidth-1:0] axi_1_arid,
    input [  AxiAddrWidth-1:0] axi_1_araddr,
    input [               7:0] axi_1_arlen,
    input [               2:0] axi_1_arsize,
    input [               1:0] axi_1_arburst,
    input [               3:0] axi_1_arcache,
    input [               2:0] axi_1_arprot,
    input                      axi_1_arlock,
    input                      axi_1_arvalid,
    input                      axi_1_arready,
    input [    AxiIdWidth-1:0] axi_1_rid,
    input [  AxiDataWidth-1:0] axi_1_rdata,
    input [               1:0] axi_1_rresp,
    input                      axi_1_rlast,
    input                      axi_1_rvalid,
    input                      axi_1_rready,

    input [    AxiIdWidth-1:0] axi_2_awid,
    input [  AxiAddrWidth-1:0] axi_2_awaddr,
    input [               2:0] axi_2_awprot,
    input [               7:0] axi_2_awlen,
    input [               2:0] axi_2_awsize,
    input [               1:0] axi_2_awburst,
    input [               3:0] axi_2_awcache,
    input                      axi_2_awlock,
    input                      axi_2_awvalid,
    input                      axi_2_awready,
    input [  AxiDataWidth-1:0] axi_2_wdata,
    input [AxiDataWidth/8-1:0] axi_2_wstrb,
    input                      axi_2_wlast,
    input                      axi_2_wvalid,
    input                      axi_2_wready,
    input [    AxiIdWidth-1:0] axi_2_bid,
    input [               1:0] axi_2_bresp,
    input                      axi_2_bvalid,
    input                      axi_2_bready,
    input [    AxiIdWidth-1:0] axi_2_arid,
    input [  AxiAddrWidth-1:0] axi_2_araddr,
    input [               7:0] axi_2_arlen,
    input [               2:0] axi_2_arsize,
    input [               1:0] axi_2_arburst,
    input [               3:0] axi_2_arcache,
    input [               2:0] axi_2_arprot,
    input                      axi_2_arlock,
    input                      axi_2_arvalid,
    input                      axi_2_arready,
    input [    AxiIdWidth-1:0] axi_2_rid,
    input [  AxiDataWidth-1:0] axi_2_rdata,
    input [               1:0] axi_2_rresp,
    input                      axi_2_rlast,
    input                      axi_2_rvalid,
    input                      axi_2_rready,

    input [    AxiIdWidth-1:0] axi_3_awid,
    input [  AxiAddrWidth-1:0] axi_3_awaddr,
    input [               2:0] axi_3_awprot,
    input [               7:0] axi_3_awlen,
    input [               2:0] axi_3_awsize,
    input [               1:0] axi_3_awburst,
    input [               3:0] axi_3_awcache,
    input                      axi_3_awlock,
    input                      axi_3_awvalid,
    input                      axi_3_awready,
    input [  AxiDataWidth-1:0] axi_3_wdata,
    input [AxiDataWidth/8-1:0] axi_3_wstrb,
    input                      axi_3_wlast,
    input                      axi_3_wvalid,
    input                      axi_3_wready,
    input [    AxiIdWidth-1:0] axi_3_bid,
    input [               1:0] axi_3_bresp,
    input                      axi_3_bvalid,
    input                      axi_3_bready,
    input [    AxiIdWidth-1:0] axi_3_arid,
    input [  AxiAddrWidth-1:0] axi_3_araddr,
    input [               7:0] axi_3_arlen,
    input [               2:0] axi_3_arsize,
    input [               1:0] axi_3_arburst,
    input [               3:0] axi_3_arcache,
    input [               2:0] axi_3_arprot,
    input                      axi_3_arlock,
    input                      axi_3_arvalid,
    input                      axi_3_arready,
    input [    AxiIdWidth-1:0] axi_3_rid,
    input [  AxiDataWidth-1:0] axi_3_rdata,
    input [               1:0] axi_3_rresp,
    input                      axi_3_rlast,
    input                      axi_3_rvalid,
    input                      axi_3_rready
);
    wire [4-1:0][    AxiIdWidth-1:0] axi_awid;
    wire [4-1:0][  AxiAddrWidth-1:0] axi_awaddr;
    wire [4-1:0][               2:0] axi_awprot;
    wire [4-1:0][               7:0] axi_awlen;
    wire [4-1:0][               2:0] axi_awsize;
    wire [4-1:0][               1:0] axi_awburst;
    wire [4-1:0][               3:0] axi_awcache;
    wire [4-1:0]                     axi_awlock;
    wire [4-1:0]                     axi_awvalid;
    wire [4-1:0]                     axi_awready;
    wire [4-1:0][  AxiDataWidth-1:0] axi_wdata;
    wire [4-1:0][AxiDataWidth/8-1:0] axi_wstrb;
    wire [4-1:0]                     axi_wlast;
    wire [4-1:0]                     axi_wvalid;
    wire [4-1:0]                     axi_wready;
    wire [4-1:0][    AxiIdWidth-1:0] axi_bid;
    wire [4-1:0][               1:0] axi_bresp;
    wire [4-1:0]                     axi_bvalid;
    wire [4-1:0]                     axi_bready;
    wire [4-1:0][    AxiIdWidth-1:0] axi_arid;
    wire [4-1:0][  AxiAddrWidth-1:0] axi_araddr;
    wire [4-1:0][               7:0] axi_arlen;
    wire [4-1:0][               2:0] axi_arsize;
    wire [4-1:0][               1:0] axi_arburst;
    wire [4-1:0][               3:0] axi_arcache;
    wire [4-1:0][               2:0] axi_arprot;
    wire [4-1:0]                     axi_arlock;
    wire [4-1:0]                     axi_arvalid;
    wire [4-1:0]                     axi_arready;
    wire [4-1:0][    AxiIdWidth-1:0] axi_rid;
    wire [4-1:0][  AxiDataWidth-1:0] axi_rdata;
    wire [4-1:0][               1:0] axi_rresp;
    wire [4-1:0]                     axi_rlast;
    wire [4-1:0]                     axi_rvalid;
    wire [4-1:0]                     axi_rready;

    assign axi_awid = {axi_3_awid, axi_2_awid, axi_1_awid, axi_0_awid};
    assign axi_awaddr = {axi_3_awaddr, axi_2_awaddr, axi_1_awaddr, axi_0_awaddr};
    assign axi_awprot = {axi_3_awprot, axi_2_awprot, axi_1_awprot, axi_0_awprot};
    assign axi_awlen = {axi_3_awlen, axi_2_awlen, axi_1_awlen, axi_0_awlen};
    assign axi_awsize = {axi_3_awsize, axi_2_awsize, axi_1_awsize, axi_0_awsize};
    assign axi_awburst = {axi_3_awburst, axi_2_awburst, axi_1_awburst, axi_0_awburst};
    assign axi_awcache = {axi_3_awcache, axi_2_awcache, axi_1_awcache, axi_0_awcache};
    assign axi_awlock = {axi_3_awlock, axi_2_awlock, axi_1_awlock, axi_0_awlock};
    assign axi_awvalid = {axi_3_awvalid, axi_2_awvalid, axi_1_awvalid, axi_0_awvalid};
    assign axi_awready = {axi_3_awready, axi_2_awready, axi_1_awready, axi_0_awready};
    assign axi_wdata = {axi_3_wdata, axi_2_wdata, axi_1_wdata, axi_0_wdata};
    assign axi_wstrb = {axi_3_wstrb, axi_2_wstrb, axi_1_wstrb, axi_0_wstrb};
    assign axi_wlast = {axi_3_wlast, axi_2_wlast, axi_1_wlast, axi_0_wlast};
    assign axi_wvalid = {axi_3_wvalid, axi_2_wvalid, axi_1_wvalid, axi_0_wvalid};
    assign axi_wready = {axi_3_wready, axi_2_wready, axi_1_wready, axi_0_wready};
    assign axi_bid = {axi_3_bid, axi_2_bid, axi_1_bid, axi_0_bid};
    assign axi_bresp = {axi_3_bresp, axi_2_bresp, axi_1_bresp, axi_0_bresp};
    assign axi_bvalid = {axi_3_bvalid, axi_2_bvalid, axi_1_bvalid, axi_0_bvalid};
    assign axi_bready = {axi_3_bready, axi_2_bready, axi_1_bready, axi_0_bready};
    assign axi_arid = {axi_3_arid, axi_2_arid, axi_1_arid, axi_0_arid};
    assign axi_araddr = {axi_3_araddr, axi_2_araddr, axi_1_araddr, axi_0_araddr};
    assign axi_arlen = {axi_3_arlen, axi_2_arlen, axi_1_arlen, axi_0_arlen};
    assign axi_arsize = {axi_3_arsize, axi_2_arsize, axi_1_arsize, axi_0_arsize};
    assign axi_arburst = {axi_3_arburst, axi_2_arburst, axi_1_arburst, axi_0_arburst};
    assign axi_arcache = {axi_3_arcache, axi_2_arcache, axi_1_arcache, axi_0_arcache};
    assign axi_arprot = {axi_3_arprot, axi_2_arprot, axi_1_arprot, axi_0_arprot};
    assign axi_arlock = {axi_3_arlock, axi_2_arlock, axi_1_arlock, axi_0_arlock};
    assign axi_arvalid = {axi_3_arvalid, axi_2_arvalid, axi_1_arvalid, axi_0_arvalid};
    assign axi_arready = {axi_3_arready, axi_2_arready, axi_1_arready, axi_0_arready};
    assign axi_rid = {axi_3_rid, axi_2_rid, axi_1_rid, axi_0_rid};
    assign axi_rdata = {axi_3_rdata, axi_2_rdata, axi_1_rdata, axi_0_rdata};
    assign axi_rresp = {axi_3_rresp, axi_2_rresp, axi_1_rresp, axi_0_rresp};
    assign axi_rlast = {axi_3_rlast, axi_2_rlast, axi_1_rlast, axi_0_rlast};
    assign axi_rvalid = {axi_3_rvalid, axi_2_rvalid, axi_1_rvalid, axi_0_rvalid};
    assign axi_rready = {axi_3_rready, axi_2_rready, axi_1_rready, axi_0_rready};

    axi_rt_device_budget #(
        .NumPorts(NumPorts),
        .BudgetWidth(BudgetWidth)
    ) i_axi_rt_device_budget (
        .clk_i (clock),
        .rst_ni(aresetn),

        .enable(enable),
        .incr_w(incr_w),
        .incr_r(incr_r),
        .budget_w(budget_w),
        .budget_r(budget_r),
        .budget_used_w(budget_used_w),
        .budget_used_r(budget_used_r),
        .budget_spent_w(budget_spent_w),
        .budget_spent_r(budget_spent_r),

        .axi_awid(axi_awid[NumPorts-1:0]),
        .axi_awaddr(axi_awaddr[NumPorts-1:0]),
        .axi_awprot(axi_awprot[NumPorts-1:0]),
        .axi_awlen(axi_awlen[NumPorts-1:0]),
        .axi_awsize(axi_awsize[NumPorts-1:0]),
        .axi_awburst(axi_awburst[NumPorts-1:0]),
        .axi_awcache(axi_awcache[NumPorts-1:0]),
        .axi_awlock(axi_awlock[NumPorts-1:0]),
        .axi_awvalid(axi_awvalid[NumPorts-1:0]),
        .axi_awready(axi_awready[NumPorts-1:0]),
        .axi_wdata(axi_wdata[NumPorts-1:0]),
        .axi_wstrb(axi_wstrb[NumPorts-1:0]),
        .axi_wlast(axi_wlast[NumPorts-1:0]),
        .axi_wvalid(axi_wvalid[NumPorts-1:0]),
        .axi_wready(axi_wready[NumPorts-1:0]),
        .axi_bid(axi_bid[NumPorts-1:0]),
        .axi_bresp(axi_bresp[NumPorts-1:0]),
        .axi_bvalid(axi_bvalid[NumPorts-1:0]),
        .axi_bready(axi_bready[NumPorts-1:0]),
        .axi_arid(axi_arid[NumPorts-1:0]),
        .axi_araddr(axi_araddr[NumPorts-1:0]),
        .axi_arlen(axi_arlen[NumPorts-1:0]),
        .axi_arsize(axi_arsize[NumPorts-1:0]),
        .axi_arburst(axi_arburst[NumPorts-1:0]),
        .axi_arcache(axi_arcache[NumPorts-1:0]),
        .axi_arprot(axi_arprot[NumPorts-1:0]),
        .axi_arlock(axi_arlock[NumPorts-1:0]),
        .axi_arvalid(axi_arvalid[NumPorts-1:0]),
        .axi_arready(axi_arready[NumPorts-1:0]),
        .axi_rid(axi_rid[NumPorts-1:0]),
        .axi_rdata(axi_rdata[NumPorts-1:0]),
        .axi_rresp(axi_rresp[NumPorts-1:0]),
        .axi_rlast(axi_rlast[NumPorts-1:0]),
        .axi_rvalid(axi_rvalid[NumPorts-1:0]),
        .axi_rready(axi_rready[NumPorts-1:0])
    );
endmodule
