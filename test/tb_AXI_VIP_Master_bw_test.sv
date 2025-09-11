`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2017 11:12:04
// Design Name: 
// Module Name: tb_AXI_VIP_Master_bw_test
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
import axi_vip_pkg::*;
import dpu_bd_axi_vip_0_0_pkg::*; // FULL AXI MASTER
import dpu_bd_axi_vip_2_0_pkg::*; // FULL AXI MASTER
import dpu_bd_axi_vip_1_0_pkg::*; // FULL AXI SLAVE


// simulation parameters
xil_axi_uint test = 0; // 0: READ, 1:WRITE
// burst parameters
parameter unsigned n_bursts = 4;
parameter unsigned n_data_beats = 4;
parameter unsigned data_beats_size = 128;
// counter
xil_axi_uint counter = 0;

//AXI4 bus signals
xil_axi_uint                            mtestID;  
xil_axi_ulong                           mtestADDR;  
xil_axi_len_t                           mtestBurstLength;  
xil_axi_size_t                          mtestDataSize;   
xil_axi_burst_t                         mtestBurstType;   
xil_axi_lock_t                          mtestLOCK;  
xil_axi_cache_t                         mtestCacheType = 0;  
xil_axi_prot_t                          mtestProtectionType = 3'b000;  
xil_axi_region_t                        mtestRegion = 4'b000;  
xil_axi_qos_t                           mtestQOS = 4'b000;  
xil_axi_data_beat                       dbeat;  
xil_axi_data_beat [255:0]               mtestWUSER;   
xil_axi_user_beat                       mtestAWUSER = 'h0;  
xil_axi_data_beat                       mtestARUSER = 'h0;  
xil_axi_data_beat [255:0]               mtestRUSER;      
xil_axi_uint                            mtestBUSER;  
xil_axi_resp_t                          mtestBresp;  
xil_axi_resp_t[255:0]                   mtestRresp;  
bit [n_bursts*data_beats_size-1:0] mtestWDataBlock;
bit [n_bursts*data_beats_size-1:0] mtestRDataBlock = 32'h00000000;
bit [32767:0] mtestWDataBlock_large;
bit [32767:0] mtestRDataBlock_large = 0;

// thread 2
xil_axi_uint                            mtestID_2;  
xil_axi_ulong                           mtestADDR_2;  
xil_axi_len_t                           mtestBurstLength_2;  
xil_axi_size_t                          mtestDataSize_2;   
xil_axi_burst_t                         mtestBurstType_2;   
xil_axi_lock_t                          mtestLOCK_2;  
xil_axi_cache_t                         mtestCacheType_2 = 0;  
xil_axi_prot_t                          mtestProtectionType_2 = 3'b000;  
xil_axi_region_t                        mtestRegion_2 = 4'b000;  
xil_axi_qos_t                           mtestQOS_2 = 4'b000;  
xil_axi_data_beat                       dbea_2t;  
xil_axi_data_beat [255:0]               mtestWUSER_2;   
xil_axi_user_beat                       mtestAWUSER_2 = 'h0;  
xil_axi_data_beat                       mtestARUSER_2 = 'h0;  
xil_axi_data_beat [255:0]               mtestRUSER_2;      
xil_axi_uint                            mtestBUSER_2;  
xil_axi_resp_t                          mtestBresp_2;  
xil_axi_resp_t[255:0]                   mtestRresp_2;  
bit [n_bursts*data_beats_size-1:0] mtestWDataBlock_2;
bit [n_bursts*data_beats_size-1:0] mtestRDataBlock_2 = 32'h00000000;
bit [32767:0] mtestWDataBlock_large_2;
bit [32767:0] mtestRDataBlock_large_2 = 0;

// clk and rst
bit aclk = 0;
bit aresetn = 0;


module tb_AXI_VIP_Master_bw_test();

always #5ns aclk = ~aclk;

dpu_bd_wrapper DUT
(
    .aclk_0(aclk),
    .aresetn_0(aresetn)
);

// Declare agent
dpu_bd_axi_vip_0_0_mst_t      master_agent_ooo;
dpu_bd_axi_vip_2_0_mst_t      master_agent_ooo_noise;
dpu_bd_axi_vip_1_0_slv_mem_t slv_agent;

// setting bits at blocks of 128
genvar i;
generate
for (i=0; i<256; i++) begin : gen_loop
    assign mtestWDataBlock_large[i*128 +: 128] = i;
end
endgenerate

genvar z;
generate
for (z=0; z<256; z++) begin : gen_loop_2
    assign mtestWDataBlock_large_2[z*128 +: 128] = 255-z;
end
endgenerate

initial begin
    // axi_vip_0-1 (master and slave)
    // Thread 1
    // Create an agent
    master_agent_ooo = new("master vip agent",DUT.dpu_bd_i.axi_vip_0.inst.IF);
    master_agent_ooo_noise = new("master vip agent noise", DUT.dpu_bd_i.axi_vip_2.inst.IF);
    slv_agent = new("slave vip agent",DUT.dpu_bd_i.axi_vip_1.inst.IF);

    // set tag for agents for easy debug
    slv_agent.set_agent_tag("Slave VIP");
    master_agent_ooo.set_agent_tag("Master VIP ooo");
    master_agent_ooo_noise.set_agent_tag("Master VIP ooo noise");

    // set print out verbosity level.
    master_agent_ooo.set_verbosity(400);
    master_agent_ooo_noise.set_verbosity(400);

    //Start the agent
    slv_agent.start_slave();
    master_agent_ooo.start_master();
    master_agent_ooo_noise.start_master();

    // reset
    aresetn = 0; 
    #250ns  
    aresetn = 1;
    #50ns

    /* --------------------- THREAD 1 INIT --------------------- */
    mtestID = 0; 
    mtestADDR = 32'h44A00000;
    
    /* AxLEN[7:0] = # of beats in a transfer, minus one. (0 = 1 beat, 1 = 2 beats ... 255 = 256 beats, the max allowed.) */
    mtestBurstLength = 255; // number of the data beats in a single AXI burst +1
    
    /* AxSIZE[2:0] = size of a beat, as 2^n (0 = 1 byte, 1 = 2 bytes, 2 = 4 bytes, 3 = 8 bytes... 7 = 128 bytes)*/
    mtestDataSize = xil_axi_size_t'(xil_clog2(128/8)); // maximum number of bytes to transfer in each data transfer 1,2,4,8...128 bytes per transfer
    
    /*XIL_AXI_BURST_TYPE_INCR: the address is incremented of +DataSize for the subsequent transfer*/
    /*XIL_AXI_BURST_TYPE_FIXED: the address is fixed*/
    mtestBurstType = XIL_AXI_BURST_TYPE_INCR;  
    
    /* The address of the transactions are not locked */
    mtestLOCK = XIL_AXI_ALOCK_NOLOCK; // the transaction is not locked
    mtestCacheType = 0;  
    mtestProtectionType = 0;  
    mtestRegion = 0; 
    mtestQOS = 0; 

    /* --------------------- THREAD 2 INIT --------------------- */
    mtestID_2 = 0; 
    mtestADDR_2 = 32'h44A00000;
    
    /* AxLEN[7:0] = # of beats in a transfer, minus one. (0 = 1 beat, 1 = 2 beats ... 255 = 256 beats, the max allowed.) */
    mtestBurstLength_2 = 255; // number of the data beats in a single AXI burst +1
    
    /* AxSIZE[2:0] = size of a beat, as 2^n (0 = 1 byte, 1 = 2 bytes, 2 = 4 bytes, 3 = 8 bytes... 7 = 128 bytes)*/
    mtestDataSize_2 = xil_axi_size_t'(xil_clog2(128/8)); // maximum number of bytes to transfer in each data transfer 1,2,4,8...128 bytes per transfer
    
    /*XIL_AXI_BURST_TYPE_INCR: the address is incremented of +DataSize for the subsequent transfer*/
    /*XIL_AXI_BURST_TYPE_FIXED: the address is fixed*/
    mtestBurstType_2 = XIL_AXI_BURST_TYPE_INCR;  
    
    /* The address of the transactions are not locked */
    mtestLOCK_2 = XIL_AXI_ALOCK_NOLOCK; // the transaction is not locked
    mtestCacheType_2 = 0;  
    mtestProtectionType_2 = 0;  
    mtestRegion_2 = 0; 
    mtestQOS_2 = 0; 

    // writing data
    master_agent_ooo.AXI4_WRITE_BURST(
    mtestID,
    mtestADDR,
    mtestBurstLength,
    mtestDataSize,
    mtestBurstType,
    mtestLOCK,
    mtestCacheType,
    mtestProtectionType,
    mtestRegion,
    mtestQOS,
    mtestAWUSER,
    mtestWDataBlock_large,
    mtestWUSER,
    mtestBresp);

    #10000ns

    // fork
    fork
        // axi vip_1
        if (test == 1) begin
            master_agent_ooo.AXI4_WRITE_BURST(
            mtestID,
            mtestADDR,
            mtestBurstLength,
            mtestDataSize,
            mtestBurstType,
            mtestLOCK,
            mtestCacheType,
            mtestProtectionType,
            mtestRegion,
            mtestQOS,
            mtestAWUSER,
            mtestWDataBlock_large,
            mtestWUSER,
            mtestBresp);
        end
        else begin
            master_agent_ooo.AXI4_READ_BURST ( 
                mtestID, 
                mtestADDR, 
                mtestBurstLength, 
                mtestDataSize, 
                mtestBurstType, 
                mtestLOCK, 
                mtestCacheType, 
                mtestProtectionType, 
                mtestRegion, 
                mtestQOS, 
                mtestAWUSER, // ARUSER = AWUSER
                mtestRDataBlock_large, 
                mtestRresp, 
                mtestWUSER);
        end

        // axi_vip_2 (noise)
        begin
        if (test == 1) begin
            master_agent_ooo_noise.AXI4_WRITE_BURST(
                mtestID_2,
                mtestADDR_2,
                mtestBurstLength_2,
                mtestDataSize_2,
                mtestBurstType_2,
                mtestLOCK_2,
                mtestCacheType_2,
                mtestProtectionType_2,
                mtestRegion_2,
                mtestQOS_2,
                mtestAWUSER_2,
                mtestWDataBlock_large_2,
                mtestWUSER_2,
                mtestBresp_2);
        end
        else begin
            master_agent_ooo_noise.AXI4_READ_BURST ( 
                mtestID_2, 
                mtestADDR_2, 
                mtestBurstLength_2, 
                mtestDataSize_2, 
                mtestBurstType_2, 
                mtestLOCK_2, 
                mtestCacheType_2, 
                mtestProtectionType_2, 
                mtestRegion_2, 
                mtestQOS_2, 
                mtestAWUSER_2, // ARUSER = AWUSER
                mtestRDataBlock_large_2, 
                mtestRresp_2, 
                mtestWUSER_2);
        end
        end
    join

    if (mtestRDataBlock_large == mtestWDataBlock_large) begin
        $display("DATA match on master #0");
    end
    else begin
        $display("DATA do not match on master #0");
    end  

    $display("Finishing Simulation...");
    $finish;
end
endmodule
