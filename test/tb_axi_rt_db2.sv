`timescale 1ns / 1ps

// Import required packages: axi_vip_pkg and <component_name>_pkg.
import axi_vip_pkg::*;
import design_2_axi_vip_2_0_pkg::*;
import design_2_axi_vip_3_0_pkg::*;
import design_2_axi_vip_4_0_pkg::*;
import axi_rt_reg_pkg::*;

module tb_axi_rt_bd2 ();

    reg aclk = 0;
    reg aresetn;

    reg start = 0;
    reg stop = 0;

    design_2_wrapper DUT (
        .aclk(aclk),
        .aresetn(aresetn),
        .core_ext_start(start),
        .core_ext_stop(stop)
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

    // Declare the agent
    design_2_axi_vip_2_0_slv_mem_t slv1;
    design_2_axi_vip_3_0_slv_mem_t slv2;
    design_2_axi_vip_4_0_mst_t cfg0;

    // Input wires
    xil_axi_resp_t axi_bresp;

    initial begin
        // Create an agent
        cfg0 = new("config vip agent 4", DUT.design_2_i.axi_vip_4.inst.IF);
        slv1 = new("slave vip agent 2", DUT.design_2_i.axi_vip_2.inst.IF);
        slv2 = new("slave vip agent 3", DUT.design_2_i.axi_vip_3.inst.IF);

        // Set print out verbosity level
        cfg0.set_verbosity(200);
        slv1.set_verbosity(200);
        slv2.set_verbosity(200);

        // Start the agent
        cfg0.start_master();
        slv1.start_slave();
        slv2.start_slave();

        // Actually do tests.

        // Lock bus.
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              32'h00000004,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(0),  // Data Size (2^0) 1 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              3'b111,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );

        // Length limit affects burst splitting.
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_LEN_LIMIT_0_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h0,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );

        // Set region
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_END_ADDR_SUB_HIGH_0_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'hFFFFFFFF,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_END_ADDR_SUB_LOW_0_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'hFFFFFFFF,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );

        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_START_ADDR_SUB_HIGH_0_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h00000000,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_START_ADDR_SUB_LOW_0_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h00000000,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );

        // Set budget
        // *reg32(&__base_axirt, AXI_RT_WRITE_BUDGET_0_REG_OFFSET + AXI_RT_PARAM_NUM_SUB * mgr_id * 4 +
        //                           region_id * 4) = budget;
        // *reg32(&__base_axirt, AXI_RT_READ_BUDGET_0_REG_OFFSET + AXI_RT_PARAM_NUM_SUB * mgr_id * 4 +
        //                           region_id * 4) = budget;
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_WRITE_BUDGET_0_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h0000001F,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_READ_BUDGET_0_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h0000001F,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );

        // Set period
        //  *reg32(&__base_axirt, AXI_RT_WRITE_PERIOD_0_REG_OFFSET + AXI_RT_PARAM_NUM_SUB * mgr_id * 4 +
        //                           region_id * 4) = period;
        // *reg32(&__base_axirt, AXI_RT_READ_PERIOD_0_REG_OFFSET + AXI_RT_PARAM_NUM_SUB * mgr_id * 4 +
        //                           region_id * 4) = period;
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_WRITE_PERIOD_0_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h00000080,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_READ_PERIOD_0_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h00000080,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );

        // Set region 1
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_END_ADDR_SUB_HIGH_1_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'hFFFFFFFF,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_END_ADDR_SUB_LOW_1_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'hFFFFFFFF,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );

        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_START_ADDR_SUB_HIGH_1_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h00000000,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_START_ADDR_SUB_LOW_1_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h00000000,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );

        // Set budget
        // *reg32(&__base_axirt, AXI_RT_WRITE_BUDGET_0_REG_OFFSET + AXI_RT_PARAM_NUM_SUB * mgr_id * 4 +
        //                           region_id * 4) = budget;
        // *reg32(&__base_axirt, AXI_RT_READ_BUDGET_0_REG_OFFSET + AXI_RT_PARAM_NUM_SUB * mgr_id * 4 +
        //                           region_id * 4) = budget;
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_WRITE_BUDGET_1_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h0000000F,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_READ_BUDGET_1_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h0000000F,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );

        // Set period
        //  *reg32(&__base_axirt, AXI_RT_WRITE_PERIOD_0_REG_OFFSET + AXI_RT_PARAM_NUM_SUB * mgr_id * 4 +
        //                           region_id * 4) = period;
        // *reg32(&__base_axirt, AXI_RT_READ_PERIOD_0_REG_OFFSET + AXI_RT_PARAM_NUM_SUB * mgr_id * 4 +
        //                           region_id * 4) = period;
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_WRITE_PERIOD_1_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h00000080,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_READ_PERIOD_1_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              32'h00000080,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );


        // Enable
        // *reg32(&__base_axirt, AXI_RT_RT_ENABLE_REG_OFFSET) = enable;
        // *reg32(&__base_axirt, AXI_RT_IMTU_ENABLE_REG_OFFSET) = enable;
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_RT_ENABLE_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              'b11,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );
        cfg0.AXI4_WRITE_BURST(0,  // Id
                              AXI_RT_IMTU_ENABLE_OFFSET,  // Address
                              0,  // Lenght (remember + 1)
                              xil_axi_size_t'(2),  // Data Size (2^2) 4 byte
                              XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                              XIL_AXI_ALOCK_NOLOCK,  // Lock
                              0,  // CacheType
                              0,  // ProtectionType
                              0,  // Region
                              0,  // QOS
                              0,  // AwUser
                              'b11,  // WDataBlock
                              0,  // WUser
                              axi_bresp  // Bresp
        );


        // Start traffic generators.
        start <= 1;
        #100us;
        start <= 1;
        #50ns;
        stop <= 1;
        #10us;
        stop <= 0;
        $finish();
    end
endmodule
