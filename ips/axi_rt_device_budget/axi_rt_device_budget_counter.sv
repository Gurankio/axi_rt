module axi_rt_device_budget_counter #(
    parameter int unsigned BudgetWidth = 32'd16,

    // Dependant
    parameter type budget_t = logic [BudgetWidth-1:0]
) (
    input logic clk_i,
    input logic rst_ni,

    // Events
    input budget_t ax_lengths,
    input logic    ax_happening,

    // Controls
    input logic    enable,
    input logic    incr,
    input budget_t budget,

    // Stats
    output logic budget_used,
    output logic budget_spent
);
    typedef logic signed [BudgetWidth:0] budget_signed_t;
    budget_signed_t available_d, available_q;
    logic budget_used_d, budget_used_q;
    logic budget_spent_d, budget_spent_q;

    always_ff @(posedge (clk_i) or negedge (rst_ni)) begin
        if (!rst_ni) begin
            available_q <= '0;
            budget_used_q <= '0;
            budget_spent_q <= '0;
        end else begin
            available_q <= available_d;
            budget_used_q <= budget_used_d;
            budget_spent_q <= budget_spent_d;
        end
    end

    assign budget_used  = budget_used_q;
    assign budget_spent = budget_spent_q;

    budget_signed_t signed_budget;
    assign signed_budget = {'0, budget};

    always_comb begin
        available_d = available_q;

        if (enable) begin
            // transactions
            if (!budget_spent & ax_happening) begin
                available_d -= ax_lengths;
            end

            // incr
            if (incr) begin
                available_d += signed_budget;

                if (available_d > signed_budget) begin
                    available_d = signed_budget;
                end
            end
        end

        // TODO: hopefully this is fast enough.
        budget_used_d  = available_d < signed_budget;
        budget_spent_d = available_d <= 0;
    end
endmodule
