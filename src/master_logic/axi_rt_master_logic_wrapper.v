module axi_rt_master_logic_wrapper #(
    parameter integer BudgetWidth = 'd16
) (
    input clock,
    input resetn,

    input [BudgetWidth-1:0] downstream_p,
    input [BudgetWidth-1:0] downstream_q,

    // Configuration
    input enable_0,
    input [BudgetWidth-1:0] budget_w_0,
    input [BudgetWidth-1:0] budget_r_0,
    input enable_1,
    input [BudgetWidth-1:0] budget_w_1,
    input [BudgetWidth-1:0] budget_r_1,
    input enable_2,
    input [BudgetWidth-1:0] budget_w_2,
    input [BudgetWidth-1:0] budget_r_2,

    // Device Controls
    output device_incr_w_0,
    output device_incr_r_0,
    output device_incr_w_1,
    output device_incr_r_1,
    output device_incr_w_2,
    output device_incr_r_2,

    // Device Statuses
    input device_budget_used_w_0,
    input device_budget_used_r_0,
    input device_budget_used_w_1,
    input device_budget_used_r_1,
    input device_budget_used_w_2,
    input device_budget_used_r_2
);
    axi_rt_master_logic #(
        .NumDevice  ('d3),
        .BudgetWidth(BudgetWidth)
    ) i_axi_rt_master_logic (
        .clk_i (clock),
        .rst_ni(resetn),

        .downstream_p(downstream_p),
        .downstream_q(downstream_q),

        .enable  ({enable_2, enable_1, enable_0}),
        .budget_w({budget_w_2, budget_w_1, budget_w_0}),
        .budget_r({budget_r_2, budget_r_1, budget_r_0}),

        .device_incr_w({device_incr_w_2, device_incr_w_1, device_incr_w_0}),
        .device_incr_r({device_incr_r_2, device_incr_r_1, device_incr_r_0}),

        .device_budget_used_w({
            device_budget_used_w_2, device_budget_used_w_1, device_budget_used_w_0
        }),
        .device_budget_used_r({
            device_budget_used_r_2, device_budget_used_r_1, device_budget_used_r_0
        })
    );
endmodule
