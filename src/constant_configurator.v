module constant_configurator #(
    parameter BudgetWidth = 16,
    parameter ResetDelay  = 4,

    parameter LenLimit = 8,
    parameter DownstreamP = 1,
    parameter DownstreamQ = 0,

    parameter Enable0 = 0,
    parameter Enable1 = 0,
    parameter Enable2 = 0,

    parameter BudgetW0 = 0,
    parameter BudgetR0 = 0,
    parameter BudgetW1 = 0,
    parameter BudgetR1 = 0,
    parameter BudgetW2 = 0,
    parameter BudgetR2 = 0
) (
    input aresetn,
    input clock,

    output [7:0] len_limit,
    output [BudgetWidth-1:0] downstream_p,
    output [BudgetWidth-1:0] downstream_q,

    output enable_0,
    output enable_1,
    output enable_2,
    output [BudgetWidth-1:0] budget_w_0,
    output [BudgetWidth-1:0] budget_r_0,
    output [BudgetWidth-1:0] budget_w_1,
    output [BudgetWidth-1:0] budget_r_1,
    output [BudgetWidth-1:0] budget_w_2,
    output [BudgetWidth-1:0] budget_r_2
);
    assign len_limit = LenLimit - 1;
    assign downstream_p = DownstreamP;
    assign downstream_q = DownstreamQ;
    assign budget_w_0 = BudgetW0;
    assign budget_r_0 = BudgetR0;
    assign budget_w_1 = BudgetW1;
    assign budget_r_1 = BudgetR1;
    assign budget_w_2 = BudgetW2;
    assign budget_r_2 = BudgetR2;

    reg [$clog2(ResetDelay + 1)-1:0] counter_q;
    reg enable_0_q, enable_1_q, enable_2_q;
    assign enable_0 = enable_0_q;
    assign enable_1 = enable_1_q;
    assign enable_2 = enable_2_q;

    always @(posedge (clock) or negedge (aresetn)) begin
        if (~aresetn) begin
            counter_q <= 0;
            enable_0_q  <= 0;
            enable_1_q  <= 0;
            enable_2_q  <= 0;
        end else begin
            counter_q <= counter_q;
            enable_0_q  <= enable_0;
            enable_1_q  <= enable_1;
            enable_2_q  <= enable_2;

            if (counter_q != ResetDelay) begin
                counter_q <= counter_q + 1;
            end else begin
                enable_0_q <= Enable0;
                enable_1_q <= Enable1;
                enable_2_q <= Enable2;
            end
        end
    end
endmodule
