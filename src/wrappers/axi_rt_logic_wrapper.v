// Vivado block design wrapper
module axi_rt_logic_wrapper #(
    parameter integer PeriodWidth = 32'd16,
    parameter integer BudgetWidth = 32'd16
) (
    input clk,
    input resetn,

    output r_budget_spent,
    output w_budget_spent,

    // IMTU (bookkeeping)
    input  imtu_enable,
    input  imtu_abort,
    input  [BudgetWidth-1:0] w_budget,
    output [BudgetWidth-1:0] w_budget_left,
    input  [PeriodWidth-1:0] w_period,
    output [PeriodWidth-1:0] w_period_left,
    input  [BudgetWidth-1:0] r_budget,
    output [BudgetWidth-1:0] r_budget_left,
    input  [PeriodWidth-1:0] r_period,
    output [PeriodWidth-1:0] r_period_left,

    // AW
    input axi_aw_valid,
    input axi_aw_ready,
    input [7:0] axi_aw_len,
    input [2:0] axi_aw_size,

    // AR
    input axi_ar_valid,
    input axi_ar_ready,
    input [7:0] axi_ar_len,
    input [2:0] axi_ar_size
);
    // AXI RT unit, xilinx wrapper
    axi_rt_logic #(
        .PeriodWidth(PeriodWidth),
        .BudgetWidth(BudgetWidth)
    ) i_axi_rt_logic (
        .clk_i (clk),
        .rst_ni(resetn),

        .r_budget_spent(r_budget_spent),
        .w_budget_spent(w_budget_spent),
        .imtu_enable_i(imtu_enable),
        .imtu_abort_i(imtu_abort),
        .w_budget_i(w_budget),
        .w_budget_left_o(w_budget_left),
        .w_period_i(w_period),
        .w_period_left_o(w_period_left),
        .r_budget_i(r_budget),
        .r_budget_left_o(r_budget_left),
        .r_period_i(r_period),
        .r_period_left_o(r_period_left),

        .axi_aw_valid(axi_aw_valid),
        .axi_aw_ready(axi_aw_ready),
        .axi_aw_len  (axi_aw_len),
        .axi_aw_size (axi_aw_size),
        .axi_ar_valid(axi_ar_valid),
        .axi_ar_ready(axi_ar_ready),
        .axi_ar_len  (axi_ar_len),
        .axi_ar_size (axi_ar_size)
    );
endmodule
