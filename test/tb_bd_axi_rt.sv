`timescale 1ns / 1ps

// Import required packages: axi_vip_pkg and <component_name>_pkg.
import axi_vip_pkg::*;
import bd_axi_rt_axi_vip_1_0_pkg::*;
import bd_axi_rt_axi_vip_2_0_pkg::*;
import bd_axi_rt_axi_vip_3_0_pkg::*;
import bd_axi_rt_axi_vip_4_0_pkg::*;
import axi_rt_reg_pkg::*;

module tb_bd_axi_rt ();
    reg aclk = 0;
    reg aresetn = 0;

    reg [7:0] splitter_len_limit = 'd0;

    // Remember to multilpy by AXI_DATA_WIDTH
    reg [15:0] r_period = 'd22;
    reg [15:0] r_budget = 'd29;
    reg [15:0] w_period = 'd22;
    reg [15:0] w_budget = 'd29;

    reg imtu_enable = 0;
    reg imtu_abort = 0;

    reg traffic_start = 0;
    reg traffic_stop = 0;

    bd_axi_rt_wrapper DUT (
        .clk(aclk),
        .resetn(aresetn),

        .splitter_len_limit(splitter_len_limit),
        .r_budget(r_budget),
        .r_period(r_period),
        .w_budget(w_budget),
        .w_period(w_period),
        .imtu_enable(imtu_enable),
        .imtu_abort(imtu_abort),

        .traffic_start(traffic_start),
        .traffic_stop (traffic_stop)
    );

    // Generate the clock : 100 MHz
    always #5ns aclk = ~aclk;

    initial begin
        //Assert the reset
        aresetn = 0;
        #250ns;
        // Release the reset
        aresetn = 1;
        #50ns;
    end
    
    xil_axi_resp_t axi_bresp;

    // Declare the agent
    bd_axi_rt_axi_vip_1_0_passthrough_t ver1;
    bd_axi_rt_axi_vip_2_0_passthrough_t ver2;
    bd_axi_rt_axi_vip_3_0_passthrough_t ver3;
    bd_axi_rt_axi_vip_4_0_passthrough_t ver4;

    initial begin
        // Create an agent
        ver1 = new("pst vip agent 1", DUT.bd_axi_rt_i.axi_vip_1.inst.IF);
        ver2 = new("pst vip agent 2", DUT.bd_axi_rt_i.axi_vip_2.inst.IF);
        ver3 = new("pst vip agent 3", DUT.bd_axi_rt_i.axi_vip_3.inst.IF);
        ver4 = new("pst vip agent 4", DUT.bd_axi_rt_i.axi_vip_4.inst.IF);

        // Set print out verbosity level
        ver1.set_verbosity(200);
        ver2.set_verbosity(200);
        ver3.set_verbosity(200);
        ver4.set_verbosity(200);

        // Actually do tests.

        #325ns;
        imtu_enable <= 0;
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
