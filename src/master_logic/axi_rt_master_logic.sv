`include "common_cells/registers.svh"

/// Real-time unit: fragments and throttles transactions
module axi_rt_master_logic #(
    parameter int unsigned NumDevice   = 'd1,
    parameter int unsigned BudgetWidth = 'd16,

    // Dependent
    parameter type budget_t = logic [BudgetWidth-1:0]
) (
    input logic clk_i,
    input logic rst_ni,

    // Represents the available bandwidth in AXI ports (p / q)
    input budget_t downstream_p,
    input budget_t downstream_q,

    // Configuration (shared with device modules)
    input logic [NumDevice-1:0] enable,
    input budget_t [NumDevice-1:0] budget_w,
    input budget_t [NumDevice-1:0] budget_r,

    // Device Controls
    output logic [NumDevice-1:0] device_incr_w,
    output logic [NumDevice-1:0] device_incr_r,

    // Device Statuses
    input logic [NumDevice-1:0] device_budget_used_w,
    input logic [NumDevice-1:0] device_budget_used_r
);
    localparam int unsigned NumDeviceWidth = ($clog2(NumDevice) > 0 ? $clog2(NumDevice) : 1);
    localparam int unsigned PeriodWidth = BudgetWidth + NumDeviceWidth;
    typedef logic [PeriodWidth-1:0] period_t;

    /// Enable
    logic [NumDevice-1:0] status_d, status_q;
    assign status_d = enable;
    `FFARN(status_q, status_d, '0, clk_i, rst_ni);

    logic any_enabled_d, any_enabled_q;
    assign any_enabled_d = |status_d;
    assign any_enabled_q = |status_q;

    /// Period computation
    localparam int unsigned DeviceReduction = NumDevice * 2 - (NumDevice == 1);
    period_t period_w_reduction[1:DeviceReduction];
    period_t period_r_reduction[1:DeviceReduction];
    for (genvar i = 0; i < NumDevice; i++) begin : gen_period_leafs
        assign period_w_reduction[NumDevice+i] = device_budget_used_w[i] ? budget_w[i] : '0;
        assign period_r_reduction[NumDevice+i] = device_budget_used_r[i] ? budget_r[i] : '0;
    end
    for (genvar i = 1; i < NumDevice; i++) begin : gen_period_nodes
        assign period_w_reduction[i] = period_w_reduction[i*2] + period_w_reduction[i*2+1];
        assign period_r_reduction[i] = period_r_reduction[i*2] + period_r_reduction[i*2+1];
    end

    period_t period_w, period_r;
    always_comb begin
        period_w = period_w_reduction[1] * downstream_p / downstream_q;
        period_w = period_w == 0 ? 1 : period_w;

        period_r = period_r_reduction[1] * downstream_p / downstream_q;
        period_r = period_r == 0 ? 1 : period_r;
    end

    /// Period counters
    logic period_over_w, period_over_r;
    // assign period_over_w = !any_enabled_q && any_enabled_d || period_left_w == 0;
    assign period_over_w = period_left_w == 0;
    // assign period_over_r = !any_enabled_q && any_enabled_d || period_left_r == 0;
    assign period_over_r = period_left_r == 0;

    period_t period_left_w;
    always_ff @(posedge (clk_i) or negedge (rst_ni)) begin
        if (!rst_ni) begin
            period_left_w <= 'd1;
        end else begin
            if (period_over_w) begin
                period_left_w <= period_w;
            end else begin
                period_left_w <= period_left_w == '0 ? '0 : period_left_w - 1;
            end
        end
    end

    period_t period_left_r;
    always_ff @(posedge (clk_i) or negedge (rst_ni)) begin
        if (!rst_ni) begin
            period_left_r <= 'd1;
        end else begin
            if (period_over_r) begin
                period_left_r <= period_r;
            end else begin
                period_left_r <= period_left_r == '0 ? '0 : period_left_r - 1;
            end
        end
    end

    /// Increment
    for (genvar i = 0; i < NumDevice; i++) begin : gen_device_incr
        assign device_incr_w[i] = device_budget_used_w[i] && period_over_w;
        assign device_incr_r[i] = device_budget_used_r[i] && period_over_r;
    end
endmodule
