`timescale 1ns / 1ps

module DC(
    input clk,
    input rst,
    input [7:0] cpu_output,
    output reg [3:0] AN,
    output wire [7:0] seg
);

    reg [15:0] clk_div;
    wire [1:0] display_selection;

    reg [3:0] display_bcd;
    reg dp;

    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] ones;

    reg [6:0] seg_pattern;

    // Convert 8-bit binary to decimal digits
    assign hundreds = cpu_output / 100;
    assign tens     = (cpu_output / 10) % 10;
    assign ones     = cpu_output % 10;

    // Refresh counter
    always @(posedge clk or posedge rst) begin
        if (rst)
            clk_div <= 16'd0;
        else
            clk_div <= clk_div + 1'b1;
    end

    assign display_selection = clk_div[15:14];

    // Select one digit at a time
    always @(*) begin
        display_bcd = 4'd0;
        dp = 1'b0;
        AN = 4'b1111;

        case (display_selection)
            2'd0: begin
                display_bcd = ones;
                AN = 4'b1110;
            end

            2'd1: begin
                display_bcd = tens;
                AN = 4'b1101;
            end

            2'd2: begin
                display_bcd = hundreds;
                AN = 4'b1011;
            end

            default: begin
                display_bcd = 4'd0;
                AN = 4'b1111;
            end
        endcase
    end

    // BCD to seven-segment decoding
    always @(*) begin
        case (display_bcd)
            4'd0: seg_pattern = 7'b1000000;
            4'd1: seg_pattern = 7'b1111001;
            4'd2: seg_pattern = 7'b0100100;
            4'd3: seg_pattern = 7'b0110000;
            4'd4: seg_pattern = 7'b0011001;
            4'd5: seg_pattern = 7'b0010010;
            4'd6: seg_pattern = 7'b0000010;
            4'd7: seg_pattern = 7'b1111000;
            4'd8: seg_pattern = 7'b0000000;
            4'd9: seg_pattern = 7'b0010000;
            default: seg_pattern = 7'b1111111;
        endcase
    end

    // Active-low decimal point and segment outputs
    assign seg[6:0] = seg_pattern;
    assign seg[7] = dp ? 1'b0 : 1'b1;

endmodule
