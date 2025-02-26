module axi_lat_monitor #(
    parameter DATA_WIDTH = 'd64,
    parameter ADDR_WIDTH = 'd48,
    parameter ID_WIDTH   = 'd16
) (
    input                    axi_aclk,
    input                    axi_aresetn,
    input [    ID_WIDTH-1:0] axi_awid,
    input [  ADDR_WIDTH-1:0] axi_awaddr,
    input [             2:0] axi_awprot,
    input [             7:0] axi_awlen,
    input [             2:0] axi_awsize,
    input [             1:0] axi_awburst,
    input [             3:0] axi_awcache,
    input                    axi_awlock,
    input                    axi_awvalid,
    input                    axi_awready,
    input [  DATA_WIDTH-1:0] axi_wdata,
    input [DATA_WIDTH/8-1:0] axi_wstrb,
    input                    axi_wlast,
    input                    axi_wvalid,
    input                    axi_wready,
    input [    ID_WIDTH-1:0] axi_bid,
    input [             1:0] axi_bresp,
    input                    axi_bvalid,
    input                    axi_bready,
    input [    ID_WIDTH-1:0] axi_arid,
    input [  ADDR_WIDTH-1:0] axi_araddr,
    input [             7:0] axi_arlen,
    input [             2:0] axi_arsize,
    input [             1:0] axi_arburst,
    input [             3:0] axi_arcache,
    input [             2:0] axi_arprot,
    input                    axi_arlock,
    input                    axi_arvalid,
    input                    axi_arready,
    input [    ID_WIDTH-1:0] axi_rid,
    input [  DATA_WIDTH-1:0] axi_rdata,
    input [             1:0] axi_rresp,
    input                    axi_rlast,
    input                    axi_rvalid,
    input                    axi_rready
);

    // Declare a variable to store the file handler
    integer fd;

    initial begin
        fd = $fopen("startend.csv", "w");
        $fwrite(fd, "start, accept, first, last, end, beats\n");
    end

    time aw_start_log[0:1024-1];
    reg [10-1:0] aw_start_ai = 0;

    integer aw_beats_log[0:1024-1];
    reg [10-1:0] aw_beats_ai = 0;

    time aw_accept_log[0:1024-1];
    reg [10-1:0] aw_accept_ai = 0;

    time w_first_log[0:1024-1];
    reg [10-1:0] w_first_ai = 0;

    time w_last_log[0:1024-1];
    reg [10-1:0] w_last_ai = 0;

    reg [10-1:0] pi = 0;
    reg aw_was_valid = 0;
    reg aw_was_ready = 0;
    reg w_was_last = 1;

    always @(posedge axi_aclk) begin
        if (!aw_was_valid & axi_awvalid | aw_was_valid & aw_was_ready & axi_awvalid) begin
            aw_start_log[aw_start_ai] = $time();
            aw_start_ai = aw_start_ai + 1;

            aw_beats_log[aw_beats_ai] = axi_awlen + 1;
            aw_beats_ai = aw_beats_ai + 1;
        end

        if (axi_awvalid & axi_awready) begin
            aw_accept_log[aw_accept_ai] = $time();
            aw_accept_ai = aw_accept_ai + 1;
        end

        if (w_was_last & axi_wvalid) begin
            w_first_log[w_first_ai] = $time();
            w_first_ai = w_first_ai + 1;
            w_was_last = 0;
        end
        
        if (axi_wlast & axi_wvalid & axi_wready) begin
            w_last_log[w_last_ai] = $time();
            w_last_ai = w_last_ai + 1;
        end

        if (axi_bvalid & axi_bready) begin
            $fwrite(fd, aw_start_log[pi]);
            $fwrite(fd, ",");
            $fwrite(fd, aw_accept_log[pi]);
            $fwrite(fd, ",");
            $fwrite(fd, w_first_log[pi]);
            $fwrite(fd, ",");
            $fwrite(fd, w_last_log[pi]);
            $fwrite(fd, ",");
            $fwrite(fd, $time());
            $fwrite(fd, ",");
            $fwrite(fd, aw_beats_log[pi]);
            $fwrite(fd, "\n");
//            $fflush(fd);
            pi = pi + 1;
        end

        aw_was_valid = axi_awvalid;
        aw_was_ready = axi_awready;

        if (axi_wlast & axi_wvalid & axi_wready) begin
            w_was_last = 1;
        end
    end
endmodule
