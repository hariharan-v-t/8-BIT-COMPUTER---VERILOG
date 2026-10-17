`timescale 1ns / 1ps
module B_Register(bus_in,ALU_in,clk,reset,BI);
output [7:0] ALU_in;
input  [7:0] bus_in;
input clk,reset,BI;
reg [7:0] reg_b;
always @(posedge clk or posedge reset) begin
if (reset)
reg_b <= 8'b0;
else if (BI)
reg_b <= bus_in;
end
assign ALU_in = reg_b;
endmodule
