`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/17/2025 02:07:19 PM
// Design Name:
// Module Name: tbd_multidev_run
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tbd_multidev_run ();
    reg clock = 0;
    reg aresetn = 0;

    reg traffic_start = 0;
    reg traffic_stop = 0;

    reg enable = 0;
    reg [7:0] len_limit = 'd8;
    reg [15:0] budget_w_0 = 'd1;
    reg [15:0] budget_w_1 = 'd1;
    reg [15:0] budget_w_2 = 'd1;
    reg [15:0] budget_r_0 = 'd1;
    reg [15:0] budget_r_1 = 'd1;
    reg [15:0] budget_r_2 = 'd1;

    reg [15:0] downstream_p = 'd1;
    reg [15:0] downstream_q = 'd1;

    tbd_multidev_wrapper DUT (
        .clock  (clock),
        .aresetn(aresetn),

        .traffic_start(traffic_start),
        .traffic_stop (traffic_stop),

        .enable(enable),
        .len_limit(len_limit),
        .budget_w_0(budget_w_0),
        .budget_w_1(budget_w_1),
        .budget_w_2(budget_w_2),
        .budget_r_0(budget_r_0),
        .budget_r_1(budget_r_1),
        .budget_r_2(budget_r_2),

        .downstream_p(downstream_p),
        .downstream_q(downstream_q)
    );

    // Generate the clock : 100 MHz
    always begin
        #5ns clock = ~clock;
    end

    initial begin
        //Assert the reset
        aresetn = 0;
        #250ns;

        // Release the reset
        aresetn = 1;
        #50ns;

        enable <= 1;
        #25ns;

        traffic_start <= 1;
        #50us;

        traffic_start <= 0;
        #25ns;

        traffic_stop <= 1;
        #10us;

        traffic_stop <= 0;
        $finish();
    end

endmodule
