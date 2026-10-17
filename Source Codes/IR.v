`timescale 1ns / 1ps

module IR(bus_out,opcode,bus_in,clk,reset,II,IO);
input clk;
input reset;
input II,IO;
input [7:0] bus_in;
output [3:0] opcode;
output [7:0] bus_out;
reg [7:0] reg_ir;
always @(posedge clk or posedge reset) begin
if (reset)
reg_ir <= 8'b0;
else if (II)
reg_ir <= bus_in;
end
assign opcode = reg_ir[7:4];
assign bus_out = IO?{4'b0000,reg_ir[3:0]}:8'bz;
endmodule