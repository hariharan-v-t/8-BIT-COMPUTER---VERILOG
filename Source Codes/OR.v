`timescale 1ns / 1ps
module OR(OUT,bus_in,clk,reset,OI);
output [7:0]OUT;
input clk,reset,OI;
input [7:0]bus_in;
reg [7:0] reg_out;
always @(posedge clk or posedge reset)
begin
if(reset)
reg_out<=8'b00000000;
else if(OI)
reg_out<=bus_in;
end
assign OUT = reg_out;
endmodule
