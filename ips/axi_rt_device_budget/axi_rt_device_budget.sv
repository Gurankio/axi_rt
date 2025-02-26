`include "common_cells/registers.svh"

module axi_rt_device_budget #(
    parameter int unsigned BudgetWidth = 'd16,
    parameter int unsigned NumPorts = 'd1,
    parameter integer AxiAddrWidth = 'd48,
    parameter integer AxiDataWidth = 'd64,
    parameter integer AxiIdWidth = 'd16,

    // Dependent
    parameter type budget_t = logic [BudgetWidth-1:0]
) (
    // TODO: constrains on clock: same as AXI clock
    input logic clk_i,
    input logic rst_ni,

    // Controls
    input  logic    enable,
    input  logic    incr_w,
    input  logic    incr_r,
    input  budget_t budget_w,
    input  budget_t budget_r,

    // State
    output logic budget_used_w,
    output logic budget_used_r,

    // Isolation
    output logic budget_spent_w,
    output logic budget_spent_r,

    // Ports
    input [NumPorts-1:0][    AxiIdWidth-1:0] axi_awid,
    input [NumPorts-1:0][  AxiAddrWidth-1:0] axi_awaddr,
    input [NumPorts-1:0][               2:0] axi_awprot,
    input [NumPorts-1:0][               7:0] axi_awlen,
    input [NumPorts-1:0][               2:0] axi_awsize,
    input [NumPorts-1:0][               1:0] axi_awburst,
    input [NumPorts-1:0][               3:0] axi_awcache,
    input [NumPorts-1:0]                     axi_awlock,
    input [NumPorts-1:0]                     axi_awvalid,
    input [NumPorts-1:0]                     axi_awready,
    input [NumPorts-1:0][  AxiDataWidth-1:0] axi_wdata,
    input [NumPorts-1:0][AxiDataWidth/8-1:0] axi_wstrb,
    input [NumPorts-1:0]                     axi_wlast,
    input [NumPorts-1:0]                     axi_wvalid,
    input [NumPorts-1:0]                     axi_wready,
    input [NumPorts-1:0][    AxiIdWidth-1:0] axi_bid,
    input [NumPorts-1:0][               1:0] axi_bresp,
    input [NumPorts-1:0]                     axi_bvalid,
    input [NumPorts-1:0]                     axi_bready,
    input [NumPorts-1:0][    AxiIdWidth-1:0] axi_arid,
    input [NumPorts-1:0][  AxiAddrWidth-1:0] axi_araddr,
    input [NumPorts-1:0][               7:0] axi_arlen,
    input [NumPorts-1:0][               2:0] axi_arsize,
    input [NumPorts-1:0][               1:0] axi_arburst,
    input [NumPorts-1:0][               3:0] axi_arcache,
    input [NumPorts-1:0][               2:0] axi_arprot,
    input [NumPorts-1:0]                     axi_arlock,
    input [NumPorts-1:0]                     axi_arvalid,
    input [NumPorts-1:0]                     axi_arready,
    input [NumPorts-1:0][    AxiIdWidth-1:0] axi_rid,
    input [NumPorts-1:0][  AxiDataWidth-1:0] axi_rdata,
    input [NumPorts-1:0][               1:0] axi_rresp,
    input [NumPorts-1:0]                     axi_rlast,
    input [NumPorts-1:0]                     axi_rvalid,
    input [NumPorts-1:0]                     axi_rready
);
    // Whether a transaction in happening in ax
    logic [NumPorts-1:0] aw_happening;
    logic [NumPorts-1:0] ar_happening;

    // The total length that is currently happening
    budget_t [NumPorts*2-1:1] aw_lengths;
    budget_t [NumPorts*2-1:1] ar_lengths;

    /// Length Probes
    for (genvar i = 0; i < NumPorts; i++) begin : gen_happening
        assign aw_happening[i] = axi_awvalid[i] & axi_awready[i];
        assign ar_happening[i] = axi_arvalid[i] & axi_arready[i];
    end
    for (genvar i = 0; i < NumPorts; i++) begin : gen_lengths_leafs
        assign aw_lengths[NumPorts+i] = aw_happening[i] ? axi_awlen[i] : '0;
        assign ar_lengths[NumPorts+i] = ar_happening[i] ? axi_arlen[i] : '0;
    end
    for (genvar i = 1; i < NumPorts; i++) begin : gen_lengths_nodes
        assign aw_lengths[i] = aw_lengths[i*2] + aw_lengths[i*2+1];
        assign ar_lengths[i] = ar_lengths[i*2] + ar_lengths[i*2+1];
    end

    // TODO: Assuming reduction is possible on a BudgetWidth.
    budget_t aw_lengths_total, ar_lengths_total;
    assign aw_lengths_total = aw_lengths[1];
    assign ar_lengths_total = ar_lengths[1];

    /// Counters
    axi_rt_device_budget_counter #(
        .BudgetWidth(BudgetWidth)
    ) i_counter_w (
        .clk_i,
        .rst_ni,
        .ax_lengths  (aw_lengths_total),
        .ax_happening(|aw_happening),
        .enable      (enable),
        .incr        (incr_w),
        .budget      (budget_w),
        .budget_used (budget_used_w),
        .budget_spent(budget_spent_w)
    );

    axi_rt_device_budget_counter #(
        .BudgetWidth(BudgetWidth)
    ) i_counter_r (
        .clk_i,
        .rst_ni,
        .ax_lengths  (ar_lengths_total),
        .ax_happening(|ar_happening),
        .enable      (enable),
        .incr        (incr_r),
        .budget      (budget_r),
        .budget_used (budget_used_r),
        .budget_spent(budget_spent_r)
    );
endmodule
