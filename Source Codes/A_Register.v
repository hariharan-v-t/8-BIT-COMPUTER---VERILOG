`timescale 1ns / 1ps
module A_Register(bus_out,ALU_in,clk,reset,AI,AO,bus_in);
output [7:0] bus_out;
output [7:0] ALU_in;
input clk,AI,AO,reset;
input [7:0] bus_in;
reg [7:0] reg_a;
always @(posedge clk or posedge reset) begin
if (reset)
reg_a<=8'b00000000;
else if(AI)
reg_a<=bus_in;
end
assign ALU_in = reg_a;
assign bus_out = AO?reg_a:8'bz;

endmodule
