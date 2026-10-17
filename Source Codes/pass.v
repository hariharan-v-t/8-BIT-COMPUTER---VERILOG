`timescale 1ns / 1ps

module Pass (
    input clk,
    input reset,
    input [3:0] password_switches,
    input enter,
    output reg auth_ok,
    output locked
);

    parameter [3:0] PASSWORD = 4'b1010;

    reg enter_meta;
    reg enter_sync;
    reg enter_prev;

    // Synchronize the Enter button to the FPGA clock
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            enter_meta <= 1'b0;
            enter_sync <= 1'b0;
            enter_prev <= 1'b0;
        end
        else begin
            enter_meta <= enter;
            enter_sync <= enter_meta;
            enter_prev <= enter_sync;
        end
    end

    // Check the password when Enter is pressed
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            auth_ok <= 1'b0;
        end
        else if (enter_sync && !enter_prev) begin
            if (password_switches == PASSWORD)
                auth_ok <= 1'b1;
            else
                auth_ok <= 1'b0;
        end
    end

    assign locked = ~auth_ok;

endmodule