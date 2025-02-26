`timescale 1ns / 1ps

// Import required packages: axi_vip_pkg and <component_name>_pkg.
import axi_vip_pkg::*;
import tbd_axi_rt_device_port_axi_vip_0_0_pkg::*;
import tbd_axi_rt_device_port_axi_vip_1_0_pkg::*;
import axi_rt_reg_pkg::*;

module tb_axi_rt_device_port();
    reg aclk = 0;
    reg aresetn = 0;

    reg [7:0] limit_0 = 'd0;
    reg [7:0] limit_1 = 'd0;

    // Remember to multilpy by AXI_DATA_WIDTH
    reg [15:0] r_period = 'd22;
    reg [15:0] r_budget = 'd29;
    reg [15:0] w_period = 'd22;
    reg [15:0] w_budget = 'd29;

    reg [0:0] enable = 0;

    reg traffic_start = 0;
    reg traffic_stop = 0;

    tbd_axi_rt_device_port_wrapper DUT (
        .clock(aclk),
        .aresetn(aresetn),

        .len_limit_0_0(limit_0),
        .len_limit_1_0(limit_1),
        .r_budget_0(r_budget),
        .w_budget_0(w_budget),
        .period_0(r_period),
        .enable_0(enable),

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
    tbd_axi_rt_device_port_axi_vip_0_0_passthrough_t ver1;
    tbd_axi_rt_device_port_axi_vip_1_0_passthrough_t ver2;
 
    initial begin
        // Create an agent
        ver1 = new("pst vip agent 0", DUT.tbd_axi_rt_device_port_i.axi_vip_0.inst.IF);
        ver2 = new("pst vip agent 1", DUT.tbd_axi_rt_device_port_i.axi_vip_1.inst.IF);

        // Set print out verbosity level
        ver1.set_verbosity(200);
        ver2.set_verbosity(200);
     
        // Actually do tests.

        #325ns;
        enable <= '1;
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
