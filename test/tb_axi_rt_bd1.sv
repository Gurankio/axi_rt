`timescale 1ns / 1ps

// Import required packages: axi_vip_pkg and <component_name>_pkg.
import axi_vip_pkg::*;
import design_1_axi_vip_0_0_pkg::*;
import design_1_axi_vip_1_0_pkg::*;
import design_1_axi_vip_2_0_pkg::*;
import design_1_axi_vip_3_0_pkg::*;
import design_1_axi_vip_4_0_pkg::*;
import axi_rt_reg_pkg::*;

module tb_axi_rt_bd1 ();

    reg aclk = 0;
    reg aresetn;

    design_1_wrapper DUT (
        .aclk(aclk),
        .aresetn(aresetn)
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
    design_1_axi_vip_0_0_mst_t mst0;
    design_1_axi_vip_1_0_mst_t mst1;
    design_1_axi_vip_2_0_slv_mem_t slv2;
    design_1_axi_vip_3_0_slv_mem_t slv3;
    design_1_axi_vip_4_0_mst_t cfg4;

    // Input wires
    xil_axi_resp_t axi_bresp;

    integer i;

    initial begin
        // Create an agent
        mst0 = new("master vip agent 0", DUT.design_1_i.axi_vip_0.inst.IF);
        mst1 = new("master vip agent 1", DUT.design_1_i.axi_vip_1.inst.IF);
        slv2 = new("slave vip agent 2", DUT.design_1_i.axi_vip_2.inst.IF);
        slv3 = new("slave vip agent 3", DUT.design_1_i.axi_vip_3.inst.IF);
        cfg4 = new("config vip agent 4", DUT.design_1_i.axi_vip_4.inst.IF);

        // Set print out verbosity level
        mst0.set_verbosity(400);
        mst1.set_verbosity(400);
        slv2.set_verbosity(400);
        slv3.set_verbosity(400);
        cfg4.set_verbosity(400);

        // Start the agent
        mst0.start_master();
        mst1.start_master();
        slv2.start_slave();
        slv3.start_slave();
        cfg4.start_master();

        // Actually do tests.

        // Lock bus.
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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

        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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

        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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
        cfg4.AXI4_WRITE_BURST(0,  // Id
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

        fork
        begin
            for (i = 0; i < 256; i++)
            begin
                mst0.AXI4_WRITE_BURST(0,  // Id
                                    32'h0000BEEF,  // Address
                                    0,  // Lenght (remember + 1)
                                    xil_axi_size_t'(3),  // Data Size (2^3) 8 byte
                                    XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                                    XIL_AXI_ALOCK_NOLOCK,  // Lock
                                    0,  // CacheType
                                    0,  // ProtectionType
                                    0,  // Region
                                    0,  // QOS
                                    0,  // AwUser
                                    64'hABCDEF00ABCDEF00,  // WDataBlock
                                    0,  // WUser
                                    axi_bresp  // Bresp
                );
            end
        end
        begin
            for (i = 0; i < 256; i++)
            begin
                mst1.AXI4_WRITE_BURST(0,  // Id
                                    32'hDEAD0000,  // Address
                                    0,  // Lenght (remember + 1)
                                    xil_axi_size_t'(3),  // Data Size (2^3) 8 byte
                                    XIL_AXI_BURST_TYPE_FIXED,  // BurstType
                                    XIL_AXI_ALOCK_NOLOCK,  // Lock
                                    0,  // CacheType
                                    0,  // ProtectionType
                                    0,  // Region
                                    0,  // QOS
                                    0,  // AwUser
                                    64'h1234567812345678,  // WDataBlock
                                    0,  // WUser
                                    axi_bresp  // Bresp
                );
            end
        end
        join
    end
endmodule
