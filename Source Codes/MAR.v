`timescale 1ns / 1ps
module MAR(mar_out,clk,reset,MI,bus_in);
output reg [3:0] mar_out;
input clk,reset,MI;
input [3:0]bus_in;
always @(posedge clk or posedge reset) begin
if (reset)
mar_out <= 4'b0000;
else if (MI)
mar_out <= bus_in;
end
endmodule
