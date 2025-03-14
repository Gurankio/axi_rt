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

    // Device Statuses
    input logic [NumDevice-1:0] device_budget_used_w,
    input logic [NumDevice-1:0] device_budget_used_r,

    // Device Controls
    output logic [NumDevice-1:0] device_incr_w,
    output logic [NumDevice-1:0] device_incr_r
);
    localparam int unsigned NumDeviceWidth = ($clog2(NumDevice) > 0 ? $clog2(NumDevice) : 1);
    localparam int unsigned PeriodWidth = BudgetWidth + NumDeviceWidth;
    typedef logic [PeriodWidth-1:0] period_t;

    /// Period computation
    logic [NumDevice-1:0] prev_enable_d, prev_enable_q;
    assign prev_enable_d = enable;
    `FFARN(prev_enable_q, prev_enable_d, '0, clk_i, rst_ni);
    logic enable_changed;
    assign enable_changed = |(prev_enable_q ^ enable);

    logic [NumDevice-1:0] to_compute_d, to_compute_q;
    `FFARN(to_compute_q, to_compute_d, '0, clk_i, rst_ni);

    logic [$clog2(NumDevice + 1)-1:0] progress_d, progress_q;
    `FFARN(progress_q, progress_d, '0, clk_i, rst_ni);

    period_t [2**NumDevice-1:0] next_periods_w_d, next_periods_w_q;
    `FFARN(next_periods_w_q, next_periods_w_d, '0, clk_i, rst_ni);
    period_t [2**NumDevice-1:0] next_periods_r_d, next_periods_r_q;
    `FFARN(next_periods_r_q, next_periods_r_d, '0, clk_i, rst_ni);

    always_comb begin
        to_compute_d = to_compute_q;
        progress_d   = progress_q;

        // If some enabled changed or the reset signal is present then start the computation.
        if (!rst_ni || to_compute_q == 0 && enable_changed) begin
            to_compute_d     = 'd1;
            progress_d       = '0;
            next_periods_w_d = '0;
            next_periods_r_d = '0;
        end

        // As long as there is work to do (compute resets by overflowing).
        if (rst_ni && to_compute_q != 0) begin
            progress_d = progress_q + 1;

            if (progress_q != NumDevice) begin
                // Accumualate budgets.
                next_periods_w_d[to_compute_q] =
                    next_periods_w_q[to_compute_q] + budget_w[progress_q] * to_compute_q[progress_q];
                next_periods_r_d[to_compute_q] =
                    next_periods_r_q[to_compute_q] + budget_r[progress_q] * to_compute_q[progress_q];
            end else begin
                // Scale by the factor and subtract one.
                next_periods_w_d[to_compute_q] =
                    next_periods_w_q[to_compute_q] * downstream_p / downstream_q - 1;
                next_periods_r_d[to_compute_q] =
                    next_periods_r_q[to_compute_q] * downstream_p / downstream_q - 1;

                // Advance to the next case.
                to_compute_d = to_compute_q + 1;
                progress_d = '0;
            end
        end
    end

    /// Next period output
    period_t next_period_w, next_period_r;
    assign next_period_w = next_periods_w_q[device_budget_used_w];
    assign next_period_r = next_periods_r_q[device_budget_used_r];

    /// Period counters
    logic period_over_w, period_over_r;
    // assign period_over_w = !any_enabled_q && any_enabled_d || period_left_w == 0;
    assign period_over_w = period_left_w == 0;
    // assign period_over_r = !any_enabled_q && any_enabled_d || period_left_r == 0;
    assign period_over_r = period_left_r == 0;

    period_t period_left_w;
    always_ff @(posedge (clk_i) or negedge (rst_ni)) begin
        if (!rst_ni) begin
            period_left_w <= 'd0;
        end else begin
            if (period_over_w) begin
                period_left_w <= next_period_w;
            end else begin
                period_left_w <= period_left_w == '0 ? '0 : period_left_w - 1;
            end
        end
    end

    period_t period_left_r;
    always_ff @(posedge (clk_i) or negedge (rst_ni)) begin
        if (!rst_ni) begin
            period_left_r <= 'd0;
        end else begin
            if (period_over_r) begin
                period_left_r <= next_period_r;
            end else begin
                period_left_r <= period_left_r == '0 ? '0 : period_left_r - 1;
            end
        end
    end

    /// Increment
    // OPT: combinatorial path is fast enough and removes a cycle?
    // logic [NumDevice-1:0] device_incr_w_d, device_incr_r_d;
    // `FFARN(device_incr_w, device_incr_w_d, '0, clk_i, rst_ni);
    // `FFARN(device_incr_r, device_incr_r_d, '0, clk_i, rst_ni);

    for (genvar i = 0; i < NumDevice; i++) begin : gen_device_incr
        assign device_incr_w[i] = device_budget_used_w[i] && period_over_w;
        assign device_incr_r[i] = device_budget_used_r[i] && period_over_r;
    end
endmodule
