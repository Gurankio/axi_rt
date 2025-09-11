// Copyright 2023 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Authors:
// - Thomas Benz <tbenz@iis.ee.ethz.ch>
// - Jacopo Del Granchio <j.delgranchio@santannpisa.it>

`include "common_cells/registers.svh"
// `define DEBUG_AXI_WRITE_BUFFER // debug


module axi_write_buffer #(
    parameter int unsigned NumOutstanding = 32'd0,
    parameter int unsigned WBufferDepth   = 32'd0,
    parameter int unsigned IdxWWidth      = cf_math_pkg::idx_width(WBufferDepth),
    parameter int unsigned IdxAwWidth     = cf_math_pkg::idx_width(NumOutstanding),

    parameter type aw_chan_t  = logic,
    parameter type w_chan_t   = logic,
    parameter type axi_req_t  = logic,
    parameter type axi_resp_t = logic,

    // Dependent parameter, do **not** overwite!
    parameter type idx_w_t  = logic [ IdxWWidth-1:0],
    parameter type idx_aw_t = logic [IdxAwWidth-1:0]
) (
    input logic clk_i,
    input logic rst_ni,

    // Input / Slave Port
    input  axi_req_t  slv_req_i,
    output axi_resp_t slv_resp_o,

    // Output / Master Port
    output axi_req_t  mst_req_o,
    input  axi_resp_t mst_resp_i,

    // status
    output idx_w_t  num_w_stored_o,
    output idx_aw_t num_aw_stored_o
);
    // --------------------------------------------------
    // Bypass the B, AR, R channels
    // --------------------------------------------------
    assign mst_req_o.ar        = slv_req_i.ar;
    assign mst_req_o.ar_valid  = slv_req_i.ar_valid;
    assign slv_resp_o.ar_ready = mst_resp_i.ar_ready;

    assign slv_resp_o.r        = mst_resp_i.r;
    assign slv_resp_o.r_valid  = mst_resp_i.r_valid;
    assign mst_req_o.r_ready   = slv_req_i.r_ready;

    assign slv_resp_o.b        = mst_resp_i.b;
    assign slv_resp_o.b_valid  = mst_resp_i.b_valid;
    assign mst_req_o.b_ready   = slv_req_i.b_ready;

    // --------------------------------------------------
    // handle AW channel
    // --------------------------------------------------
    logic aw_pop, aw_not_empty, aw_not_full;
    stream_fifo #(
        .DEPTH(NumOutstanding),
        .T    (aw_chan_t)
    ) i_stream_fifo_aw (
        .clk_i,
        .rst_ni,
        .flush_i(1'b0),
        .testmode_i(1'b0),
        .usage_o(num_aw_stored_o),
        .data_i(slv_req_i.aw),
        .valid_i(slv_req_i.aw_valid & slv_resp_o.aw_ready),
        .ready_o(aw_not_full),  // = aw fifo is not full
        .data_o(mst_req_o.aw),
        .valid_o(aw_not_empty),  // = aw fifo is not empty
        .ready_i(aw_pop)  // = pop aw fifo
    );

    // --------------------------------------------------
    // buffer W channel
    // --------------------------------------------------
    logic w_pop, w_not_empty, w_not_full;
    stream_fifo #(
        .DEPTH     (WBufferDepth),
        .T         (w_chan_t),
        .ADDR_DEPTH(IdxWWidth)
    ) i_stream_fifo_w (
        .clk_i,
        .rst_ni,
        .flush_i   (1'b0),
        .testmode_i(1'b0),
        .usage_o   (num_w_stored_o),
        .data_i    (slv_req_i.w),
        .valid_i   (slv_req_i.w_valid & slv_resp_o.w_ready),
        .ready_o   (w_not_full),                              // = w fifo is not full
        .data_o    (mst_req_o.w),
        .valid_o   (w_not_empty),                             // = w fifo is not empty
        .ready_i   (w_pop)                                    // = pop w fifo
    );

    // --------------------------------------------------
    // handle W channel last queue
    // --------------------------------------------------
    logic last_pop, last_not_empty, last_not_full;
    idx_aw_t last_stored;

    logic last_valid_input;
    assign last_valid_input = slv_req_i.w.last && slv_req_i.w_valid && slv_resp_o.w_ready;

    stream_fifo #(
        .DEPTH(NumOutstanding),
        .T    (logic)
    ) i_stream_fifo (
        .clk_i,
        .rst_ni,
        .flush_i   (1'b0),
        .testmode_i(1'b0),
        .usage_o   (last_stored),
        .data_i    (1'b0),
        // If it is the last beat and it is valid.
        .valid_i   (last_valid_input),
        .ready_o   (last_not_full),
        .data_o    (  /* Not Used */),
        .valid_o   (last_not_empty),
        .ready_i   (last_pop)
    );

    // Allow inputs on AW and W if there is space in all queues.
    assign slv_resp_o.aw_ready = aw_not_full;
    assign slv_resp_o.w_ready  = w_not_full && last_not_full;

    // --------------------------------------------------
    // Sync FSM
    // --------------------------------------------------
    typedef enum logic [0:0] {
        WaitingInput,
        WaitingSync
    } state_e;

    state_e aw_state_q, aw_state_d;
    `FFARN(aw_state_q, aw_state_d, WaitingInput, clk_i, rst_ni);

    state_e w_state_q, w_state_d;
    `FFARN(w_state_q, w_state_d, WaitingInput, clk_i, rst_ni);

    logic aw_valid_d, w_valid_d;
    `FFARN(mst_req_o.aw_valid, aw_valid_d, WaitingInput, clk_i, rst_ni);
    `FFARN(mst_req_o.w_valid, w_valid_d, WaitingInput, clk_i, rst_ni);

    assign aw_pop = mst_req_o.aw_valid && mst_resp_i.aw_ready;
    assign w_pop = mst_req_o.w_valid && mst_resp_i.w_ready;
    assign last_pop = mst_req_o.w_valid && mst_req_o.w.last && mst_resp_i.w_ready;

    always_comb begin
        // AW channel
        aw_state_d = aw_state_q;
        aw_valid_d = 0;
        unique case (aw_state_q)
            WaitingInput: begin
                `ifdef DEBUG_AXI_WRITE_BUFFER
                $display("[AXI_WRBUF][%0t] AW: state is WaitingInput", $time);
                `endif
                // If we have a full transaction stored go ahead.
                if (last_not_empty) begin
                    aw_valid_d = 1;

                    `ifdef DEBUG_AXI_WRITE_BUFFER
                    $display("[AXI_WRBUF][%0t] AW: Ready to send. last_not_empty=%0b", $time, last_not_empty);
                    `endif

                    if (aw_pop) begin
                        aw_valid_d = 0;
                        `ifdef DEBUG_AXI_WRITE_BUFFER
                        $display("[AXI_WRBUF][%0t] AW: Pop, moving to WaitingSync", $time);
                        `endif

                        // if the burst is just 1 beat long, the state is kept to WaitingInput
                        // ELSE: normal transition to WaitingSync
                        if (last_pop) begin
                            if (last_stored > 1 | !last_not_full) begin // fill pointer or fifo is full
                                aw_valid_d = 1;
                            end
                            aw_state_d = WaitingInput; // explicit assignment
                        end
                        else begin
                            aw_state_d = WaitingSync;
                        end
                    end
                end
            end
            WaitingSync: begin
                $display("[AXI_WRBUF][%0t] AW: state is WaitingSync: last pop=%0b", $time, last_pop);
                if (last_pop) begin
                    `ifdef DEBUG_AXI_WRITE_BUFFER
                    $display("[AXI_WRBUF][%0t] AW: Last popped. last_stored=%0d, last_not_full=%0b", $time, last_stored, last_not_full);
                    `endif
                    if (last_stored > 1 | !last_not_full) begin // fill pointer or fifo is full
                        aw_valid_d = 1;
                    end
                    aw_state_d = WaitingInput;
                end
            end
        endcase

        // W channel
        w_state_d = w_state_q;
        w_valid_d = 0;
        unique case (w_state_q)
            WaitingInput: begin
                // If we have a full transaction stored go ahead.
                if (last_not_empty) begin
                    w_valid_d = 1;


                    `ifdef DEBUG_AXI_WRITE_BUFFER
                    $display("[AXI_WRBUF][%0t] W: Ready to send. last_not_empty=%0b", $time, last_not_empty);
                    `endif

                    // Skip to sync if downstream is already ready.
                    if (last_pop) begin
                        w_valid_d = 0;
                        w_state_d = WaitingSync;

                        `ifdef DEBUG_AXI_WRITE_BUFFER
                        $display("[AXI_WRBUF][%0t] W: Last popped. Transition to WaitingSync", $time);
                        `endif

                        if (aw_state_q == WaitingSync) begin
                            if (last_stored > 1 | !last_not_full) begin
                                w_valid_d = 1;
                            end
                            w_state_d = WaitingInput;
                        end
                    end
                end
            end
            WaitingSync: begin
                if (aw_state_q == WaitingSync) begin
                    if (last_not_empty) begin
                        w_valid_d = 1;
                    end
                    w_state_d = WaitingInput;

                    `ifdef DEBUG_AXI_WRITE_BUFFER
                    $display("[AXI_WRBUF][%0t] W: Sync complete. Back to WaitingInput", $time);
                    `endif
                end
            end
        endcase
    end
endmodule
