`timescale 1ns / 1ps
//==================================================
// TOP MODULE: 8-BIT CPU + 7-SEGMENT DISPLAY + FLAGS
//==================================================
module CPU_Display_Top (
    input  wire        clk,
    input  wire [15:0] sw,
    input  wire [3:0]  btn,

    output wire [3:0]  D0_AN,
    output wire [7:0]  D0_SEG,
    output wire [1:0]  LED
);

    // CPU output and flags
    wire [7:0] cpu_output;
    wire carry;
    wire zero;

    wire reset;

    // Button 0 resets the CPU and display scanner
    assign reset = btn[0];

    // LED[0] = Carry flag
    // LED[1] = Zero flag
    assign LED[0] = carry;
    assign LED[1] = zero;

    //==================================================
    // YOUR EXISTING CPU
    // Program is loaded from hram.mem
    // SW[7:0] provides the live INP value
    //==================================================
    Top_Module U_CPU (
        .data_out   (cpu_output),
        .carry      (carry),
        .zero       (zero),
        .clk        (clk),
        .reset      (reset),

        // RAM manual loading disabled
        .load       (1'b0),
        .in_address (4'b0000),
        .in_data    (8'b00000000),

        // External input for INP instruction
        .for_in     (sw[7:0])
    );

    //==================================================
    // SEVEN-SEGMENT DISPLAY
    // Shows cpu_output as decimal 000 to 255
    //==================================================
    Boolean_Display U_DISPLAY (
        .clk   (clk),
        .reset (reset),
        .value (cpu_output),
        .an    (D0_AN),
        .seg   (D0_SEG)
    );

endmodule


//==================================================
// 8-BIT BINARY TO 3 DECIMAL DIGITS
//==================================================
module Binary_To_Decimal (
    input  wire [7:0] value,
    output wire [3:0] hundreds,
    output wire [3:0] tens,
    output wire [3:0] ones
);

    assign hundreds = value / 100;
    assign tens     = (value / 10) % 10;
    assign ones     = value % 10;

endmodule


//==================================================
// SEVEN-SEGMENT DECODER
// Active-low outputs
// seg[0] = a
// seg[1] = b
// seg[2] = c
// seg[3] = d
// seg[4] = e
// seg[5] = f
// seg[6] = g
// seg[7] = decimal point
//==================================================
module Decimal_To_7Seg (
    input  wire [3:0] digit,
    output reg  [7:0] seg
);

    always @(*) begin
        case (digit)
            4'd0: seg = 8'b11000000;
            4'd1: seg = 8'b11111001;
            4'd2: seg = 8'b10100100;
            4'd3: seg = 8'b10110000;
            4'd4: seg = 8'b10011001;
            4'd5: seg = 8'b10010010;
            4'd6: seg = 8'b10000010;
            4'd7: seg = 8'b11111000;
            4'd8: seg = 8'b10000000;
            4'd9: seg = 8'b10010000;

            default: seg = 8'b11111111;
        endcase
    end

endmodule


//==================================================
// THREE-DIGIT DISPLAY SCANNER
// D0 digit 0 = ones
// D0 digit 1 = tens
// D0 digit 2 = hundreds
// D0 digit 3 = OFF
//==================================================
module Boolean_Display #(
    parameter integer CLOCKS_PER_DIGIT = 100000
) (
    input  wire       clk,
    input  wire       reset,
    input  wire [7:0] value,

    output reg  [3:0] an,
    output wire [7:0] seg
);

    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] ones;

    reg [16:0] refresh_count;
    reg [1:0] digit_select;
    reg [3:0] current_digit;

    // Convert binary output into decimal digits
    Binary_To_Decimal U_CONVERT (
        .value    (value),
        .hundreds (hundreds),
        .tens     (tens),
        .ones     (ones)
    );

    // Display refresh counter
    // Assumes a 100 MHz input clock
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_count <= 0;
            digit_select  <= 0;
        end
        else if (refresh_count >= CLOCKS_PER_DIGIT - 1) begin
            refresh_count <= 0;

            if (digit_select == 2)
                digit_select <= 0;
            else
                digit_select <= digit_select + 1'b1;
        end
        else begin
            refresh_count <= refresh_count + 1'b1;
        end
    end

    // Select one decimal digit at a time
    // Digit enable signals are active-low
    always @(*) begin
        an = 4'b1111;
        current_digit = 4'd0;

        case (digit_select)

            2'd0: begin
                an = 4'b1110;
                current_digit = ones;
            end

            2'd1: begin
                an = 4'b1101;
                current_digit = tens;
            end

            2'd2: begin
                an = 4'b1011;
                current_digit = hundreds;
            end

            default: begin
                an = 4'b1111;
                current_digit = 4'd0;
            end

        endcase
    end

    // Convert selected digit to segment pattern
    Decimal_To_7Seg U_DECODE (
        .digit (current_digit),
        .seg   (seg)
    );

endmodule